DROP PROCEDURE [DP].[Proc_SyncDmsContract]
GO


CREATE PROCEDURE [DP].[Proc_SyncDmsContract]
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
		SET @ModleId = '00000001-0003-0004-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @ModleId;
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, Bu, ModleID, Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, Column9, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       mast.DMA_ID,
		       Division,
		       @ModleId,
		       ll.VALUE1 ContractType,
		       EffectiveDate ContractStartTime,
		       ExpirationDate ContractEndTime,
		       Division ContractDivision,
		       cc.CC_NameCN ContractSubDept,
		       l.VALUE1 ContractStatus,
		       ContractID ContractId,
		       mast.DMA_DealerType AS ContractDealerType,
		       ParmetType ContractTypeId,
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(ORDER BY ll.VALUE1, Division, cc.CC_NameCN)
		FROM   (
		           SELECT appoin.CAP_ID AS ContractID,
		                  appoin.CAP_CM_ID AS CmID,
		                  appoin.CAP_DMA_ID AS DealerID,
		                  appoin.CAP_Division AS Division,
		                  CONVERT(NVARCHAR(10), appoin.CAP_EffectiveDate, 120) AS EffectiveDate,
		                  CONVERT(NVARCHAR(10), appoin.CAP_ExpirationDate, 120) AS ExpirationDate,
		                  appoin.CAP_Status AS ContStatus,
		                  appoin.CAP_Type AS ContType,
		                  'Appointment' AS ParmetType,
		                  appoin.CAP_Update_Date AS UpdateDate,
		                  appoin.CAP_SubDepID AS SubDepID
		           FROM   ContractAppointment appoin
		           UNION
		           SELECT amend.CAM_ID AS ContractID,
		                  amend.CAM_CM_ID AS CmID,
		                  amend.CAM_DMA_ID AS DealerID,
		                  amend.CAM_Division AS Division,
		                  CONVERT(NVARCHAR(10), amend.CAM_Agreement_EffectiveDate, 120) AS EffectiveDate,
		                  CONVERT(NVARCHAR(10), amend.CAM_Agreement_ExpirationDate, 120) AS ExpirationDate,
		                  amend.CAM_Status AS ContStatus,
		                  amend.CAM_Type AS ContType,
		                  'Amendment' AS ParmetType,
		                  amend.CAM_Update_Date AS UpdateDate,
		                  amend.CAM_SubDepID
		           FROM   ContractAmendment amend
		           UNION
		           SELECT rene.CRE_ID AS ContractID,
		                  rene.CRE_CM_ID AS CmID,
		                  rene.CRE_DMA_ID AS DealerID,
		                  rene.CRE_Division AS Division,
		                  CONVERT(NVARCHAR(10), rene.CRE_Agrmt_EffectiveDate_Renewal, 120) AS EffectiveDate,
		                  CONVERT(NVARCHAR(10), rene.CRE_Agrmt_ExpirationDate_Renewal, 120) AS ExpirationDate,
		                  rene.CRE_Status AS ContStatus,
		                  rene.CRE_Type AS ContType,
		                  'Renewal' AS ParmetType,
		                  rene.CRE_Update_Date,
		                  rene.CRE_SubDepID
		           FROM   ContractRenewal rene
		           UNION
		           SELECT cte.CTE_ID AS ContractID,
		                  cte.CTE_CM_ID AS CmID,
		                  cte.CTE_DMA_ID AS DealerID,
		                  cte.CTE_Division AS Division,
		                  CONVERT(NVARCHAR(10), cte.CTE_Termination_EffectiveDate, 120) AS EffectiveDate,
		                  NULL AS ExpirationDate,
		                  cte.CTE_Status AS ContStatus,
		                  cte.CTE_Type AS ContType,
		                  'Termination' AS ParmetType,
		                  cte.CTE_Update_Date,
		                  cte.CTE_SubDepID
		           FROM   ContractTermination cte
		       ) ToTable
		       LEFT JOIN dbo.DealerMaster mast
		            ON  mast.DMA_ID = ToTable.DealerID
		       LEFT JOIN interface.ClassificationContract cc
		            ON  ToTable.SubDepID = cc.CC_Code
		       LEFT JOIN Lafite_DICT l
		            ON  ContStatus = l.DICT_KEY
		            AND l.DICT_TYPE = 'CONST_Contract_Status'
		       LEFT JOIN Lafite_DICT ll
		            ON  ParmetType = ll.DICT_KEY
		            AND ll.DICT_TYPE = 'CONST_Contract_Type'
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsContractµÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


