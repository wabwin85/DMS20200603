
USE [BSC_Prd]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create procedure dbo.CFDASynchronization
(
 @ContractId      UNIQUEIDENTIFIER
)as
begin
    DECLARE @dealerid  NVARCHAR(200);
	DECLARE	@DML_CurLicenseNo NVARCHAR(200);
	DECLARE	@DML_CurLicenseValidFrom NVARCHAR(200);
	DECLARE	@DML_CurLicenseValidTo NVARCHAR(200);
	DECLARE	@newDML_CurSecondClassCatagory NVARCHAR(200);
	DECLARE	@DML_CurFilingNo NVARCHAR(200);
	DECLARE	@DML_CurFilingValidFrom NVARCHAR(200);
	DECLARE	@DML_CurFilingValidTo NVARCHAR(200);
	DECLARE	@newDML_CurThirdClassCatagory NVARCHAR(200);
	DECLARE	@DML_CurUpdateDate NVARCHAR(200);
	DECLARE @DML_CurRespPerson NVARCHAR(200);
	DECLARE @DML_CurLegalPerson NVARCHAR(200);

   
	

select @dealerid=DML_DMA_ID,@DML_CurLicenseNo=DML_NewLicenseNo,
@DML_CurLicenseValidFrom=DML_NewLicenseValidFrom,@DML_CurLicenseValidTo=DML_NewLicenseValidTo, 
@newDML_CurSecondClassCatagory=DML_NewSecondClassCatagory,@DML_CurFilingNo=DML_NewFilingNo,
@DML_CurFilingValidFrom=DML_NewFilingValidFrom ,@DML_CurFilingValidTo=DML_NewFilingValidTo ,
@newDML_CurThirdClassCatagory=DML_NewThirdClassCatagory ,@DML_CurUpdateDate=DML_NewApplyDate,
@DML_CurRespPerson=DML_NewCurRespPerson,@DML_CurLegalPerson=DML_NewCurLegalPerson 
from DealerMasterLicenseModify d where d.DML_MID=@ContractId



update  DealerMasterLicense set DML_CurLicenseNo=@DML_CurLicenseNo,
DML_CurLicenseValidFrom=@DML_CurLicenseValidFrom,DML_CurLicenseValidTo=@DML_CurLicenseValidTo, 
DML_CurSecondClassCatagory=DML_CurSecondClassCatagory+@newDML_CurSecondClassCatagory,DML_CurFilingNo=@DML_CurFilingNo,
DML_CurFilingValidFrom=@DML_CurFilingValidFrom ,DML_CurFilingValidTo=@DML_CurFilingValidTo,
DML_CurThirdClassCatagory=DML_CurThirdClassCatagory+@newDML_CurThirdClassCatagory,DML_CurUpdateDate=@DML_CurUpdateDate,
DML_CurRespPerson=@DML_CurRespPerson,DML_CurLegalPerson=@DML_CurLegalPerson 
where DML_DMA_ID=@dealerid 

delete from SAPWarehouseAddress where SWA_DMA_ID=@dealerid

insert into SAPWarehouseAddress (SWA_ID,SWA_DMA_ID,SWA_Name,SWA_WH_Code,SWA_WH_Type,SWA_WH_Address,SWA_ActiveFlag,SWA_CreateDate,SWA_UpdateDate,SWA_AddressType,SWA_IsSendAddress)
select NEWID(), ST_DMA_ID,DMA_ChineseName,ST_WH_Code,'SAP',ST_Address ,'1' ,getdate(),null,ST_Type,ST_IsSendAddress from  SAPWarehouseAddress_temp
inner join DealerMaster d on d.dma_id=ST_DMA_ID
where ST_DMA_ID=@dealerid and ST_DML_MID=@ContractId

insert into Attachment(AT_ID,AT_Main_ID,AT_Name,AT_Url,AT_Type,AT_UploadUser,AT_UploadDate)
select newid(),@dealerid ,a.AT_Name,a.AT_Url,a.AT_Type,a.AT_UploadUser,AT_UploadDate from Attachment a
where a.AT_Main_ID=@ContractId


end

