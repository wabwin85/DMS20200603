USE [BSC_Prd]
GO

/****** Object:  Table [dbo].[CFN]    Script Date: 11/21/2017 10:00:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [interface].[T_I_MDS_CFN](
[CFN_CustomerFaceNbr] [nvarchar](200) not NULL,
	[CFN_EnglishName] [nvarchar](200) NULL,
	[CFN_ChineseName] [nvarchar](200) NULL,
	[CFN_Implant] [bit] NULL,
	[CFN_Tool] [bit] NULL,
	[CFN_Description] [nvarchar](200) NULL,
	[CFN_ProductCatagory_PCT_ID] [uniqueidentifier] NULL,
	[CFN_Property1] [nvarchar](200) NULL,
	[CFN_Property2] [nvarchar](200) NULL,
	[CFN_Property3] [nvarchar](200) NULL,
	[CFN_Property4] [nvarchar](200) NULL,
	[CFN_Property5] [nvarchar](200) NULL,
	[CFN_Property6] [nvarchar](200) NULL,
	[CFN_Property7] [nvarchar](200) NULL,
	[CFN_Property8] [nvarchar](200) NULL,
	[CFN_LastModifiedDate] [datetime] NULL,
	[CFN_DeletedFlag] [bit] NULL,
	[CFN_ProductLine_BUM_ID] [uniqueidentifier] NULL,
	[CFN_LastModifiedBy_USR_UserID] [uniqueidentifier] NULL,
	[CFN_Share] [bit] NULL,
	[CFN_Level1Code] [nvarchar](200) NULL,
	[CFN_Level1Desc] [nvarchar](200) NULL,
	[CFN_Level2Code] [nvarchar](200) NULL,
	[CFN_Level2Desc] [nvarchar](200) NULL,
	[CFN_Level3Code] [nvarchar](200) NULL,
	[CFN_Level3Desc] [nvarchar](200) NULL,
	[CFN_Level4Code] [nvarchar](200) NULL,
	[CFN_Level4Desc] [nvarchar](200) NULL,
	[CFN_Level5Code] [nvarchar](200) NULL,
	[CFN_Level5Desc] [nvarchar](200) NULL,
	[CFN_ConvertFactor] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[CFN_CustomerFaceNbr] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
