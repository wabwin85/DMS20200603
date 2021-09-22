DROP PROCEDURE [Workflow].[Proc_Tender_GetFormData]

GO

CREATE PROCEDURE [Workflow].[Proc_Tender_GetFormData]
	@InstanceId uniqueidentifier
AS

--select * from [AuthorizationTenderMain]
DECLARE @VendorType INT
SELECT @VendorType = COUNT(1) FROM dbo.AuthorizationTenderMain WHERE DTM_ID = @InstanceId

IF @VendorType = 1
	BEGIN
		SELECT (
					SELECT DivisionCode FROM V_DivisionProductLineRelation
						INNER JOIN View_ProductLine ON Id = ProductLineID 
						WHERE Id = DTM_ProductLine_ID
				) AS DeptId, DTM_DealerType AS DealerType, DTM_NO AS RequestNo
		FROM dbo.AuthorizationTenderMain
		WHERE DTM_ID = @InstanceId
	END

GO


