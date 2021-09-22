DROP Procedure [interface].[P_I_EW_DCMS_GetDealerContract_Test]
GO


CREATE Procedure [interface].[P_I_EW_DCMS_GetDealerContract_Test]
	@DMA_SAP_Code NVARCHAR(50),
	@Division Int,
	@MarketType NVARCHAR(10)
AS
	DECLARE @DivisionName NVARCHAR(50)
	DECLARE @ContractID uniqueidentifier
	DECLARE @DMA_ID uniqueidentifier

	DECLARE @ContractType NVARCHAR(50)
	DECLARE @AOPDealerSum NVARCHAR(50)
	DECLARE @HoapitalString NVARCHAR(50)
	
	DECLARE @AOPtotal float ;
	DECLARE @RtnVal NVARCHAR(2000);
	DECLARE @Year NVARCHAR(20);
	DECLARE @Q1 decimal(18,2)  ;
	DECLARE @Q2 decimal(18,2)   ;
	DECLARE @Q3 decimal(18,2)   ;
	DECLARE @Q4 decimal(18,2)   ;
	
	CREATE TABLE #tbReturn
	(
		 SAP_Code NVARCHAR(50),
		 DMA_ID uniqueidentifier,
		 Division Int,
		 DivisionName nvarchar(100),
		 EffectiveDate datetime,
		 ExpirationDate datetime,
		 DealerType nvarchar(100),
		 ContractType nvarchar(100),
		 BSCEntity nvarchar(100),
		 Exclusiveness nvarchar(100),
		 ProductLine nvarchar(100),
		 ProductLineRemark nvarchar(2000),
		 Pricing_Discount nvarchar(100),
		 Pricing_Discount_Remark nvarchar(max),
		 Pricing_Rebate nvarchar(100),
		 Pricing_Rebate_Remark nvarchar(max),
		 PaymentTerm nvarchar(100),
		 CreditLimit nvarchar(100),
		 CreditTerm nvarchar(50),
		 SecurityDeposit nvarchar(100),
		 Attachment nvarchar(200),
		 AOPDealerQuarter  nvarchar(2000),
		 AOPDealerSum float ,
		 HoapitalString nvarchar(200),
		 Inform nvarchar(200),
		 InformOther nvarchar(1000)
	)

	
SET NOCOUNT ON
	BEGIN  
	SET @RtnVal='';
	SELECT Distinct @DivisionName=t2.ATTRIBUTE_NAME
			  FROM Cache_OrganizationUnits  t1 , Lafite_ATTRIBUTE t2 
			 WHERE     t1.AttributeType = 'Product_Line'
				   AND t1.RootID = t2.Id
				   AND t1.RootID IN (SELECT AttributeID
									   FROM Cache_OrganizationUnits 
									  WHERE AttributeType = 'BU')  
				   AND Convert(NVARCHAR(10),t2.REV1)=Convert(NVARCHAR(10),@Division);
	SELECT @DMA_ID=DMA_ID FROM DealerMaster  WHERE DealerMaster.DMA_SAP_Code=@DMA_SAP_Code;
	
    IF (@MarketType IS NULL OR @MarketType='')
    BEGIN
		DECLARE @PRODUCT_CUR cursor;
		SET @PRODUCT_CUR=cursor for 
			SELECT aopd.AOPD_Year AS Year,
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_1 + aopd.AOPD_Amount_2 + aopd.AOPD_Amount_3)),
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_4 + aopd.AOPD_Amount_5 + aopd.AOPD_Amount_6)),
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_7 + aopd.AOPD_Amount_8 + aopd.AOPD_Amount_9)),
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_10 + aopd.AOPD_Amount_11 + aopd.AOPD_Amount_12))
			  FROM  dbo.V_AOPDealer  aopd
				   INNER JOIN V_DivisionProductLineRelation  AS pl_div
				   ON pl_div.ProductLineID = aopd.AOPD_ProductLine_BUM_ID and pl_div.IsEmerging='0'
			WHERE aopd.AOPD_Dealer_DMA_ID = @DMA_ID
			AND pl_div.DivisionCode = Convert(NVARCHAR(10),@Division)
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
			  FROM  dbo.V_AOPDealer  aopd
				   INNER JOIN V_DivisionProductLineRelation  AS pl_div
				   ON pl_div.ProductLineID = aopd.AOPD_ProductLine_BUM_ID and pl_div.IsEmerging='0'
			WHERE aopd.AOPD_Dealer_DMA_ID = @DMA_ID
			AND pl_div.DivisionCode = Convert(NVARCHAR(10),@Division)
			AND ISNULL(aopd.AOPD_Market_Type,'0')='0';
		
		SELECT @HoapitalString=Count(*)
		  FROM HospitalList hos
			   INNER JOIN DealerAuthorizationTable   aut
				  ON hos.HLA_DAT_ID = aut.DAT_ID
			   INNER JOIN DealerContract  con
				  ON aut.DAT_DCL_ID = con.DCL_ID
			   INNER JOIN V_DivisionProductLineRelation  AS pl_div
				  ON pl_div.ProductLineID = aut.DAT_ProductLine_BUM_ID AND pl_div.IsEmerging='0'
			   INNER JOIN Hospital 
				  ON Hospital.HOS_ID = hos.HLA_HOS_ID
				INNER JOIN V_AllHospitalMarketProperty  AMP ON AMP.ProductLineID=pl_div.ProductLineID AND AMP.Hos_Id=Hospital.Hos_Id
		 WHERE  pl_div.DivisionCode=Convert(NVARCHAR(10),@Division)
				  AND con.DCL_DMA_ID = @DMA_ID
				  AND CONVERT(NVARCHAR(10),ISNULL(AMP.MarketProperty,0))='0' ;
				
		SET @HoapitalString  =@HoapitalString+' Hospital(s)';
		
		INSERT INTO #tbReturn(SAP_Code,DMA_ID,Division,DivisionName,EffectiveDate,ExpirationDate,DealerType,
		ContractType,BSCEntity,Exclusiveness,ProductLine,ProductLineRemark,Pricing_Discount,Pricing_Discount_Remark,
		Pricing_Rebate,Pricing_Rebate_Remark,PaymentTerm,CreditLimit,CreditTerm,SecurityDeposit,Attachment,AOPDealerQuarter,AOPDealerSum,HoapitalString,Inform,InformOther)
		SELECT @DMA_SAP_Code,DCM_DMA_ID,@Division,@DivisionName ,DCM_EffectiveDate,DCM_ExpirationDate,DCM_DealerType,
		DCM_ContractType,DCM_BSCEntity,DCM_Exclusiveness,DCM_ProductLine,DCM_ProductLineRemark,DCM_Pricing_Discount,DCM_Pricing_Discount_Remark,
		DCM_Pricing_Rebate,DCM_Pricing_Rebate_Remark,DCM_Payment_Term,DCM_Credit_Limit,DCM_Credit_Term,DCM_Security_Deposit,DCM_Attachment,@RtnVal,@AOPtotal,@HoapitalString,DCM_Guarantee,DCM_GuaranteeRemark
		FROM DealerContractMaster 
		WHERE  DCM_DMA_ID  =@DMA_ID
		AND DCM_Division=Convert(NVARCHAR(10),@Division)
		--AND DCM_MarketType IS NULL
		AND CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))=0
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
			  FROM  dbo.V_AOPDealer  aopd
				   INNER JOIN V_DivisionProductLineRelation   AS pl_div
				   ON pl_div.ProductLineID = aopd.AOPD_ProductLine_BUM_ID and pl_div.IsEmerging='0'
			WHERE aopd.AOPD_Dealer_DMA_ID = @DMA_ID
			AND pl_div.DivisionCode = Convert(NVARCHAR(10),@Division)
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
			  FROM  dbo.V_AOPDealer aopd
				   INNER JOIN
					  V_DivisionProductLineRelation  AS pl_div
				   ON pl_div.ProductLineID = aopd.AOPD_ProductLine_BUM_ID and pl_div.IsEmerging='0'
			WHERE aopd.AOPD_Dealer_DMA_ID = @DMA_ID
			AND pl_div.DivisionCode = Convert(NVARCHAR(10),@Division)
			AND ISNULL(aopd.AOPD_Market_Type,'0')=@MarketType
			
	
		SELECT @HoapitalString=Count(*)
		  FROM HospitalList hos
			   INNER JOIN DealerAuthorizationTable  aut
				  ON hos.HLA_DAT_ID = aut.DAT_ID
			   INNER JOIN DealerContract  con
				  ON aut.DAT_DCL_ID = con.DCL_ID
			   INNER JOIN V_DivisionProductLineRelation  AS pl_div
				  ON pl_div.ProductLineID = aut.DAT_ProductLine_BUM_ID AND pl_div.IsEmerging='0'
			   INNER JOIN Hospital 
				  ON Hospital.HOS_ID = hos.HLA_HOS_ID
				INNER JOIN V_AllHospitalMarketProperty  AMP ON AMP.ProductLineID=pl_div.ProductLineID AND AMP.Hos_Id=Hospital.Hos_Id
		 WHERE  pl_div.DivisionCode=Convert(NVARCHAR(10),@Division)
				  AND con.DCL_DMA_ID = @DMA_ID
				  AND CONVERT(NVARCHAR(10),ISNULL(AMP.MarketProperty,0))=@MarketType ;
		
		SET @HoapitalString  =@HoapitalString+' Hospital(s)';		  
		INSERT INTO #tbReturn(SAP_Code,DMA_ID,Division,DivisionName,EffectiveDate,ExpirationDate,DealerType,
		ContractType,BSCEntity,Exclusiveness,ProductLine,ProductLineRemark,Pricing_Discount,Pricing_Discount_Remark,
		Pricing_Rebate,Pricing_Rebate_Remark,PaymentTerm,CreditLimit,CreditTerm,SecurityDeposit,Attachment,AOPDealerQuarter,AOPDealerSum,HoapitalString,Inform,InformOther)
		SELECT @DMA_SAP_Code,DCM_DMA_ID,@Division,@DivisionName ,DCM_EffectiveDate,DCM_ExpirationDate,DCM_DealerType,
		DCM_ContractType,DCM_BSCEntity,DCM_Exclusiveness,DCM_ProductLine,DCM_ProductLineRemark,DCM_Pricing_Discount,DCM_Pricing_Discount_Remark,
		DCM_Pricing_Rebate,DCM_Pricing_Rebate_Remark,DCM_Payment_Term,DCM_Credit_Limit,DCM_Credit_Term,DCM_Security_Deposit,DCM_Attachment,@RtnVal,@AOPtotal,@HoapitalString,DCM_Guarantee,DCM_GuaranteeRemark
		FROM DealerContractMaster 
		WHERE  DCM_DMA_ID  IN (SELECT DMA_ID FROM DealerMaster WHERE DealerMaster.DMA_SAP_Code=@DMA_SAP_Code)
		AND CONVERT(NVARCHAR(10),DCM_Division)=Convert(NVARCHAR(10),@Division)
		AND CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))=@MarketType
    END 
    
	SELECT * FROM #tbReturn
	
	END
	




GO


