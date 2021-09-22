DROP PROCEDURE [dbo].[GC_GetNextAutoNumberForInt]
GO


/*
接口处理编号生成
*/

CREATE PROCEDURE [dbo].[GC_GetNextAutoNumberForInt]
	@ClientID		nvarchar(50),
	@Setting        NVarChar(50),
	@NextAutoNbr    NVarChar(50) = '0' OUTPUT
AS
	DECLARE @LastIDDate DATETIME
	DECLARE @IncrementCount INTEGER
	DECLARE @Prefix NVARCHAR(50)
SET NOCOUNT ON

--BEGIN TRY

--BEGIN TRAN
	--判断是否存在
	IF NOT EXISTS (SELECT 1 FROM InterfaceAutoNbrData WHERE IAND_ClientID = @ClientID and IAND_ATO_Setting = @Setting)
		INSERT INTO InterfaceAutoNbrData(IAND_ClientID,IAND_ATO_Setting,IAND_Prefix,IAND_NextID,IAND_AutoNbrDate)
		SELECT @ClientID,ATO_Setting,ATO_DefaultPrefix,ATO_DefaultNextID,GetDate() FROM AutoNumber 
		WHERE ATO_Setting = @Setting

	SET @IncrementCount = 1
	
	--查询当前值
	SELECT 
		@NextAutoNbr = IAND_NextID,
		@Prefix = ISNULL(IAND_Prefix,''),
		@LastIDDate = IAND_AutoNbrDate
	FROM AutoNumber INNER JOIN InterfaceAutoNbrData ON AutoNumber.ATO_Setting = InterfaceAutoNbrData.IAND_ATO_Setting
	WHERE IAND_ClientID = @ClientID and IAND_ATO_Setting = @Setting
    
	--判断是否为同一天，若不是同一天则重新计数
	IF DATEDIFF(d,@LastIDDate, getdate()) <> 0
	Begin
		Update InterfaceAutoNbrData Set IAND_AutoNbrDate = getdate(), IAND_NextID = '1' 
		WHERE IAND_ClientID = @ClientID and IAND_ATO_Setting = @Setting
		
		SET @NextAutoNbr = '1'
	end
	
	--更新计数器
	UPDATE InterfaceAutoNbrData SET 
	  IAND_NextID = Convert(VarChar(50), Convert(Int, @NextAutoNbr) + @IncrementCount)
	WHERE IAND_ClientID = @ClientID and IAND_ATO_Setting = @Setting
      
	IF LEN(@NextAutoNbr) < 4
		SET @NextAutoNbr = REPLICATE('0',4-LEN(@NextAutoNbr))+ @NextAutoNbr
	SET @NextAutoNbr = @Prefix + @ClientID +  Convert(nvarchar(8),getdate(),112) + @NextAutoNbr

--COMMIT TRAN

--SET NOCOUNT OFF
--return 1

--END TRY

--BEGIN CATCH 
--    SET NOCOUNT OFF
--    ROLLBACK TRAN
--    return -1
    
--END CATCH



GO


