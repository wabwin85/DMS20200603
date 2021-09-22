SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [Contract].[Proc_Contract_TakeEffectState](@ContractId uniqueidentifier)
AS
BEGIN
	DECLARE @BeginDate DATETIME
	DECLARE @ContractState NVARCHAR(50)
	DECLARE @ContractType NVARCHAR(50)
	DECLARE @DealerType NVARCHAR(50)
	DECLARE @SynState INT
	DECLARE @DealerId uniqueidentifier
	DECLARE @ExpireDays INT=-180;
	DECLARE @DepId INT;
    DECLARE @BrandName NVARCHAR(100);

	CREATE TABLE #TEMP(
		Massage NVARCHAR(MAX)
	)
	
	SELECT @BeginDate=BeginDate,@ContractState=ContractState,@ContractType=ContractType,@SynState=SynState 
	FROM INTERFACE.T_I_EW_ContractState A WHERE A.ContractId=@ContractId 
	
	IF @SynState=2
	BEGIN
		INSERT INTO #TEMP (Massage) VALUES ('合同已经生效')
	END
	ELSE
	BEGIN
	
	IF CONVERT(NVARCHAR(8),@BeginDate,112)>=CONVERT(NVARCHAR(8),GETDATE(),112)
	BEGIN
		INSERT INTO #TEMP (Massage) VALUES ('合同还未到生效时间')
	END
	
	IF @ContractType='Appointment'
	BEGIN
		IF EXISTS (SELECT 1 FROM DealerMaster B INNER JOIN Contract.AppointmentCandidate A ON A.CompanyID=B.DMA_ID WHERE A.ContractId=@ContractId )
		BEGIN
			SELECT @DealerId=a.CompanyID,@DealerType=b.DealerType FROM Contract.AppointmentCandidate A INNER JOIN Contract.AppointmentMain B ON A.ContractId=B.ContractId WHERE A.ContractId=@ContractId 
		END
		ELSE 
		BEGIN
			SELECT @DealerId=DMA_ID,@DealerType=dm.DMA_DealerType FROM DealerMaster DM WHERE EXISTS (
			SELECT A.CompanyName,B.DealerType,A.LPSAPCode FROM Contract.AppointmentCandidate A 
			INNER JOIN Contract.AppointmentMain B ON A.ContractId=B.ContractId
			INNER JOIN DealerMaster C ON C.DMA_SAP_Code=A.LPSAPCode
			WHERE A.ContractId=@ContractId
			AND DM.DMA_ChineseName=A.CompanyName AND DM.DMA_DealerType=B.DealerType AND DM.DMA_Parent_DMA_ID=C.DMA_ID
			)
		END
	END
	IF @ContractType='Amendment'
	BEGIN
		SELECT @DealerId=CompanyID,@DealerType=DealerType FROM Contract.AmendmentMain A WHERE A.ContractId=@ContractId
	END
	IF @ContractType='Renewal'
	BEGIN
		SELECT @DealerId=CompanyID,@DealerType=DealerType FROM Contract.RenewalMain A WHERE A.ContractId=@ContractId
	END
	IF @ContractType='Termination'
	BEGIN
		SELECT @DealerId=B.DMA_ID,@DealerType=A.DealerType FROM Contract.TerminationMain A
		INNER JOIN DealerMaster B ON A.DealerName=B.DMA_SAP_Code
		 WHERE A.ContractId=@ContractId
	END

	
	
	IF @DealerId IS NULL and @ContractType='Appointment'
		BEGIN
			INSERT INTO #TEMP (Massage) VALUES ('经销商账号创建有问题，请联系DMS管理员')
		END
		ELSE IF @DealerId IS NOT NULL and @ContractType IN ('Appointment','Renewal')
		BEGIN	

				SELECT TOP 1
				   @DepId = DepId
			FROM
			(
				SELECT DepId
				FROM Contract.AppointmentMain
				WHERE ContractId = @ContractId
				UNION
				SELECT DepId
				FROM Contract.RenewalMain
				WHERE ContractId = @ContractId
			) AS T_Contract;

			SELECT TOP 1
				   @BrandName = BrandName
			FROM dbo.V_ProductClassificationStructure
				INNER JOIN dbo.View_ProductLine
					ON V_ProductClassificationStructure.CC_ProductLineID = View_ProductLine.Id
			WHERE V_ProductClassificationStructure.CC_Division = @DepId;

			IF @BrandName = '波科'
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DealerTraining a 
									WHERE a.DealerId=@DealerId 
									AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,@ExpireDays,GETDATE())
									AND A.TestStatus='已通过' AND a.TestType='Compliance')
				BEGIN
					INSERT INTO #TEMP (Massage) VALUES ('经销商合规培训未完成')
				END
				/*IF NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DealerTraining a WHERE  a.DealerId=@DealerId 
								AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,@ExpireDays,GETDATE()) 
								--AND (YEAR(TestDate)=YEAR(@BeginDate) OR (YEAR(TestDate)+1=YEAR(@BeginDate) and MONTH(TestDate)=12))
								AND A.TestStatus='已通过' AND TestType='Quality') AND  @DealerType IN ('LP','T1')
				BEGIN
					INSERT INTO #TEMP (Massage) VALUES ('经销商质量培训未完成')
				END
				*/
				IF NOT EXISTS (SELECT 1 FROM interface.T_I_MDM_DealerTraining a WHERE  a.DealerId=@DealerId 
								AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,@ExpireDays,GETDATE()) 
								AND A.TestStatus='已通过' AND TestType='Survey')
						--AND @DealerType<>'LP'
				BEGIN
					INSERT INTO #TEMP (Massage) VALUES ('经销商调研问卷未完成')
				END

			END
		END
	
	END
	
	SELECT 
	ROW_NUMBER () OVER (ORDER BY Massage Desc)AS Nbr,
	Massage FROM #TEMP
END




GO

