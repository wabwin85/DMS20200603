DROP PROCEDURE [DP].[Proc_SyncDmsContractAttr]
GO


CREATE PROCEDURE [DP].[Proc_SyncDmsContractAttr]
AS
BEGIN
	DECLARE @error_number INT
	DECLARE @error_serverity INT
	DECLARE @error_state INT
	DECLARE @error_message NVARCHAR(256)
	DECLARE @error_line INT
	DECLARE @error_procedure NVARCHAR(256)
	DECLARE @vError NVARCHAR(1000)
	
	BEGIN TRY
		DECLARE @ModleId UNIQUEIDENTIFIER;
		SET @ModleId = '00000001-0003-0005-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @ModleId;
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, Bu, ModleID, Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       comTb.DMA_ID,
		       comTb.Division,
		       @ModleId,
		       comTb.Division,
		       DIC.VALUE1,
		       AT_Name,
		       CONVERT(NVARCHAR(19), comTb.EffectiveDate, 121),
		       CONVERT(NVARCHAR(19), comTb.ExpirationDate, 121),
		       li.IDENTITY_NAME,
		       CONVERT(NVARCHAR(19), a.AT_UploadDate, 121),
		       '../../Download.aspx?FileId=' + CONVERT(NVARCHAR(50), AT_ID) + '&FileType=dcms' 
		       AT_Url,
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(ORDER BY AT_Name)
		FROM   Attachment a
		       LEFT JOIN Lafite_Identity li
		            ON  a.AT_UploadUser = li.Id
		       INNER JOIN dbo.Lafite_DICT DIC
		            ON  DIC.DICT_KEY = a.AT_Type
		       INNER JOIN (
		                SELECT CAP_ID AS ContractID,
		                       CAP_DMA_ID AS DMA_ID,
		                       CAP_Division Division,
		                       CAP_EffectiveDate EffectiveDate,
		                       CAP_ExpirationDate ExpirationDate
		                FROM   ContractAppointment
		                UNION
		                SELECT CAM_ID,
		                       CAM_DMA_ID,
		                       CAM_Division,
		                       CAM_Amendment_EffectiveDate EffectiveDate,
		                       CAM_Agreement_ExpirationDate ExpirationDate
		                FROM   ContractAmendment
		                UNION
		                SELECT CRE_ID,
		                       CRE_DMA_ID,
		                       CRE_Division,
		                       CRE_Agrmt_EffectiveDate_Renewal EffectiveDate,
		                       CRE_Agrmt_ExpirationDate_Renewal ExpirationDate
		                FROM   ContractRenewal
		                UNION
		                SELECT CTE_ID,
		                       CTE_DMA_ID,
		                       CTE_Division,
		                       CTE_Termination_EffectiveDate EffectiveDate,
		                       CTE_Agreement_ExpirationDate ExpirationDate
		                FROM   ContractTermination
		            ) comTb
		            ON  comTb.ContractID = a.AT_Main_ID
		WHERE  a.AT_Type <> 'T1_Certificates'
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsContractAttrµÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


