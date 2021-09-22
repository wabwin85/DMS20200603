CREATE TABLE [dbo].[PurchaseOrderDetail_WithQR] (
[POD_ID] uniqueidentifier NOT NULL,
[POD_POH_ID] uniqueidentifier NOT NULL,
[POD_CFN_ID] uniqueidentifier NOT NULL,
[POD_CFN_Price] decimal(18, 6) NULL,
[POD_UOM] nvarchar(100) NULL,
[POD_RequiredQty] decimal(18, 6) NULL,
[POD_Amount] decimal(18, 6) NULL,
[POD_Tax] decimal(18, 6) NULL,
[POD_ReceiptQty] decimal(18, 6) NULL,
[POD_Status] nvarchar(50) NULL,
[POD_LotNumber] nvarchar(50) NULL,
[POD_ShipmentNbr] nvarchar(30) NULL,
[POD_HOS_ID] uniqueidentifier NULL,
[POD_WH_ID] uniqueidentifier NULL,
[POD_Field1] nvarchar(50) NULL,
[POD_Field2] nvarchar(50) NULL,
[POD_Field3] nvarchar(50) NULL,
[POD_CurRegNo] nvarchar(500) NULL,
[POD_CurValidDateFrom] datetime NULL,
[POD_CurValidDataTo] datetime NULL,
[POD_CurManuName] nvarchar(500) NULL,
[POD_LastRegNo] nvarchar(500) NULL,
[POD_LastValidDateFrom] datetime NULL,
[POD_LastValidDataTo] datetime NULL,
[POD_LastManuName] nvarchar(500) NULL,
[POD_CurGMKind] nvarchar(200) NULL,
[POD_CurGMCatalog] nvarchar(200) NULL,
[POD_QRCode] nvarchar(50) NULL,
[POD_ConsignmentDay] int null,
[POD_ConsignmentContractID] uniqueidentifier,
CONSTRAINT [PK_PurchaseOrderDetail_WithQR]
PRIMARY KEY NONCLUSTERED ([POD_ID] ASC)
WITH ( PAD_INDEX = OFF,
FILLFACTOR = 100,
IGNORE_DUP_KEY = OFF,
STATISTICS_NORECOMPUTE = OFF,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON,
DATA_COMPRESSION = NONE )
 ON [PRIMARY]
)
ON [PRIMARY]
WITH (DATA_COMPRESSION = NONE);
GO
ALTER TABLE [dbo].[PurchaseOrderDetail_WithQR] SET (LOCK_ESCALATION = TABLE);
GO



CREATE NONCLUSTERED INDEX [Idx_PODQR_POH_ID]
ON [dbo].[PurchaseOrderDetail_WithQR]
([POD_POH_ID])
WITH
(
PAD_INDEX = OFF,
FILLFACTOR = 100,
IGNORE_DUP_KEY = OFF,
STATISTICS_NORECOMPUTE = OFF,
ONLINE = OFF,
ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON,
DATA_COMPRESSION = NONE
)
ON [PRIMARY];
GO