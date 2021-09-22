DROP PROCEDURE Consignment.Proc_GetNextAutoNumber
GO

CREATE PROCEDURE Consignment.Proc_GetNextAutoNumber
	@DeptCode NVARCHAR(100),
	@ProductLineId UNIQUEIDENTIFIER,
	@ClientId NVARCHAR(500),
	@Settings NVARCHAR(500),
	@NextNum NVARCHAR(500) = '0' OUTPUT
AS
BEGIN
	DECLARE @LastIDDate DATETIME
	DECLARE @IncrementCount INTEGER
	DECLARE @Prefix NVARCHAR(50)
	
	SET @Prefix = @DeptCode;
	
	IF NOT EXISTS (
	       SELECT 1
	       FROM   InterfaceAutoNbrData
	       WHERE  IAND_ClientID = @ClientID
	              AND IAND_ATO_Setting = @Settings
	   )
	BEGIN
	    INSERT INTO InterfaceAutoNbrData
	      (IAND_ClientID, IAND_ATO_Setting, IAND_Prefix, IAND_NextID, IAND_AutoNbrDate)
	    SELECT @ClientID,
	           ATO_Setting,
	           ATO_DefaultPrefix,
	           ATO_DefaultNextID,
	           GETDATE()
	    FROM   AutoNumber
	    WHERE  ATO_Setting = @Settings
	END
	
	SET @IncrementCount = 1
	
	--查询当前值
	SELECT @NextNum = IAND_NextID,
	       @LastIDDate = IAND_AutoNbrDate
	FROM   AutoNumber
	       INNER JOIN InterfaceAutoNbrData
	            ON  AutoNumber.ATO_Setting = InterfaceAutoNbrData.IAND_ATO_Setting
	WHERE  IAND_ClientID = @ClientID
	       AND IAND_ATO_Setting = @Settings
	
	--判断是否为同一年，若不是同一年则重新计数
	IF DATEDIFF(YEAR, @LastIDDate, GETDATE()) <> 0
	BEGIN
	    UPDATE InterfaceAutoNbrData
	    SET    IAND_AutoNbrDate = GETDATE(),
	           IAND_NextID = '1'
	    WHERE  IAND_ClientID = @ClientID
	           AND IAND_ATO_Setting = @Settings
	    
	    SET @NextNum = '1'
	END
	
	--更新计数器
	UPDATE InterfaceAutoNbrData
	SET    IAND_NextID = CONVERT(VARCHAR(50), CONVERT(INT, @NextNum) + @IncrementCount)
	WHERE  IAND_ClientID = @ClientID
	       AND IAND_ATO_Setting = @Settings
	
	IF (ISNULL(@Prefix, '') = '')
	BEGIN
	    SELECT @Prefix = B.DepShortName
	    FROM   V_DivisionProductLineRelation A
	           INNER JOIN interface.mdm_department B
	                ON  A.DivisionCode = CONVERT(NVARCHAR(10), B.DepID)
	    WHERE  A.ProductLineID = @ProductLineId
	           AND a.IsEmerging = '0'
	END
	
	IF LEN(@NextNum) < 6
	BEGIN
	    SET @NextNum = REPLICATE('0', 6 -LEN(@NextNum)) + ISNULL(@NextNum, '')
	END
	
	SET @NextNum = @ClientID + '-' + ISNULL(@Prefix, '') + '-' + CONVERT(NVARCHAR(4), YEAR(GETDATE())) + '-' + @NextNum
END