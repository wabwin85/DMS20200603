DROP PROCEDURE [DP].[Proc_SyncDmsContractMaster]
GO


CREATE PROCEDURE [DP].[Proc_SyncDmsContractMaster]
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
		SET @ModleId = '00000001-0003-0001-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @ModleId;
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, Bu, ModleID, Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, Column9, Column10, Column11, Column12, Column13, Column14, Column15, Column16, Column17, Column18, Column19, Column20, Column21, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       A.DCM_DMA_ID,
		       C.ATTRIBUTE_NAME,
		       @ModleId,
		       D.VALUE1 AS '����������',
		       C.ATTRIBUTE_NAME AS 'BU',
		       CASE DCM_MarketType
		            WHEN 0 THEN '��ͨ�г�'
		            WHEN 1 THEN '�����г�'
		            ELSE '���ֺ�����'
		       END AS '�г�����',
		       ISNULL(DCM_ContractType, '') AS 'Contract Type',
		       ISNULL(DCM_BSCEntity, '') AS 'BSC Entity',
		       ISNULL(DCM_Exclusiveness, '') AS 'Exclusiveness',
		       ISNULL(CONVERT(NVARCHAR(10), DCM_EffectiveDate, 121), '') AS '��ͬ��ʼʱ��',
		       ISNULL(CONVERT(NVARCHAR(10), DCM_ExpirationDate, 121), '') AS '��ͬ��ֹʱ��',
		       DCM_ProductLine AS '��Ʒ��',
		       ISNULL(DCM_Pricing_Discount, '') AS '�۸��ۿ�',
		       ISNULL(DCM_Pricing_Rebate, '') AS '����',
		       ISNULL(DCM_Credit_Limit, '') AS '�Ŵ����',
		       ISNULL(DCM_Credit_Term, '') AS '��������',
		       ISNULL(DCM_Payment_Term, '') AS '���ʽ',
		       ISNULL(DCM_Security_Deposit, '') AS 'Security Deposit',
		       ISNULL(DCM_Guarantee, '') AS 'Guarantee',
		       ISNULL(DCM_GuaranteeRemark, '') AS '������ע',
		       ISNULL(CONVERT(NVARCHAR(10), DCM_TerminationDate, 121), '') AS 'Termination Date',
		       ISNULL(CONVERT(NVARCHAR(10), DCM_FirstContractDate, 121), '') AS '�״κ�ͬʱ��',
		       ISNULL(CONVERT(NVARCHAR(10), DCM_ExtensionDate, 121), '') AS '��չʱ��',
		       B.CC_NameCN AS '��ͬ����ID',
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(ORDER BY DCM_MarketType, DCM_ContractType, DCM_ProductLine)
		FROM   DealerContractMaster A
		       INNER JOIN interface.ClassificationContract B
		            ON  A.DCM_CC_ID = B.CC_ID
		       INNER JOIN View_BU C
		            ON  A.DCM_Division = C.DivisionId
		       INNER JOIN Lafite_DICT D
		            ON  A.DCM_DealerType = D.DICT_KEY
		            AND D.DICT_TYPE = 'CONST_Dealer_Type'
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsContractMaster��' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + '�г���[����ţ�' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']��' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


