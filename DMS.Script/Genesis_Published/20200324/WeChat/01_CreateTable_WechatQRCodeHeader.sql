
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WechatQRCodeHeader](
	[WQH_ID] [UNIQUEIDENTIFIER] NOT NULL,
	[WQH_No] [NVARCHAR](50) NOT NULL,
	[WQH_DealerID] UNIQUEIDENTIFIER NOT NULL,
	[WQH_UploadStatus] BIT NOT NULL,
	[WQH_Remark] [NVARCHAR](500) NULL,
	[WQH_UploadDate] [DATETIME] NULL,
	[WQH_UploadResult] [NVARCHAR](max) NULL,
	[WQH_Status] BIT NOT NULL,
	[WQH_CreateDate] [DATETIME] NULL,
	[WQH_CreateUser] [NVARCHAR](50) NULL,
	[WQH_UpdateDate] [DATETIME] NULL,
	[WQH_UpdateUser] [NVARCHAR](50) NULL
 CONSTRAINT [PK_WechatQRCodeHeader] PRIMARY KEY CLUSTERED 
(
	[WQH_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeHeader', @level2type=N'COLUMN',@level2name=N'WQH_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'单据号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeHeader', @level2type=N'COLUMN',@level2name=N'WQH_No'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'经销商ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeHeader', @level2type=N'COLUMN',@level2name=N'WQH_DealerID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注信息' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeHeader', @level2type=N'COLUMN',@level2name=N'WQH_Remark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeHeader', @level2type=N'COLUMN',@level2name=N'WQH_CreateDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeHeader', @level2type=N'COLUMN',@level2name=N'WQH_CreateUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeHeader', @level2type=N'COLUMN',@level2name=N'WQH_UpdateDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeHeader', @level2type=N'COLUMN',@level2name=N'WQH_UpdateUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'WechatQRCodeHeader' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WechatQRCodeHeader'
GO


