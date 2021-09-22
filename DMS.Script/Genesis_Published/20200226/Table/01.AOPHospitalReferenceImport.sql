USE [GenesisDMS_PRD]
GO

/****** Object:  Table [dbo].[AOPHospitalReferenceImport]    Script Date: 2020/2/25 8:55:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AOPHospitalReferenceImport](
	[AOPHRI_ID] [uniqueidentifier] NOT NULL,
	[AOPHRI_SubCompanyName] [nvarchar](200) NULL,
	[AOPHRI_SubCompanyId] [uniqueidentifier] NULL,
	[AOPHRI_BrandName] [nvarchar](200) NULL,
	[AOPHRI_BrandId] [uniqueidentifier] NULL,
	[AOPHRI_ProductLine_BUM_ID] [uniqueidentifier] NULL,
	[AOPHRI_ProductLineName] [nvarchar](200) NULL,
	[AOPHRI_Year] [nvarchar](30) NULL,
	[AOPHRI_HospitalName] [nvarchar](200) NULL,
	[AOPHRI_HospitalNbr] [nvarchar](30) NULL,
	[AOPHRI_Hospital_ID] [uniqueidentifier] NULL,
	[AOPHRI_January] [float] NULL,
	[AOPHRI_February] [float] NULL,
	[AOPHRI_March] [float] NULL,
	[AOPHRI_April] [float] NULL,
	[AOPHRI_May] [float] NULL,
	[AOPHRI_June] [float] NULL,
	[AOPHRI_July] [float] NULL,
	[AOPHRI_August] [float] NULL,
	[AOPHRI_September] [float] NULL,
	[AOPHRI_October] [float] NULL,
	[AOPHRI_November] [float] NULL,
	[AOPHRI_December] [float] NULL,
	[AOPHRI_Update_User_ID] [uniqueidentifier] NULL,
	[AOPHRI_Update_Date] [datetime] NULL,
	[AOPHRI_PCTName] [nvarchar](200) NULL,
	[AOPHRI_PCT_ID] [uniqueidentifier] NULL,
	[AOPHRI_ErrMassage] [nvarchar](2000) NULL,
	[AOPHRI_DivisionID] [nvarchar](30) NULL,
 CONSTRAINT [PK_AOPHOSPITALREFERENCEImport] PRIMARY KEY CLUSTERED 
(
	[AOPHRI_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


