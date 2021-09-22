DROP Procedure [dbo].[GC_ConsignmentOrderBSC_AddCfnInventory]
GO

CREATE Procedure [dbo].[GC_ConsignmentOrderBSC_AddCfnInventory]
@PohId uniqueidentifier,
@DealerId uniqueidentifier,
@CfnString NVARCHAR(1000),
@RtnVal NVARCHAR(20) OUTPUT,
@RtnMsg NVARCHAR(1000) OUTPUT
AS
DECLARE @ErrorCount INTEGER
DECLARE @CfnId uniqueidentifier
DECLARE @UOM NVARCHAR(50)
DECLARE @Qty INT
DECLARE @cfnPrice   DECIMAL (18, 6)
DECLARE @LotNumber NVARCHAR(200)
DECLARE @IAHID uniqueidentifier
DECLARE @IALID uniqueidentifier
	/*�����ݽ�����CFNID�ַ���ת�����ݱ�*/
	DECLARE CfnCursor CURSOR FOR 
	SELECT
	T5.CFN_ID,
	T5.CFN_Property3,
	T3.IAL_LotQty,
	ISNULL(T6.CFNP_Price,0) as Price,
	T3.IAL_LotNumber,
	T1.VAL,
	T3.IAL_ID
	FROM (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@CfnString,',') A
           ) T1 INNER JOIN InventoryAdjustDetail T2 ON(T1.VAL=T2.IAD_IAH_ID)
           INNER JOIN InventoryAdjustLot T3 ON(T2.IAD_ID = T3.IAL_IAD_ID)
           INNER JOIN Product T4  ON (T4.PMA_ID = T2.IAD_PMA_ID)
           INNER JOIN CFN T5 ON (T5.CFN_ID = T4.PMA_CFN_ID)
           LEFT JOIN CFNPrice T6 ON(T5.CFN_ID=T6.CFNP_CFN_ID AND T6. CFNP_PriceType='DealerConsignment' AND T6. CFNP_Group_ID=@DealerId)
           DECLARE @Price decimal(18,6)
           SET NOCOUNT ON
           BEGIN 
           TRY
           BEGIN TRAN
           SET @RtnVal = 'Success'
	       SET @RtnMsg = ''
	       IF((SELECT COUNT(*) FROM dbo.GC_Fn_SplitStringToTable(@CfnString,',') A) >1)
	       SET @RtnMsg=@RtnMsg+'ֻ��ѡ��һ���˻���<BR/>'
	       /*ɾ��ԭ�ж���*/
	       DELETE ConsignmentApplyDetails WHERE CAD_CAH_ID=@PohId 
	       
	       OPEN CfnCursor
	       FETCH NEXT FROM CfnCursor
	       INTO @CfnId,@UOM,@Qty,@cfnPrice,@LotNumber,@IAHID,@IALID
	       	WHILE @@FETCH_STATUS = 0
	       	BEGIN
	       	IF (ISNUMERIC(@Qty)<=0)
              SET @RtnMsg = @RtnMsg  + '�����������0<BR/>'
            ELSE
              SET @Qty = Convert(INT,Convert(Decimal(18,2),@Qty))
              IF len(@RtnMsg) = 0      
        BEGIN
          --����Ʒ��Ȩ
    			IF dbo.GC_Fn_CFN_CheckDealerAuth(@DealerId,@CfnId) = 1
    				BEGIN
								/*��Ӷ�����ϸ��Ϣ*/
							
						INSERT INTO ConsignmentApplyDetails(CAD_ID,CAD_CAH_ID,CAD_CFN_ID,CAD_UOM,CAD_Qty,CAD_Price,CAD_Actual_Price, CAD_LotNumber,CAD_IAH_ID,CAD_IAL_ID)
						VALUES(NEWID(),@PohId,@CfnId,@UOM,@Qty,@cfnPrice,@cfnPrice,@LotNumber,@IAHID,@IALID)
							END
						
    					
    				
    			ELSE
    				SET @RtnMsg = @RtnMsg + '��Ȩδͨ��<BR/>'
        END
			FETCH NEXT FROM CfnCursor INTO @CfnId, @UOM, @Qty,@cfnPrice, @LotNumber,@IAHID,@IALID
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

    --��¼������־��ʼ
    DECLARE @error_line   INT
    DECLARE @error_number   INT
    DECLARE @error_message   NVARCHAR (256)
    DECLARE @vError   NVARCHAR (1000)
    SET @error_line = ERROR_LINE ()
    SET @error_number = ERROR_NUMBER ()
    SET @error_message = ERROR_MESSAGE ()
    SET @vError =
             '��'
           + CONVERT (NVARCHAR (10), @error_line)
           + '����[�����'
           + CONVERT (NVARCHAR (10), @error_number)
           + '],'
           + @error_message
    SET @RtnMsg = @vError
    RETURN -1
END CATCH

GO


