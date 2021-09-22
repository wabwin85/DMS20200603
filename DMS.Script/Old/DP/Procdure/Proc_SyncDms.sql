DROP PROCEDURE [DP].[Proc_SyncDms]
GO


CREATE PROCEDURE [DP].[Proc_SyncDms]
AS
BEGIN
	EXEC DP.Proc_SyncDmsSubInfo;
	EXEC DP.Proc_SyncDmsAuth;
	EXEC DP.Proc_SyncDmsContractMaster;
	EXEC DP.Proc_SyncDmsContract;
	EXEC DP.Proc_SyncDmsContractAttr;
	EXEC DP.Proc_SyncDmsBasicAttr;
	EXEC DP.Proc_SyncDmsThirdCompany;
	EXEC DP.Proc_SyncDmsLicenceAttr;
	EXEC DP.Proc_SyncDmsLicenceAlert;
	EXEC DP.Proc_SyncDmsComp;
	EXEC DP.Proc_SyncSendFeedbackMail;
	
	DECLARE @DealerId UNIQUEIDENTIFIER;
	
	DECLARE CUR_CONDITION CURSOR  
	FOR
	    SELECT DMA_ID
	    FROM   dbo.DealerMaster
	
	OPEN CUR_CONDITION
	FETCH NEXT FROM CUR_CONDITION INTO @DealerId
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    EXEC DP.Proc_SyncDmsBasicInfo @DealerId;
	    EXEC DP.Proc_SyncDmsAreaInfo @DealerId;
	    EXEC DP.Proc_SyncDmsRegInfo @DealerId;
	    EXEC DP.Proc_SyncDmsContact @DealerId;
	    
	    EXEC DP.Proc_SyncDmsSummary @DealerId;
	    
	    FETCH NEXT FROM CUR_CONDITION INTO @DealerId
	END
	CLOSE CUR_CONDITION
	DEALLOCATE CUR_CONDITION
	
	EXEC DP.Proc_SyncSendAlertMail;
	EXEC DP.Proc_SyncSendCfdaMail;
END
GO


