
DROP view [interface].[V_I_QV_Hospital]
GO



CREATE view [interface].[V_I_QV_Hospital]
as
		select
			 DMSCode =HOS_Key_Account
			,Name_CN =HOS_HospitalName
			,ShortName =HOS_HospitalShortName
			,Name_EN =HOS_HospitalNameEN
			,Province =HOS_Province
			,ProvinceID =a.TER_ID
			,City =HOS_City
			,CityID =b.TER_ID
			,[Address] =HOS_Address
			,PostalCode =HOS_PostalCode
			,H_Grad = HOS_Grade
			,[Status] =HOS_ActiveFlag
			,HOS_ID
		from Hospital
		left join Territory a on HOS_Province=a.TER_Description and a.TER_Type='Province'
		left join Territory b on HOS_City=b.TER_Description and b.TER_Type='City'
		and b.TER_ParentID=a.TER_ID




GO


