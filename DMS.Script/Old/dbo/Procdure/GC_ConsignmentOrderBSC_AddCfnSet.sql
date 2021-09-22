DROP Procedure [dbo].[GC_ConsignmentOrderBSC_AddCfnSet]
GO

CREATE Procedure [dbo].[GC_ConsignmentOrderBSC_AddCfnSet]
 @PohId uniqueidentifier,
 @DealerId uniqueidentifier,
  @CfnString NVARCHAR(1000),
  @PriceType NVARCHAR (20),
  @RtnVal NVARCHAR(20) OUTPUT,
  @RtnMsg NVARCHAR(1000) OUTPUT
AS
  DECLARE @ErrorCount INTEGER
  DECLARE @CfnsetId uniqueidentifier
  DECLARE @CfnId uniqueidentifier
  DECLARE @ArticleNumber NVARCHAR(200)
  DECLARE @CfnQty nvarchar(200)
  DECLARE @CfnPrice   DECIMAL (18, 6)
  DECLARE @CfnQtyInt INT
  DECLARE @UOM NVARCHAR(200)

	/*将传递进来的CFNID字符串转换成纵表*/
	DECLARE CfnCursor CURSOR FOR 
		  SELECT T1.SET_ID,
		  T2.CSD_CFN_ID,
		  T3.CFN_CustomerFaceNbr,
		  T1.SET_QTY,
		   ISNULL(T4.CFNP_Price,0) as Price,
		  T2.CSD_Default_Quantity,
          T3.CFN_Property3
        FROM (
           SELECT LEFT(VAL,CHARINDEX('|',VAL)-1) AS SET_ID,SUBSTRING(VAL,CHARINDEX('|',VAL)+1,LEN(VAL)-CHARINDEX('|',VAL)) AS SET_QTY
				    FROM dbo.GC_Fn_SplitStringToTable(@CfnString,',') A
           ) T1 INNER JOIN CFNSetDetail T2 ON (T1.SET_ID = T2.CSD_CFNS_ID)
               INNER JOIN CFN T3 ON (T2.CSD_CFN_ID=T3.CFN_ID) LEFT JOIN CFNPrice T4 ON(T3.CFN_ID=T4.CFNP_CFN_ID AND T4. CFNP_PriceType='DealerConsignment' AND T4. CFNP_Group_ID=@DealerId)
 
	DECLARE @Price decimal(18,6)	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
  
	IF (SELECT count(*) FROM (
                  SELECT LEFT(VAL,CHARINDEX('|',VAL)-1) AS SET_ID,SUBSTRING(VAL,CHARINDEX('|',VAL)+1,LEN(VAL)-CHARINDEX('|',VAL)) AS SET_QTY
            				FROM dbo.GC_Fn_SplitStringToTable(@CfnString,',') A
                  ) T1, CFN T2
                  WHERE T1.SET_ID = T2.CFN_ID) > 1
        SET @RtnMsg = @RtnMsg + '只能选择一个设备<BR/>' 
	
  OPEN CfnCursor
	FETCH NEXT FROM CfnCursor INTO @CfnsetId, @CfnId, @ArticleNumber, @CfnQty,@CfnPrice, @CfnQtyInt, @UOM
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF ISNUMERIC(@CfnQty) =0 OR FLOOR(Convert(Decimal(18,6),@CfnQty))<CEILING(Convert(Decimal(18,6),@CfnQty))
        SET @RtnMsg = @RtnMsg + @ArticleNumber + '数量必须是整数<BR/>'      
      ELSE
        IF Convert(INT,Convert(Decimal(18,2),@CfnQty)) = 0 or Convert(INT,Convert(Decimal(18,2),@CfnQty)) < 0
          SET @RtnMsg = @RtnMsg + @ArticleNumber + '数量必须大于0<BR/>'  
        ELSE
          SET @CfnQty = Convert(INT,Convert(Decimal(18,2),@CfnQty))
            
      --检查成套产品是否有比例
      IF len(@RtnMsg) = 0      
        BEGIN
          --检查产品授权
    			IF dbo.GC_Fn_CFN_CheckDealerAuth(@DealerId,@CfnId) = 1
    				BEGIN
						IF EXISTS(  SELECT 1 FROM ConsignmentApplyDetails WHERE CAD_CAH_ID=@PohId AND CAD_CFN_ID=@CfnId)
							BEGIN
								
								UPDATE ConsignmentApplyDetails SET CAD_Qty=(@CfnQty*isnull(@CfnQtyInt,0))+CAD_Qty ,CAD_CFNSet_Id=@CfnsetId
								WHERE CAD_CAH_ID=@PohId AND CAD_CFN_ID=@CfnId
							END
						ELSE
							BEGIN
								INSERT INTO ConsignmentApplyDetails(CAD_ID,CAD_CAH_ID,CAD_CFN_ID,CAD_CFNSet_Id,CAD_UOM,CAD_Qty,CAD_Price,CAD_Actual_Price)
								VALUES(NEWID(),@PohId,@CfnId,@CfnsetId,@UOM,@CfnQty*isnull(@CfnQtyInt,0),@CfnPrice,@CfnPrice)
							END --检查是否可订购
    					
    				END
    			ELSE
    				SET @RtnMsg = @RtnMsg + @ArticleNumber + '授权未通过<BR/>'
        END
			FETCH NEXT FROM CfnCursor INTO @CfnsetId, @CfnId, @ArticleNumber, @CfnQty,@CfnPrice, @CfnQtyInt, @UOM
		END
	CLOSE CfnCursor
	DEALLOCATE CfnCursor
COMMIT TRAN

IF len(@RtnMsg) > 1 
  SET @RtnVal = 'Warn'
SET NOCOUNT OFF
return 1


END TRY
BEGIN CATCH
    SET  NOCOUNT OFF
    ROLLBACK TRAN
    CLOSE CfnCursor
	  DEALLOCATE CfnCursor
    SET @RtnVal = 'Failure'

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


