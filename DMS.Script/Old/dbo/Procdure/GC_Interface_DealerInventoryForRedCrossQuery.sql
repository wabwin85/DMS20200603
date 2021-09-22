DROP procedure [dbo].[GC_Interface_DealerInventoryForRedCrossQuery]
GO

CREATE procedure [dbo].[GC_Interface_DealerInventoryForRedCrossQuery]
(
	@DealerCode nvarchar(20),
	@QrCode nvarchar(max),
  @UPN nvarchar(MAX)
)
as

BEGIN

create table #tmp_result
(
	DealerCode nvarchar(20) null,
  DealerName nvarchar(200) null,
  MerchandiseID nvarchar(50) null,
  MerchandiseName nvarchar(100) null, 
	UPN nvarchar(50) null,
	LOT nvarchar(50) null,
	QRCode nvarchar(50) null,  
	GTIN nvarchar(50) null,
  Qty decimal(18,2) null,
  CR int null,
	ExpDate nvarchar(10) null,
	DOM nvarchar(10) null,
	IsQRUsable nvarchar(20) null,
	Remark nvarchar(2000) null,
	WHMType nvarchar(20) null
)

create table #tmp_QueryData
(
	DealerCode nvarchar(20) null, 
	UPN nvarchar(50) null,
	QRCode nvarchar(50) null
)

IF (@QrCode ='' OR @QrCode is NULL) 
  BEGIN 
    --������ڶ��UPN����ָ��ɶ���д���м��
    INSERT INTO #tmp_QueryData(DealerCode,UPN)
    SELECT @DealerCode,* 
      FROM dbo.GC_Fn_SplitStringToTable(@UPN,',')
  END
ELSE
  BEGIN
    --������ڶ����ά�룬��ָ��ɶ���д���м��
    INSERT INTO #tmp_QueryData(DealerCode,QRCode)
    SELECT @DealerCode,* 
      FROM dbo.GC_Fn_SplitStringToTable(@QrCode,',')
  END


--���Ҿ��������ֿ�ͼ��ۿ⣬��������
IF (@QrCode ='' OR @QrCode is NULL) 
  BEGIN
    --����UPN����ѯ���������Ŀ����Ϣ
    INSERT INTO #tmp_result
    SELECT 
          DM.DMA_SAP_Code As DealerCode,
          DM.DMA_ChineseName AS DealerName,
          '' AS MerchandiseID,
          C.CFN_ChineseName AS MerchandiseName,
          P.PMA_UPN AS UPN,
          LM.LTM_LotNumber As LOT, 
          LM.LTM_QrCode AS QRCode,
          C.CFN_Property7 AS GTIN,
          LT.LOT_OnHandQty AS Qty,
          P.PMA_ConvertFactor AS CR,
      	  CONVERT(nvarchar(10),LM.LTM_ExpiredDate,112) AS ExpDate,
      	  LM.LTM_Type AS DOM,
          'Active' As IsQRUsable,
          '' AS Remark,
          WH.WHM_Type AS WHMType                    
     FROM #tmp_QueryData A 
        INNER JOIN CFN AS C(nolock) ON C.CFN_CustomerFaceNbr = A.UPN
        INNER JOIN Product AS P(nolock) ON P.PMA_CFN_ID = C.CFN_ID
        INNER JOIN Inventory AS Inv(nolock) ON Inv.INV_PMA_ID = P.PMA_ID
        INNER JOIN Lot AS LT(nolock) ON LT.LOT_INV_ID = Inv.INV_ID
        INNER JOIN V_LotMaster AS LM(nolock) ON (LM.LTM_ID = LT.LOT_LTM_ID)
        INNER JOIN Warehouse AS WH(nolock)  ON (WH.WHM_ID = Inv.Inv_WHM_ID)
        INNER JOIN DealerMaster AS DM(nolock)  ON (DM.DMA_ID = WH.WHM_DMA_ID)
      WHERE LOT_OnHandQty >= 0
        AND DM.DMA_SAP_Code = @DealerCode
    
    --д��û��ƥ�������
    INSERT INTO  #tmp_result(DealerCode,UPN,IsQRUsable)
    SELECT t1.DealerCode,t1.UPN,'Error'
      FROM #tmp_QueryData t1
     LEFT JOIN #tmp_result t2 ON (t1.DealerCode = t2.DealerCode and t1.UPN = t2.UPN)
     WHERE t2.UPN IS NULL
    
    --���´�����Ϣ
    UPDATE t1 set t1.Remark ='�����̱�Ų���ȷ'
    FROM #tmp_result t1
    LEFT JOIN DealerMaster t2 on t1.DealerCode = t2.DMA_SAP_Code
    WHERE t2.DMA_ID IS NULL
     AND t1.IsQRUsable = 'Error'
    
    UPDATE t1 SET Remark = 'UPN����ȷ'
      FROM #tmp_result t1 LEFT JOIN CFN C ON (t1.UPN = C.CFN_CustomerFaceNbr )
     WHERE C.CFN_ID IS NULL
      AND t1.IsQRUsable = 'Error'
      AND (Remark ='' OR Remark IS NULL)

    UPDATE #tmp_result
       SET Remark = 'û�п��'
     WHERE isnull(Qty, 0) = 0
       AND IsQRUsable = 'Error'
       AND (Remark ='' OR Remark IS NULL)

    UPDATE #tmp_result
       SET IsQRUsable = 'Error', Remark = '��治����'
     WHERE WHMType IN ('Normal', 'SystemHold','Frozen')  
      AND (Remark ='' OR Remark IS NULL)


   
  END
ELSE
  BEGIN
    
    --����UPN����ѯ���������Ŀ����Ϣ
    INSERT INTO #tmp_result
    SELECT 
          DM.DMA_SAP_Code As DealerCode,
          DM.DMA_ChineseName AS DealerName,
          '' AS MerchandiseID,
          C.CFN_ChineseName AS MerchandiseName,
          P.PMA_UPN AS UPN,
          LM.LTM_LotNumber As LOT, --substring(LM.LTM_LotNumber,1,charindex('@',LM.LTM_LotNumber)-1) AS LOT,
          LM.LTM_QrCode AS QRCode,
          C.CFN_Property7 AS GTIN,
          LT.LOT_OnHandQty AS Qty,
          P.PMA_ConvertFactor AS CR,
      	  CONVERT(nvarchar(10),LM.LTM_ExpiredDate,112) AS ExpDate,
      	  LM.LTM_Type AS DOM,
          'Active' As IsQRUsable,
          '' AS Remark,
          WH.WHM_Type AS WHMType                    
     FROM #tmp_QueryData A 
        INNER JOIN V_LotMaster(nolock) LM ON (LM.LTM_QrCode = A.QRCode)
        INNER JOIN Lot(nolock) LT ON LM.LTM_ID = LT.LOT_LTM_ID
        INNER JOIN Inventory(nolock) Inv ON LT.LOT_INV_ID = Inv.INV_ID
        INNER JOIN Product(nolock) P ON Inv.INV_PMA_ID = P.PMA_ID        
        INNER JOIN CFN(nolock) C ON P.PMA_CFN_ID = C.CFN_ID
        INNER JOIN Warehouse(nolock) WH ON (WH.WHM_ID = Inv.Inv_WHM_ID)
        INNER JOIN DealerMaster(nolock) DM ON (DM.DMA_ID = WH.WHM_DMA_ID)
      WHERE LOT_OnHandQty > 0
        AND DM.DMA_SAP_Code = @DealerCode
    
    --д��û��ƥ�������
    INSERT INTO  #tmp_result(DealerCode,QRCode,IsQRUsable)
    SELECT t1.DealerCode,t1.UPN,'Error'
      FROM #tmp_QueryData t1
     LEFT JOIN #tmp_result t2 ON (t1.DealerCode = t2.DealerCode and t1.QRCode = t2.QRCode)
     WHERE t2.QRCode IS NULL
    
    --���´�����Ϣ
    UPDATE t1 set t1.Remark ='�����̱�Ų���ȷ'
      FROM #tmp_result t1
      LEFT JOIN DealerMaster t2 on t1.DealerCode = t2.DMA_SAP_Code
     WHERE t2.DMA_ID IS NULL
       AND t1.IsQRUsable = 'Error'
    
    UPDATE t1 SET Remark = '��ά�벻��ȷ��û�д˶�ά����'
      FROM #tmp_result t1 LEFT JOIN V_LotMaster LM ON (t1.QRCode = LM.LTM_QRCode )
     WHERE LM.LTM_ID IS NULL
      AND t1.IsQRUsable = 'Error'
      AND (t1.Remark ='' OR t1.Remark IS NULL)
    
    UPDATE #tmp_result
       SET Remark = 'û�п��'
     WHERE isnull(Qty, 0) = 0      
       AND (Remark ='' OR Remark IS NULL)
       
    UPDATE #tmp_result
       SET IsQRUsable = 'Error', Remark = '��治����'
     WHERE WHMType IN ('Normal', 'SystemHold','Frozen')      
       AND (Remark ='' OR Remark IS NULL)
   
  END


SELECT DealerCode AS SupplyID,
       isnull (DealerName , '') AS SupplyName,
       isnull (MerchandiseID, '') AS MerchandiseID,
       isnull (MerchandiseName,'') AS MerchandiseName,       
       isnull (UPN, '') AS UPN,
       isnull (LOT, '') AS LOT,
       isnull (QRCode, '') AS QRCode,
       isnull (GTIN, '') AS GTIN,
       Convert(nvarchar(20),isnull (Qty, 0)) AS Qty,
       Convert(nvarchar(10),isnull (CR, 0)) As CR, 
       isnull (ExpDate, '') AS ExpDate,
       isnull (DOM, '') AS DOM,
       isnull (IsQRUsable, '') AS IsQRUsable,
       isnull (Remark, '') AS Remark,
       isnull (WHMType, '') AS WHMType
  FROM #tmp_result

END
GO


