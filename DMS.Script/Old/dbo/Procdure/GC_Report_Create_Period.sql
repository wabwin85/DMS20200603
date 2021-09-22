DROP PROCEDURE [dbo].[GC_Report_Create_Period]
GO


/*
	���ɱ���
*/


CREATE PROCEDURE [dbo].[GC_Report_Create_Period] 

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Count		int	
	DECLARE @NowStr		varchar(10)
	DECLARE @FY			nvarchar(30)
	DECLARE @FQ			nvarchar(30)
	DECLARE @FM			nvarchar(30)
	DECLARE @FW			nvarchar(30)
	

	SELECT @NowStr = convert(varchar(10),getDate(),120)
	
	--For Test
	--set @NowStr='2009-8-15'	
	--print(@NowStr)


	--
	--DealerbuyInMonth Report
	--

	SELECT @FY = COP_Year, @FM = COP_Period
	FROM COP
	WHERE COP_Type='M' and COP_StartDate <= @NowStr and COP_EndDate >= @NowStr

	exec GC_Report_DealerBuyInMonth_Period @FY, @FM

	--������ڼ�ĵ�һ�죬���¼�����һ�ڼ�
	SELECT @Count = Count(1)
	FROM COP
	WHERE COP_Type='M' and COP_StartDate = @NowStr

	IF (@Count > 0 )
	Begin
		SELECT @FY = COP_Year, @FM = COP_Period
		FROM COP
		WHERE COP_Type='M' and  COP_StartDate <= DateAdd(day, -1, @NowStr) and COP_EndDate >= DateAdd(day, -1, @NowStr)

		exec GC_Report_DealerBuyInMonth_Period @FY, @FM
	End
		
	--
	-- End DealerbuyInMonth Report
	--



	--
	--DealerbuyInQuarter Report
	--

	SELECT @FY = COP_Year, @FQ = COP_Period
	FROM COP
	WHERE COP_Type='Q' and COP_StartDate <= @NowStr and COP_EndDate >= @NowStr

	exec GC_Report_DealerBuyInQuarter_Period @FY, @FQ

	--������ڼ�ĵ�һ�죬���¼�����һ�ڼ�
	SELECT @Count = Count(1)
	FROM COP
	WHERE COP_Type='Q' and COP_StartDate = @NowStr

	IF (@Count > 0 )
	Begin
		SELECT @FY = COP_Year, @FQ = COP_Period
		FROM COP
		WHERE COP_Type='Q' and  COP_StartDate <= DateAdd(day, -1, @NowStr) and COP_EndDate >= DateAdd(day, -1, @NowStr)

		exec GC_Report_DealerBuyInQuarter_Period @FY, @FQ
	End
		
	--
	-- End DealerbuyInQuarter Report
	--



	--
	--DealerbuyInWeek Report
	--

	SELECT @FY = COP_Year, @FW = COP_Period
	FROM COP
	WHERE COP_Type='W' and COP_StartDate <= @NowStr and COP_EndDate >= @NowStr

	exec GC_Report_DealerBuyInWeek_Period @FY, @FW

	--������ڼ�ĵ�һ�죬���¼�����һ�ڼ�
	SELECT @Count = Count(1)
	FROM COP
	WHERE COP_Type='W' and COP_StartDate = @NowStr

	IF (@Count > 0 )
	Begin
		SELECT @FY = COP_Year, @FW = COP_Period
		FROM COP
		WHERE COP_Type='W' and  COP_StartDate <= DateAdd(day, -1, @NowStr) and COP_EndDate >= DateAdd(day, -1, @NowStr)

		exec GC_Report_DealerBuyInWeek_Period @FY, @FW
	End
		
	--
	-- End DealerbuyInWeek Report
	--





END
GO


