
DROP PROCEDURE [Workflow].[Proc_PromotionPolicy_GetFormData]
GO

CREATE PROCEDURE [Workflow].[Proc_PromotionPolicy_GetFormData]
	@InstanceId uniqueidentifier
AS


DECLARE @VendorType INT
SELECT @VendorType = COUNT(1) FROM Promotion.PRO_POLICY WHERE InstanceId = @InstanceId

DECLARE @DepID INT
SELECT TOP 1 @DepID=c.DepID FROM Promotion.PRO_POLICY a
INNER JOIN Lafite_IDENTITY b on a.CreateBy =b.Id
INNER JOIN INTERFACE.MDM_EmployeeMaster C ON C.account=B.IDENTITY_CODE
WHERE InstanceId = @InstanceId 

SET @DepID=ISNULL(@DepID,0);

IF @VendorType = 1
	BEGIN
		SELECT PolicyNo AS RequestNo,
		CASE WHEN b.DivisionCode='10' THEN b.DivisionCode 
		ELSE CASE WHEN @DepID=36 THEN '36' ELSE b.DivisionCode END END AS BU,
		A.SubBu SubBu FROM Promotion.PRO_POLICY A INNER JOIN V_DivisionProductLineRelation B ON A.BU=B.DivisionName AND B.IsEmerging='0'
		WHERE A.InstanceId = @InstanceId
	END

GO


