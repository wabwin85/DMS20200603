DROP PROCEDURE [Contract].[Proc_QueryRenewalList]
GO

CREATE PROCEDURE [Contract].[Proc_QueryRenewalList](
    @ContractNo      NVARCHAR(100),
    @DepId           NVARCHAR(100),
    @SUBDEPID        NVARCHAR(100),
    @DealerType      NVARCHAR(100),
    @CompanyName     NVARCHAR(100),
    @ContractStatus  NVARCHAR(100),
    @ApplyUser       NVARCHAR(100),
    @ApplyDateStart  NVARCHAR(100),
    @ApplyDateEnd    NVARCHAR(100),
    @UserId          UNIQUEIDENTIFIER
)
AS
BEGIN
	SET @ContractNo = LTRIM(RTRIM(@ContractNo));
	SET @DepId = LTRIM(RTRIM(@DepId));
	SET @SUBDEPID = LTRIM(RTRIM(@SUBDEPID));
	SET @DealerType = LTRIM(RTRIM(@DealerType));
	SET @CompanyName = LTRIM(RTRIM(@CompanyName));
	SET @ContractStatus = LTRIM(RTRIM(@ContractStatus));
	SET @ApplyUser = LTRIM(RTRIM(@ApplyUser));
	SET @ApplyDateStart = LTRIM(RTRIM(@ApplyDateStart));
	SET @ApplyDateEnd = LTRIM(RTRIM(@ApplyDateEnd));
	
	DECLARE @DeptId INT;
	DECLARE @IsAdmin INT;
	DECLARE @IsLp INT;
	DECLARE @LpId UNIQUEIDENTIFIER;
	
	IF (@DepId = '')
	BEGIN
	    SET @DeptId = NULL;
	END
	ELSE
	BEGIN
	    SET @DeptId = CONVERT(INT, @DepId);
	END
	
	IF EXISTS (
	       SELECT 1
	       FROM   Lafite_IDENTITY_MAP T1,
	              Lafite_ATTRIBUTE T2
	       WHERE  T1.MAP_ID = T2.Id
	              AND T1.IDENTITY_ID = @UserId
	              AND T1.MAP_TYPE = 'Role'
	              AND T2.ATTRIBUTE_TYPE = 'Role'
	              AND T2.ATTRIBUTE_NAME = '合同管理员'
	   )
	BEGIN
	    SET @IsAdmin = 1;
	END
	ELSE
	BEGIN
	    SET @IsAdmin = 0;
	END
	
	IF EXISTS (
	       SELECT 1
	       FROM   Lafite_IDENTITY_MAP T1,
	              Lafite_ATTRIBUTE T2
	       WHERE  T1.MAP_ID = T2.Id
	              AND T1.IDENTITY_ID = @UserId
	              AND T1.MAP_TYPE = 'Role'
	              AND T2.ATTRIBUTE_TYPE = 'Role'
	              AND T2.ATTRIBUTE_NAME = '平台合同管理员'
	   )
	BEGIN
	    SET @IsLp = 1;
	    SELECT @LpId = A.Corp_ID
	    FROM   Lafite_IDENTITY A
	    WHERE  A.Id = @UserId;
	END
	ELSE
	BEGIN
	    SET @IsLp = 0;
	    SET @LpId = '00000000-0000-0000-0000-000000000000';
	END
	
	SELECT A.ContractId,
	       A.ContractNo,
	       C.DepFullName DepIdShow,
	       D.CC_NameCN SUBDEPIDShow,
	       A.DealerType DealerType,
	       dbo.Func_GetCode('CONST_CONTRACT_DealerType', A.DealerType) DealerTypeShow,
	       B.DMA_ChineseName CompanyName,
	       E.IDENTITY_NAME ApplyUser,
	       CONVERT(NVARCHAR(19), A.CreateDate, 121) ApplyDate,
	       A.ContractStatus,
	       dbo.Func_GetCode('CONST_CONTRACT_ContractStatus', A.ContractStatus) ContractStatusShow,
	       A.CurrentApprove,
	       A.NextApprove,
	       CASE 
	            WHEN EXISTS (
	                     SELECT 1
	                     FROM   Workflow.FormInstanceMaster T
	                     WHERE  T.ApplyId = A.ContractId
	                 ) THEN 1
	            ELSE 0
	       END IsEkp
	FROM   [Contract].RenewalMain A
	       LEFT JOIN DealerMaster B
	            ON  A.DealerName = B.DMA_SAP_Code
	       LEFT JOIN interface.MDM_Department C
	            ON  A.DepId = C.DepID
	       LEFT JOIN interface.ClassificationContract D
	            ON  A.SUBDEPID = D.CC_Code
	       LEFT JOIN Lafite_IDENTITY E
	            ON  A.CreateUser = E.Id
	WHERE  (
	           @ContractNo = ''
	           OR A.ContractNo LIKE '%' + @ContractNo + '%'
	       )
	       AND (@DeptId IS NULL OR A.DepId = @DeptId)
	       AND (@SUBDEPID = '' OR A.SUBDEPID = @SUBDEPID)
	       AND (@DealerType = '' OR A.DealerType = @DealerType)
	       AND (
	               @CompanyName = ''
	               OR B.DMA_ChineseName LIKE '%' + @CompanyName + '%'
	           )
	       AND (@ContractStatus = '' OR A.ContractStatus = @ContractStatus)
	       AND (
	               @ApplyUser = ''
	               OR E.IDENTITY_NAME LIKE '%' + @ApplyUser + '%'
	           )
	       AND (
	               @ApplyDateStart = ''
	               OR CONVERT(NVARCHAR(10), A.RequestDate, 121) >= @ApplyDateStart
	           )
	       AND (
	               @ApplyDateEnd = ''
	               OR CONVERT(NVARCHAR(10), A.RequestDate, 121) <= @ApplyDateEnd
	           )
	       AND (
	               A.CreateUser = @UserId
	               OR (
	                      @IsAdmin = 1
	                      AND A.ContractStatus IN ('InApproval', 'Approved', 'Deny')
	                  )
	               OR (
	                      @IsLp = 1
	                      AND (
	                              EXISTS (
	                                  SELECT 1
	                                  FROM   DealerMaster DM
	                                  WHERE  DM.DMA_ID = A.CompanyID
	                                         AND DM.DMA_Parent_DMA_ID = @LpId
	                              )
	                          )
	                      AND A.ContractStatus IN ('InApproval', 'Approved', 'Deny')
	                  )
	           )
	ORDER BY
	       A.CreateDate DESC
END
GO


