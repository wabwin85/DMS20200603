DROP proc [interface].[p_i_cr_HospitalSalesRep]
GO





CREATE proc [interface].[p_i_cr_HospitalSalesRep]
as

DELETE from interface.[T_I_CR_Hospital_SalesRep]
where [Year]=DATEPART(year,getdate()) and [Month]=DATEPART(month,getdate())

Insert into interface.[T_I_CR_Hospital_SalesRep]
SELECT [ID]=SRH_ID
      ,[HospitalID]=isnull(HOS_Key_Account,'')
      ,[Sales]=IDENTITY_NAME
      ,[EID]=IDENTITY_CODE
      ,[DivisionID]=Bu.DivisionId  --×é±ðId
      ,[Month]=DATEPART(month,GETDATE())
      ,[Year]=DATEPART(year,GETDATE())
  FROM SalesRepHospital s
  left join Hospital on  Hospital.HOS_ID=s.SRN_HOS_ID
  left join Lafite_IDENTITY l on s.SRH_USR_UserID=l.Id
  left join
  (SELECT bu.DivisionId as DivisionId ,ou.AttributeID as AttributeID FROM Cache_OrganizationUnits ou
INNER JOIN View_BU bu ON bu.Id = ou.RootID
WHERE ou.AttributeType = 'Product_Line') as Bu
on convert(nvarchar(200),s.BUM_ID)=Bu.AttributeID




GO


