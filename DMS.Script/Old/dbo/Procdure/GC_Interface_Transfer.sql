DROP Procedure [dbo].[GC_Interface_Transfer]
GO


/*
��������ϴ�
*/
CREATE Procedure [dbo].[GC_Interface_Transfer]
	@BatchNbr NVARCHAR(30),
	@ClientID NVARCHAR(50),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @SysUserId uniqueidentifier
	DECLARE @SystemHoldWarehouse uniqueidentifier
	DECLARE @DefaultWarehouse uniqueidentifier
	DECLARE @DealerId uniqueidentifier
	DECLARE @DupQRCnt INT
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	
	--У��һ�ŵ����Ƿ�����ظ��Ķ�ά��
	  SELECT @DupQRCnt = COUNT (*)
		FROM (SELECT QRCode,SUM(ITR_LotTransferQty) AS SumQty
		        FROM (				
						SELECT CASE WHEN charindex('@@',ITR_LotNumber) > 0
									THEN substring(ITR_LotNumber,charindex('@@',ITR_LotNumber)+2,len(ITR_LotNumber)) 
									ELSE ''
									END AS QRCode,ITR_LotTransferQty
						FROM InterfaceTransfer
					   WHERE ITR_BatchNbr = @BatchNbr 
			         ) AS QRTab
			   WHERE QRCode<>'NoQR'
			   GROUP BY QRCode
			  HAVING SUM(ITR_LotTransferQty) > 1
	  ) tab
	  
	  IF (@DupQRCnt > 0)
		 RAISERROR ('�˽�����ݴ��ڶ�ά���ظ����ά����������1�����', 16, 1)
	
	--����������
	SELECT @DealerId = CLT_Corp_Id FROM Client WHERE CLT_ID = @ClientID
		
	--ƽ̨��;������
	SELECT @SystemHoldWarehouse = WHM_ID FROM Warehouse WHERE WHM_DMA_ID = @DealerId AND WHM_Type = 'SystemHold'
	--ƽ̨Ĭ�Ͽ�����
	SELECT @DefaultWarehouse = WHM_ID FROM Warehouse WHERE WHM_DMA_ID = @DealerId AND WHM_Type = 'DefaultWH'

	--���@ClientID��Ϊ�գ���ʾ��InterfaceTransfer�ж�ȡ����
	--��Ʒ��Ȩ�ݲ������,SNL_Authorizedʼ��1
	INSERT INTO TransferNote
	(
		TNL_ID,
		TNL_Dealer_SapCode,
		TNL_TransferDate,
		TNL_ArticleNumber,
		TNL_LotNumber,
		TNL_ExpiredDate,
		TNL_LotTransferQty,
		TNL_Remark,
		TNL_TransferType,
		TNL_ToDealerType,
		TNL_LineNbr,
		TNL_FileName,
		TNL_ImportDate,
		TNL_ClientID,
		TNL_BatchNbr,
		TNL_FromDealer_DMA_ID,
		TNL_ToDealer_DMA_ID,
		TNL_FromWarehouse_WHM_ID,
		TNL_ToWarehouse_WHM_ID,
		TNL_Authorized,
		TNL_ProblemDescription,
		TNL_HandleDate,
		TNL_UnitPrice
	)
	SELECT 
		NEWID(),
		ITR_Dealer_SapCode,
		ITR_TransferDate,
		ITR_ArticleNumber,
		ITR_LotNumber,
		ITR_ExpiredDate,
		ITR_LotTransferQty,
		ITR_Remark,
		ITR_TransferType,
		CASE ITR_TransferType WHEN 'Out' THEN D.DMA_DealerType ELSE NULL END,
		ITR_LineNbr,
		ITR_FileName,
		ITR_ImportDate,
		ITR_ClientID,
		ITR_BatchNbr,
		CASE ITR_TransferType WHEN 'Out' THEN @DealerId ELSE D.DMA_ID END,
		CASE ITR_TransferType WHEN 'In' THEN @DealerId ELSE D.DMA_ID END,
		CASE ITR_TransferType WHEN 'Out' THEN @DefaultWarehouse ELSE W.WHM_ID END,
		CASE ITR_TransferType WHEN 'In' THEN @DefaultWarehouse ELSE W.WHM_ID END,
		1,
		NULL,
		GETDATE(),
		ITR_UnitPrice
	FROM InterfaceTransfer I
	LEFT OUTER JOIN DealerMaster D ON D.DMA_SAP_Code = I.ITR_Dealer_SapCode
	LEFT OUTER JOIN Warehouse W ON W.WHM_DMA_ID = D.DMA_ID AND W.WHM_Type = 'DefaultWH'
	WHERE ITR_BatchNbr = @BatchNbr



	--���²�Ʒ��Ϣ
	UPDATE  A
	SET A.TNL_CFN_ID = CFN.CFN_ID, 
	A.TNL_PMA_ID = Product.PMA_ID,
	A.TNL_BUM_ID = CFN.CFN_ProductLine_BUM_ID,
	A.TNL_PCT_ID = CCF.ClassificationId,
	A.TNL_HandleDate = GETDATE()
	FROM TransferNote A
	INNER JOIN CFN ON CFN.CFN_CustomerFaceNbr = A.TNL_ArticleNumber
	INNER JOIN Product ON Product.PMA_CFN_ID = CFN.CFN_ID
	INNER JOIN DealerMaster DM ON DM.DMA_SAP_Code=A.TNL_Dealer_SapCode
	INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
	AND CCF.ClassificationId IN (SELECT b.ProducPctId FROM GC_FN_GetDealerAuthProductSub(dm.DMA_ID) b WHERE b.ActiveFlag=1)
	WHERE 
	 A.TNL_BatchNbr = @BatchNbr

	--�����������������κŸ������κ�����
	UPDATE TransferNote
	SET TransferNote.TNL_LTM_ID = LM.LTM_ID
	FROM LotMaster LM
	WHERE LM.LTM_LotNumber = TransferNote.TNL_LotNumber
	AND LM.LTM_Product_PMA_ID = TransferNote.TNL_PMA_ID
	AND TransferNote.TNL_BatchNbr = @BatchNbr
	AND TransferNote.TNL_PMA_ID IS NOT NULL


  --����LTM_ID�ŵ�����������


	--TODO�������Ȩ
	
	--���´�����Ϣ
	UPDATE TransferNote SET TNL_ProblemDescription = N'��������̲�����'
	WHERE TNL_FromDealer_DMA_ID IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr

	UPDATE TransferNote SET TNL_ProblemDescription = (CASE WHEN TNL_ProblemDescription IS NULL THEN '' ELSE TNL_ProblemDescription + ',' END) + N'���뾭���̲�����'
	WHERE TNL_ToDealer_DMA_ID IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr

	UPDATE TransferNote SET TNL_ProblemDescription = (CASE WHEN TNL_ProblemDescription IS NULL THEN '' ELSE TNL_ProblemDescription + ',' END) + N'����ֿⲻ����'
	WHERE TNL_FromWarehouse_WHM_ID IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr

	UPDATE TransferNote SET TNL_ProblemDescription = (CASE WHEN TNL_ProblemDescription IS NULL THEN '' ELSE TNL_ProblemDescription + ',' END) + N'����ֿⲻ����'
	WHERE TNL_ToWarehouse_WHM_ID IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr

	UPDATE TransferNote SET TNL_ProblemDescription = (CASE WHEN TNL_ProblemDescription IS NULL THEN '' ELSE TNL_ProblemDescription + ',' END) + N'��Ʒ�ͺŲ�����(' + ISNULL(TNL_BatchNbr,'') + ';UPN��' + ISNULL(TNL_ArticleNumber,'') + ';LOT:' + ISNULL(TNL_LotNumber,'')+')'
	WHERE TNL_CFN_ID IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr

	UPDATE TransferNote SET TNL_ProblemDescription = (CASE WHEN TNL_ProblemDescription IS NULL THEN '' ELSE TNL_ProblemDescription + ',' END) + N'��Ʒδ������Ʒ��'
	WHERE TNL_CFN_ID IS NOT NULL AND TNL_BUM_ID IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr

	--Added By Song Yuqi On 2016-06-12 Begin
	--У�鷢��������Ȩ
	CREATE TABLE #AuthTemp
	(
		DealerId UNIQUEIDENTIFIER,
		BumId UNIQUEIDENTIFIER,
		AuthCount INT
	)

	INSERT INTO #AuthTemp
	SELECT DAT_DMA_ID,DAT_ProductLine_BUM_ID,COUNT(1) FROM DealerAuthorizationTable 
	WHERE EXISTS(
		SELECT TNL_FromDealer_DMA_ID,TNL_BUM_ID FROM TransferNote
		WHERE TNL_CFN_ID IS NOT NULL 
		AND TNL_BUM_ID IS NOT NULL 
		AND TNL_FromDealer_DMA_ID IS NOT NULL
		AND TNL_BatchNbr = @BatchNbr
		AND DAT_DMA_ID = TNL_FromDealer_DMA_ID
		AND DAT_ProductLine_BUM_ID = TNL_BUM_ID
	)
	AND DAT_Type = 'Transfer'
	GROUP BY DAT_DMA_ID,DAT_ProductLine_BUM_ID
	
	UPDATE TransferNote SET TNL_ProblemDescription = (CASE WHEN TNL_ProblemDescription IS NULL THEN '' ELSE TNL_ProblemDescription + ',' END) + N'��Ȩδͨ��' 
	FROM CFN
            WHERE TNL_CFN_ID IS NOT NULL 
			AND TNL_BUM_ID IS NOT NULL 
			AND TNL_FromDealer_DMA_ID IS NOT NULL
			AND TNL_BatchNbr = @BatchNbr
			AND TNL_CFN_ID = CFN_ID
            AND NOT EXISTS(
				SELECT 1 FROM DealerAuthorizationTable
				INNER JOIN Cache_PartsClassificationRec ON PCT_ProductLine_BUM_ID = DAT_ProductLine_BUM_ID
				INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
				
				WHERE DAT_PMA_ID != DAT_ProductLine_BUM_ID
				AND DAT_DMA_ID = TNL_FromDealer_DMA_ID
				AND DAT_ProductLine_BUM_ID = TNL_BUM_ID
				AND PCT_ParentClassification_PCT_ID = DAT_PMA_ID
				AND PCT_ID = CCF.ClassificationId
				AND CFN_DeletedFlag = 0
				AND ((DAT_Type = 'Transfer' AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
						OR (ISNULL((SELECT AuthCount FROM #AuthTemp WHERE BumId = DAT_ProductLine_BUM_ID AND DealerId = DAT_DMA_ID),0) = 0 
						AND (DAT_Type IN ('Normal','Temp') AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DATEADD(DAY,-1 * DATEPART(DAY,DATEADD(MONTH,2,DAT_EndDate)),DATEADD(MONTH,2,DAT_EndDate)),DATEADD(DAY,-1,GETDATE())))
					)
				)
				UNION
				SELECT 1 FROM DealerAuthorizationTable
				INNER JOIN Cache_PartsClassificationRec ON PCT_ProductLine_BUM_ID = DAT_ProductLine_BUM_ID
				INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
				WHERE DAT_PMA_ID = DAT_ProductLine_BUM_ID
				AND DAT_DMA_ID = TNL_FromDealer_DMA_ID
				AND DAT_ProductLine_BUM_ID = TNL_BUM_ID
				AND DAT_PMA_ID = PCT_ProductLine_BUM_ID
				AND PCT_ID = CCF.ClassificationId
				AND CFN_DeletedFlag = 0
				AND ((DAT_Type = 'Transfer' AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
						OR (ISNULL((SELECT AuthCount FROM #AuthTemp WHERE BumId = DAT_ProductLine_BUM_ID AND DealerId = DAT_DMA_ID),0) = 0 
						AND (DAT_Type IN ('Normal','Temp') AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DATEADD(DAY,-1 * DATEPART(DAY,DATEADD(MONTH,2,DAT_EndDate)),DATEADD(MONTH,2,DAT_EndDate)),DATEADD(DAY,-1,GETDATE())))
					)
				)
            )
  --Added By Song Yuqi On 2016-06-12 End

  --���UPN + LOT����Ƿ����
  Update TN set TNL_ProblemDescription = (CASE WHEN TNL_ProblemDescription IS NULL THEN '' ELSE TNL_ProblemDescription + ',' END) + N'UPN + LOT��ϲ�����' 
  from TransferNote TN 
  where NOt exists (select 1 from LotMaster LM where CASE WHEN charindex('@@',TN.TNL_LotNumber ) > 0 
                      THEN substring(TN.TNL_LotNumber,1,charindex('@@',TN.TNL_LotNumber)-1) + '@@NoQR' 
                      ELSE TN.TNL_LotNumber + '@@NoQR'
                      END  = LM.LTM_LotNumber and LM.LTM_Product_PMA_ID= TN.TNL_PMA_ID )
    and not EXISTS (select 1 from LotMaster LM 
                     where TN.TNL_LotNumber = LM.LTM_LotNumber and LM.LTM_Product_PMA_ID= TN.TNL_PMA_ID)
    and TN.TNL_BatchNbr =@BatchNbr
    and TN.TNL_TransferType = 'Out'
    and TN.TNL_ProblemDescription is null
    
	
	--��Ʒ���κŲ�����  ,, 
--	UPDATE TransferNote 
--	SET TNL_ProblemDescription = (CASE WHEN TNL_ProblemDescription IS NULL THEN '' ELSE TNL_ProblemDescription + ',' END) + N'��Ʒ���κŲ�����(' + ISNULL(TNL_BatchNbr,'') + ';UPN��' + ISNULL(TNL_ArticleNumber,'') + ';LOT:' + ISNULL(TNL_LotNumber,'')+')'
--	WHERE TNL_PMA_ID IS NOT NULL AND TNL_LTM_ID IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr

	--���ü�����Ƿ���ϣ����������ۼ��ɸ�����Edit By Weiming on 2016-04-22
--	SELECT TNL_WHM_ID,TNL_PMA_ID,TNL_LTM_ID,SUM(TNL_LotTransferQty) AS TNL_LotTransferQty, 0 AS LOT_OnHandQty 
--	INTO #tmp_lot_qty
--	FROM (SELECT TNL_FromWarehouse_WHM_ID as TNL_WHM_ID,TNL_PMA_ID,TNL_LTM_ID,TNL_LotTransferQty
--	FROM TransferNote
--	WHERE TNL_ProblemDescription IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr	
--	AND TNL_TransferType = 'Out'
--	UNION ALL
--	SELECT TNL_ToWarehouse_WHM_ID as TNL_WHM_ID,TNL_PMA_ID,TNL_LTM_ID,-TNL_LotTransferQty
--	FROM TransferNote
--	WHERE TNL_ProblemDescription IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr	
--	AND TNL_TransferType = 'In') AS T
--	GROUP BY TNL_WHM_ID,TNL_PMA_ID,TNL_LTM_ID

	--UPDATE TransferNote SET TNL_ProblemDescription = N'�����β�Ʒ�ڲֿ�����������'
	--FROM #tmp_lot_qty AS T
	--WHERE TransferNote.TNL_ProblemDescription IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr
	--AND T.TNL_WHM_ID = (CASE TNL_TransferType WHEN 'Out' THEN TransferNote.TNL_FromWarehouse_WHM_ID ELSE TransferNote.TNL_ToWarehouse_WHM_ID END)
	--AND T.TNL_PMA_ID = TransferNote.TNL_PMA_ID 
	--AND T.TNL_LTM_ID = TransferNote.TNL_LTM_ID
	--AND T.LOT_OnHandQty - T.TNL_LotTransferQty < 0

	--DELETE FROM #tmp_lot_qty WHERE LOT_OnHandQty - TNL_LotTransferQty < 0
	
	declare @cnt int;
	select @cnt = COUNT(*) from TransferNote where TNL_ProblemDescription IS NOT NULL AND TNL_BatchNbr = @BatchNbr

	IF(@cnt = 0)
	BEGIN
		--ƽ̨����п���û�ж�Ӧ�Ķ�ά���Ʒ��棬������Ҫд�벻���ڵĶ�ά��LotMaster
    CREATE TABLE #TmpLotMaster
    (
       [LTM_InitialQty]       FLOAT NULL,
       [LTM_ExpiredDate]      DATETIME NULL,
       [LTM_LotNumber]        NVARCHAR (50) NOT NULL,
       [LTM_ID]               UNIQUEIDENTIFIER NOT NULL,
       [LTM_CreatedDate]      DATETIME NOT NULL,
       [LTM_PRL_ID]           UNIQUEIDENTIFIER NULL,
       [LTM_Product_PMA_ID]   UNIQUEIDENTIFIER NULL,
       [LTM_Type]             NVARCHAR (30) NULL,
       [LTM_RelationID]       UNIQUEIDENTIFIER NULL
    )

    INSERT INTO #TmpLotMaster
       SELECT 1,
              NULL,
              TN.TNL_LotNumber,
              newid (),
              getdate (),
              NULL,
              TN.TNL_PMA_ID,
              NULL,
              NULL
         FROM TransferNote TN
        WHERE TN.TNL_BatchNbr = @BatchNbr
       GROUP BY TN.TNL_PMA_ID, TN.TNL_LotNumber



    UPDATE TLM
       SET TLM.LTM_ExpiredDate = LM.LTM_ExpiredDate, TLM.LTM_Type = LM.LTM_Type
      FROM #TmpLotMaster TLM, LotMaster LM
     WHERE     TLM.LTM_Product_PMA_ID = LM.LTM_Product_PMA_ID
           AND CASE
                  WHEN charindex ('@@', TLM.LTM_LotNumber) > 0
                  THEN substring (TLM.LTM_LotNumber,1,charindex ('@@', TLM.LTM_LotNumber) - 1) + '@@NoQR'
                  ELSE TLM.LTM_LotNumber + '@@NoQR'
                  END = LM.LTM_LotNumber

    INSERT INTO LotMaster
       SELECT *
         FROM #TmpLotMaster TLM
        WHERE NOT EXISTS
                 (SELECT 1
                    FROM LotMaster LM
                   WHERE     TLM.LTM_Product_PMA_ID = LM.LTM_Product_PMA_ID
                         AND TLM.LTM_LotNumber = LM.LTM_LotNumber)
    
    --����LTM_ID����ȡƥ��Ķ�ά�룬����ʹ��NoQR�����߼����д���
      UPDATE TransferNote
			   SET TransferNote.TNL_LTM_ID = LM.LTM_ID
			  FROM LotMaster LM
			 WHERE LM.LTM_LotNumber = TNL_LotNumber 
			   AND LM.LTM_Product_PMA_ID = TransferNote.TNL_PMA_ID
			   AND TransferNote.TNL_BatchNbr = @BatchNbr
    
    	SELECT TNL_WHM_ID,TNL_PMA_ID,TNL_LTM_ID,SUM(TNL_LotTransferQty) AS TNL_LotTransferQty, 0 AS LOT_OnHandQty 
      	INTO #tmp_lot_qty
      	FROM (SELECT TNL_FromWarehouse_WHM_ID as TNL_WHM_ID,TNL_PMA_ID,TNL_LTM_ID,TNL_LotTransferQty
      	FROM TransferNote
      	WHERE TNL_ProblemDescription IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr	
      	AND TNL_TransferType = 'Out'
      	UNION ALL
      	SELECT TNL_ToWarehouse_WHM_ID as TNL_WHM_ID,TNL_PMA_ID,TNL_LTM_ID,-TNL_LotTransferQty
      	FROM TransferNote
      	WHERE TNL_ProblemDescription IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr	
      	AND TNL_TransferType = 'In') AS T
      	GROUP BY TNL_WHM_ID,TNL_PMA_ID,TNL_LTM_ID
    
    
    --��ѯ��ǰ�����
--  	SELECT INV.INV_WHM_ID,
--         INV.INV_PMA_ID,
--         Lot.LOT_LTM_ID,
--         Lot.LOT_OnHandQty
--    INTO #tmp_lot_cur
--    FROM Lot INNER JOIN Inventory INV ON Lot.LOT_INV_ID = INV.INV_ID
--   WHERE EXISTS
--            (SELECT 1
--               FROM TransferNote
--              WHERE     TNL_PMA_ID = INV.INV_PMA_ID
--                    AND (CASE TNL_TransferType
--                            WHEN 'Out' THEN TNL_FromWarehouse_WHM_ID
--                            ELSE TNL_ToWarehouse_WHM_ID
--                         END) = INV.INV_WHM_ID
--                    AND TNL_LTM_ID = LOT.LOT_LTM_ID
--                    AND TNL_ProblemDescription IS NULL
--                    AND TNL_BatchNbr = @BatchNbr)


  --���µ�ǰ�����
--  UPDATE #tmp_lot_qty
--     SET #tmp_lot_qty.LOT_OnHandQty = #tmp_lot_cur.LOT_OnHandQty
--    FROM #tmp_lot_cur
--   WHERE     INV_WHM_ID = TNL_WHM_ID
--         AND INV_PMA_ID = TNL_PMA_ID
--         AND LOT_LTM_ID = TNL_LTM_ID
    
    
    --������
		/*�����ʱ��*/
		create table #tmp_inventory(
		INV_ID uniqueidentifier,
		INV_WHM_ID uniqueidentifier,
		INV_PMA_ID uniqueidentifier,
		INV_OnHandQuantity float
		primary key (INV_ID)
		)

		/*�����ϸLot��ʱ��*/
		create table #tmp_lot(
		LOT_ID uniqueidentifier,
		LOT_LTM_ID uniqueidentifier,
		LOT_WHM_ID uniqueidentifier,
		LOT_PMA_ID uniqueidentifier,
		LOT_INV_ID uniqueidentifier,
		LOT_OnHandQty float,
		LOT_LotNumber nvarchar(50),
		primary key (LOT_ID)
		)

		--Inventory��
		INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
		SELECT -A.QTY,NEWID(),A.TNL_WHM_ID,A.TNL_PMA_ID
		FROM 
		(SELECT TNL_WHM_ID,TNL_PMA_ID,SUM(TNL_LotTransferQty) AS QTY 
		FROM #tmp_lot_qty	
		GROUP BY TNL_WHM_ID,TNL_PMA_ID) AS A

		--ƽ̨�����һ�������̣���Ҫ����һ�������̵�Ĭ�Ͽ�
		INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
		SELECT A.QTY,NEWID(),A.TNL_ToWarehouse_WHM_ID,A.TNL_PMA_ID
		FROM 
		(SELECT TNL_ToWarehouse_WHM_ID,TNL_PMA_ID,SUM(TNL_LotTransferQty) AS QTY 
		FROM TransferNote
		WHERE TNL_ProblemDescription IS NULL AND TNL_BatchNbr = @BatchNbr
		AND TNL_TransferType = 'Out' and TNL_ToDealerType  in ('T1','T2')
		GROUP BY TNL_ToWarehouse_WHM_ID,TNL_PMA_ID) AS A

		--���¿������ڵĸ��£������ڵ�����
		UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)+Convert(decimal(18,6),TMP.INV_OnHandQuantity)
		FROM #tmp_inventory AS TMP
		WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
		AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID

		INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)	
		SELECT INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID
		FROM #tmp_inventory AS TMP	
		WHERE NOT EXISTS (SELECT 1 FROM Inventory INV WHERE INV.INV_WHM_ID = TMP.INV_WHM_ID
		AND INV.INV_PMA_ID = TMP.INV_PMA_ID)	

		--Lot��
		INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
		SELECT NEWID(),A.TNL_LTM_ID,A.TNL_WHM_ID,A.TNL_PMA_ID,A.LTM_LotNumber,-A.QTY
		FROM 
		(SELECT TNL_WHM_ID,TNL_PMA_ID,TNL_LTM_ID,LM.LTM_LotNumber,SUM(TNL_LotTransferQty) AS QTY 
		FROM #tmp_lot_qty 
		INNER JOIN LotMaster LM on LM.LTM_ID = TNL_LTM_ID
		GROUP BY TNL_WHM_ID,TNL_PMA_ID,TNL_LTM_ID,LM.LTM_LotNumber) AS A

		--ƽ̨�����һ�������̣���Ҫ����һ�������̵�Ĭ�Ͽ�
		INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
		SELECT NEWID(),A.TNL_LTM_ID,A.TNL_ToWarehouse_WHM_ID,A.TNL_PMA_ID,A.TNL_LotNumber,A.QTY
		FROM 
		(SELECT TNL_ToWarehouse_WHM_ID,TNL_PMA_ID,TNL_LTM_ID,TNL_LotNumber,SUM(TNL_LotTransferQty) AS QTY 
		FROM TransferNote
		WHERE TNL_ProblemDescription IS NULL AND TNL_BatchNbr = @BatchNbr
		AND TNL_TransferType = 'Out' and TNL_ToDealerType  in ('T1','T2')	
		GROUP BY TNL_ToWarehouse_WHM_ID,TNL_PMA_ID,TNL_LTM_ID,TNL_LotNumber) AS A
		
		--���¹����������
		UPDATE #tmp_lot SET LOT_INV_ID = INV.INV_ID
		FROM Inventory INV 
		WHERE INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
		AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

		--�������α����ڵĸ��£������ڵ�����
		UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,6),Lot.LOT_OnHandQty)+Convert(decimal(18,6),TMP.LOT_OnHandQty)
		FROM #tmp_lot AS TMP
		WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
		AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

		INSERT INTO Lot (LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
		SELECT LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID 
		FROM #tmp_lot AS TMP
		WHERE NOT EXISTS (SELECT 1 FROM Lot WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
		AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)

		--����ƽ̨������ⵥ
		exec dbo.GC_Interface_Transfer_Out @BatchNbr

		--����ƽ̨�����ⵥ��һ�������̽����ⵥ
		exec dbo.GC_Interface_Transfer_In @BatchNbr
	
	END
	
COMMIT TRAN	
	
SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
	
	--��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH

GO


