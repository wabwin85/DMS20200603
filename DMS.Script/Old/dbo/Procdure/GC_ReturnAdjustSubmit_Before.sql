DROP PROCEDURE [dbo].[GC_ReturnAdjustSubmit_Before]
GO


/*ʹ��ҵ��������ͳһ����*/
CREATE PROCEDURE [dbo].[GC_ReturnAdjustSubmit_Before]
	@AdjustId uniqueidentifier,
	@AdjustNo nvarchar(200),
	@AdjustDesc nvarchar(2000),
	@DealerId uniqueidentifier,
	@ProductLineId uniqueidentifier,
	@AdjustType nvarchar(50),
	@ApplyType nvarchar(50),
	@UserId uniqueidentifier,
	@UserName  nvarchar(50),
	@RtnVal nvarchar(50) OUTPUT,
	@RtnMsg nvarchar(2000) OUTPUT 
AS	
SET NOCOUNT ON
BEGIN TRY

	DECLARE @SysUserId uniqueidentifier
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	DECLARE @DealerType NVARCHAR(50)
	DECLARE @OrderStatus NVARCHAR(50)
	
	DECLARE @SubmitBeginDate DATETIME
	DECLARE @SubmitEndDate DATETIME

	DECLARE @ExpBeginDate DATETIME
	DECLARE @ExpEndDate DATETIME
	
	SELECT @DealerType = DMA_DealerType FROM DealerMaster WHERE DMA_ID = @DealerId
	SELECT @OrderStatus = IAH_Status FROM InventoryAdjustHeader WHERE IAH_ID = @AdjustId
	
	----���¼۸�(�ύʱȡ���µļ۸�)
	--IF (@AdjustType = 'Return' OR @AdjustType = 'Exchange') AND @ApplyType = '4'
	--	BEGIN
	--		UPDATE C SET C.IAL_UnitPrice = dbo.fn_GetPriceForDealerRetrun(@DealerId ,PMA_CFN_ID,IAL_LotNumber, @ApplyType) 
	--		FROM InventoryAdjustHeader A
	--		INNER JOIN InventoryAdjustDetail B ON A.IAH_ID = B.IAD_IAH_ID
	--		INNER JOIN InventoryAdjustLot C ON B.IAD_ID = C.IAL_IAD_ID
	--		INNER JOIN Product D ON D.PMA_ID = B.IAD_PMA_ID
	--		WHERE A.IAH_ID = @AdjustId

	--	END
		
		SELECT @SubmitBeginDate = MIN(DRP_SubmitBeginDate),
			@SubmitEndDate = MIN(DRP_SubmitEndDate),
			@ExpBeginDate = MIN(DRP_ExpBeginDate),
			@ExpEndDate = MIN(DRP_ExpEndDate)
			FROM dbo.DealerReturnPosition
			WHERE DRP_IsActived = 1
				--AND DRP_IsInit = 1
				AND DRP_DMA_ID = @DealerId
				AND DRP_BUM_ID = @ProductLineId
				AND DRP_Type In ('��������','��ʼ����')
				AND YEAR(DRP_SubmitBeginDate)=(CASE WHEN datepart(quarter,GETDATE() )>1 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1 END)
				
		--Ŀǰֻ�����˻�����Ϊ������ͬԼ�������ڵġ�������У��
		--���˻�����Ϊ������ͬԼ�������ڵġ��ĵ��ݾ����سɹ�
		--T2�ǲ������С���ͬԼ�������ڵġ��ĵ����ύ��
		--��������0�۸�����޼۸�Ŀ���Ʒ�ύ
		--������δ���ڵĿ���Ʒ�ύ
		--��ƷЧ�ھ��ύ������2���ȼ����ϣ���Ҫ�ϴ������ļ�
		--�ύʱ����������ύ��Χ��
		--�˻���Ʒ��Ч�ڱ�������Ч�ڷ�Χ��
		IF (@AdjustType = 'Return' OR @AdjustType = 'Exchange') AND @ApplyType = '4'
			BEGIN
				IF @OrderStatus != 'Draft'
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '�������ύ����ˢ��ҳ��'
						RETURN 1
					END
				ELSE IF @DealerType = 'T2'
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = 'ֻ������ƽ̨��һ��������'
						RETURN 1
					END
				ELSE IF (SELECT COUNT(1) FROM InventoryAdjustHeader,InventoryAdjustDetail,InventoryAdjustLot 
							WHERE IAH_ID = IAD_IAH_ID AND IAD_ID = IAL_IAD_ID 
							AND IAH_ID = @AdjustId AND ISNULL(IAL_UnitPrice,0) = 0) > 0
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '��������0�۸�����޼۸�Ĳ�Ʒ'
						RETURN 1
					END
				ELSE IF (SELECT COUNT(1) FROM InventoryAdjustHeader,InventoryAdjustDetail,InventoryAdjustLot
							WHERE IAH_ID = IAD_IAH_ID AND IAD_ID = IAL_IAD_ID 
							AND IAH_ID = @AdjustId AND CONVERT(NVARCHAR(10),IAL_ExpiredDate,112) > CONVERT(NVARCHAR(10),GETDATE(),112)) > 0
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '[��ͬԼ�������ڵ�]���˻������뵥��ֻ�����ύ��Ч�ڵĲ�Ʒ'
						RETURN 1
					END
				ELSE IF GETDATE() < @SubmitBeginDate OR GETDATE() > @SubmitEndDate
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '��ǰ�ύʱ�䲻�ں�ͬ���÷�Χ��'
						RETURN 1
					END
				ELSE IF (SELECT COUNT(1) FROM InventoryAdjustHeader,InventoryAdjustDetail,InventoryAdjustLot
							WHERE IAH_ID = IAD_IAH_ID AND IAD_ID = IAL_IAD_ID 
							AND IAH_ID = @AdjustId 
							AND (CONVERT(NVARCHAR(10),IAL_ExpiredDate,112) < CONVERT(NVARCHAR(10),@ExpBeginDate,112)
							OR CONVERT(NVARCHAR(10),IAL_ExpiredDate,112) > CONVERT(NVARCHAR(10),@ExpEndDate,112))) > 0
					BEGIN
						PRINT 'Error'
						SET @RtnVal = 'Error'
						SET @RtnMsg = '��ƷЧ�ڲ��ں�ͬ�涨�ķ�Χ��'
						RETURN 1
					END
				ELSE IF (SELECT COUNT(1) FROM InventoryAdjustHeader,InventoryAdjustDetail,InventoryAdjustLot
							WHERE IAH_ID = IAD_IAH_ID AND IAD_ID = IAL_IAD_ID 
							AND IAH_ID = @AdjustId AND DATEDIFF(QUARTER,IAL_ExpiredDate,GETDATE()) >= 2) > 0
						AND (SELECT COUNT(1) FROM Attachment WHERE AT_Main_ID = @AdjustId AND AT_Type = 'ReturnAdjust') = 0
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '[��ͬԼ�������ڵ�]���˻������뵥�д��ھ��뵱ǰʱ����ڵ���2�����ȵĲ�Ʒ����Ҫ�ϴ������ļ�'
						RETURN 1
					END
				ELSE 
					BEGIN
						--�ܵ��˻���Ƚ��
						DECLARE @TotalAmount DECIMAL(18,6)
						--�˵����ܵ��˻����
						DECLARE @ReturnAmount DECIMAL(18,6)

						SET @TotalAmount = 0
						SET @ReturnAmount = 0

						SELECT @TotalAmount = ISNULL(SUM(ISNULL(DRP_DetailAmount,0)),0) FROM DealerReturnPosition
						WHERE DRP_BUM_ID = @ProductLineId
							AND DRP_DMA_ID = @DealerId
							AND DRP_IsActived = 1

						SELECT @ReturnAmount = ISNULL(SUM(ISNULL(IAL_LotQty,0)*ISNULL(IAL_UnitPrice,0)),0) FROM InventoryAdjustHeader
						INNER JOIN InventoryAdjustDetail ON IAH_ID = IAD_IAH_ID
						INNER JOIN InventoryAdjustLot ON IAD_ID = IAL_IAD_ID
						WHERE IAH_ID = @AdjustId

						IF @TotalAmount < @ReturnAmount
							BEGIN
								SET @RtnVal = 'Error'
								SET @RtnMsg = '�����˻��ܽ������˻����'
								RETURN 1
							END 
						ELSE 
							BEGIN
								INSERT INTO [dbo].[DealerReturnPosition]
										   ([DRP_ID]
										   ,[DRP_DMA_ID]
										   ,[DRP_BUM_ID]
										   ,[DRP_Year]
										   ,[DRP_Quarter]
										   ,[DRP_DetailAmount]
										   ,[DRP_IsInit]
										   ,[DRP_ReturnId]
										   ,[DRP_ReturnNo]
										   ,[DRP_ReturnLotId]
										   ,[DRP_Sku]
										   ,[DRP_LotNumber]
										   ,[DRP_QrCode]
										   ,[DRP_ReturnQty]
										   ,[DRP_Price]
										   ,[DRP_Type]
										   ,[DRP_Desc]
										   ,[DRP_REV1]
										   ,[DRP_REV2]
										   ,[DRP_REV3]
										   ,[DRP_CreateDate]
										   ,[DRP_CreateUser]
										   ,[DRP_CreateUserName]
										   ,[DRP_IsActived])
								SELECT NEWID(),
										@DealerId,
										@ProductLineId,
										YEAR(GETDATE()),
										DATEPART(QUARTER,GETDATE()),
										-1*ISNULL(IAL_LotQty,0)*ISNULL(IAL_UnitPrice,0),
										0,
										@AdjustId,
										@AdjustNo,
										IAL_ID,
										CFN_CustomerFaceNbr,
										CASE WHEN CHARINDEX('@@',IAL_LotNumber) > 0 THEN substring(IAL_LotNumber,1,CHARINDEX('@@',IAL_LotNumber)-1) ELSE IAL_LotNumber END,
										CASE WHEN CHARINDEX('@@',IAL_LotNumber) > 0 THEN substring(IAL_LotNumber,CHARINDEX('@@',IAL_LotNumber)+2,LEN(IAL_LotNumber)-CHARINDEX('@@',IAL_LotNumber)) ELSE 'NoQR' END,
										IAL_LotQty,
										IAL_UnitPrice,
										'�˻��ύ',
										'�˻��ύ�ۼ�',
										@AdjustDesc,
										NULL,
										NULL,
										GETDATE(),
										@UserId,
										@UserName,
										1
									FROM InventoryAdjustHeader
										INNER JOIN InventoryAdjustDetail ON IAH_ID = IAD_IAH_ID
										INNER JOIN InventoryAdjustLot ON IAD_ID = IAL_IAD_ID
										INNER JOIN Product ON PMA_ID = IAD_PMA_ID
										INNER JOIN CFN ON CFN_ID = PMA_CFN_ID
									WHERE IAH_ID = @AdjustId
							END
			
					END
			END
		ELSE 
			BEGIN
				SET @RtnVal = 'Success'
				SET @RtnMsg = ''
				RETURN 1
			END

SET NOCOUNT OFF
RETURN 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    SET @RtnVal = 'Failure'
    
    --��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '1��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
    return -1
    
END CATCH

GO


