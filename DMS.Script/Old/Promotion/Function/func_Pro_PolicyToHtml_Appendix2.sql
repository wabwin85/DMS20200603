DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Appendix2]
GO



/**********************************************
 功能:传入PolicyId,取得附录2的HTML(经销商封顶值)
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Appendix2](
	@PolicyId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);
	DECLARE @Period NVARCHAR(10);
	DECLARE @TopValue NVARCHAR(50);
	
	DECLARE @MinPeriod NVARCHAR(10);
	DECLARE @MaxPeriod NVARCHAR(10);
	DECLARE @runPeriod NVARCHAR(10);
	
	DECLARE @DealerId UNIQUEIDENTIFIER
	DECLARE @HospitalId NVARCHAR(100)
	DECLARE @DealerName NVARCHAR(100)
	DECLARE @HospitalName NVARCHAR(100)
	
	DECLARE @TopType NVARCHAR(50)
	
	SET @iReturn = ''
	
	SELECT @TopType = A.TopType,@Period = A.Period
	FROM Promotion.PRO_POLICY A WHERE PolicyId = @PolicyId
	
	--获得开始结束期间
	SELECT @MinPeriod = Min(Period),@MaxPeriod=Max(Period)
	FROM Promotion.Pro_Policy_TopValue A WHERE PolicyId = @PolicyId
	
	SET @runPeriod = @MinPeriod
	
	--写表头(第一行：经销商+医院)
	SET @iReturn +='<tr><th style="text-align: center;">经销商</th>' + CASE WHEN @TopType IN ('Hospital','HospitalPeriod') THEN '<th style="text-align: center;">医院</th>' ELSE '' END
	
	--写表头(第一行：期间封顶或单个封顶值)
	IF @TopType IN ('DealerPeriod','HospitalPeriod')
	BEGIN
		WHILE @runPeriod <= @MaxPeriod
		BEGIN
			SET @iReturn += '<th style="text-align: center;">'+@runPeriod+'封顶值</th>'
			SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@runPeriod)
		END
	END
	ELSE
	BEGIN 
		SET @iReturn +='<th style="text-align: center;">封顶值</th>'
	END 
	SET @iReturn +='</tr>'
	
	--写数据
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT DISTINCT DealerId,HospitalId,
						ISNULL(B.DMA_ChineseName,'未知经销商') DealerName,
						ISNULL(c.HOS_HospitalName,'未知医院') HospitalName 
						FROM Promotion.PRO_POLICY_TOPVALUE A 
						LEFT JOIN dbo.DealerMaster B ON A.DealerId = B.DMA_ID 
						LEFT JOIN dbo.Hospital C ON A.HospitalId = C.HOS_Key_Account
					WHERE A.PolicyId = @PolicyId
						ORDER BY DealerId,HospitalId
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @DealerId,@HospitalId,@DealerName,@HospitalName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @iReturn +='<tr>'
		SET @iReturn +='<td>'+@DealerName+'</td>' 
			+ CASE WHEN @TopType IN ('Hospital','HospitalPeriod') THEN '<td>'+@HospitalName+'</td>' ELSE '' END
		
		IF @TopType IN ('DealerPeriod','HospitalPeriod')
		BEGIN
			SET @runPeriod = @MinPeriod
			WHILE @runPeriod <= @MaxPeriod
			BEGIN	
				SELECT @TopValue = CONVERT(NVARCHAR,CONVERT(DECIMAL(14,2),TopValue)) 
				FROM Promotion.PRO_POLICY_TOPVALUE 
				WHERE PolicyId = @PolicyId AND DealerId = @DealerId
				AND ISNULL(HospitalId,'') = ISNULL(@HospitalId,'') 
				AND Period = @runPeriod 
				
				SET @iReturn +='<td>'+ISNULL(@TopValue,'')+'</td>' 
				
				SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@runPeriod)
			END
		END 
		ELSE 
		BEGIN
			SELECT @TopValue = CONVERT(NVARCHAR,CONVERT(DECIMAL(14,2),TopValue)) 
			FROM Promotion.PRO_POLICY_TOPVALUE 
			WHERE PolicyId = @PolicyId AND DealerId = @DealerId
			AND ISNULL(HospitalId,'') = ISNULL(@HospitalId,'') 
			
			SET @iReturn +='<td>'+ISNULL(@TopValue,'')+'</td>' 
		END
		SET @iReturn +='</tr>'
		FETCH NEXT FROM @iCURSOR INTO @DealerId,@HospitalId,@DealerName,@HospitalName
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	RETURN @iReturn
END



GO


