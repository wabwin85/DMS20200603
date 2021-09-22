CREATE TABLE dbo.DealerPriceInitLog(
			[DPI_ID] [uniqueidentifier] NOT NULL,
      [DPI_DPH_ID] [uniqueidentifier] NOT NULL,
			[DPI_USER] [uniqueidentifier] NOT NULL,
			[DPI_UploadDate] [datetime] NOT NULL,
			[DPI_LineNbr] [int] NOT NULL,
			[DPI_FileName] [nvarchar](200) NOT NULL,
			[DPI_ErrorFlag] [bit] NOT NULL,
			[DPI_ErrorDescription] [nvarchar](100) NULL,
			[DPI_LP_ID] [uniqueidentifier] NOT NULL,
			[DPI_ArticleNumber] [nvarchar](30) NULL,
			[DPI_ArticleNumber_ErrMsg] [nvarchar](100) NULL,
			[DPI_CFN_ID] [uniqueidentifier] NULL,
			[DPI_Dealer] [nvarchar](50) NULL,
			[DPI_Dealer_ErrMsg] [nvarchar](100) NULL,
			[DPI_DMA_ID] [uniqueidentifier] NULL,
			[DPI_Price] [nvarchar](100) NULL,
			[DPI_Price_ErrMsg] [nvarchar](100) NULL,
			[DPI_PriceTypeName] [nvarchar](20) NULL,
			[DPI_PriceTypeName_ErrMsg] [nvarchar](100) NULL,
			[DPI_PriceType] [nvarchar](20) NULL,
			[DPI_CreateDate] datetime NOT NULL
	    )
CREATE INDEX IDX_DealerPriceInitLog_DPH_ID on dbo.DealerPriceInitLog(DPI_DPH_ID)
