DROP PROCEDURE [dbo].[GC_GetNextAutoNumberForSampleClin]
GO

CREATE PROCEDURE [dbo].[GC_GetNextAutoNumberForSampleClin]
	@DeptCode		nvarchar(50),
	@ClientID		nvarchar(50),
	@Setting        NVarChar(50),
	@NextAutoNbr    NVarChar(50) = '0' OUTPUT
AS
	DECLARE @LastIDDate DATETIME
	DECLARE @IncrementCount INTEGER
	DECLARE @DMA_RecID NVARCHAR(100)
	
SET NOCOUNT ON

--BEGIN TRY

--BEGIN TRAN
	select @DMA_RecID = DMA_ID from dealermaster where DMA_SAP_Code='471287'
	--判断是否存在
	IF NOT EXISTS(SELECT 1 FROM dbo.AutoNbrData WHERE AND_DMA_ID = @DMA_RecID AND AND_ATO_Setting = @Setting)
     INSERT INTO AutoNbrData(AND_DMA_ID,AND_ATO_Setting,AND_Prefix,AND_NextID,AND_AutoNbrDate)
     SELECT @DMA_RecID,ATO_Setting,ATO_DefaultPrefix,ATO_DefaultNextID,GetDate()
     FROM AutoNumber WHERE ATO_Setting = @Setting

	SET @IncrementCount = 1

  --获取时间是流水号
  SELECT 
		@NextAutoNbr = AND_NextID,		
		@LastIDDate = AND_AutoNbrDate
	FROM AutoNumber(NOLOCK) INNER JOIN AutoNbrData(NOLOCK) ON AutoNumber.ATO_Setting = AutoNbrData.AND_ATO_Setting
	WHERE AND_ATO_Setting = @Setting 

  SET @IncrementCount = 1
  
  --判断是否为同一年同一个月，若不是同一年则重新计数
	IF DATEDIFF(mm,@LastIDDate, getdate()) <> 0
	Begin
		Update AutoNbrData Set AND_AutoNbrDate = getdate(), AND_NextID = '1' 
		WHERE AND_ATO_Setting = @Setting 
		
		SET @NextAutoNbr = '1'
	end
	
	--更新计数器
	UPDATE AutoNbrData SET 
	  AND_NextID = Convert(VarChar(50), Convert(Int, @NextAutoNbr) + @IncrementCount)
	WHERE AND_ATO_Setting = @Setting 
      
	IF LEN(@NextAutoNbr) < 4
		SET @NextAutoNbr = RIGHT( REPLICATE('0', 3) + @NextAutoNbr, 3)
	
  SET @NextAutoNbr = 'CLIN-' + Convert(nvarchar(8),getdate(),112)+ @NextAutoNbr 
GO


