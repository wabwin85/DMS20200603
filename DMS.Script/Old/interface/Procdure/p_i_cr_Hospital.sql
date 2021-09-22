DROP proc [interface].[p_i_cr_Hospital]
GO

CREATE proc [interface].[p_i_cr_Hospital]
as

DELETE from interface.T_I_CR_Hospital

Insert into interface.T_I_CR_Hospital
SELECT distinct [ID]=HOS_ID
      ,[Name_CN]=ISNULL(HOS_HospitalName,'')
      ,[Name_EN]=isnull(Te.TER_EName,Ter.TER_EName)
      ,[HospitalID]=ISNULL(HOS_Key_Account,'')
      ,[ProvinceID]=ISNULL(Te.TER_Description,'')
      ,[CityID]=ISNULL(Ter.TER_Description,'')
      ,[Status]=HOS_ActiveFlag
  FROM dbo.Hospital
  left join Territory as Te
  on Hospital.HOS_Province=Te.TER_Description and Te.TER_Type='Province'
  left join Territory as Ter
  on Hospital.HOS_City=Ter.TER_Description and Ter.TER_Type='City'
GO


