DROP Procedure [dbo].[GC_PurchaseOrder_AddCfn]
GO

/*
����������Ӳ�Ʒ
*/
CREATE Procedure [dbo].[GC_PurchaseOrder_AddCfn]
    @PohId uniqueidentifier,
	@DealerId uniqueidentifier,
	@CfnString NVARCHAR(1000),
    @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
AS
    DECLARE @ErrorCount INTEGER
	DECLARE @CfnId uniqueidentifier
	DECLARE @ArticleNumber NVARCHAR(200)
	/*�����ݽ�����CFNID�ַ���ת�����ݱ�*/
	DECLARE CfnCursor CURSOR FOR 
		SELECT B.CFN_ID,B.CFN_CustomerFaceNbr 
		FROM dbo.GC_Fn_SplitStringToTable(@CfnString,',') A
		INNER JOIN CFN B ON B.CFN_ID = A.VAL
	DECLARE @Price decimal(18,6)	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	OPEN CfnCursor
	FETCH NEXT FROM CfnCursor INTO @CfnId,@ArticleNumber
	WHILE @@FETCH_STATUS = 0
		BEGIN
			--����Ʒ��Ȩ
			IF dbo.GC_Fn_CFN_CheckDealerAuth(@DealerId,@CfnId) = 1
				BEGIN
					--����Ƿ�ɶ���
					IF dbo.GC_Fn_CFN_CheckDealerCanOrder(@DealerId,@CfnId) = 1
						BEGIN
							--ȡ�ò�Ʒ��׼����
							--SELECT @Price = CFNP_Price FROM CFNPrice WHERE CFNP_CFN_ID = @CfnId AND CFNP_PriceType = 'Base' AND CFNP_DeletedFlag = 0						
							SELECT @Price = dbo.fn_GetPriceByDealerForPO(@DealerId,@CfnId)
							--����Ʒ�Ƿ��Ѿ����
							IF EXISTS (SELECT 1 FROM PurchaseOrderDetail WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId)
								--���Ѿ���Ӹò�Ʒ������ݵ��ۺ�����������С�Ƽ�˰��С��
								UPDATE PurchaseOrderDetail 
									SET POD_CFN_Price = @Price,
										POD_RequiredQty = POD_RequiredQty + 1,
										POD_Amount = (POD_RequiredQty + 1) * @Price,
										POD_Tax = (POD_RequiredQty + 1) * @Price * 0.17
								WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId
							ELSE
								--������Ʒ��Ĭ������1
								INSERT INTO PurchaseOrderDetail(POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_UOM,POD_RequiredQty,POD_Amount,POD_Tax,POD_ReceiptQty)
								VALUES (NEWID(),@PohId,@CfnId,@Price,NULL,1,@Price,@Price*0.17,0)
						END
					ELSE
						SET @RtnMsg = @RtnMsg + @ArticleNumber + '���ɶ���<BR/>'
				END
			ELSE
				SET @RtnMsg = @RtnMsg + @ArticleNumber + '��Ȩδͨ��<BR/>'
			FETCH NEXT FROM CfnCursor INTO @CfnId,@ArticleNumber
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


