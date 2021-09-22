DROP PROCEDURE [interface].[P_I_EW_ScoreCardStatusUpdate]
GO

CREATE PROCEDURE [interface].[P_I_EW_ScoreCardStatusUpdate]
@BUCode nvarchar(10), --BU���
@DMSFormNo nvarchar(30), --DMS���ݱ��
@EWFFormNo nvarchar(30), --E-Workflow���ݱ��
@UpdateDate datetime, --�ύʱ��
@UpdateType nvarchar(20),  --����״̬
@UpdateRemark nvarchar(4000),--��ע˵��
@UpdateUserName nvarchar(10), --�ύ������
@RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT

WITH EXEC AS CALLER
AS
	DECLARE @UpdateTypeName  NVARCHAR(100)
	DECLARE @ESCID  UNIQUEIDENTIFIER
	DECLARE @CHECK  INT
	
SET NOCOUNT ON

BEGIN TRY
BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	IF ISNULL(@BUCode,'')<>'' AND (@BUCode='18' or @BUCode = '22')
	BEGIN
		IF ISNULL(@UpdateType,'')='DSMSubmit'
		BEGIN
			SET @UpdateTypeName='DSM�ύ'
		END
		
		IF ISNULL(@UpdateType,'')='Cancel'
		BEGIN
			SET @UpdateTypeName='�����˳���'
		END
		
		IF ISNULL(@UpdateType,'')='RSMApprove'  
		BEGIN
			SET @UpdateTypeName='RSM����ͨ��'
		END
		
		IF ISNULL(@UpdateType,'')='RSMReject'
		BEGIN
			SET @UpdateTypeName='RSM�����ܾ�'
		END
		
		IF ISNULL(@UpdateType,'')='CMSubmit'
		BEGIN
			SET @UpdateTypeName='CM�ύ'
		END
		
		IF ISNULL(@UpdateType,'')='CMReject'
		BEGIN
			SET @UpdateTypeName='CM�����ܾ�'
		END
		
		IF ISNULL(@UpdateType,'')='ProcessComplete'
		BEGIN
			SET @UpdateTypeName='�������'
		END
		
		SELECT @ESCID=ESCH_ID FROM EndoScoreCardHeader WHERE ESCH_No=@DMSFormNo;
		
		IF ISNULL(@UpdateType,'')='DSMSubmit'
		BEGIN
			UPDATE EndoScoreCardHeader
			SET ESCH_Status = 'Submitted'
			WHERE ESCH_ID = @ESCID
			
			--��ɾ��ԭ�м�¼
			DELETE FROM EndoScoreCardDetail
			WHERE ESCD_ESCH_ID = @ESCID
			AND ESCD_WFBIZINDEX < 10
			
			insert into EndoScoreCardDetail
			select NEWID(),ESCH_ID,t1.ManageContent,Content,AssessItem,FormulaSource,TotalScore,ScoreContent,Score,ScoreDetail
			from (SELECT a.*,b.BUID,b.DMSNo FROM [Interface].[BIZ_SCORECARD_SCORELIST] a,
			[Interface].[BIZ_SCORECARD_MAIN] b
			where a.WFINSTANCEID = b.WFINSTANCEID
			and b.DMSNo = @DMSFormNo
			and b.WFINSTANCEID = @EWFFormNo) t1,
			EndoScoreCardHeader T2,
			(SELECT 1 AS ManageContent,'�г�����' as Content
			union
			SELECT 2 AS ManageContent,'���ݹ���' as Content
			union
			SELECT 3 AS ManageContent,'��������' as Content
			union
			SELECT 4 AS ManageContent,'��Ա���Ŷӹ���' as Content
			) t3
			WHERE t1.DMSNo = t2.ESCH_NO
			and t1.ManageContent = t3.ManageContent
			
		END
		ELSE IF (ISNULL(@UpdateType,'')='CMSubmit')
		BEGIN
			--��ɾ��ԭ�м�¼
			DELETE FROM EndoScoreCardDetail
			WHERE ESCD_ESCH_ID = @ESCID
			AND ESCD_WFBIZINDEX < 10
			--����
			insert into EndoScoreCardDetail
			select NEWID(),ESCH_ID,t1.ManageContent,Content,AssessItem,FormulaSource,TotalScore,ScoreContent,Score,ScoreDetail
			from (SELECT a.*,b.BUID,b.DMSNo FROM [Interface].[BIZ_SCORECARD_SCORELIST] a,
			[Interface].[BIZ_SCORECARD_MAIN] b
			where a.WFINSTANCEID = b.WFINSTANCEID
			and b.DMSNo = @DMSFormNo
			and b.WFINSTANCEID = @EWFFormNo) t1,
			EndoScoreCardHeader T2,
			(SELECT 1 AS ManageContent,'�г�����' as Content
			union
			SELECT 2 AS ManageContent,'���ݹ���' as Content
			union
			SELECT 3 AS ManageContent,'��������' as Content
			union
			SELECT 4 AS ManageContent,'��Ա���Ŷӹ���' as Content
			) t3
			WHERE t1.DMSNo = t2.ESCH_NO
			and t1.ManageContent = t3.ManageContent
			
		END
		ELSE IF (ISNULL(@UpdateType,'')='RSMReject' or ISNULL(@UpdateType,'')='CMReject')
		BEGIN
			UPDATE EndoScoreCardHeader
			SET ESCH_Status = 'Reject'
			WHERE ESCH_ID = @ESCID
			
		END
		ELSE IF ISNULL(@UpdateType,'')='ProcessComplete'
		BEGIN
			UPDATE EndoScoreCardHeader
			SET ESCH_Status = 'Confirming'
			WHERE ESCH_ID = @ESCID
			
		END
		ELSE IF ISNULL(@UpdateType,'')='Cancel'
		BEGIN
			UPDATE EndoScoreCardHeader
			SET ESCH_Status = 'Cancel'
			WHERE ESCH_ID = @ESCID
			
		END
		
		
		IF @ESCID IS NOT NULL
		BEGIN
			INSERT INTO ScoreCardLog (SCL_ID,SCL_ESC_ID,SCL_OperUser,SCL_OperDate,SCL_OperType,SCL_OperNote)
			VALUES(NEWID(),@ESCID,@UpdateUserName,@UpdateDate,@UpdateTypeName,@UpdateRemark)
		END
		
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


