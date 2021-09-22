DROP FUNCTION [Promotion].[func_Pro_Utility_getPointValidDate]
GO

CREATE FUNCTION [Promotion].[func_Pro_Utility_getPointValidDate](
	@Period NVARCHAR(50),				--����/�·�
	@AccountMonth  NVARCHAR(50),		--��ǰ��������
	@PointValidDateType NVARCHAR(50),	--������Ч������(Alwaysʼ����Ч��AbsoluteDate�̶����ڣ�AccountMonth������չ��)
	@PointValidDateDuration INT,		--������Ч�ڻ�׼ʱ����:1-12����
	@PointValidDateAbsolute DATETIME	--������Ч��ͳһ����:ͳһ����
	)
RETURNS DATETIME
AS
BEGIN
	DECLARE @RETURN_DATE DATETIME
	
	IF @PointValidDateType = 'Always'
	BEGIN
		SET	@RETURN_DATE = '9999-12-31'
	END
	
	IF @PointValidDateType = 'AbsoluteDate'
	BEGIN
		SET	@RETURN_DATE = @PointValidDateAbsolute
	END
	
	IF @PointValidDateType = 'AccountMonth'
	BEGIN
		IF @Period = '����'
		BEGIN
			SET	@RETURN_DATE = DATEADD(M,@PointValidDateDuration+1,CONVERT(DATETIME,LEFT(@AccountMonth,4) 
				+ CASE RIGHT(@AccountMonth,2) WHEN 'Q1' THEN '03' WHEN 'Q2' THEN '06' WHEN 'Q3' THEN '09' ELSE '12' END+'01'))-1
		END
		ELSE
		BEGIN
			SET	@RETURN_DATE = DATEADD(M,@PointValidDateDuration+1,CONVERT(DATETIME,@AccountMonth+'01'))-1
		END 
	END
	
	RETURN @RETURN_DATE
END


GO


