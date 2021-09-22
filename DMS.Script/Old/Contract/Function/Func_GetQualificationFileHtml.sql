DROP FUNCTION [Contract].[Func_GetQualificationFileHtml]
GO


CREATE FUNCTION [Contract].[Func_GetQualificationFileHtml]
(
	@DealerId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Rtn NVARCHAR(MAX);
	
	SET @Rtn = '';
	
	--资质文件
	DECLARE @FileType NVARCHAR(500) ;
	DECLARE @FileName NVARCHAR(500) ;
	DECLARE @FileUrl NVARCHAR(500) ;
	
	DECLARE CUR_ATT CURSOR  
	FOR
	    SELECT TypeName,
			   NAME,
			   dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'BscDp/Pages/Download.aspx?FileId=' + CONVERT(NVARCHAR(50), Id) + '&FileType=dcms' URL
		FROM   (
				   SELECT AT_ID AS Id,
						  AT_Name AS NAME,
						  DIC.VALUE1 AS TypeName,
						  CONVERT(NVARCHAR(10), AT_UploadDate, 120) AS UploadDate
				   FROM   dbo.Attachment a
						  INNER JOIN dbo.Lafite_DICT DIC
							   ON  DIC.DICT_KEY = a.AT_Type
						  INNER JOIN (
								   SELECT CAP_ID AS ContractID,
										  CAP_DMA_ID AS DMA_ID
								   FROM   ContractAppointment                           
								   UNION                           
								   SELECT CAM_ID,
										  CAM_DMA_ID
								   FROM   ContractAmendment                           
								   UNION                           
								   SELECT CRE_ID,
										  CRE_DMA_ID
								   FROM   ContractRenewal                           
								   UNION                           
								   SELECT CTE_ID,
										  CTE_DMA_ID
								   FROM   ContractTermination
							   ) comTb
							   ON  comTb.ContractID = a.AT_Main_ID
				   WHERE  comTb.DMA_ID = @DealerId 
				   AND DIC.DICT_KEY IN ('LP_Certificates','T1_Certificates')
				   UNION           
				   SELECT AT_ID AS Id,
						  AT_Name AS NAME,
						  DIC.VALUE1 AS TypeName,
						  CONVERT(NVARCHAR(10), AT_UploadDate, 120) AS UploadDate
				   FROM   dbo.Attachment a
						  INNER JOIN dbo.Lafite_DICT DIC
							   ON  DIC.DICT_KEY = a.AT_Type
						  INNER JOIN DealerMaster DM
							   ON  DM.DMA_ID = A.AT_Main_ID
				   WHERE  DM.DMA_ID = @DealerId
				   AND AT_Name like '%证%' 
			   )TB
		ORDER BY UploadDate
	
	--Head
	SET @Rtn += '<h4>资质文件</h4><table class="gridtable">'
	SET @Rtn += '<tr><td class="title" width="33%">文件类别</td><td class="title" width="67%">文件名</td></tr>'
	
	OPEN CUR_ATT
	FETCH NEXT FROM CUR_ATT INTO @FileType,@FileName,@FileUrl
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @Rtn += '<tr><td>' + @FileType + '</td><td><a href="' + @FileUrl + '" target="_blank">' + @FileName + '</a></td></tr>'
	    
	    FETCH NEXT FROM CUR_ATT INTO @FileType,@FileName,@FileUrl
	END
	CLOSE CUR_ATT
	DEALLOCATE CUR_ATT
	
	SET @Rtn += '</table>'
	
	RETURN @Rtn
END
GO


