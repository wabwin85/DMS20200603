DROP PROCEDURE [Workflow].[Proc_SampleReturn_GetFormData]
GO




CREATE PROCEDURE [Workflow].[Proc_SampleReturn_GetFormData]
	@InstanceId uniqueidentifier
AS

select case when SampleType = '��ҵ��Ʒ' then 1 else 2 end as RequestType,
ReturnNo AS	SampleReturnNo
from SampleReturnHead 
where SampleReturnHeadId = @InstanceId




GO


