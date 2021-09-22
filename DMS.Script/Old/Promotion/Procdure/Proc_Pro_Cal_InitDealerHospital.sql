DROP PROCEDURE [Promotion].[Proc_Pro_Cal_InitDealerHospital] 
GO


/**********************************************
	功能：每次先INSERT经销商或者经销商医院
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_InitDealerHospital] 
	@PolicyId INT
AS
BEGIN 
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @CalType NVARCHAR(20)
	DECLARE @CalModule NVARCHAR(20)
	DECLARE @iTableName NVARCHAR(50)
	DECLARE @BU NVARCHAR(20)
	DECLARE @SubBU NVARCHAR(20)
	DECLARE @PolicyFactorId INT
	DECLARE @ICOUNT INT
	DECLARE @PolicyBeginDate DATETIME
	
	SELECT 	@CalType = A.CalType,
			@CalModule=CalModule,
			@BU = A.BU,
			@SubBU = A.SubBU,
			@PolicyBeginDate=ISNULL(SUBSTRING(A.StartDate,1,4)+'-'+SUBSTRING(A.StartDate,5,2)+'-01','2010-01-01')
	FROM Promotion.PRO_POLICY A WHERE PolicyId = @PolicyId 
	
	IF @CalModule = '正式' 
		SET @iTableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	ELSE
		SET @iTableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'CAL')
	
	CREATE TABLE #TMP_HOSPITAL
	(
		OperTag NVARCHAR(10),
		HospitalId NVARCHAR (50)
	)
	
	IF @CalType = 'ByDealer'
	BEGIN 
		CREATE TABLE #TMP_DEALER
		(
			DealerId UNIQUEIDENTIFIER,
			DealerName NVARCHAR(100)
		)
		
		--包含的单个经销商
		INSERT INTO #TMP_DEALER(DealerId,DealerName)
		SELECT A.DMA_ID,A.DMA_ChineseName FROM dbo.DealerMaster A,Promotion.PRO_DEALER B 
			WHERE A.DMA_ID = B.DEALERID AND B.WithType = 'ByDealer' AND B.OperType = '包含' AND B.PolicyId = @PolicyId 
		
		--包含的授权经销商	
		INSERT INTO #TMP_DEALER(DealerId,DealerName)
		SELECT DISTINCT A.DMA_ID,A.DMA_ChineseName 
		FROM dbo.DealerMaster A,Promotion.PRO_DEALER B ,V_DealerContractMaster C,
		INTERFACE.ClassificationContract D,V_DivisionProductLineRelation E
			WHERE B.WithType = 'ByAuth' AND B.OperType = '包含' AND B.PolicyId = @PolicyId 
			AND C.DMA_ID=A.DMA_ID AND YEAR(C.MinDate)>=  YEAR(@PolicyBeginDate)  AND D.CC_Division=E.DivisionCode 
			AND E.IsEmerging='0' AND E.DivisionName=@BU  AND C.Division=D.CC_Division
			AND ((ISNULL(@SubBU,'')<>'' AND D.CC_ID=C.CC_ID AND  D.CC_Code=@SubBU ) OR ( ISNULL(@SubBU,'')=''))
		
		--删除不包含的单个经销商
		DELETE C FROM dbo.DealerMaster A,Promotion.PRO_DEALER B,#TMP_DEALER C
		WHERE A.DMA_ID = B.DEALERID AND B.WithType = 'ByDealer' AND B.OperType = '不包含' AND B.PolicyId = @PolicyId 
		AND A.DMA_ID = C.DealerId
		
		SET @SQL = N'INSERT INTO '+@iTableName+'(DealerId,DealerName) 
			SELECT DealerId,DealerName FROM #TMP_DEALER A
			WHERE NOT EXISTS (SELECT 1 FROM '+@iTableName+' WHERE DealerId = A.DealerId)'
		PRINT @SQL
		EXEC(@SQL)
				
		SET @SQL = N'SELECT @ICOUNT = COUNT(*) FROM '+@iTableName
 		EXEC SP_EXECUTESQL @SQL,N'@ICOUNT INT output',@ICOUNT output
 		IF @ICOUNT = 0 
		BEGIN
			--如果PRO_POLICY_FACTOR中维护了"因素ID=7,指定产品医院植入达标率"的FactId,就以Pro_Hospital_PrdSalesTaget表中的医院初始化
			IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 7)
			BEGIN
				DECLARE @iCURSOR_Factor8 CURSOR;
				SET @iCURSOR_Factor8 = CURSOR FOR SELECT PolicyFactorId 
					FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 7
				OPEN @iCURSOR_Factor8 	
				FETCH NEXT FROM @iCURSOR_Factor8 INTO @PolicyFactorId
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @SQL = N'INSERT INTO '+@iTableName+'(DealerId,DealerName)
							SELECT DISTINCT A.DealerId,B.DMA_ChineseName
							FROM Promotion.Pro_Hospital_PrdSalesTaget a,dbo.DealerMaster b,dbo.Hospital c
							WHERE a.DealerId = b.DMA_ID AND a.HospitalId = c.HOS_Key_Account 
							AND a.PolicyFactorId = ' + CONVERT(NVARCHAR,@PolicyFactorId) +
							' AND NOT EXISTS (SELECT 1 FROM '+@iTableName+' WHERE DealerId = A.DealerId)'
					PRINT @SQL
					EXEC(@SQL)
					FETCH NEXT FROM @iCURSOR_Factor8 INTO @PolicyFactorId
				END	
				CLOSE @iCURSOR_Factor8
				DEALLOCATE @iCURSOR_Factor8
			END
		END
		
		SET @SQL = N'SELECT @ICOUNT = COUNT(*) FROM '+@iTableName
 		EXEC SP_EXECUTESQL @SQL,N'@ICOUNT INT output',@ICOUNT output
 		IF @ICOUNT = 0 
		BEGIN
			--如果PRO_POLICY_FACTOR中维护了"因素ID=6,指定产品商业采购达标"的FactId,就以Pro_Dealer_PrdPurchase_Taget表中的经销商初始化
			IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 6)
			BEGIN
				DECLARE @iCURSOR_Factor9 CURSOR;
				SET @iCURSOR_Factor9 = CURSOR FOR SELECT PolicyFactorId 
					FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 6
				OPEN @iCURSOR_Factor9 	
				FETCH NEXT FROM @iCURSOR_Factor9 INTO @PolicyFactorId
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @SQL = N'INSERT INTO '+@iTableName+'(DealerId,DealerName)
							SELECT DISTINCT A.DealerId,B.DMA_ChineseName
							FROM Promotion.Pro_Dealer_PrdPurchase_Taget a,dbo.DealerMaster b
							WHERE a.DealerId = b.DMA_ID 
							AND a.PolicyFactorId = ' + CONVERT(NVARCHAR,@PolicyFactorId) +
							' AND NOT EXISTS (SELECT 1 FROM '+@iTableName+' WHERE DealerId = A.DealerId)'
					PRINT @SQL
					EXEC(@SQL)
					FETCH NEXT FROM @iCURSOR_Factor9 INTO @PolicyFactorId
				END	
				CLOSE @iCURSOR_Factor9
				DEALLOCATE @iCURSOR_Factor9
			END
		END
		
		SET @SQL = N'SELECT @ICOUNT = COUNT(*) FROM '+@iTableName
 		EXEC SP_EXECUTESQL @SQL,N'@ICOUNT INT output',@ICOUNT output
 		IF @ICOUNT = 0 
		BEGIN
			--如果没有上述因素，就以PRO_POLICY_FACTOR中的FactId=2（医院因素）的FactValue拆分
			DECLARE @iCURSOR_Factor2 CURSOR;
			SET @iCURSOR_Factor2 = CURSOR FOR SELECT PolicyFactorId 
				FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 2
			OPEN @iCURSOR_Factor2 	
			FETCH NEXT FROM @iCURSOR_Factor2 INTO @PolicyFactorId
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO #TMP_HOSPITAL(OperTag,HospitalId)
				SELECT OperTag,HospitalId FROM Promotion.func_Pro_CalFactor_Hospital(@PolicyFactorId)
		
				SET @SQL = N'INSERT INTO '+@iTableName+'(DealerId,DealerName)
						SELECT DISTINCT C.DMA_ID,C.DMA_CHINESENAME FROM interface.V_I_QV_DealerAuthorization A 
						INNER JOIN interface.ClassificationContract B ON A.SubBUCode=B.CC_Code
						INNER JOIN DealerMaster C ON C.DMA_SAP_Code=A.SAPID
						INNER JOIN V_DealerContractMaster D ON D.CC_ID=B.CC_ID AND D.DMA_ID=C.DMA_ID AND YEAR(D.MinDate)>=  YEAR('''+@PolicyBeginDate+''') 
						INNER JOIN #TMP_HOSPITAL E ON E.HospitalId = A.DMSCODE
						WHERE A.Year=YEAR(GETDATE()) AND A.Month=MONTH(GETDATE()) AND E.OperTag = ''INCLUDE''
						AND A.DIVISION ='''+@BU+''''
						+' AND NOT EXISTS (SELECT 1 FROM '+@iTableName+' WHERE DealerId = C.DMA_ID)'
				PRINT @SQL
				EXEC(@SQL)
				FETCH NEXT FROM @iCURSOR_Factor2 INTO @PolicyFactorId
			END	
			CLOSE @iCURSOR_Factor2
			DEALLOCATE @iCURSOR_Factor2 
		END
	END 
	ELSE	--ByHospital
	BEGIN
		--如果PRO_POLICY_FACTOR中维护了"因素ID=7,指定产品医院植入达标率"的FactId,就以Pro_Hospital_PrdSalesTaget表中的医院初始化
		IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 7)
		BEGIN
			DECLARE @iCURSOR_Factor7 CURSOR;
			SET @iCURSOR_Factor7 = CURSOR FOR SELECT PolicyFactorId 
				FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 7
			OPEN @iCURSOR_Factor7 	
			FETCH NEXT FROM @iCURSOR_Factor7 INTO @PolicyFactorId
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @SQL = N'INSERT INTO '+@iTableName+'(DealerId,DealerName,HospitalId,HospitalName)
						SELECT DISTINCT A.DealerId,B.DMA_ChineseName,A.HospitalId,C.HOS_HospitalName 
						FROM Promotion.Pro_Hospital_PrdSalesTaget a,dbo.DealerMaster b,dbo.Hospital c
						WHERE a.DealerId = b.DMA_ID AND a.HospitalId = c.HOS_Key_Account 
						AND a.PolicyFactorId = ' + CONVERT(NVARCHAR,@PolicyFactorId) +
						' AND NOT EXISTS (SELECT 1 FROM '+@iTableName+' WHERE DealerId = A.DealerId AND HospitalId = A.HospitalId)'
				PRINT @SQL
				EXEC(@SQL)
				FETCH NEXT FROM @iCURSOR_Factor7 INTO @PolicyFactorId
			END	
			CLOSE @iCURSOR_Factor7
			DEALLOCATE @iCURSOR_Factor7
		END
		
		SET @SQL = N'SELECT @ICOUNT = COUNT(*) FROM '+@iTableName
 		EXEC SP_EXECUTESQL @SQL,N'@ICOUNT INT output',@ICOUNT output
 		--如果没有上述因素，就以PRO_POLICY_FACTOR中的FactId=2（医院因素）的FactValue拆分
 		IF @ICOUNT = 0 
		BEGIN
			DECLARE @iCURSOR_Factor3 CURSOR;
			SET @iCURSOR_Factor3 = CURSOR FOR SELECT PolicyFactorId 
				FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 2
			OPEN @iCURSOR_Factor3 	
			FETCH NEXT FROM @iCURSOR_Factor3 INTO @PolicyFactorId
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO #TMP_HOSPITAL(OperTag,HospitalId)
				SELECT OperTag,HospitalId FROM Promotion.func_Pro_CalFactor_Hospital(@PolicyFactorId)
									
				SET @SQL = N'INSERT INTO '+@iTableName+'(DealerId,DealerName,HospitalId,HospitalName)
						SELECT DISTINCT C.DMA_ID,C.DMA_CHINESENAME,A.DMSCODE,A.HOSPITAL FROM interface.V_I_QV_DealerAuthorization A 
						INNER JOIN interface.ClassificationContract B ON A.SubBUCode=B.CC_Code
						INNER JOIN DealerMaster C ON C.DMA_SAP_Code=A.SAPID
						INNER JOIN V_DealerContractMaster D ON D.CC_ID=B.CC_ID AND D.DMA_ID=C.DMA_ID AND YEAR(D.MinDate)>=  YEAR('''+@PolicyBeginDate+''') 
						INNER JOIN #TMP_HOSPITAL E ON E.HospitalId = A.DMSCODE
						WHERE A.Year=YEAR(GETDATE()) AND A.Month=MONTH(GETDATE()) AND E.OperTag = ''INCLUDE''
						AND A.DIVISION ='''+@BU+''''
						+' AND NOT EXISTS (SELECT 1 FROM '+@iTableName+' WHERE DealerId = C.DMA_ID AND HospitalId = A.DMSCODE)'
						
				PRINT @SQL
				EXEC(@SQL)
				FETCH NEXT FROM @iCURSOR_Factor3 INTO @PolicyFactorId
			END	
			CLOSE @iCURSOR_Factor3
			DEALLOCATE @iCURSOR_Factor3
			 
		END
	END
END  

GO


