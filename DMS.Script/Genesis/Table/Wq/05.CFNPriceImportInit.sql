USE [GenesisDMS_Test]
GO

/****** Object:  Table [dbo].[CFNPriceImportInit]    Script Date: 2019/10/18 10:00:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CFNPriceImportInit](
	[CFNPI_ID] [uniqueidentifier] NOT NULL,
	[CFNPI_Group_ID] [uniqueidentifier] NULL,
	[CFNPI_SAP_Code] [nvarchar](200) NULL,
	[CFNPI_ChineseName] [nvarchar](200) NULL,
	[CFNPI_CFN_ID] [uniqueidentifier] NULL,
	[CFNPI_CustomerFaceNbr] [nvarchar](200) NULL,
	[CFNPI_Price] [nvarchar](100) NULL,
	[CFNPI_Province] [nvarchar](200) NULL,
	[CFNPI_Province_ID] [uniqueidentifier] NULL,
	[CFNPI_City] [nvarchar](200) NULL,
	[CFNPI_City_ID] [uniqueidentifier] NULL,
	[CFNPI_LevelValue] [nvarchar](100) NULL,
	[CFNPI_LevelKey] [nvarchar](100) NULL,
	[CFNPI_ValidDateFrom] [nvarchar](100) NULL,
	[CFNPI_ValidDateTo] [nvarchar](100) NULL,
	[CFNPI_SubCompanyId] [uniqueidentifier] NULL,
	[CFNPI_BrandId] [uniqueidentifier] NULL,
	[ErrMassage] [nvarchar](max) NULL,
	[CreateUser] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_CFNPriceImportInit] PRIMARY KEY CLUSTERED 
(
	[CFNPI_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


