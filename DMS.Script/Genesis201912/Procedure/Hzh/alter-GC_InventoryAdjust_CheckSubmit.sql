SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


ALTER proc [dbo].[GC_InventoryAdjust_CheckSubmit]
   (@IAHID uniqueidentifier,
    @AdjustType NVARCHAR(50),
    @RtnRegMsg NVARCHAR(2000) OUTPUT,
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
    )
 AS
 
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

SET @RtnRegMsg = ''

--创建其他出入库临时表
CREATE TABLE #InventoryAdjustLot(
 IAL_ID uniqueidentifier,
 CFN NVARCHAR(200) collate Chinese_PRC_CI_AS,
 IAL_LTM_Lot NVARCHAR(50) collate Chinese_PRC_CI_AS,
 QRCode NVARCHAR(50) collate Chinese_PRC_CI_AS,
 QRCodeEdit NVARCHAR(50) collate Chinese_PRC_CI_AS,
 AdjustQty float,
 Messinge NVARCHAR(500) collate Chinese_PRC_CI_AS,
)
--创建填写正确的明细表
CREATE TABLE #CorrectInventoryAdjustLot(
 IAL_ID uniqueidentifier,
 CFN NVARCHAR(200) collate Chinese_PRC_CI_AS,
 LotNumber NVARCHAR(50) collate Chinese_PRC_CI_AS,
 QRCode NVARCHAR(50) collate Chinese_PRC_CI_AS,
 QRCodeEdit NVARCHAR(50) collate Chinese_PRC_CI_AS,
 AdjustQty float
)
 --IF(@AdjustType='StockIn')
 ----如果是入库操作要校验批次号是否填写正确
 --BEGIN
 --将明细数据写入临时表
 INSERT INTO #InventoryAdjustLot
      SELECT InventoryAdjustLot.IAL_ID,
      CFN.CFN_CustomerFaceNbr AS CFN,
      InventoryAdjustLot.IAL_Lot AS LotNumber,
      InventoryAdjustLot.IAL_QRCode  as  QRCode,
	  case when isnull(IAL_QRLotNumber,'') = '' then '' else substring(IAL_QRLotNumber,CHARINDEX('@@',IAL_QRLotNumber,0)+2,LEN(IAL_QRLotNumber)-CHARINDEX('@@',IAL_QRLotNumber,0)) end AS QRCodeEdit,
      InventoryAdjustLot.IAL_LotQty AS AdjustQty,''
      FROM InventoryAdjustLot
      INNER JOIN InventoryAdjustDetail ON InventoryAdjustLot.IAL_IAD_ID = InventoryAdjustDetail.IAD_ID
      INNER JOIN Product ON InventoryAdjustDetail.IAD_PMA_ID = Product.PMA_ID
      INNER JOIN CFN ON Product.PMA_CFN_ID = CFN.CFN_ID
      INNER JOIN Warehouse ON InventoryAdjustLot.IAL_WHM_ID = Warehouse.WHM_ID
      LEFT OUTER JOIN Lot ON InventoryAdjustLot.IAL_LOT_ID = Lot.LOT_ID
      WHERE IAD_IAH_ID=@IAHID

    --将空格替换为null方便后面判断  
   UPDATE #InventoryAdjustLot SET QRCode =NULL   WHERE QRCode=''
   UPDATE #InventoryAdjustLot SET QRCodeEdit=NULL WHERE QRCodeEdit=''
      IF(@AdjustType='StockIn')
     --入库要校验批次
      BEGIN
  --将填写正确的数据写入明细表
       INSERT INTO #CorrectInventoryAdjustLot
      SELECT IAL_ID,CFN,IAL_LTM_Lot,QRCode,QRCodeEdit,AdjustQty FROM ( SELECT  #InventoryAdjustLot.* FROM  (
       SELECT CASE WHEN CHARINDEX('@@', LTM_LotNumber, 0) > 0 THEN substring(LTM_LotNumber, 1, CHARINDEX('@@', LTM_LotNumber,
      0) - 1) ELSE LTM_LotNumber END AS LOT,
      CFN.CFN_CustomerFaceNbr, LTM_InitialQty AS InitialQty
	  ,LTM_ExpiredDate AS ExpiredDate
	  ,LTM_LotNumber AS LotNumber
	  ,LTM_ID AS Id
	  ,LTM_CreatedDate AS CreateDate
	  ,LTM_PRL_ID AS PrlId
	  ,LTM_Product_PMA_ID AS ProductPmaId
	  ,LTM_Type AS Type
	  ,LTM_RelationID AS Relationid
      FROM LotMaster,product,cfn
      WHERE LTM_Product_PMA_ID = PMA_ID
      and PMA_CFN_ID = CFN_ID)DT INNER JOIN #InventoryAdjustLot
      ON #InventoryAdjustLot.CFN=DT.CFN_CustomerFaceNbr
      AND DT.LOT =#InventoryAdjustLot.IAL_LTM_Lot
     )T GROUP BY IAL_ID,CFN,IAL_LTM_Lot,QRCode,QRCodeEdit,AdjustQty
    --检查是否填写了批次
      UPDATE #InventoryAdjustLot SET Messinge='产品:'+CFN+'批次号未填写'
      WHERE (IAL_LTM_Lot IS NULL OR IAL_LTM_Lot='')
      AND Messinge=''

	--  select  * from #InventoryAdjustLot  where IAL_ID='17C54636-26DD-4C32-9737-181A4F498B56'
    --对比筛选出填写错误的批次
       UPDATE #InventoryAdjustLot SET Messinge='批次号:'+IAL_LTM_Lot+'填写错误;'
       WHERE Not EXISTS(SELECT 1 FROM #CorrectInventoryAdjustLot WHERE #InventoryAdjustLot.IAL_ID=#CorrectInventoryAdjustLot.IAL_ID)
       AND Messinge='' 
   
		--只有当入库是才校验二维码信息
		--检查是否填写了二维码
		UPDATE #InventoryAdjustLot SET Messinge='产品:'+CFN+'二维码未填写;'
		WHERE (ISNULL(QRCodeEdit,QRCode) IS NULL OR ISNULL(QRCodeEdit,QRCode)='' )--OR ISNULL(QRCodeEdit,QRCode)='NoQR')  
		 AND ISNULL(QRCodeEdit,QRCode)<>'NoQR'
		AND Messinge=''
		--筛选出填写错误的二维码
		UPDATE #InventoryAdjustLot SET Messinge='二维码:'+QRCodeEdit+'填写错误;'
		WHERE NOT EXISTS(SELECT 1 FROM QRCodeMaster WHERE ISNULL(#InventoryAdjustLot.QRCodeEdit,#InventoryAdjustLot.QRCode)=QRCodeMaster.QRM_QRCode)
		AND ISNULL(QRCodeEdit,QRCode)<>'NoQR'
		AND Messinge=''
		--校验二维码是否重复
	   UPDATE #InventoryAdjustLot SET Messinge='二维码:'+ISNULL(QRCodeEdit,QRCode)+'重复填写;'
	   WHERE EXISTS(SELECT 1 FROM(SELECT ISNULL(QRCodeEdit,QRCode) AS Code FROM  
	   #InventoryAdjustLot)T GROUP BY Code HAVING COUNT(Code)>1 AND 
	   (#InventoryAdjustLot.QRCode=T.Code OR #InventoryAdjustLot.QRCodeEdit=T.Code) AND T.Code<>'NoQR' )
	   AND Messinge=''
    END
     --select @RtnMessing=(select  Messinge as M FROM #InventoryAdjustLot WHERE #InventoryAdjustLot.Messinge !=''  order by LotNumber FOR XML PATH(''))
  IF EXISTS (SELECT 1 FROM #InventoryAdjustLot WHERE  #InventoryAdjustLot.Messinge !='')
			BEGIN
				--拼接警告信息
				
				SET @RtnRegMsg = (SELECT Messinge + ',' FROM #InventoryAdjustLot WHERE #InventoryAdjustLot.Messinge !='' ORDER BY IAL_LTM_Lot FOR XML PATH(''))
			END
 IF @RtnRegMsg<>''
   BEGIN
    SET @IsValid = 'Error'
   END
 --end
ELSE	
 BEGIN
  SET @IsValid = 'Success'
 END


COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
    
    --记录错误日志开始
	
	
	return -1
END CATCH





GO

