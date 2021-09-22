DROP FUNCTION [dbo].[GC_Fn_ContractSum]
GO


CREATE FUNCTION [dbo].[GC_Fn_ContractSum]
(
	@DealerId UNIQUEIDENTIFIER,
	@ProductLineId UNIQUEIDENTIFIER,
	@CCId UNIQUEIDENTIFIER,
	@MarketType NVARCHAR(10),
	@BeginDate datetime,
	@EndDate datetime,
	@SelectType int  --1: AOP SUM; 2: AOP ; 3:Authorization ; 4: Are-Authorization
	
)
RETURNS Nvarchar(500)
AS

BEGIN
	DECLARE @RtnVal NVARCHAR(500);
	IF @SelectType=1
	BEGIN
		SELECT @RtnVal=CONVERT(NVARCHAR(100),CONVERT(NVARCHAR,a.AOPD_Amount_Y))  from  V_AOPDealer A 
					WHERE A.AOPD_Dealer_DMA_ID=@DealerId  
					and a.AOPD_ProductLine_BUM_ID=@ProductLineId 
					and a.AOPD_CC_ID=@CCId 
					and CONVERT(INT,a.AOPD_Year) >=YEAR(@BeginDate) AND CONVERT(INT,a.AOPD_Year) <=YEAR(@EndDate)
					AND (ISNULL (@MarketType,'')='' OR ISNULL (@MarketType,'')='2' OR ISNULL (@MarketType,'')=A.AOPD_Market_Type)
	END
	IF @SelectType=2
	BEGIN
	SELECT @RtnVal=
			STUFF(REPLACE(REPLACE(
			(
			SELECT A.AOPD_Year+' '+'[Q1:' +dbo.GetFormatString((A.AOPD_Amount_1+A.AOPD_Amount_2+A.AOPD_Amount_3),0)
						+', '+'Q2:'+dbo.GetFormatString((A.AOPD_Amount_4+A.AOPD_Amount_5+A.AOPD_Amount_6),0)
						+', '+'Q3:'+dbo.GetFormatString((A.AOPD_Amount_7+A.AOPD_Amount_8+A.AOPD_Amount_9),0)
						+', '+'Q4:'+dbo.GetFormatString((A.AOPD_Amount_10+A.AOPD_Amount_11+A.AOPD_Amount_12),0)+']'  AS RESULT
					FROM V_AOPDealer A 
						WHERE A.AOPD_Dealer_DMA_ID=@DealerId  
									and a.AOPD_ProductLine_BUM_ID=@ProductLineId 
									and a.AOPD_CC_ID=@CCId 
									and CONVERT(INT,a.AOPD_Year) >=YEAR(@BeginDate) AND CONVERT(INT,a.AOPD_Year) <=YEAR(@EndDate)
									AND (ISNULL (@MarketType,'')='' OR ISNULL (@MarketType,'')='2' OR ISNULL (@MarketType,'')=A.AOPD_Market_Type)
							FOR XML AUTO
						), '<A RESULT="', ';'), '"/>', ''), 1, 1, '')
	END
	
	IF @SelectType=3
	BEGIN
		IF @MarketType='2'
			BEGIN
				SELECT @RtnVal=Count(*)
				FROM (
				SELECT DISTINCT HLA_HOS_ID
				  FROM HospitalList hos(nolock)
					   INNER JOIN DealerAuthorizationTable aut(nolock)
						  ON hos.HLA_DAT_ID = aut.DAT_ID
					   INNER JOIN Hospital(nolock)
						  ON Hospital.HOS_ID = hos.HLA_HOS_ID
				 WHERE aut.DAT_DMA_ID=@DealerId
				 AND aut.DAT_ProductLine_BUM_ID=@ProductLineId
				 AND aut.DAT_PMA_ID IN (SELECT DISTINCT CA_ID FROM V_ProductClassificationStructure(nolock) WHERE CC_ID=@CCId))TAB
			END
			ELSE
			BEGIN
				SELECT @RtnVal=Count(*)
					FROM (
					SELECT DISTINCT HLA_HOS_ID
					  FROM HospitalList hos(nolock)
						   INNER JOIN DealerAuthorizationTable aut(nolock)
							  ON hos.HLA_DAT_ID = aut.DAT_ID
						   INNER JOIN Hospital(nolock)
							  ON Hospital.HOS_ID = hos.HLA_HOS_ID
							INNER JOIN V_AllHospitalMarketProperty AMP(nolock) ON AMP.ProductLineID=aut.DAT_ProductLine_BUM_ID 
										AND AMP.Hos_Id=Hospital.Hos_Id
					 WHERE  aut.DAT_ProductLine_BUM_ID=@ProductLineId
							  AND aut.DAT_DMA_ID = @DealerId
							  AND CONVERT(NVARCHAR(10),ISNULL(AMP.MarketProperty,0))=@MarketType
							  AND aut.DAT_PMA_ID IN (SELECT DISTINCT CA_ID FROM V_ProductClassificationStructure(nolock) WHERE CC_ID=@CCId))TAB
			END		
			SET @RtnVal  =@RtnVal+' Hospital(s)';	
	END
	
	IF @SelectType=4
	BEGIN
		SELECT  @RtnVal=COUNT (DISTINCT B.TA_Area) 
			FROM DealerAuthorizationArea A(nolock)
			INNER JOIN TerritoryArea B ON A.DA_ID=B.TA_DA_ID
		WHERE a.DA_DMA_ID=@DealerId 
			AND A.DA_PMA_ID IN (SELECT DISTINCT CA_ID FROM V_ProductClassificationStructure(nolock) WHERE CC_ID=@CCId)
			AND A.DA_DeletedFlag='0'
		
		SET @RtnVal=(CONVERT(nvarchar(50),@RtnVal)+ ' Territory(s)')
	END

	RETURN @RtnVal
END

GO


