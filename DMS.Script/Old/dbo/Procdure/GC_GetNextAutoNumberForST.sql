DROP PROCEDURE [dbo].[GC_GetNextAutoNumberForST]
GO


/*
库存盘点单编号生成，目前PT维修单也使用了（客户申请时经销商ID取的是）
*/

CREATE PROCEDURE [dbo].[GC_GetNextAutoNumberForST]
			@DMA_RecID		uniqueidentifier,
			@Setting        NVarChar(60),
			@NextAutoNbr    NVarChar(50) = '0' OUTPUT
		AS

		--To Check the records for the dealer if exists.	   
		IF NOT EXISTS (SELECT 1 FROM dbo.AutoNbrData WHERE AND_DMA_ID = @DMA_RecID AND AND_ATO_Setting = @Setting)
			INSERT INTO AutoNbrData(AND_DMA_ID,AND_ATO_Setting,AND_Prefix,AND_NextID,AND_AutoNbrDate)
			SELECT @DMA_RecID,ATO_Setting,ATO_DefaultPrefix,ATO_DefaultNextID,GetDate()
			FROM AutoNumber WHERE ATO_Setting = @Setting

		DECLARE @ParentTable    NVarChar(100)
		DECLARE @ParentField    NVarChar(100)
		DECLARE @SQL            NVarChar(510)
		DECLARE @Prefix         NVarChar(6)
		DECLARE @CheckSetting   NVarChar(60)
		DECLARE @LastIDDate		datetime
		DECLARE @Count          Integer
		DECLARE @Retry          Integer
		DECLARE @SAPCode		NVARCHAR(120)
		DECLARE @EmptyLength	Integer
		
		DECLARE @IncrementCount Integer
		SET @IncrementCount = 1
				  		  								  		
		SELECT 
			@CheckSetting = AND_ATO_Setting,
			@NextAutoNbr = AND_NextID,
			@ParentTable = ATO_ParentTable,
			@ParentField = ATO_ParentField,
			@Prefix = ISNULL(AND_Prefix,''),
			@LastIDDate = AND_AutoNbrDate
		FROM AutoNumber(NOLOCK) INNER JOIN AutoNbrData(NOLOCK) ON AutoNumber.ATO_Setting = AutoNbrData.AND_ATO_Setting
		WHERE AND_ATO_Setting = @Setting AND AND_DMA_ID = @DMA_RecID
	   
		SELECT @SAPCode = DMA_SAP_Code FROM DealerMaster WHERE (DMA_ID = @DMA_RecID)
		--SELECT @SAPCode = @SAPCode + REV1 FROM Lafite_ATTRIBUTE WHERE ATTRIBUTE_NAME = @BU
		--modified by bozhenfei on 20100609
		SELECT @SAPCode = @SAPCode + '00'
		SELECT @SAPCode = @SAPCode + @Prefix

		IF datediff(d,@LastIDDate, getdate()) <> 0
		Begin
			Update AutoNbrData Set AND_AutoNbrDate = getdate(), AND_NextID = '1' 
			WHERE AND_ATO_Setting = @Setting AND AND_DMA_ID = @DMA_RecID
			SET @NextAutoNbr = '1'
		end
		SELECT @SAPCode = @SAPCode + RIGHT(Convert(nvarchar(10), Year(getdate())),2)
		+ REPLICATE('0',2-LEN(month(getdate())))+ Convert(nvarchar(10),month(getdate()))
		+ REPLICATE('0',2-LEN(day(getdate())))+ Convert(nvarchar(10),day(getdate()))

		--Did we find the setting?
		IF @CheckSetting IS NULL
	      GOTO Err_Handler
	   
	   --Make sure we have exclusive access to the record before reading the next autonumber.
	   UPDATE AutoNbrData WITH (ROWLOCK) SET 
	      AND_NextID = AND_NextID
	   WHERE AND_ATO_Setting = @Setting AND AND_DMA_ID = @DMA_RecID
	   
	   --Look to see if this auto number already exists.
	   SELECT @Count = 1
	   SELECT @Retry = 0
	   
	   IF NOT (@ParentTable IS NULL OR @ParentField IS NULL)
	      WHILE @Count <> 0 And @Retry < 100
	         BEGIN
	            SELECT @Retry = @Retry + 1
	   
                IF Len(@NextAutoNbr) > 9
		            GOTO Err_Handler
                ELSE
                    SELECT @SQL = 'Declare crsrLookup CURSOR FOR
                        SELECT COUNT(' + @ParentField + ') FROM ' + @ParentTable + '(NOLOCK) WHERE ' + @ParentField + ' = ''' + @SAPCode + @NextAutoNbr + ''''
                EXEC(@SQL)
                OPEN crsrLookup
	   
	            FETCH NEXT FROM crsrLookup INTO @Count
	   
	            IF @@fetch_status = -1
	               GOTO Err_Handler
	   
	            IF @Count <> 0
	               SELECT @NextAutoNbr = CONVERT(VarChar(50), Convert(Int, @NextAutoNbr) + @IncrementCount)
	   
	            DEALLOCATE crsrLookup
            END
	   
	   --Did we end the loop because we could not find the next available autonumber?
	   IF @Retry = 100
	      GOTO Err_Handler
	   
	   UPDATE AutoNbrData SET 
	      AND_NextID = Convert(VarChar(50), Convert(Int, @NextAutoNbr) + @IncrementCount)
	   WHERE AND_ATO_Setting = @Setting AND AND_DMA_ID = @DMA_RecID
	   
	   IF ((2-LEN(@NextAutoNbr))<0)
			SELECT @EmptyLength = 0
	   ELSE
			SELECT @EmptyLength = 2-LEN(@NextAutoNbr)
	 
	   IF NOT @SAPCode IS NULL 
	      SELECT @NextAutoNbr = @SAPCode + REPLICATE('0',@EmptyLength)+ @NextAutoNbr

       --Standard return code        
	   Exit_Function:
	      Return 1

	   --Error occured return code
	   Err_Handler:
	      Return 2

GO


