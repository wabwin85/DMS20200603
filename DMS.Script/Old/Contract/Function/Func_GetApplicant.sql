DROP FUNCTION [Contract].[Func_GetApplicant]
GO

CREATE FUNCTION [Contract].[Func_GetApplicant]()
--(
--	@SAPID NVARCHAR(20),
--	@SubDepID  NVARCHAR(20)
--)
RETURNS @temp TABLE 
        (SAPID NVARCHAR(50),SubDepID NVARCHAR(50),MinDate datetime,OperType  NVARCHAR(50),EID INT)
WITH 

	EXECUTE AS CALLER
AS

BEGIN


	insert into @temp
	SELECT dm.DMA_SAP_Code,a.SubDepID,a.Update_Date,a.type,c.eid from 
	(
		select  CAP_ID	,DMA_ID ,SubDepID ,Update_Date,Type
		from (
			select a.CAP_ID,a.CAP_DMA_ID AS DMA_ID,a.CAP_Update_Date Update_Date,a.CAP_SubDepID SubDepID ,'Appointment' type from ContractAppointment a where a.CAP_Status='Completed' and CAP_SubDepID is not null
			union
			select a.CAM_ID,a.CAM_DMA_ID,a.CAM_Update_Date,a.CAM_SubDepID,'Amendment' from ContractAmendment a where a.CAM_Status='Completed' and CAM_SubDepID is not null
			union
			select  a.CRE_ID,a.CRE_DMA_ID,a.CRE_Update_Date,a.CRE_SubDepID,'Renewal'  from ContractRenewal a where a.CRE_Status='Completed' and CRE_SubDepID is not null
		) tab
	) a 
	inner join 
	(
		select  DMA_ID ,SubDepID ,min(Update_Date) as MinDate
		from (
			select a.CAP_ID,a.CAP_DMA_ID AS DMA_ID,a.CAP_Update_Date Update_Date,a.CAP_SubDepID SubDepID ,'Appointment' type from ContractAppointment a where a.CAP_Status='Completed' and CAP_SubDepID is not null
			union
			select a.CAM_ID,a.CAM_DMA_ID,a.CAM_Update_Date,a.CAM_SubDepID,'Amendment' from ContractAmendment a where a.CAM_Status='Completed' and CAM_SubDepID is not null
			union
			select  a.CRE_ID,a.CRE_DMA_ID,a.CRE_Update_Date,a.CRE_SubDepID,'Renewal'  from ContractRenewal a where a.CRE_Status='Completed' and CRE_SubDepID is not null
		) tab  group by DMA_ID ,SubDepID 
	) b on a.DMA_ID=b.DMA_ID and a.SubDepID=b.SubDepID and a.Update_Date=b.MinDate
	left join (
		select ApplicationID,EId from interface.Biz_Dealer_New_Main
		UNION
		select ApplicationID,EId from interface.Biz_Dealer_Amend_Main
		UNION
		select ApplicationID,EId from interface.Biz_Dealer_Renew_Main
		UNION
		select ContractId,EId from Contract.AppointmentMain
		UNION
		select ContractId,EId from Contract.AmendmentMain
		UNION
		select ContractId,EId from Contract.RenewalMain
	) c on a.CAP_ID=c.ApplicationID
	left join dbo.DealerMaster dm on a.DMA_ID=dm.DMA_ID
	--where dm.DMA_SAP_Code=@SAPID and a.SubDepID=@SubDepID

	RETURN

END


  
GO


