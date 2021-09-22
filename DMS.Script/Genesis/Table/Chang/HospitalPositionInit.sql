

/****** Object:  Table [dbo].[HospitalPositionInit]    Script Date: 2019/11/27 15:54:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[HospitalPositionInit](
	[Id] [uniqueidentifier] NOT NULL,
	[HospitalID] [uniqueidentifier] NULL,
	[HospitalCode] [nvarchar](50) NULL,
	[IsError] [bit] NULL,
	[ErrorMsg] [nvarchar](2000) NULL,
	[LineNbr] [int] NOT NULL,
	[ImportUser] [uniqueidentifier] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
 CONSTRAINT [PK_HospitalPositionUpload] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



