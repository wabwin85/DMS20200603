DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Log] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Log] 
	@PolicyId INT,
	@Status NVARCHAR(10),
	@vError NVARCHAR(1000)
AS
BEGIN
	DECLARE @StartDate NVARCHAR(10)
	DECLARE @CurrentPeriod NVARCHAR(10)
	DECLARE @Period NVARCHAR(10)
	
	SELECT @CurrentPeriod = CurrentPeriod,@Period = Period,@StartDate=StartDate
	FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId
	
	IF @@ROWCOUNT = 0 
		INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT @PolicyId,NULL,NULL,NULL,GETDATE(),GETDATE(),'���߱�Ų�����'
		
	--�������߱��������Ѽ�����ڼ䣬��õ�ǰ���ڼ�����ڼ�
	IF ISNULL(@CurrentPeriod,'') = ''
		SET @CurrentPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate) 
	ELSE
		SET @CurrentPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod) 
	
	--�������߱����״̬
	UPDATE Promotion.PRO_POLICY SET CalStatus = CASE ISNULL(@Status,'') WHEN '' THEN CalStatus ELSE @Status END,
	CalPeriod = @CurrentPeriod,EndTime = GETDATE()
	WHERE PolicyId = @PolicyId
	
	--��¼��־
	INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
	SELECT a.PolicyId,a.CalModule,@Status CalStatus,a.CalPeriod,a.StartTime,a.EndTime,@vError
	FROM Promotion.PRO_POLICY a WHERE PolicyId = @PolicyId
	
END

GO


