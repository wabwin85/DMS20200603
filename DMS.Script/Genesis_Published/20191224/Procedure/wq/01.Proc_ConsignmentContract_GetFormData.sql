
/****** Object:  StoredProcedure [Workflow].[Proc_ConsignmentContract_GetFormData]    Script Date: 2019/12/13 13:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [Workflow].[Proc_ConsignmentContract_GetFormData]
	@InstanceId uniqueidentifier
AS
select 1 'NoData'
--select CCH_No as RequestNo,'1' as [Type],0 AS TotalAmountRMB,0 AS TotalAmountUSD  from Consignment.ContractHeader
--where CCH_ID=@InstanceId


