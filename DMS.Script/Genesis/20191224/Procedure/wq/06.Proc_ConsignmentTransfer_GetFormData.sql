
/****** Object:  StoredProcedure [Workflow].[Proc_ConsignmentTransfer_GetFormData]    Script Date: 2019/12/16 10:11:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Workflow].[Proc_ConsignmentTransfer_GetFormData]
	@InstanceId UNIQUEIDENTIFIER,
	   @SubCompanyId NVARCHAR(50),
   @BrandId NVARCHAR(50)
AS

DECLARE @UsdRate DECIMAL(18,2)
SELECT @UsdRate = Rate FROM interface.V_MDM_ExchangeRate

--SELECT A.TH_No AS RequestNo,E.DMA_DealerType AS DealerType,D.DivisionCode AS Bu,
--sum(isnull(C.TC_QTY,0)*isnull(dbo.fn_GetCfnPriceByDealer(A.TH_DMA_ID_To, P.PMA_CFN_ID, @SubCompanyId, @BrandId, 'DealerConsignment', 0),0)) as TotalAmountRMB,
--cast((sum(isnull(C.TC_QTY,0)*isnull(dbo.fn_GetCfnPriceByDealer(A.TH_DMA_ID_To, P.PMA_CFN_ID, @SubCompanyId, @BrandId, 'DealerConsignment', 0),0))*(cast(isnull(@UsdRate,1) AS decimal(18,2)))) as decimal(18,2)) as TotalAmountUSD
--from Consignment.TransferHeader a
--INNER JOIN Consignment.TransferDetail b ON A.TH_ID=B.TD_TH_ID
--INNER JOIN Consignment.TransferConfirm c ON C.TC_TD_ID=B.TD_ID
--INNER JOIN DealerMaster E ON E.DMA_ID=A.TH_DMA_ID_To 
--INNER JOIN Product P ON P.PMA_ID=C.TC_PMA_ID 
--LEFT JOIN CFNPrice H ON H.CFNP_CFN_ID=P.PMA_CFN_ID AND H.CFNP_Group_ID=A.TH_DMA_ID_To AND H.CFNP_PriceType='DealerConsignment'
--left join  V_DivisionProductLineRelation d on d.ProductLineID= a.TH_ProductLine_BUM_ID AND D.IsEmerging='0'
--where A.TH_ID=@InstanceId
--group by TH_No,DMA_DealerType,DivisionCode

select 1 'NoData'




