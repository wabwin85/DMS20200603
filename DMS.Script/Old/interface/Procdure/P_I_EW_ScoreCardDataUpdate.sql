DROP PROCEDURE [interface].[P_I_EW_ScoreCardDataUpdate]
GO

CREATE PROCEDURE [interface].[P_I_EW_ScoreCardDataUpdate]
@ESC_No nvarchar(30),  --单据号
@ESC_GradeValue1 nvarchar(30), --开发计划评分
@ESC_GradeValue2 nvarchar(30), --开发结果（成功进医院新产品数量）
@ESC_Score1 nvarchar(3), --市场开发总得分
@ESC_GradeValue7 nvarchar(30),--每周学习次数
@ESC_GradeValue8 nvarchar(30),--考试分数
@ESC_Score4 nvarchar(3),--培训出勤和考试达标总得分
@RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT
WITH EXEC AS CALLER
AS

DECLARE @ESCID  UNIQUEIDENTIFIER

SET NOCOUNT ON

BEGIN TRY
BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	SELECT @ESCID=ESC_ID FROM EndoScoreCard WHERE ESC_No=@ESC_No;
	
	IF(@ESCID IS NULL)
	BEGIN
		SET @RtnVal = 'Failure'
		SET @RtnMsg = '单据编号不存在！'
	END
	ELSE
	BEGIN
		--更新DMS表中评分内容
		UPDATE EndoScoreCard
		SET ESC_GradeValue1 = @ESC_GradeValue1,
			ESC_GradeValue2 = @ESC_GradeValue2,
			ESC_Score1 = @ESC_Score1,
			ESC_GradeValue7 = @ESC_GradeValue7,
			ESC_GradeValue8 = @ESC_GradeValue8,
			ESC_Score4 = @ESC_Score4
		WHERE ESC_ID = @ESCID
	END
	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
END CATCH

GO


