SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE TRIGGER [dbo].[TRG_Cache_Lafite_IDENTITY_MAP]
ON [dbo].[Lafite_IDENTITY_MAP]
AFTER INSERT, UPDATE, DELETE
NOT FOR REPLICATION
AS
BEGIN
    --update dbo.Lafite_Settings set State =0,LastUpdateDate=GetDate() where Title='SalesOfDealer'

    IF EXISTS (SELECT 1 FROM Inserted WHERE Inserted.MAP_TYPE = 'Position')
       OR EXISTS
    (
        SELECT 1
        FROM Deleted
        WHERE Deleted.MAP_TYPE = 'Position'
    )
    BEGIN
        EXEC [Lafite_Settings_ResetState] 'SalesOfDealer';
    END;

END;


