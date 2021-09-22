DROP VIEW [interface].[V_I_QV_DealerAuthorization]
GO




CREATE VIEW [interface].[V_I_QV_DealerAuthorization]
AS
--select distinct
--			 ProductLine
--			,ProductLineId=HosAuth.ProductLineId
--			,Division=ISNULL(HosAuth.DivisionName,'')
--			,DivisionId=ISNULL(HosAuth.DivisionCode,0)
--			,Dealer=DMA_ChineseName
--			,SAPID=DMA_SAP_Code
--			,DealerType=DMA_DealerType
--			,DMA_Parent=Case when DMA_Parent_DMA_ID='A00FCD75-951D-4D91-8F24-A29900DA5E85' then '·½³Ð'
--				when DMA_Parent_DMA_ID='84C83F71-93B4-4EFD-AB51-12354AFABAC3' then '¹ú¿ÆºãÌ©'
--				else 'Boston' end 
--			,Hospital=HOS_HospitalName
--			,DMSCode=HOS_Key_Account
--			,Province=HOS_Province
--			,ProvindeID=ProvinceId
--			,City=HOS_City
--			,CityID=CityId
--			,StartDate=StartDate
--			,StopDate=StopDate
--			,Year=YEAR(getdate())
--			,Month=MONTH(getdate())
--			,CC_Code AS SubBUCode
--			,CC_NameCN AS SubBUName
--			,CA_Code AS CaCode
--			,CA_NameCN AS CaName
--			,MinDate
--	from (
--			SELECT
--			dp.DivisionCode,
--			dp.DivisionName,
--			ca.CA_Code ,
--			CA_NameCN,
--			 DMA_SAP_Code, 
--			 DMA_ChineseName,
--			 DMA_DealerType , 
--			 HOS_Key_Account,
--			 HOS_HospitalName,
--			 HOS_Province,
--			 isnull( (CASE WHEN DAT_PMA_ID = DAT_ProductLine_BUM_ID THEN NULL          
--			 ELSE (SELECT PCT_Name FROM PartsClassification WHERE DAT_PMA_ID = PCT_ID
--			 )  END ),
--			 (SELECT P. ATTRIBUTE_NAME FROM View_ProductLine AS P WHERE P .ID =
--			 DAT_ProductLine_BUM_ID)
--			 ) as ProductLine,
--		     isnull( (CASE WHEN DAT_PMA_ID = DAT_ProductLine_BUM_ID THEN NULL          
--			 ELSE (SELECT PCT_ID FROM PartsClassification WHERE DAT_PMA_ID = PCT_ID
--			 )  END ),
--			 (SELECT P.Id FROM View_ProductLine AS P WHERE P .ID =
--			 DAT_ProductLine_BUM_ID)
--			 ) as ProductLineId
--			,CC_Code
--			,CC_NameCN
--			,dct.ExpirationDate as StopDate
--			,dct.EffectiveDate as StartDate
--			,HOS_City
--			,a.TER_ID as ProvinceId
--			,t.TER_ID as CityId
--			,DMA_Parent_DMA_ID
--			,dct.MinDate 
--	FROM Hospital ( nolock)
--	inner join HospitalList ( nolock) b on b. HLA_HOS_ID = Hospital.HOS_ID
--	inner join DealerAuthorizationTable (nolock ) dat on dat.DAT_ID =b .HLA_DAT_ID
--	inner join DealerMaster ( nolock) dma on dma.DMA_ID =dat .DAT_DMA_ID
--	inner join V_DealerContractMaster ( nolock) dct on dct.ActiveFlag=1 and dct.DMA_ID=dat.DAT_DMA_ID 
--	inner join V_DivisionProductLineRelation ( nolock) dp on dp.DivisionCode=CONVERT(nvarchar(10), dct.Division) and dp.ProductLineID=dat.DAT_ProductLine_BUM_ID and dp.IsEmerging='0'
--	--inner join V_AllHospitalMarketProperty ( nolock)  hmk on hmk.DivisionCode=dp.DivisionCode and ISNULL( hmk.MarketProperty,0)=isnull(dct.MarketType,0) and b.HLA_HOS_ID=hmk.Hos_Id
--	inner join interface.ClassificationContract cc on dct.CC_ID=cc.CC_ID and cc.CC_Division= CONVERT(nvarchar(10), dct.Division)
--	inner join interface.ClassificationAuthorization ca on ca.CA_ParentCode=cc.CC_Code and ca.CA_ID=dat.DAT_PMA_ID
--	left join Territory a on HOS_Province=a.TER_Description and a.TER_Type='Province'
--	left join Territory t on HOS_City=t.TER_Description and t.TER_Type='City'
--	and t.TER_ParentID=a.TER_ID
--) as HosAuth 
--INNER JOIN V_AllHospitalMarketProperty M ON M.Hos_Code=HosAuth.HOS_Key_Account  AND M.DivisionCode=HosAuth.DivisionCode
--WHERE 1=1 AND ( (HosAuth.CC_Code='C1701' AND M.MarketProperty<>'1')  OR (HosAuth.CC_Code<>'C1701'))
SELECT ProductLine = A.PMAName
	,ProductLineId = A.ProductLineID
	,Division = ISNULL(A.Division, '')
	,DivisionId = ISNULL(B.DivisionCode, 0)
	,Dealer = A.DealerName
	,SAPID = SAPId
	,DealerType = DealerType
	,DMA_Parent = DmaParent
	,Hospital = HospitalName
	,DMSCode = HospitalCode
	,Province = Province
	,ProvindeID = ProvindeID
	,City = City
	,CityID = CityID
	,StartDate = EffectiveDate
	,StopDate = ExpirationDate
	,Year = [Year]
	,Month = [Month]
	,SubBUCode = SubBU
	,cast(c.CC_NameCN AS NVARCHAR(50)) AS SubBUName
	,d.CA_Code AS CaCode
	,A.PMAName AS CaName
	,MinDate = ''
	,A.TerminationDate
	,A.ExtensionDate
FROM Interface.T_I_QV_DealerAuthorizationList A WITH (NOLOCK)
INNER JOIN V_DivisionProductLineRelation B ON B.IsEmerging = '0' AND B.DivisionName = A.Division
INNER JOIN interface.ClassificationContract c WITH (NOLOCK) ON c.CC_Code = a.SubBU
INNER JOIN (
	SELECT DISTINCT CA_ID
		,CA_Code
	FROM interface.ClassificationAuthorization WITH (NOLOCK)
	) d ON d.CA_ID = a.ProductLineID
WHERE 
--Year = Year(getdate()) AND 
--Month = Month(getdate()) AND 
len(sapid) < 10




GO


