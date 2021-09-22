DROP  PROCEDURE [dbo].[GC_GetNextAutoNumberForMA]
GO


/*
PT维修单编号生成，现在未使用，使用了ST的，后面需要用再改
*/

CREATE PROCEDURE [dbo].[GC_GetNextAutoNumberForMA]
@DMA_RecID		uniqueidentifier,
@Setting        NVarChar(60),
@ProdLine		uniqueidentifier,		
@NextAutoNbr    NVarChar(50) = '0' OUTPUT
AS
  IF NOT EXISTS(SELECT 1 FROM dbo.AutoNbrData WHERE AND_DMA_ID = @DMA_RecID AND AND_ATO_Setting = @Setting)
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
  DECLARE @TmpCode		NVARCHAR(120)
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
  SELECT @TmpCode = ISNULL(REV2,REPLACE(REPLACE(ATTRIBUTE_NAME,'Product Line',''),' ','')) FROM Lafite_ATTRIBUTE WHERE Id = @ProdLine
  SELECT @TmpCode = @TmpCode + '-' + ISNULL(DMA_SAP_Code,'000000') FROM DealerMaster WHERE (DMA_ID = @DMA_RecID)

  IF datediff(d,@LastIDDate, getdate()) <> 0
     Begin
          Update AutoNbrData Set AND_AutoNbrDate = getdate(), AND_NextID = '1'
			WHERE AND_ATO_Setting = @Setting AND AND_DMA_ID = @DMA_RecID
			SET @NextAutoNbr = '1'
     end
  SELECT @TmpCode = @TmpCode + '-' +  Convert(nvarchar(8),getdate(),112)
  --Did we find the setting?
  IF @CheckSetting IS NULL
     GOTO Err_Handler
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
                     BEGIN
	                    IF ((2-LEN(@NextAutoNbr))<0)
                           SELECT @EmptyLength = 0
                        ELSE
                            SELECT @EmptyLength = 2-LEN(@NextAutoNbr)
                     END
                SELECT @SQL = 'Declare crsrLookup1 CURSOR FOR
                       SELECT COUNT(' + @ParentField + ') FROM ' + @ParentTable + '(NOLOCK) WHERE ' + @ParentField + ' = ''' + @TmpCode + '-' + REPLICATE('0',@EmptyLength) + @NextAutoNbr + ''''
                EXEC(@SQL)
                OPEN crsrLookup1

	            FETCH NEXT FROM crsrLookup1 INTO @Count
	
	            IF @@fetch_status = -1
	               GOTO Err_Handler

	            IF @Count <> 0
                   SELECT @NextAutoNbr = CONVERT(VarChar(50), Convert(Int, @NextAutoNbr) + @IncrementCount)
	
                DEALLOCATE crsrLookup1
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
     IF NOT @TmpCode IS NULL
        SELECT @NextAutoNbr = @TmpCode + '-' + REPLICATE('0',@EmptyLength) + @NextAutoNbr
     --Standard return code
     Exit_Function:
        Return 1
     --Error occured return code
     Err_Handler:
        Return 2


GO


