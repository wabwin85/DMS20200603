DROP VIEW [dbo].[V_LotMaster]
GO

CREATE VIEW [dbo].[V_LotMaster] WITH SCHEMABINDING 
AS 

      select LTM_InitialQty,
      LTM_ExpiredDate,
      CASE WHEN CHARINDEX('@@',LTM_LotNumber) > 0 THEN substring(LTM_LotNumber,1,CHARINDEX('@@',LTM_LotNumber)-1) ELSE LTM_LotNumber END AS LTM_LotNumber,
      LTM_ID,
      LTM_CreatedDate,
      LTM_PRL_ID,
      LTM_Product_PMA_ID,
      LTM_Type,
      LTM_RelationID,
      CASE WHEN CHARINDEX('@@',LTM_LotNumber) > 0 THEN substring(LTM_LotNumber,CHARINDEX('@@',LTM_LotNumber)+2,LEN(LTM_LotNumber)-CHARINDEX('@@',LTM_LotNumber)) ELSE 'NoQR' END AS LTM_QrCode
      from dbo.LotMaster(nolock)
GO


