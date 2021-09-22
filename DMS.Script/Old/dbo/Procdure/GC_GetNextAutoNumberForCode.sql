DROP  PROCEDURE [dbo].[GC_GetNextAutoNumberForCode]
GO


/*
接口处理编号生成
*/

CREATE PROCEDURE [dbo].[GC_GetNextAutoNumberForCode]
	@Setting        NVarChar(50),
	@NextAutoNbr    NVarChar(50) = '0' OUTPUT
AS
	DECLARE @LastIDDate DATETIME
	DECLARE @IncrementCount INTEGER
	DECLARE @Prefix NVARCHAR(50)
SET NOCOUNT ON

	--判断是否存在
	IF NOT EXISTS (SELECT 1 FROM CodeAutoNbrData WHERE CAND_ATO_Setting = @Setting)
		INSERT INTO CodeAutoNbrData(CAND_ATO_Setting,CAND_Prefix,CAND_NextID,CAND_AutoNbrDate)
		SELECT ATO_Setting,ATO_DefaultPrefix,ATO_DefaultNextID,GetDate() FROM AutoNumber 
		WHERE ATO_Setting = @Setting

	SET @IncrementCount = 1
	
	--查询当前值
	SELECT 
		@NextAutoNbr = CAND_NextID,
		@Prefix = ISNULL(CAND_Prefix,''),
		@LastIDDate = CAND_AutoNbrDate
	FROM AutoNumber INNER JOIN CodeAutoNbrData ON AutoNumber.ATO_Setting = CodeAutoNbrData.CAND_ATO_Setting
	WHERE CAND_ATO_Setting = @Setting
    
	--更新计数器
	UPDATE CodeAutoNbrData SET 
	  CAND_NextID = Convert(VarChar(50), Convert(Int, @NextAutoNbr) + @IncrementCount)
	WHERE CAND_ATO_Setting = @Setting
      
	IF LEN(@NextAutoNbr) < 6
		SET @NextAutoNbr = REPLICATE('0',6-LEN(@NextAutoNbr))+ @NextAutoNbr
	SET @NextAutoNbr = @Prefix + @NextAutoNbr


GO


