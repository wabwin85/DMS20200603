DROP Procedure [dbo].[GC_AreaAuthorizedSynchronous]
GO



CREATE Procedure [dbo].[GC_AreaAuthorizedSynchronous]
AS
	--参数
	DECLARE @DAT_ID uniqueidentifier
	DECLARE @DealerID uniqueidentifier
	DECLARE @ProductLineID uniqueidentifier
	DECLARE @Pct_Id uniqueidentifier
	
	--中间变量
	--DECLARE @HAS INT
	
	CREATE TABLE #TEMPAuthorized(
		DealerID uniqueidentifier ,
		ProductLineID  uniqueidentifier,
		Pct_Id uniqueidentifier,
		Dat_Id uniqueidentifier
	)
	
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
		--SELECT * FROM  TerritoryArea
		--SELECT * FROM  TerritoryAreaExc
		--SELECT * FROM  DealerAuthorizationArea
		
		INSERT INTO #TEMPAuthorized(DealerID,ProductLineID,Pct_Id,Dat_Id)
		SELECT A.DA_DMA_ID,A.DA_ProductLine_BUM_ID,A.DA_PMA_ID,A.DA_ID FROM DealerAuthorizationArea A 
		WHERE CONVERT(NVARCHAR(10),A.DA_StartDate,120) <=CONVERT(NVARCHAR(10),GETDATE() ,120)
			AND CONVERT(NVARCHAR(10),A.DA_EndDate,120) >=CONVERT(NVARCHAR(10),GETDATE() ,120)
		
		--INSERT INTO #TEMPAuthorized(DealerID,ProductLineID,Pct_Id,Dat_Id)
		--SELECT A.DMA_ID,B.CC_ProductLineID,B.CA_ID,DA.DA_ID FROM V_DealerContractMaster A
		--INNER JOIN (SELECT DISTINCT CC_ProductLineID,CC_Division,CC_Code,CC_ID,CC_NameCN,CA_Code,CA_ID,CA_NameCN FROM V_ProductClassificationStructure ) B ON A.CC_ID=B.CC_ID AND B.CC_Division=CONVERT(NVARCHAR(10), A.Division)
		--INNER JOIN DealerAuthorizationArea DA ON DA.DA_DMA_ID=A.DMA_ID AND B.CC_ProductLineID=DA.DA_ProductLine_BUM_ID AND B.CA_ID=DA.DA_PMA_ID
		--WHERE A.ActiveFlag='1'
		
		DECLARE @PRODUCT_CUR cursor;
		SET @PRODUCT_CUR=cursor for 
			SELECT DealerID,ProductLineID,Pct_Id,Dat_Id FROM #TEMPAuthorized
		OPEN @PRODUCT_CUR
		FETCH NEXT FROM @PRODUCT_CUR INTO @DealerID,@ProductLineID,@Pct_Id,@DAT_ID
		WHILE @@FETCH_STATUS = 0        
			BEGIN
			
			
			
			IF exists ( SELECT  1 FROM DealerAuthorizationTable A WHERE A.DAT_ID=@DAT_ID)
			BEGIN
				DELETE HospitalList WHERE HLA_DAT_ID =@DAT_ID;
				
				INSERT INTO HospitalList (HLA_DAT_ID,HLA_HOS_ID,HLA_ID)
				SELECT @DAT_ID,C.HOS_ID,NEWID() FROM TerritoryArea  A 
				INNER JOIN Territory B ON A.TA_Area=B.TER_ID
				INNER JOIN Hospital C ON C.HOS_Province=B.TER_Description
				WHERE A.TA_DA_ID=@DAT_ID
				AND c.HOS_ActiveFlag='1' and c.HOS_DeletedFlag='0'
				AND C.HOS_ID NOT IN (SELECT TAE_HOS_ID FROM TerritoryAreaExc WHERE TAE_DA_ID=@DAT_ID);
			END
			
			
			FETCH NEXT FROM @PRODUCT_CUR INTO @DealerID,@ProductLineID,@Pct_Id,@DAT_ID
			END
		CLOSE @PRODUCT_CUR
		DEALLOCATE @PRODUCT_CUR ;

		
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    return -1
END CATCH




GO


