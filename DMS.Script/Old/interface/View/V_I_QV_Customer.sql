DROP view [interface].[V_I_QV_Customer]
GO

CREATE view [interface].[V_I_QV_Customer]
as
	select DISTINCT
	   ID=dm.DMA_ID,
		DealerID= Convert(nvarchar(50),dm.DMA_ID)
		,SAPID= DMA_SAP_Code
		,Name_CN= DMA_ChineseName
		,Name_EN=DMA_EnglishName
		,DealerType=CASE WHEN DMA_Taxpayer='直销医院' then 'HD' ELSE DMA_DealerType END
		,Province=DMA_Province
		,ProvinceID=a.TER_ID
		,City=DMA_City
		,CityID=b.TER_ID
		,[Address]=DMA_Address
		,PostalCode=DMA_PostalCode
		,ParentDealerID=DMA_Parent_DMA_ID
		,[Status]=DMA_ActiveFlag
		,ParentSAPID=(select DMA_SAP_Code from DealerMaster where DMA_ID=dm.DMA_Parent_DMA_ID)
		,DMA_DealerAuthentication
		,dm.DMA_Reason AS Reason
		,dm.DMA_FormeRname as FormeRname
		,d.DealerMark
		--,DCL_StopDate
	from DealerMaster dm
	left join Territory a on DMA_Province=a.TER_Description and a.TER_Type='Province'
	left join Territory b on DMA_City=b.TER_Description and b.TER_Type='City'
	and b.TER_ParentID=a.TER_ID
	left join  dbo.DealerMark d on d.DMA_ID=dm.DMA_ID
	--left join DealerContract on DMA_ID=DCL_DMA_ID
	where dm.DMA_DeletedFlag=0
GO


