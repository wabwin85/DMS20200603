DROP PROCEDURE [dbo].[GC_ProductAlertInvLevel_Update]
GO

/*
每月统计一次，用于计算警戒库存使用的产品分类
*/

CREATE PROCEDURE [dbo].[GC_ProductAlertInvLevel_Update]
   @UpdateDate Datetime,
   @IsValid NVARCHAR (20) OUTPUT, 
   @RtnMsg NVARCHAR (MAX) OUTPUT
AS
   DECLARE @Mon01 nvarchar(6)
   DECLARE @Mon02 nvarchar(6)
   DECLARE @Mon03 nvarchar(6)
   DECLARE @Mon04 nvarchar(6)
   DECLARE @Mon05 nvarchar(6)
   DECLARE @Mon06 nvarchar(6)   
   DECLARE @SumCOGS Decimal (18,2)
   DECLARE @ErrorCount   INTEGER


   BEGIN TRY
      BEGIN TRAN
      SET @IsValid = 'Success'
      SET @RtnMsg = ''
      
      --创建临时表
      CREATE TABLE #tmpCFNLevel
      (
         [CFN_ID]    UNIQUEIDENTIFIER NOT NULL,
         [Mon01_Qty]     Decimal (18,2) NULL,
         [Mon02_Qty]     Decimal (18,2) NULL,
         [Mon03_Qty]     Decimal (18,2) NULL,
         [Mon04_Qty]     Decimal (18,2) NULL,
         [Mon05_Qty]     Decimal (18,2) NULL,
         [Mon06_Qty]     Decimal (18,2) NULL,
         [Total_Qty]     Decimal (18,2) NULL,
         [LBM]           Decimal (18,2) NULL,
         [Total_COGS]    Decimal (18,2) NULL,
         [COGS_Rate]     Decimal (18,6) NULL,
         [COGS_Cum]      Decimal (18,6) NULL,
         [COGS_Level]    NVARCHAR (50) NULL,
         [Sales_Freq]    INT NULL,
         [Sales_Level]   NVARCHAR (50) NULL,
         [CFN_Level]     NVARCHAR (50) NULL,
         PRIMARY KEY (CFN_ID)
      )
      
      
      --如果传入的参数为空，则使用当前时间
      IF @UpdateDate IS NULL
         Set @UpdateDate = getdate()
      
      --根据UpdateDate获取Month01~Month06的值
      select @Mon06 = substring (CONVERT (NVARCHAR (100), dateadd(month,-1,@UpdateDate), 112),1,6)
      select @Mon05 = substring (CONVERT (NVARCHAR (100), dateadd(month,-2,@UpdateDate), 112),1,6)
      select @Mon04 = substring (CONVERT (NVARCHAR (100), dateadd(month,-3,@UpdateDate), 112),1,6)
      select @Mon03 = substring (CONVERT (NVARCHAR (100), dateadd(month,-4,@UpdateDate), 112),1,6)
      select @Mon02 = substring (CONVERT (NVARCHAR (100), dateadd(month,-5,@UpdateDate), 112),1,6)
      select @Mon01 = substring (CONVERT (NVARCHAR (100), dateadd(month,-6,@UpdateDate), 112),1,6)
      
      --销售看销售时间SPH_ShipmentDate  冲红是看最后审批通过时间（updateDate）,写入临时表
      INSERT INTO #tmpCFNLevel(CFN_ID,Mon01_Qty,Mon02_Qty,Mon03_Qty,Mon04_Qty,Mon05_Qty,Mon06_Qty,Total_Qty,Total_COGS)
      SELECT PMA_CFN_ID,
             Convert(decimal(18,2),sum(mth01)),
             Convert(decimal(18,2),sum(mth02)),
             Convert(decimal(18,2),sum(mth03)),
             Convert(decimal(18,2),sum(mth04)),
             Convert(decimal(18,2),sum(mth05)),
             Convert(decimal(18,2),sum(mth06)),
             Convert(decimal(18,2),sum(Total)),
             Convert(decimal(18,2),sum(totalCOGS))
      FROM
      (SELECT PMA_CFN_ID,
             CASE WHEN FeeCalendar = @Mon01 THEN sum (Qty) ELSE 0 END AS mth01,
             CASE WHEN FeeCalendar = @Mon02 THEN sum (Qty) ELSE 0 END AS mth02,
             CASE WHEN FeeCalendar = @Mon03 THEN sum (Qty) ELSE 0 END AS mth03,
             CASE WHEN FeeCalendar = @Mon04 THEN sum (Qty) ELSE 0 END AS mth04,
             CASE WHEN FeeCalendar = @Mon05 THEN sum (Qty) ELSE 0 END AS mth05,
             CASE WHEN FeeCalendar = @Mon06 THEN sum (Qty) ELSE 0 END AS mth06,            
             sum (Qty) AS Total,
             sum (Qty * Price) AS totalCOGS
        FROM (SELECT P.PMA_CFN_ID,
                     substring (CONVERT (NVARCHAR (100), H.SPH_ShipmentDate, 112),1,6) AS FeeCalendar,
                     isnull (L.SPL_ShipmentQty, 0) AS Qty,
                     (SELECT isnull (CFNP_Price, 0)
                        FROM CFNPrice AS CP
                       WHERE     CP.CFNP_PriceType = 'Dealer'
                             AND CP.CFNP_CFN_ID = P.PMA_CFN_ID
                             AND CP.CFNP_Group_ID = H.SPH_Dealer_DMA_ID) AS Price
                FROM ShipmentHeader H
                     INNER JOIN ShipmentLine L ON (H.SPH_ID = L.SPL_SPH_ID)
                     INNER JOIN Product P ON (P.PMA_ID = L.SPL_Shipment_PMA_ID)
               WHERE     H.SPH_Status = 'Complete'
                     AND H.SPH_Type = 'Hospital'
                     AND convert(int,substring(CONVERT (NVARCHAR (100),H.SPH_ShipmentDate, 112),1,6)) <= convert(int,@Mon06)
                     AND convert(int,substring(CONVERT (NVARCHAR (100),H.SPH_ShipmentDate, 112),1,6)) >= convert(int,@Mon01)
                     --AND H.SPH_ShipmentDate BETWEEN '2013-01-01 00:00:00' AND '2013-08-01 00:00:00'
                     ) SI
      GROUP BY PMA_CFN_ID, FeeCalendar
      UNION
      SELECT PMA_CFN_ID,
             CASE WHEN FeeCalendar = @Mon01 THEN -sum (Qty) ELSE 0 END AS mth01,
             CASE WHEN FeeCalendar = @Mon02 THEN -sum (Qty) ELSE 0 END AS mth02,
             CASE WHEN FeeCalendar = @Mon03 THEN -sum (Qty) ELSE 0 END AS mth03,
             CASE WHEN FeeCalendar = @Mon04 THEN -sum (Qty) ELSE 0 END AS mth04,
             CASE WHEN FeeCalendar = @Mon05 THEN -sum (Qty) ELSE 0 END AS mth05,
             CASE WHEN FeeCalendar = @Mon06 THEN -sum (Qty) ELSE 0 END AS mth06,            
             -sum (Qty) AS Total,
             -sum (Qty * Price) AS totalCOGS
        FROM (SELECT P.PMA_CFN_ID,
                     substring (CONVERT (NVARCHAR (100), H.SPH_UpdateDate, 112),1,6) AS FeeCalendar,
                     isnull (L.SPL_ShipmentQty, 0) AS Qty,
                     (SELECT isnull (CFNP_Price, 0)
                        FROM CFNPrice AS CP
                       WHERE     CP.CFNP_PriceType = 'Dealer'
                             AND CP.CFNP_CFN_ID = P.PMA_CFN_ID
                             AND CP.CFNP_Group_ID = H.SPH_Dealer_DMA_ID) AS Price
                FROM ShipmentHeader H
                     INNER JOIN ShipmentLine L ON (H.SPH_ID = L.SPL_SPH_ID)
                     INNER JOIN Product P ON (P.PMA_ID = L.SPL_Shipment_PMA_ID)
               WHERE     H.SPH_Status = 'Reversed'
                     AND H.SPH_Type = 'Hospital'
                     AND convert(int,substring(CONVERT (NVARCHAR (100),H.SPH_UpdateDate, 112),1,6)) <= convert(int,@Mon06)
                     AND convert(int,substring(CONVERT (NVARCHAR (100),H.SPH_UpdateDate, 112),1,6)) >= convert(int,@Mon01)
                     --AND H.SPH_ShipmentDate BETWEEN '2013-01-01 00:00:00' AND '2013-08-01 00:00:00'
                     ) SI
      GROUP BY PMA_CFN_ID, FeeCalendar
      ) AS Sales
      Group By PMA_CFN_ID
      
      --更新临时表的COGS_Rate
      SELECT @SumCOGS =sum (Total_COGS) FROM #tmpCFNLevel
      Update #tmpCFNLevel SET COGS_Rate = Convert(Decimal (18,6),Total_COGS/@SumCOGS)
      
      --更新临时表的COGS_Cum(通过游标来实现)      
      DECLARE @CFNID UNIQUEIDENTIFIER
      DECLARE @COGSRate Decimal (18,6)
      DECLARE @COGSCum Decimal (18,6)
      DECLARE curCOGSRate CURSOR FOR SELECT CFN_ID,COGS_Rate FROM #tmpCFNLevel ORDER BY COGS_Rate DESC
      
      SET @COGSCum = 0
      
      OPEN curCOGSRate
      FETCH NEXT FROM curCOGSRate
        INTO @CFNID, @COGSRate

      WHILE (@@fetch_status <> -1)
      BEGIN
         IF (@@fetch_status <> -2)
            BEGIN
               SET @COGSCum = @COGSCum + @COGSRate
               UPDATE #tmpCFNLevel SET COGS_Cum = @COGSCum WHERE CFN_ID = @CFNID
            END
         FETCH NEXT FROM curCOGSRate
           INTO @CFNID, @COGSRate
      END
      CLOSE curCOGSRate
      DEALLOCATE curCOGSRate
      
      --根据规则更新COGS_Level
      UPDATE #tmpCFNLevel SET COGS_Level = CASE WHEN COGS_Cum <= 0.8 THEN 'A' 
                                                WHEN COGS_Cum >= 0.95 THEN 'C'
                                                ELSE 'B' END
                                                
      --更新Sales_Freq
      UPDATE #tmpCFNLevel SET Sales_Freq = CASE WHEN Mon01_Qty > 0 THEN 1 ELSE 0 END + 
                                           CASE WHEN Mon02_Qty > 0 THEN 1 ELSE 0 END +
                                           CASE WHEN Mon03_Qty > 0 THEN 1 ELSE 0 END +
                                           CASE WHEN Mon04_Qty > 0 THEN 1 ELSE 0 END +
                                           CASE WHEN Mon05_Qty > 0 THEN 1 ELSE 0 END +
                                           CASE WHEN Mon06_Qty > 0 THEN 1 ELSE 0 END
                                               
                                                
      --根据规则更新COGS_Level
      UPDATE #tmpCFNLevel SET Sales_Level = CASE WHEN Sales_Freq > 4 THEN 'A' 
                                                 WHEN Sales_Freq < 3 THEN 'C'
                                                 ELSE 'B' END
                                                 
      --更新CFN_Level
      UPDATE #tmpCFNLevel SET CFN_Level = COGS_Level + Sales_Level
      
      --更新CFN表
      update CFN set CFN_Property1 = 'B'
      
      UPDATE t1 SET t1.CFN_Property1 = 'A'
      FROM CFN t1,#tmpCFNLevel t2
      WHERE t1.CFN_ID = t2.CFN_ID AND t2.CFN_Level = 'AA'
      select * from #tmpCFNLevel
      COMMIT TRAN

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @IsValid = 'Failure'

      --记录错误日志开始
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError =
               '行'
             + CONVERT (NVARCHAR (10), @error_line)
             + '出错[错误号'
             + CONVERT (NVARCHAR (10), @error_number)
             + '],'
             + @error_message
      SET @RtnMsg = @vError
     
      RETURN -1
   END CATCH
GO


