DROP  PROCEDURE [dbo].[GC_PurchaseOrderBSCPRO_AddCfn]
GO

/*
��������������Ӳ�Ʒ 
*/
CREATE PROCEDURE [dbo].[GC_PurchaseOrderBSCPRO_AddCfn]
   @PohId                UNIQUEIDENTIFIER,
   @DealerId             UNIQUEIDENTIFIER,
   @CfnString            NVARCHAR (MAX),
   @CfnCheckString            NVARCHAR (MAX),
   @DealerType           NVARCHAR (100),
   @OrderType            NVARCHAR (20),
   @SpecialPriceId       NVARCHAR (100),
   @RtnVal               NVARCHAR (20) OUTPUT,
   @RtnMsg               NVARCHAR (1000) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER
   DECLARE @CfnId   UNIQUEIDENTIFIER
   DECLARE @ArticleNumber   NVARCHAR (200)
   DECLARE @cfnPrice   DECIMAL (18, 6)
   DECLARE @UOM   NVARCHAR (100)
   CREATE TABLE #Temp(
	   CFNID UNIQUEIDENTIFIER,
	   DLid INT ,
	   CFNName NVARCHAR(200)
   )
   DECLARE @CheckUPNHs   INT
   DECLARE @CheckUPN  BIT
   DECLARE @CFNName   NVARCHAR (100)
   DECLARE @DLid1   NVARCHAR (100)
   DECLARE @DLid2   NVARCHAR (100)
   
   /*�����ݽ�����CFNID�ַ���ת�����ݱ�*/
   DECLARE
      CfnCursor CURSOR FOR SELECT B.CFN_ID,
                                  B.CFN_CustomerFaceNbr,
                                  CONVERT (DECIMAL (18, 6), A.Col2) AS Price,
                                  A.Col3 AS UOM
                             FROM dbo.GC_Fn_SplitStringToMultiColsTable (
                                     @CfnString,
                                     ',',
                                     '@') A
                                  INNER JOIN CFN B ON B.CFN_ID = A.COL1

   DECLARE @Price   DECIMAL (18, 6)
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''
      
      INSERT INTO #Temp(CFNID,DLid,CFNName)
	  SELECT B.CFN_ID,A.ColB AS DLid,B.CFN_CustomerFaceNbr 
		FROM [Promotion].[func_Pro_Utility_getStringSplit](@CfnCheckString) A
		INNER JOIN CFN B ON B.CFN_ID = A.ColA

      OPEN CfnCursor
      FETCH NEXT FROM CfnCursor
        INTO @CfnId, @ArticleNumber, @cfnPrice, @UOM

      WHILE @@FETCH_STATUS = 0
      BEGIN
		 --�����ѡ��Ʒ�ڱ��ζ�����ʹ���������Ͳ�Ʒ��
		 SET @CheckUPN=1;
		 SET @CFNName='';
		 SELECT @CheckUPNHs=COUNT(*) FROM #Temp A 
		 INNER JOIN PurchaseOrderDetail B ON A.CFNID=B.POD_CFN_ID AND B.POD_POH_ID=@PohId
		 WHERE A.CFNID=@CfnId;
		 IF @CheckUPNHs>0 
		 BEGIN
				SELECT @DLid1=A.DLid,@DLid2=B.POD_Field3,@CFNName=a.CFNName FROM #Temp A 
				 INNER JOIN PurchaseOrderDetail B ON A.CFNID=B.POD_CFN_ID AND B.POD_POH_ID=@PohId
				 WHERE A.CFNID=@CfnId
				 IF @DLid1<>@DLid2
				 BEGIN
					SET @CheckUPN=0;
				 END
		 END
	
		 IF @CheckUPN=1
		 BEGIN
         --����Ʒ��Ȩ
			 IF dbo.GC_Fn_CFN_CheckDealerAuth (@DealerId, @CfnId) = 1
				BEGIN
				   --����Ƿ�ɶ���
				   --IF dbo.GC_Fn_CFN_CheckDealerCanOrder (@DealerId, @CfnId) = 1
				   --   BEGIN
				   --ȡ�ò�Ʒ��׼����(�۸�Ӳ����л�ȡ)
				   --SELECT @Price = CFNP_Price FROM CFNPrice WHERE CFNP_CFN_ID = @CfnId AND CFNP_PriceType = 'Base' AND CFNP_DeletedFlag = 0
				   --SELECT @Price = dbo.fn_GetPriceByDealerForPO (@DealerId, @CfnId)

				   --����ǽ��Ӷ���������Ҫ���⴦��,����Ҫ�ϲ�
	              
				   IF (@OrderType = 'Transfer' OR @OrderType = 'ClearBorrowManual')
					  BEGIN
						 IF EXISTS
							   (SELECT 1
								  FROM PurchaseOrderDetail
								 WHERE     POD_POH_ID = @PohId
									   AND POD_CFN_ID = @CfnId
									   AND POD_LotNumber IS NULL)
							UPDATE PurchaseOrderDetail
							   SET POD_CFN_Price = @cfnPrice,
								   POD_RequiredQty = POD_RequiredQty + 1,
								   POD_Amount = (POD_RequiredQty + 1) * @cfnPrice,
								   POD_Tax =
									  (POD_RequiredQty + 1) * @cfnPrice * 0,
								   POD_UOM = @UOM
							 WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId AND POD_LotNumber IS NULL
						 ELSE
							--������Ʒ��Ĭ������1
							INSERT INTO PurchaseOrderDetail (POD_ID,
															 POD_POH_ID, 
															 POD_CFN_ID,
															 POD_CFN_Price,
															 POD_UOM,
															 POD_RequiredQty,
															 POD_Amount,
															 POD_Tax,
															 POD_ReceiptQty,
															 POD_Field3)
							VALUES (NEWID (),
									@PohId,
									@CfnId,
									@cfnPrice,
									@UOM,
									1,
									@cfnPrice,
									0,
									0,
									(SELECT TOP 1 DLid FROM #Temp WHERE CFNID=@CfnId))
					  END
				   ELSE IF (@OrderType = 'SpecialPrice')
					BEGIN
						IF EXISTS
							   (SELECT 1
								  FROM PurchaseOrderDetail
								 WHERE     POD_POH_ID = @PohId
									   AND POD_CFN_ID = @CfnId
									   AND POD_CFN_Price = @cfnPrice)
							UPDATE PurchaseOrderDetail
							   SET POD_CFN_Price = @cfnPrice,
								   POD_RequiredQty = POD_RequiredQty + 1,
								   POD_Amount = (POD_RequiredQty + 1) * @cfnPrice,
								   POD_Tax =
									  (POD_RequiredQty + 1) * @cfnPrice * 0,
								   POD_UOM = @UOM
							 WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId AND POD_CFN_Price = @cfnPrice
						 ELSE
							--������Ʒ��Ĭ������1
							INSERT INTO PurchaseOrderDetail (POD_ID,
															 POD_POH_ID, 
															 POD_CFN_ID,
															 POD_CFN_Price,
															 POD_UOM,
															 POD_RequiredQty,
															 POD_Amount,
															 POD_Tax,
															 POD_ReceiptQty,
															 POD_Field3)
							VALUES (NEWID (),
									@PohId,
									@CfnId,
									@cfnPrice,
									@UOM,
									1,
									@cfnPrice,
									0,
									0,
									(SELECT TOP 1 DLid FROM #Temp WHERE CFNID=@CfnId))
					END
				   ELSE
					  BEGIN
						 --����Ʒ�Ƿ��Ѿ����
						 IF EXISTS
							   (SELECT 1
								  FROM PurchaseOrderDetail
								 WHERE     POD_POH_ID = @PohId
									   AND POD_CFN_ID = @CfnId)
							--���Ѿ���Ӹò�Ʒ������ݵ��ۺ�����������С�Ƽ�˰��С��
							UPDATE PurchaseOrderDetail
							   SET POD_CFN_Price = @cfnPrice,
								   POD_RequiredQty = POD_RequiredQty + 1,
								   POD_Amount = (POD_RequiredQty + 1) * @cfnPrice,
								   POD_Tax =
									  (POD_RequiredQty + 1) * @cfnPrice * 0,
								   POD_UOM = @UOM
							 WHERE POD_POH_ID = @PohId AND POD_CFN_ID = @CfnId
						 ELSE
							--������Ʒ��Ĭ������1
							INSERT INTO PurchaseOrderDetail (POD_ID,
															 POD_POH_ID,
															 POD_CFN_ID,
															 POD_CFN_Price,
															 POD_UOM,
															 POD_RequiredQty,
															 POD_Amount,
															 POD_Tax,
															 POD_ReceiptQty,
															 POD_Field3)
							VALUES (NEWID (),
									@PohId,
									@CfnId,
									@cfnPrice,
									@UOM,
									1,
									@cfnPrice,
									0,
									0,
									(SELECT TOP 1 DLid FROM #Temp WHERE CFNID=@CfnId))
					  END
				--END
				--ELSE
				--   SET @RtnMsg = @RtnMsg + @ArticleNumber + '���ɶ���<BR/>'
				END
			 ELSE
				 BEGIN
					SET @RtnVal = 'Error'
					SET @RtnMsg = @RtnMsg + @ArticleNumber + '��Ȩδͨ��<BR/>'
				 END
         END
         ELSE
			BEGIN
				SET @RtnVal = 'Error'
				SET @RtnMsg = @RtnMsg + @CFNName + ' ���ζ�����ʹ��������Ʒ����<BR/>'
			END
         

         FETCH NEXT FROM CfnCursor
           INTO @CfnId, @ArticleNumber, @cfnPrice, @UOM
         
      END

      CLOSE CfnCursor
      DEALLOCATE CfnCursor

      IF (@SpecialPriceId IS NOT NULL AND @SpecialPriceId <> '' and @SpecialPriceId<>'0')
         UPDATE PurchaseOrderHeader
            SET POH_SpecialPriceID = @SpecialPriceId
          WHERE POH_ID = @PohId

      COMMIT TRAN

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @RtnVal = 'Failure'
      
      
      declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	
	set @RtnMsg=@vError
      RETURN -1
   END CATCH
GO


