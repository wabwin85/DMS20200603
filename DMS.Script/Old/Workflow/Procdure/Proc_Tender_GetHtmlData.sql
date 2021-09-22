DROP PROCEDURE [Workflow].[Proc_Tender_GetHtmlData]
GO

CREATE PROCEDURE [Workflow].[Proc_Tender_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)
SELECT @ApplyType = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

--模版信息，必须放在第一个查询结果，且只有固定的两个字段，名称不能变
SELECT @ApplyType AS TemplateName, 'Header,AuthProduct,Attachment' AS TableNames

DECLARE @BeginDate NVARCHAR(100) 
DECLARE @EndDate NVARCHAR(100) 
SELECT @BeginDate = CONVERT(NVARCHAR(10),DTM_BeginDate,120),@EndDate = CONVERT(NVARCHAR(10),DTM_EndDate,120)
FROM AuthorizationTenderMain
WHERE DTM_ID = @InstanceId

--数据信息
--表头
SELECT DTM_ID AS Id,DTM_NO AS No,DTM_DealerName AS DealerName,DTM_ProductLine_ID AS ProductLineId,CONVERT(NVARCHAR(10),DTM_BeginDate,120) AS BeginDate,CONVERT(NVARCHAR(10),DTM_EndDate,120) AS EndDate,DTM_CreateUser AS CreateUser,CONVERT(NVARCHAR(20),DTM_CreateDate,120) AS CreateDate,DTM_States AS States,CASE WHEN DTM_LicenceType = 1 THEN '是' ELSE '否' END AS LicenceType,DTM_DealerAddress AS DealerAddress,DTM_Remark1 AS Remark1,DTM_Remark2 AS Remark2,DTM_Remark3 AS Remark3,DTM_DealerType AS DealerType
,(SELECT ATTRIBUTE_NAME FROM VIEW_ProductLine WHERE Id = DTM_ProductLine_ID) AS ProductLineName
,(SELECT VALUE1 FROM Lafite_DICT WHERE DICT_TYPE = 'CONST_Dealer_Type' AND DICT_KEY = DTM_DealerType) AS DealerTypeName
,DivisionName AS DivisionName
FROM AuthorizationTenderMain
INNER JOIN V_DivisionProductLineRelation ON ProductLineID = DTM_ProductLine_ID
WHERE DTM_ID = @InstanceId

--授权产品信息
EXEC dbo.Pro_GetTenderProductSelected @InstanceId,'00000000-0000-0000-0000-000000000000',@BeginDate,@EndDate,'Export',0,0

--附件信息
EXEC Workflow.Proc_Attachment_GetHtmlData @InstanceId,NULL

GO


