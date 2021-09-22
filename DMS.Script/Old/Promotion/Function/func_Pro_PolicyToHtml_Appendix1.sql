DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Appendix1]
GO



/**********************************************
 ����:����PolicyId,ȡ�ø�¼1��HTML(ָ��ҽԺֲ��ָ��)
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-08-28
 ���¼�¼˵����
 1.���� 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Appendix1](
	@PolicyId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);
	DECLARE @Period NVARCHAR(10);
	DECLARE @PolicyFactorId INT;
	DECLARE @hasHospital NVARCHAR(1);
	DECLARE @TargetLevelCount INT;
	DECLARE @TargetLevelStart INT;
	DECLARE @TargetValue NVARCHAR(50);
	
	DECLARE @MinPeriod NVARCHAR(10);
	DECLARE @MaxPeriod NVARCHAR(10);
	DECLARE @runPeriod NVARCHAR(10);
	
	DECLARE @DealerId UNIQUEIDENTIFIER
	DECLARE @HospitalId NVARCHAR(100)
	DECLARE @DealerName NVARCHAR(100)
	DECLARE @HospitalName NVARCHAR(100)
	
	SET @iReturn = ''
	
	--ֻȡ��1��PolicyFactorId��Ŀǰ��Ϊ1��������ֻ����1����¼1
	DECLARE @iCURSORP CURSOR;
	SET @iCURSORP = CURSOR FOR 
		SELECT distinct
			 b.PolicyFactorId,
			a.Period
		FROM Promotion.PRO_POLICY a,Promotion.PRO_POLICY_factor b,Promotion.Pro_Hospital_PrdSalesTaget c
		WHERE a.PolicyId = b.PolicyId AND b.PolicyFactorId = c.PolicyFactorId AND a.PolicyId = @PolicyId
		OPEN @iCURSORP 	
	FETCH NEXT FROM @iCURSORP INTO @PolicyFactorId,@Period
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
			--�Ƿ����õ�ҽԺ���������1��Ϊ�գ���ô���еĶ�Ӧ���ǿյģ�
			IF EXISTS (SELECT 1 FROM Promotion.Pro_Hospital_PrdSalesTaget 
				WHERE PolicyFactorId = @PolicyFactorId AND ISNULL(HospitalId,'') = '')
				SET @hasHospital = 'N'
			ELSE
				SET @hasHospital = 'Y'

			--��á�Ŀ��ֵ���ĸ���
			SELECT @TargetLevelCount = COUNT(DISTINCT A.TargetLevel),@MinPeriod = Min(Period),@MaxPeriod=Max(Period)
			FROM Promotion.Pro_Hospital_PrdSalesTaget A WHERE PolicyFactorId = @PolicyFactorId

			SET @runPeriod = @MinPeriod

			--д��ͷ(��һ�У�������+ҽԺ)
			SET @iReturn +='<tr><th rowspan=2 style="text-align: center;">������</th>' + CASE @hasHospital WHEN 'Y' THEN '<th rowspan=2 style="text-align: center;">ҽԺ</th>' ELSE '' END
			--д��ͷ(��һ�У��ڼ�)
			WHILE @runPeriod <= @MaxPeriod
			BEGIN
				SET @iReturn += '<th colspan='+CONVERT(NVARCHAR,@TargetLevelCount)+' style="text-align: center;">'+@runPeriod+'</th>'
				SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@runPeriod)
			END
			SET @iReturn +='</tr>'

			--д��ͷ(�ڶ��У�Ŀ��ֵ)
			SET @iReturn +='<tr>'
			SET @runPeriod = @MinPeriod
			WHILE @runPeriod <= @MaxPeriod
			BEGIN
				SET @iReturn +=	CASE WHEN @TargetLevelCount >=1 THEN '<th style="text-align: center;">Ŀ��1</th>' ELSE '' END
						 +CASE WHEN @TargetLevelCount >=2 THEN '<th style="text-align: center;">Ŀ��2</th>' ELSE '' END
						 +CASE WHEN @TargetLevelCount >=3 THEN '<th style="text-align: center;">Ŀ��3</th>' ELSE '' END
						 +CASE WHEN @TargetLevelCount >=4 THEN '<th style="text-align: center;">Ŀ��4</th>' ELSE '' END
						 +CASE WHEN @TargetLevelCount >=5 THEN '<th style="text-align: center;">Ŀ��5</th>' ELSE '' END
				SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@runPeriod)
			END
			SET @iReturn +='</tr>'

			--д����
			DECLARE @iCURSOR CURSOR;
			SET @iCURSOR = CURSOR FOR SELECT DISTINCT DealerId,HospitalId,
								ISNULL(B.DMA_ChineseName,'δ֪������') DealerName,
								ISNULL(c.HOS_HospitalName,'δ֪ҽԺ') HospitalName 
								FROM Promotion.Pro_Hospital_PrdSalesTaget A 
								LEFT JOIN dbo.DealerMaster B ON A.DealerId = B.DMA_ID 
								LEFT JOIN dbo.Hospital C ON A.HospitalId = C.HOS_Key_Account
							WHERE PolicyFactorId = @PolicyFactorId
								ORDER BY DealerId,HospitalId
			OPEN @iCURSOR 	
			FETCH NEXT FROM @iCURSOR INTO @DealerId,@HospitalId,@DealerName,@HospitalName
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @iReturn +='<tr>'
				SET @iReturn +='<td>'+@DealerName+'</td>' 
					+ CASE @hasHospital WHEN 'Y' THEN '<td>'+@HospitalName+'</td>' ELSE '' END
				
				SET @runPeriod = @MinPeriod
				WHILE @runPeriod <= @MaxPeriod
				BEGIN
					SET @TargetLevelStart = 1
					WHILE @TargetLevelStart <= @TargetLevelCount
					BEGIN
						SET @TargetValue = ''
						
						SELECT @TargetValue = CONVERT(NVARCHAR,CONVERT(DECIMAL(14,2),TargetValue)) 
						FROM Promotion.Pro_Hospital_PrdSalesTaget 
						WHERE PolicyFactorId = @PolicyFactorId AND DealerId = @DealerId
						AND ISNULL(HospitalId,'') = ISNULL(@HospitalId,'') 
						AND Period = @runPeriod AND TargetLevel ='Ŀ��'+CONVERT(NVARCHAR,@TargetLevelStart)
						
						SET @iReturn +='<td style="text-align: right;">'+ISNULL(@TargetValue,'')+'</td>' 
						
						SET @TargetLevelStart += 1
					END
					SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@runPeriod)
				END
				
				SET @iReturn +='</tr>'
				FETCH NEXT FROM @iCURSOR INTO @DealerId,@HospitalId,@DealerName,@HospitalName
			END	
			CLOSE @iCURSOR
			DEALLOCATE @iCURSOR



		FETCH NEXT FROM @iCURSORP INTO @PolicyFactorId,@Period
	END	
	CLOSE @iCURSORP
	DEALLOCATE @iCURSORP
	
	
	
	
	
	
	RETURN @iReturn
END



GO


