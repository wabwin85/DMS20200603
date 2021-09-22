CREATE PROCEDURE [dbo].[GC_DealerComplain_Info_SpecialDateFormat]
    @DC_ID UNIQUEIDENTIFIER ,
    @ComplainType NVARCHAR(20)
AS
    IF @ComplainType = 'BSC'
        BEGIN
            SELECT  DC.DC_ID, DC.DC_ComplainNbr, DC.DC_CorpId, DC.DC_Status, DC.DC_CreatedBy, 
           Convert(nvarchar(2),DAY (DC.DC_CreatedDate )) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DC_CreatedDate )*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DC_CreatedDate )) AS DC_CreatedDate, --Date 
           DC.DC_LastModifiedBy, DC.DC_LastModifiedDate, DC.EID, 
           Convert(nvarchar(2),DAY (DC.REQUESTDATE)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.REQUESTDATE)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.REQUESTDATE)) AS REQUESTDATE,    --Date 
           DC.INITIALNAME, DC.INITIALPHONE, DC.INITIALJOB, DC.INITIALEMAIL, DC.PHYSICIAN, DC.PHYSICIANPHONE, DC.FIRSTBSCNAME, 
           Convert(nvarchar(2),DAY (DC.BSCAWAREDATE)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.BSCAWAREDATE)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.BSCAWAREDATE)) AS BSCAWAREDATE,   --Date
           Convert(nvarchar(2),DAY (DC.NOTIFYDATE )) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.NOTIFYDATE )*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.NOTIFYDATE )) AS NOTIFYDATE, --Date
           DC.CONTACTMETHOD, DC.COMPLAINTSOURCE, DC.FEEDBACKREQUESTED, DC.FEEDBACKSENDTO, DC.COMPLAINTID, DC.REFERBOX, DC.PRODUCTTYPE, DC.RETURNTYPE, DC.ISPLATFORM, DC.BSCSOLDTOACCOUNT, DC.BSCSOLDTONAME, DC.BSCSOLDTOCITY, DC.SUBSOLDTONAME, DC.SUBSOLDTOCITY, DC.DISTRIBUTORCUSTOMER, DC.DISTRIBUTORCITY, DC.UPN, DC.[DESCRIPTION], DC.LOT, DC.BU, DC.SINGLEUSE, DC.RESTERILIZED, DC.PREPROCESSOR, DC.USEDEXPIRY, DC.UPNEXPECTED, DC.UPNQUANTITY, DC.NORETURN, DC.NORETURNREASON, 
           Convert(nvarchar(2),DAY (DC.INITIALPDATE)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.INITIALPDATE)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.INITIALPDATE)) AS INITIALPDATE, --Date
           DC.PNAME, DC.INDICATION, 
           Convert(nvarchar(2),DAY (DC.IMPLANTEDDATE)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.IMPLANTEDDATE)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.IMPLANTEDDATE)) AS IMPLANTEDDATE, --Date
           CASE WHEN DC.EXPLANTEDDATE is null or DC.EXPLANTEDDATE ='' Then '' ELSE Convert(nvarchar(2),DAY (DC.EXPLANTEDDATE)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.EXPLANTEDDATE)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.EXPLANTEDDATE)) end AS EXPLANTEDDATE, --Date
           DC.POUTCOME, DC.IVUS, DC.GENERATOR, DC.GENERATORTYPE, DC.GENERATORSET, DC.PCONDITION, DC.PCONDITIONOTHER, 
           Convert(nvarchar(2),DAY (DC.EDATE )) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.EDATE )*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.EDATE )) AS EDATE,--Date
           DC.WHEREOCCUR, DC.WHENNOTICED, DC.EDESCRIPTION, DC.WITHLABELEDUSE, DC.NOLABELEDUSE, DC.EVENTRESOLVED, DC.BSCSALESNAME, DC.BSCSALESPHONE, DC.CarrierNumber, DC.DN, DC.WHM_ID, DC.ReturnNum, DC.ConvertFactor, 
           DC.UPNExpDate,--Convert(nvarchar(2),DAY (DC.UPNExpDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.UPNExpDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.UPNExpDate)),  --Date
           DC.CONFIRMRETURNTYPE, DC.EFINSTANCECODE, DC.Registration, 
           Convert(nvarchar(2),DAY (DC.SalesDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.SalesDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.SalesDate)) AS SalesDate, --Date
           DC.HospitalCn, DC.HospitalEn, DC.PatientName, DC.PatientNum, DC.PatientSex, DC.PatientAge, 
           CASE WHEN DC.PatientBirth is null or DC.PatientBirth ='' Then '' ELSE Convert(nvarchar(2),DAY (DC.PatientBirth)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.PatientBirth)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.PatientBirth)) end AS PatientBirth, --Date , 
           DC.PatientSexUom, DC.PatientIs18, DC.PatientWeight, DC.PatientWeightUom, DC.AnatomicSite, DC.HandlingEvents, DC.SurgeryRemark, DC.HospitalizationRemark, DC.MedicineRemark, DC.BloodTransfusionRemark, DC.OtherInterventionalRemark, DC.Consequence, 
           CASE WHEN DC.DeathDate is null or DC.DeathDate ='' Then '' ELSE Convert(nvarchar(2),DAY (DC.DeathDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DeathDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DeathDate)) END AS DeathDate, --Date
           DC.DeathRemark, DC.Remark, DC.DC_ComplainStatus, 
           Convert(nvarchar(2),DAY (DC.DC_ConfirmDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DC_ConfirmDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DC_ConfirmDate)) AS DC_ConfirmDate, --Date
           DC.DC_ConfirmUser, DC.DC_ConfirmSubmitDate, DC.DC_ConfirmSubmitUser, DC.DC_ConfirmUpdateDate, DC.DC_ConfirmUpdateUser, DC.KA, DC.KR, DC.CR, DC.BL, DC.C, DC.Invoice, DC.MB, DC.ZNC, DC.KB, 
           Convert(nvarchar(2),DAY (DC.DNDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DNDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DNDate)) AS DNDate,  --Date
           DC.CS, 
           Convert(nvarchar(2),DAY (DC.STODate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.STODate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.STODate)) AS STODate,  --DAte
           Convert(nvarchar(2),DAY (DC.HasSalesDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.HasSalesDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.HasSalesDate)) AS HasSalesDate, --date
           DC.[Name], 
           Convert(nvarchar(2),DAY (DC.DateReceipt)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DateReceipt)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DateReceipt)) AS DateReceipt,--Date
           DC.TWNbr, DC.PermanentDamageRemark, DC.NotSeriousRemark, DC.SeriousRemark, DC.QrCode, DC.ComplainApprovelRemark, DC.HasFollowOperation, 
           Convert(nvarchar(2),DAY (DC.FollowOperationDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.FollowOperationDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.FollowOperationDate)) AS FollowOperationDate,  --Date
           DC.FollowOperationStaff, DC.NeedOfferAnalyzeReport, DC.NoProblemButLesionNotPass, DC.CourierCompany, DC.ConfirmReturnOrRefund, DC.ReturnFactoryTrackingNo, DC.ReceiveReturnedGoods, 
           Convert(nvarchar(2),DAY (DC.ReceiveReturnedGoodsDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.ReceiveReturnedGoodsDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.ReceiveReturnedGoodsDate)) AS ReceiveReturnedGoodsDate, --Date
           DC.CFN_Property4, DC.PropertyRights, DC.RGA ,
           LI.Id, LI.IDENTITY_CODE, LI.LOWERED_IDENTITY_CODE, LI.IDENTITY_NAME, LI.EMAIL1, LI.EMAIL2, LI.PHONE, LI.ADDRESS, LI.BOOLEAN_FLAG, LI.IDENTITY_TYPE, LI.[DESCRIPTION], LI.VALID_DATE_BEGIN, LI.VALID_DATE_END, LI.LastActivityDate, LI.Corp_ID, LI.REV1, LI.REV2, LI.REV3, LI.APP_ID, LI.SORT_COL, LI.DELETE_FLAG, LI.CREATE_USER, LI.CREATE_DATE, LI.LAST_UPDATE_USER, LI.LAST_UPDATE_DATE, 
                    CASE WHEN DC.WHM_ID = '00000000-0000-0000-0000-000000000000'
                         THEN '销售到医院'
                         ELSE ( SELECT  W.WHM_Name
                                FROM    Warehouse W
                                WHERE   W.WHM_ID = DC.WHM_ID
                              )
                    END AS WarehouseName ,
					(SELECT IDENTITY_NAME FROM dbo.Lafite_IDENTITY WHERE IDENTITY_CODE = dc.BSCSALESNAME) AS BSCSales
            FROM    DealerComplain DC ,
                    Lafite_IDENTITY LI
            WHERE   DC.EID = LI.Id
                    AND DC.DC_ID = @DC_ID
        END
    ELSE
        IF @ComplainType = 'CRM'
            BEGIN
                SELECT  DC.DC_ID, DC.DC_ComplainNbr, DC.DC_CorpId, DC.DC_Status, DC.DC_CreatedBy, 
         Convert(nvarchar(2),DAY (DC.DC_CreatedDate )) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DC_CreatedDate )*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DC_CreatedDate )) as DC_CreatedDate,  --date
         DC.DC_LastModifiedBy, 
         Convert(nvarchar(2),DAY (DC.DC_LastModifiedDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DC_LastModifiedDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DC_LastModifiedDate)) AS DC_LastModifiedDate, --date
         DC.EID, DC.Model, DC.Serial, DC.Lot, DC.[PI], DC.IAN, DC.CompletedName, DC.CompletedTitle, DC.NonBostonName, DC.NonBostonCompany, DC.NonBostonAddress, DC.NonBostonCity, DC.NonBostonCountry, 
         Convert(nvarchar(2),DAY (DC.DateEvent)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DateEvent)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DateEvent)) as DateEvent,--date
         Convert(nvarchar(2),DAY (DC.DateBSC)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DateBSC)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DateBSC)) as DateBSC,--date
         Convert(nvarchar(2),DAY (DC.DateDealer)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DateDealer)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DateDealer)) as DateDealer,--date
         DC.EventCountry, DC.OtherCountry, DC.NeedSupport, DC.PatientName, DC.PatientNum, DC.PatientSex, DC.PatientSexInvalid, 
         CASE WHEN DC.PatientBirth is null or DC.PatientBirth ='' Then '' ELSE Convert(nvarchar(2),DAY (DC.PatientBirth)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.PatientBirth)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.PatientBirth)) END AS PatientBirth, --date
         DC.PatientBirthInvalid, DC.PatientWeight, DC.PatientWeightInvalid, DC.PhysicianName, DC.PhysicianHospital, DC.PhysicianTitle, DC.PhysicianAddress, DC.PhysicianCity, DC.PhysicianZipcode, DC.PhysicianCountry, DC.PatientStatus, 
         CASE WHEN DC.DeathDate is null or DC.DeathDate ='' Then '' ELSE Convert(nvarchar(2),DAY (DC.DeathDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DeathDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DeathDate)) END as DeathDate,--date
         DC.DeathTime, DC.DeathCause, DC.Witnessed, DC.RelatedBSC, DC.ReasonsForProduct, DC.Returned, DC.ReturnedDay, DC.AnalysisReport, DC.RequestPhysicianName, DC.Warranty, DC.Pulse, DC.Pulsebeats, DC.Leads, DC.LeadsFracture, DC.LeadsIssue, DC.LeadsDislodgement, DC.LeadsMeasurements, DC.LeadsThresholds, DC.LeadsBeats, DC.LeadsNoise, DC.LeadsLoss, DC.Clinical, DC.ClinicalPerforation, DC.ClinicalBeats, DC.PulseModel, DC.PulseSerial, 
         CASE WHEN DC.PulseImplant is null or DC.PulseImplant ='' Then '' ELSE Convert(nvarchar(2),DAY (DC.PulseImplant)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.PulseImplant)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.PulseImplant)) END AS PulseImplant, --date
         DC.Leads1Model, DC.Leads1Serial, 
         CASE WHEN DC.Leads1Implant is null or DC.Leads1Implant ='' Then '' ELSE Convert(nvarchar(2),DAY (DC.Leads1Implant)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.Leads1Implant)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.Leads1Implant)) END AS Leads1Implant, --date
         DC.Leads1Position, DC.Leads2Model, DC.Leads2Serial, 
         CASE WHEN DC.Leads2Implant is null or DC.Leads2Implant ='' Then '' ELSE Convert(nvarchar(2),DAY (DC.Leads2Implant)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.Leads2Implant)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.Leads2Implant)) END AS Leads2Implant, --date 
         DC.Leads2Position, DC.Leads3Model, DC.Leads3Serial, 
         CASE WHEN DC.Leads3Implant is null or DC.Leads3Implant ='' Then '' ELSE Convert(nvarchar(2),DAY (DC.Leads3Implant)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.Leads3Implant)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.Leads3Implant)) END AS Leads3Implant, --date 
         DC.Leads3Position, DC.AccessoryModel, DC.AccessorySerial, DC.AccessoryImplant, DC.AccessoryLot, 
         CASE WHEN DC.ExplantDate is null or DC.ExplantDate ='' Then '' ELSE Convert(nvarchar(2),DAY (DC.ExplantDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.ExplantDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.ExplantDate)) end as ExplantDate, --date
         DC.RemainsService, DC.RemovedService, DC.Replace1Model, DC.Replace1Serial, DC.Replace1Implant, DC.Replace2Model, DC.Replace2Serial, DC.Replace2Implant, DC.Replace3Model, DC.Replace3Serial, DC.Replace3Implant, DC.Replace4Model, DC.Replace4Serial, DC.Replace4Implant, DC.Replace5Model, DC.Replace5Serial, DC.Replace5Implant, DC.ProductExpDetail, DC.CustomerComment, DC.DN, DC.CarrierNumber, DC.ProductType, DC.ReturnType, DC.IsPlatform, DC.BSCSoldToAccount, DC.BSCSoldToName, DC.BSCSoldToCity, DC.SubSoldToName, DC.SubSoldToCity, DC.DistributorCustomer, DC.DistributorCity, DC.IsForBSCProduct, DC.ProductDescription, DC.UPNExpDate, DC.WHMID, DC.CONFIRMRETURNTYPE, DC.EFINSTANCECODE, DC.Registration, 
         Convert(nvarchar(2),DAY (DC.SalesDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.SalesDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.SalesDate)) as SalesDate,--date
         DC.QrCode, DC.RN, 
         Convert(nvarchar(2),DAY (DC.DateReceipt)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DateReceipt)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DateReceipt)) as DateReceipt,--date
         DC.CompletedPhone, DC.CompletedEmail, DC.REMARK, DC.DC_ComplainStatus, 
         Convert(nvarchar(2),DAY (DC.DC_ConfirmDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DC_ConfirmDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DC_ConfirmDate)) as DC_ConfirmDate, --date
         DC.DC_ConfirmUser, 
         Convert(nvarchar(2),DAY (DC.DC_ConfirmSubmitDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DC_ConfirmSubmitDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DC_ConfirmSubmitDate)) as DC_ConfirmSubmitDate,--date
         DC.DC_ConfirmSubmitUser, 
         Convert(nvarchar(2),DAY (DC.DC_ConfirmUpdateDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DC_ConfirmUpdateDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DC_ConfirmUpdateDate)) as DC_ConfirmUpdateDate,--date
         DC.DC_ConfirmUpdateUser, DC.KA, DC.KR, DC.CR, DC.BL, DC.C, DC.Invoice, DC.MB, DC.ZNC, DC.KB, 
         Convert(nvarchar(2),DAY (DC.DNDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.DNDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.DNDate)) as DNDate,--date
         DC.CS, 
         Convert(nvarchar(2),DAY (DC.STODate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.STODate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.STODate)) as STODate, --date
         Convert(nvarchar(2),DAY (DC.HasSalesDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.HasSalesDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.HasSalesDate)) as HasSalesDate,--date
         DC.ComplainApprovelRemark, DC.HasFollowOperation, 
         Convert(nvarchar(2),DAY (DC.FollowOperationDate)) + '-' +  SubString('JanFebMarAprMayJunJulAugSepOctNovDec',Month(DC.FollowOperationDate)*3-2,3) +'-' + Convert(nvarchar(4),YEAR (DC.FollowOperationDate)) as FollowOperationDate,--date
         DC.FollowOperationStaff, DC.CourierCompany, DC.ConfirmReturnOrRefund, DC.ConvertFactor, DC.CFN_Property4, DC.PropertyRights, DC.RGA ,
         LI.Id, LI.IDENTITY_CODE, LI.LOWERED_IDENTITY_CODE, LI.IDENTITY_NAME, LI.EMAIL1, LI.EMAIL2, LI.PHONE, LI.ADDRESS, LI.BOOLEAN_FLAG, LI.IDENTITY_TYPE, LI.[DESCRIPTION], LI.VALID_DATE_BEGIN, LI.VALID_DATE_END, LI.LastActivityDate, LI.Corp_ID, LI.REV1, LI.REV2, LI.REV3, LI.APP_ID, LI.SORT_COL, LI.DELETE_FLAG, LI.CREATE_USER, LI.CREATE_DATE, LI.LAST_UPDATE_USER, LI.LAST_UPDATE_DATE,
                        CASE WHEN WHMID = '00000000-0000-0000-0000-000000000000'
                             THEN '销售到医院'
                             ELSE ( SELECT  WHM_Name
                                    FROM    Warehouse
                                    WHERE   WHM_ID = WHMID
                                  )
                        END AS WarehouseName,
						(SELECT IDENTITY_NAME FROM dbo.Lafite_IDENTITY WHERE IDENTITY_CODE = dc.CompletedName) AS BSCSales
                FROM    DealerComplainCRM DC ,
                        Lafite_IDENTITY LI
                WHERE   DC.EID = LI.Id
                        AND DC.DC_ID = @DC_ID
            END
GO