DROP FUNCTION [dbo].[GC_Fn_GetAuthorCodeAndDivName]
GO



CREATE FUNCTION [dbo].[GC_Fn_GetAuthorCodeAndDivName]
(
	@ContractId UNIQUEIDENTIFIER,
	@ContractType NVARCHAR(100)
)
RETURNS @temp TABLE 
(
	AuthorCode NVARCHAR(100) NULL,
	DivName NVARCHAR(500) NULL,
	AuthorNameString NVARCHAR(2000) NULL
)
AS

BEGIN
	DECLARE @DealerShortName NVARCHAR(50)
	DECLARE @Division NVARCHAR(50)
	DECLARE @Code NVARCHAR(100)
	DECLARE @CodeF NVARCHAR(100)
	DECLARE @CodeC NVARCHAR(100)
	DECLARE @DealerType NVARCHAR(100)
	DECLARE @DealerSAPCode NVARCHAR(100)
	DECLARE @ProductRemark NVARCHAR(100)
	DECLARE @SubBU NVARCHAR(100)
	DECLARE @SubBUName NVARCHAR(500)
	
	DECLARE @AuthorCode NVARCHAR(50)
	DECLARE @DivName NVARCHAR(50)
	DECLARE @AuthorNameString NVARCHAR(2000)
	
	DECLARE @BeginDate Datetime
	
	IF(@ContractType='Appointment')
	BEGIN
		SELECT @DealerShortName=dm.DMA_ChineseShortName,@Division=ca.CAP_Division,@DealerType=DMA_DealerType,@DealerSAPCode=DMA_SAP_Code,
		@ProductRemark=(case LOWER(isnull(ca.CAP_ProductLine,'')) when 'all' then '' else ca.CAP_ProductLine end )
		,@SubBU=ca.CAP_SubDepID
		,@BeginDate=ca.CAP_EffectiveDate
		FROM DealerMaster dm INNER JOIN ContractAppointment ca ON dm.DMA_ID=ca.CAP_DMA_ID And ca.CAP_ID=@ContractId
	END
	IF(@ContractType='Amendment')
	BEGIN
		SELECT @DealerShortName=dm.DMA_ChineseShortName,@Division=ca.CAM_Division,@DealerType=DMA_DealerType,@DealerSAPCode=DMA_SAP_Code
		,@ProductRemark=ISNULL(ca.CAM_ProductLine_Remarks,'')
		,@SubBU=ca.CAM_SubDepID
		,@BeginDate=ca.CAM_Amendment_EffectiveDate
		FROM DealerMaster dm INNER JOIN ContractAmendment ca ON dm.DMA_ID=ca.CAM_DMA_ID And ca.CAM_ID=@ContractId
	END
	IF(@ContractType='Renewal')
	BEGIN
		SELECT @DealerShortName=dm.DMA_ChineseShortName,@Division=ca.CRE_Division,@DealerType=DMA_DealerType,@DealerSAPCode=DMA_SAP_Code
		,@ProductRemark=ISNULL(ca.CRE_ProductLine_Remarks,'')
		,@SubBU=ca.CRE_SubDepID
		,@BeginDate=ca.CRE_Agrmt_EffectiveDate_Renewal
		FROM DealerMaster dm INNER JOIN ContractRenewal ca ON dm.DMA_ID=ca.CRE_DMA_ID And ca.CRE_ID=@ContractId
	END
	select @Code=REPLACE(REPLACE(REPLACE(CONVERT(varchar,GETDATE(),120),'-',''),' ',''),':','');
	SET @CodeF=SUBSTRING(@Code,0,9);
	SET @CodeC=SUBSTRING(@Code,9,3);
	IF(@DealerType='T2')
	BEGIN
		SET @AuthorCode = @DealerSAPCode+'-'+@Division+'-'+@CodeF+'-'+@CodeC;
	END
	ELSE BEGIN
		IF @DealerShortName IS NULL
		BEGIN
			SET @DealerShortName='';
		END
		SET @AuthorCode = @DealerShortName+'-'+@Division+'-'+@CodeF+'-'+@CodeC;
	END
	--授权分类名称
	SELECT @AuthorNameString =
                 STUFF ( (SELECT ',' + tt1.PCT_Name
                     FROM (SELECT DISTINCT A.DAT_PMA_ID, b.CA_NameCN PCT_Name
                             FROM    DealerAuthorizationTableTemp A
                                  LEFT JOIN
                                     (select distinct CA_NameCN,CA_Code,CA_ID from V_ProductClassificationStructure f where  @BeginDate between f.StartDate and f.EndDate and f.CC_Code=@SubBU) B
                                  ON A.DAT_PMA_ID = B.CA_ID
                            WHERE A.DAT_DCL_ID = @ContractId) tt1
                   FOR XML PATH ( '' )),
                 1,
                 1,
                 '')
	--产品线
	SELECT @DivName= t1.AttributeName
			FROM Cache_OrganizationUnits t1, Lafite_ATTRIBUTE t2,Lafite_ATTRIBUTE t3
			WHERE t3.ATTRIBUTE_TYPE='Product_Line'
			  AND t3.Id=t1.AttributeID
			  AND t1.AttributeType = 'Product_Line'
			  AND t1.RootID = t2.Id
			  AND t1.RootID IN (SELECT AttributeID
			  FROM Cache_OrganizationUnits
			  WHERE AttributeType = 'BU')
               AND t2.ATTRIBUTE_NAME=@Division
               AND t3.ATTRIBUTE_FIELD4='0';
               
               
    SELECT @SubBUName =A.CC_RV1 FROM INTERFACE.ClassificationContract A WHERE A.CC_Code=@SubBU
    IF(@ProductRemark <>'' AND @ProductRemark IS NOT NULL)
    BEGIN
		SET @DivName=@DivName+' ('+@ProductRemark+')'
		SET @SubBUName=@SubBUName +' ('+@ProductRemark+')'
    END
    IF (ISNULL(@AuthorNameString,''))=''
    BEGIN
		INSERT INTO @temp (AuthorCode,DivName)VALUES(@AuthorCode,@SubBUName);
	END
	ELSE
	BEGIN
		INSERT INTO @temp (AuthorCode,DivName,AuthorNameString)VALUES(@AuthorCode,@SubBUName,' ('+@AuthorNameString+')');
	END
	RETURN
END



GO


