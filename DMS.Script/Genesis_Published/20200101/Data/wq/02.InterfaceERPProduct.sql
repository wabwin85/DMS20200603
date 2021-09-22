USE [GenesisDMS_PRD]
GO

/****** Object:  Table [dbo].[InterfaceERPProduct]    Script Date: 2019/12/18 14:53:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InterfaceERPProduct](
	[ID] [uniqueidentifier] NOT NULL,
	[IsProcess] int NOT NULL,
	[ImportDate] [datetime] NULL,
	[ProcessDate] [datetime] NULL,
	[FNumber] [nvarchar](50) NOT NULL,
	[FName] [nvarchar](200) NULL,
	[F_SRT_EnglishName] [nvarchar](200) NULL,
	[FMnemonicCode] [nvarchar](50) NULL,
	[Fspecification] [nvarchar](500) NULL,
	[FBASEUNITID.FNumber] [nvarchar](500) NULL,
	[F_SRT_ProductLine] [nvarchar](50) NULL,
	[F_SRT_RegName] [nvarchar](200) NULL,
	[FModifyDate] [nvarchar](50) NULL,
	[FIsSale] [nvarchar](50) NULL,
	[F_SRT_SourceArea] [nvarchar](200) NULL,
 CONSTRAINT [PK_InterfaceERPProduct] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) 

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否处理，0未处理，1处理中，2处理完成' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'IsProcess'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'导入时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'ImportDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'处理时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'ProcessDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'金蝶物料编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'FNumber'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'物料名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'FName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'英文名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_EnglishName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'UPN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'FMnemonicCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'Fspecification'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'FBASEUNITID.FNumber'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'产品线' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_ProductLine'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'注册证' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_RegName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'FModifyDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP获取到产品表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'InterfaceERPProduct'
GO


