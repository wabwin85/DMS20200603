DROP PROCEDURE [DP].[Proc_ExportMain]
GO


CREATE PROCEDURE [DP].[Proc_ExportMain]
	@ModleList NVARCHAR(2000),
	@DealerList NVARCHAR(2000),
	@IsShowVersion BIT,
	@UserId UNIQUEIDENTIFIER
AS
BEGIN
	SELECT B.ModleID ModleId,
	       B.ModleName ModleName INTO #ModleList
	FROM   dbo.GC_Fn_SplitStringToTable(@ModleList, ',') A,
	       DP.DPModule B
	WHERE  A.VAL = B.ModleID;
	
	SELECT *
	FROM   #ModleList;
	
	SELECT B.DMA_ID DealerId,
	       B.DMA_SAP_Code DealerCode,
	       B.DMA_ChineseName DealerName INTO #DealerList
	FROM   dbo.GC_Fn_SplitStringToTable(@DealerList, ',') A,
	       dbo.DealerMaster B
	WHERE  A.VAL = B.DMA_ID;
	
	DECLARE @ModleId UNIQUEIDENTIFIER;
	DECLARE @IsGrid BIT;
	DECLARE CUR_MODLE CURSOR  
	FOR
	    SELECT ModleId
	    FROM   #ModleList
	
	OPEN CUR_MODLE
	FETCH NEXT FROM CUR_MODLE INTO @ModleId
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    --ÌØÊâÄ£¿é
	    
	    SELECT @IsGrid = IsGrid
	    FROM   DP.DPModule
	    WHERE  ModleID = @ModleId;
	    
	    IF (@IsGrid = 0)
	    BEGIN
	        EXEC DP.Proc_ExportForm @ModleId, @IsShowVersion
	    END
	    ELSE
	    BEGIN
	        EXEC DP.Proc_ExportGrid @ModleId
	    END
	    
	    FETCH NEXT FROM CUR_MODLE INTO @ModleId
	END
	CLOSE CUR_MODLE
	DEALLOCATE CUR_MODLE
	
	DROP TABLE #ModleList;
	DROP TABLE #DealerList;
END
GO


