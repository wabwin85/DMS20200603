DROP FUNCTION [interface].[fn_I_EW_GoodsReturn_TmpTest]
GO

CREATE FUNCTION [interface].[fn_I_EW_GoodsReturn_TmpTest] ()
   RETURNS @re TABLE
               (
                  DMA_ID              UNIQUEIDENTIFIER NULL,
                  ReturnNo            NVARCHAR (30) NULL,
                  ReturnDate          DATETIME NULL,
                  SapCode             NVARCHAR (50),
                  DealerName          NVARCHAR (50),
                  Parent_DMA_ID       UNIQUEIDENTIFIER,
                  ParentCode          NVARCHAR (50),
                  ParentName          NVARCHAR (200),
                  Remark              NVARCHAR (2000) NULL,
                  WarehouseCode       NVARCHAR (50) NULL,
                  WarehouseName       NVARCHAR (50) NULL,
                  UPN                 NVARCHAR (50) NULL,
                  Description         NVARCHAR (200) NULL,
                  Lot                 NVARCHAR (50) NULL,
                  ExpDate             DATETIME NULL,
                  UnitPrice           DECIMAL (18, 6) NULL,
                  Qty                 DECIMAL (18, 6) NULL,
                  LastMonthSales      DECIMAL (18, 6) NULL,
                  ThisMonthReturned   DECIMAL (18, 6) NULL,
                  DistributorLevel    NVARCHAR (20) NULL,
                  ToDealerId          UNIQUEIDENTIFIER NULL,
                  ToSapCode           NVARCHAR (50) NULL,
                  ToDealerName        NVARCHAR (50) NULL
               )
AS
   BEGIN
      INSERT INTO @re
         SELECT IAH_DMA_ID,
                IAH_Inv_Adj_Nbr,
                IAH_ApprovalDate,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                IAH_UserDescription,
                WHM_CODE,
                WHM_Name,
                CFN_CustomerFaceNbr,
                CFN_Description,
                t3.IAL_LotNumber,
                (CASE
                    WHEN t5.CFN_Property6 = '1'
                    THEN
                       t3.IAL_ExpiredDate
                    ELSE
                       dateadd (
                          dd,
                          -day (dateadd (month, 1, t3.IAL_ExpiredDate)),
                          dateadd (month, 1, t3.IAL_ExpiredDate))
                 END),
                isnull (t6.CFNP_Price, (select isnull(UnitPrice,0) from  interface.V_I_EW_DealerLastedMaintainedPrice where CustomerSapCode = DM.DMA_SAP_Code and UPN = t4.PMA_UPN  )) AS CFNP_Price,
                t3.IAL_LotQty,
                0,
                0,
                '',
                t3.IAL_DMA_ID,
                NULL,
                NULL
           FROM InventoryAdjustHeader t1(nolock)
                INNER JOIN InventoryAdjustDetail t2(nolock) ON t1.IAH_ID = t2.IAD_IAH_ID
                INNER JOIN DealerMaster DM(nolock) ON  DM.DMA_ID = t1.IAH_DMA_ID 
                INNER JOIN InventoryAdjustLot t3(nolock) ON t2.IAD_ID = t3.IAL_IAD_ID
                INNER JOIN Product t4(nolock) ON t2.IAD_PMA_ID = t4.PMA_ID
                INNER JOIN CFN t5(nolock) ON t4.PMA_CFN_ID = t5.CFN_ID
                INNER JOIN Warehouse t7(nolock) ON IAL_WHM_ID = WHM_ID
                LEFT JOIN CFNPrice t6(nolock)
                   ON     t1.IAH_DMA_ID = t6.CFNP_Group_ID
                      AND t5.CFN_ID = t6.CFNP_CFN_ID
                      AND t6.CFNP_PriceType =
                             (CASE
                                 WHEN WHM_Type IN ('DefaultWH',
                                                   'SystemHold',
                                                   'Normal')
                                 THEN
                                    'Dealer'
                                 ELSE
                                    'DealerConsignment'
                              END)
          WHERE     IAH_Reason IN ('Return', 'Exchange', 'Transfer')
                --AND IAH_Status = 'Submitted'

      --AND NOT EXISTS (SELECT 1 FROM PurchaseOrderLog WHERE PurchaseOrderLog.POL_POH_ID = t1.IAH_ID
      --AND PurchaseOrderLog.POL_OperType = 'Approve' AND PurchaseOrderLog.POL_OperNote = 'eWorkflowÃ·ΩªÕÀªı…Í«Î')

     
      UPDATE @re
         SET LastMonthSales = t2.Amount
        FROM (SELECT SPH_Dealer_DMA_ID,
                     SUM (SLT_UnitPrice * SLT_LotShippedQty) AS Amount
                FROM ShipmentHeader(nolock)
                     INNER JOIN ShipmentLine(nolock) ON SPH_ID = SPL_SPH_ID
                     INNER JOIN ShipmentLot(nolock) ON SPL_ID = SLT_SPL_ID
               WHERE     SPH_Status IN ('Complete', 'Reversed')
                     AND CONVERT (NVARCHAR (6), SPH_SubmitDate, 112) =
                            CONVERT (NVARCHAR (6),
                                     dateadd (mm, -1, GETDATE ()),
                                     112)
              GROUP BY SPH_Dealer_DMA_ID) t2
       WHERE DMA_ID = t2.SPH_Dealer_DMA_ID
      

      UPDATE @re
         SET ThisMonthReturned = 0
        FROM (SELECT IAH_DMA_ID,
                     sum (t6.CFNP_Price * IAD_Quantity) AS ThisMonthReturned
                FROM InventoryAdjustHeader t1(nolock)
                     INNER JOIN InventoryAdjustDetail t2(nolock)
                        ON t1.IAH_ID = t2.IAD_IAH_ID
                     INNER JOIN InventoryAdjustLot t3(nolock)
                        ON t2.IAD_ID = t3.IAL_IAD_ID
                     INNER JOIN Product t4(nolock) ON t2.IAD_PMA_ID = t4.PMA_ID
                     INNER JOIN CFN t5(nolock) ON t4.PMA_CFN_ID = t5.CFN_ID
                     INNER JOIN CFNPrice t6(nolock)
                        ON     t1.IAH_DMA_ID = t6.CFNP_Group_ID
                           AND t5.CFN_ID = t6.CFNP_CFN_ID
                     INNER JOIN Warehouse t7(nolock) ON IAL_WHM_ID = WHM_ID
               WHERE     IAH_Reason = 'Return'
                     --AND IAH_Status = 'Uploaded'
                     AND CONVERT (NVARCHAR (6), IAH_ApprovalDate, 112) =
                            CONVERT (NVARCHAR (6), GETDATE (), 112)
              GROUP BY IAH_DMA_ID) t2
       WHERE DMA_ID = t2.IAH_DMA_ID

      UPDATE R
         SET R.SapCode = D.DMA_SAP_CODE,
             R.DealerName = D.DMA_ChineseName,
             R.Parent_DMA_ID =
                (CASE
                    WHEN D.DMA_DealerType = 'T2' THEN D.DMA_Parent_DMA_ID
                    ELSE NULL
                 END)
        FROM DealerMaster D(nolock), @re R
       WHERE D.DMA_ID = R.DMA_ID

      UPDATE R
         SET R.ParentCode = D.DMA_SAP_CODE, R.ParentName = D.DMA_ChineseName
        FROM DealerMaster D(nolock), @re R
       WHERE D.DMA_ID = R.Parent_DMA_ID

      UPDATE @re
         SET ParentCode = SapCode, ParentName = DealerName
       WHERE Parent_DMA_ID IS NULL

      UPDATE @re
         SET ToSapCode = DMA_SAP_Code, ToDealerName = DMA_ChineseName
        FROM DealerMaster A
       WHERE A.DMA_ID = ToDealerId

      RETURN
   END
GO


