DROP PROCEDURE [interface].[p_i_cr_Division]
GO

CREATE PROCEDURE [interface].[p_i_cr_Division]
WITH EXEC AS CALLER
AS
DELETE from interface.T_I_CR_Division

Insert into interface.T_I_CR_Division
SELECT [DivisionID]=DivisionId --×é±ðId
      ,[Division]=ATTRIBUTE_Name
      ,[ST]=1
  FROM dbo.View_BU
GO


