DROP PROCEDURE [Workflow].[Proc_Contract_Amendment_GetHtmlData]
GO


CREATE PROCEDURE [Workflow].[Proc_Contract_Amendment_GetHtmlData]
	@InstanceId UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @DealerType NVARCHAR(200) ;
	
	SELECT @DealerType = A.DealerType
	FROM   [Contract].AmendmentMain A
	WHERE  A.ContractId = @InstanceId;
	
	IF @DealerType = 'T2'
	BEGIN
	    EXEC Workflow.Proc_Contract_AmendmentT2_GetHtmlData @InstanceId
	END
	ELSE 
	IF @DealerType = 'T1'
	   OR @DealerType = 'LP'
	BEGIN
	    EXEC Workflow.Proc_Contract_AmendmentLp_GetHtmlData @InstanceId
	END
END
GO


