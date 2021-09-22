

/****** Object:  StoredProcedure [dbo].[GC_HospitalPositionInitVerify]    Script Date: 2019/11/27 15:56:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[GC_HospitalPositionInitVerify]
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

/*先将错误标志设为0*/
UPDATE HospitalPositionInit SET IsError = 0,ErrorMsg = NULL
WHERE ImportUser = @UserId 


update d  SET [HospitalID]=s.HOS_ID
from HospitalPositionInit d inner join 
	Hospital s on d.HospitalCode=s.HOS_Key_Account
where s.HOS_ActiveFlag=1  and d.ImportUser=@UserId

update d  SET IsError = 1, ErrorMsg = '医院不存在'
from HospitalPositionInit d
where d.ImportUser=@UserId and [HospitalID] is null



IF (SELECT COUNT(*) FROM HospitalPositionInit WHERE IsError = 1 AND ImportUser = @UserId) > 0
	BEGIN
		/*如果存在错误，则返回Error*/
		SET @RtnVal = 'Error'
	END
ELSE
	BEGIN
		--IF @IsImport = 1
		--	BEGIN				
		--		update u  SET JoinDate=d.JoinDate,AccountingDate=d.AccountingDate
		--		from Lafite_IDENTITY_Init d inner join 
		--			Lafite_IDENTITY u on d.LoginId=u.IDENTITY_CODE
		--		where u.Id=d.UserId and d.ImportUser=@UserId
		--	END

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

	--记录错误日志开始
	DECLARE @error_line   INT
	DECLARE @error_number   INT
	DECLARE @error_message   NVARCHAR (256)
	DECLARE @vError   NVARCHAR (1000)
	SET @error_line = ERROR_LINE ()
	SET @error_number = ERROR_NUMBER ()
	SET @error_message = ERROR_MESSAGE ()
	SET @vError =
			'行'
			+ CONVERT (NVARCHAR (10), @error_line)
			+ '出错[错误号'
			+ CONVERT (NVARCHAR (10), @error_number)
			+ '],'
			+ @error_message
	SET @RtnMsg = @vError
	RETURN -1

END CATCH
GO


