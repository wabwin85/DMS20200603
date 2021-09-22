DROP PROCEDURE [Contract].[Proc_ContractCopy]
GO


CREATE PROCEDURE [Contract].[Proc_ContractCopy](@ContractId UNIQUEIDENTIFIER, @UserId UNIQUEIDENTIFIER)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
		
		DECLARE @NewId UNIQUEIDENTIFIER;
		DECLARE @Division NVARCHAR(10);
		SET @NewId = NEWID();
		SELECT @Division = DepAbbr
		FROM   interface.MDM_EmployeeMaster A,
		       Lafite_IDENTITY B
		WHERE  A.account = B.IDENTITY_CODE
		       AND B.Id = @UserId
		
		DECLARE @ContractNo NVARCHAR(100)
		SET @ContractNo = ''
		EXEC dbo.GC_GetNextAutoNumberForSample @Division, 'AP', 'Next_ContractAppointment', @ContractNo OUTPUT
		
		INSERT INTO [Contract].AppointmentMain
		  (ContractId, ContractNo, EId, EName, RequestDate, DealerType, ApplicantDep, REASON, FORMERNAME, TypeRemark, ReagionRSM, ContractStatus, CreateUser, CreateDate)
		SELECT @NewId,
		       @ContractNo,
		       EId,
		       EName,
		       CONVERT(DATETIME, CONVERT(NVARCHAR(10), GETDATE(), 121), 121),
		       DealerType,
		       ApplicantDep,
		       REASON,
		       FORMERNAME,
		       TypeRemark,
		       ReagionRSM,
		       'Draft',
		       CreateUser,
		       GETDATE()
		FROM   [Contract].AppointmentMain
		WHERE  ContractId = @ContractId
		
		INSERT INTO [Contract].AppointmentCandidate
		  (ContractId, CompanyName, CompanyEName, CompanyID, IsEquipment, Contact, EMail, OfficeNumber, Mobile, OfficeAddress, CompanyType, EstablishedTime, Capital, Website, LPSAPCode, SAPCode, DealerMark, IsForeign, ForeignRemark)
		SELECT @NewId,
		       CompanyName,
		       CompanyEName,
		       NEWID(),
		       IsEquipment,
		       Contact,
		       EMail,
		       OfficeNumber,
		       Mobile,
		       OfficeAddress,
		       CompanyType,
		       EstablishedTime,
		       Capital,
		       Website,
		       LPSAPCode,
		       SAPCode,
		       DealerMark,
		       IsForeign,
		       ForeignRemark
		FROM   [Contract].AppointmentCandidate
		WHERE  ContractId = @ContractId
		
		INSERT INTO [Contract].AppointmentCompetency
		  (ContractId, Healthcare, Inter, KOL, MNC, Justification)
		SELECT @NewId,
		       Healthcare,
		       Inter,
		       KOL,
		       MNC,
		       Justification
		FROM   [Contract].AppointmentCompetency
		WHERE  ContractId = @ContractId
		
		INSERT INTO [Contract].AppointmentDocuments
		  (ContractId, BizLicense, MedicalLicense, Tax, BA, MA, TA, OOC, OA, Registration, RA, IsThreeLicense)
		SELECT @NewId,
		       BizLicense,
		       MedicalLicense,
		       Tax,
		       BA,
		       MA,
		       TA,
		       OOC,
		       OA,
		       Registration,
		       RA,
		       IsThreeLicense
		FROM   [Contract].AppointmentDocuments
		WHERE  ContractId = @ContractId
		
		INSERT INTO [Contract].AppointmentProposals
		  (ContractId, ContractType, BSC, Exclusiveness, Attachment)
		SELECT @NewId,
		       ContractType,
		       BSC,
		       Exclusiveness,
		       Attachment
		FROM   [Contract].AppointmentProposals
		WHERE  ContractId = @ContractId
		
		INSERT INTO [Contract].AppointmentJustification
		  (ContractId, Jus1_QDJL, Jus1_BKQY, Jus1_GJ, Jus1_QYF, Jus2_GSDZ, Jus3_JXSLX, Jus3_DZYY, Jus4_FWFW, Jus4_EWFWFW, Jus4_YWFW, Jus4_SQQY, Jus4_SQFW, Jus5_SFCD, Jus5_YYSM, Jus5_JTMS, Jus6_ZMFS, Jus6_TJR, Jus6_QTFS, Jus6_JXSPG, Jus6_YY, Jus6_QTXX, Jus6_XWYQ, Jus7_ZZBJ, Jus7_SX, Jus7_SYLW, Jus7_HDMS, Jus8_YWZB, Jus8_QTQK, Jus8_TSYY, Jus8_SFFGD, Jus8_FGDFS, Jus8_JL, Jus8_JLFS)
		SELECT @NewId,
		       Jus1_QDJL,
		       Jus1_BKQY,
		       Jus1_GJ,
		       Jus1_QYF,
		       Jus2_GSDZ,
		       Jus3_JXSLX,
		       Jus3_DZYY,
		       Jus4_FWFW,
		       Jus4_EWFWFW,
		       Jus4_YWFW,
		       Jus4_SQQY,
		       Jus4_SQFW,
		       Jus5_SFCD,
		       Jus5_YYSM,
		       Jus5_JTMS,
		       Jus6_ZMFS,
		       Jus6_TJR,
		       Jus6_QTFS,
		       Jus6_JXSPG,
		       Jus6_YY,
		       Jus6_QTXX,
		       Jus6_XWYQ,
		       Jus7_ZZBJ,
		       Jus7_SX,
		       Jus7_SYLW,
		       Jus7_HDMS,
		       Jus8_YWZB,
		       Jus8_QTQK,
		       Jus8_TSYY,
		       Jus8_SFFGD,
		       Jus8_FGDFS,
		       Jus8_JL,
		       Jus8_JLFS
		FROM   [Contract].AppointmentJustification
		WHERE  ContractId = @ContractId
		
		INSERT INTO [Contract].PreContractService
		  (ServiceId, ContractId, Pre7_FWLX, Pre7_YJ, Pre7_YJBL, Pre7_LR, Pre7_LRFW, Pre7_JDXFK, Pre7_QKDJ, Pre7_QT, SortNo, Pre7_FWLXValue)
		SELECT NEWID(),
		       @NewId,
		       Pre7_FWLX,
		       Pre7_YJ,
		       Pre7_YJBL,
		       Pre7_LR,
		       Pre7_LRFW,
		       Pre7_JDXFK,
		       Pre7_QKDJ,
		       Pre7_QT,
		       SortNo,
		       Pre7_FWLXValue
		FROM   [Contract].PreContractService
		WHERE  ContractId = @ContractId
		
		
		COMMIT TRAN
		RETURN 1
	END TRY
	
	BEGIN CATCH
		ROLLBACK TRAN
		
		DECLARE @error_number INT
		DECLARE @error_serverity INT
		DECLARE @error_state INT
		DECLARE @error_message NVARCHAR(256)
		DECLARE @error_line INT
		DECLARE @error_procedure NVARCHAR(256)
		DECLARE @vError NVARCHAR(1000)
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = ISNULL(@error_procedure, '') + 'µÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, ''))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, ''))
		    + ']£¬' + ISNULL(@error_message, '')
		
		RAISERROR(@vError, @error_serverity, @error_state)
	END CATCH
END
GO


