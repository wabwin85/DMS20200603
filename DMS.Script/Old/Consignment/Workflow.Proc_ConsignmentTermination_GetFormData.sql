
/*
1. 功能名称：合同终止发起MFlow
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Workflow].[Proc_ConsignmentTermination_GetFormData]
	@InstanceId uniqueidentifier
AS

select CST_No as RequestNo,DivisionCode as Bu,DMA_DealerType as DealerType
from Consignment.ConsignmentTermination
left join Consignment.ContractHeader on Consignment.ContractHeader.CCH_ID=Consignment.ConsignmentTermination.CST_CCH_ID
left join V_DivisionProductLineRelation on V_DivisionProductLineRelation.ProductLineID=Consignment.ContractHeader.CCH_ProductLine_BUM_ID
left join Lafite_IDENTITY on Lafite_IDENTITY.Id=Consignment.ConsignmentTermination.CST_CreateUser
left join DealerMaster on DealerMaster.DMA_ID=Lafite_IDENTITY.Corp_ID
where CST_ID=@InstanceId

