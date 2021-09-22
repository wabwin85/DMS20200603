
/*
1. 功能名称：寄售合同申请发起MFlow
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [Workflow].[Proc_ConsignmentContract_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)
SELECT @ApplyType = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

--模版信息，必须放在第一个查询结果，且只有固定的两个字段，名称不能变
SELECT @ApplyType AS TemplateName, 'Header,ProductUPN' AS TableNames

--寄售合同主信息
select 
CCH_No,IDENTITY_NAME,
CCH_CreateDate,
VALUE1,
ProductLineName,
DealerMaster.DMA_ChineseShortName,
CCH_Name,
CCH_ConsignmentDay,
CCH_DelayNumber,
(case when CCH_IsFixedMoney=1 then '是' else '否' end) as CCH_IsFixedMoney,
(case when CCH_IsFixedQty=1 then '是' else '否' end) as CCH_IsFixedQty,
(case when CCH_IsKB=1 then '是' else '否' end) as CCH_IsKB,
(case when CCH_IsUseDiscount=1 then '是' else '否' end) as CCH_IsUseDiscount,
(CONVERT(nvarchar(50),CCH_BeginDate,23)+' - '+(CONVERT(nvarchar(50),CCH_EndDate,23))) as ContractDate,
CCH_Remark
from Consignment.ContractHeader H
left join Lafite_IDENTITY on Lafite_IDENTITY.Id=H.CCH_CreateUser
left join V_DivisionProductLineRelation on V_DivisionProductLineRelation.ProductLineID=H.CCH_ProductLine_BUM_ID
left join DealerMaster on DealerMaster.DMA_ID=H.CCH_DMA_ID
left join Lafite_DICT on Lafite_DICT.DICT_KEY=H.CCH_Status and DICT_TYPE='Consignment_ContractHeader_Status'
where CCH_ID=@InstanceId

--产品UPN
select distinct CCD_CfnShortNumber as UPN,CCD_CfnType as [Type],CFN_Property1 as ShortNumber,Product.PMA_ConvertFactor as ConvertFactor,CFN_Property3 as Unit,
(select top 1 CFN_ChineseName from CFN where CFN.CFN_Property1=C.CCD_CfnShortNumber) as ChineseName
from Consignment.ContractDetail C
left join CFN on CFN.CFN_Property1=C.CCD_CfnShortNumber
left join Product on CFN.CFN_ID=Product.PMA_CFN_ID
where CCD_CCH_ID=@InstanceId
