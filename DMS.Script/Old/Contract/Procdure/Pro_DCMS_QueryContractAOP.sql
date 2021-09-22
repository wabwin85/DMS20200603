DROP PROCEDURE [Contract].[Pro_DCMS_QueryContractAOP]
GO

/**********************************************
	功能：合同管理-授权指标查询结果
	作者：Huakaichun
	最后更新时间：	2017-08-15
	更新记录说明：
	1.创建 2017-08-15
**********************************************/
CREATE PROCEDURE [Contract].[Pro_DCMS_QueryContractAOP]
	@ContractId NVARCHAR(36),
	@DealerId NVARCHAR(36),
	@SubBU NVARCHAR(50),
	@ContractType NVARCHAR(50) --合同类型
AS
BEGIN

	DECLARE @LastContractId uniqueidentifier
	DECLARE @AOPType NVARCHAR(50)

	CREATE TABLE #ConTol
	(
		ContractId uniqueidentifier,
		DealerId uniqueidentifier,
		SubBU NVARCHAR(50),
		MarketType INT,
		BeginDate DATETIME,
		EndDate DATETIME,
		ContractType NVARCHAR(50),
		UpdateDate DATETIME
	)

	INSERT INTO #ConTol (ContractId,DealerId,MarketType,BeginDate,EndDate,SubBU,ContractType,UpdateDate)
	SELECT a.CAP_ID,a.CAP_DMA_ID,a.CAP_MarketType,CAP_EffectiveDate,CAP_ExpirationDate,a.CAP_SubDepID ,'Appointment',a.CAP_Update_Date from ContractAppointment a where a.CAP_Status='Completed' and a.CAP_DMA_ID=@DealerId and a.CAP_SubDepID=@SubBU 
	UNION
	SELECT a.CAM_ID,a.CAM_DMA_ID,a.CAM_MarketType,CAM_Amendment_EffectiveDate,CAM_Agreement_ExpirationDate,a.CAM_SubDepID,'Amendment',a.CAM_Update_Date from ContractAmendment a where a.CAM_Status='Completed' and a.CAM_Quota_IsChange='1' and a.CAM_DMA_ID=@DealerId and a.CAM_SubDepID=@SubBU 
	UNION
	SELECT  a.CRE_ID,a.CRE_DMA_ID,a.CRE_MarketType,CRE_Agrmt_EffectiveDate_Renewal,CRE_Agrmt_ExpirationDate_Renewal,a.CRE_SubDepID,'Renewal',a.CRE_Update_Date  from ContractRenewal a where a.CRE_Status='Completed' and a.CRE_DMA_ID=@DealerId and a.CRE_SubDepID=@SubBU 

	IF  EXISTS(SELECT 1 FROM #ConTol WHERE ContractId=@ContractId)
	BEGIN
		DECLARE @UpdateDate DATETIME
		SELECT @UpdateDate =UpdateDate FROM #ConTol WHERE ContractId=@ContractId;
		SELECT TOP 1 @LastContractId=ContractId FROM #ConTol WHERE CONVERT(NVARCHAR(10),UpdateDate,120) <CONVERT(NVARCHAR(10),@UpdateDate,120)  ORDER BY UpdateDate DESC
	END
	ELSE
	BEGIN
		SELECT TOP 1 @LastContractId=ContractId FROM #ConTol  ORDER BY UpdateDate DESC
	END
	
	SELECT @AOPType=AOPTYPE FROM Contract.SubBuParam WHERE SUBDEPID=@SubBU
	
	IF @ContractType='Amendment' 
	BEGIN
		SET @LastContractId=ISNULL(@LastContractId,'00000000-0000-0000-0000-000000000000');
		
		
		BEGIN --获取医院实际指标与标准指标历史指标的比对
			SELECT ContractId,
			DmaId,
			ProductLineId,
			ProductId,
			ProductName, --指标分类名称
			HospitalId,
			OperType,--是否新增授权标志
			HospitalName,--医院名称
			Year,--指标年份
			Amount1,Amount2,Amount3,Amount4,Amount5,Amount6,Amount7,Amount8,Amount9,Amount10,Amount11,Amount12,--(1-12月医院实际指标)
			Q1,Q2,Q3,Q4,AmountY,
			dbo.GetFormatString(ISNULL(FromalAmount1,ISNULL(RefAmount1,0)),0) RefAmount1, --1月标准/历史 指标
			dbo.GetFormatString(ISNULL(FromalAmount2,ISNULL(RefAmount2,0)),0) RefAmount2,--2月标准/历史 指标
			dbo.GetFormatString(ISNULL(FromalAmount3,ISNULL(RefAmount3,0)),0) RefAmount3,--3月标准/历史 指标
			dbo.GetFormatString(ISNULL(FromalAmount4,ISNULL(RefAmount4,0)),0) RefAmount4,--4月标准/历史 指标
			dbo.GetFormatString(ISNULL(FromalAmount5,ISNULL(RefAmount5,0)),0) RefAmount5,--5月标准/历史 指标
			dbo.GetFormatString(ISNULL(FromalAmount6,ISNULL(RefAmount6,0)),0) RefAmount6,--6月标准/历史 指标
			dbo.GetFormatString(ISNULL(FromalAmount7,ISNULL(RefAmount7,0)),0) RefAmount7,--7月标准/历史 指标
			dbo.GetFormatString(ISNULL(FromalAmount8,ISNULL(RefAmount8,0)),0) RefAmount8,--8月标准/历史 指标
			dbo.GetFormatString(ISNULL(FromalAmount9,ISNULL(RefAmount9,0)),0) RefAmount9,--9月标准/历史 指标
			dbo.GetFormatString(ISNULL(FromalAmount10,ISNULL(RefAmount10,0)),0) RefAmount10,--10月标准/历史 指标
			dbo.GetFormatString(ISNULL(FromalAmount11,ISNULL(RefAmount11,0)),0) RefAmount11,--11月标准/历史 指标
			dbo.GetFormatString(ISNULL(FromalAmount12,ISNULL(RefAmount12,0)),0) RefAmount12,--12月标准/历史 指标

			dbo.GetFormatString((ISNULL(FromalAmount1,ISNULL(RefAmount1,0)) + ISNULL(FromalAmount2,ISNULL(RefAmount2,0)) +
			ISNULL(FromalAmount3,ISNULL(RefAmount3,0))),0) RefQ1, --Q1标准/历史 指标
			dbo.GetFormatString((ISNULL(FromalAmount4,ISNULL(RefAmount4,0)) + ISNULL(FromalAmount5,ISNULL(RefAmount5,0)) +
			ISNULL(FromalAmount6,ISNULL(RefAmount6,0)) ),0) RefQ2, --Q2标准/历史 指标
			dbo.GetFormatString((ISNULL(FromalAmount7,ISNULL(RefAmount7,0)) + ISNULL(FromalAmount8,ISNULL(RefAmount8,0)) +
			ISNULL(FromalAmount9,ISNULL(RefAmount9,0))),0) RefQ3, --Q3标准/历史 指标
			dbo.GetFormatString((ISNULL(FromalAmount10,ISNULL(RefAmount10,0)) + ISNULL(FromalAmount11,ISNULL(RefAmount11,0)) +
			ISNULL(FromalAmount12,ISNULL(RefAmount12,0))),0) RefQ4, --Q4标准/历史 指标

			dbo.GetFormatString((ISNULL(FromalAmount1,ISNULL(RefAmount1,0)) +
			ISNULL(FromalAmount2,ISNULL(RefAmount2,0)) +
			ISNULL(FromalAmount3,ISNULL(RefAmount3,0)) +
			ISNULL(FromalAmount4,ISNULL(RefAmount4,0)) +
			ISNULL(FromalAmount5,ISNULL(RefAmount5,0)) +
			ISNULL(FromalAmount6,ISNULL(RefAmount6,0))+
			ISNULL(FromalAmount7,ISNULL(RefAmount7,0)) +
			ISNULL(FromalAmount8,ISNULL(RefAmount8,0)) +
			ISNULL(FromalAmount9,ISNULL(RefAmount9,0)) +
			ISNULL(FromalAmount10,ISNULL(RefAmount10,0)) +
			ISNULL(FromalAmount11,ISNULL(RefAmount11,0)) +
			ISNULL(FromalAmount12,ISNULL(RefAmount12,0))),0) RefYear, --全年标准/历史 指标
			CanUpdate ,--被删除指标标识
			row_number () OVER (ORDER BY CanUpdate  DESC) AS [row_number]
			FROM
			(SELECT
			[dbo].[GC_Fn_DCMS_CheckHospitalProductQuery](AOP.AOPDH_Contract_ID,AOP.AOPDH_Hospital_ID,AOP.AOPDH_PCT_ID) AS CanUpdate ,
			AOP.AOPDH_Contract_ID as ContractId,
			AOP.AOPDH_Dealer_DMA_ID as DmaId,
			AOP.AOPDH_ProductLine_BUM_ID as ProductLineId,
			AOP.AOPDH_PCT_ID as ProductId,
			pcf.CQ_NameCN as ProductName,
			AOP.AOPDH_Hospital_ID as HospitalId,
			tree.Territory_Type as OperType,
			Hospital.HOS_HospitalName as HospitalName,
			AOP.AOPDH_Year as Year,
			dbo.GetFormatString(AOP.AOPDH_Amount_1,0) as Amount1,
			dbo.GetFormatString(AOP.AOPDH_Amount_2,0) as Amount2,
			dbo.GetFormatString(AOP.AOPDH_Amount_3,0) as Amount3,
			dbo.GetFormatString(AOP.AOPDH_Amount_4,0) as Amount4,
			dbo.GetFormatString(AOP.AOPDH_Amount_5,0) as Amount5,
			dbo.GetFormatString(AOP.AOPDH_Amount_6,0) as Amount6,
			dbo.GetFormatString(AOP.AOPDH_Amount_7,0) as Amount7,
			dbo.GetFormatString(AOP.AOPDH_Amount_8,0) as Amount8,
			dbo.GetFormatString(AOP.AOPDH_Amount_9,0) as Amount9,
			dbo.GetFormatString(AOP.AOPDH_Amount_10,0) as Amount10,
			dbo.GetFormatString(AOP.AOPDH_Amount_11,0) as Amount11,
			dbo.GetFormatString(AOP.AOPDH_Amount_12,0) as Amount12,
			dbo.GetFormatString(AOP.AOPDH_Amount_Y,0) as AmountY,
			dbo.GetFormatString((AOP.AOPDH_Amount_1 +AOP.AOPDH_Amount_2+AOP.AOPDH_Amount_3),0) Q1,
			dbo.GetFormatString((AOP.AOPDH_Amount_4 +AOP.AOPDH_Amount_5+AOP.AOPDH_Amount_6),0) Q2,
			dbo.GetFormatString((AOP.AOPDH_Amount_7 +AOP.AOPDH_Amount_8+AOP.AOPDH_Amount_9),0) Q3,
			dbo.GetFormatString((AOP.AOPDH_Amount_10 +AOP.AOPDH_Amount_11+AOP.AOPDH_Amount_12),0) Q4,

			rec.AOPHR_January as RefAmount1 ,
			rec.AOPHR_February as RefAmount2,
			rec.AOPHR_March as RefAmount3,
			rec.AOPHR_April as RefAmount4 ,
			rec.AOPHR_May as RefAmount5,
			rec.AOPHR_June as RefAmount6,
			rec.AOPHR_July as RefAmount7 ,
			rec.AOPHR_August as RefAmount8,
			rec.AOPHR_September as RefAmount9,
			rec.AOPHR_October as RefAmount10 ,
			rec.AOPHR_November as RefAmount11,
			rec.AOPHR_December as RefAmount12

			,Formal.AOPDH_Amount_1 FromalAmount1
			,Formal.AOPDH_Amount_2 FromalAmount2
			,Formal.AOPDH_Amount_3 FromalAmount3
			,Formal.AOPDH_Amount_4 FromalAmount4
			,Formal.AOPDH_Amount_5 FromalAmount5
			,Formal.AOPDH_Amount_6 FromalAmount6
			,Formal.AOPDH_Amount_7 FromalAmount7
			,Formal.AOPDH_Amount_8 FromalAmount8
			,Formal.AOPDH_Amount_9 FromalAmount9
			,Formal.AOPDH_Amount_10 FromalAmount10
			,Formal.AOPDH_Amount_11 FromalAmount11
			,Formal.AOPDH_Amount_12 FromalAmount12
			,REK.Rmk_Body RmkBody
			FROM V_AOPDealerHospital_Temp AOP
			left join AOPHospitalReference rec on AOP.AOPDH_ProductLine_BUM_ID=rec.AOPHR_ProductLine_BUM_ID
			and AOP.AOPDH_Hospital_ID=rec.AOPHR_Hospital_ID
			AND CONVERT(INT,AOP.AOPDH_Year)=CONVERT(INT,rec.AOPHR_Year)
			and AOP.AOPDH_PCT_ID=rec.AOPHR_PCT_ID

			left join V_AOPDealerHospital_Temp Formal on  Formal.AOPDH_Hospital_ID=AOP.AOPDH_Hospital_ID
			and Formal.AOPDH_PCT_ID=AOP.AOPDH_PCT_ID
			and Formal.AOPDH_Year=AOP.AOPDH_Year AND Formal.AOPDH_Contract_ID=@LastContractId

			inner join Hospital on Hospital.HOS_ID=AOP.AOPDH_Hospital_ID
			inner join (SELECT DISTINCT CQ_ID,CQ_NameCN FROM interface.ClassificationQuota)  pcf on pcf.CQ_ID=aop.AOPDH_PCT_ID
			left join (SELECT c.CQ_ID,b.HOS_ID,b.Territory_Type FROM DealerAuthorizationTableTemp a
			INNER JOIN (select distinct CA_ID,CQ_ID from V_ProductClassificationStructure) c on c.CA_ID=a.DAT_PMA_ID
			inner join ContractTerritory b on a.DAT_ID=b.Contract_ID and a.DAT_DCL_ID=@ContractId  AND B.Territory_Type='New') tree
			on tree.HOS_ID=AOP.AOPDH_Hospital_ID and AOP.AOPDH_PCT_ID=tree.CQ_ID 
			LEFT JOIN AOPRemark REK ON REK.Rmk_ContractID=AOP.AOPDH_Contract_ID AND REK.Rmk_Hos_ID=AOP.AOPDH_Hospital_ID AND REK.Rmk_Rv1=CONVERT(NVARCHAR(100),AOP.AOPDH_PCT_ID)
			WHERE AOP.AOPDH_Contract_ID=@ContractId
			) TAB
			where TAB.ContractId= @ContractId
		END
		
		
		IF @AOPType<>'Unit'--金额指标
		BEGIN
			PRINT 'AmendmentAmount'
			
			BEGIN --医院指标汇总经销商指标
				  SELECT *
				  ,row_number ()    OVER (ORDER BY TAB.Nber ASC) AS [row_number]
				  FROM (

				  SELECT B.HOS_HospitalName AS HospitalName, --医院名称
				  B.HOS_ID AS HospitalId,--医院ID
				  A.AOPDH_Year Year,--指标年份
				  SUM(A.AOPDH_Amount_1) AS Amount1, --1月实际指标
				  SUM(A.AOPDH_Amount_2) AS Amount2, --2月实际指标
				  SUM(A.AOPDH_Amount_3) AS Amount3, --3月实际指标
				  SUM(A.AOPDH_Amount_4) AS Amount4,SUM(A.AOPDH_Amount_5) AS Amount5,SUM(A.AOPDH_Amount_6) AS Amount6,
				  SUM(A.AOPDH_Amount_7) AS Amount7,SUM(A.AOPDH_Amount_8) AS Amount8,SUM(A.AOPDH_Amount_9) AS Amount9,
				  SUM(A.AOPDH_Amount_10) AS Amount10,SUM(A.AOPDH_Amount_11) AS Amount11,SUM(A.AOPDH_Amount_12) AS Amount12,
				  SUM(A.AOPDH_Amount_Y) AS AmountY,
				  SUM((A.AOPDH_Amount_1+A.AOPDH_Amount_2+A.AOPDH_Amount_3)) Q1,
				  SUM((A.AOPDH_Amount_4+A.AOPDH_Amount_5+A.AOPDH_Amount_6)) Q2,
				  SUM((A.AOPDH_Amount_7+A.AOPDH_Amount_8+A.AOPDH_Amount_9)) Q3,
				  SUM((A.AOPDH_Amount_10+A.AOPDH_Amount_11+A.AOPDH_Amount_12)) Q4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0)) ReAmount1,--1月标准/历史指标
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0)) ReAmount2,--2月标准/历史指标
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReAmount3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) ReAmount4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) ReAmount5,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReAmount6,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) ReAmount7,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) ReAmount8,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReAmount9,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0)) ReAmount10,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0)) ReAmount11,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReAmount12,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReQ1   ,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReQ2,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReQ3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReQ4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0))  ReAmountY
				  ,row_number ()    OVER (ORDER BY B.HOS_ID , A.AOPDH_Year ASC) AS Nber
				  FROM V_AOPDealerHospital_Temp A
				  INNER JOIN Hospital B ON A.AOPDH_Hospital_ID=B.HOS_ID
				  LEFT JOIN AOPHospitalReference C ON C.AOPHR_PCT_ID=A.AOPDH_PCT_ID
				  AND C.AOPHR_Hospital_ID=A.AOPDH_Hospital_ID
				  AND CONVERT(INT,C.AOPHR_Year)=CONVERT(INT,A.AOPDH_Year)
				  AND C.AOPHR_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  LEFT JOIN V_AOPDealerHospital_Temp D ON D.AOPDH_Contract_ID=@LastContractId
				  AND D.AOPDH_Hospital_ID=A.AOPDH_Hospital_ID
				  AND D.AOPDH_Year=A.AOPDH_Year
				  AND D.AOPDH_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  AND D.AOPDH_PCT_ID=A.AOPDH_PCT_ID
				  where A.AOPDH_Contract_ID= @ContractId 
					  GROUP BY B.HOS_HospitalName,B.HOS_ID,A.AOPDH_Year

				  UNION

				  SELECT '合计' AS HospitalName,NULL AS HospitalId,A.AOPDH_Year Year,
				  SUM(A.AOPDH_Amount_1) AS Amount1,SUM(A.AOPDH_Amount_2) AS Amount2,SUM(A.AOPDH_Amount_3) AS Amount3,
				  SUM(A.AOPDH_Amount_4) AS Amount4,SUM(A.AOPDH_Amount_5) AS Amount5,SUM(A.AOPDH_Amount_6) AS Amount6,
				  SUM(A.AOPDH_Amount_7) AS Amount7,SUM(A.AOPDH_Amount_8) AS Amount8,SUM(A.AOPDH_Amount_9) AS Amount9,
				  SUM(A.AOPDH_Amount_10) AS Amount10,SUM(A.AOPDH_Amount_11) AS Amount11,SUM(A.AOPDH_Amount_12) AS Amount12,
				  SUM(A.AOPDH_Amount_Y) AS AmountY,
				  SUM((A.AOPDH_Amount_1+A.AOPDH_Amount_2+A.AOPDH_Amount_3)) Q1,
				  SUM((A.AOPDH_Amount_4+A.AOPDH_Amount_5+A.AOPDH_Amount_6)) Q2,
				  SUM((A.AOPDH_Amount_7+A.AOPDH_Amount_8+A.AOPDH_Amount_9)) Q3,
				  SUM((A.AOPDH_Amount_10+A.AOPDH_Amount_11+A.AOPDH_Amount_12)) Q4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0)) ReAmount1,SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0)) ReAmount2,SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReAmount3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) ReAmount4,SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) ReAmount5,SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReAmount6,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) ReAmount7,SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) ReAmount8,SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReAmount9,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0)) ReAmount10,SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0)) ReAmount11,SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReAmount12,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReQ1   ,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReQ2,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReQ3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReQ4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0))  ReAmountY
				  ,0 AS Nber
				  FROM V_AOPDealerHospital_Temp A
				  INNER JOIN Hospital B ON A.AOPDH_Hospital_ID=B.HOS_ID
				  LEFT JOIN AOPHospitalReference C ON C.AOPHR_PCT_ID=A.AOPDH_PCT_ID
				  AND C.AOPHR_Hospital_ID=A.AOPDH_Hospital_ID
				  AND CONVERT(INT,C.AOPHR_Year)=CONVERT(INT,A.AOPDH_Year)
				  AND C.AOPHR_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  LEFT JOIN V_AOPDealerHospital_Temp D ON D.AOPDH_Contract_ID=@LastContractId
				  AND D.AOPDH_Hospital_ID=A.AOPDH_Hospital_ID
				  AND D.AOPDH_Year=A.AOPDH_Year
				  AND D.AOPDH_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  AND D.AOPDH_PCT_ID=A.AOPDH_PCT_ID
				  where A.AOPDH_Contract_ID= @ContractId 
					  GROUP BY A.AOPDH_Year
				  ) TAB
			END
			
			BEGIN --产品指标汇总
				  SELECT *
				  ,row_number ()    OVER (ORDER BY TAB.Nber ASC) AS [row_number]
				  FROM (

				  SELECT B.CQ_NameCN AS ProductName,B.CQ_ID AS ProductId,B.CQ_Code AS ProductCode,A.AOPDH_Year Year,
				  SUM(A.AOPDH_Amount_1) AS Amount1,SUM(A.AOPDH_Amount_2) AS Amount2,SUM(A.AOPDH_Amount_3) AS Amount3,
				  SUM(A.AOPDH_Amount_4) AS Amount4,SUM(A.AOPDH_Amount_5) AS Amount5,SUM(A.AOPDH_Amount_6) AS Amount6,
				  SUM(A.AOPDH_Amount_7) AS Amount7,SUM(A.AOPDH_Amount_8) AS Amount8,SUM(A.AOPDH_Amount_9) AS Amount9,
				  SUM(A.AOPDH_Amount_10) AS Amount10,SUM(A.AOPDH_Amount_11) AS Amount11,SUM(A.AOPDH_Amount_12) AS Amount12,
				  SUM(A.AOPDH_Amount_Y) AS AmountY,
				  SUM((A.AOPDH_Amount_1+A.AOPDH_Amount_2+A.AOPDH_Amount_3)) Q1,
				  SUM((A.AOPDH_Amount_4+A.AOPDH_Amount_5+A.AOPDH_Amount_6)) Q2,
				  SUM((A.AOPDH_Amount_7+A.AOPDH_Amount_8+A.AOPDH_Amount_9)) Q3,
				  SUM((A.AOPDH_Amount_10+A.AOPDH_Amount_11+A.AOPDH_Amount_12)) Q4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0)) ReAmount1,SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0)) ReAmount2,SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReAmount3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) ReAmount4,SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) ReAmount5,SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReAmount6,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) ReAmount7,SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) ReAmount8,SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReAmount9,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0)) ReAmount10,SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0)) ReAmount11,SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReAmount12,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReQ1   ,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReQ2,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReQ3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReQ4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0))  ReAmountY
				  ,row_number ()    OVER (ORDER BY B.CQ_Code , A.AOPDH_Year ASC) AS Nber
				  FROM V_AOPDealerHospital_Temp A
				  INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code,CQ_NameCN FROM INTERFACE.ClassificationQuota) B ON A.AOPDH_PCT_ID=b.CQ_ID
				  LEFT JOIN AOPHospitalReference C ON C.AOPHR_PCT_ID=A.AOPDH_PCT_ID
				  AND C.AOPHR_Hospital_ID=A.AOPDH_Hospital_ID
				  AND CONVERT(INT,C.AOPHR_Year)=CONVERT(INT,A.AOPDH_Year)
				  AND C.AOPHR_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  LEFT JOIN V_AOPDealerHospital_Temp D ON D.AOPDH_Contract_ID=@LastContractId
				  AND D.AOPDH_Hospital_ID=A.AOPDH_Hospital_ID
				  AND CONVERT(INT,D.AOPDH_Year)=CONVERT(INT,A.AOPDH_Year)
				  AND D.AOPDH_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  AND D.AOPDH_PCT_ID=A.AOPDH_PCT_ID
				  where A.AOPDH_Contract_ID= @ContractId 
				  GROUP BY B.CQ_Code,B.CQ_ID,B.CQ_NameCN,A.AOPDH_Year

				  UNION
				  SELECT '合计' AS ProductName,NULL AS HospitalId,NULL,A.AOPDH_Year Year,
				  SUM(A.AOPDH_Amount_1) AS Amount1,SUM(A.AOPDH_Amount_2) AS Amount2,SUM(A.AOPDH_Amount_3) AS Amount3,
				  SUM(A.AOPDH_Amount_4) AS Amount4,SUM(A.AOPDH_Amount_5) AS Amount5,SUM(A.AOPDH_Amount_6) AS Amount6,
				  SUM(A.AOPDH_Amount_7) AS Amount7,SUM(A.AOPDH_Amount_8) AS Amount8,SUM(A.AOPDH_Amount_9) AS Amount9,
				  SUM(A.AOPDH_Amount_10) AS Amount10,SUM(A.AOPDH_Amount_11) AS Amount11,SUM(A.AOPDH_Amount_12) AS Amount12,
				  SUM(A.AOPDH_Amount_Y) AS AmountY,
				  SUM((A.AOPDH_Amount_1+A.AOPDH_Amount_2+A.AOPDH_Amount_3)) Q1,
				  SUM((A.AOPDH_Amount_4+A.AOPDH_Amount_5+A.AOPDH_Amount_6)) Q2,
				  SUM((A.AOPDH_Amount_7+A.AOPDH_Amount_8+A.AOPDH_Amount_9)) Q3,
				  SUM((A.AOPDH_Amount_10+A.AOPDH_Amount_11+A.AOPDH_Amount_12)) Q4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0)) ReAmount1,SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0)) ReAmount2,SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReAmount3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) ReAmount4,SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) ReAmount5,SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReAmount6,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) ReAmount7,SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) ReAmount8,SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReAmount9,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0)) ReAmount10,SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0)) ReAmount11,SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReAmount12,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReQ1   ,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReQ2,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReQ3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReQ4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0))  ReAmountY
				  ,0 AS Nber
				  FROM V_AOPDealerHospital_Temp A
				  INNER JOIN Hospital B ON A.AOPDH_Hospital_ID=B.HOS_ID
				  LEFT JOIN AOPHospitalReference C ON C.AOPHR_PCT_ID=A.AOPDH_PCT_ID
				  AND C.AOPHR_Hospital_ID=A.AOPDH_Hospital_ID
				  AND CONVERT(INT,C.AOPHR_Year)=CONVERT(INT,A.AOPDH_Year)
				  AND C.AOPHR_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  LEFT JOIN V_AOPDealerHospital_Temp D ON D.AOPDH_Contract_ID=@LastContractId
				  AND D.AOPDH_Hospital_ID=A.AOPDH_Hospital_ID
				  AND D.AOPDH_Year=A.AOPDH_Year
				  AND D.AOPDH_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  AND D.AOPDH_PCT_ID=A.AOPDH_PCT_ID
				  WHERE A.AOPDH_Contract_ID= @ContractId
				  GROUP BY A.AOPDH_Year
				  ) TAB
			END
			
			BEGIN --经销商指标
			 SELECT *,row_number () OVER (ORDER BY TAB.Year,TAB.AOPType  DESC) AS [row_number]
			  FROM (SELECT AOPD_Contract_ID AS Contract_ID,
			  AOPD_Dealer_DMA_ID AS Dealer_DMA_ID,
			  AOPD_ProductLine_BUM_ID AS ProductLine_BUM_ID,
			  AOPD_Year AS Year,
			  '经销商采购指标(修改后)' AS AOPType,
			  dbo.GetFormatString(AOPD_Amount_1,0) AS Amount_1,
			  dbo.GetFormatString(AOPD_Amount_2,0) AS Amount_2,
			  dbo.GetFormatString(AOPD_Amount_3,0) AS Amount_3,
			  dbo.GetFormatString(AOPD_Amount_4,0) AS Amount_4,
			  dbo.GetFormatString(AOPD_Amount_5,0) AS Amount_5,
			  dbo.GetFormatString(AOPD_Amount_6,0) AS Amount_6,
			  dbo.GetFormatString(AOPD_Amount_7,0) AS Amount_7,
			  dbo.GetFormatString(AOPD_Amount_8,0) AS Amount_8,
			  dbo.GetFormatString(AOPD_Amount_9,0) AS Amount_9,
			  dbo.GetFormatString(AOPD_Amount_10,0) AS Amount_10,
			  dbo.GetFormatString(AOPD_Amount_11,0) AS Amount_11,
			  dbo.GetFormatString(AOPD_Amount_12,0) AS Amount_12,
			  dbo.GetFormatString(AOPD_Amount_Y,0) AS Amount_Y,
			  Rmk_Body AS RmkBody,
			  CASE
			  WHEN    ISNULL (HTP.SAOPDH_Amount_Y, '') = ''
			  OR HTP.SAOPDH_Amount_Y = 0
			  THEN NULL ELSE
			  (CASE WHEN    (CONVERT(decimal(18,4),AOPD_Amount_Y) - CONVERT(decimal(18,4),SAOPDH_Amount_Y)   <  0) OR (  (CONVERT(decimal(18,4),AOPD_Amount_Y) - CONVERT(decimal(18,4),SAOPDH_Amount_Y)) / SAOPDH_Amount_Y > 0.1)
			  THEN CASE WHEN EXISTS(SELECT 1 FROM INTERFACE.ClassificationContract WHERE CC_ID=TP.AOPD_CC_ID AND ISNULL(CC_RV2,'')='1') THEN '1' ELSE '0' END
			  ELSE '0' END) END  AS RefD_H
			  FROM V_AOPDealer_Temp TP
			  LEFT JOIN AOPRemark ON AOPD_Contract_ID = Rmk_ContractID AND Rmk_Type = 'Dealer'
			  LEFT JOIN (SELECT AOPDH_Contract_ID,  AOPDH_ProductLine_BUM_ID, AOPDH_Year, SUM (AOPDH_Amount_Y) AS SAOPDH_Amount_Y
			  FROM V_AOPDealerHospital_Temp
			  WHERE AOPDH_Contract_ID=@ContractId
			  GROUP BY AOPDH_Contract_ID,
			  AOPDH_ProductLine_BUM_ID,
			  AOPDH_Year
			  ) HTP ON HTP.AOPDH_Contract_ID = TP.AOPD_Contract_ID AND HTP.AOPDH_ProductLine_BUM_ID = TP.AOPD_ProductLine_BUM_ID AND HTP.AOPDH_Year = TP.AOPD_Year
			  WHERE TP.AOPD_Contract_ID=@ContractId
			  UNION
			  SELECT AOPDH_Contract_ID,
			  AOPDH_Dealer_DMA_ID,
			  AOPDH_ProductLine_BUM_ID,
			  AOPDH_Year,
			  '经销商医院实际指标' AS AOPType,
			  dbo.GetFormatString(SUM (AOPDH_Amount_1),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_2),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_3),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_4),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_5),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_6),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_7),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_8),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_9),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_10),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_11),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_12),0),
			  dbo.GetFormatString(SUM (AOPDH_Amount_Y),0),
			  '' AS RmkBody,
			  NULL RefD_H
			  FROM V_AOPDealerHospital_Temp
			  WHERE AOPDH_Contract_ID=@ContractId
			  GROUP BY AOPDH_Contract_ID,
			  AOPDH_Dealer_DMA_ID,
			  AOPDH_ProductLine_BUM_ID,
			  AOPDH_Year

			  UNION
			  SELECT TP.AOPD_Contract_ID,
			  TP.AOPD_Dealer_DMA_ID,
			  TP.AOPD_ProductLine_BUM_ID,
			  TP.AOPD_Year,
			  '经销商采购指标（修改前）' AS AOPType,
			  dbo.GetFormatString(TP.AOPD_Amount_1,0),
			  dbo.GetFormatString(TP.AOPD_Amount_2,0),
			  dbo.GetFormatString(TP.AOPD_Amount_3,0),
			  dbo.GetFormatString(TP.AOPD_Amount_4,0),
			  dbo.GetFormatString(TP.AOPD_Amount_5,0),
			  dbo.GetFormatString(TP.AOPD_Amount_6,0),
			  dbo.GetFormatString(TP.AOPD_Amount_7,0),
			  dbo.GetFormatString(TP.AOPD_Amount_8,0),
			  dbo.GetFormatString(TP.AOPD_Amount_9,0),
			  dbo.GetFormatString(TP.AOPD_Amount_10,0),
			  dbo.GetFormatString(TP.AOPD_Amount_11,0),
			  dbo.GetFormatString(TP.AOPD_Amount_12,0),
			  dbo.GetFormatString(TP.AOPD_Amount_Y,0),
			  '' AS RmkBody,
			  NULL RefD_H
			  FROM V_AOPDealer_Temp TP
			  WHERE  TP.AOPD_Contract_ID=@LastContractId
			  ) TAB
			END
		END
		ELSE
		BEGIN
			PRINT 'AmendmentUnit'
			
			--数量指标
			--医院指标汇总
			exec dbo.Pro_DCMS_QueryHospitalUnitAopTemp @ContractId,null,null ,'1',0,8000;
			exec dbo.Pro_DCMS_QueryHospitalUnitAopTemp @ContractId,null,null ,'2',0,8000;
			--经销商指标
			SELECT TOTB.* ,row_number () OVER (ORDER BY TOTB.Year,TOTB.AOPType  DESC) AS [row_number]
			FROM (
			SELECT dealer.AOPD_Contract_ID,dealer.AOPD_Dealer_DMA_ID AS Dealer_DMA_ID,dealer.AOPD_ProductLine_BUM_ID AS ProductLine_BUM_ID,
			dealer.AOPD_Year AS Year,--指标年份
			dbo.GetFormatString((dealer.AOPD_Amount_1+dealer.AOPD_Amount_2+dealer.AOPD_Amount_3),0) as Q1,
			dbo.GetFormatString((dealer.AOPD_Amount_4+dealer.AOPD_Amount_5+dealer.AOPD_Amount_6),0) as Q2,
			dbo.GetFormatString((dealer.AOPD_Amount_7+dealer.AOPD_Amount_8+dealer.AOPD_Amount_9),0) as Q3,
			dbo.GetFormatString((dealer.AOPD_Amount_10+dealer.AOPD_Amount_11+dealer.AOPD_Amount_12),0) as Q4,
			dbo.GetFormatString(dealer.AOPD_Amount_1,0) AS Amount_1,--1月指标
			dbo.GetFormatString(dealer.AOPD_Amount_2,0) as Amount_2,--2月指标
			dbo.GetFormatString(dealer.AOPD_Amount_3,0) as Amount_3,--3月指标
			dbo.GetFormatString(dealer.AOPD_Amount_4,0) as Amount_4 ,dbo.GetFormatString(dealer.AOPD_Amount_5,0) as Amount_5,dbo.GetFormatString(dealer.AOPD_Amount_6,0) as Amount_6,
			dbo.GetFormatString(dealer.AOPD_Amount_7,0) as Amount_7,dbo.GetFormatString(dealer.AOPD_Amount_8,0) as Amount_8,dbo.GetFormatString(dealer.AOPD_Amount_9,0) as Amount_9,
			dbo.GetFormatString(dealer.AOPD_Amount_10,0) as Amount_10,dbo.GetFormatString(dealer.AOPD_Amount_11,0) as Amount_11,dbo.GetFormatString(dealer.AOPD_Amount_12,0) as Amount_12,dbo.GetFormatString(dealer.AOPD_Amount_Y,0) as Amount_Y,
			(CASE  WHEN  (ISNULL(RefAmount1+RefAmount2+RefAmount3+RefAmount4+RefAmount5+RefAmount6+RefAmount7+RefAmount8+RefAmount9+RefAmount10+RefAmount11+RefAmount12,0)=0)  THEN ''
			ELSE CASE WHEN (ROUND((dealer.AOPD_Amount_Y-(RefAmount1+RefAmount2+RefAmount3+RefAmount4+RefAmount5+RefAmount6+RefAmount7+RefAmount8+RefAmount9+RefAmount10+RefAmount11+RefAmount12)),4)/ROUND(RefAmount1+RefAmount2+RefAmount3+RefAmount4+RefAmount5+RefAmount6+RefAmount7+RefAmount8+RefAmount9+RefAmount10+RefAmount11+RefAmount12,4) >0.1) OR (ROUND(dealer.AOPD_Amount_Y-(RefAmount1+RefAmount2+RefAmount3+RefAmount4+RefAmount5+RefAmount6+RefAmount7+RefAmount8+RefAmount9+RefAmount10+RefAmount11+RefAmount12),4)  < 0 )
			THEN CASE WHEN EXISTS(SELECT 1 FROM INTERFACE.ClassificationContract WHERE CC_ID=dealer.AOPD_CC_ID 
			AND ISNULL(CC_RV2,'')='1') THEN '1' ELSE '0' END
			ELSE '0' END END) AS RefD_H

			,'经销商采购指标(修改后)' as AOPType
			FROM  V_AOPDealer_Temp dealer
			LEFT JOIN (
			SELECT AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year ,
			SUM (RefAmount1) AS RefAmount1, SUM (RefAmount2) AS RefAmount2, SUM (RefAmount3) AS RefAmount3,
			SUM (RefAmount4) AS RefAmount4, SUM (RefAmount5) AS RefAmount5, SUM (RefAmount6) AS RefAmount6,
			SUM (RefAmount7) AS RefAmount7, SUM (RefAmount8) AS RefAmount8, SUM (RefAmount9) AS RefAmount9,
			SUM (RefAmount10) AS RefAmount10, SUM (RefAmount11) AS RefAmount11, SUM (RefAmount12) AS RefAmount12
			FROM (
			SELECT hos.AOPDH_Contract_ID,hos.AOPDH_Dealer_DMA_ID,hos.AOPDH_ProductLine_BUM_ID,hos.AOPDH_Year,
			hos.AOPDH_Amount_1 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'01') AS RefAmount1,
			hos.AOPDH_Amount_2*DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'02') AS RefAmount2,
			hos.AOPDH_Amount_3 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'03') AS RefAmount3,
			hos.AOPDH_Amount_4 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'04') AS RefAmount4,
			hos.AOPDH_Amount_5 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'05') AS RefAmount5,
			hos.AOPDH_Amount_6 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'06') AS RefAmount6,
			hos.AOPDH_Amount_7 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'07') AS RefAmount7,
			hos.AOPDH_Amount_8 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'08') AS RefAmount8,
			hos.AOPDH_Amount_9 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'09') AS RefAmount9,
			hos.AOPDH_Amount_10 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'10') AS RefAmount10,
			hos.AOPDH_Amount_11 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'11') AS RefAmount11,
			hos.AOPDH_Amount_12 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'12') AS RefAmount12
			FROM V_AOPDealerHospital_Temp hos
			WHERE hos.AOPDH_Contract_ID = @ContractId
			
			) S

			GROUP BY S.AOPDH_Contract_ID,S.AOPDH_Dealer_DMA_ID,S.AOPDH_ProductLine_BUM_ID,S.AOPDH_Year) tab
			on tab.AOPDH_Contract_ID=dealer.AOPD_Contract_ID and tab.AOPDH_ProductLine_BUM_ID=dealer.AOPD_ProductLine_BUM_ID
			and tab.AOPDH_Dealer_DMA_ID=dealer.AOPD_Dealer_DMA_ID and tab.AOPDH_Year=dealer.AOPD_Year
			WHERE  dealer.AOPD_Contract_ID = @ContractId 
			UNION

			SELECT tab.AOPDH_Contract_ID,tab.AOPDH_Dealer_DMA_ID,tab.AOPDH_ProductLine_BUM_ID,tab.AOPDH_Year,

			dbo.GetFormatString(tab.RefAmount1+tab.RefAmount2+tab.RefAmount3,0)RefQ1,
			dbo.GetFormatString(tab.RefAmount4+tab.RefAmount5+tab.RefAmount6,0)RefQ2,
			dbo.GetFormatString(tab.RefAmount7+tab.RefAmount8+tab.RefAmount9,0)RefQ3,
			dbo.GetFormatString(tab.RefAmount10+tab.RefAmount11+tab.RefAmount12,0)RefQ4,

			dbo.GetFormatString(tab.RefAmount1,0) as RefAmount1,dbo.GetFormatString(tab.RefAmount2,0) as RefAmount2,dbo.GetFormatString(tab.RefAmount3,0) as RefAmount3,
			dbo.GetFormatString(tab.RefAmount4,0) as RefAmount4,dbo.GetFormatString(tab.RefAmount5,0) as RefAmount5,dbo.GetFormatString(tab.RefAmount6,0) as RefAmount6,
			dbo.GetFormatString(tab.RefAmount7,0) as RefAmount7,dbo.GetFormatString(tab.RefAmount8,0) as RefAmount8,dbo.GetFormatString(tab.RefAmount9,0) as RefAmount9,
			dbo.GetFormatString(tab.RefAmount10,0) as RefAmount10,dbo.GetFormatString(tab.RefAmount11,0) as RefAmount11,dbo.GetFormatString(tab.RefAmount12,0) as RefAmount12,
			dbo.GetFormatString((RefAmount1+RefAmount2+RefAmount3+RefAmount4+RefAmount5+RefAmount6+RefAmount7+RefAmount8+RefAmount9+RefAmount10+RefAmount11+RefAmount12),0) as RefAmountTotal,
			'' AS RefD_H
			,'经销商医院实际指标' as AOPType

			FROM (
			SELECT AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year ,
			SUM (RefAmount1) AS RefAmount1, SUM (RefAmount2) AS RefAmount2, SUM (RefAmount3) AS RefAmount3,
			SUM (RefAmount4) AS RefAmount4, SUM (RefAmount5) AS RefAmount5, SUM (RefAmount6) AS RefAmount6,
			SUM (RefAmount7) AS RefAmount7, SUM (RefAmount8) AS RefAmount8, SUM (RefAmount9) AS RefAmount9,
			SUM (RefAmount10) AS RefAmount10, SUM (RefAmount11) AS RefAmount11, SUM (RefAmount12) AS RefAmount12
			FROM (
			SELECT hos.AOPDH_Contract_ID,hos.AOPDH_Dealer_DMA_ID,hos.AOPDH_ProductLine_BUM_ID,hos.AOPDH_Year,
			hos.AOPDH_Amount_1 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'01') AS RefAmount1,
			hos.AOPDH_Amount_2*DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'02') AS RefAmount2,
			hos.AOPDH_Amount_3 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'03') AS RefAmount3,
			hos.AOPDH_Amount_4 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'04') AS RefAmount4,
			hos.AOPDH_Amount_5 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'05') AS RefAmount5,
			hos.AOPDH_Amount_6 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'06') AS RefAmount6,
			hos.AOPDH_Amount_7 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'07') AS RefAmount7,
			hos.AOPDH_Amount_8 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'08') AS RefAmount8,
			hos.AOPDH_Amount_9 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'09') AS RefAmount9,
			hos.AOPDH_Amount_10 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'10') AS RefAmount10,
			hos.AOPDH_Amount_11 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'11') AS RefAmount11,
			hos.AOPDH_Amount_12 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'12') AS RefAmount12
			FROM V_AOPDealerHospital_Temp hos
			WHERE hos.AOPDH_Contract_ID= @ContractId
			) S
			GROUP BY S.AOPDH_Contract_ID,S.AOPDH_Dealer_DMA_ID,S.AOPDH_ProductLine_BUM_ID,S.AOPDH_Year) tab

			UNION
			SELECT TP.AOPD_Contract_ID,
			TP.AOPD_Dealer_DMA_ID,
			TP.AOPD_ProductLine_BUM_ID,
			TP.AOPD_Year,
			dbo.GetFormatString(TP.AOPD_Amount_1+TP.AOPD_Amount_2+TP.AOPD_Amount_3,0),
			dbo.GetFormatString(TP.AOPD_Amount_4+TP.AOPD_Amount_5+TP.AOPD_Amount_6,0),
			dbo.GetFormatString(TP.AOPD_Amount_7+TP.AOPD_Amount_8+TP.AOPD_Amount_9,0),
			dbo.GetFormatString(TP.AOPD_Amount_10+TP.AOPD_Amount_11+TP.AOPD_Amount_12,0),
			dbo.GetFormatString(TP.AOPD_Amount_1,0),
			dbo.GetFormatString(TP.AOPD_Amount_2,0),
			dbo.GetFormatString(TP.AOPD_Amount_3,0),
			dbo.GetFormatString(TP.AOPD_Amount_4,0),
			dbo.GetFormatString(TP.AOPD_Amount_5,0),
			dbo.GetFormatString(TP.AOPD_Amount_6,0),
			dbo.GetFormatString(TP.AOPD_Amount_7,0),
			dbo.GetFormatString(TP.AOPD_Amount_8,0),
			dbo.GetFormatString(TP.AOPD_Amount_9,0),
			dbo.GetFormatString(TP.AOPD_Amount_10,0),
			dbo.GetFormatString(TP.AOPD_Amount_11,0),
			dbo.GetFormatString(TP.AOPD_Amount_12,0),
			dbo.GetFormatString(TP.AOPD_Amount_Y,0),
			NULL RefD_H,
			'经销商采购指标（修改前）' AS AOPType
			FROM V_AOPDealer_Temp TP
			WHERE  TP.AOPD_Contract_ID=@LastContractId

			)TOTB
		END
		
	END
	ELSE
	BEGIN
		BEGIN --获取医院实际指标与标准指标
			select ProductLineId,ProductId,ProductName,OperType,HospitalId,HospitalName,Year,RmkId,RmkBody,
				Amount1,Amount2,Amount3,Amount4,Amount5,Amount6,Amount7,Amount8,Amount9,Amount10,Amount11,Amount12,AmountY,Q1,Q2,Q3,Q4,
				RefAmount1,RefAmount2,RefAmount3,RefAmount4,RefAmount5,RefAmount6,RefAmount7,RefAmount8,RefAmount9,RefAmount10,RefAmount11,RefAmount12,RefQ1,RefQ2,RefQ3,RefQ4,RefYear,
				FromalAmount1,FromalAmount2,FromalAmount3,FromalAmount4,FromalAmount5,FromalAmount6,FromalAmount7,FromalAmount8,FromalAmount9,FromalAmount10,FromalAmount11,FromalAmount12,FromalQ1,FromalQ2,FromalQ3,FromalQ4,FromalYear,
				DiffAmount1,DiffAmount2,DiffAmount3,DiffAmount4,DiffAmount5,DiffAmount6,DiffAmount7,DiffAmount8,DiffAmount9,DiffAmount10,DiffAmount11,DiffAmount12,
				DiffAmountQ1,DiffAmountQ2,DiffAmountQ3,DiffAmountQ4,DiffAmountY,
				FormalDiffAmount1,FormalDiffAmount2,FormalDiffAmount3,FormalDiffAmount4,FormalDiffAmount5,FormalDiffAmount6,FormalDiffAmount7,
				FormalDiffAmount8,FormalDiffAmount9,FormalDiffAmount10,FormalDiffAmount11,FormalDiffAmount12,FormalDiffAmountQ1,FormalDiffAmountQ2,FormalDiffAmountQ3,FormalDiffAmountQ4,FormalDiffAmountY
			,row_number ()    OVER (ORDER BY  OperType, HospitalName, Year,ProductName ASC) AS [row_number] 
			from [dbo].[V_AOPHospitalAmountTemp]  tab
			WHERE tab.ContractId= @ContractId
		END
		IF @AOPType<>'Unit'--金额指标
		BEGIN
			PRINT 'AppointmentAmount'
			
			BEGIN --医院指标汇总
				  SELECT *
				  ,row_number ()    OVER (ORDER BY TAB.Nber ASC) AS [row_number]
				  FROM (

				  SELECT B.HOS_HospitalName AS HospitalName,B.HOS_ID AS HospitalId,A.AOPDH_Year Year,
				  SUM(A.AOPDH_Amount_1) AS Amount1,SUM(A.AOPDH_Amount_2) AS Amount2,SUM(A.AOPDH_Amount_3) AS Amount3,
				  SUM(A.AOPDH_Amount_4) AS Amount4,SUM(A.AOPDH_Amount_5) AS Amount5,SUM(A.AOPDH_Amount_6) AS Amount6,
				  SUM(A.AOPDH_Amount_7) AS Amount7,SUM(A.AOPDH_Amount_8) AS Amount8,SUM(A.AOPDH_Amount_9) AS Amount9,
				  SUM(A.AOPDH_Amount_10) AS Amount10,SUM(A.AOPDH_Amount_11) AS Amount11,SUM(A.AOPDH_Amount_12) AS Amount12,
				  SUM(A.AOPDH_Amount_Y) AS AmountY,
				  SUM((A.AOPDH_Amount_1+A.AOPDH_Amount_2+A.AOPDH_Amount_3)) Q1,
				  SUM((A.AOPDH_Amount_4+A.AOPDH_Amount_5+A.AOPDH_Amount_6)) Q2,
				  SUM((A.AOPDH_Amount_7+A.AOPDH_Amount_8+A.AOPDH_Amount_9)) Q3,
				  SUM((A.AOPDH_Amount_10+A.AOPDH_Amount_11+A.AOPDH_Amount_12)) Q4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0)) ReAmount1,SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0)) ReAmount2,SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReAmount3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) ReAmount4,SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) ReAmount5,SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReAmount6,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) ReAmount7,SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) ReAmount8,SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReAmount9,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0)) ReAmount10,SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0)) ReAmount11,SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReAmount12,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReQ1   ,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReQ2,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReQ3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReQ4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0))  ReAmountY
				  ,row_number ()    OVER (ORDER BY B.HOS_ID , A.AOPDH_Year ASC) AS Nber
				  FROM V_AOPDealerHospital_Temp A
				  INNER JOIN Hospital B ON A.AOPDH_Hospital_ID=B.HOS_ID
				  LEFT JOIN AOPHospitalReference C ON C.AOPHR_PCT_ID=A.AOPDH_PCT_ID
				  AND C.AOPHR_Hospital_ID=A.AOPDH_Hospital_ID
				  AND CONVERT(INT,C.AOPHR_Year)=CONVERT(INT,A.AOPDH_Year)
				  AND C.AOPHR_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  LEFT JOIN V_AOPDealerHospital_Temp D ON D.AOPDH_Contract_ID=@LastContractId
				  AND D.AOPDH_Hospital_ID=A.AOPDH_Hospital_ID
				  AND D.AOPDH_Year=A.AOPDH_Year
				  AND D.AOPDH_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  AND D.AOPDH_PCT_ID=A.AOPDH_PCT_ID
				  where A.AOPDH_Contract_ID= @ContractId 
					  GROUP BY B.HOS_HospitalName,B.HOS_ID,A.AOPDH_Year

				  UNION

				  SELECT '合计' AS HospitalName,NULL AS HospitalId,A.AOPDH_Year Year,
				  SUM(A.AOPDH_Amount_1) AS Amount1,SUM(A.AOPDH_Amount_2) AS Amount2,SUM(A.AOPDH_Amount_3) AS Amount3,
				  SUM(A.AOPDH_Amount_4) AS Amount4,SUM(A.AOPDH_Amount_5) AS Amount5,SUM(A.AOPDH_Amount_6) AS Amount6,
				  SUM(A.AOPDH_Amount_7) AS Amount7,SUM(A.AOPDH_Amount_8) AS Amount8,SUM(A.AOPDH_Amount_9) AS Amount9,
				  SUM(A.AOPDH_Amount_10) AS Amount10,SUM(A.AOPDH_Amount_11) AS Amount11,SUM(A.AOPDH_Amount_12) AS Amount12,
				  SUM(A.AOPDH_Amount_Y) AS AmountY,
				  SUM((A.AOPDH_Amount_1+A.AOPDH_Amount_2+A.AOPDH_Amount_3)) Q1,
				  SUM((A.AOPDH_Amount_4+A.AOPDH_Amount_5+A.AOPDH_Amount_6)) Q2,
				  SUM((A.AOPDH_Amount_7+A.AOPDH_Amount_8+A.AOPDH_Amount_9)) Q3,
				  SUM((A.AOPDH_Amount_10+A.AOPDH_Amount_11+A.AOPDH_Amount_12)) Q4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0)) ReAmount1,SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0)) ReAmount2,SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReAmount3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) ReAmount4,SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) ReAmount5,SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReAmount6,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) ReAmount7,SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) ReAmount8,SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReAmount9,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0)) ReAmount10,SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0)) ReAmount11,SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReAmount12,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReQ1   ,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReQ2,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReQ3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReQ4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0))  ReAmountY
				  ,0 AS Nber
				  FROM V_AOPDealerHospital_Temp A
				  INNER JOIN Hospital B ON A.AOPDH_Hospital_ID=B.HOS_ID
				  LEFT JOIN AOPHospitalReference C ON C.AOPHR_PCT_ID=A.AOPDH_PCT_ID
				  AND C.AOPHR_Hospital_ID=A.AOPDH_Hospital_ID
				  AND CONVERT(INT,C.AOPHR_Year)=CONVERT(INT,A.AOPDH_Year)
				  AND C.AOPHR_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  LEFT JOIN V_AOPDealerHospital_Temp D ON D.AOPDH_Contract_ID=@LastContractId
				  AND D.AOPDH_Hospital_ID=A.AOPDH_Hospital_ID
				  AND D.AOPDH_Year=A.AOPDH_Year
				  AND D.AOPDH_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  AND D.AOPDH_PCT_ID=A.AOPDH_PCT_ID
				  where A.AOPDH_Contract_ID= @ContractId 
					  GROUP BY A.AOPDH_Year
				  ) TAB
			END
		
			BEGIN --产品指标汇总
				  SELECT *
				  ,row_number ()    OVER (ORDER BY TAB.Nber ASC) AS [row_number]
				  FROM (

				  SELECT B.CQ_NameCN AS ProductName,--产品分类名称
				  B.CQ_ID AS ProductId,
				  B.CQ_Code AS ProductCode,--产品分类编号
				  A.AOPDH_Year Year,--指标年份
				  SUM(A.AOPDH_Amount_1) AS Amount1,--1月实际指标
				  SUM(A.AOPDH_Amount_2) AS Amount2,SUM(A.AOPDH_Amount_3) AS Amount3,
				  SUM(A.AOPDH_Amount_4) AS Amount4,SUM(A.AOPDH_Amount_5) AS Amount5,SUM(A.AOPDH_Amount_6) AS Amount6,
				  SUM(A.AOPDH_Amount_7) AS Amount7,SUM(A.AOPDH_Amount_8) AS Amount8,SUM(A.AOPDH_Amount_9) AS Amount9,
				  SUM(A.AOPDH_Amount_10) AS Amount10,SUM(A.AOPDH_Amount_11) AS Amount11,SUM(A.AOPDH_Amount_12) AS Amount12,
				  SUM(A.AOPDH_Amount_Y) AS AmountY,
				  SUM((A.AOPDH_Amount_1+A.AOPDH_Amount_2+A.AOPDH_Amount_3)) Q1,
				  SUM((A.AOPDH_Amount_4+A.AOPDH_Amount_5+A.AOPDH_Amount_6)) Q2,
				  SUM((A.AOPDH_Amount_7+A.AOPDH_Amount_8+A.AOPDH_Amount_9)) Q3,
				  SUM((A.AOPDH_Amount_10+A.AOPDH_Amount_11+A.AOPDH_Amount_12)) Q4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0)) ReAmount1, --1月标准/历史指标
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0)) ReAmount2,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReAmount3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) ReAmount4,SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) ReAmount5,SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReAmount6,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) ReAmount7,SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) ReAmount8,SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReAmount9,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0)) ReAmount10,SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0)) ReAmount11,SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReAmount12,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReQ1   ,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReQ2,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReQ3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReQ4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0))  ReAmountY
				  ,row_number ()    OVER (ORDER BY B.CQ_Code , A.AOPDH_Year ASC) AS Nber
				  FROM V_AOPDealerHospital_Temp A
				  INNER JOIN (SELECT DISTINCT CQ_ID,CQ_Code,CQ_NameCN FROM INTERFACE.ClassificationQuota) B ON A.AOPDH_PCT_ID=b.CQ_ID
				  LEFT JOIN AOPHospitalReference C ON C.AOPHR_PCT_ID=A.AOPDH_PCT_ID
				  AND C.AOPHR_Hospital_ID=A.AOPDH_Hospital_ID
				  AND CONVERT(INT,C.AOPHR_Year)=CONVERT(INT,A.AOPDH_Year)
				  AND C.AOPHR_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  LEFT JOIN V_AOPDealerHospital_Temp D ON D.AOPDH_Contract_ID=@LastContractId
				  AND D.AOPDH_Hospital_ID=A.AOPDH_Hospital_ID
				  AND CONVERT(INT,D.AOPDH_Year)=CONVERT(INT,A.AOPDH_Year)
				  AND D.AOPDH_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  AND D.AOPDH_PCT_ID=A.AOPDH_PCT_ID
				  where A.AOPDH_Contract_ID= @ContractId 
				  GROUP BY B.CQ_Code,B.CQ_ID,B.CQ_NameCN,A.AOPDH_Year

				  UNION
				  SELECT '合计' AS ProductName,NULL AS HospitalId,NULL,A.AOPDH_Year Year,
				  SUM(A.AOPDH_Amount_1) AS Amount1,SUM(A.AOPDH_Amount_2) AS Amount2,SUM(A.AOPDH_Amount_3) AS Amount3,
				  SUM(A.AOPDH_Amount_4) AS Amount4,SUM(A.AOPDH_Amount_5) AS Amount5,SUM(A.AOPDH_Amount_6) AS Amount6,
				  SUM(A.AOPDH_Amount_7) AS Amount7,SUM(A.AOPDH_Amount_8) AS Amount8,SUM(A.AOPDH_Amount_9) AS Amount9,
				  SUM(A.AOPDH_Amount_10) AS Amount10,SUM(A.AOPDH_Amount_11) AS Amount11,SUM(A.AOPDH_Amount_12) AS Amount12,
				  SUM(A.AOPDH_Amount_Y) AS AmountY,
				  SUM((A.AOPDH_Amount_1+A.AOPDH_Amount_2+A.AOPDH_Amount_3)) Q1,
				  SUM((A.AOPDH_Amount_4+A.AOPDH_Amount_5+A.AOPDH_Amount_6)) Q2,
				  SUM((A.AOPDH_Amount_7+A.AOPDH_Amount_8+A.AOPDH_Amount_9)) Q3,
				  SUM((A.AOPDH_Amount_10+A.AOPDH_Amount_11+A.AOPDH_Amount_12)) Q4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0)) ReAmount1,SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0)) ReAmount2,SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReAmount3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) ReAmount4,SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) ReAmount5,SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReAmount6,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) ReAmount7,SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) ReAmount8,SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReAmount9,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0)) ReAmount10,SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0)) ReAmount11,SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReAmount12,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0)) ReQ1   ,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0)) ReQ2,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0)) ReQ3,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0)) ReQ4,
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_1,AOPHR_January),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_2,AOPHR_February),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_3,AOPHR_March),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_4,AOPHR_April),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_5,AOPHR_May),0)) +SUM(ISNULL(ISNULL(D.AOPDH_Amount_6,AOPHR_June),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_7,AOPHR_July),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_8,AOPHR_August),0)) + SUM(ISNULL(ISNULL(D.AOPDH_Amount_9,AOPHR_September),0))+
				  SUM(ISNULL(ISNULL(D.AOPDH_Amount_10,AOPHR_October),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_11,AOPHR_November),0))+SUM(ISNULL(ISNULL(D.AOPDH_Amount_12,AOPHR_December),0))  ReAmountY
				  ,0 AS Nber
				  FROM V_AOPDealerHospital_Temp A
				  INNER JOIN Hospital B ON A.AOPDH_Hospital_ID=B.HOS_ID
				  LEFT JOIN AOPHospitalReference C ON C.AOPHR_PCT_ID=A.AOPDH_PCT_ID
				  AND C.AOPHR_Hospital_ID=A.AOPDH_Hospital_ID
				  AND CONVERT(INT,C.AOPHR_Year)=CONVERT(INT,A.AOPDH_Year)
				  AND C.AOPHR_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  LEFT JOIN V_AOPDealerHospital_Temp D ON D.AOPDH_Contract_ID=@LastContractId
				  AND D.AOPDH_Hospital_ID=A.AOPDH_Hospital_ID
				  AND D.AOPDH_Year=A.AOPDH_Year
				  AND D.AOPDH_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
				  AND D.AOPDH_PCT_ID=A.AOPDH_PCT_ID
				  WHERE A.AOPDH_Contract_ID= @ContractId
				  GROUP BY A.AOPDH_Year
				  ) TAB
			END
			
			BEGIN --经销商指标
			  SELECT TOTB.* ,row_number () OVER (ORDER BY TOTB.AOPD_Year,TOTB.AOPType  DESC) AS [row_number]
			  FROM (
			  SELECT dealer.AOPD_Contract_ID,dealer.AOPD_Dealer_DMA_ID,dealer.AOPD_ProductLine_BUM_ID,dealer.AOPD_Year,
			  dbo.GetFormatString((dealer.AOPD_Amount_1+dealer.AOPD_Amount_2+dealer.AOPD_Amount_3),0) as Q1,
			  dbo.GetFormatString((dealer.AOPD_Amount_4+dealer.AOPD_Amount_5+dealer.AOPD_Amount_6),0) as Q2,
			  dbo.GetFormatString((dealer.AOPD_Amount_7+dealer.AOPD_Amount_8+dealer.AOPD_Amount_9),0) as Q3,
			  dbo.GetFormatString((dealer.AOPD_Amount_10+dealer.AOPD_Amount_11+dealer.AOPD_Amount_12),0) as Q4,
			  dbo.GetFormatString(dealer.AOPD_Amount_1,0) AS AOPD_Amount_1,dbo.GetFormatString(dealer.AOPD_Amount_2,0) as AOPD_Amount_2,dbo.GetFormatString(dealer.AOPD_Amount_3,0) as AOPD_Amount_3,
			  dbo.GetFormatString(dealer.AOPD_Amount_4,0) as AOPD_Amount_4 ,dbo.GetFormatString(dealer.AOPD_Amount_5,0) as AOPD_Amount_5,dbo.GetFormatString(dealer.AOPD_Amount_6,0) as AOPD_Amount_6,
			  dbo.GetFormatString(dealer.AOPD_Amount_7,0) as AOPD_Amount_7,dbo.GetFormatString(dealer.AOPD_Amount_8,0) as AOPD_Amount_8,dbo.GetFormatString(dealer.AOPD_Amount_9,0) as AOPD_Amount_9,
			  dbo.GetFormatString(dealer.AOPD_Amount_10,0) as AOPD_Amount_10,dbo.GetFormatString(dealer.AOPD_Amount_11,0) as AOPD_Amount_11,dbo.GetFormatString(dealer.AOPD_Amount_12,0) as AOPD_Amount_12,dbo.GetFormatString(dealer.AOPD_Amount_Y,0) as AOPD_Amount_Y,

			  (CASE  WHEN  ISNULL(tab.AOPDH_Amount_Y,0)=0  THEN ''
			  ELSE CASE WHEN ((ROUND(dealer.AOPD_Amount_Y-tab.AOPDH_Amount_Y,4))/tab.AOPDH_Amount_Y >0.1) OR (ROUND(dealer.AOPD_Amount_Y-tab.AOPDH_Amount_Y,4)   < 0)
			  THEN CASE WHEN EXISTS(SELECT 1 FROM INTERFACE.ClassificationContract WHERE CC_ID=dealer.AOPD_CC_ID AND ISNULL(CC_RV2,'')='1') THEN '1' ELSE '0' END
			  ELSE '0' END END) AS RefD_H
			  ,'经销商商业采购指标' as AOPType
			  FROM  V_AOPDealer_Temp dealer
			  LEFT JOIN (SELECT AOPDH_Contract_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Dealer_DMA_ID,AOPDH_Year,SUM(AOPDH_Amount_Y) AS AOPDH_Amount_Y FROM  V_AOPDealerHospital_Temp WHERE AOPDH_Contract_ID=@ContractId  GROUP BY AOPDH_Contract_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Dealer_DMA_ID,AOPDH_Year  )tab
			  on tab.AOPDH_Contract_ID=dealer.AOPD_Contract_ID and tab.AOPDH_ProductLine_BUM_ID=dealer.AOPD_ProductLine_BUM_ID
			  and tab.AOPDH_Dealer_DMA_ID=dealer.AOPD_Dealer_DMA_ID and tab.AOPDH_Year=dealer.AOPD_Year
			  UNION
			  SELECT tab.AOPDH_Contract_ID,tab.AOPDH_Dealer_DMA_ID,tab.AOPDH_ProductLine_BUM_ID,tab.AOPDH_Year,
			  dbo.GetFormatString(SUM(tab.AOPDH_Amount_1+tab.AOPDH_Amount_2+tab.AOPDH_Amount_3),0) RefQ1,
			  dbo.GetFormatString(SUM(tab.AOPDH_Amount_4+tab.AOPDH_Amount_5+tab.AOPDH_Amount_6),0) RefQ2,
			  dbo.GetFormatString(SUM(tab.AOPDH_Amount_7+tab.AOPDH_Amount_8+tab.AOPDH_Amount_9),0) RefQ3,
			  dbo.GetFormatString(SUM(tab.AOPDH_Amount_10+tab.AOPDH_Amount_11+tab.AOPDH_Amount_12),0) RefQ4,
			  dbo.GetFormatString(SUM(tab.AOPDH_Amount_1),0) as RefAmount1,dbo.GetFormatString(SUM(tab.AOPDH_Amount_2),0) as RefAmount2,dbo.GetFormatString(SUM(tab.AOPDH_Amount_3),0) as RefAmount3,
			  dbo.GetFormatString(SUM(tab.AOPDH_Amount_4),0) as RefAmount4,dbo.GetFormatString(SUM(tab.AOPDH_Amount_5),0) as RefAmount5,dbo.GetFormatString(SUM(tab.AOPDH_Amount_6),0) as RefAmount6,
			  dbo.GetFormatString(SUM(tab.AOPDH_Amount_7),0) as RefAmount7,dbo.GetFormatString(SUM(tab.AOPDH_Amount_8),0) as RefAmount8,dbo.GetFormatString(SUM(tab.AOPDH_Amount_9),0) as RefAmount9,
			  dbo.GetFormatString(SUM(tab.AOPDH_Amount_10),0) as RefAmount10,dbo.GetFormatString(SUM(tab.AOPDH_Amount_11),0) as RefAmount11,dbo.GetFormatString(SUM(tab.AOPDH_Amount_12),0) as RefAmount12,
			  dbo.GetFormatString(SUM(tab.AOPDH_Amount_Y),0) as RefAmountTotal,
			  '' AS RefD_H
			  ,'经销商医院实际指标' as AOPType
			  FROM V_AOPDealerHospital_Temp tab
			  GROUP BY tab.AOPDH_Contract_ID,tab.AOPDH_Dealer_DMA_ID,tab.AOPDH_ProductLine_BUM_ID,tab.AOPDH_Year
			  )TOTB
			  WHERE TOTB.AOPD_Contract_ID=@ContractId
			END
		END
		ELSE
		BEGIN
			PRINT 'AppointmentUnit'
			
			--数量指标
			--医院指标汇总
			exec dbo.Pro_DCMS_QueryHospitalUnitAopTemp @ContractId,null,null ,'1',0,8000
			exec dbo.Pro_DCMS_QueryHospitalUnitAopTemp @ContractId,null,null ,'2',0,8000
			
			--经销商指标
			SELECT TOTB.* ,row_number () OVER (ORDER BY TOTB.AOPD_Year,TOTB.AOPType  DESC) AS [row_number]
			 FROM (
			  SELECT dealer.AOPD_Contract_ID,dealer.AOPD_Dealer_DMA_ID,dealer.AOPD_ProductLine_BUM_ID,dealer.AOPD_Year,
			  dbo.GetFormatString((dealer.AOPD_Amount_1+dealer.AOPD_Amount_2+dealer.AOPD_Amount_3),0) as Q1,
			  dbo.GetFormatString((dealer.AOPD_Amount_4+dealer.AOPD_Amount_5+dealer.AOPD_Amount_6),0) as Q2,
			  dbo.GetFormatString((dealer.AOPD_Amount_7+dealer.AOPD_Amount_8+dealer.AOPD_Amount_9),0) as Q3,
			  dbo.GetFormatString((dealer.AOPD_Amount_10+dealer.AOPD_Amount_11+dealer.AOPD_Amount_12),0) as Q4,
			  dbo.GetFormatString(dealer.AOPD_Amount_1,0) AS AOPD_Amount_1,dbo.GetFormatString(dealer.AOPD_Amount_2,0) as AOPD_Amount_2,dbo.GetFormatString(dealer.AOPD_Amount_3,0) as AOPD_Amount_3,
			  dbo.GetFormatString(dealer.AOPD_Amount_4,0) as AOPD_Amount_4 ,dbo.GetFormatString(dealer.AOPD_Amount_5,0) as AOPD_Amount_5,dbo.GetFormatString(dealer.AOPD_Amount_6,0) as AOPD_Amount_6,
			  dbo.GetFormatString(dealer.AOPD_Amount_7,0) as AOPD_Amount_7,dbo.GetFormatString(dealer.AOPD_Amount_8,0) as AOPD_Amount_8,dbo.GetFormatString(dealer.AOPD_Amount_9,0) as AOPD_Amount_9,
			  dbo.GetFormatString(dealer.AOPD_Amount_10,0) as AOPD_Amount_10,dbo.GetFormatString(dealer.AOPD_Amount_11,0) as AOPD_Amount_11,dbo.GetFormatString(dealer.AOPD_Amount_12,0) as AOPD_Amount_12,dbo.GetFormatString(dealer.AOPD_Amount_Y,0) as AOPD_Amount_Y,
			  (CASE  WHEN  (ISNULL(RefAmount1+RefAmount2+RefAmount3+RefAmount4+RefAmount5+RefAmount6+RefAmount7+RefAmount8+RefAmount9+RefAmount10+RefAmount11+RefAmount12,0)=0)  THEN ''
			  ELSE CASE WHEN (ROUND((dealer.AOPD_Amount_Y-(RefAmount1+RefAmount2+RefAmount3+RefAmount4+RefAmount5+RefAmount6+RefAmount7+RefAmount8+RefAmount9+RefAmount10+RefAmount11+RefAmount12)),4)/ROUND(RefAmount1+RefAmount2+RefAmount3+RefAmount4+RefAmount5+RefAmount6+RefAmount7+RefAmount8+RefAmount9+RefAmount10+RefAmount11+RefAmount12,4) >0.1) OR (ROUND(dealer.AOPD_Amount_Y-(RefAmount1+RefAmount2+RefAmount3+RefAmount4+RefAmount5+RefAmount6+RefAmount7+RefAmount8+RefAmount9+RefAmount10+RefAmount11+RefAmount12),4)  < 0 )
			  THEN
			  CASE WHEN EXISTS(SELECT 1 FROM INTERFACE.ClassificationContract WHERE CC_ID=dealer.AOPD_CC_ID AND ISNULL(CC_RV2,'')='1') THEN '1' ELSE '0' END

			  ELSE '0' END END) AS RefD_H

			  ,'经销商商业采购指标' as AOPType
			  FROM  V_AOPDealer_Temp dealer
			  LEFT JOIN (
			  SELECT AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year ,
			  SUM (RefAmount1) AS RefAmount1, SUM (RefAmount2) AS RefAmount2, SUM (RefAmount3) AS RefAmount3,
			  SUM (RefAmount4) AS RefAmount4, SUM (RefAmount5) AS RefAmount5, SUM (RefAmount6) AS RefAmount6,
			  SUM (RefAmount7) AS RefAmount7, SUM (RefAmount8) AS RefAmount8, SUM (RefAmount9) AS RefAmount9,
			  SUM (RefAmount10) AS RefAmount10, SUM (RefAmount11) AS RefAmount11, SUM (RefAmount12) AS RefAmount12
			  FROM (
			  SELECT hos.AOPDH_Contract_ID,hos.AOPDH_Dealer_DMA_ID,hos.AOPDH_ProductLine_BUM_ID,hos.AOPDH_Year,
			  hos.AOPDH_Amount_1 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'01') AS RefAmount1,
			  hos.AOPDH_Amount_2*DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'02') AS RefAmount2,
			  hos.AOPDH_Amount_3 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'03') AS RefAmount3,
			  hos.AOPDH_Amount_4 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'04') AS RefAmount4,
			  hos.AOPDH_Amount_5 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'05') AS RefAmount5,
			  hos.AOPDH_Amount_6 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'06') AS RefAmount6,
			  hos.AOPDH_Amount_7 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'07') AS RefAmount7,
			  hos.AOPDH_Amount_8 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'08') AS RefAmount8,
			  hos.AOPDH_Amount_9 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'09') AS RefAmount9,
			  hos.AOPDH_Amount_10 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'10') AS RefAmount10,
			  hos.AOPDH_Amount_11 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'11') AS RefAmount11,
			  hos.AOPDH_Amount_12 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'12') AS RefAmount12
			  FROM V_AOPDealerHospital_Temp hos
				where hos.AOPDH_Contract_ID = @ContractId 
			  ) S

			  GROUP BY S.AOPDH_Contract_ID,S.AOPDH_Dealer_DMA_ID,S.AOPDH_ProductLine_BUM_ID,S.AOPDH_Year) tab
			  on tab.AOPDH_Contract_ID=dealer.AOPD_Contract_ID and tab.AOPDH_ProductLine_BUM_ID=dealer.AOPD_ProductLine_BUM_ID
			  and tab.AOPDH_Dealer_DMA_ID=dealer.AOPD_Dealer_DMA_ID and tab.AOPDH_Year=dealer.AOPD_Year
				WHERE dealer.AOPD_Contract_ID = @ContractId 
		   


			  UNION

			  SELECT tab.AOPDH_Contract_ID,tab.AOPDH_Dealer_DMA_ID,tab.AOPDH_ProductLine_BUM_ID,tab.AOPDH_Year,

			  dbo.GetFormatString(tab.RefAmount1+tab.RefAmount2+tab.RefAmount3,0)RefQ1,
			  dbo.GetFormatString(tab.RefAmount4+tab.RefAmount5+tab.RefAmount6,0)RefQ2,
			  dbo.GetFormatString(tab.RefAmount7+tab.RefAmount8+tab.RefAmount9,0)RefQ3,
			  dbo.GetFormatString(tab.RefAmount10+tab.RefAmount11+tab.RefAmount12,0)RefQ4,

			  dbo.GetFormatString(tab.RefAmount1,0) as RefAmount1,dbo.GetFormatString(tab.RefAmount2,0) as RefAmount2,dbo.GetFormatString(tab.RefAmount3,0) as RefAmount3,
			  dbo.GetFormatString(tab.RefAmount4,0) as RefAmount4,dbo.GetFormatString(tab.RefAmount5,0) as RefAmount5,dbo.GetFormatString(tab.RefAmount6,0) as RefAmount6,
			  dbo.GetFormatString(tab.RefAmount7,0) as RefAmount7,dbo.GetFormatString(tab.RefAmount8,0) as RefAmount8,dbo.GetFormatString(tab.RefAmount9,0) as RefAmount9,
			  dbo.GetFormatString(tab.RefAmount10,0) as RefAmount10,dbo.GetFormatString(tab.RefAmount11,0) as RefAmount11,dbo.GetFormatString(tab.RefAmount12,0) as RefAmount12,
			  dbo.GetFormatString((RefAmount1+RefAmount2+RefAmount3+RefAmount4+RefAmount5+RefAmount6+RefAmount7+RefAmount8+RefAmount9+RefAmount10+RefAmount11+RefAmount12),0) as RefAmountTotal,
			  '' AS RefD_H
			  ,'经销商医院实际指标' as AOPType

			  FROM (
			  SELECT AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year ,
			  SUM (RefAmount1) AS RefAmount1, SUM (RefAmount2) AS RefAmount2, SUM (RefAmount3) AS RefAmount3,
			  SUM (RefAmount4) AS RefAmount4, SUM (RefAmount5) AS RefAmount5, SUM (RefAmount6) AS RefAmount6,
			  SUM (RefAmount7) AS RefAmount7, SUM (RefAmount8) AS RefAmount8, SUM (RefAmount9) AS RefAmount9,
			  SUM (RefAmount10) AS RefAmount10, SUM (RefAmount11) AS RefAmount11, SUM (RefAmount12) AS RefAmount12
			  FROM (
			  SELECT hos.AOPDH_Contract_ID,hos.AOPDH_Dealer_DMA_ID,hos.AOPDH_ProductLine_BUM_ID,hos.AOPDH_Year,
			  hos.AOPDH_Amount_1 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'01') AS RefAmount1,
			  hos.AOPDH_Amount_2*DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'02') AS RefAmount2,
			  hos.AOPDH_Amount_3 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'03') AS RefAmount3,
			  hos.AOPDH_Amount_4 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'04') AS RefAmount4,
			  hos.AOPDH_Amount_5 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'05') AS RefAmount5,
			  hos.AOPDH_Amount_6 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'06') AS RefAmount6,
			  hos.AOPDH_Amount_7 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'07') AS RefAmount7,
			  hos.AOPDH_Amount_8 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'08') AS RefAmount8,
			  hos.AOPDH_Amount_9 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'09') AS RefAmount9,
			  hos.AOPDH_Amount_10 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'10') AS RefAmount10,
			  hos.AOPDH_Amount_11 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'11') AS RefAmount11,
			  hos.AOPDH_Amount_12 *DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,'12') AS RefAmount12
			  FROM V_AOPDealerHospital_Temp hos
			  WHERE hos.AOPDH_Contract_ID= @ContractId
			  ) S
			  GROUP BY S.AOPDH_Contract_ID,S.AOPDH_Dealer_DMA_ID,S.AOPDH_ProductLine_BUM_ID,S.AOPDH_Year) tab)TOTB
		END
		
	END
	
	

END  

GO


