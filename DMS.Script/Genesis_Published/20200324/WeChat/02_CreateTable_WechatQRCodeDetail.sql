
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WechatQRCodeDetail](
	[WQD_ID] [UNIQUEIDENTIFIER] NOT NULL,
	[WQD_WQH_ID] [UNIQUEIDENTIFIER] NOT NULL,
	[WQD_QRCode] [NVARCHAR](50) NOT NULL,
	[WQD_UPN] [NVARCHAR](50) NOT NULL,
	[WQD_Lot] [NVARCHAR](50) NOT NULL,
	[WQD_WeChatStatus] BIT NOT NULL,
	[WQD_DMSStatus] BIT NOT NULL,
	[WQD_Status] BIT NOT NULL,
	[WQD_CreateDate] [DATETIME] NULL,
	[WQD_CreateUser] [NVARCHAR](50) NULL,
	[WQD_UpdateDate] [DATETIME] NULL,
	[WQD_UpdateUser] [NVARCHAR](50) NULL
 CONSTRAINT [PK_WechatQRCodeDetail] PRIMARY KEY CLUSTERED 
(
	[WQD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeDetail', @level2type=N'COLUMN',@level2name=N'WQD_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主表外键ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeDetail', @level2type=N'COLUMN',@level2name=N'WQD_WQH_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'产品二维码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeDetail', @level2type=N'COLUMN',@level2name=N'WQD_QRCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'UPN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeDetail', @level2type=N'COLUMN',@level2name=N'WQD_UPN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lot' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeDetail', @level2type=N'COLUMN',@level2name=N'WQD_Lot'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeDetail', @level2type=N'COLUMN',@level2name=N'WQD_CreateDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeDetail', @level2type=N'COLUMN',@level2name=N'WQD_CreateUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeDetail', @level2type=N'COLUMN',@level2name=N'WQD_UpdateDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeDetail', @level2type=N'COLUMN',@level2name=N'WQD_UpdateUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'WechatQRCodeDetail' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeDetail'
GO


