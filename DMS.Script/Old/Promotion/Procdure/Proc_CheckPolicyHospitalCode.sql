DROP PROCEDURE [Promotion].[Proc_CheckPolicyHospitalCode] 
GO


/**********************************************
	功能：校验医院
	作者：GrapeCity
	最后更新时间：	2016-02-02
	更新记录说明：
	1.创建 2016-05-17
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
		SET @IsValid+=(' 以下医院代码填写错误：'+@MAS);
	END
END 

GO


