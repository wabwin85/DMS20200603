DROP Procedure [interface].[P_I_EW_DCMS_GetDealerContract_View]

GO

CREATE Procedure [interface].[P_I_EW_DCMS_GetDealerContract_View]
	@InstanceID NVARCHAR(36),
	@DMA_SAP_Code NVARCHAR(50) ,   
	@Division Int, 
	@SubDepCode NVARCHAR(50),   
	@MarketType NVARCHAR(10)   
	 
AS
	DECLARE @DivisionName NVARCHAR(50)
	DECLARE @ContractID uniqueidentifier
	DECLARE @DMA_ID uniqueidentifier
	DECLARE @SubDepId uniqueidentifier

	DECLARE @ContractType NVARCHAR(50)
	DECLARE @AOPDealerSum NVARCHAR(500)
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
	
	CREATE TABLE #tbReturn
	(
		 SAP_Code NVARCHAR(50),
		 DMA_ID uniqueidentifier,
		 Division Int,
		 DivisionName nvarchar(1000),
		 EffectiveDate datetime,
		 ExpirationDate datetime,
		 DealerType nvarchar(1000),
		 ContractType nvarchar(1000),
		 BSCEntity nvarchar(1000),
		 Exclusiveness nvarchar(1000),
		 ProductLine nvarchar(1000),
		 ProductLineRemark nvarchar(2000),
		 Pricing_Discount nvarchar(1000),
		 Pricing_Discount_Remark nvarchar(max),
		 Pricing_Rebate nvarchar(1000),
		 Pricing_Rebate_Remark nvarchar(max),
		 PaymentTerm nvarchar(1000),
		 CreditLimit nvarchar(1000),
		 CreditTerm nvarchar(500),
		 SecurityDeposit nvarchar(1000),
		 Attachment nvarchar(2000),
		 AOPDealerQuarter  nvarchar(2000),
		 AOPDealerSum float ,
		 HoapitalString nvarchar(2000),
		 Inform nvarchar(2000),
		 InformOther nvarchar(1000),
		 AreaString nvarchar(2000)
	)

	
SET NOCOUNT ON
	BEGIN  
	SET @RtnVal='';
	SELECT @SubDepId=CC_ID FROM interface.ClassificationContract(nolock) where CC_Code=CONVERT(nvarchar(100), @SubDepCode)
	
	SELECT Distinct @DivisionName=t2.ATTRIBUTE_NAME
			  FROM Cache_OrganizationUnits t1(nolock), Lafite_ATTRIBUTE t2(nolock)
			 WHERE     t1.AttributeType = 'Product_Line'
				   AND t1.RootID = t2.Id
				   AND t1.RootID IN (SELECT AttributeID
									   FROM Cache_OrganizationUnits(nolock)
									  WHERE AttributeType = 'BU')  
				   AND Convert(NVARCHAR(10),t2.REV1)=Convert(NVARCHAR(10),@Division);
	SELECT @DMA_ID=DMA_ID FROM DealerMaster(nolock) WHERE DealerMaster.DMA_SAP_Code=@DMA_SAP_Code;
	
    IF (@MarketType IS NULL OR @MarketType='')
    BEGIN
		DECLARE @PRODUCT_CUR cursor;
		SET @PRODUCT_CUR=cursor for 
			SELECT aopd.AOPD_Year AS Year,
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_1 + aopd.AOPD_Amount_2 + aopd.AOPD_Amount_3)),
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_4 + aopd.AOPD_Amount_5 + aopd.AOPD_Amount_6)),
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_7 + aopd.AOPD_Amount_8 + aopd.AOPD_Amount_9)),
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_10 + aopd.AOPD_Amount_11 + aopd.AOPD_Amount_12))
			  FROM  dbo.V_AOPDealer aopd(nolock)
				   INNER JOIN V_DivisionProductLineRelation  AS pl_div(nolock)
				   ON pl_div.ProductLineID = aopd.AOPD_ProductLine_BUM_ID and pl_div.IsEmerging='0'
			WHERE aopd.AOPD_Dealer_DMA_ID = @DMA_ID
			AND pl_div.DivisionCode = Convert(NVARCHAR(10),@Division)
			AND aopd.AOPD_CC_ID=@SubDepId
			AND ISNULL( aopd.AOPD_Market_Type,'0')='0'
		OPEN @PRODUCT_CUR
		FETCH NEXT FROM @PRODUCT_CUR INTO @Year,@Q1,@Q2,@Q3,@Q4
		WHILE @@FETCH_STATUS = 0        
			BEGIN
			SET @RtnVal = @RtnVal +@Year +'  [Q1:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q1),0)+';  Q2:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q2),0)+';  Q3:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q3),0)++';  Q4:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q4),0)+'];   '
			FETCH NEXT FROM @PRODUCT_CUR INTO @Year,@Q1,@Q2,@Q3,@Q4
			END
		CLOSE @PRODUCT_CUR
		DEALLOCATE @PRODUCT_CUR ;
		
		SELECT @AOPtotal=SUM(AOPD_Amount_Y)
			  FROM  dbo.V_AOPDealer aopd(nolock)
				   INNER JOIN V_DivisionProductLineRelation AS pl_div
				   ON pl_div.ProductLineID = aopd.AOPD_ProductLine_BUM_ID and pl_div.IsEmerging='0'
			WHERE aopd.AOPD_Dealer_DMA_ID = @DMA_ID
			AND pl_div.DivisionCode = Convert(NVARCHAR(10),@Division)
			AND aopd.AOPD_CC_ID=@SubDepId 
			AND ISNULL(aopd.AOPD_Market_Type,'0')='0';
		
		SELECT @HoapitalString=Count(*)
		FROM (
		SELECT DISTINCT HLA_HOS_ID
		  FROM HospitalList hos(nolock)
			   INNER JOIN DealerAuthorizationTable aut(nolock)
				  ON hos.HLA_DAT_ID = aut.DAT_ID
			   INNER JOIN V_DivisionProductLineRelation AS pl_div(nolock)
				  ON pl_div.ProductLineID = aut.DAT_ProductLine_BUM_ID AND pl_div.IsEmerging='0'
			   INNER JOIN Hospital(nolock)
				  ON Hospital.HOS_ID = hos.HLA_HOS_ID
				INNER JOIN V_AllHospitalMarketProperty AMP(nolock) ON AMP.ProductLineID=pl_div.ProductLineID AND AMP.Hos_Id=Hospital.Hos_Id
		 WHERE  pl_div.DivisionCode=Convert(NVARCHAR(10),@Division)
				  AND aut.DAT_DMA_ID = @DMA_ID
				  AND CONVERT(NVARCHAR(10),ISNULL(AMP.MarketProperty,0))='0'
				  AND aut.DAT_PMA_ID IN (SELECT DISTINCT CA_ID FROM V_ProductClassificationStructure(nolock) WHERE CC_ID=@SubDepId))TAB
				
		SET @HoapitalString  =@HoapitalString+' Hospital(s)';
		
		INSERT INTO #tbReturn(SAP_Code,DMA_ID,Division,DivisionName,EffectiveDate,ExpirationDate,DealerType,
		ContractType,BSCEntity,Exclusiveness,ProductLine,ProductLineRemark,Pricing_Discount,Pricing_Discount_Remark,
		Pricing_Rebate,Pricing_Rebate_Remark,PaymentTerm,CreditLimit,CreditTerm,SecurityDeposit,Attachment,AOPDealerQuarter,AOPDealerSum,HoapitalString,Inform,InformOther)
		SELECT @DMA_SAP_Code,DCM_DMA_ID,@Division,@DivisionName ,DCM_EffectiveDate,DCM_ExpirationDate,DCM_DealerType,
		DCM_ContractType,DCM_BSCEntity,DCM_Exclusiveness,DCM_ProductLine,DCM_ProductLineRemark,DCM_Pricing_Discount,DCM_Pricing_Discount_Remark,
		DCM_Pricing_Rebate,DCM_Pricing_Rebate_Remark,DCM_Payment_Term,DCM_Credit_Limit,DCM_Credit_Term,DCM_Security_Deposit,DCM_Attachment,@RtnVal,@AOPtotal,@HoapitalString,DCM_Guarantee,DCM_GuaranteeRemark
		FROM DealerContractMaster(nolock)
		WHERE  DCM_DMA_ID  =@DMA_ID
		AND DCM_Division=Convert(NVARCHAR(10),@Division)
		--AND DCM_MarketType IS NULL
		AND CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))='0'
		AND DCM_CC_ID =@SubDepId;
    END
    ELSE
    BEGIN 
		DECLARE @PRODUCTMar_CUR cursor;
		SET @PRODUCTMar_CUR =cursor for 
			SELECT aopd.AOPD_Year AS Year,
				   (aopd.AOPD_Amount_1 + aopd.AOPD_Amount_2 + aopd.AOPD_Amount_3) AS Q1,
				   (aopd.AOPD_Amount_4 + aopd.AOPD_Amount_5 + aopd.AOPD_Amount_6) AS Q2,
				   (aopd.AOPD_Amount_7 + aopd.AOPD_Amount_8 + aopd.AOPD_Amount_9) AS Q3,
				   (aopd.AOPD_Amount_10 + aopd.AOPD_Amount_11 + aopd.AOPD_Amount_12)  AS Q4
			  FROM  dbo.V_AOPDealer aopd(nolock)
				   INNER JOIN V_DivisionProductLineRelation  AS pl_div(nolock)
				   ON pl_div.ProductLineID = aopd.AOPD_ProductLine_BUM_ID and pl_div.IsEmerging='0'
			WHERE aopd.AOPD_Dealer_DMA_ID = @DMA_ID
			AND pl_div.DivisionCode = Convert(NVARCHAR(10),@Division)
			AND aopd.AOPD_CC_ID=@SubDepId
			AND ISNULL(aopd.AOPD_Market_Type,'0')=@MarketType
		OPEN @PRODUCTMar_CUR
		FETCH NEXT FROM @PRODUCTMar_CUR INTO @Year,@Q1,@Q2,@Q3,@Q4
		WHILE @@FETCH_STATUS = 0        
			BEGIN
			SET @RtnVal = @RtnVal +@Year +'  [Q1:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q1),0)+';  Q2:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q2),0)+';  Q3:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q3),0)++';  Q4:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q4),0)+'];   '
			FETCH NEXT FROM @PRODUCTMar_CUR INTO @Year,@Q1,@Q2,@Q3,@Q4
			END
		CLOSE @PRODUCTMar_CUR
		DEALLOCATE @PRODUCTMar_CUR ;
		
		SELECT @AOPtotal=SUM(AOPD_Amount_Y)
			  FROM  dbo.V_AOPDealer aopd(nolock)
				   INNER JOIN
					  V_DivisionProductLineRelation AS pl_div(nolock)
				   ON pl_div.ProductLineID = aopd.AOPD_ProductLine_BUM_ID and pl_div.IsEmerging='0'
			WHERE aopd.AOPD_Dealer_DMA_ID = @DMA_ID
			AND pl_div.DivisionCode = Convert(NVARCHAR(10),@Division)
			AND aopd.AOPD_CC_ID=@SubDepId
			AND ISNULL(aopd.AOPD_Market_Type,'0')=@MarketType
			
		IF @MarketType='2'
		BEGIN
			SELECT @HoapitalString=Count(*)
			FROM (
			SELECT DISTINCT HLA_HOS_ID
			  FROM HospitalList hos(nolock)
				   INNER JOIN DealerAuthorizationTable aut(nolock)
					  ON hos.HLA_DAT_ID = aut.DAT_ID
				   INNER JOIN V_DivisionProductLineRelation AS pl_div(nolock)
					  ON pl_div.ProductLineID = aut.DAT_ProductLine_BUM_ID AND pl_div.IsEmerging='0'
				   INNER JOIN Hospital(nolock)
					  ON Hospital.HOS_ID = hos.HLA_HOS_ID
			 WHERE  pl_div.DivisionCode=Convert(NVARCHAR(10),@Division)
					  AND aut.DAT_DMA_ID = @DMA_ID
					  AND aut.DAT_PMA_ID IN (SELECT DISTINCT CA_ID FROM V_ProductClassificationStructure(nolock) WHERE CC_ID=@SubDepId))TAB
		END
		ELSE
		BEGIN
			SELECT @HoapitalString=Count(*)
				FROM (
				SELECT DISTINCT HLA_HOS_ID
				  FROM HospitalList hos(nolock)
					   INNER JOIN DealerAuthorizationTable aut(nolock)
						  ON hos.HLA_DAT_ID = aut.DAT_ID
					   INNER JOIN V_DivisionProductLineRelation AS pl_div(nolock)
						  ON pl_div.ProductLineID = aut.DAT_ProductLine_BUM_ID AND pl_div.IsEmerging='0'
					   INNER JOIN Hospital(nolock)
						  ON Hospital.HOS_ID = hos.HLA_HOS_ID
						INNER JOIN V_AllHospitalMarketProperty AMP(nolock) ON AMP.ProductLineID=pl_div.ProductLineID AND AMP.Hos_Id=Hospital.Hos_Id
				 WHERE  pl_div.DivisionCode=Convert(NVARCHAR(10),@Division)
						  AND aut.DAT_DMA_ID = @DMA_ID
						  AND CONVERT(NVARCHAR(10),ISNULL(AMP.MarketProperty,0))=@MarketType
						  AND aut.DAT_PMA_ID IN (SELECT DISTINCT CA_ID FROM V_ProductClassificationStructure(nolock) WHERE CC_ID=@SubDepId))TAB
		END		  
		
		SET @HoapitalString  =@HoapitalString+' Hospital(s)';	
		
		--ÊÚÈ¨µ½ÇøÓò
		SELECT  @AreaQty=COUNT (DISTINCT B.TA_Area) 
		FROM DealerAuthorizationArea A(nolock)
		INNER JOIN TerritoryArea B ON A.DA_ID=B.TA_DA_ID
		INNER JOIN DealerMaster C ON A.DA_DMA_ID=C.DMA_ID
		WHERE C.DMA_SAP_Code=@DMA_SAP_Code 
		AND A.DA_PMA_ID IN (SELECT DISTINCT CA_ID FROM V_ProductClassificationStructure(nolock) WHERE CC_Code=@SubDepCode)
		AND A.DA_DeletedFlag='0'
		
		SET @AreaString=(CONVERT(nvarchar(50),@AreaQty)+ ' Territory(s)')
			  
		INSERT INTO #tbReturn(SAP_Code,DMA_ID,Division,DivisionName,EffectiveDate,ExpirationDate,DealerType,
		ContractType,BSCEntity,Exclusiveness,ProductLine,ProductLineRemark,Pricing_Discount,Pricing_Discount_Remark,
		Pricing_Rebate,Pricing_Rebate_Remark,PaymentTerm,CreditLimit,CreditTerm,SecurityDeposit,Attachment,AOPDealerQuarter,AOPDealerSum,HoapitalString,Inform,InformOther,AreaString)
		SELECT @DMA_SAP_Code,DCM_DMA_ID,@Division,@DivisionName ,DCM_EffectiveDate,
		case when DCM_TerminationDate is not null and DCM_TerminationDate< DCM_ExpirationDate then DCM_TerminationDate else DCM_ExpirationDate end,
		DCM_DealerType,
		DCM_ContractType,DCM_BSCEntity,DCM_Exclusiveness,DCM_ProductLine,DCM_ProductLineRemark,DCM_Pricing_Discount,DCM_Pricing_Discount_Remark,
		DCM_Pricing_Rebate,DCM_Pricing_Rebate_Remark,DCM_Payment_Term,DCM_Credit_Limit,DCM_Credit_Term,DCM_Security_Deposit,DCM_Attachment,@RtnVal,@AOPtotal,@HoapitalString,DCM_Guarantee,DCM_GuaranteeRemark,@AreaString
		FROM DealerContractMaster(nolock)
		WHERE  DCM_DMA_ID  IN (SELECT DMA_ID FROM DealerMaster(nolock) WHERE DealerMaster.DMA_SAP_Code=@DMA_SAP_Code)
		AND CONVERT(NVARCHAR(10),DCM_Division)=Convert(NVARCHAR(10),@Division)
		AND CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))=@MarketType
		and DCM_CC_ID=@SubDepId
    END 
    
	--SELECT * FROM #tbReturn
	delete interface.T_I_EW_DealerContractReturn  where InstanceID=@InstanceID;
	
	insert into interface.T_I_EW_DealerContractReturn (InstanceID,SAP_Code,DMA_ID,Division,DivisionName,EffectiveDate,ExpirationDate,DealerType,
		ContractType,BSCEntity,Exclusiveness,ProductLine,ProductLineRemark,Pricing_Discount,Pricing_Discount_Remark,
		Pricing_Rebate,Pricing_Rebate_Remark,PaymentTerm,CreditLimit,CreditTerm,SecurityDeposit,Attachment,AOPDealerQuarter,AOPDealerSum,HoapitalString,Inform,InformOther,AreaString,MarketType,CCode)
		select @InstanceID,SAP_Code,DMA_ID,Division,DivisionName,EffectiveDate,ExpirationDate,DealerType,
		ContractType,BSCEntity,Exclusiveness,ProductLine,ProductLineRemark,Pricing_Discount,Pricing_Discount_Remark,
		Pricing_Rebate,Pricing_Rebate_Remark,PaymentTerm,CreditLimit,CreditTerm,SecurityDeposit,Attachment,AOPDealerQuarter,AOPDealerSum,HoapitalString,Inform,InformOther ,AreaString,@MarketType,@SubDepCode
		from #tbReturn; 
		
		
	delete 	#tbReturn 
	
	End
GO


