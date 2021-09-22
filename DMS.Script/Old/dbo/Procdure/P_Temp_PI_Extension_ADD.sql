DROP Procedure [dbo].[P_Temp_PI_Extension_ADD]
GO


CREATE Procedure [dbo].[P_Temp_PI_Extension_ADD]
@SAPCode NVARCHAR(50),
@SubBU NVARCHAR(50)
 
AS
	DECLARE @LastContractId uniqueidentifier
	DECLARE @DealerID uniqueidentifier
	DECLARE @SubDealerID uniqueidentifier
	DECLARE @CC_ID uniqueidentifier
	DECLARE @SubCC_ID uniqueidentifier
	
	
	DECLARE @DCL_ID uniqueidentifier
	
	CREATE TABLE #ConTol
	(
		ContractId uniqueidentifier,
		DealerId uniqueidentifier,
		SubBU NVARCHAR(50),
		MarketType INT,
		BeginDate DATETIME,
		EndDate DATETIME,
		ContractType NVARCHAR(50),
		UpdateDate DATETIME
	)
	
	CREATE TABLE #MPDat
	(
		DAT_ID uniqueidentifier,
		DAT_ID_New uniqueidentifier
	)
	
SET NOCOUNT ON
BEGIN  
	select @DealerID=DMA_ID from DealerMaster a where a.DMA_SAP_Code=@SAPCode
	SELECT @CC_ID=CC_ID FROM INTERFACE.ClassificationContract A WHERE A.CC_Code=@SubBU
	
	
	INSERT INTO #ConTol (ContractId,DealerId,MarketType,BeginDate,EndDate,SubBU,ContractType,UpdateDate)
	SELECT a.CAP_ID,a.CAP_DMA_ID,a.CAP_MarketType,CAP_EffectiveDate,CAP_ExpirationDate,a.CAP_SubDepID ,'Appointment',a.CAP_Update_Date 
	from ContractAppointment a 	where a.CAP_Status='Completed' and a.CAP_DMA_ID=@DealerID and a.CAP_SubDepID=@SubBU
	UNION
	SELECT a.CAM_ID,a.CAM_DMA_ID,a.CAM_MarketType,CAM_Amendment_EffectiveDate,CAM_Agreement_ExpirationDate,a.CAM_SubDepID,'Amendment',a.CAM_Update_Date from ContractAmendment a where a.CAM_Status='Completed' and  a.CAM_Territory_IsChange='1' and a.CAM_DMA_ID=@DealerID and a.CAM_SubDepID=@SubBU
	UNION
	SELECT  a.CRE_ID,a.CRE_DMA_ID,a.CRE_MarketType,CRE_Agrmt_EffectiveDate_Renewal,CRE_Agrmt_ExpirationDate_Renewal,a.CRE_SubDepID,'Renewal',a.CRE_Update_Date  from ContractRenewal a where a.CRE_Status='Completed' and a.CRE_DMA_ID=@DealerID and a.CRE_SubDepID=@SubBU


	SELECT TOP 1 @LastContractId=ContractId FROM #ConTol  ORDER BY UpdateDate DESC
	
	if exists (select 1 from DealerAuthorizationTableTemp where DAT_DCL_ID=@LastContractId)
	begin
			select @DCL_ID=DCL_ID from DealerContract  a inner join interface.ClassificationContract  b on a.DCL_CC_ID=b.CC_ID
				where DCL_DMA_ID=@DealerID and b.CC_Code =@SubBU
			
			if @DCL_ID is null
			begin
				set @DCL_ID=NEWID();
				insert into DealerContract (DCL_ID,DCL_StartDate,DCL_StopDate,DCL_ContractNumber,DCL_DMA_ID,DCL_CreatedDate,DCL_CreatedBy,DCL_CC_ID)
				values(@DCL_ID,'2017-03-01','2017-03-31',ISNULL(@SAPCode,'')+'-'+@SubBU,@DealerID,GETDATE(),'00000000-0000-0000-0000-000000000000',@CC_ID)
			end
			delete #MPDat
			
			insert into #MPDat (DAT_ID)
			SELECT DAT_ID
			FROM DealerAuthorizationTableTemp A WHERE A.DAT_DCL_ID=@LastContractId
			
			update #MPDat set DAT_ID_New=NEWID();
			
			INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription,DAT_StartDate,DAT_EndDate,DAT_Type)
			SELECT DAT_PMA_ID,b.DAT_ID_New,@DCL_ID,A.DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription,'2017-03-01','2017-03-31','Temp' 
			FROM DealerAuthorizationTableTemp A 
			inner join #MPDat b on a.DAT_ID=b.DAT_ID
			WHERE A.DAT_DCL_ID=@LastContractId
			
			INSERT INTO DealerAuthorizationTableLog
			(DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription,DAT_StartDate,DAT_EndDate,DAT_Type,DAT_OperationType,DAT_OperationDate,DAT_OperationUser)
			SELECT DAT_PMA_ID,b.DAT_ID_New,DAT_DCL_ID,DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription,'2017-03-01','2017-03-31','Temp','Insert',GETDATE(),'c763e69b-616f-4246-8480-9df40126057c' 
			FROM DealerAuthorizationTableTemp A 
			inner join #MPDat b on a.DAT_ID=b.DAT_ID
			WHERE A.DAT_DCL_ID=@LastContractId
			
			
			INSERT INTO HospitalList (HLA_DAT_ID,HLA_HOS_ID,HLA_ID,HLA_HOS_Depart,HLA_HOS_DepartType,HLA_HOS_DepartRemark,HLA_StartDate,HLA_EndDate)
			SELECT c.DAT_ID_New,A.HOS_ID,NEWID(),A.HOS_Depart,A.HOS_DepartType,A.HOS_DepartRemark,'2017-03-01','2017-03-31'
			FROM ContractTerritory A ,DealerAuthorizationTableTemp B ,#MPDat c
			WHERE A.Contract_ID=B.DAT_ID 
			and c.DAT_ID=b.DAT_ID
			AND B.DAT_DCL_ID=@LastContractId
		end

END


GO


