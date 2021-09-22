DROP PROCEDURE [dbo].[GC_HospitalShipmentBSC_BeforeSubmit]
GO


/*
 *医院销售单提交前检查
 *Add By SongWeiming on 2015-08-27
 */
CREATE PROCEDURE [dbo].[GC_HospitalShipmentBSC_BeforeSubmit]
   @SphId UNIQUEIDENTIFIER,
   @ShipmentDate NVARCHAR (200),
   @DealerId UNIQUEIDENTIFIER,
   @ProductLineId UNIQUEIDENTIFIER,
   @HospitalId UNIQUEIDENTIFIER,
   @ShipmentUser UNIQUEIDENTIFIER,
   @RtnVal NVARCHAR (20) OUTPUT,
   @RtnMsg NVARCHAR (1000) OUTPUT
AS
	DECLARE @ErrorCount   INTEGER
  
  --临时表，处理完成后，写入正式表，正式表以经销商、申请人、SPH_ID标识为当前正在处理的数据
	CREATE TABLE #TMP_CHECK
	(
		SltId             UNIQUEIDENTIFIER NOT NULL,
    IDENTITY_TYPE			NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NOT NULL,  
		IDENTITY_CODE			NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NOT NULL,
		SPH_ID					UNIQUEIDENTIFIER NOT NULL,
		SPH_Type				NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NOT NULL,
		SPL_Shipment_PMA_ID		UNIQUEIDENTIFIER NOT NULL,      
		LTM_LotNumber			NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NOT NULL,
		LTM_ExpiredDate			DATETIME NOT NULL,  --产品有效期
		ShipmentQty				DECIMAL (18, 6) NOT NULL, --销售数量
		TotalQty				DECIMAL (18, 6) NULL,    --可用库存数    
		IsCRM					BIT NOT NULL,
		CFN_CustomerFaceNbr		NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NULL,  --产品型号
		CFN_ID					UNIQUEIDENTIFIER NOT NULL,
		CurDate					DATETIME NOT NULL,
		ShipmentDate			DATETIME NOT NULL,
		HasAttachment			BIT NULL,
		ActualShipDate			DATETIME NULL,
		ConvertExpDate			DATETIME NULL,
		DealerID				UNIQUEIDENTIFIER,
		EditQrCode				NVARCHAR(50) COLLATE Chinese_PRC_CI_AS,
		QrCode					NVARCHAR(50) COLLATE Chinese_PRC_CI_AS,
		IsShipDateCrossQuarter	Bit NULL,
		IsActualShipDateCrossQuarter	Bit NULL,
		ErrorDesc				NVARCHAR (2000) COLLATE Chinese_PRC_CI_AS NULL,
		HospitalId				UNIQUEIDENTIFIER NOT NULL,
		BumId					UNIQUEIDENTIFIER NOT NULL,    
    IsError      Bit Not null,   --记录结果是否正确
    ErrorType    NVARCHAR(20) COLLATE Chinese_PRC_CI_AS NULL, --错误类型
    ErrorFixSuggestion NVARCHAR(2000) COLLATE Chinese_PRC_CI_AS NULL, --建议修改
    Whm_id       UNIQUEIDENTIFIER NOT NULL,  --仓库ID
    WHM_Name     NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NOT NULL,      --仓库名称
    CFN_ChineseName  NVARCHAR(200) COLLATE Chinese_PRC_CI_AS NULL,      --产品名称
    PMA_ConvertFactor int null,                --包装单位
    AvailableQty  DECIMAL (18, 6) NULL,    --剩余可用库存数  
    SalesUnitPrice DECIMAL (18, 6) NULL    --销售单价
	)
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''
      
      
      
      
      --先判断有没有销售到医院的数据,且状态是Draft
      IF EXISTS (SELECT 1 FROM ShipmentHeader WHERE SPH_ID = @SphId and SPH_Status='Draft')
         BEGIN
            SELECT * INTO #ShipmentHeader1 FROM ShipmentHeader WHERE SPH_ID = @SphId
            SELECT * INTO #ShipmentLine1 FROM ShipmentLine WHERE SPL_SPH_ID = @SphId
            SELECT * INTO #ShipmentLot1 FROM ShipmentLot A WHERE EXISTS (SELECT 1 FROM #ShipmentLine1 WHERE SPL_ID = A.SLT_SPL_ID)
            SELECT * INTO #ShipmentConsignment1 FROM ShipmentConsignment WHERE SPC_SPH_ID = @SphId
            
            --将Shipmentheader、ShipmentLine、ShipmentLot表相关信息写入临时表
            Insert into #TMP_CHECK(IDENTITY_TYPE,IDENTITY_CODE,SPH_ID,SPH_Type,SPL_Shipment_PMA_ID,LTM_LotNumber,LTM_ExpiredDate,ShipmentQty,TotalQty,
            IsCRM,CFN_CustomerFaceNbr,CFN_ID,CurDate,ShipmentDate,HasAttachment,ActualShipDate,ConvertExpDate,DealerID,EditQrCode,QrCode,HospitalId,BumId,
            IsError,ErrorType,ErrorFixSuggestion,Whm_id,WHM_Name,CFN_ChineseName,PMA_ConvertFactor,AvailableQty,SalesUnitPrice,SltId)
            
            select IDENTITY_TYPE,LI.IDENTITY_CODE,H.SPH_ID,H.SPH_Type,L.SPL_Shipment_PMA_ID, LM.LTM_LotNumber,LM.LTM_ExpiredDate,
                   T.SLT_LotShippedQty,SUM(CONVERT(decimal(18,6),LT.LOT_OnHandQty)) AS TotalQty,C.CFN_Property6 AS IsCRM,
                   C.CFN_CustomerFaceNbr,C.CFN_ID,getdate() As CurDate,@ShipmentDate,0 AS HasAttachment,
                   T.ShipmentDate AS ActualShipDate,LM.LTM_ExpiredDate ,
                   @DealerId,
                   CASE WHEN CHARINDEX('@@', T.SLT_QRLotNumber, 0) > 0 THEN substring(T.SLT_QRLotNumber, CHARINDEX('@@', T.SLT_QRLotNumber, 0) + 2, LEN(T.SLT_QRLotNumber) 
                    - CHARINDEX('@@', T.SLT_QRLotNumber, 0)) ELSE 'NoQR' END AS EditQrCode,
                   CASE WHEN CHARINDEX('@@', LM.LTM_LotNumber, 0) > 0 THEN substring(LM.LTM_LotNumber, CHARINDEX('@@', LM.LTM_LotNumber, 0) + 2, LEN(LM.LTM_LotNumber) 
                    - CHARINDEX('@@', LM.LTM_LotNumber, 0)) ELSE 'NoQR' END AS QrCode,
				           @HospitalId,@ProductLineId,
                   0 AS IsError,'' AS ErrorType,'' AS ErrorFixSuggestion, T.SLT_WHM_ID AS Whm_id,WH.WHM_Name,C.CFN_ChineseName,P.PMA_ConvertFactor, Convert(decimal(18,2),SUM(CONVERT(decimal(18,6),LT.LOT_OnHandQty))-T.SLT_LotShippedQty) AS AvailableQty, Convert(decimal(18,2),T.SLT_UnitPrice) AS SalesUnitPrice, T.SLT_ID
              from #ShipmentHeader1 H, #ShipmentLine1 L, #ShipmentLot1 T, Lot LT, LotMaster LM, Lafite_IDENTITY LI,CFN C, Product P, Warehouse WH
             where H.SPH_ID = L.SPL_SPH_ID and L.SPL_ID = T.SLT_SPL_ID 
               and LT.LOT_ID = T.SLT_LOT_ID and LT.LOT_LTM_ID = LM.LTM_ID 
               and LI.Id = isnull(H.SPH_Shipment_User,@ShipmentUser)
               and P.PMA_ID = L.SPL_Shipment_PMA_ID 
               and P.PMA_CFN_ID = C.CFN_ID
               and T.SLT_WHM_ID = WH.WHM_ID
               and H.SPH_ID=@SphId
               and H.SPH_Status='Draft'
            group by IDENTITY_TYPE,LI.IDENTITY_CODE,H.SPH_ID,H.SPH_Type,L.SPL_Shipment_PMA_ID, LM.LTM_LotNumber,LM.LTM_ExpiredDate,
                     T.SLT_LotShippedQty,C.CFN_Property6 ,C.CFN_CustomerFaceNbr,C.CFN_ID,T.ShipmentDate,T.SLT_QRLotNumber,LM.LTM_LotNumber,
                     T.SLT_WHM_ID,WH.WHM_Name,C.CFN_ChineseName,P.PMA_ConvertFactor,T.SLT_UnitPrice,T.SLT_ID
                     
--寄售销售已经不使用了 Edit By SWM on 2018-06-24
--            union 
--            select IDENTITY_TYPE,LI.IDENTITY_CODE,H.SPH_ID,H.SPH_Type,P.PMA_ID , LM.LTM_LotNumber,LM.LTM_ExpiredDate,
--                   Sc.SPC_ShippedQty,SUM(CONVERT(decimal(18,6),LT.LOT_OnHandQty)) AS TotalQty,C.CFN_Property6 AS IsCRM,
--                   C.CFN_CustomerFaceNbr,C.CFN_ID,getdate() As CurDate,@ShipmentDate,0 AS HasAttachment, 
--                   SC.ShipmentDate AS ActualShipDate,LM.LTM_ExpiredDate,
--                   @DealerId,'' as EditQrCode,
--                   CASE WHEN CHARINDEX('@@', LM.LTM_LotNumber, 0) > 0 THEN substring(LM.LTM_LotNumber, CHARINDEX('@@', LM.LTM_LotNumber, 0) + 2, LEN(LM.LTM_LotNumber) 
--                    - CHARINDEX('@@', LM.LTM_LotNumber, 0)) ELSE 'NoQR' END AS QrCode,
--				   @HospitalId,@ProductLineId
--              from #ShipmentHeader1 H, #ShipmentConsignment1 SC,Lot LT,Inventory Inv, LotMaster LM, Lafite_IDENTITY LI,CFN C, Product P, Warehouse WH
--             where H.SPH_ID = SC.SPC_SPH_ID and SC.SPC_LTM_ID = LM.LTM_ID 
--               and LT.LOT_LTM_ID = LM.LTM_ID and Inv.INV_ID = LT.LOT_INV_ID
--               and LI.Id = isnull(H.SPH_Shipment_User,@ShipmentUser)
--               and Inv.INV_PMA_ID = P.PMA_ID
--               and P.PMA_CFN_ID = C.CFN_ID and WH.WHM_ID = Inv.INV_WHM_ID
--               and WH.WHM_DMA_ID = H.SPH_Dealer_DMA_ID 
--               and WH.WHM_Type IN ('Consignment','LP_Consignment')
--               and H.SPH_ID=@SphId
--               and H.SPH_Status='Draft'
--             group by IDENTITY_TYPE,LI.IDENTITY_CODE,H.SPH_ID,H.SPH_Type,P.PMA_ID , LM.LTM_LotNumber,LM.LTM_ExpiredDate,
--                      Sc.SPC_ShippedQty,C.CFN_Property6 ,C.CFN_CustomerFaceNbr,C.CFN_ID,SC.ShipmentDate,LM.LTM_LotNumber

            
			      --更新是否有附件的标识           
            --select *
            UPDATE TC SET TC.HasAttachment = 1
              FROM #TMP_CHECK TC, Attachment ATT
             WHERE TC.SPH_ID = ATT.AT_Main_ID
            
            --转换产品有效期：CRM产品的有效期直接使用，非CRM产品有效期是当月的最后一天
            update #TMP_CHECK SET ConvertExpDate = dateadd(month, datediff(month, 0, dateadd(month,1,LTM_ExpiredDate)), 0) WHERE IsCRM = 0
            update #TMP_CHECK SET ConvertExpDate = dateadd(day,1,LTM_ExpiredDate) WHERE IsCRM = 1
                        
            --更新用量日期是否跨季度(与当前日期比较)：
            update #TMP_CHECK SET IsShipDateCrossQuarter = 1
            
            update #TMP_CHECK SET IsShipDateCrossQuarter = 0 
             WHERE dateadd(qq,datediff(qq,0,ShipmentDate),0) = dateadd(qq,datediff(qq,0,getdate()),0)
            
            
            
            --更新实际用量日期是否跨季度(与当前日期比较)
            update #TMP_CHECK SET IsActualShipDateCrossQuarter = 0 
             WHERE dateadd(qq,datediff(qq,0,ShipmentDate),0) = dateadd(qq,datediff(qq,0,getdate()),0)
            
            update #TMP_CHECK SET IsActualShipDateCrossQuarter = 1 
             WHERE dateadd(qq,datediff(qq,0,ActualShipDate),0) <> dateadd(qq,datediff(qq,0,getdate()),0)
               AND ActualShipDate is not null
            
            
            --检查库存是否够
             UPDATE #TMP_CHECK
                SET ErrorDesc = '库存不够扣减', IsError = 1, ErrorType ='库存',ErrorFixSuggestion ='修改销售出库数量'
              WHERE ErrorDesc IS NULL
                AND ShipmentQty > TotalQty           
          
            
            --如果提交人是经销商（Dealer）
            --1、不允许用量日期大于产品有效期
            --2、如果提交日期大于产品效期，则必须有附件
			--3、检验医院授权
			--4、检验产品授权
			UPDATE #TMP_CHECK
                SET ErrorDesc = '不允许用量日期大于产品有效期;', IsError = 1, ErrorType ='用量日期',ErrorFixSuggestion ='调整用量日期或咨询系统管理员'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'Dealer'
                AND ShipmentDate >= ConvertExpDate
                
			UPDATE #TMP_CHECK
                SET ErrorDesc = '当前单据的提交日期超过产品的有效期，请添加“发货到医院的出库单（需有日期）照片”作为本单据的附件;', IsError = 1, ErrorType ='产品',ErrorFixSuggestion ='去除过期产品或联系管理员'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'Dealer'
                AND getdate() >= ConvertExpDate
                AND HasAttachment = 0

			UPDATE #TMP_CHECK
				SET ErrorDesc = '医院未授权;', IsError = 1, ErrorType ='授权',ErrorFixSuggestion ='查询授权情况并根据需要增加授权'
				WHERE     ErrorDesc IS NULL
				AND IDENTITY_TYPE = 'Dealer'
				AND NOT EXISTS 
				(
					SELECT 1 FROM DealerAuthorizationTable
					INNER JOIN HospitalList ON DAT_ID = HLA_DAT_ID
					WHERE DAT_Type IN ('Normal','Temp','Shipment')
					AND DAT_ProductLine_BUM_ID = BumId
					AND DAT_DMA_ID = DealerID
					AND HospitalId = HLA_HOS_ID
					AND ShipmentDate BETWEEN ISNULL(HLA_StartDate,'1900-01-01') AND ISNULL(HLA_EndDate,DATEADD(DAY,-1,ShipmentDate))
				)
			
			DECLARE @AuthCount INT 

			SELECT @AuthCount = COUNT(1) FROM DealerAuthorizationTable 
			WHERE DAT_Type = 'Shipment' 
			AND EXISTS (SELECT 1 FROM #TMP_CHECK WHERE DealerID = DAT_DMA_ID AND DAT_ProductLine_BUM_ID = BumId)
			
			UPDATE #TMP_CHECK
				SET ErrorDesc = '产品未授权;', IsError = 1, ErrorType ='授权',ErrorFixSuggestion ='查询授权情况并根据需要增加授权'
				WHERE     ErrorDesc IS NULL
				AND IDENTITY_TYPE = 'Dealer'
				AND NOT EXISTS 
				(
					SELECT 1 FROM DealerAuthorizationTable
					INNER JOIN HospitalList ON DAT_ID = HLA_DAT_ID
					INNER JOIN Cache_PartsClassificationRec ON PCT_ProductLine_BUM_ID = DAT_ProductLine_BUM_ID
					INNER JOIN CFN C ON C.CFN_ID = #TMP_CHECK.CFN_ID
					INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=C.CFN_CustomerFaceNbr
					WHERE DAT_Type IN ('Normal','Temp','Shipment')
					AND DAT_ProductLine_BUM_ID = BumId
					AND DAT_DMA_ID = DealerID
					AND HospitalId = HLA_HOS_ID
					AND ShipmentDate BETWEEN ISNULL(HLA_StartDate,'1900-01-01') AND ISNULL(HLA_EndDate,DATEADD(DAY,-1,ShipmentDate))
					AND 
					(
						(
							DAT_Type = 'Shipment' AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),ShipmentDate,120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,ShipmentDate))
						)
						OR 
						(
							@AuthCount = 0 AND (DAT_Type IN ('Normal','Temp') AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),ShipmentDate,120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,ShipmentDate)))
						)
					)
					AND
					(
						(
							DAT_PMA_ID = DAT_ProductLine_BUM_ID
							AND DAT_ProductLine_BUM_ID = C.CFN_ProductLine_BUM_ID
						)
						OR
						(
							DAT_PMA_ID != DAT_ProductLine_BUM_ID
							AND PCT_ParentClassification_PCT_ID = DAT_PMA_ID
							AND PCT_ID = CCF.ClassificationId
						)
					)
				)
				               
            --如果提交人是波科用户（User），
            --1、用量日期不允许跨季度（与当前日期不在同一个季度）
            --2、如果填写了实际用量日期，则实际用量日期必须与当前日期不在同一个季度，且必须比当前日期小
            --3、如果填写了实际用量日期，则用量日期必须是当前日期
            --4、不允许用量日期大于产品有效期
            --5、如果提交日期大于产品效期，则必须有附件
             UPDATE #TMP_CHECK
                SET ErrorDesc = '不允许用量日期大于产品有效期;', IsError = 1, ErrorType ='产品',ErrorFixSuggestion ='调整用量日期或联系管理员'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'User'
                AND ShipmentDate >= ConvertExpDate
                AND ActualShipDate IS NULL
                
             UPDATE #TMP_CHECK
                SET ErrorDesc = '实际用量日期必须小于产品有效期;', IsError = 1, ErrorType ='产品',ErrorFixSuggestion ='调整实际用量日期或联系管理员'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'User'
                AND ActualShipDate >= ConvertExpDate
                AND ActualShipDate IS NOT NULL
             
             UPDATE #TMP_CHECK
                SET ErrorDesc = '提交日期大于产品效期,必须添加附件作为证明文件;', IsError = 1, ErrorType ='产品',ErrorFixSuggestion ='去除过有效期产品或添加附件证明'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'User'
                AND getdate() >= ConvertExpDate
                AND HasAttachment = 0
                AND ShipmentQty >= 0

		     -- Edit By SongWeiming on 2018-10-13 according to CR applied by DRM and QA
             --UPDATE #TMP_CHECK
             --   SET ErrorDesc = '用量日期不允许跨季度,如果跨季度,请填写实际用量日期,且用量日期必须为当前日期;', IsError = 1, ErrorType ='用量日期',ErrorFixSuggestion ='调整用量日期或填写实际用量日期'
             -- WHERE     ErrorDesc IS NULL
             --   AND IDENTITY_TYPE = 'User'               
             --   AND IsShipDateCrossQuarter = 1
             
--             UPDATE #TMP_CHECK
--                SET ErrorDesc = '填写的实际用量日期与当前日期不能在同一个季度;', IsError = 1, ErrorType ='用量日期',ErrorFixSuggestion ='调整实际用量日期或联系管理员'
--              WHERE     ErrorDesc IS NULL
--                AND IDENTITY_TYPE = 'User'  
--                AND ActualShipDate IS NOT NULL
--                AND IsActualShipDateCrossQuarter = 0
              
             UPDATE #TMP_CHECK
                SET ErrorDesc = '填写了实际用量日期，用量日期必须是当前日期;', IsError = 1, ErrorType ='用量日期',ErrorFixSuggestion ='调整用量日期为当前日期'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'User' 
                AND ActualShipDate IS NOT NULL
                AND Convert(nvarchar(8),ShipmentDate,112) <> Convert(nvarchar(8),getdate(),112)
		
		SELECT * INTO #ShipmentHeader2 FROM ShipmentHeader A WHERE EXISTS (SELECT 1 FROM #TMP_CHECK WHERE DealerID = A.SPH_Dealer_DMA_ID)
			AND A.SPH_Status IN ('Complete','Reversed')
			AND A.SPH_ID<>@SphId
				 
		SELECT * INTO #ShipmentLine2 FROM ShipmentLine A WHERE EXISTS (SELECT 1 FROM #ShipmentHeader2 WHERE SPH_ID = A.SPL_SPH_ID)
		
		SELECT * INTO #ShipmentLot2 FROM ShipmentLot A WHERE EXISTS (SELECT 1 FROM #ShipmentLine2 WHERE SPL_ID = A.SLT_SPL_ID)
		
                -- 判断二维码是否在历史单据中使用过
                UPDATE #TMP_CHECK 
                SET ErrorDesc=#TMP_CHECK.EditQrCode+'二维码已在历史销售单中使用过', IsError = 1, ErrorType ='产品',ErrorFixSuggestion ='确认此二维码是否正确或请联系系统管理员'
                where ErrorDesc IS NULL 
				        AND exists(SELECT 1 FROM #ShipmentHeader2 ShipmentHeader inner join #ShipmentLine2 ShipmentLine on 
                ShipmentHeader.SPH_ID=ShipmentLine.SPL_SPH_ID
                inner join #ShipmentLot2 ShipmentLot on ShipmentLine.SPL_ID=ShipmentLot.SLT_SPL_ID
                inner join Lot on ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID)=Lot.LOT_ID
                inner join LotMaster on LotMaster.LTM_ID=Lot.LOT_LTM_ID
                WHERE #TMP_CHECK.DealerID=ShipmentHeader.SPH_Dealer_DMA_ID 
				 AND ShipmentHeader.SPH_Status IN ('Complete','Reversed')
				 AND ShipmentHeader.SPH_ID<>@SphId
				 AND (#TMP_CHECK.EditQrCode=CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 
												THEN substring(LotMaster.LTM_LotNumber, CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) + 2, LEN(LotMaster.LTM_LotNumber) - CHARINDEX('@@', LotMaster.LTM_LotNumber, 0)) 
											ELSE 'NoQR' END 
						OR #TMP_CHECK.QrCode=CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 
												THEN substring(LotMaster.LTM_LotNumber, CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) + 2, LEN(LotMaster.LTM_LotNumber) - CHARINDEX('@@', LotMaster.LTM_LotNumber, 0)) 
											ELSE 'NoQR' END) 
				AND CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 
								THEN substring(LotMaster.LTM_LotNumber, CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) + 2, LEN(LotMaster.LTM_LotNumber) - CHARINDEX('@@', LotMaster.LTM_LotNumber, 0)) 
							ELSE 'NoQR' END <> 'NoQR'
                group by ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID) HAVING  SUM(ISNULL(ShipmentLot.SLT_LotShippedQty,0))+ISNULL(#TMP_CHECK.ShipmentQty,0)>1)
                
            
			--是否有医院授权未通过的数据
			DECLARE @HospAuthErrorCount INT
			SELECT @HospAuthErrorCount = COUNT(1) FROM #TMP_CHECK WHERE ErrorDesc LIKE '%医院未授权;%'

			--SELECT @RtnMsg=#TMP_CHECK.LTM_LotNumber+
            --'二维码已在' FROM #TMP_CHECK
            --判断当前日期是否可以提交对应用量日期的单据           
            declare @maxSpDate datetime
            declare @minSpDate datetime 
            declare @IDType nvarchar(20)
            
            select @maxSpDate = dateadd(dd,1,Convert(datetime,CDD_Calendar + right('00'+Convert(nvarchar(10),cdd_date1),2)))
                    from CalendarDate 
                   where CDD_Calendar= Convert(nvarchar(6),dateadd(month,1,@shipmentDate),112)
            select @minSpDate = DATEADD(mm, DATEDIFF(mm,0,@shipmentDate), 0)         
            select top 1 @IDType =  IDENTITY_TYPE from #TMP_CHECK
            
            IF((GETDATE()> @maxSpDate OR GETDATE()<@minSpDate) AND @IDType='Dealer' )
      				BEGIN
      					DECLARE @validMaxSpDate DATETIME
      					DECLARE @validMinSpDate DATETIME          
      					SELECT @validMaxSpDate = GETDATE()
      					SELECT @validMinSpDate = DATEADD(mm, DATEDIFF(mm,0,getdate()), 0)
                      
      					SET @RtnMsg = '选择的“用量日期”不在有效的日期范围内，有效日期为：'+ Convert(nvarchar(10),@validMinSpDate,112) + '~'+ Convert(nvarchar(10),@validMaxSpDate,112) +',请修改用量日期'                 
      				END
              
--已经可以明细行报错了，所以不需要拼接错误信息              
--      			ELSE IF @HospAuthErrorCount > 0
--      				BEGIN
--      					
--      					SET @RtnMsg = '医院未授权'
--      				END
--            ELSE
--                    BEGIN
--                      --拼接错误信息
--                      SET @RtnMsg =
--                           ISNULL ( (SELECT '批号:' + LTM_LotNumber + ' ' +ErrorDesc + 'brbr'
--                                       FROM #TMP_CHECK
--                                      WHERE ErrorDesc IS NOT NULL
--                                     ORDER BY LTM_LotNumber
--                                     FOR XML PATH ( '' )),
--                                   '')
--                    END
         END
      ELSE
         BEGIN
           SET @RtnMsg = '单据不是草稿状态不能提交,或此单据已被删除'
         END
         

      
      
      
      IF LEN (@RtnMsg) > 0
         SET @RtnVal = 'Error' 
      
      DELETE FROM dbo.HospitalShipmentBSC_BeforeSubmit_Init where SPH_ID=@SphId and CreateUser = @ShipmentUser
      INSERT INTO dbo.HospitalShipmentBSC_BeforeSubmit_Init select *,@ShipmentUser,getdate() from #TMP_CHECK

      COMMIT TRAN

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @RtnVal = 'Error'
      
      --记录错误日志开始
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError = '行' + CONVERT (NVARCHAR (10), @error_line) + '出错[错误号' + CONVERT (NVARCHAR (10), @error_number) + '],' + @error_message
      SET @RtnMsg = @vError
      
      RETURN -1
   END CATCH


