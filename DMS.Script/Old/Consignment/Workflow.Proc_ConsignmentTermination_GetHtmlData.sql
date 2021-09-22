
/*
1. 功能名称：合同终止发起MFlow
*/


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [Workflow].[Proc_ConsignmentTermination_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)
SELECT @ApplyType = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

--模版信息，必须放在第一个查询结果，且只有固定的两个字段，名称不能变
SELECT @ApplyType AS TemplateName, 'Header' AS TableNames

--寄售终止信息
select CST_No,
IDENTITY_NAME,
CST_CreateDate,
VALUE1,
ProductLineName,
CST_Reason as CST_Remark,
CCH_No,
CCH_Name,
CCH_ConsignmentDay,
CCH_DelayNumber,
(CONVERT(nvarchar(50),CCH_BeginDate,23)+' - '+(CONVERT(nvarchar(50),CCH_EndDate,23))) as ContractDate,
(case when CCH_IsKB=1 then'是' else '否' end) as CCH_IsKB,
(case when CCh_IsFixedMoney=1 then'是' else '否' end) as CCh_IsFixedMoney,
(case when CCH_IsFixedQty=1 then'是' else '否' end) as CCH_IsFixedQty,
(case when CCH_IsUseDiscount=1 then'是' else '否' end) as CCH_IsUseDiscount,
CCH_Remark
from Consignment.ConsignmentTermination T
left join Lafite_IDENTITY on Lafite_IDENTITY.Id=T.CST_CreateUser
left join Consignment.ContractHeader on Consignment.ContractHeader.CCH_ID=T.CST_CCH_ID
left join V_DivisionProductLineRelation on V_DivisionProductLineRelation.ProductLineID=Consignment.ContractHeader.CCH_ProductLine_BUM_ID
left join Lafite_DICT on Lafite_DICT.DICT_KEY=T.CST_Status and DICT_TYPE='Consignment_ConsignmentTermination_Status'
where CST_ID=@InstanceId


