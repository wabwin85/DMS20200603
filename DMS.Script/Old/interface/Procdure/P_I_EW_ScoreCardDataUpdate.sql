DROP PROCEDURE [interface].[P_I_EW_ScoreCardDataUpdate]
GO

CREATE PROCEDURE [interface].[P_I_EW_ScoreCardDataUpdate]
@ESC_No nvarchar(30),  --���ݺ�
@ESC_GradeValue1 nvarchar(30), --�����ƻ�����
@ESC_GradeValue2 nvarchar(30), --����������ɹ���ҽԺ�²�Ʒ������
@ESC_Score1 nvarchar(3), --�г������ܵ÷�
@ESC_GradeValue7 nvarchar(30),--ÿ��ѧϰ����
@ESC_GradeValue8 nvarchar(30),--���Է���
@ESC_Score4 nvarchar(3),--��ѵ���ںͿ��Դ���ܵ÷�
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
		SET @RtnMsg = '���ݱ�Ų����ڣ�'
	END
	ELSE
	BEGIN
		--����DMS������������
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
    --��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
END CATCH

GO


