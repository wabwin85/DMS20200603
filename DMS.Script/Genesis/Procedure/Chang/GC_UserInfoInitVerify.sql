

/****** Object:  StoredProcedure [dbo].[GC_UserInfoInitVerify]    Script Date: 2019/11/26 14:39:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[GC_UserInfoInitVerify]
	(
		@UserId uniqueidentifier,
		@IsImport int,
		@RtnVal NVARCHAR(20) OUTPUT,
		@RtnMsg NVARCHAR(2000) OUTPUT
	)
AS

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

SET @RtnVal = 'Success'
SET @RtnMsg = ''

/*�Ƚ������־��Ϊ0*/
UPDATE Lafite_IDENTITY_Init SET IsError = 0,ErrorMsg = NULL
WHERE ImportUser = @UserId 


update d  SET UserId=u.Id
from Lafite_IDENTITY_Init d inner join 
	Lafite_IDENTITY u on d.LoginId=u.IDENTITY_CODE
where u.DELETE_FLAG=0 and IDENTITY_TYPE='user' and d.ImportUser=@UserId

update d  SET IsError = 1, ErrorMsg = '�û�������'
from Lafite_IDENTITY_Init d
where d.ImportUser=@UserId and UserId is null



IF (SELECT COUNT(*) FROM Lafite_IDENTITY_Init WHERE IsError = 1 AND ImportUser = @UserId) > 0
	BEGIN
		/*������ڴ����򷵻�Error*/
		SET @RtnVal = 'Error'
	END
ELSE
	BEGIN
		IF @IsImport = 1
			BEGIN				
				update u  SET JoinDate=d.JoinDate,AccountingDate=d.AccountingDate
				from Lafite_IDENTITY_Init d inner join 
					Lafite_IDENTITY u on d.LoginId=u.IDENTITY_CODE
				where u.Id=d.UserId and d.ImportUser=@UserId
			END

		SET @RtnVal = 'Success'
 
	END

COMMIT TRAN

SET NOCOUNT OFF
RETURN 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'

	--��¼������־��ʼ
	DECLARE @error_line   INT
	DECLARE @error_number   INT
	DECLARE @error_message   NVARCHAR (256)
	DECLARE @vError   NVARCHAR (1000)
	SET @error_line = ERROR_LINE ()
	SET @error_number = ERROR_NUMBER ()
	SET @error_message = ERROR_MESSAGE ()
	SET @vError =
			'��'
			+ CONVERT (NVARCHAR (10), @error_line)
			+ '����[�����'
			+ CONVERT (NVARCHAR (10), @error_number)
			+ '],'
			+ @error_message
	SET @RtnMsg = @vError
	RETURN -1

END CATCH
GO


