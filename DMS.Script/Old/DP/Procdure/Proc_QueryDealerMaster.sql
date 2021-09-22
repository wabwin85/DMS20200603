DROP PROCEDURE [DP].[Proc_QueryDealerMaster]
GO

CREATE PROCEDURE [DP].[Proc_QueryDealerMaster]
(
    @DealerName         NVARCHAR(200),
    @SapCode            NVARCHAR(200),
    @DealerType         NVARCHAR(200),
    @LPId               NVARCHAR(200),
    @OwnerIdentityType  NVARCHAR(200),
    @OwnerId            NVARCHAR(200),
    @PageStart          INT,
    @PageLimit          INT
)
AS
BEGIN
	SET @DealerName = LTRIM(RTRIM(ISNULL(@DealerName, '')))
	SET @SapCode = LTRIM(RTRIM(ISNULL(@SapCode, '')))
	SET @DealerType = LTRIM(RTRIM(ISNULL(@DealerType, '')))
	SET @LPId = LTRIM(RTRIM(ISNULL(@LPId, '')))
	SET @OwnerIdentityType = LTRIM(RTRIM(ISNULL(@OwnerIdentityType, '')))
	SET @OwnerId = LTRIM(RTRIM(ISNULL(@OwnerId, '')))
	
	CREATE TABLE #ResultTmp
	(
		Id              UNIQUEIDENTIFIER,
		ChineseName     NVARCHAR(500),
		SapCode         NVARCHAR(500),
		DealerType      NVARCHAR(500),
		LastUpdateDate  DATETIME,
		LastUpdateUser  UNIQUEIDENTIFIER,
		ROWNUMBER       INT,
		PRIMARY KEY(Id)
	)
	
	CREATE TABLE #Result
	(
		Id                  UNIQUEIDENTIFIER,
		ChineseName         NVARCHAR(500),
		SapCode             NVARCHAR(500),
		DealerType          NVARCHAR(500),
		LastUpdateDate      DATETIME,
		LastUpdateUser      UNIQUEIDENTIFIER,
		LastUpdateUserName  NVARCHAR(500),
		ActiveFlag          NVARCHAR(500)
	)
	
	IF @OwnerIdentityType <> 'User'
	BEGIN
	    INSERT INTO #ResultTmp
	      (Id, ChineseName, SapCode, DealerType, LastUpdateDate, LastUpdateUser, ROWNUMBER)
	    SELECT DM.DMA_ID,
	           DM.DMA_ChineseName,
	           DM.DMA_SAP_Code,
	           DM.DMA_DealerType,
	           DM.DMA_LastModifiedDate,
	           DM.DMA_LastModifiedBy_USR_UserID,
	           ROW_NUMBER() OVER(ORDER BY DM.DMA_ChineseName ASC)
	    FROM   dbo.DealerMaster DM
	           LEFT JOIN DealerMasterLicense DML
	                ON  DM.DMA_ID = DML.DML_DMA_ID
	    WHERE  DM.DMA_DeletedFlag = 0
	           AND (
	                   @DealerName = ''
	                   OR DM.DMA_ChineseName LIKE '%' + @DealerName + '%'
	               )
	           AND (@SapCode = '' OR DM.DMA_SAP_Code LIKE '%' + @SapCode + '%')
	           AND (@DealerType = '' OR DM.DMA_DealerType = @DealerType)
	           AND EXISTS (
	                   SELECT 1
	                   FROM   dbo.DealerMaster DMA
	                   WHERE  (
	                              CONVERT(NVARCHAR(100), DMA.DMA_Parent_DMA_ID) = @LPId
	                              AND DMA.DMA_ID = DM.DMA_ID
	                          )
	                          OR  (CONVERT(NVARCHAR(100), DM.DMA_ID) = @LPId)
	               )
	END
	ELSE 
	IF EXISTS (
	       SELECT 1
	       FROM   Lafite_IDENTITY_MAP RA,
	              Lafite_ATTRIBUTE RB
	       WHERE  RA.MAP_ID = RB.Id
	              AND RA.MAP_TYPE = 'Role'
	              AND RB.ATTRIBUTE_TYPE = 'Role'
	              AND RB.ATTRIBUTE_NAME IN ('DP 系统管理员', 'DP DRM人员', 'DP 财务人员')
	              AND RA.IDENTITY_ID = CONVERT(UNIQUEIDENTIFIER, @OwnerId)
	   )
	BEGIN
	    INSERT INTO #ResultTmp
	      (Id, ChineseName, SapCode, DealerType, LastUpdateDate, LastUpdateUser, ROWNUMBER)
	    SELECT DM.DMA_ID,
	           DM.DMA_ChineseName,
	           DM.DMA_SAP_Code,
	           DM.DMA_DealerType,
	           DM.DMA_LastModifiedDate,
	           DM.DMA_LastModifiedBy_USR_UserID,
	           ROW_NUMBER() OVER(ORDER BY DM.DMA_ChineseName ASC)
	    FROM   dbo.DealerMaster DM
	           LEFT JOIN DealerMasterLicense DML
	                ON  DM.DMA_ID = DML.DML_DMA_ID
	    WHERE  DM.DMA_DeletedFlag = 0
	           AND (
	                   @DealerName = ''
	                   OR DM.DMA_ChineseName LIKE '%' + @DealerName + '%'
	               )
	           AND (@SapCode = '' OR DM.DMA_SAP_Code LIKE '%' + @SapCode + '%')
	           AND (@DealerType = '' OR DM.DMA_DealerType = @DealerType)
	END
	ELSE
	BEGIN
	    INSERT INTO #ResultTmp
	      (Id, ChineseName, SapCode, DealerType, LastUpdateDate, LastUpdateUser, ROWNUMBER)
	    SELECT DM.DMA_ID,
	           DM.DMA_ChineseName,
	           DM.DMA_SAP_Code,
	           DM.DMA_DealerType,
	           DM.DMA_LastModifiedDate,
	           DM.DMA_LastModifiedBy_USR_UserID,
	           ROW_NUMBER() OVER(ORDER BY DM.DMA_ChineseName ASC)
	    FROM   dbo.DealerMaster DM
	           LEFT JOIN DealerMasterLicense DML
	                ON  DM.DMA_ID = DML.DML_DMA_ID
	    WHERE  DM.DMA_DeletedFlag = 0
	           AND (
	                   @DealerName = ''
	                   OR DM.DMA_ChineseName LIKE '%' + @DealerName + '%'
	               )
	           AND (@SapCode = '' OR DM.DMA_SAP_Code LIKE '%' + @SapCode + '%')
	           AND (@DealerType = '' OR DM.DMA_DealerType = @DealerType)
	           AND EXISTS (
	                   SELECT 1
	                   FROM   Cache_SalesOfDealer SD
	                   WHERE  SD.DealerID = DM.DMA_ID
	                          AND (
	                                  EXISTS(
	                                      SELECT 1
	                                      FROM   Cache_OrganizationUnits OU,
	                                             Lafite_IDENTITY_MAP IM
	                                      WHERE  OU.AttributeId = IM.MAP_ID
	                                             AND IM.MAP_TYPE = 'Organization'
	                                             AND CONVERT(VARCHAR(36), SD.SalesID) = IM.IDENTITY_ID
	                                             AND OU.AttributeId <> OU.RootId
	                                             AND OU.RootID 
	                                                 IN (SELECT MAP_ID
	                                                     FROM   Lafite_IDENTITY_MAP OM
	                                                     WHERE  OM.MAP_TYPE = 'Organization'
	                                                            AND OM.IDENTITY_ID = CONVERT(UNIQUEIDENTIFIER, @OwnerId))
	                                  )
	                                  OR (SD.SalesID = CONVERT(UNIQUEIDENTIFIER, @OwnerId))
	                              )
	               )
	END
	
	SELECT COUNT(*) CNT
	FROM   #ResultTmp
	
	INSERT INTO #Result
	  (Id, ChineseName, SapCode, DealerType, LastUpdateDate, LastUpdateUser, LastUpdateUserName, ActiveFlag)
	SELECT Id,
	       ChineseName,
	       SapCode,
	       DealerType,
	       LastUpdateDate,
	       LastUpdateUser,
	       (
	           SELECT IDENTITY_NAME
	           FROM   Lafite_IDENTITY Z
	           WHERE  Z.Id = A.LastUpdateUser
	       ),
	       CASE 
	            WHEN EXISTS (
	                     SELECT 1
	                     FROM   V_DealerContractMaster Z
	                     WHERE  CONVERT(NVARCHAR(10), GETDATE(), 121) >= CONVERT(NVARCHAR(10), Z.EffectiveDate, 121)
	                            AND CONVERT(NVARCHAR(10), GETDATE(), 121) <= CONVERT(NVARCHAR(10), Z.ExpirationDate, 121)
	                            AND Z.ActiveFlag = 1
	                            AND Z.DMA_ID = A.Id
	                 ) THEN '有效'
	            ELSE '失效'
	       END
	FROM   #ResultTmp A
	WHERE  ROWNUMBER BETWEEN @PageStart + 1 AND @PageStart + @PageLimit
	
	SELECT *
	FROM   #Result
END
GO


