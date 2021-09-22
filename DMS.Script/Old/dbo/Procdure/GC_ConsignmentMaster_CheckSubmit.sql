DROP Procedure [dbo].[GC_ConsignmentMaster_CheckSubmit]
GO

CREATE Procedure [dbo].[GC_ConsignmentMaster_CheckSubmit]
  @CM_ID uniqueidentifier,
  @ProductLineId uniqueidentifier,
  @NAme  NVARCHAR(200),
  @RtnVal NVARCHAR(20) OUTPUT,
  @RtnMsg NVARCHAR(1000) OUTPUT,
  @RtnRegMsg NVARCHAR(1000) OUTPUT
AS
    DECLARE @ErrorCount INTEGER
	
	CREATE TABLE #TMP_CHECK(
		CfnId uniqueidentifier,
		ArticleNumber NVARCHAR(30),
		CfnQty decimal(18,6),
		CfnAmount decimal(18,6),
		ErrorDesc NVARCHAR(50),
		IsReg bit,
		PRIMARY KEY (CfnId)
	)
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = '1'
	SET @RtnRegMsg = '2'
	
	BEGIN
	IF EXISTS (SELECT 1 FROM ConsignmentCfn WHERE CC_CM_ID = @CM_ID)
		BEGIN
			INSERT INTO #TMP_CHECK
			SELECT C.CFN_ID,C.CFN_CustomerFaceNbr,CcFN.CC_Qty,CcFN.CC_Amount,NULL,NULL  FROM
			ConsignmentMaster AS Mast INNER JOIN ConsignmentCfn AS CcFN ON Mast.CM_ID=CcFN.CC_CM_ID
            INNER JOIN CFN AS C ON CcFN.CC_CFN_ID=C.CFN_ID WHERE Mast.CM_ID=@CM_ID AND Mast.CM_ProductLine_Id=@ProductLineId
			ORDER BY C.CFN_CustomerFaceNbr 
			
			--检查是否可订购
			
			UPDATE #TMP_CHECK SET ErrorDesc = ArticleNumber + '不可订购'
			WHERE ErrorDesc IS NULL AND (SELECT CFN_DeletedFlag FROM CFN WHERE CFN_ID=CfnId AND CFN_DeletedFlag<>0)=0
			
			--检查订购数量和金额是否大于0
			--UPDATE #TMP_CHECK SET ErrorDesc = ArticleNumber + '订购数量与金额必须大于0'
			--WHERE ErrorDesc IS NULL AND (CfnQty <= 0 OR CfnAmount <=0)
			--拼接错误信息
			SET @RtnMsg = ISNULL((SELECT ErrorDesc + ',' FROM #TMP_CHECK WHERE ErrorDesc IS NOT NULL ORDER BY ArticleNumber FOR XML PATH('')),'')
		END
	ELSE
		SET @RtnMsg = '请添加产品'
	END	
	
	--检查经销商
	IF ((SELECT COUNT(*) FROM ConsignmentMaster Mast INNER JOIN ConsignmentDealer Dealer ON Mast.CM_ID=Dealer.CD_CM_ID
     WHERE  Mast.CM_ID=@CM_ID)=0)
     BEGIN
      SET @RtnMsg=@RtnMsg+'请添加经销商'
      END
     --检查名称是否重复
     IF EXISTS(SELECT 1 FROM ConsignmentMaster WHERE CM_ConsignmentName=@NAme AND CM_ID<>@CM_ID)
     BEGIN
     SET @RtnMsg=@RtnMsg+'规则名称重复'
     END
		
	
	IF LEN(@RtnMsg) > 0
		SET @RtnVal = 'Error'
	ELSE 
		IF EXISTS (SELECT 1 FROM #TMP_CHECK WHERE ErrorDesc IS NULL AND IsReg = 0)
			BEGIN
				--拼接警告信息
				SET @RtnVal = 'Warn' 
				SET @RtnMsg = ''
				SET @RtnRegMsg = (SELECT ArticleNumber + ',' FROM #TMP_CHECK WHERE ErrorDesc IS NULL AND IsReg = 0 ORDER BY ArticleNumber FOR XML PATH(''))
			END
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    return -1
    
END CATCH



GO


