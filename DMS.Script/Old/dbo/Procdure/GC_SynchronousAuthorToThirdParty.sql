DROP Procedure [dbo].[GC_SynchronousAuthorToThirdParty]
GO


/*
同步需要维护第三方披露表的授权信息
*/
CREATE Procedure [dbo].[GC_SynchronousAuthorToThirdParty]
	@DealerId NVARCHAR(36),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(MAX) OUTPUT
AS
	CREATE TABLE #tbAuthor
	(
		 DealerId uniqueidentifier,
		 ProductLineId uniqueidentifier,
		 HospitalId uniqueidentifier
	)
	CREATE TABLE #tbAuthorNoProductLine
	(
		 DealerId uniqueidentifier,
		 HospitalId uniqueidentifier
	)
	DECLARE @ReDealerId NVARCHAR(36);
	DECLARE @ReHospitalId NVARCHAR(36);
	DECLARE @Check INT;
	
	DECLARE @CompanyName1 NVARCHAR(200);
	DECLARE @RSM1 NVARCHAR(2000);
	DECLARE @CompanyName2 NVARCHAR(200);
	DECLARE @RSM2 NVARCHAR(2000);
	DECLARE @NotTP BIT;

	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	INSERT INTO #tbAuthor(DealerId,ProductLineId,HospitalId)
	SELECT DISTINCT A.DAT_DMA_ID,A.DAT_ProductLine_BUM_ID,B.HLA_HOS_ID 
	FROM DealerAuthorizationTable A 
	INNER JOIN HospitalList B ON A.DAT_ID=B.HLA_DAT_ID 
	WHERE GETDATE() BETWEEN A.DAT_StartDate AND A.DAT_EndDate
	AND A.DAT_DMA_ID=@DealerId
	/*
	SELECT DISTINCT A.DMA_ID,C.ProductLineID,E.HLA_HOS_ID
	FROM V_DealerContractMaster A
	INNER JOIN (SELECT DISTINCT CC_ID,CA_ID FROM V_ProductClassificationStructure WHERE ActiveFlag=1) B ON A.CC_ID=B.CC_ID
	INNER JOIN V_DivisionProductLineRelation C ON C.DivisionCode=CONVERT(NVARCHAR(10),A.Division) AND C.IsEmerging='0'
	INNER JOIN DealerAuthorizationTable D ON D.DAT_DMA_ID=A.DMA_ID AND D.DAT_ProductLine_BUM_ID=C.ProductLineID AND D.DAT_PMA_ID=B.CA_ID
	INNER JOIN HospitalList E ON E.HLA_DAT_ID=D.DAT_ID
	WHERE A.ActiveFlag='1'
	AND ISNULL(A.MarketType,0)=2
	AND A.DMA_ID=@DealerId
	UNION
	SELECT DISTINCT A.DMA_ID,C.ProductLineID,E.HLA_HOS_ID
	FROM V_DealerContractMaster A
	INNER JOIN (SELECT DISTINCT CC_ID,CA_ID FROM V_ProductClassificationStructure) B ON A.CC_ID=B.CC_ID
	INNER JOIN V_DivisionProductLineRelation C ON C.DivisionCode=CONVERT(NVARCHAR(10),A.Division) AND C.IsEmerging='0'
	INNER JOIN DealerAuthorizationTable D ON D.DAT_DMA_ID=A.DMA_ID AND D.DAT_ProductLine_BUM_ID=C.ProductLineID AND D.DAT_PMA_ID=B.CA_ID
	INNER JOIN HospitalList E ON E.HLA_DAT_ID=D.DAT_ID
	INNER JOIN V_AllHospitalMarketProperty F ON F.ProductLineID=C.ProductLineID AND F.Hos_Id=E.HLA_HOS_ID AND F.MarketProperty=ISNULL(A.MarketType,0)
	WHERE A.ActiveFlag='1'
	AND ISNULL(A.MarketType,0)<>2
	AND A.DMA_ID=@DealerId
	*/
	INSERT INTO #tbAuthorNoProductLine (DealerId,HospitalId)
	SELECT DISTINCT DealerId,HospitalId FROM #tbAuthor
	
	
	DELETE ThirdPartyDisclosure WHERE TPD_ID NOT IN (
	SELECT TPD_ID FROM ThirdPartyDisclosure B
	INNER JOIN #tbAuthor A ON A.DealerId=B.TPD_DMA_ID AND A.HospitalId=B.TPD_HOS_ID /* AND A.ProductLineId=B.TPD_ProductLineId */ )
	AND TPD_DMA_ID=@DealerId
	AND (ISNULL(TPD_CompanyName,'')='' and ISNULL(TPD_CompanyName2,'')='')
	
	UPDATE  ThirdPartyDisclosure SET TPD_Status=0 WHERE TPD_ID NOT IN (
	SELECT TPD_ID FROM ThirdPartyDisclosure B
	INNER JOIN #tbAuthor A ON A.DealerId=B.TPD_DMA_ID AND A.HospitalId=B.TPD_HOS_ID /* AND A.ProductLineId=B.TPD_ProductLineId */ )
	AND TPD_DMA_ID=@DealerId
	AND (ISNULL(TPD_CompanyName,'')<>'' OR  ISNULL(TPD_CompanyName2,'')<>'')
	
	UPDATE  ThirdPartyDisclosure SET TPD_Status=1 WHERE TPD_ID IN (
	SELECT TPD_ID FROM ThirdPartyDisclosure B
	INNER JOIN #tbAuthor A ON A.DealerId=B.TPD_DMA_ID AND A.HospitalId=B.TPD_HOS_ID /* AND A.ProductLineId=B.TPD_ProductLineId */ )
	AND TPD_DMA_ID=@DealerId
	AND (ISNULL(TPD_CompanyName,'')<>'' OR  ISNULL(TPD_CompanyName2,'')<>'')
	
	INSERT INTO ThirdPartyDisclosure(TPD_ID,TPD_DMA_ID,	TPD_HOS_ID,TPD_NotTP,TPD_Status)
	SELECT NEWID(),A.DealerId,A.HospitalId,0,1 FROM #tbAuthorNoProductLine A WHERE NOT EXISTS(SELECT 1 FROM ThirdPartyDisclosure B WHERE A.DealerId=B.TPD_DMA_ID AND A.HospitalId=B.TPD_HOS_ID )
	
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
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH




GO


