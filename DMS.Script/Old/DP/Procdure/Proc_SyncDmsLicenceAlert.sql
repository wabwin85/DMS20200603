
DROP PROCEDURE [DP].[Proc_SyncDmsLicenceAlert]
GO

CREATE PROCEDURE [DP].[Proc_SyncDmsLicenceAlert]
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
		SET @ModleId = '00000001-0002-0007-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @ModleId;
		
		DECLARE @SortId INT;
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       DML_DMA_ID,
		       @ModleId,
		       '医疗器械经营许可证信息',
		       CASE 
		            WHEN DML_CurLicenseValidTo < GETDATE() THEN CONVERT(NVARCHAR(10), DML_CurLicenseValidTo, 121) +
		                 '(已过期)'
		            ELSE CONVERT(NVARCHAR(10), DML_CurLicenseValidTo, 121) + '(' + CONVERT(
		                     NVARCHAR(10),
		                     DATEDIFF(DAY, GETDATE(), DML_CurLicenseValidTo)
		                 ) + '天后过期)'
		       END,
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(ORDER BY DML_DMA_ID)
		FROM   DealerMasterLicense
		WHERE  DML_CurLicenseValidTo IS NOT NULL

		SELECT @SortId = MAX(SortId)
		FROM   DP.DealerMaster
		WHERE  ModleID = @ModleId
		
		SET @SortId=ISNULL(@SortId,1);
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       DML_DMA_ID,
		       @ModleId,
		       '医疗器械备案凭证信息',
		       CASE 
		            WHEN DML_CurLicenseValidTo < GETDATE() THEN CONVERT(NVARCHAR(10), DML_CurFilingValidTo, 121) +
		                 '(已过期)'
		            ELSE CONVERT(NVARCHAR(10), DML_CurFilingValidTo, 121) + '(' + CONVERT(
		                     NVARCHAR(10),
		                     DATEDIFF(DAY, GETDATE(), DML_CurFilingValidTo)
		                 ) + '天后过期)'
		       END,
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(ORDER BY DML_DMA_ID) + @SortId
		FROM   DealerMasterLicense
		WHERE  DML_CurFilingValidTo IS NOT NULL

		--SELECT @SortId = MAX(SortId)
		--FROM   DP.DealerMaster
		--WHERE  ModleID = @ModleId
		
		--SET @SortId=ISNULL(@SortId,1);
		
		--INSERT INTO DP.DealerMaster
		--  (ID, DealerId, ModleID, Column1, Column2, IsAction, CreateBy, CreateDate, SortId)
		--SELECT NEWID(),
		--       DealerId,
		--       @ModleId,
		--       Column3,
		--       CASE 
		--            WHEN CONVERT(DATETIME, Column5, 121) < GETDATE() THEN Column5 + '(已过期)'
		--            ELSE Column5 + '(' + CONVERT(
		--                     NVARCHAR(10),
		--                     DATEDIFF(DAY, GETDATE(), CONVERT(DATETIME, Column5, 121))
		--                 ) + '天后过期)'
		--       END,
		--       1,
		--       '00000000-0000-0000-0000-000000000000',
		--       GETDATE(),
		--       ROW_NUMBER() OVER(ORDER BY Column3) + @SortId
		--FROM   DP.DealerMaster
		--WHERE  ModleID = '00000001-0002-0010-0000-000000000000'
		--       AND ISNULL(Column5, '') <> ''

		SELECT @SortId = MAX(SortId)
		FROM   DP.DealerMaster
		WHERE  ModleID = @ModleId
		
		SET @SortId=ISNULL(@SortId,1);
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       TT2.DAT_DMA_ID,
		       @ModleId,
		       '授权产品经营资质',
		       TT2.CA_NameCN + ' 无资质',
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(ORDER BY TT2.CA_NameCN) + @SortId
		FROM   (
		           SELECT b.*,
		                  pc.CA_NameCN,
		                  pc.CC_NameCN,
		                  pc.CA_Code                      
		           FROM   V_DealerContractMaster a
		                  INNER JOIN (
		                           SELECT DISTINCT CC_Code,
		                                  CC_NameCN,
		                                  CC_ID,
		                                  CA_Code,
		                                  CA_ID,
		                                  CC_ProductLineID,
		                                  CC_Division,
		                                  CA_NameCN
		                           FROM   V_ProductClassificationStructure
		                       ) pc
		                       ON  CONVERT(NVARCHAR(10), a.Division) = pc.CC_Division
		                       AND pc.CC_ID = a.CC_ID
		                  INNER JOIN DealerAuthorizationTable b
		                       ON  b.DAT_DMA_ID = a.DMA_ID
		                       AND pc.CC_ProductLineID = b.DAT_ProductLine_BUM_ID
		                       AND b.DAT_PMA_ID = pc.CA_ID
		           WHERE  a.ActiveFlag = '1'
		       ) TT2
		WHERE  NOT EXISTS (
		           SELECT 1
		           FROM   (
		                      SELECT DISTINCT t3.CFN_CustomerFaceNbr,
		                             t1.GM_CATALOG,
		                             CCF.ClassificationId AS CFN_ProductCatagory_PCT_ID,--t3.CFN_ProductCatagory_PCT_ID,
		                             t3.CFN_ProductLine_BUM_ID
		                      FROM   MD.INF_REG t1 inner join
		                             MD.V_INF_UPN_REG_LIST t2 on (t1.REG_NO = t2.REG_NO)
		                             inner join dbo.CFN t3 on (t2.SAP_Code = t3.CFN_Property1)
                                 inner join CfnClassification CCF 
                                   on (    ccf.CfnCustomerFaceNbr=t3.CFN_CustomerFaceNbr 
                                       and ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub( TT2.DAT_DMA_ID)))
		                      WHERE      t3.CFN_Property4 <> -1
		                             AND t1.GM_KIND = '2'
		                             AND t1.GM_CATALOG IN (SELECT VAL
		                                                   FROM   GC_Fn_SplitStringToTable(
		                                                              (
		                                                                  SELECT TOP 1 DML_CurSecondClassCatagory
		                                                                  FROM   DealerMasterLicense
		                                                                  WHERE  DML_DMA_ID = TT2.DAT_DMA_ID
		                                                              ),
		                                                              ','
		                                                          ))
		                      UNION
		                      SELECT DISTINCT t3.CFN_CustomerFaceNbr,
		                             t1.GM_CATALOG,
		                             CCF.ClassificationId AS CFN_ProductCatagory_PCT_ID,--t3.CFN_ProductCatagory_PCT_ID,
		                             t3.CFN_ProductLine_BUM_ID
		                      FROM   MD.INF_REG t1 inner join
		                             MD.V_INF_UPN_REG_LIST t2 on (t1.REG_NO = t2.REG_NO)
		                             inner join dbo.CFN t3 on ( t2.SAP_Code = t3.CFN_Property1)
                                 inner join CfnClassification CCF 
                                   on (    ccf.CfnCustomerFaceNbr=t3.CFN_CustomerFaceNbr 
                                       and ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub( TT2.DAT_DMA_ID))) 
		                      WHERE      t3.CFN_Property4 <> -1
		                             AND t1.GM_KIND = '3'
		                             AND t1.GM_CATALOG IN (SELECT VAL
		                                                   FROM   GC_Fn_SplitStringToTable(
		                                                              (
		                                                                  SELECT TOP 1 DML_CurThirdClassCatagory
		                                                                  FROM   DealerMasterLicense
		                                                                  WHERE  DML_DMA_ID = TT2.DAT_DMA_ID
		                                                              ),
		                                                              ','
		                                                          ))
		                  ) T1
		           WHERE  TT2.DAT_PMA_ID = T1.CFN_ProductCatagory_PCT_ID
		                  OR  TT2.DAT_PMA_ID = T1.CFN_ProductLine_BUM_ID
		       )
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsLicenceAlert第' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + '行出错[错误号：' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']，' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


