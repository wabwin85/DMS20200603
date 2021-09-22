/****** Object:  StoredProcedure [Workflow].[Proc_Contract_Appointment_CheckFormData]    Script Date: 2019/12/2 14:09:33 ******/
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
	           WHERE  VAL in ('��Ӧ������_ƽ̨�½�','��Ӧ������_T1�½�')
	       )
	BEGIN
	    SET @RtnVal = 'Fail';
	    SET @RtnMsg = '��ά��ERP Code';
	END
	ELSE IF EXISTS (
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL IN ('�Ϲ�����_T1�½�','�Ϲ�����_ƽ̨�½�','ƽ̨��ѵT2_T2�½�')    --����Compliance�����ڵ㣬���޸�
	       )
	BEGIN
		DECLARE @DDEndDate DateTime;
		SELECT TOP 1 @DDEndDate=DMDD_EndDate 
		FROM DealerMasterDD DMDD
		INNER JOIN contract.AppointmentCandidate cac ON cac.CompanyID=DMDD.DMDD_DealerID
		WHERE cac.ContractID=@InstanceId ORDER BY DMDD_UpdateDate DESC
		IF ((@DDEndDate IS NULL or dateadd(m,13,GetDate())>@DDEndDate) AND EXISTS (   --�Ϲ沿��Ҫ�ж���Ч��
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL IN ('�Ϲ�����_T1�½�','�Ϲ�����_ƽ̨�½�')    
	       ))
		BEGIN
			SET @RtnVal = 'Fail';
			SET @RtnMsg = '��������δ�ϴ����ѹ���Ч��';
		END
		ELSE IF(@DDEndDate IS NULL AND EXISTS (      --ƽ̨��ѵ������Ч�� 
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL IN ('ƽ̨��ѵT2_T2�½�')    
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