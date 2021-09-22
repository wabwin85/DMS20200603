CREATE FUNCTION [Contract].[GC_Fn_ContractAttach_list]
(
	-- Add the parameters for the function here
	@ExportId UNIQUEIDENTIFIER,
	@ContractType nvarchar(50),
	@DealerType  nvarchar(50),
	@ProductlineId  nvarchar(50),
	@DealerId nvarchar(50)
)
RETURNS 
@TEMP TABLE 
(
	-- Add the column definitions for the TABLE variable here
	TemplateId  UNIQUEIDENTIFIER,
	ContractType NVARCHAR(50),
	DealerType  NVARCHAR(50),
	TemplateName NVARCHAR(200),
	TemplateFile NVARCHAR(200),
	TemplateFile1 NVARCHAR(200),
	IsActive    BIT,
	IsRequired BIT,
	DisplayOrder INT,
	IsRequiredBind BIT,
	[FileName] NVARCHAR(200),
	TemplateType NVARCHAR(50)
	
)
	WITH
	EXECUTE AS CALLER
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	--DECLARE @MAXCOUNT  INT


	--IF  EXISTS(SELECT A.DisplayOrder FROM Contract.ExportSelectedTemplate A WHERE A.ExportId=@ExportId)
	IF  exists(select 1 from Contract.ExportMain where ExportId=@ExportId )
	BEGIN
		
		INSERT INTO @TEMP(
		TemplateId,ContractType,DealerType,TemplateName,TemplateFile,TemplateFile1,IsActive,IsRequired,DisplayOrder,IsRequiredBind,[FileName],TemplateType)
		SELECT C.TemplateId,C.ContractType,C.DealerType,C.TemplateName,CASE ISNULL(TemplateType,'') WHEN 'RebateAttachment' THEN  C.TemplateFile1 ELSE   C.TemplateFile END TemplateFile,   C.TemplateFile1,C.IsActive,C.IsRequired,C.DisplayOrder,C.IsRequiredBind,C.[FileName],
		C.TemplateType
		FROM (
			SELECT CASE WHEN  ISNULL(TAB.DisplayOrder2,0)=0 THEN 0 ELSE 1 END AS IsRequired,
				TAB.*,
				case when  ISNULL(TAB.DisplayOrder2,0)=0 then TAB.DisplayOrder1+
				(select max(DisplayOrder) from Contract.ExportSelectedTemplate where ExportId=@ExportId)
				else  TAB.DisplayOrder2 end AS DisplayOrder
			FROM (
				SELECT A.TemplateId,A.ContractType,A.DealerType,
				A.TemplateName,
				A.TemplateFile,
				B.UploadFilePath AS TemplateFile1,
				A.IsActive,
				A.IsRequired as IsRequiredBind,A.DisplayOrder as DisplayOrder1,
				B.DisplayOrder as DisplayOrder2,
				B.[FileName],
				A.TemplateType
				 from Contract.ExportTemplate A
				left join Contract.ExportSelectedTemplate B on a.TemplateId=b.TemplateId AND ExportId=@ExportId
				WHERE A.ContractType=@ContractType AND DealerType=@DealerType AND A.IsActive=1) TAB ) 
			C order by DisplayOrder

	END
	ELSE
	BEGIN
		INSERT INTO @TEMP(
			TemplateId,ContractType,DealerType,TemplateName,TemplateFile,TemplateFile1,IsActive,IsRequired,DisplayOrder,IsRequiredBind,[FileName],TemplateType)
		SELECT A.TemplateId,A.ContractType,A.DealerType,A.TemplateName,
		CASE A.TemplateType WHEN 'RebateAttachment' THEN (SELECT top 1 TemplatePath FROM [Contract].[ExportRebateTemplate] where DeptId=@ProductlineId AND Rv1=@DealerId) ELSE A.TemplateFile END as TemplateFile
		,NULL,A.IsActive,A.IsRequired,A.DisplayOrder,A.IsRequired,NULL ,
		A.TemplateType
		FROM Contract.ExportTemplate A WHERE A.ContractType=@ContractType AND A.DealerType=@DealerType AND A.IsActive=1
		ORDER BY A.DisplayOrder ASC
	END

	RETURN 
END


GO