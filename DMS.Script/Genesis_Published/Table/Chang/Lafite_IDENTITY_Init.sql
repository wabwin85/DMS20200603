

/****** Object:  Table [dbo].[Lafite_IDENTITY_Init]    Script Date: 2019/11/26 14:38:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Lafite_IDENTITY_Init](
	[LII_Id] [uniqueidentifier] NOT NULL,
	[LoginId] [nvarchar](50) NULL,
	[JoinDate] [nvarchar](50) NULL,
	[AccountingDate] [nvarchar](50) NULL,
	[IsError] [bit] NULL,
	[ErrorMsg] [nvarchar](2000) NULL,
	[LineNbr] [int] NOT NULL,
	[ImportUser] [uniqueidentifier] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[UserId] [varchar](50) NULL,
 CONSTRAINT [PK_Lafite_IDENTITY_Init] PRIMARY KEY CLUSTERED 
(
	[LII_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lafite_IDENTITY_Init', @level2type=N'COLUMN',@level2name=N'LineNbr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'导入人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lafite_IDENTITY_Init', @level2type=N'COLUMN',@level2name=N'ImportUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'导入时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Lafite_IDENTITY_Init', @level2type=N'COLUMN',@level2name=N'ImportDate'
GO


