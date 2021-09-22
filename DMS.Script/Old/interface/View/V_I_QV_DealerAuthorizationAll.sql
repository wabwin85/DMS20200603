DROP view [interface].[V_I_QV_DealerAuthorizationAll]
GO













CREATE view [interface].[V_I_QV_DealerAuthorizationAll]
as
select distinct
			ProductLine
			,ProductLineId=HosAuth.ProductLineId
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
			,CC_Code SubBUCode
			,CC_NameCN SubBUName
			,CA_Code  CaCode
			,CA_NameCN CaName
			
	from (
			SELECT
			cc.CC_Code,
			cc.CC_NameCN,
			ca.CA_Code,
			ca.CA_NameCN,
			dp.DivisionCode,
			dp.DivisionName,
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
			 ) as ProductLineId
			--,dct.ExpirationDate as StopDate
			---,dct.EffectiveDate as StartDate
			,'' as StopDate
			,'' as StartDate
			,HOS_City
			,a.TER_ID as ProvinceId
			,t.TER_ID as CityId
			,DMA_Parent_DMA_ID
	FROM Hospital ( nolock)
	inner join HospitalList ( nolock) b on b. HLA_HOS_ID = Hospital.HOS_ID
	inner join DealerAuthorizationTable (nolock ) dat on dat.DAT_ID =b .HLA_DAT_ID
	inner join DealerMaster ( nolock) dma on dma.DMA_ID =dat .DAT_DMA_ID
	inner join V_DivisionProductLineRelation ( nolock) dp on  dp.ProductLineID=dat.DAT_ProductLine_BUM_ID and dp.IsEmerging='0'
	inner join(select distinct dcm.DMA_ID,dcm.Division, dcm.CC_ID from  V_DealerContractMaster dcm where dcm.ActiveFlag='1' ) dcmm on dcmm.DMA_ID=dat.DAT_DMA_ID and CONVERT(nvarchar(10), dcmm.Division)=dp.DivisionCode
	inner join interface.ClassificationContract cc on dcmm.CC_ID=cc.CC_ID
	inner join interface.ClassificationAuthorization ca on ca.CA_ParentCode=cc.CC_Code and ca.CA_ID=dat.DAT_PMA_ID
	
	left join Territory a on HOS_Province=a.TER_Description and a.TER_Type='Province'
	left join Territory t on HOS_City=t.TER_Description and t.TER_Type='City'
	and t.TER_ParentID=a.TER_ID
) as HosAuth










GO


