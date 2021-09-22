DROP PROCEDURE [dbo].[GC_GetNextAutoNumberForTender]
GO


/*
接口处理编号生成
*/

CREATE PROCEDURE [dbo].[GC_GetNextAutoNumberForTender]
	@DeptCode		nvarchar(50),
	@ClientID		nvarchar(50),
	@Settings        NVarChar(50),
	@nextnbr    NVarChar(50) = '0' OUTPUT
AS
	DECLARE @LastIDDate DATETIME
	DECLARE @IncrementCount INTEGER
	DECLARE @Prefix NVARCHAR(50)
SET NOCOUNT ON
--BEGIN TRY

--BEGIN TRAN
	--判断是否存在
	IF NOT EXISTS (SELECT 1 FROM InterfaceAutoNbrData WHERE IAND_ClientID = @ClientID and IAND_ATO_Setting = @Settings)
		INSERT INTO InterfaceAutoNbrData(IAND_ClientID,IAND_ATO_Setting,IAND_Prefix,IAND_NextID,IAND_AutoNbrDate)
		SELECT @ClientID,ATO_Setting,ATO_DefaultPrefix,ATO_DefaultNextID,GetDate() FROM AutoNumber 
		WHERE ATO_Setting = @Settings

	SET @IncrementCount = 1
	
	--查询当前值
	SELECT 
		@nextnbr = IAND_NextID,
		@LastIDDate = IAND_AutoNbrDate
	FROM AutoNumber INNER JOIN InterfaceAutoNbrData ON AutoNumber.ATO_Setting = InterfaceAutoNbrData.IAND_ATO_Setting
	WHERE IAND_ClientID = @ClientID and IAND_ATO_Setting = @Settings
    
	--判断是否为同一天，若不是同一天则重新计数
	IF DATEDIFF(d,@LastIDDate, getdate()) <> 0
	Begin
		Update InterfaceAutoNbrData Set IAND_AutoNbrDate = getdate(), IAND_NextID = '1' 
		WHERE IAND_ClientID = @ClientID and IAND_ATO_Setting = @Settings
		
		SET @nextnbr = '1'
	end
	
	--更新计数器
	UPDATE InterfaceAutoNbrData SET 
	  IAND_NextID = Convert(VarChar(50), Convert(Int, @nextnbr) + @IncrementCount)
	WHERE IAND_ClientID = @ClientID and IAND_ATO_Setting = @Settings
    
    SELECT @Prefix=B.DepShortName FROM V_DivisionProductLineRelation A 
    inner join interface.mdm_department B ON A.DivisionCode=CONVERT(NVARCHAR(10),B.DepID)
    
    WHERE A.ProductLineID=@DeptCode and a.IsEmerging='0'
	IF LEN(@nextnbr) < 4
		SET @nextnbr = REPLICATE('0',4-LEN(@nextnbr))+ isnull(@nextnbr,'')
	SET @nextnbr = @ClientID+'-'+ISNULL(@Prefix,'')+'-'+Convert(nvarchar(8),getdate(),112) + @nextnbr

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


