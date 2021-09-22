DROP PROCEDURE [Contract].[Proc_DeleteTempAccount]
GO


CREATE PROCEDURE [Contract].[Proc_DeleteTempAccount](
    @ContractId      UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @DealerId UNIQUEIDENTIFIER;
	DECLARE @DealerType NVARCHAR(10);
	DECLARE @DMASAPCode NVARCHAR(10);
	DECLARE @CANDELETE INT;
	
	SET @CANDELETE=0
	SELECT @DealerId=B.DMA_ID,@DealerType=DMA_DealerType,@DMASAPCode=DMA_SAP_Code FROM ContractAppointment A INNER JOIN DealerMaster B ON A.CAP_DMA_ID=B.DMA_ID WHERE A.CAP_ID=@ContractId;
	IF @DealerId IS NOT NULL AND @DealerType IN ('T1','LP') AND LEN(@DMASAPCode)>6
	BEGIN
		SET @CANDELETE=1;
	END
	ELSE IF @DealerId IS NOT NULL AND @DealerType IN ('T2')
	BEGIN
		SET @CANDELETE=1
	END
	
	IF @CANDELETE=1
	BEGIN
	
		--删除权限
		DELETE B  FROM Lafite_IDENTITY_MAP B 
		INNER JOIN Lafite_IDENTITY A on b.IDENTITY_ID=a.Id
		WHERE A.Corp_ID=@DealerId ;
		
		--删除密码
		DELETE B  FROM Lafite_Membership B 
		INNER JOIN Lafite_IDENTITY A on b.UserId=a.Id
		WHERE A.Corp_ID=@DealerId ;
	
		--删除仓库
		DELETE Warehouse WHERE WHM_DMA_ID=@DealerId;
		
		--删除账号	
		DELETE  Lafite_IDENTITY  WHERE Corp_ID=@DealerId;
		
		--删除经销商主信息
		DELETE DealerMaster WHERE DMA_ID=@DealerId;
		
	END
	
END
GO


