DROP PROC [interface].[P_Stage_T_I_EW_DistributorPrice]
GO

CREATE PROC [interface].[P_Stage_T_I_EW_DistributorPrice]
AS
BEGIN


	INSERT INTO interface.T_I_EW_DistributorPrice(
		InstancdId
		,Type
		,SubtType
		,UPN
		,Qty
		,NewPrice
		,CustomerSapCode
		,ValidFrom
		,ValidTo
		,Reason
		,IsForRebate
		,Lot
		,CreateDate
		)
	SELECT InstanceId
		,Type
		,SubtType
		,UPN
		,Qty
		,NewPrice
		,CustomerSapCode
		,ValidFrom
		,ValidTo
		,Reason
		,IsForRebate
		,Lot
		,CreateDate
	FROM interface.Stage_T_I_EW_DistributorPrice

	DECLARE @InstanceID INT
	DECLARE Inst_CUR CURSOR FOR 
	SELECT InstanceID
	FROM interface.Stage_T_I_EW_DistributorPrice

	OPEN Inst_CUR
	FETCH NEXT FROM Inst_CUR INTO @InstanceID

	WHILE(@@FETCH_STATUS=0)
	BEGIN

		EXEC [interface].[P_I_EW_DistributorPrice] @InstanceID,NULL,NULL

		FETCH NEXT FROM Inst_CUR INTO @InstanceID

	END

	CLOSE Inst_CUR
	DEALLOCATE Inst_CUR

END
GO


