DROP PROCEDURE [Promotion].[Proc_CheckPolicyHospitalCode] 
GO


/**********************************************
	���ܣ�У��ҽԺ
	���ߣ�GrapeCity
	������ʱ�䣺	2016-02-02
	���¼�¼˵����
	1.���� 2016-05-17
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_CheckPolicyHospitalCode] 
	@HospitalHas NVARCHAR(max),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN 
	DECLARE @MAS NVARCHAR(MAX)
	CREATE TABLE #TEMP(
	HosCode NVARCHAR(50),
	HOSName NVARCHAR(200),
	)
	
	SET @IsValid='';
	
	INSERT INTO #TEMP(HosCode)
	SELECT a.VAL AS HosCode FROM dbo.GC_Fn_SplitStringToTable(@HospitalHas,'|') a
	
	UPDATE A SET HOSName=B.HOS_HospitalName FROM #TEMP A INNER JOIN Hospital B ON A.HosCode=B.HOS_Key_Account
	
	IF  EXISTS(SELECT 1 FROM #TEMP WHERE ISNULL(HOSName,'')='')
	BEGIN
		SELECT 
		@MAS=STUFF(REPLACE(REPLACE(
					(
		SELECT HosCode  RESULT FROM #TEMP A WHERE ISNULL(HOSName,'')='' 
						FOR XML AUTO
					), '<A RESULT="', ','), '"/>', ''), 1, 1, '')
	END
	IF(ISNULL(@MAS,'')<>'')
	BEGIN
		SET @IsValid+=(' ����ҽԺ������д����'+@MAS);
	END
END 

GO


