DROP Procedure [dbo].[P_Temp_Renew2017]
GO


CREATE Procedure [dbo].[P_Temp_Renew2017]
	 
AS
	DECLARE @DealerID uniqueidentifier
	DECLARE @ContractId uniqueidentifier
	DECLARE @CC_Code NVARCHAR(50)
	
	DECLARE @AOPDealerSum NVARCHAR(500)
	DECLARE @HoapitalQty INT
	DECLARE @HoapitalString NVARCHAR(500)
	DECLARE @AreaString NVARCHAR(500)
	DECLARE @AreaQty INT
	
	DECLARE @AOPtotal float  ;
	DECLARE @RtnVal NVARCHAR(2000) ;
	DECLARE @Year NVARCHAR(20)  ;
	DECLARE @Q1 decimal(18,2)  ;
	DECLARE @Q2 decimal(18,2)   ;
	DECLARE @Q3 decimal(18,2)   ;
	DECLARE @Q4 decimal(18,2)   ;

	
SET NOCOUNT ON
BEGIN  
	SET @RtnVal='';
	
	CREATE TABLE #ConTol
	(
		ContractId uniqueidentifier,
		DealerId uniqueidentifier,
		SubBU NVARCHAR(50),
		MarketType INT,
		BeginDate DATETIME,
		EndDate DATETIME,
		ContractType NVARCHAR(50),
		UpdateDate DATETIME,
		Quota INT,--指标
		Auth INT--授权
	)
	
	DECLARE @LastAOPContractId uniqueidentifier;
	DECLARE @LastAuthContractId uniqueidentifier;
	--SELECT   * from IC_Renew_2017_Main
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT   DealerId,CC_Code,ID from IC_Renew_2017_Main a
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @DealerID,@CC_Code,@ContractId
	WHILE @@FETCH_STATUS = 0        
		BEGIN
		delete #ConTol
		--select *  from Contract.RenewalCurrent_2017 where ContractId='3252E7EF-F5C9-40AB-8DAE-05EC43608ED4'
	
		set @LastAOPContractId=null
		set @LastAuthContractId=null
		set @HoapitalQty=0
		set @AOPtotal=0
		SET @RtnVal='';
		
		
		INSERT INTO #ConTol (ContractId,DealerId,MarketType,BeginDate,EndDate,SubBU,ContractType,UpdateDate,Quota,Auth)
		SELECT a.CAP_ID,a.CAP_DMA_ID,a.CAP_MarketType,CAP_EffectiveDate,CAP_ExpirationDate,a.CAP_SubDepID ,'Appointment',a.CAP_Update_Date,1,1 from ContractAppointment a where a.CAP_Status='Completed' and a.CAP_DMA_ID=@DealerID and a.CAP_SubDepID=@CC_Code 
		UNION
		SELECT a.CAM_ID,a.CAM_DMA_ID,a.CAM_MarketType,CAM_Amendment_EffectiveDate,CAM_Agreement_ExpirationDate,a.CAM_SubDepID,'Amendment',a.CAM_Update_Date,CASE WHEN ISNULL(a.CAM_Quota_IsChange,0)=1 THEN 1 ELSE 0 END,CASE WHEN ISNULL(a.CAM_Territory_IsChange,0)=1 THEN 1 ELSE 0 END  from ContractAmendment a where a.CAM_Status='Completed' and a.CAM_DMA_ID=@DealerID and a.CAM_SubDepID=@CC_Code 
		UNION
		SELECT  a.CRE_ID,a.CRE_DMA_ID,a.CRE_MarketType,CRE_Agrmt_EffectiveDate_Renewal,CRE_Agrmt_ExpirationDate_Renewal,a.CRE_SubDepID,'Renewal',a.CRE_Update_Date,1,1  from ContractRenewal a where a.CRE_Status='Completed' and a.CRE_DMA_ID=@DealerID and a.CRE_SubDepID=@CC_Code 
	
	
	
	SELECT TOP 1 @LastAOPContractId=ContractId FROM #ConTol WHERE Quota=1  ORDER BY UpdateDate DESC
			IF @LastAOPContractId IS NOT NULL
			BEGIN
				DECLARE @PRODUCT_CUR2 cursor;
				SET @PRODUCT_CUR2=cursor for 
					SELECT aopd.AOPD_Year AS Year,
							CONVERT(decimal(18,2),(aopd.AOPD_Amount_1 + aopd.AOPD_Amount_2 + aopd.AOPD_Amount_3)),
							CONVERT(decimal(18,2),(aopd.AOPD_Amount_4 + aopd.AOPD_Amount_5 + aopd.AOPD_Amount_6)),
							CONVERT(decimal(18,2),(aopd.AOPD_Amount_7 + aopd.AOPD_Amount_8 + aopd.AOPD_Amount_9)),
							CONVERT(decimal(18,2),(aopd.AOPD_Amount_10 + aopd.AOPD_Amount_11 + aopd.AOPD_Amount_12))
					  FROM  V_AOPDealer_Temp aopd(nolock)
					WHERE  aopd.AOPD_Contract_ID=@LastAOPContractId
					OPEN @PRODUCT_CUR2
					FETCH NEXT FROM @PRODUCT_CUR2 INTO @Year,@Q1,@Q2,@Q3,@Q4
					WHILE @@FETCH_STATUS = 0        
						BEGIN
						SET @RtnVal = @RtnVal +@Year +'  [Q1:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q1),0)+';  Q2:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),0),@Q2)+';  Q3:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q3),0)++';  Q4:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q4),0)+'];   '
						FETCH NEXT FROM @PRODUCT_CUR2 INTO @Year,@Q1,@Q2,@Q3,@Q4
						END
					CLOSE @PRODUCT_CUR2
					DEALLOCATE @PRODUCT_CUR2 ;
					
					SELECT @AOPtotal= CONVERT(decimal(18,2),SUM(AOPD_Amount_Y))	FROM  V_AOPDealer_Temp aopd(nolock) WHERE aopd.AOPD_Contract_ID=@LastAOPContractId;
					 
			END
	
	SELECT TOP 1 @LastAuthContractId=ContractId FROM #ConTol WHERE Auth=1  ORDER BY UpdateDate DESC
	SET @HoapitalQty=0;
	IF @LastAuthContractId IS NOT NULL
	BEGIN
		SELECT @HoapitalQty=Count(*) FROM 
		(SELECT DISTINCT B.HOS_ID FROM DealerAuthorizationTableTemp A INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID WHERE a.DAT_DCL_ID=@LastAuthContractId) TAB
	END
	
		
		insert into Contract.RenewalCurrent_2017
		select @ContractId ,DCM_ContractType,DCM_BSCEntity,	DCM_Exclusiveness,
		DCM_EffectiveDate,DCM_ExpirationDate,DCM_ProductLine,DCM_ProductLineRemark,DCM_Pricing,DCM_Pricing_Discount_Remark,
		DCM_Pricing_Rebate,DCM_Pricing_Rebate_Remark,
		CONVERT(nvarchar, ISNULL(@HoapitalQty,0))+ ' Hospital(s)<button class="btn btn-sm btn-primary yahei" onclick="showCurrentHospital();" type="button"><i class="icon-cog icon-on-right bigger-110"></i>&nbsp;授权查看</button>' Hospital,
		isnull(@RtnVal,'')+' <button class="btn btn-sm btn-primary yahei" onclick="showCurrentQuota();" type="button"><i class="icon-cog icon-on-right bigger-110"></i>&nbsp;指标查看</button>' as Quota,
		dbo.GetFormatString(ISNULL(@AOPtotal,0),2) QuotaTotal,
		null	,null	,null	,null	,null	,null	,''
		from DealerContractMaster a inner join interface.ClassificationContract b on a.DCM_CC_ID=b.CC_ID
		where b.CC_Code=@CC_Code
		and a.DCM_DMA_ID=@DealerID
		
		set @HoapitalQty=0;
		select  @HoapitalQty=COUNT(distinct b.HOS_ID) from DealerAuthorizationTableTemp a inner join ContractTerritory b on a.DAT_ID=b.Contract_ID
		where a.DAT_DCL_ID=@ContractId
		
		set @AOPtotal=0;
		
		select @AOPtotal=CONVERT(decimal(18,2),SUM(a.AOPD_Amount_Y)) from V_AOPDealer_Temp a where a.AOPD_Contract_ID=@ContractId
		
		select  @Q1=CONVERT(decimal(18,2),AOPD_Amount_1+AOPD_Amount_2+AOPD_Amount_3), 
		@Q2=CONVERT(decimal(18,2),AOPD_Amount_4+AOPD_Amount_5+AOPD_Amount_6),
		@Q3=CONVERT(decimal(18,2),AOPD_Amount_7+AOPD_Amount_8+AOPD_Amount_9),
		@Q4=CONVERT(decimal(18,2),AOPD_Amount_10+AOPD_Amount_11+AOPD_Amount_12)
		from V_AOPDealer_Temp a where a.AOPD_Contract_ID=@ContractId
		

		insert into Contract.RenewalProposals_2017
			(ContractId,	ContractType,	BSC,	Exclusiveness,	AgreementBegin,	AgreementEnd,	Product,	ProductRemark,	Price,	PriceRemark,
			SpecialSales,	SpecialSalesRemark,	Hospital,	Quota,	QuotaTotal,	QUOTAUSD,	AllProductAop,	AllProductAopUSD,
			DealerLessHos,	DealerLessHosReason,	DealerLessHosReasonQ,	DealerLessHosQ,	DealerLessHosQRemark	,HosLessStandard	,HosLessStandardReason	,HosLessStandardReasonQ	,HosLessStandardQ,	HosLessStandardQRemark	,Attachment,	ISVAT,
			HosHavZorro,	CheckData,	ProductGroupCheck,	ProductGroupRemark	,ProductGroupMemo)
		select 
		@ContractId,	'Dealer',	'China',	'Exclusive',	'2017-01-01',	'2017-12-31',	'All',	'',	'依照公司政策',	'依照公司政策',
			'依照公司政策',	'依照公司政策',	
			CONVERT(nvarchar,ISNULL(@HoapitalQty,0) ) +' Hospital(s)<button class="btn btn-sm btn-primary yahei" onclick="showHospital();" type="button"><i class="icon-cog icon-on-right bigger-110"></i>&nbsp;授权</button>',	
			'2017 [Q1:'+dbo.GetFormatString(@Q1,0)+';  Q2:'+dbo.GetFormatString(@Q2,0)+';  Q3:'+dbo.GetFormatString(@Q3,0)+';  Q4:'+dbo.GetFormatString(@Q4,0)+']; <button class="btn btn-sm btn-primary yahei" onclick="showQuota();" type="button"><i class="icon-cog icon-on-right bigger-110"></i>&nbsp;指标</button>',	
			
			@AOPtotal ,	@AOPtotal/6.15,	null,	null,
			1,	'',	'',	1,	''	,1	,''	,''	,1,	''	,'',	0,
			1,	1,	'',	''	,''

	
	
		FETCH NEXT FROM @PRODUCT_CUR INTO @DealerID,@CC_Code,@ContractId
		END
	CLOSE @PRODUCT_CUR
	DEALLOCATE @PRODUCT_CUR ;

	

END
GO


