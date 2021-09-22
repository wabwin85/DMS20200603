DROP VIEW [dbo].[V_DivisionProductLineRelation]
GO


CREATE VIEW [dbo].[V_DivisionProductLineRelation]
AS
  select ProductLineID,	ProductLineName,	DivisionName,	DivisionCode,	IsEmerging from t_DivisionProductLineRelation

GO


