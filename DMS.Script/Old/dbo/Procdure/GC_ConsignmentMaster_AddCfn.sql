DROP PROCEDURE [dbo].[GC_ConsignmentMaster_AddCfn]
GO


/*
订单批量添加产品
*/
CREATE PROCEDURE [dbo].[GC_ConsignmentMaster_AddCfn]
  @PohId                UNIQUEIDENTIFIER,
   @ProductLineId             UNIQUEIDENTIFIER,
   @CfnString            NVARCHAR (MAX),
   @RtnVal               NVARCHAR (20) OUTPUT,
   @RtnMsg               NVARCHAR (1000) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER
   DECLARE @CfnId   UNIQUEIDENTIFIER
   DECLARE @ArticleNumber   NVARCHAR (200)
   DECLARE @cfnPrice   DECIMAL (18, 6)
   DECLARE @UOM   NVARCHAR (100)
   DECLARE @CurRegNo nvarchar(500)
   DECLARE @CurValidDateFrom datetime 
   DECLARE @CurValidDataTo datetime
   DECLARE @CurManuName nvarchar(500)
   DECLARE @LastRegNo nvarchar(500)
   DECLARE @LastValidDateFrom datetime
   DECLARE @LastValidDataTo datetime
   DECLARE @LastManuName nvarchar(500)
   DECLARE @CurGMKind nvarchar(200)
   DECLARE @CurGMCatalog nvarchar(200)

   /*将传递进来的CFNID字符串转换成纵表*/
   DECLARE
      CfnCursor CURSOR FOR SELECT B.CFN_ID,
                                  B.CFN_CustomerFaceNbr,
                                  --CONVERT (DECIMAL (18, 6), case when A.Col2 = 'null' then 0 else A.Col2 end) AS Price,
                                  CASE WHEN A.Col2 = 'null' OR A.Col2 is null THEN CONVERT (DECIMAL (18, 6),0) ELSE A.Col2 END AS Price,
                                  A.Col3 AS UOM,
                                  REG.CurRegNo,
                                  REG.CurValidDateFrom,
                                  REG.CurValidDataTo,
                                  REG.CurManuName,
                                  REG.LastRegNo,
                                  REG.LastValidDateFrom,
                                  REG.LastValidDataTo,
                                  REG.LastManuName,
                                  REG.CurGMKind,
                                  REG.CurGMCatalog
                                  --select *
                             FROM dbo.GC_Fn_SplitStringToMultiColsTable (
                                     @CfnString,
                                     ',',
                                     '@') A
                                  INNER JOIN CFN B ON (B.CFN_ID = A.COL1)
                                  LEFT join MD.V_INF_UPN_REG AS REG ON (B.CFN_CustomerFaceNbr = REG.CurUPN)

   DECLARE @Price   DECIMAL (18, 6)
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''

      OPEN CfnCursor
      FETCH NEXT FROM CfnCursor
        INTO @CfnId, @ArticleNumber, @cfnPrice, @UOM, @CurRegNo, @CurValidDateFrom, @CurValidDataTo, @CurManuName, 
             @LastRegNo, @LastValidDateFrom, @LastValidDataTo, @LastManuName, @CurGMKind, @CurGMCatalog

      WHILE @@FETCH_STATUS = 0
      BEGIN
  
                     IF EXISTS
                           (SELECT 1
                              FROM ConsignmentCfn,ConsignmentMaster
                             WHERE   CC_CM_ID =  @PohId
                                   AND CC_CFN_ID = @CfnId)
                        UPDATE ConsignmentCfn
                           SET CC_Price = @cfnPrice,
                               CC_Actual_Price=@cfnPrice,
                               CC_Qty = CC_Qty + 1,
                               CC_Amount = (CC_Qty + 1) * @cfnPrice,
                               CC_UOM = @UOM
                         WHERE CC_CM_ID = @PohId AND CC_CFN_ID = @CfnId 
                     ELSE
                        --新增产品，默认数量1
                        INSERT INTO ConsignmentCfn (CC_ID,
                                                         CC_CM_ID, 
                                                         CC_CFN_ID,
                                                         CC_UOM,
                                                         CC_Qty,
                                                         CC_Price,
                                                         CC_Actual_Price,
                                                         CC_Amount
                                                         )
                        VALUES (NEWID (),
                                @PohId,
                                @CfnId,
                                @UOM,
                                1,
                                @cfnPrice,
                                @cfnPrice,
                               @cfnPrice
                                )
          
               

         FETCH NEXT FROM CfnCursor
           INTO @CfnId, @ArticleNumber, @cfnPrice, @UOM, @CurRegNo, @CurValidDateFrom, @CurValidDataTo, @CurManuName, 
                @LastRegNo, @LastValidDateFrom, @LastValidDataTo, @LastManuName, @CurGMKind, @CurGMCatalog
      END

      CLOSE CfnCursor
      DEALLOCATE CfnCursor

      
      COMMIT TRAN

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @RtnVal = 'Failure'
      RETURN -1
   END CATCH

GO


