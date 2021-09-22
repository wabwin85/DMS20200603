DROP view [dbo].[V_DealerContractAuthorization]
GO








CREATE view [dbo].[V_DealerContractAuthorization]
as
select distinct
			 ProductLine
			,ProductLineId=HosAuth.ProductLineId
			,Pct_Id=HosAuth.PCT_ID
			,Division=ISNULL(DivisionName,'')
			,DivisionId=ISNULL(DivisionCode,0)
			,Dealer=DMA_ChineseName
			,SAPID=DMA_SAP_Code
			,DealerType=DMA_DealerType
			,DMA_Parent=Case when DMA_Parent_DMA_ID='A00FCD75-951D-4D91-8F24-A29900DA5E85' then '·½³Ð'
				when DMA_Parent_DMA_ID='84C83F71-93B4-4EFD-AB51-12354AFABAC3' then '¹ú¿ÆºãÌ©'
				else 'Boston' end 
			,Hospital=HOS_HospitalName
			,DMSCode=HOS_Key_Account
			,Province=HOS_Province
			,ProvindeID=ProvinceId
			,City=HOS_City
			,CityID=CityId
			,StartDate=StartDate
			,StopDate=StopDate
			,Year=YEAR(getdate())
			,Month=MONTH(getdate())
			,CC_Code AS SubBUCode
			,CC_NameCN AS SubBUName
			,CA_Code AS CaCode
			,CA_NameCN AS CaName
			,MinDate
	from (
			SELECT
			dp.DivisionCode,
			dp.DivisionName,
			ca.CA_Code ,
			CA_NameCN,
			 DMA_SAP_Code, 
			 DMA_ChineseName,
			 DMA_DealerType , 
			 HOS_Key_Account,
			 HOS_HospitalName,
			 HOS_Province,
			 isnull( (CASE WHEN DAT_PMA_ID = DAT_ProductLine_BUM_ID THEN NULL          
			 ELSE (SELECT PCT_Name FROM PartsClassification WHERE DAT_PMA_ID = PCT_ID
			 )  END ),
			 (SELECT P. ATTRIBUTE_NAME FROM View_ProductLine AS P WHERE P .ID =
			 DAT_ProductLine_BUM_ID)
			 ) as ProductLine,
		     isnull( (CASE WHEN DAT_PMA_ID = DAT_ProductLine_BUM_ID THEN NULL          
			 ELSE (SELECT PCT_ID FROM PartsClassification WHERE DAT_PMA_ID = PCT_ID
			 )  END ),
			 (SELECT P.Id FROM View_ProductLine AS P WHERE P .ID =
			 DAT_ProductLine_BUM_ID)
			 ) as PCT_ID
			,CC_Code
			,CC_NameCN
			,dct.ExpirationDate as StopDate
			,dct.EffectiveDate as StartDate
			,HOS_City
			,a.TER_ID as ProvinceId
			,t.TER_ID as CityId
			,DMA_Parent_DMA_ID
			,dct.MinDate 
			,dp.ProductLineID
	FROM Hospital ( nolock)
	inner join HospitalList ( nolock) b on b. HLA_HOS_ID = Hospital.HOS_ID
	inner join DealerAuthorizationTable (nolock ) dat on dat.DAT_ID =b .HLA_DAT_ID
	inner join DealerMaster ( nolock) dma on dma.DMA_ID =dat .DAT_DMA_ID
	inner join V_DealerContractMaster ( nolock) dct on  dct.DMA_ID=dat.DAT_DMA_ID 
	inner join V_DivisionProductLineRelation ( nolock) dp on dp.DivisionCode=CONVERT(nvarchar(10), dct.Division) and dp.ProductLineID=dat.DAT_ProductLine_BUM_ID and dp.IsEmerging='0'
	
	inner join interface.ClassificationContract cc(nolock) on dct.CC_ID=cc.CC_ID and cc.CC_Division= CONVERT(nvarchar(10), dct.Division)
	inner join interface.ClassificationAuthorization ca(nolock) on ca.CA_ParentCode=cc.CC_Code and ca.CA_ID=dat.DAT_PMA_ID
	
	left join Territory a(nolock) on HOS_Province=a.TER_Description and a.TER_Type='Province'
	left join Territory t(nolock) on HOS_City=t.TER_Description and t.TER_Type='City'
	and t.TER_ParentID=a.TER_ID
) as HosAuth














GO


