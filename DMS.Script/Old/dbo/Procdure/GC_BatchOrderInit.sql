DROP Procedure [dbo].[GC_BatchOrderInit]
GO

/*
订单导入
*/
CREATE Procedure [dbo].[GC_BatchOrderInit]
    @UserId uniqueidentifier,
    @ImportType NVARCHAR(20),   --导入类型：分为二级、平台及一级
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
    
AS
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

	Declare @DealerID uniqueidentifier
	Declare @DealerType nvarchar(5)
	DECLARE @m_DmaId uniqueidentifier
	DECLARE @m_ProductLine uniqueidentifier
	DECLARE @m_Id uniqueidentifier
	DECLARE @m_OrderNo nvarchar(50)

--创建临时表
create table #mmbo_PurchaseOrderHeader (
   POH_ID               uniqueidentifier     not null,
   POH_OrderNo          nvarchar(30)         collate Chinese_PRC_CI_AS null,
   POH_ProductLine_BUM_ID uniqueidentifier     null,
   POH_DMA_ID           uniqueidentifier     null,
   POH_VendorID         nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_TerritoryCode    nvarchar(200)        null,
   POH_RDD              datetime             null,
   POH_ContactPerson    nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_Contact          nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_ContactMobile    nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_Consignee        nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_ShipToAddress    nvarchar(200)        collate Chinese_PRC_CI_AS null,
   POH_ConsigneePhone   nvarchar(200)        collate Chinese_PRC_CI_AS null,
   POH_Remark           nvarchar(400)        collate Chinese_PRC_CI_AS null,
   POH_InvoiceComment   nvarchar(200)        collate Chinese_PRC_CI_AS null,
   POH_CreateType       nvarchar(20)         collate Chinese_PRC_CI_AS not null,
   POH_CreateUser       uniqueidentifier     not null,
   POH_CreateDate       datetime             not null,
   POH_UpdateUser       uniqueidentifier     null,
   POH_UpdateDate       datetime             null,
   POH_SubmitUser       uniqueidentifier     null,
   POH_SubmitDate       datetime             null,
   POH_LastBrowseUser   uniqueidentifier     null,
   POH_LastBrowseDate   datetime             null,
   POH_OrderStatus      nvarchar(20)         collate Chinese_PRC_CI_AS not null,
   POH_LatestAuditDate  datetime             null,
   POH_IsLocked         bit                  not null,
   POH_SAP_OrderNo      nvarchar(50)         collate Chinese_PRC_CI_AS null,
   POH_SAP_ConfirmDate  datetime             null,
   POH_LastVersion      int                  not null,
   POH_OrderType        nvarchar(20)         collate Chinese_PRC_CI_AS null,
   POH_VirtualDC        nvarchar(50)         collate Chinese_PRC_CI_AS null,
   POH_SpecialPriceID   uniqueidentifier     null,
   POH_WHM_ID           uniqueidentifier     null,
   POH_POH_ID           uniqueidentifier     null,
   primary key (POH_ID)
)

create table #mmbo_PurchaseOrderDetail (
   POD_ID               uniqueidentifier     not null,
   POD_POH_ID           uniqueidentifier     not null,
   POD_CFN_ID           uniqueidentifier     not null,
   POD_CFN_Price        decimal(18,6)        null,
   POD_UOM              nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POD_RequiredQty      decimal(18,6)        null,
   POD_Amount           decimal(18,6)        null,
   POD_Tax              decimal(18,6)        null,
   POD_ReceiptQty       decimal(18,6)        null,
   POD_Status           nvarchar(50)         collate Chinese_PRC_CI_AS null,
   POD_LotNumber		    nvarchar(50)		     collate Chinese_PRC_CI_AS null,
   POD_CurRegNo nvarchar(500)    collate Chinese_PRC_CI_AS NULL,
   POD_CurValidDateFrom datetime NULL,
   POD_CurValidDataTo datetime NULL,
   POD_CurManuName nvarchar(500) collate Chinese_PRC_CI_AS NULL,
   POD_LastRegNo nvarchar(500) collate Chinese_PRC_CI_AS NULL,
   POD_LastValidDateFrom datetime NULL,
   POD_LastValidDataTo datetime NULL,
   POD_LastManuName nvarchar(500) collate Chinese_PRC_CI_AS NULL,
   POD_CurGMKind nvarchar(200) collate Chinese_PRC_CI_AS NULL,
   POD_CurGMCatalog nvarchar(200) collate Chinese_PRC_CI_AS NULL,
    primary key (POD_ID)
)

		/*先将错误标志设为0*/
		UPDATE BatchOrderInit SET [BOI_ErrorFlag] = 0,BOI_ArticleNumber_ErrMsg = null WHERE BOI_USER = @UserId

		--检查经销商是否存在
		UPDATE BatchOrderInit SET BOI_ErrorFlag = 1, BOI_SAP_Code_ErrMsg =  N'经销商不存在'
		where BOI_USER=@UserId and NOT  EXISTS (select 1 from DealerMaster a inner join BatchOrderInit b on  
		BOI_SAP_Code = DMA_SAP_Code where b.BOI_USER=@UserId
		)
		--获取经销商
		 
		--select BOI_DMA_ID=dma_id from DealerMaster where DMA_SAP_Code=DMA_SAP_Code 
		--update By HuaKaichun 产品结构调整
		--update BatchOrderInit 
		--set BOI_ErrorFlag = 1, BOI_OrderType_ErrMsg = N'订单类型必须为寄售订单'
		--where BOI_USER = @UserId and BOI_OrderType not in('寄售订单')


		--检查单据类型是否正确
		update BatchOrderInit
		set BOI_OrderTypeName = 'Consignment' 
		where BOI_USER = @UserId	
		   


--一级经销商和物流平台只能导入普通订单和交接订单
--二级经销商只能导入普通订单、寄售订单

IF (@DealerType = 'LP') 
  BEGIN
    UPDATE BatchOrderInit SET BOI_ErrorFlag = 1, BOI_OrderType_ErrMsg =  N'单据类型不正确,二级经销商只能导入普通及寄售订单'
     WHERE BOI_USER = @UserId
       and BOI_OrderTypeName NOT in ('Consignment')
      and BOI_OrderTypeName is null
       
  END


		--检查产品是否存在
		UPDATE BatchOrderInit SET BOI_CFN_ID = CFN_ID
		FROM CFN WHERE CFN_CustomerFaceNbr = BOI_ArticleNumber
		AND BOI_USER = @UserId

		UPDATE BatchOrderInit SET BOI_ErrorFlag = 1, BOI_ArticleNumber_ErrMsg = N'产品不存在,'
		WHERE BOI_CFN_ID IS NULL AND BOI_USER = @UserId AND BOI_ArticleNumber_ErrMsg IS NULL

		--更新产品线ID
		UPDATE BOI SET BOI_BUM_ID = v.Id
		FROM BatchOrderInit BOI inner join View_ProductLine v on v.ATTRIBUTE_NAME= BOI.BOI_ProductLine
		WHERE v.ATTRIBUTE_TYPE='Product_Line'
		AND BOI_USER = @UserId 
		--更新经销商编号

		UPDATE BOI SET BOI_DMA_ID=d.DMA_ID
		FROM BatchOrderInit BOI inner join DealerMaster d on d.DMA_SAP_Code = BOI.BOI_SAP_Code
		AND BOI_USER = @UserId 
		--更新产品CFNID
		UPDATE BatchOrderInit SET BOI_CFN_ID = CFN_ID
		FROM CFN WHERE CFN_CustomerFaceNbr = BOI_ArticleNumber
		AND BOI_USER = @UserId

		UPDATE BatchOrderInit SET BOI_ErrorFlag = 1, BOI_ArticleNumber_ErrMsg =  N'产品未分类(无对应产品线),'
		WHERE BOI_BUM_ID IS NULL AND BOI_USER = @UserId AND BOI_ArticleNumber_ErrMsg IS NULL

		--检查产品是否可以下定（根据单据类型获取价格类型）
		UPDATE BatchOrderInit SET BOI_ErrorFlag = 1, BOI_ArticleNumber_ErrMsg = N'产品未授权或未维护价格,'
		WHERE BOI_CFN_ID IS  NULL 
		AND BOI_USER = @UserId 
		AND BOI_ArticleNumber_ErrMsg IS NULL

		--检查产品是否存在  
		UPDATE BatchOrderInit SET BOI_CFN_ID = CFN_ID
		FROM CFN WHERE CFN_CustomerFaceNbr = BOI_ArticleNumber
		AND BOI_USER = @UserId

		UPDATE BatchOrderInit SET BOI_ErrorFlag = 1, BOI_ArticleNumber_ErrMsg = N'产品不存在,'
		WHERE BOI_CFN_ID IS NULL AND BOI_USER = @UserId AND BOI_ArticleNumber_ErrMsg IS NULL

		--Add by SongWeiming对于二级经销商需要填写产品线，根据共享产品来判断产品是否可以选择对应的产品线

		--填写的产品线是否正确
		UPDATE BatchOrderInit SET  BOI_ErrorFlag = 1, BOI_ProductLine_ErrMsg =  N'填写的产品线不存在或填写的产品线不正确'
		WHERE BOI_USER = @UserId
		and NOT Exists (select 1 from Lafite_ATTRIBUTE where ATTRIBUTE_TYPE='Product_Line' and ATTRIBUTE_NAME = BatchOrderInit.BOI_ProductLine)

		--产品线是否有授权
		update BatchOrderInit SET  BOI_ErrorFlag = 1, BOI_ProductLine_ErrMsg =  N'没有设定此产品线的授权'
		WHERE BOI_USER = @UserId
		AND BOI_ProductLine_ErrMsg is null
		AND NOT EXISTS 
		(
		SELECT 1 FROM DealerAuthorizationTable 
		WHERE DAT_DMA_ID = BatchOrderInit.BOI_DMA_ID
		AND DAT_ProductLine_BUM_ID = BatchOrderInit.BOI_BUM_ID
		AND DAT_Type IN ('Normal','Temp','Order')
		)--没有值

		UPDATE BatchOrderInit SET BOI_ErrorFlag = 1, BOI_ArticleNumber_ErrMsg = N'产品未授权,'
		WHERE BOI_USER = @UserId
		AND dbo.GC_Fn_CFN_CheckDealerAuth(BOI_DMA_ID,BOI_CFN_ID) = 0
		AND BOI_ArticleNumber_ErrMsg IS NULL

		--最后校验 如果有错误消息 返回error
		UPDATE BatchOrderInit SET BOI_ErrorFlag = 1
		WHERE BOI_USER = @UserId
		AND (BOI_ArticleNumber_ErrMsg IS NOT NULL OR BOI_LotNumber_ErrMsg IS NOT NULL OR BOI_OrderType_ErrMsg IS NOT NULL OR BOI_RequiredQty_ErrMsg IS NOT NULL)


--检查是否存在错误
IF (SELECT COUNT(*) FROM BatchOrderInit WHERE BOI_ErrorFlag = 1 AND BOI_USER = @UserId) > 0  
	BEGIN
		/*如果存在错误，则返回Error*/
		SET @IsValid = 'Error'
	END
ELSE
	BEGIN
		/*如果不存在错误，则返回Success*/		
		SET @IsValid = 'Success'
	
    
    
    
  
  IF @ImportType = 'Import'
		BEGIN
	--插入临时订单主表
	
			insert into #mmbo_PurchaseOrderHeader (POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_OrderType,POH_CreateType,
			POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_TerritoryCode,POH_SubmitDate,POH_VirtualDC)
			select newid(),a.BOI_BUM_ID,a.BOI_DMA_ID,a.BOI_OrderTypeName,'Manual',a.BOI_USER,getdate(),'Submitted',0,0,a.BOI_TerritoryCode,GETDATE(),
      (select VDC_Plant from VirtualDC where VDC_DMA_ID=BOI_DMA_ID and VDC_BUM_ID=BOI_BUM_ID) AS VirtualDC
			from (select DISTINCT BOI_USER,BOI_BUM_ID,BOI_DMA_ID,BOI_TerritoryCode,BOI_OrderTypeName
			from BatchOrderInit where BOI_USER = @UserId) a  
			
			
 

		--更新联系人和收货信息
		update a set POH_ContactPerson=DST_ContactPerson
		,POH_Contact=DST_Contact
		,POH_ContactMobile=DST_ContactMobile
		,POH_Consignee=DST_Consignee
		,POH_ConsigneePhone=DST_ConsigneePhone
		from #mmbo_PurchaseOrderHeader a 
		inner join DealerShipTo b  on a.POH_DMA_ID=b.DST_Dealer_DMA_ID
		where ISNULL( DST_ContactPerson,'')<>''


		--更新承运商
		Update #mmbo_PurchaseOrderHeader set POH_TerritoryCode = DMA_Certification
		FROM DealerMaster where DMA_ID = POH_DMA_ID

		--更新仓库
		Update #mmbo_PurchaseOrderHeader set POH_WHM_ID=a.WHM_ID
		from Warehouse a where  a.WHM_DMA_ID= POH_DMA_ID and  a.WHM_Type='Borrow'

		--更新收货地址
		Update #mmbo_PurchaseOrderHeader set POH_ShipToAddress =  SWA_WH_Address
		from SAPWarehouseAddress  a where POH_DMA_ID=a.SWA_DMA_ID 



         
--插入临时订单明细表 其他订单不需要按照LotNumber汇总
insert into #mmbo_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_RequiredQty,
			   POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM,
         POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,
         POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
			select newid(),POH_ID,BOI_CFN_ID,BOI_RequiredQty,0,0,BOI_LotNumber,CFN_UOM,
         REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
         REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
			from(
			select b.POH_ID,a.BOI_CFN_ID,a.BOI_RequiredQty,a.BOI_LotNumber,0 as CFN_UOM
			from (select BOI_USER,BOI_OrderTypeName,BOI_CFN_ID,BOI_BUM_ID,BOI_DMA_ID,BOI_LotNumber,sum(convert(decimal(8,2),BOI_RequiredQty)) as BOI_RequiredQty 
			        from BatchOrderInit 
             where BOI_OrderTypeName in('Consignment') 
				AND BOI_USER = @UserId 
             group by BOI_USER,BOI_OrderTypeName,BOI_CFN_ID,BOI_BUM_ID,BOI_DMA_ID,BOI_LotNumber) as a, 
			#mmbo_PurchaseOrderHeader as b,Lafite_DICT AS Dict
			where a.BOI_USER = b.POH_CreateUser
			and a.BOI_BUM_ID = b.POH_ProductLine_BUM_ID
			and a.BOI_DMA_ID = b.POH_DMA_ID			
			and a.BOI_OrderTypeName = b.POH_OrderType
					
      and Dict.DICT_TYPE = N'CONST_Order_Type'
            
      AND Dict.Dict_Key = a.BOI_OrderTypeName
      ) as c
		
        inner join cfn on (c.BOI_CFN_ID  = CFN.cfn_ID) 
        LEFT join MD.V_INF_UPN_REG AS REG ON (cfn.CFN_CustomerFaceNbr = REG.CurUPN)

			
			
   --更新单价，总金额，产品单位
	--select  CFNP_Price 
	update t3 set t3.POD_CFN_Price = isnull(t1.CFNP_Price,0), t3.POD_Amount = Convert(decimal(18,6),isnull(t3.POD_RequiredQty,0) * isnull(t1.CFNP_Price,0)),t3.POD_UOM=t4.CFN_Property3
	from cfnprice t1, #mmbo_PurchaseOrderHeader t2, #mmbo_PurchaseOrderDetail t3,cfn t4
	where t2.POH_ID = t3.POD_POH_ID and cfnp_group_id= t2.POH_DMA_ID 
	and CFNP_CFN_ID =t3.POD_CFN_ID
	and CFNP_PriceType='Dealer'
	and t3.POD_CFN_ID=t4.CFN_ID
    
    
   
    
    
 ---更新订单编号
    DECLARE  curHandleOrderNo CURSOR
    FOR SELECT POH_ID,POH_DMA_ID,POH_ProductLine_BUM_ID FROM #mmbo_PurchaseOrderHeader
    OPEN curHandleOrderNo
    FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine
    WHILE @@FETCH_STATUS = 0
    BEGIN
       EXEC dbo.[GC_GetNextAutoNumberForPO] @m_DmaId,'Next_PurchaseOrder',@m_ProductLine,'Consignment', @m_OrderNo output
		UPDATE #mmbo_PurchaseOrderHeader SET POH_OrderNo = @m_OrderNo+'90L' ,POH_Remark= @m_OrderNo+'90L'+'(短效发货)' WHERE POH_ID = @m_Id
       FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_ProductLine
    END
    CLOSE curHandleOrderNo
    DEALLOCATE curHandleOrderNo
    
    
    --插入订单主表
			--insert into PurchaseOrderHeader 
			--select * from #mmbo_PurchaseOrderHeader
    
    
			insert into PurchaseOrderHeader(POH_ID,
											POH_OrderNo,
											POH_ProductLine_BUM_ID,
											POH_DMA_ID,
											POH_VendorID,
											POH_TerritoryCode,
											POH_RDD,
											POH_ContactPerson,
											POH_Contact,
											POH_ContactMobile,
											POH_Consignee,
											POH_ShipToAddress,
											POH_ConsigneePhone,
											POH_Remark,
											POH_InvoiceComment,
											POH_CreateType,
											POH_CreateUser,
											POH_CreateDate,
											POH_UpdateUser,
											POH_UpdateDate,
											POH_SubmitUser,
											POH_SubmitDate,
											POH_LastBrowseUser,
											POH_LastBrowseDate,
											POH_OrderStatus,
											POH_LatestAuditDate,
											POH_IsLocked,
											POH_SAP_OrderNo,
											POH_SAP_ConfirmDate,
											POH_LastVersion,
											POH_OrderType,
											POH_VirtualDC,
											POH_SpecialPriceID,
											POH_WHM_ID,
											POH_POH_ID)
											select POH_ID,
											POH_OrderNo,
											POH_ProductLine_BUM_ID,
											POH_DMA_ID,
											POH_VendorID,
											POH_TerritoryCode,
											POH_RDD,
											POH_ContactPerson,
											POH_Contact,
											POH_ContactMobile,
											POH_Consignee,
											POH_ShipToAddress,
											POH_ConsigneePhone,
											POH_Remark,
											POH_InvoiceComment,
											POH_CreateType,
											POH_CreateUser,
											POH_CreateDate,
											POH_UpdateUser,
											POH_UpdateDate,
											POH_SubmitUser,
											POH_SubmitDate,
											POH_LastBrowseUser,
											POH_LastBrowseDate,
											POH_OrderStatus,
											POH_LatestAuditDate,
											POH_IsLocked,
											POH_SAP_OrderNo,
											POH_SAP_ConfirmDate,
											POH_LastVersion,
											POH_OrderType,
											POH_VirtualDC,
											POH_SpecialPriceID,
											POH_WHM_ID,
											POH_POH_ID FROM #mmbo_PurchaseOrderHeader

			

--插入订单明细表

    insert into PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
			POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM,
      POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog) 
			select POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
			POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM,POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog
      from #mmbo_PurchaseOrderDetail

           
			
			

			--插入订单操作日志
			INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
			SELECT NEWID(),POH_ID,POH_CreateUser,GETDATE(),'ExcelImport',NULL FROM #mmbo_PurchaseOrderHeader
			
			--清除中间表的数据
			DELETE FROM BatchOrderInit WHERE	BOI_USER = @UserId
			
			INSERT INTO PurchaseOrderInterface(POI_ID,POI_BatchNbr,POI_RecordNbr,POI_POH_ID
			,POI_POH_OrderNo,POI_Status,POI_ProcessType,POI_CreateUser,POI_CreateDate,
			POI_UpdateUser,POI_UpdateDate,POI_ClientID)
			SELECT NEWID(), '','',POH_ID,POH_OrderNo,'Pending','Manual','00000000-0000-0000-0000-000000000000',
			GETDATE(),'00000000-0000-0000-0000-000000000000',GETDATE(),'EAI' 
			FROM #mmbo_PurchaseOrderHeader 
			
		END
		
				
		
			
end

COMMIT TRAN

SET NOCOUNT OFF
return 1
END TRY
BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
    return -1
    
END CATCH







GO


