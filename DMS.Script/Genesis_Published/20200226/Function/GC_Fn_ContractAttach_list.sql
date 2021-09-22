USE [GenesisDMS_PRD]
GO
/****** Object:  UserDefinedFunction [Contract].[GC_Fn_ContractAttach_list]    Script Date: 2020/2/19 16:22:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [Contract].[GC_Fn_ContractAttach_list]
(
	-- Add the parameters for the function here
	@ExportId UNIQUEIDENTIFIER,
	@ContractType nvarchar(50),
	@DealerType  nvarchar(50),
	@ProductlineId  nvarchar(50),
	@DealerId nvarchar(50),
	@ContractId nvarchar(50)
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
	
	--根据合同申请先后顺序区别主合同与附加合同
	DECLARE @HasMainContract INT
	SET @HasMainContract=0
	IF EXISTS (SELECT 1 FROM Contract.ExportMain em INNER JOIN dbo.V_DivisionProductLineRelation dpr ON em.DeptId=dpr.DivisionCode WHERE DealerId=@DealerId AND ContractType='Appointment' AND DealerType=@DealerType AND em.DeptId=@ProductlineId AND em.ContractId<>@ContractId)
	OR EXISTS (SELECT 1 FROM Contract.ExportT2Main etm INNER JOIN dbo.V_DivisionProductLineRelation dpr ON etm.DeptId=dpr.DivisionCode WHERE DealerId=@DealerId AND ContractType='Appointment' AND DealerType=@DealerType AND etm.DeptId=@ProductlineId AND etm.ContractId<>@ContractId)
	BEGIN 
		SET @HasMainContract=1
	END
	IF(@ContractType='Termination' AND @DealerType = 'T2')
	BEGIN
		SET @HasMainContract=0
	END
	--IF  EXISTS(SELECT A.DisplayOrder FROM Contract.ExportSelectedTemplate A WHERE A.ExportId=@ExportId)
	IF  exists(select 1 from Contract.ExportMain where ExportId=@ExportId )
	or exists(select 1 from Contract.ExportT2Main where ExportId=@ExportId )
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
				inner join Contract.ExportSelectedTemplate B on a.TemplateId=b.TemplateId AND ExportId=@ExportId
				WHERE (A.ContractType=@ContractType OR ContractType='Amendment') AND DealerType=@DealerType AND A.IsActive=1
				AND (A.BrandName IS NULL OR EXISTS(SELECT 1 FROM V_DivisionProductLineRelation WHERE DivisionCode=@ProductlineId AND BrandName = A.BrandName))
				) TAB ) 
			C order by DisplayOrder

	END
	ELSE
	BEGIN
		INSERT INTO @TEMP(
			TemplateId,ContractType,DealerType,TemplateName,TemplateFile,TemplateFile1,IsActive,IsRequired,DisplayOrder,IsRequiredBind,[FileName],TemplateType)
		SELECT A.TemplateId,A.ContractType,A.DealerType,A.TemplateName,
		CASE A.TemplateType WHEN 'RebateAttachment' THEN (SELECT TOP 1 TemplatePath FROM [Contract].[ExportRebateTemplate] WHERE DeptId=@ProductlineId AND Rv1=@DealerId) ELSE A.TemplateFile END as TemplateFile
		--,NULL
		,CASE A.TemplateType WHEN 'OtherAttachment' THEN ISNULL((SELECT TOP 1 EUD_UploadFilePath FROM Contract.ExportUploadDetail WHERE EUD_DMA_ID = @DealerId AND EUD_IsActived = 1),'') ELSE NULL END as TemplateFile1
		,A.IsActive,A.IsRequired,A.DisplayOrder,A.IsRequired,CASE WHEN @DealerType='T2' THEN '其他附件_T2.pdf' ELSE '其他附件_T1.pdf' END,
		A.TemplateType
		FROM Contract.ExportTemplate A WHERE A.ContractType=(CASE WHEN @HasMainContract=1 THEN 'Amendment' ELSE @ContractType END) AND A.DealerType=@DealerType AND A.IsActive=1
		AND (A.BrandName IS NULL OR EXISTS(SELECT 1 FROM V_DivisionProductLineRelation WHERE DivisionCode=@ProductlineId AND BrandName = A.BrandName))

		ORDER BY A.DisplayOrder ASC
		--终止判断是否
		IF(@ContractType='Termination' AND @DealerType = 'T2')
		BEGIN
			IF((SELECT COUNT(1) FROM DealerAuthorizationTable
				INNER JOIN DealerContract ON dat_dcl_id=dcl_ID
				INNER JOIN V_ProductClassificationStructure  ON DAT_PMA_ID = CA_ID
				WHERE DCL_DMA_ID = @DealerId AND CC_Division<>@ProductlineId 
				AND GETDATE() Between DCL_StartDate AND DATEADD(DAY,1,DCL_StopDate)
				AND GETDATE() Between DAT_StartDate AND DATEADD(DAY,1,DAT_EndDate))>0)
			BEGIN
			   DELETE @TEMP WHERE TemplateName='二级经销商终止通知函'
			END
			ELSE
			BEGIN
			   DELETE @TEMP WHERE TemplateName='二级经销商合同修改协议'
			END
		END
	END

	RETURN 
END



