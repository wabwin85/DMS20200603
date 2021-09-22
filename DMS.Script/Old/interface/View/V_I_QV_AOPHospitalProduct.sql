DROP  VIEW [interface].[V_I_QV_AOPHospitalProduct]
GO
















CREATE  VIEW [interface].[V_I_QV_AOPHospitalProduct]
AS

/*
实际指标调整-2015版本
*/
--SELECT TAB.DMA_Id,	ProductLineId,	ProductLineName,	DivisionCode,	DivisionName,CC_Code,CC_NameCN,	PCTId,	PCTCode,	PCTName,	Year,	HospitalId,	HospitalCode,	HOS_HospitalName,	AOPType,	Month1,	Month2,	Month3,	Month4,	Month5,	Month6,	Month7,	Month8,	Month9,	Month10,	Month11,	Month12,	Price FROM (
--SELECT RE.AOPICH_DMA_ID AS DMA_Id
--      ,RE.AOPICH_ProductLine_ID AS ProductLineId
--      ,DPR.ProductLineName AS ProductLineName
--      ,DPR.DivisionCode AS DivisionCode
--      ,DPR.DivisionName AS DivisionName
--      ,RE.AOPICH_PCT_ID AS PCTId
--      ,PC.CQ_Code		AS PCTCode
--      ,PC.CQ_NameCN AS PCTName
--      ,RE.AOPICH_Year AS [Year]
--      ,RE.AOPICH_Hospital_ID AS HospitalId
--      ,HOS.HOS_Key_Account AS HospitalCode
--      ,HOS.HOS_HospitalName
--      ,'Unit' AOPType
--      ,RE.AOPICH_Unit_1 AS Month1
--      ,RE.AOPICH_Unit_2 AS Month2
--      ,RE.AOPICH_Unit_3 AS Month3
--      ,RE.AOPICH_Unit_4 AS Month4
--      ,RE.AOPICH_Unit_5 AS Month5
--      ,RE.AOPICH_Unit_6 AS Month6
--      ,RE.AOPICH_Unit_7 AS Month7
--      ,RE.AOPICH_Unit_8 AS Month8
--      ,RE.AOPICH_Unit_9 AS Month9
--      ,RE.AOPICH_Unit_10 AS Month10
--      ,RE.AOPICH_Unit_11 AS Month11
--      ,RE.AOPICH_Unit_12 AS Month12
--      ,QP.CP_Price AS Price 
--  FROM V_AOPICDealerHospital RE
--  inner JOIN ( select distinct CQ_ID, CQ_Code,CQ_NameCN from interface.ClassificationQuotaMain ) PC ON  RE.AOPICH_PCT_ID=PC.CQ_ID
--  inner JOIN V_DivisionProductLineRelation DPR ON DP,R.ProductLineID=RE.AOPICH_ProductLine_ID AND DPR.IsEmerging='0'
--  inner JOIN Hospital HOS ON HOS.HOS_ID=RE.AOPICH_Hospital_ID AND HOS.HOS_ActiveFlag='1'
--  inner JOIN AOPHospitalProductMapping mp on mp.AOPHPM_Dma_id=re.AOPICH_DMA_ID and mp.AOPHPM_Hos_Id=re.AOPICH_Hospital_ID and mp.AOPHPM_PCT_ID=re.AOPICH_PCT_ID AND mp.AOPHPM_ActiveFlag=1
--  inner JOIN interface.T_I_EW_Contract con on con.InstanceID=mp.AOPHPM_ContractId and con.Division=DPR.DivisionName
--  inner JOIN INTERFACE.ClassificationQuotaPrice QP ON QP.CP_ID=MP.AOPHPM_PCP_ID and QP.CP_Year=re.AOPICH_Year
--  UNION
--  SELECT RE.AOPDH_Dealer_DMA_ID
--      ,RE.AOPDH_ProductLine_BUM_ID
--      ,DPR.ProductLineName AS ProductLineName
--      ,DPR.DivisionCode AS DivisionCode
--      ,DPR.DivisionName AS DivisionName
--      ,RE.AOPDH_PCT_ID AS PCTId
--      ,CQ.CQ_Code 
--      ,CQ.CQ_NameCN AS PCTName
--      ,RE.AOPDH_Year
--      ,RE.AOPDH_Hospital_ID
--      ,HOS.HOS_Key_Account AS HospitalCode
--      ,HOS.HOS_HospitalName
--      ,'Amount' AOPType
--      ,RE.AOPDH_Amount_1
--      ,RE.AOPDH_Amount_2
--      ,RE.AOPDH_Amount_3
--      ,RE.AOPDH_Amount_4
--      ,RE.AOPDH_Amount_5
--      ,RE.AOPDH_Amount_6
--      ,RE.AOPDH_Amount_7
--      ,RE.AOPDH_Amount_8
--      ,RE.AOPDH_Amount_9
--      ,RE.AOPDH_Amount_10
--      ,RE.AOPDH_Amount_11
--      ,RE.AOPDH_Amount_12
--      ,''
--  FROM V_AOPDealerHospital RE
--  LEFT JOIN (select distinct CQ_ID ,PC.CQ_Code,PC.CQ_NameCN from  interface.ClassificationQuotaMain) CQ ON CQ.CQ_ID=RE.AOPDH_PCT_ID 
--  LEFT JOIN V_DivisionProductLineRelation DPR ON DPR.ProductLineID=RE.AOPDH_ProductLine_BUM_ID AND DPR.IsEmerging='0'
--  LEFT JOIN Hospital HOS ON HOS.HOS_ID=RE.AOPDH_Hospital_ID AND HOS.HOS_ActiveFlag='1')
--  TAB
--  INNER JOIN (SELECT DISTINCT CC_ProductLineID,CC_ID,CC_Code,CC_NameCN,CQ_ID,CQ_Code FROM interface.V_I_QV_ProductClassificationStructure) PCS ON PCS.CQ_ID=TAB.PCTId AND TAB.ProductLineId=PCS.CC_ProductLineID
--  INNER JOIN V_DealerContractMaster DCM ON DCM.CC_ID=PCS.CC_ID AND DCM.DMA_ID=TAB.DMA_Id AND TAB.DivisionCode=CONVERT(NVARCHAR(10), DCM.Division)


/*
实际指标调整-2016版本
*/

--SELECT a.DMA_Id
--	,ProductLineId
--	,CAST(ProductLineName AS NVARCHAR(50)) ProductLineName
--	,DivisionCode
--	,DivisionName
--	,CC_Code
--	,CAST(CC_NameCN AS NVARCHAR(50)) CC_NameCN
--	,PCTId
--	,PCTCode
--	,CAST(PCTName AS NVARCHAR(50)) PCTName
--	,Year
--	,HospitalId
--	,HospitalCode
--	,HOS_HospitalName
--	,AOPType
--	,Month1
--	,Month2
--	,Month3
--	,Month4
--	,Month5
--	,Month6
--	,Month7
--	,Month8
--	,Month9
--	,Month10
--	,Month11
--	,Month12
--	,Price
--	,dma.DMA_SAP_Code as SAPID
--FROM (
--	SELECT TAB.DMA_Id
--		,TAB.ProductLineId
--		,TAB.ProductLineName
--		,TAB.DivisionCode
--		,TAB.DivisionName
--		,CC_Code
--		,CC_NameCN
--		,PCTId
--		,PCTCode
--		,PCTName
--		,Year
--		,HospitalId
--		,HospitalCode
--		,HOS_HospitalName
--		,AOPType
--		,Month1
--		,Month2
--		,Month3
--		,Month4
--		,Month5
--		,Month6
--		,Month7
--		,Month8
--		,Month9
--		,Month10
--		,Month11
--		,Month12
--		,Price
--	FROM (
--		SELECT RE.AOPICH_DMA_ID AS DMA_Id
--			,RE.AOPICH_ProductLine_ID AS ProductLineId
--			,CAST(DPR.ProductLineName AS NVARCHAR(200)) AS ProductLineName
--			,DPR.DivisionCode AS DivisionCode
--			,DPR.DivisionName AS DivisionName
--			,RE.AOPICH_PCT_ID AS PCTId
--			,PC.CQ_Code AS PCTCode
--			,CAST(PC.CQ_NameCN AS NVARCHAR(200)) AS PCTName
--			,RE.AOPICH_Year AS [Year]
--			,RE.AOPICH_Hospital_ID AS HospitalId
--			,HOS.HOS_Key_Account AS HospitalCode
--			,HOS.HOS_HospitalName
--			,'Unit' AOPType
--			,RE.AOPICH_Unit_1 AS Month1
--			,RE.AOPICH_Unit_2 AS Month2
--			,RE.AOPICH_Unit_3 AS Month3
--			,RE.AOPICH_Unit_4 AS Month4
--			,RE.AOPICH_Unit_5 AS Month5
--			,RE.AOPICH_Unit_6 AS Month6
--			,RE.AOPICH_Unit_7 AS Month7
--			,RE.AOPICH_Unit_8 AS Month8
--			,RE.AOPICH_Unit_9 AS Month9
--			,RE.AOPICH_Unit_10 AS Month10
--			,RE.AOPICH_Unit_11 AS Month11
--			,RE.AOPICH_Unit_12 AS Month12
--			,QP.CP_Price AS Price
--		FROM V_AOPICDealerHospital RE
--		INNER JOIN (
--			SELECT DISTINCT CQ_ID
--				,CQ_Code
--				,CQ_NameCN
--			FROM interface.ClassificationQuotaMain
--			) PC ON RE.AOPICH_PCT_ID = PC.CQ_ID
--		INNER JOIN V_DivisionProductLineRelation DPR ON DPR.ProductLineID = RE.AOPICH_ProductLine_ID AND DPR.IsEmerging = '0'
--		INNER JOIN Hospital HOS ON HOS.HOS_ID = RE.AOPICH_Hospital_ID AND HOS.HOS_ActiveFlag = '1'
--		INNER JOIN AOPHospitalProductMapping mp ON mp.AOPHPM_Dma_id = re.AOPICH_DMA_ID AND mp.AOPHPM_Hos_Id = re.AOPICH_Hospital_ID AND mp.AOPHPM_PCT_ID = re.AOPICH_PCT_ID AND mp.AOPHPM_ActiveFlag = 1
--		INNER JOIN interface.T_I_EW_Contract con ON con.InstanceID = mp.AOPHPM_ContractId AND con.Division = DPR.DivisionName
--		INNER JOIN INTERFACE.ClassificationQuotaPrice QP ON QP.CP_ID = MP.AOPHPM_PCP_ID
--		WHERE RE.AOPICH_Year = year(getdate())
		
--		UNION
		
--		SELECT RE.AOPDH_Dealer_DMA_ID
--			,RE.AOPDH_ProductLine_BUM_ID
--			,DPR.ProductLineName AS ProductLineName
--			,DPR.DivisionCode AS DivisionCode
--			,DPR.DivisionName AS DivisionName
--			,RE.AOPDH_PCT_ID AS PCTId
--			,CQ.CQ_Code
--			,CQ.CQ_NameCN AS PCTName
--			,RE.AOPDH_Year
--			,RE.AOPDH_Hospital_ID
--			,HOS.HOS_Key_Account AS HospitalCode
--			,HOS.HOS_HospitalName
--			,'Amount' AOPType
--			,RE.AOPDH_Amount_1
--			,RE.AOPDH_Amount_2
--			,RE.AOPDH_Amount_3
--			,RE.AOPDH_Amount_4
--			,RE.AOPDH_Amount_5
--			,RE.AOPDH_Amount_6
--			,RE.AOPDH_Amount_7
--			,RE.AOPDH_Amount_8
--			,RE.AOPDH_Amount_9
--			,RE.AOPDH_Amount_10
--			,RE.AOPDH_Amount_11
--			,RE.AOPDH_Amount_12
--			,''
--		FROM V_AOPDealerHospital RE
--		LEFT JOIN (
--			SELECT DISTINCT CQ_ID
--				,CQ_Code
--				,CQ_NameCN
--			FROM interface.ClassificationQuotaMain(NOLOCK)
--			) CQ ON CQ.CQ_ID = RE.AOPDH_PCT_ID
--		LEFT JOIN V_DivisionProductLineRelation DPR ON DPR.ProductLineID = RE.AOPDH_ProductLine_BUM_ID AND DPR.IsEmerging = '0'
--		LEFT JOIN Hospital HOS(NOLOCK) ON HOS.HOS_ID = RE.AOPDH_Hospital_ID AND HOS.HOS_ActiveFlag = '1'
--		WHERE RE.AOPDH_Year = YEAR(GETDATE())
--		) TAB
--	INNER JOIN (
--		SELECT DISTINCT CC_ProductLineID
--			,CC_ID
--			,CC_Code
--			,CC_NameCN
--			,CQ_ID
--			,CQ_Code
--		FROM interface.V_I_QV_ProductClassificationStructure
--		) PCS ON PCS.CQ_ID = TAB.PCTId AND TAB.ProductLineId = PCS.CC_ProductLineID
--	INNER JOIN V_DealerContractMaster DCM ON DCM.CC_ID = PCS.CC_ID AND DCM.DMA_ID = TAB.DMA_Id AND TAB.DivisionCode = CONVERT(NVARCHAR(10), DCM.Division)
--	--INNER JOIN V_AllHospitalMarketProperty b ON ((isnull(dcm.MarketType, 0) = 2) OR (isnull(dcm.MarketType, 0) <> 2 AND dcm.MarketType = b.MarketProperty)) AND b.DivisionCode = CONVERT(NVARCHAR(10), dcm.Division) AND b.Hos_Id = tab.HospitalId
--	INNER JOIN interface.Stage_V_AllHospitalMarketProperty b ON ((isnull(dcm.MarketType, 0) = 2) OR (isnull(dcm.MarketType, 0) <> 2 AND dcm.MarketType = b.MarketProperty)) AND b.DivisionCode = CONVERT(NVARCHAR(10), dcm.Division) AND b.Hos_Id = tab.HospitalId
--	WHERE ((CC_Code = 'C1701' AND PCTCode NOT IN ('1702007', '1702008', '1702009', '1702004', '1703001', '1702005', '1703002')) OR (CC_Code <> 'C1701'))
--	and ((CC_Code = 'C3401' AND PCTCode NOT IN ('34')) OR (CC_Code <> 'C3401'))
--	) A
--	LEFT JOIN dbo.DealerMaster dma
--		on a.DMA_Id=dma.DMA_ID







/*
实际指标调整-2017版本
*/

SELECT a.DMA_Id
	,ProductLineId
	,CAST(ProductLineName AS NVARCHAR(50)) ProductLineName
	,DivisionCode
	,DivisionName
	,CC_Code
	,CAST(CC_NameCN AS NVARCHAR(50)) CC_NameCN
	,PCTId
	,PCTCode
	,CAST(PCTName AS NVARCHAR(50)) PCTName
	,Year
	,HospitalId
	,HospitalCode
	,HOS_HospitalName
	,AOPType
	,Month1
	,Month2
	,Month3
	,Month4
	,Month5
	,Month6
	,Month7
	,Month8
	,Month9
	,Month10
	,Month11
	,Month12
	,Price
	,dma.DMA_SAP_Code as SAPID
FROM (
	SELECT TAB.DMA_Id
		,TAB.ProductLineId
		,TAB.ProductLineName
		,TAB.DivisionCode
		,TAB.DivisionName
		,CC_Code
		,CC_NameCN
		,PCTId
		,PCTCode
		,PCTName
		,Year
		,HospitalId
		,HospitalCode
		,HOS_HospitalName
		,AOPType
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month1 else case when MONTH(MinDate)>=1 then Month1 else 0.0 end end  Month1
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month2 else case when MONTH(MinDate)>=2 then Month2 else 0.0 end end  Month2
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month3 else case when MONTH(MinDate)>=3 then Month3 else 0.0 end end  Month3
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month4 else case when MONTH(MinDate)>=4 then Month4 else 0.0 end end  Month4
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month5 else case when MONTH(MinDate)>=5 then Month5 else 0.0 end end  Month5
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month6 else case when MONTH(MinDate)>=6 then Month6 else 0.0 end end  Month6
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month7 else case when MONTH(MinDate)>=7 then Month7 else 0.0 end end  Month7
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month8 else case when MONTH(MinDate)>=8 then Month8 else 0.0 end end  Month8
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month9 else case when MONTH(MinDate)>=9 then Month9 else 0.0 end end  Month9
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month10 else case when MONTH(MinDate)>=10 then Month10 else 0.0 end end  Month10
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month11 else case when MONTH(MinDate)>=11 then Month11 else 0.0 end end  Month11
		,case when YEAR(MinDate)>YEAR(GETDATE()) Then Month12 else case when MONTH(MinDate)>=12 then Month12 else 0.0 end end  Month12
		
		,Price
	FROM (
	SELECT DMA_Id,ProductLineId,ProductLineName,DivisionCode,DivisionName,PCTId,PCTCode,PCTName,[Year],HospitalId,HospitalCode,HOS_HospitalName,AOPType 
	,Month1,Month2,Month3,Month4,Month5,Month6,Month7,Month8,Month9,Month10,Month11,Month12 
	,[dbo].[GC_Fn_GetProductHospitalPrice](HospitalId,PCTId,[YEAR],CONVERT(NVARCHAR,MONTH(GETDATE())))  AS Price
	FROM (
			SELECT RE.AOPDH_Dealer_DMA_ID AS DMA_Id
			,RE.AOPDH_ProductLine_BUM_ID AS ProductLineId
			,DPR.ProductLineName AS ProductLineName
			,DPR.DivisionCode AS DivisionCode 
			,DPR.DivisionName AS DivisionName
			,RE.AOPDH_PCT_ID AS PCTId
			,CQ.CQ_Code AS PCTCode
			,CQ.CQ_NameCN AS PCTName
			,RE.AOPDH_Year AS [Year]
			,RE.AOPDH_Hospital_ID AS HospitalId
			,HOS.HOS_Key_Account AS HospitalCode
			,HOS.HOS_HospitalName
			,'Unit' AOPType
			,RE.AOPDH_Amount_1 AS Month1
			,RE.AOPDH_Amount_2 AS Month2
			,RE.AOPDH_Amount_3 AS Month3
			,RE.AOPDH_Amount_4 AS Month4
			,RE.AOPDH_Amount_5 AS Month5
			,RE.AOPDH_Amount_6 AS Month6
			,RE.AOPDH_Amount_7 AS Month7
			,RE.AOPDH_Amount_8 AS Month8
			,RE.AOPDH_Amount_9 AS Month9
			,RE.AOPDH_Amount_10 AS Month10
			,RE.AOPDH_Amount_11 AS Month11
			,RE.AOPDH_Amount_12 AS Month12
		FROM V_AOPDealerHospital RE
		LEFT JOIN (SELECT DISTINCT CQ_ID,CQ_Code,CQ_NameCN	FROM interface.ClassificationQuota(NOLOCK)) CQ ON CQ.CQ_ID = RE.AOPDH_PCT_ID
		LEFT JOIN V_DivisionProductLineRelation DPR ON DPR.ProductLineID = RE.AOPDH_ProductLine_BUM_ID AND DPR.IsEmerging = '0'
		LEFT JOIN Hospital HOS(NOLOCK) ON HOS.HOS_ID = RE.AOPDH_Hospital_ID AND HOS.HOS_ActiveFlag = '1'
		WHERE RE.AOPDH_Year = YEAR(GETDATE()) and DPR.DivisionCode in ('35','17') and CQ.CQ_Code not in ('1702012','1702013','17','1702105','3603001','3603002','3602005')
		) TAB
		
		UNION
		SELECT RE.AOPDH_Dealer_DMA_ID AS DMA_Id
			,RE.AOPDH_ProductLine_BUM_ID AS ProductLineId
			,DPR.ProductLineName AS ProductLineName
			,DPR.DivisionCode AS DivisionCode 
			,DPR.DivisionName AS DivisionName
			,RE.AOPDH_PCT_ID AS PCTId
			,CQ.CQ_Code AS PCTCode
			,CQ.CQ_NameCN AS PCTName
			,RE.AOPDH_Year AS [Year]
			,RE.AOPDH_Hospital_ID AS HospitalId
			,HOS.HOS_Key_Account AS HospitalCode
			,HOS.HOS_HospitalName
			,'Amount' AOPType
			,RE.AOPDH_Amount_1 AS Month1
			,RE.AOPDH_Amount_2 AS Month2
			,RE.AOPDH_Amount_3 AS Month3
			,RE.AOPDH_Amount_4 AS Month4
			,RE.AOPDH_Amount_5 AS Month5
			,RE.AOPDH_Amount_6 AS Month6
			,RE.AOPDH_Amount_7 AS Month7
			,RE.AOPDH_Amount_8 AS Month8
			,RE.AOPDH_Amount_9 AS Month9
			,RE.AOPDH_Amount_10 AS Month10
			,RE.AOPDH_Amount_11 AS Month11
			,RE.AOPDH_Amount_12 AS Month12
			,null AS Price
		FROM V_AOPDealerHospital RE
		LEFT JOIN (SELECT DISTINCT CQ_ID,CQ_Code,CQ_NameCN	FROM interface.ClassificationQuota(NOLOCK)) CQ ON CQ.CQ_ID = RE.AOPDH_PCT_ID
		LEFT JOIN V_DivisionProductLineRelation DPR ON DPR.ProductLineID = RE.AOPDH_ProductLine_BUM_ID AND DPR.IsEmerging = '0'
		LEFT JOIN Hospital HOS(NOLOCK) ON HOS.HOS_ID = RE.AOPDH_Hospital_ID AND HOS.HOS_ActiveFlag = '1'
		WHERE RE.AOPDH_Year = YEAR(GETDATE()) and (DPR.DivisionCode not in ('35','17') or (DPR.DivisionCode in ('35','17') and CQ.CQ_Code in  ('1702012','1702013','17','1702105','3603001','3603002','3602005')))
		
		
		
		
		) TAB
	INNER JOIN (
		SELECT DISTINCT CC_ProductLineID
			,CC_ID
			,CC_Code
			,CC_NameCN
			,CQ_ID
			,CQ_Code
		FROM interface.V_I_QV_ProductClassificationStructure st 
		) PCS ON PCS.CQ_ID = TAB.PCTId AND TAB.ProductLineId = PCS.CC_ProductLineID
	INNER JOIN interface.V_I_QV_DealerContractMaster_AOP DCM ON DCM.CC_ID = PCS.CC_ID AND DCM.DMA_ID = TAB.DMA_Id AND TAB.DivisionCode = CONVERT(NVARCHAR(10), DCM.Division) and TAB.Year=CONVERT(NVARCHAR(10),YEAR(DCM.MinDate))
	--INNER JOIN V_AllHospitalMarketProperty b ON ((isnull(dcm.MarketType, 0) = 2) OR (isnull(dcm.MarketType, 0) <> 2 AND dcm.MarketType = b.MarketProperty)) AND b.DivisionCode = CONVERT(NVARCHAR(10), dcm.Division) AND b.Hos_Id = tab.HospitalId
	INNER JOIN interface.Stage_V_AllHospitalMarketProperty b ON ((isnull(dcm.MarketType, 0) = 2) OR (isnull(dcm.MarketType, 0) <> 2 AND dcm.MarketType = b.MarketProperty)) AND b.DivisionCode = CONVERT(NVARCHAR(10), dcm.Division) AND b.Hos_Id = tab.HospitalId
	WHERE ((CC_Code = 'C1701' AND PCTCode NOT IN ('1702007', '1702008', '1702009', '1702004', '1703001', '1702005', '1703002')) OR (CC_Code <> 'C1701'))
	and ((CC_Code = 'C3401' AND PCTCode NOT IN ('34')) OR (CC_Code <> 'C3401'))
	) A
	LEFT JOIN dbo.DealerMaster dma
		on a.DMA_Id=dma.DMA_ID










GO


