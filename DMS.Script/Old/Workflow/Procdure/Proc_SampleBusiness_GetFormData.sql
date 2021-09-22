DROP PROCEDURE [Workflow].[Proc_SampleBusiness_GetFormData]
GO


CREATE PROCEDURE [Workflow].[Proc_SampleBusiness_GetFormData]
	@InstanceId uniqueidentifier
AS

DECLARE @UsdRate DECIMAL(18,2)

SELECT @UsdRate = Rate FROM interface.V_MDM_ExchangeRate

SELECT case when SampleType = '商业样品' then 1 else 2 end AS RequestType,ApplyPurpose AS PurposeType,(SELECT SUM(ApplyQuantity*ISNULL(Cost,0))/ISNULL(@UsdRate,1) FROM SampleUpn WHERE SampleHeadId = SampleApplyHeadId) AS TOTALAMOUNTUSD,
UPN = '#'+STUFF
  ((SELECT '#' + UpnNo
      FROM SampleUpn AS t
      WHERE t.SampleHeadId = SampleApplyHeadId FOR xml path('')), 1, 1, '')+'#',
ApplyNo AS SampleNo
from SampleApplyHead 
where SampleApplyHeadId = @InstanceId


GO


