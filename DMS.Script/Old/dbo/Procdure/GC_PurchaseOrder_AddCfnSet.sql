DROP Procedure [dbo].[GC_PurchaseOrder_AddCfnSet]
GO

/*
����������ӳ��ײ�Ʒ
*/
CREATE Procedure [dbo].[GC_PurchaseOrder_AddCfnSet]
    @PohId uniqueidentifier,
	@DealerId uniqueidentifier,
	@CfnString NVARCHAR(1000),
    @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
AS
    DECLARE @ErrorCount INTEGER
	DECLARE @CfnId uniqueidentifier
	DECLARE @CfnQty decimal(18,6)
	DECLARE @ArticleNumber NVARCHAR(200)
	/*�����ݽ�����CFNID�ַ���ת�����ݱ�*/
	DECLARE CfnCursor CURSOR FOR 
		SELECT C.CFN_ID,C.CFN_CustomerFaceNbr AS ArticleNumber,SUM(S.SET_QTY*D.CSD_Default_Quantity) AS CFN_QTY
		FROM (SELECT 
				LEFT(VAL,CHARINDEX('|',VAL)-1) AS SET_ID,
				CONVERT(DECIMAL(18,6),SUBSTRING(VAL,CHARINDEX('|',VAL)+1,LEN(VAL)-CHARINDEX('|',VAL))) AS SET_QTY
				FROM dbo.GC_Fn_SplitStringToTable(@CfnString,',') A) AS S
		INNER JOIN CFNSetDetail AS D ON D.CSD_CFNS_ID = S.SET_ID
		INNER JOIN CFN C ON C.CFN_ID = D.CSD_CFN_ID
		GROUP BY C.CFN_ID,C.CFN_CustomerFaceNbr
	DECLARE @Price decimal(18,6)	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	OPEN CfnCursor
	FETCH NEXT FROM CfnCursor INTO @CfnId,@ArticleNumber,@CfnQty
	WHILE @@FETCH_STATUS = 0
		BEGIN
			--����Ʒ��Ȩ
			IF dbo.GC_Fn_CFN_CheckDealerAuth(@DealerId,@CfnId) = 1
				BEGIN
					--����Ƿ�ɶ���
					IF dbo.GC_Fn_CFN_CheckDealerCanOrder(@DealerId,@CfnId) = 1
						BEGIN
							--ȡ�ò�Ʒ��׼�۸�
							--SELECT @Price = CFNP_Price FROM CFNPrice WHERE CFNP_CFN_ID = @CfnId AND CFNP_PriceType = 'Base' AND CFNP_DeletedFlag = 0						
							SELECT @Price = dbo.fn_GetPriceByDealerForPO(@DealerId,@CfnId)
							--����Ʒ�Ƿ��Ѿ����
							IF EXISTS (SELECT 1 FROM PurchaseOrderDetail WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId)
								--���Ѿ���Ӹò�Ʒ�����ۼ������ͽ��
								UPDATE PurchaseOrderDetail 
									SET POD_CFN_Price = @Price,
										POD_RequiredQty = POD_RequiredQty + @CfnQty,
										POD_Amount = (POD_RequiredQty + @CfnQty) * @Price,
										POD_Tax = (POD_RequiredQty + @CfnQty) * @Price * 0.17
								WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId
							ELSE
								--������Ʒ��Ĭ������1
								INSERT INTO PurchaseOrderDetail(POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_UOM,POD_RequiredQty,POD_Amount,POD_Tax,POD_ReceiptQty)
								VALUES (NEWID(),@PohId,@CfnId,@Price,NULL,@CfnQty,@CfnQty*@Price,@CfnQty*@Price*0.17,0)
						END
					ELSE
						SET @RtnMsg = @RtnMsg + @ArticleNumber + '���ɶ���<BR/>'
				END
			ELSE
				SET @RtnMsg = @RtnMsg + @ArticleNumber + '��Ȩδͨ��<BR/>'
			FETCH NEXT FROM CfnCursor INTO @CfnId,@ArticleNumber,@CfnQty
		END
	CLOSE CfnCursor
	DEALLOCATE CfnCursor
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    return -1
    
END CATCH
GO


