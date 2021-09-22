DROP PROCEDURE [dbo].[GC_HospitalShipmentBSC_BeforeSubmit]
GO


/*
 *ҽԺ���۵��ύǰ���
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
  
  --��ʱ��������ɺ�д����ʽ����ʽ���Ծ����̡������ˡ�SPH_ID��ʶΪ��ǰ���ڴ��������
	CREATE TABLE #TMP_CHECK
	(
		SltId             UNIQUEIDENTIFIER NOT NULL,
    IDENTITY_TYPE			NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NOT NULL,  
		IDENTITY_CODE			NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NOT NULL,
		SPH_ID					UNIQUEIDENTIFIER NOT NULL,
		SPH_Type				NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NOT NULL,
		SPL_Shipment_PMA_ID		UNIQUEIDENTIFIER NOT NULL,      
		LTM_LotNumber			NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NOT NULL,
		LTM_ExpiredDate			DATETIME NOT NULL,  --��Ʒ��Ч��
		ShipmentQty				DECIMAL (18, 6) NOT NULL, --��������
		TotalQty				DECIMAL (18, 6) NULL,    --���ÿ����    
		IsCRM					BIT NOT NULL,
		CFN_CustomerFaceNbr		NVARCHAR (100) COLLATE Chinese_PRC_CI_AS NULL,  --��Ʒ�ͺ�
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
    IsError      Bit Not null,   --��¼����Ƿ���ȷ
    ErrorType    NVARCHAR(20) COLLATE Chinese_PRC_CI_AS NULL, --��������
    ErrorFixSuggestion NVARCHAR(2000) COLLATE Chinese_PRC_CI_AS NULL, --�����޸�
    Whm_id       UNIQUEIDENTIFIER NOT NULL,  --�ֿ�ID
    WHM_Name     NVARCHAR (50) COLLATE Chinese_PRC_CI_AS NOT NULL,      --�ֿ�����
    CFN_ChineseName  NVARCHAR(200) COLLATE Chinese_PRC_CI_AS NULL,      --��Ʒ����
    PMA_ConvertFactor int null,                --��װ��λ
    AvailableQty  DECIMAL (18, 6) NULL,    --ʣ����ÿ����  
    SalesUnitPrice DECIMAL (18, 6) NULL    --���۵���
	)
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''
      
      
      
      
      --���ж���û�����۵�ҽԺ������,��״̬��Draft
      IF EXISTS (SELECT 1 FROM ShipmentHeader WHERE SPH_ID = @SphId and SPH_Status='Draft')
         BEGIN
            SELECT * INTO #ShipmentHeader1 FROM ShipmentHeader WHERE SPH_ID = @SphId
            SELECT * INTO #ShipmentLine1 FROM ShipmentLine WHERE SPL_SPH_ID = @SphId
            SELECT * INTO #ShipmentLot1 FROM ShipmentLot A WHERE EXISTS (SELECT 1 FROM #ShipmentLine1 WHERE SPL_ID = A.SLT_SPL_ID)
            SELECT * INTO #ShipmentConsignment1 FROM ShipmentConsignment WHERE SPC_SPH_ID = @SphId
            
            --��Shipmentheader��ShipmentLine��ShipmentLot�������Ϣд����ʱ��
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
                     
--���������Ѿ���ʹ���� Edit By SWM on 2018-06-24
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

            
			      --�����Ƿ��и����ı�ʶ           
            --select *
            UPDATE TC SET TC.HasAttachment = 1
              FROM #TMP_CHECK TC, Attachment ATT
             WHERE TC.SPH_ID = ATT.AT_Main_ID
            
            --ת����Ʒ��Ч�ڣ�CRM��Ʒ����Ч��ֱ��ʹ�ã���CRM��Ʒ��Ч���ǵ��µ����һ��
            update #TMP_CHECK SET ConvertExpDate = dateadd(month, datediff(month, 0, dateadd(month,1,LTM_ExpiredDate)), 0) WHERE IsCRM = 0
            update #TMP_CHECK SET ConvertExpDate = dateadd(day,1,LTM_ExpiredDate) WHERE IsCRM = 1
                        
            --�������������Ƿ�缾��(�뵱ǰ���ڱȽ�)��
            update #TMP_CHECK SET IsShipDateCrossQuarter = 1
            
            update #TMP_CHECK SET IsShipDateCrossQuarter = 0 
             WHERE dateadd(qq,datediff(qq,0,ShipmentDate),0) = dateadd(qq,datediff(qq,0,getdate()),0)
            
            
            
            --����ʵ�����������Ƿ�缾��(�뵱ǰ���ڱȽ�)
            update #TMP_CHECK SET IsActualShipDateCrossQuarter = 0 
             WHERE dateadd(qq,datediff(qq,0,ShipmentDate),0) = dateadd(qq,datediff(qq,0,getdate()),0)
            
            update #TMP_CHECK SET IsActualShipDateCrossQuarter = 1 
             WHERE dateadd(qq,datediff(qq,0,ActualShipDate),0) <> dateadd(qq,datediff(qq,0,getdate()),0)
               AND ActualShipDate is not null
            
            
            --������Ƿ�
             UPDATE #TMP_CHECK
                SET ErrorDesc = '��治���ۼ�', IsError = 1, ErrorType ='���',ErrorFixSuggestion ='�޸����۳�������'
              WHERE ErrorDesc IS NULL
                AND ShipmentQty > TotalQty           
          
            
            --����ύ���Ǿ����̣�Dealer��
            --1���������������ڴ��ڲ�Ʒ��Ч��
            --2������ύ���ڴ��ڲ�ƷЧ�ڣ�������и���
			--3������ҽԺ��Ȩ
			--4�������Ʒ��Ȩ
			UPDATE #TMP_CHECK
                SET ErrorDesc = '�������������ڴ��ڲ�Ʒ��Ч��;', IsError = 1, ErrorType ='��������',ErrorFixSuggestion ='�����������ڻ���ѯϵͳ����Ա'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'Dealer'
                AND ShipmentDate >= ConvertExpDate
                
			UPDATE #TMP_CHECK
                SET ErrorDesc = '��ǰ���ݵ��ύ���ڳ�����Ʒ����Ч�ڣ�����ӡ�������ҽԺ�ĳ��ⵥ���������ڣ���Ƭ����Ϊ�����ݵĸ���;', IsError = 1, ErrorType ='��Ʒ',ErrorFixSuggestion ='ȥ�����ڲ�Ʒ����ϵ����Ա'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'Dealer'
                AND getdate() >= ConvertExpDate
                AND HasAttachment = 0

			UPDATE #TMP_CHECK
				SET ErrorDesc = 'ҽԺδ��Ȩ;', IsError = 1, ErrorType ='��Ȩ',ErrorFixSuggestion ='��ѯ��Ȩ�����������Ҫ������Ȩ'
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
				SET ErrorDesc = '��Ʒδ��Ȩ;', IsError = 1, ErrorType ='��Ȩ',ErrorFixSuggestion ='��ѯ��Ȩ�����������Ҫ������Ȩ'
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
				               
            --����ύ���ǲ����û���User����
            --1���������ڲ�����缾�ȣ��뵱ǰ���ڲ���ͬһ�����ȣ�
            --2�������д��ʵ���������ڣ���ʵ���������ڱ����뵱ǰ���ڲ���ͬһ�����ȣ��ұ���ȵ�ǰ����С
            --3�������д��ʵ���������ڣ����������ڱ����ǵ�ǰ����
            --4���������������ڴ��ڲ�Ʒ��Ч��
            --5������ύ���ڴ��ڲ�ƷЧ�ڣ�������и���
             UPDATE #TMP_CHECK
                SET ErrorDesc = '�������������ڴ��ڲ�Ʒ��Ч��;', IsError = 1, ErrorType ='��Ʒ',ErrorFixSuggestion ='�����������ڻ���ϵ����Ա'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'User'
                AND ShipmentDate >= ConvertExpDate
                AND ActualShipDate IS NULL
                
             UPDATE #TMP_CHECK
                SET ErrorDesc = 'ʵ���������ڱ���С�ڲ�Ʒ��Ч��;', IsError = 1, ErrorType ='��Ʒ',ErrorFixSuggestion ='����ʵ���������ڻ���ϵ����Ա'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'User'
                AND ActualShipDate >= ConvertExpDate
                AND ActualShipDate IS NOT NULL
             
             UPDATE #TMP_CHECK
                SET ErrorDesc = '�ύ���ڴ��ڲ�ƷЧ��,������Ӹ�����Ϊ֤���ļ�;', IsError = 1, ErrorType ='��Ʒ',ErrorFixSuggestion ='ȥ������Ч�ڲ�Ʒ����Ӹ���֤��'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'User'
                AND getdate() >= ConvertExpDate
                AND HasAttachment = 0
                AND ShipmentQty >= 0

		     -- Edit By SongWeiming on 2018-10-13 according to CR applied by DRM and QA
             --UPDATE #TMP_CHECK
             --   SET ErrorDesc = '�������ڲ�����缾��,����缾��,����дʵ����������,���������ڱ���Ϊ��ǰ����;', IsError = 1, ErrorType ='��������',ErrorFixSuggestion ='�����������ڻ���дʵ����������'
             -- WHERE     ErrorDesc IS NULL
             --   AND IDENTITY_TYPE = 'User'               
             --   AND IsShipDateCrossQuarter = 1
             
--             UPDATE #TMP_CHECK
--                SET ErrorDesc = '��д��ʵ�����������뵱ǰ���ڲ�����ͬһ������;', IsError = 1, ErrorType ='��������',ErrorFixSuggestion ='����ʵ���������ڻ���ϵ����Ա'
--              WHERE     ErrorDesc IS NULL
--                AND IDENTITY_TYPE = 'User'  
--                AND ActualShipDate IS NOT NULL
--                AND IsActualShipDateCrossQuarter = 0
              
             UPDATE #TMP_CHECK
                SET ErrorDesc = '��д��ʵ���������ڣ��������ڱ����ǵ�ǰ����;', IsError = 1, ErrorType ='��������',ErrorFixSuggestion ='������������Ϊ��ǰ����'
              WHERE     ErrorDesc IS NULL
                AND IDENTITY_TYPE = 'User' 
                AND ActualShipDate IS NOT NULL
                AND Convert(nvarchar(8),ShipmentDate,112) <> Convert(nvarchar(8),getdate(),112)
		
		SELECT * INTO #ShipmentHeader2 FROM ShipmentHeader A WHERE EXISTS (SELECT 1 FROM #TMP_CHECK WHERE DealerID = A.SPH_Dealer_DMA_ID)
			AND A.SPH_Status IN ('Complete','Reversed')
			AND A.SPH_ID<>@SphId
				 
		SELECT * INTO #ShipmentLine2 FROM ShipmentLine A WHERE EXISTS (SELECT 1 FROM #ShipmentHeader2 WHERE SPH_ID = A.SPL_SPH_ID)
		
		SELECT * INTO #ShipmentLot2 FROM ShipmentLot A WHERE EXISTS (SELECT 1 FROM #ShipmentLine2 WHERE SPL_ID = A.SLT_SPL_ID)
		
                -- �ж϶�ά���Ƿ�����ʷ������ʹ�ù�
                UPDATE #TMP_CHECK 
                SET ErrorDesc=#TMP_CHECK.EditQrCode+'��ά��������ʷ���۵���ʹ�ù�', IsError = 1, ErrorType ='��Ʒ',ErrorFixSuggestion ='ȷ�ϴ˶�ά���Ƿ���ȷ������ϵϵͳ����Ա'
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
                
            
			--�Ƿ���ҽԺ��Ȩδͨ��������
			DECLARE @HospAuthErrorCount INT
			SELECT @HospAuthErrorCount = COUNT(1) FROM #TMP_CHECK WHERE ErrorDesc LIKE '%ҽԺδ��Ȩ;%'

			--SELECT @RtnMsg=#TMP_CHECK.LTM_LotNumber+
            --'��ά������' FROM #TMP_CHECK
            --�жϵ�ǰ�����Ƿ�����ύ��Ӧ�������ڵĵ���           
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
                      
      					SET @RtnMsg = 'ѡ��ġ��������ڡ�������Ч�����ڷ�Χ�ڣ���Ч����Ϊ��'+ Convert(nvarchar(10),@validMinSpDate,112) + '~'+ Convert(nvarchar(10),@validMaxSpDate,112) +',���޸���������'                 
      				END
              
--�Ѿ�������ϸ�б����ˣ����Բ���Ҫƴ�Ӵ�����Ϣ              
--      			ELSE IF @HospAuthErrorCount > 0
--      				BEGIN
--      					
--      					SET @RtnMsg = 'ҽԺδ��Ȩ'
--      				END
--            ELSE
--                    BEGIN
--                      --ƴ�Ӵ�����Ϣ
--                      SET @RtnMsg =
--                           ISNULL ( (SELECT '����:' + LTM_LotNumber + ' ' +ErrorDesc + 'brbr'
--                                       FROM #TMP_CHECK
--                                      WHERE ErrorDesc IS NOT NULL
--                                     ORDER BY LTM_LotNumber
--                                     FOR XML PATH ( '' )),
--                                   '')
--                    END
         END
      ELSE
         BEGIN
           SET @RtnMsg = '���ݲ��ǲݸ�״̬�����ύ,��˵����ѱ�ɾ��'
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
      
      --��¼������־��ʼ
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError = '��' + CONVERT (NVARCHAR (10), @error_line) + '����[�����' + CONVERT (NVARCHAR (10), @error_number) + '],' + @error_message
      SET @RtnMsg = @vError
      
      RETURN -1
   END CATCH


