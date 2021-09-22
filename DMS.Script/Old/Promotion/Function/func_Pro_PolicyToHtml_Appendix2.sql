DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Appendix2]
GO



/**********************************************
 ����:����PolicyId,ȡ�ø�¼2��HTML(�����̷ⶥֵ)
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-08-28
 ���¼�¼˵����
 1.���� 2015-08-28
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
	
	--��ÿ�ʼ�����ڼ�
	SELECT @MinPeriod = Min(Period),@MaxPeriod=Max(Period)
	FROM Promotion.Pro_Policy_TopValue A WHERE PolicyId = @PolicyId
	
	SET @runPeriod = @MinPeriod
	
	--д��ͷ(��һ�У�������+ҽԺ)
	SET @iReturn +='<tr><th style="text-align: center;">������</th>' + CASE WHEN @TopType IN ('Hospital','HospitalPeriod') THEN '<th style="text-align: center;">ҽԺ</th>' ELSE '' END
	
	--д��ͷ(��һ�У��ڼ�ⶥ�򵥸��ⶥֵ)
	IF @TopType IN ('DealerPeriod','HospitalPeriod')
	BEGIN
		WHILE @runPeriod <= @MaxPeriod
		BEGIN
			SET @iReturn += '<th style="text-align: center;">'+@runPeriod+'�ⶥֵ</th>'
			SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@runPeriod)
		END
	END
	ELSE
	BEGIN 
		SET @iReturn +='<th style="text-align: center;">�ⶥֵ</th>'
	END 
	SET @iReturn +='</tr>'
	
	--д����
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT DISTINCT DealerId,HospitalId,
						ISNULL(B.DMA_ChineseName,'δ֪������') DealerName,
						ISNULL(c.HOS_HospitalName,'δ֪ҽԺ') HospitalName 
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


