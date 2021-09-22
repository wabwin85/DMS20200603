DROP procedure [dbo].[GC_Interface_ProcessRunner_PurchaseOrder]
GO

CREATE procedure [dbo].[GC_Interface_ProcessRunner_PurchaseOrder](
	@HeaderID uniqueidentifier,
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
)
as
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

	Declare @Count int --明细数 
	Declare @OrderNo nvarchar(50) --明细数 

	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	--获取订单相关信息
	SELECT  @Count = COUNT(*),@OrderNo = POH_OrderNo
	FROM PurchaseOrderHeader,PurchaseOrderDetail
	WHERE POH_ID = POD_POH_ID
	AND POH_ID = @HeaderID
	group by POH_OrderNo
	
	--统计订单中明细数，如果只有一条明细，则往T_I_ProcessRunner_PurchaseOrderInterface插入两条明细
	--如果大于一条明细，则往T_I_ProcessRunner_PurchaseOrderInterface插入对应行数的记录
	--T_I_ProcessRunner_PurchaseOrderInterface的主信息只在记录第一条明细时保存，其他时候为空
	
	IF(@Count = 1)
	BEGIN
		INSERT INTO Interface.T_I_ProcessRunner_PurchaseOrderInterface
		SELECT NEWID(),POH_OrderNo,'Processing',REV1,CASE WHEN DivisionName = 'CRM' then 'CN50' else 'CN10' end, 
		'00','00',POH_OrderNo,case when isnull(POH_RDD,'') = '' then Convert(nvarchar(8),dateadd(day,7,GETDATE()),112) else Convert(nvarchar(8),dateadd(day,7,POH_RDD),112) end,'DMS','','CS','021-61415941','','','','Z018',POH_Remark,'AG',DMA_SAP_Code,
		10 ,CFN_CustomerFaceNbr,ISNULL(POD_LotNumber,''),POD_RequiredQty,  ''   ,  ''  ,case when POD_CFN_Price = CFNP_Price then '' else 10 end ,case when POD_CFN_Price = CFNP_Price then '' else 'ZMAP' end,case when POD_CFN_Price = CFNP_Price then '' else Convert(nvarchar(18),POD_CFN_Price/1.16) end,
    case when POD_CFN_Price = CFNP_Price then '' 
         else
             Case When (SELECT count(*) from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate) >0 
                 then (SELECT top 1 DC_Currency from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate)
                 ELSE 'CNY' 
            END               
         end
    ,case when POD_CFN_Price = CFNP_Price then '' else '1' end, case when POD_CFN_Price = CFNP_Price then '' else 'EA' end,GETDATE(),null
		FROM PurchaseOrderHeader
		inner join PurchaseOrderDetail on POH_ID = POD_POH_ID
		inner join Lafite_DICT on POH_OrderType = DICT_KEY and DICT_TYPE='CONST_Order_Type'
		inner join V_DivisionProductLineRelation on POH_ProductLine_BUM_ID = ProductLineID
		inner join DealerMaster on POH_DMA_ID = DMA_ID
		inner join CFN on POD_CFN_ID = CFN_ID
		inner join CFNPrice on CFN.CFN_ID = CFNP_CFN_ID
			AND POH_DMA_ID = CFNP_Group_ID
			AND CFNP_PriceType = 'DealerConsignment'
		WHERE REV1 = 'KE'
		AND POH_ID = @HeaderID
		
		INSERT INTO Interface.T_I_ProcessRunner_PurchaseOrderInterface
		SELECT NEWID(),POH_OrderNo,'Processing',REV1,CASE WHEN DivisionName = 'CRM' then 'CN50' else 'CN10' end, 
		'00','00',POH_OrderNo,case when isnull(POH_RDD,'') = '' then Convert(nvarchar(8),dateadd(day,7,GETDATE()),112) else Convert(nvarchar(8),dateadd(day,7,POH_RDD),112) end,'DMS','','CS','021-61415941','','','','Z018',POH_Remark,'AG',DMA_SAP_Code,
		10 ,CFN_CustomerFaceNbr,ISNULL(POD_LotNumber,''),POD_RequiredQty,
		CASE WHEN REV1 ='ZRB' THEN 'D838' ELSE  '' end ,
		CASE WHEN REV1 ='ZRB' THEN '0002' ELSE  '' END ,
		case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else 10 end end,
		case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else 'ZMAP' end end,
		case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else Convert(nvarchar(18),POD_CFN_Price/1.16) end end,
		case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else     
    Case When (SELECT count(*) from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate) >0 
                 then (SELECT top 1 DC_Currency from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate)
                 ELSE 'CNY' 
            END   
    end end,
		case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else  '1' end end, 
		case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else  'EA' end end,GETDATE(),null
		FROM PurchaseOrderHeader
		inner join PurchaseOrderDetail on POH_ID = POD_POH_ID
		inner join Lafite_DICT on POH_OrderType = DICT_KEY
		inner join V_DivisionProductLineRelation on POH_ProductLine_BUM_ID = ProductLineID
		inner join DealerMaster on POH_DMA_ID = DMA_ID
		inner join CFN on POD_CFN_ID = CFN_ID
		--left join SAPWarehouseAddress on DMA_ID = SWA_DMA_ID
		left join CFNPrice on CFN.CFN_ID = CFNP_CFN_ID
			AND POH_DMA_ID = CFNP_Group_ID
			AND CFNP_PriceType = 'Dealer'
		WHERE  DICT_TYPE='CONST_Order_Type'
		AND REV1 <> 'KE'		
		AND POH_ID = @HeaderID
		
		--INSERT INTO Interface.T_I_ProcessRunner_PurchaseOrderInterface
		--SELECT NEWID(),POH_OrderNo,'Processing','','', 
		--'','','','','','','','','','','','','','WE',SWA_WH_Code,
		--'','','','','','','','','','','','',GETDATE(),null
		--FROM PurchaseOrderHeader,SAPWarehouseAddress
		--WHERE POH_DMA_ID = SWA_DMA_ID
		--AND POH_ID = @HeaderID
	END
	ELSE
	BEGIN
		--生成单据号
		DECLARE @m_PodId uniqueidentifier
		DECLARE @m_RowNum int

		DECLARE	curHandleOrderNo CURSOR 
		FOR SELECT POD_ID,ROW_NUMBER() OVER(ORDER BY POD_ID) FROM PurchaseOrderDetail
		where pod_poh_id =@HeaderID

		OPEN curHandleOrderNo
		FETCH NEXT FROM curHandleOrderNo INTO @m_PodId,@m_RowNum

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF(@m_RowNum = 1)
			BEGIN				
				INSERT INTO Interface.T_I_ProcessRunner_PurchaseOrderInterface
				SELECT NEWID(),POH_OrderNo,'Processing',REV1,CASE WHEN DivisionName = 'CRM' then 'CN50' else 'CN10' end, 
				'00','00',POH_OrderNo,case when isnull(POH_RDD,'') = '' then Convert(nvarchar(8),dateadd(day,7,GETDATE()),112) else Convert(nvarchar(8),dateadd(day,7,POH_RDD),112) end,'DMS','','CS','021-61415941','','','','Z018',POH_Remark,'AG',DMA_SAP_Code,
				@m_RowNum*10 ,CFN_CustomerFaceNbr,ISNULL(POD_LotNumber,''),POD_RequiredQty,  ''  ,  ''  , case when POD_CFN_Price = CFNP_Price then '' else 10 end ,case when POD_CFN_Price = CFNP_Price then '' else 'ZMAP' end,case when POD_CFN_Price = CFNP_Price then '' else Convert(nvarchar(18),POD_CFN_Price/1.16) end, 
        case when POD_CFN_Price = CFNP_Price then '' 
             else
             Case When (SELECT count(*) from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate) >0 
                 then (SELECT top 1 DC_Currency from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate)
                 ELSE 'CNY' 
             END 
        end,
        case when POD_CFN_Price = CFNP_Price then '' else '1' end, case when POD_CFN_Price = CFNP_Price then '' else 'EA' end,GETDATE(),null
				FROM PurchaseOrderHeader
				inner join PurchaseOrderDetail on POH_ID = POD_POH_ID
				inner join Lafite_DICT on POH_OrderType = DICT_KEY and DICT_TYPE='CONST_Order_Type'
				inner join V_DivisionProductLineRelation on POH_ProductLine_BUM_ID = ProductLineID
				inner join DealerMaster on POH_DMA_ID = DMA_ID
				inner join CFN on POD_CFN_ID = CFN_ID
				inner join CFNPrice on CFN.CFN_ID = CFNP_CFN_ID
					AND POH_DMA_ID = CFNP_Group_ID
					AND CFNP_PriceType = 'DealerConsignment'
				WHERE REV1 = 'KE'
				AND POD_ID = @m_PodId
		
				INSERT INTO Interface.T_I_ProcessRunner_PurchaseOrderInterface
				SELECT NEWID(),POH_OrderNo,'Processing',REV1,CASE WHEN DivisionName = 'CRM' then 'CN50' else 'CN10' end, 
				'00','00',POH_OrderNo,case when isnull(POH_RDD,'') = '' then Convert(nvarchar(8),dateadd(day,7,GETDATE()),112) else Convert(nvarchar(8),dateadd(day,7,POH_RDD),112) end,'DMS','','CS','021-61415941','','','','Z018',POH_Remark,'AG',DMA_SAP_Code,
				@m_RowNum*10 ,CFN_CustomerFaceNbr,ISNULL(POD_LotNumber,''),POD_RequiredQty,
				CASE WHEN REV1 ='ZRB' THEN 'D838' ELSE  '' end ,
				CASE WHEN REV1 ='ZRB' THEN '0002' ELSE  '' END ,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else 10 end end ,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else 'ZMAP' end end,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else Convert(nvarchar(18),POD_CFN_Price/1.16) end end,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else        
        Case When (SELECT count(*) from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate) >0 
                 then (SELECT top 1 DC_Currency from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate)
                 ELSE 'CNY' 
            END
        end end,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else  '1' end end, 
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else  'EA' end end,GETDATE(),null
				FROM PurchaseOrderHeader
				inner join PurchaseOrderDetail on POH_ID = POD_POH_ID
				inner join Lafite_DICT on POH_OrderType = DICT_KEY
				inner join V_DivisionProductLineRelation on POH_ProductLine_BUM_ID = ProductLineID
				inner join DealerMaster on POH_DMA_ID = DMA_ID
				inner join CFN on POD_CFN_ID = CFN_ID
				--left join SAPWarehouseAddress on DMA_ID = SWA_DMA_ID
				left join CFNPrice on CFN.CFN_ID = CFNP_CFN_ID
					AND POH_DMA_ID = CFNP_Group_ID
					AND CFNP_PriceType = 'Dealer'
				WHERE  DICT_TYPE='CONST_Order_Type'
				AND REV1 <> 'KE'		
				AND POD_ID = @m_PodId
			END
			ELSE IF (@m_RowNum = 2)
			BEGIN
				INSERT INTO Interface.T_I_ProcessRunner_PurchaseOrderInterface
				SELECT NEWID(),POH_OrderNo,'Processing','','', 
				'','','','','','','','','','','','','','WE',max(SWA_WH_Code),
				@m_RowNum*10 ,CFN_CustomerFaceNbr,ISNULL(POD_LotNumber,''),POD_RequiredQty,
				 ''  , ''  ,case when POD_CFN_Price = CFNP_Price then '' else @m_RowNum*10 end ,
				case when POD_CFN_Price = CFNP_Price then '' else 'ZMAP' end,
				case when POD_CFN_Price = CFNP_Price then '' else Convert(nvarchar(18),POD_CFN_Price/1.16) end,
				case when POD_CFN_Price = CFNP_Price then '' else 
        
        Case When (SELECT count(*) from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate) >0 
                 then (SELECT top 1 DC_Currency from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate)
                 ELSE 'CNY' 
            END 
        
        end,
				case when POD_CFN_Price = CFNP_Price then '' else '1' end, 
				case when POD_CFN_Price = CFNP_Price then '' else 'EA' end
				,GETDATE(),null
				FROM PurchaseOrderHeader
				inner join PurchaseOrderDetail on POH_ID = POD_POH_ID
				inner join Lafite_DICT on POH_OrderType = DICT_KEY and DICT_TYPE='CONST_Order_Type'
				inner join V_DivisionProductLineRelation on POH_ProductLine_BUM_ID = ProductLineID
				inner join DealerMaster on POH_DMA_ID = DMA_ID
				left join SAPWarehouseAddress on DMA_ID = SWA_DMA_ID
				inner join CFN on POD_CFN_ID = CFN_ID
				inner join CFNPrice on CFN.CFN_ID = CFNP_CFN_ID
					AND POH_DMA_ID = CFNP_Group_ID
					AND CFNP_PriceType = 'DealerConsignment'
				WHERE REV1 = 'KE'
				AND POD_ID = @m_PodId
				group by POH_OrderNo,CFN_CustomerFaceNbr,POD_LotNumber,POD_RequiredQty,POD_CFN_Price,CFNP_Price,DealerMaster.DMA_ID
				
				INSERT INTO Interface.T_I_ProcessRunner_PurchaseOrderInterface
				SELECT NEWID(),POH_OrderNo,'Processing','','', 
				'','','','','','','','','','','','','','','',
				@m_RowNum*10 ,CFN_CustomerFaceNbr,ISNULL(POD_LotNumber,''),POD_RequiredQty,
				CASE WHEN REV1 ='ZRB' THEN 'D838' ELSE  '' end ,
				CASE WHEN REV1 ='ZRB' THEN '0002' ELSE  '' END ,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else @m_RowNum*10 end end,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else 'ZMAP' end end,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else Convert(nvarchar(18),POD_CFN_Price/1.16) end end,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else 
        Case When (SELECT count(*) from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate) >0 
                 then (SELECT top 1 DC_Currency from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate)
                 ELSE 'CNY' 
            END 
        end end,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else  '1' end end, 
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else  'EA' end end
				,GETDATE(),null
				FROM PurchaseOrderHeader
				inner join PurchaseOrderDetail on POH_ID = POD_POH_ID
				inner join Lafite_DICT on POH_OrderType = DICT_KEY
				inner join V_DivisionProductLineRelation on POH_ProductLine_BUM_ID = ProductLineID
				inner join DealerMaster on POH_DMA_ID = DMA_ID
				inner join CFN on POD_CFN_ID = CFN_ID
				--left join SAPWarehouseAddress on DMA_ID = SWA_DMA_ID
				left join CFNPrice on CFN.CFN_ID = CFNP_CFN_ID
					AND POH_DMA_ID = CFNP_Group_ID
					AND CFNP_PriceType = 'Dealer'
				WHERE  DICT_TYPE='CONST_Order_Type'
				AND REV1 <> 'KE'		
				AND POD_ID = @m_PodId
			END
			ELSE
			BEGIN
				INSERT INTO Interface.T_I_ProcessRunner_PurchaseOrderInterface
				SELECT NEWID(),POH_OrderNo,'Processing','','', 
				'','','','','','','','','','','','','','','',
				@m_RowNum*10 ,CFN_CustomerFaceNbr,ISNULL(POD_LotNumber,''),POD_RequiredQty,
				 ''  , '' , case when POD_CFN_Price = CFNP_Price then '' else @m_RowNum*10 end ,
				case when POD_CFN_Price = CFNP_Price then '' else 'ZMAP' end,
				case when POD_CFN_Price = CFNP_Price then '' else Convert(nvarchar(18),POD_CFN_Price/1.16) end,
				case when POD_CFN_Price = CFNP_Price then '' else 
        Case When (SELECT count(*) from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate) >0 
                 then (SELECT top 1 DC_Currency from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate)
                 ELSE 'CNY' 
            END 
        end,
				case when POD_CFN_Price = CFNP_Price then '' else '1' end, 
				case when POD_CFN_Price = CFNP_Price then '' else 'EA' end
				,GETDATE(),null
				FROM PurchaseOrderHeader
				inner join PurchaseOrderDetail on POH_ID = POD_POH_ID
				inner join Lafite_DICT on POH_OrderType = DICT_KEY and DICT_TYPE='CONST_Order_Type'
				inner join V_DivisionProductLineRelation on POH_ProductLine_BUM_ID = ProductLineID
				inner join DealerMaster on POH_DMA_ID = DMA_ID
				inner join CFN on POD_CFN_ID = CFN_ID
				inner join CFNPrice on CFN.CFN_ID = CFNP_CFN_ID
					AND POH_DMA_ID = CFNP_Group_ID
					AND CFNP_PriceType = 'DealerConsignment'
				WHERE REV1 = 'KE'
				AND POD_ID = @m_PodId
				
				INSERT INTO Interface.T_I_ProcessRunner_PurchaseOrderInterface
				SELECT NEWID(),POH_OrderNo,'Processing','','', 
				'','','','','','','','','','','','','','','',
				@m_RowNum*10 ,CFN_CustomerFaceNbr,ISNULL(POD_LotNumber,''),POD_RequiredQty,
				CASE WHEN REV1 ='ZRB' THEN 'D838' ELSE  '' end ,
				CASE WHEN REV1 ='ZRB' THEN '0002' ELSE  '' END ,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else @m_RowNum*10 end end,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else 'ZMAP' end end,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else Convert(nvarchar(18),POD_CFN_Price/1.16) end end,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else 
        Case When (SELECT count(*) from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate) >0 
                 then (SELECT top 1 DC_Currency from DealerCurrency where DC_DMA_ID = DealerMaster.DMA_ID and getdate() >= DC_BeginDate and getdate()<= DC_EndDate)
                 ELSE 'CNY' 
            END 
        end end,
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else  '1' end end, 
				case when REV1 = 'ZRB' then '' else case when POD_CFN_Price = CFNP_Price then '' else  'EA' end end
				,GETDATE(),null
				FROM PurchaseOrderHeader
				inner join PurchaseOrderDetail on POH_ID = POD_POH_ID
				inner join Lafite_DICT on POH_OrderType = DICT_KEY
				inner join V_DivisionProductLineRelation on POH_ProductLine_BUM_ID = ProductLineID
				inner join DealerMaster on POH_DMA_ID = DMA_ID
				inner join CFN on POD_CFN_ID = CFN_ID
				left join CFNPrice on CFN.CFN_ID = CFNP_CFN_ID
					AND POH_DMA_ID = CFNP_Group_ID
					AND CFNP_PriceType = 'Dealer'
				WHERE  DICT_TYPE='CONST_Order_Type'
				AND REV1 <> 'KE'		
				AND POD_ID = @m_PodId
			END
			
			FETCH NEXT FROM curHandleOrderNo INTO @m_PodId,@m_RowNum
		END

		CLOSE curHandleOrderNo
		DEALLOCATE curHandleOrderNo
		
	END
		
		UPDATE Interface.T_I_ProcessRunner_PurchaseOrderInterface 
       SET OrderReason = 'F04'
		WHERE SalesDocumentType = 'ZRB'
       AND POI_OrderNo = @OrderNo

		--OR数据处理
		UPDATE Interface.T_I_ProcessRunner_PurchaseOrderInterface
		   SET OrderReason = 'X01'
		WHERE  SalesDocumentType = 'OR'
		   AND POI_OrderNo = @OrderNo

		--KE订单处理
		UPDATE Interface.T_I_ProcessRunner_PurchaseOrderInterface
		   SET OrderReason = 'B32'
		WHERE  SalesDocumentType = 'KE'
		   AND POI_OrderNo = @OrderNo

		UPDATE Interface.T_I_ProcessRunner_PurchaseOrderInterface
		   SET Quantity = SUBSTRING(Quantity,1,LEN(Quantity) - 3) 
		WHERE  POI_OrderNo = @OrderNo
		AND Quantity <> ''
		
		UPDATE Interface.T_I_ProcessRunner_PurchaseOrderInterface
		   SET ConditionValue = SUBSTRING(ConditionValue,1,CHARINDEX('.',ConditionValue) +2)
		WHERE  POI_OrderNo = @OrderNo
		AND ConditionValue <> ''
		
		UPDATE Interface.T_I_ProcessRunner_PurchaseOrderInterface
		   SET SalesDocumentType = 'TA'
		WHERE  POI_OrderNo = @OrderNo
		AND SalesDocumentType = 'OR'
	
		UPDATE Interface.T_I_ProcessRunner_PurchaseOrderInterface 
       SET ConditionItemNumber =''
		WHERE ConditionItemNumber ='0'
       AND POI_OrderNo = @OrderNo
	   
	   UPDATE Interface.T_I_ProcessRunner_PurchaseOrderInterface 
       SET ConditionType = null,
           ConditionValue = null,	
           Currency = null,	
           ConditionUnit = null,	
           ConditionPricingUnit = null
		WHERE POI_OrderNo = @OrderNo
		  AND Exists (SELECT 1 FROM PurchaseOrderHeader where POH_ID =@HeaderID and POH_OrderType in ('ConsignmentReturn','ZTKA','ZTKB') )
       
	   --更新ZTKA、KA订单的Plant
       UPDATE PR SET PR.Plant = CP.Plant
		from Interface.T_I_ProcessRunner_PurchaseOrderInterface PR, interface.View_Stage_SAP_ConsignmentBatchAndPlant CP, PurchaseOrderHeader PH, DealerMaster DM
		where PR.POI_OrderNo = PH.POH_OrderNo and PH.POH_DMA_ID = DM.DMA_ID
		and CP.Material = PR.Material and  CP.Batch = PR.Batch  and CP.CustomerNumber = DM.DMA_SAP_Code
		and PH.POH_ID=@HeaderID and PH.POH_OrderType in ('ConsignmentReturn','ZTKA','ZTKB')
		AND PR.POI_OrderNo = @OrderNo
  
COMMIT TRAN	
	
SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
	
	--记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '2行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH
GO


