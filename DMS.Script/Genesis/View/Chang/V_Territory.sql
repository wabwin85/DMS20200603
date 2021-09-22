USE [GenesisDMS_Test]
GO

/****** Object:  View [dbo].[V_Territory]    Script Date: 2019/11/29 17:30:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[V_Territory]
AS
	with p as(
		select [TER_Description],[TER_ID],[TER_ParentID],[TER_Code],[TER_Type],[TER_EName] 
			,[TER_ID] as ProvinceID, [TER_Code] as ProvinceCode,[TER_Description] as ProvinceName
			,NULL as  CityID, NULL as CityCode, NULL as CityName
			,NULL as  CountyID,NULL as  CountyCode,NULL as  CountyName
		from Territory where TER_Type='Province')
	,city as(
		select  c.[TER_Description],c.[TER_ID],c.[TER_ParentID],c.[TER_Code],c.[TER_Type],c.[TER_EName] 
				,p.ProvinceID, p.ProvinceCode,p.ProvinceName
				,c.[TER_ID] as  CityID, c.[TER_Code] as CityCode, c.[TER_Description] as CityName
				,NULL as  CountyID,NULL as  CountyCode,NULL as  CountyName
		from Territory c inner join p on c.TER_ParentID=p.TER_ID	
		where c.TER_Type='City')	
	,County as(
		select  c2.[TER_Description],c2.[TER_ID],c2.[TER_ParentID],c2.[TER_Code],c2.[TER_Type],c2.[TER_EName] 
				,city.ProvinceID, city.ProvinceCode,city.ProvinceName
				,city.CityID, city.CityCode, city.CityName
				,c2.[TER_ID] as  CountyID,c2.[TER_Code] as  CountyCode,c2.[TER_Description] as  CountyName
		from Territory c2 inner join city on c2.TER_ParentID=city.TER_ID
		where c2.TER_Type='County')	
		select * from p
		union
		select * from city
		union
		select * from County		









GO


