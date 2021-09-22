

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
	           WHERE  VAL IN ('�Ϲ�����_ƽ̨��ǩ','�Ϲ�����_T1��ǩ','ƽ̨��ѵT2_T2��ǩ')    --����Compliance�����ڵ㣬���޸�
	       )
	BEGIN
		DECLARE @DDEndDate DateTime;
		SELECT TOP 1 @DDEndDate=DMDD_EndDate 
		FROM DealerMasterDD DMDD
		INNER JOIN [Contract].RenewalMain cac ON cac.CompanyID=DMDD.DMDD_DealerID
		WHERE cac.ContractID=@InstanceId ORDER BY DMDD_UpdateDate DESC
		IF ((@DDEndDate IS NULL or dateadd(m,13,GetDate())>@DDEndDate) AND EXISTS (   --�Ϲ沿��Ҫ�ж���Ч��
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL IN ('�Ϲ�����_ƽ̨��ǩ','�Ϲ�����_T1��ǩ')    
	       ))
		BEGIN
			SET @RtnVal = 'Fail';
			SET @RtnMsg = '��������δ�ϴ����ѹ���Ч��';
		END
		ELSE IF(@DDEndDate IS NULL AND EXISTS (      --ƽ̨��ѵ������Ч�� 
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL IN ('ƽ̨��ѵT2_T2��ǩ')    
	       ))
		BEGIN
			SET @RtnVal = 'Fail';
			SET @RtnMsg = '��������δ�ϴ�';
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


