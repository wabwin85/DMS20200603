DROP view [interface].[V_I_QV_SalesStatisticsCurrent]
GO

CREATE view [interface].[V_I_QV_SalesStatisticsCurrent]
as		
    select
			ID= NEWID()
			,DealerID= DMA_Id
			,StartTime=[StartTime]
			,EndTime=[EndTime]
			,InDueTime=[InDueTime]
			,Division=isnull( (CASE WHEN DAT_PMA_ID = DAT_ProductLine_BUM_ID THEN NULL          
ELSE (SELECT PCT_Name FROM PartsClassification WHERE DAT_PMA_ID = PCT_ID
)  END ),
(SELECT P. ATTRIBUTE_NAME FROM View_ProductLine AS P WHERE P .ID =
DAT_ProductLine_BUM_ID)
) 
          ,Divisionid=isnull( (CASE WHEN DAT_PMA_ID = DAT_ProductLine_BUM_ID THEN NULL          
ELSE (SELECT PCT_ID FROM PartsClassification WHERE DAT_PMA_ID = PCT_ID
)  END ),
(SELECT Id FROM View_ProductLine AS P WHERE P .ID =
DAT_ProductLine_BUM_ID)
) 
			,[dbo].[fn_GetPurchaseCount2](DMA_ID,EndTime) IsPurchased
  FROM [interface].[T_I_CR_SalesStatisticsCurrent](nolock) a
	 left  join DealerMaster (nolock) b on a.DMA_SAP_Code=b.DMA_SAP_Code
	   join DealerAuthorizationTable(nolock) d  on d.DAT_DMA_ID =b.DMA_ID
	    left join DealerContract (nolock) on  DCL_ID=DAT_DCL_ID
	where 
   DMA_ActiveFlag=1 and DMA_DeletedFlag=0
     and DCL_StopDate>=getdate()
     and DAT_PMA_ID  not in ('0a3b34da-43d6-4fed-b62b-a253010d7dd0','a2cf5034-52ca-4f7e-b6f7-a26700e82bd9','C3A82E41-8248-4B75-A58C-A348017D9901')










GO


