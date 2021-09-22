

/****** Object:  StoredProcedure [Workflow].[Proc_Contract_Appointment_CheckFormData]    Script Date: 2019/12/2 14:25:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Workflow].[Proc_Contract_Renewal_CheckFormData]
	@InstanceId UNIQUEIDENTIFIER,
	@NodeIds NVARCHAR(2000),
	@RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(4000) OUTPUT
AS
BEGIN
	IF EXISTS (
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL IN ('合规审批_平台续签','合规审批_T1续签','平台培训T2_T2续签')    --新增Compliance审批节点，需修改
	       )
	BEGIN
		DECLARE @DDEndDate DateTime;
		SELECT TOP 1 @DDEndDate=DMDD_EndDate 
		FROM DealerMasterDD DMDD
		INNER JOIN [Contract].RenewalMain cac ON cac.CompanyID=DMDD.DMDD_DealerID
		WHERE cac.ContractID=@InstanceId ORDER BY DMDD_UpdateDate DESC
		IF ((@DDEndDate IS NULL or dateadd(m,13,GetDate())>@DDEndDate) AND EXISTS (   --合规部需要判断有效期
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL IN ('合规审批_平台续签','合规审批_T1续签')    
	       ))
		BEGIN
			SET @RtnVal = 'Fail';
			SET @RtnMsg = '背调报告未上传或已过有效期';
		END
		ELSE IF(@DDEndDate IS NULL AND EXISTS (      --平台培训不看有效期 
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL IN ('平台培训T2_T2续签')    
	       ))
		BEGIN
			SET @RtnVal = 'Fail';
			SET @RtnMsg = '背调报告未上传';
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
GO


