DROP PROCEDURE [dbo].[GC_HospitalProductAOPSubmint] 
GO


/**********************************************
	功能：提交医院产品指标
	作者：GrapeCity
	最后更新时间：	2016-07-15
	更新记录说明：
	1.创建 2016-07-15
**********************************************/
CREATE PROCEDURE [dbo].[GC_HospitalProductAOPSubmint] 
	@ContractId NVARCHAR(36),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN 
		SET @IsValid='Success';
		
		UPDATE A  SET A.AOPDH_Amount=B.M1 
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='01'
		AND A.AOPDH_Contract_ID=@ContractId
		
		UPDATE A  SET A.AOPDH_Amount=B.M2 
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code  FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='02' 
		AND A.AOPDH_Contract_ID=@ContractId
		
		UPDATE A  SET A.AOPDH_Amount=B.M3
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='03' 
		AND A.AOPDH_Contract_ID=@ContractId
		
		UPDATE A  SET A.AOPDH_Amount=B.M4
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='04' 
		AND A.AOPDH_Contract_ID=@ContractId
	  
		UPDATE A  SET A.AOPDH_Amount=B.M5
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='05' 
		AND A.AOPDH_Contract_ID=@ContractId
		
		UPDATE A  SET A.AOPDH_Amount=B.M6
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='06' 
		AND A.AOPDH_Contract_ID=@ContractId
		
		UPDATE A  SET A.AOPDH_Amount=B.M7
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='07' 
		AND A.AOPDH_Contract_ID=@ContractId
		
		
		UPDATE A  SET A.AOPDH_Amount=B.M8
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='08' 
		AND A.AOPDH_Contract_ID=@ContractId
		
		
		UPDATE A  SET A.AOPDH_Amount=B.M9
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='09' 
		AND A.AOPDH_Contract_ID=@ContractId
		
		UPDATE A  SET A.AOPDH_Amount=B.M10
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='10' 
		AND A.AOPDH_Contract_ID=@ContractId
		
		UPDATE A  SET A.AOPDH_Amount=B.M11
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='11' 
		AND A.AOPDH_Contract_ID=@ContractId
		
		UPDATE A  SET A.AOPDH_Amount=B.M12
		FROM AOPDealerHospitalTemp A 
		INNER JOIN Hospital C ON A.AOPDH_Hospital_ID=C.HOS_ID
		INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
		INNER JOIN HospitalProductAOPInputTemp B 
			ON A.AOPDH_Contract_ID=B.ContractId  AND B.HospitalCode=C.HOS_Key_Account AND B.ProductCode=D.CQ_Code
			AND A.AOPDH_Year=B.[Year]
		WHERE A.AOPDH_Month='12' 
		AND A.AOPDH_Contract_ID=@ContractId
END 


GO


