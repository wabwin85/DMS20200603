DROP view [interface].[V_I_CR_SalesStatistics]
GO



/****** Script for SelectTopNRows command from SSMS  ******/
	CREATE view [interface].[V_I_CR_SalesStatistics]
	as
	SELECT a.[DMA_SAP_Code]
		  ,[StartTime]
		  ,[EndTime]
		  ,[InDueTime]
		  ,PCT_Name as Division
	  FROM [BSC_Prd].[interface].[T_I_CR_SalesStatistics] a
	   join DealerMaster b on a.DMA_SAP_Code=b.DMA_SAP_Code
	   join DealerAuthorizationTable d  on d.DAT_DMA_ID =b.DMA_ID
	   left join PartsClassification c
	   on d.DAT_PMA_ID = c.PCT_ID or d.DAT_PMA_ID =c .PCT_ProductLine_BUM_ID
	   left join DealerContract on  DCL_ID=DAT_DCL_ID
	where PCT_Name not like '%Share%'and DMA_ActiveFlag=1
	      --AND getdate () BETWEEN DCL_STARTDATE AND dcl_stopdate


GO


