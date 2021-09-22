DROP PROCEDURE [dbo].[GC_HospitalProductAOPInit] 
GO


/**********************************************
	功能：校验医院产品指标
	作者：GrapeCity
	最后更新时间：	2016-07-15
	更新记录说明：
	1.创建 2016-07-15
**********************************************/
CREATE PROCEDURE [dbo].[GC_HospitalProductAOPInit] 
	@ContractId NVARCHAR(36),
	@BEGINDATE DATETIME,
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN 
		CREATE TABLE #TEMPTABLE(
			Year NVARCHAR(4),
			HospitalCode NVARCHAR(20),
			ProductCode NVARCHAR(20),
			MONTH NVARCHAR(2),
			Amount FLOAT
		)
		
		CREATE TABLE #TEMPTABLE_RE(
			Year NVARCHAR(4),
			HospitalCode NVARCHAR(20),
			ProductCode NVARCHAR(20),
			MONTH NVARCHAR(2),
			Amount FLOAT
		)

		SET @IsValid='Success';
		
		UPDATE A SET ErrMassage='医院编码不能为空'
		FROM HospitalProductAOPInputTemp A 
		WHERE ISNULL(A.HospitalCode,'')='' AND ISNULL(A.ErrMassage,'')='' AND A.ContractId=@ContractId;

		UPDATE A SET a.ErrMassage='产品编码不能为空'
		FROM HospitalProductAOPInputTemp A 
		WHERE ISNULL(A.ProductCode,'')='' AND ISNULL(A.ErrMassage,'')='' AND A.ContractId=@ContractId

			
		UPDATE A SET ErrMassage='医院编码填写错误'
		FROM HospitalProductAOPInputTemp A 
		WHERE  ISNULL(A.ErrMassage,'')='' AND A.ContractId=@ContractId
		AND NOT EXISTS(SELECT 1 FROM Hospital B WHERE A.HospitalCode=B.HOS_Key_Account)

		UPDATE A SET ErrMassage='产品编码填写错误'
		FROM HospitalProductAOPInputTemp A 
		WHERE  ISNULL(A.ErrMassage,'')='' AND A.ContractId=@ContractId
		AND NOT EXISTS(SELECT 1 FROM Hospital B WHERE A.HospitalCode=B.HOS_Key_Account)

		UPDATE A SET ErrMassage='该医院产品指标不能设置'
		FROM HospitalProductAOPInputTemp A 
		INNER JOIN Hospital C ON C.HOS_Key_Account=A.HospitalCode
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota WHERE @BEGINDATE BETWEEN CQ_StartDate AND CQ_EndDate) D ON D.CQ_Code=A.ProductCode
		WHERE  ISNULL(A.ErrMassage,'')='' AND A.ContractId=@ContractId
		AND NOT EXISTS(SELECT 1 FROM AOPDealerHospitalTemp B WHERE B.AOPDH_Hospital_ID=C.HOS_ID AND  D.CQ_ID=B.AOPDH_PCT_ID and B.AOPDH_Contract_ID=A.ContractId)
		
		
		INSERT INTO #TEMPTABLE(Year,HospitalCode,ProductCode,MONTH,Amount)
		SELECT A.Year,A.HospitalCode,A.ProductCode,'01',M1 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId UNION
		SELECT A.Year,A.HospitalCode,A.ProductCode,'02',M2 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId UNION
		SELECT A.Year,A.HospitalCode,A.ProductCode,'03',M3 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId UNION
		SELECT A.Year,A.HospitalCode,A.ProductCode,'04',M4 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId UNION
		SELECT A.Year,A.HospitalCode,A.ProductCode,'05',M5 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId UNION
		SELECT A.Year,A.HospitalCode,A.ProductCode,'06',M6 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId UNION
		SELECT A.Year,A.HospitalCode,A.ProductCode,'07',M7 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId UNION
		SELECT A.Year,A.HospitalCode,A.ProductCode,'08',M8 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId UNION
		SELECT A.Year,A.HospitalCode,A.ProductCode,'09',M9 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId UNION
		SELECT A.Year,A.HospitalCode,A.ProductCode,'10',M10 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId UNION
		SELECT A.Year,A.HospitalCode,A.ProductCode,'11',M11 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId UNION
		SELECT A.Year,A.HospitalCode,A.ProductCode,'12',M12 FROM HospitalProductAOPInputTemp A WHERE A.ContractId= @ContractId
		
		DECLARE @DEALERID uniqueidentifier;
		SELECT TOP 1 @DEALERID= A.AOPDH_Dealer_DMA_ID FROM AOPDealerHospitalTemp A WHERE A.AOPDH_Contract_ID=@ContractId;
		
		INSERT INTO #TEMPTABLE_RE(Year,HospitalCode,ProductCode,MONTH,Amount)
		SELECT A.AOPDH_Year,B.HOS_Key_Account,C.CQ_Code,A.AOPDH_Month,A.AOPDH_Amount FROM AOPDealerHospital A 
		INNER JOIN Hospital B ON A.AOPDH_Hospital_ID=B.HOS_ID 
		INNER JOIN (SELECT DISTINCT CQ_Code,CQ_ID FROM INTERFACE.ClassificationQuota where @BEGINDATE between CQ_StartDate and CQ_EndDate) C ON A.AOPDH_PCT_ID=C.CQ_ID
		INNER JOIN #TEMPTABLE D ON D.HospitalCode=B.HOS_Key_Account AND D.MONTH=A.AOPDH_Month AND D.ProductCode=C.CQ_Code AND A.AOPDH_Year=D.Year 
		WHERE A.AOPDH_Dealer_DMA_ID=ISNULL(@DEALERID,'00000000-0000-0000-0000-000000000000')
		
		--新授权过去月份授权不能维护
		UPDATE A SET a.ErrMassage='过去月份指标不能维护 （'+CONVERT(NVARCHAR(10),MONTH(@BEGINDATE))+' 月之前指标）'
		FROM HospitalProductAOPInputTemp A 
		WHERE  ISNULL(A.ErrMassage,'')='' 
		AND A.ContractId=@ContractId 
		AND a.Year=YEAR(@BEGINDATE)
		AND NOT EXISTS(SELECT 1 FROM #TEMPTABLE_RE B WHERE B.Year=A.Year AND A.HospitalCode=B.HospitalCode AND A.ProductCode=B.ProductCode)
		AND EXISTS(SELECT 1 FROM #TEMPTABLE C WHERE C.Year=A.Year AND A.HospitalCode=C.HospitalCode AND A.ProductCode=C.ProductCode AND CONVERT(INT,C.[MONTH]) < MONTH(@BEGINDATE) AND C.Amount>0)
		
		--老授权过去月份指标不能修改
		UPDATE A SET a.ErrMassage='过去月份指标不能修改 （'+CONVERT(NVARCHAR(10),MONTH(@BEGINDATE))+' 月之前指标）'
		FROM HospitalProductAOPInputTemp A 
		WHERE  ISNULL(A.ErrMassage,'')='' 
		AND A.ContractId=@ContractId 
		AND a.Year=YEAR(@BEGINDATE)
		AND EXISTS(SELECT 1 FROM #TEMPTABLE_RE B WHERE B.Year=A.Year AND A.HospitalCode=B.HospitalCode AND A.ProductCode=B.ProductCode)
		AND EXISTS(SELECT 1 FROM #TEMPTABLE C ,#TEMPTABLE_RE D
			WHERE C.Year=A.Year AND A.HospitalCode=C.HospitalCode 
				AND A.ProductCode=C.ProductCode 
				
				AND C.Year=D.Year AND D.HospitalCode=C.HospitalCode 
				AND D.ProductCode=C.ProductCode  AND D.MONTH=C.MONTH
				AND CONVERT(INT,C.[MONTH]) < MONTH(@BEGINDATE) 
				AND CONVERT(decimal(18,6),D.Amount)<>CONVERT(decimal(18,6),C.Amount))
		
		
		IF EXISTS(SELECT 1 FROM HospitalProductAOPInputTemp  WHERE ISNULL(ErrMassage,'')<>'' AND ContractId=@ContractId)
		BEGIN
			SET @IsValid='Error';
		END
	  
END 


GO


