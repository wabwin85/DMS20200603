
CREATE TABLE [DealerMasterDD](
	[DMDD_ID] [uniqueidentifier] NOT NULL,
	[DMDD_ContractID] [uniqueidentifier] NULL,
	[DMDD_ReportName] [nvarchar](200) NULL,
	[DMDD_StartDate] [datetime] NULL,
	[DMDD_EndDate] [datetime] NULL,
	[DMDD_DealerID] [uniqueidentifier] NULL,
	[DMDD_CreateUser] [nvarchar](50) NULL,
	[DMDD_CreateDate] [datetime] NULL,
	[DMDD_UpdateUser] [nvarchar](50) NULL,
	[DMDD_UpdateDate] [datetime] NULL,
	[DMDD_DD] [nvarchar](500) NULL,
 CONSTRAINT [PK_DealerMasterDD] PRIMARY KEY CLUSTERED 
(
	[DMDD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO