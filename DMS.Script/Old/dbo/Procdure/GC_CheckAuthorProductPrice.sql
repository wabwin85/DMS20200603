DROP  Procedure [dbo].[GC_CheckAuthorProductPrice]
GO


CREATE Procedure [dbo].[GC_CheckAuthorProductPrice]
	@Contract_ID uniqueidentifier,
	@ProductLineBumId uniqueidentifier,
	@priceidString NVARCHAR(MAX)
	
AS
	DECLARE @Retrun NVARCHAR(50);
	DECLARE @TCOUNT NVARCHAR(50);
	
SET NOCOUNT ON
	BEGIN
		SET @Retrun='0';
		SET @TCOUNT=0;
		SELECT @TCOUNT=SUM(TCOUNT) FROM (
		SELECT PCS.CQ_Code,PCS.Year,SUM(TB.TCOUNT) TCOUNT  
		FROM (SELECT DISTINCT CQ_Code,CQ_ID,CP_ID,Year FROM V_ProductClassificationStructure WHERE CC_ProductLineID=@ProductLineBumId) PCS
		INNER JOIN (select VAL, 1 AS TCOUNT  from  dbo.GC_Fn_SplitStringToTable(@priceidString,','))TB ON TB.VAL=PCS.CP_ID
		GROUP BY PCS.CQ_Code,PCS.Year) TB
		WHERE TB.TCOUNT>1
		GROUP BY TB.CQ_Code,TB.Year
		
		IF(@TCOUNT>0)
		BEGIN
			SET @Retrun='1';
		END
		ELSE
		BEGIN
			SELECT @TCOUNT=COUNT(*) FROM (
			SELECT A.AOPHPM_PCT_ID,MP.CP_ID FROM AOPHospitalProductMapping  A
			LEFT JOIN (SELECT B.CQ_ID,B.CP_ID   FROM V_ProductClassificationStructure  B 
			INNER JOIN  (select VAL AS PCP_ID  from  dbo.GC_Fn_SplitStringToTable(@priceidString,','))TB  ON B.CP_ID=TB.PCP_ID) MP
			ON A.AOPHPM_PCT_ID=MP.CQ_ID
			WHERE AOPHPM_ContractId=@Contract_ID) TBTO
			WHERE TBTO.CP_ID IS NULL
			
			IF (@TCOUNT>0)
			BEGIN
				SET @Retrun='2';
			END
			ELSE
			BEGIN
				SET @Retrun='0';
			END
			
		END
		
		SELECT @Retrun AS Retrun;
	
	END
	




GO


