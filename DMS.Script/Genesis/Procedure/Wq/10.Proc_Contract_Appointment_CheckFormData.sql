
/****** Object:  StoredProcedure [Workflow].[Proc_Contract_Appointment_CheckFormData]    Script Date: 2019/11/22 15:08:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Workflow].[Proc_Contract_Appointment_CheckFormData]
	@InstanceId UNIQUEIDENTIFIER,
	@NodeIds NVARCHAR(2000),
	@RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(4000) OUTPUT
AS
BEGIN
	IF EXISTS (
	       SELECT 1
	       FROM   [Contract].AppointmentMain
	       WHERE  ContractId = @InstanceId
	              AND DealerType NOT IN ('T2', 'Trade')
	   )
	   AND EXISTS (
	           SELECT 1
	           FROM   [Contract].AppointmentCandidate
	           WHERE  ContractId = @InstanceId
	                  AND ISNULL(SAPCode, '') = ''
	       )
	   AND EXISTS (
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL in ('供应链审批_平台新建','供应链审批_T1新建')
	       )
	BEGIN
	    SET @RtnVal = 'Fail';
	    SET @RtnMsg = '请维护ERP Code';
	END
	ELSE IF EXISTS (
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL IN ('合规审批_T1新建','合规审批_平台新建','平台培训T2_T2新建')    --新增Compliance审批节点，需修改
	       )
	BEGIN
		DECLARE @DDEndDate DateTime;
		SELECT TOP 1 @DDEndDate=DMDD_EndDate 
		FROM DealerMasterDD DMDD
		INNER JOIN contract.AppointmentCandidate cac ON cac.CompanyID=DMDD.DMDD_DealerID
		WHERE cac.ContractID=@InstanceId ORDER BY DMDD_UpdateDate DESC
		IF (@DDEndDate IS NULL or dateadd(m,13,GetDate())>@DDEndDate)
		BEGIN
			SET @RtnVal = 'Fail';
			SET @RtnMsg = '背调报告未上传或已过有效期';
		END
		ELSE
		BEGIN
			SET @RtnVal = 'Success';
			SET @RtnMsg = '';
		END
	END
	ELSE
	BEGIN
	    SET @RtnVal = 'Success';
	    SET @RtnMsg = '';
	END
END