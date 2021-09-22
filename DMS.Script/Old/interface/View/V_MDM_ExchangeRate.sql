DROP VIEW [interface].[V_MDM_ExchangeRate]
GO




CREATE VIEW [interface].[V_MDM_ExchangeRate]
AS

   SELECT TOP 1 [FROM] AS [FROM],[TO] AS [TO], Rate AS Rate FROM interface.MDM_ExchangeRate



GO


