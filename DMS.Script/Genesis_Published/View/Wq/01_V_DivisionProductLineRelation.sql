

/****** Object:  View [dbo].[V_DivisionProductLineRelation]    Script Date: 2019/9/26 11:48:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[V_DivisionProductLineRelation]
AS
  select ProductLineID,	ProductLineName,	DivisionName,	DivisionCode,	IsEmerging 
  ,SubCompanyId,SubCompanyName,BrandId,BrandName
  from t_DivisionProductLineRelation dplr
  left join View_ProductLine vpl on vpl.Id=dplr.ProductLineID
  

GO


