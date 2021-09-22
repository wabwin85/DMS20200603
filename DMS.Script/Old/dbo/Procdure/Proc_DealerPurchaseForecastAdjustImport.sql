DROP PROCEDURE [dbo].[Proc_DealerPurchaseForecastAdjustImport]
GO


CREATE PROCEDURE [dbo].[Proc_DealerPurchaseForecastAdjustImport]
(
	@UserId UNIQUEIDENTIFIER,
	@IsValid NVARCHAR(200) = 'a' OUTPUT  
)
AS
BEGIN TRY 
	SET @IsValid = 'Error'
	
	DECLARE @YEARMONTH NVARCHAR(10) --当前年月
	
	SELECT @YEARMONTH = CDD_Calendar FROM CalendarDate 
	WHERE CDD_Calendar = CONVERT(NVARCHAR(6),GETDATE(),112) AND DAY(GETDATE()) BETWEEN CDD_Date8 AND CDD_Date9
	
	IF @YEARMONTH IS NULL
	BEGIN 
		SET @IsValid = '当前时间点不可导入数据！'
		RETURN 
	END
	
	SELECT * INTO #DealerPurchaseForecastAdjust_Import FROM DealerPurchaseForecastAdjust_Import WHERE II_User = @UserId 
	--校验*****************************************************************************
	--判断本次上传数据是否属于符合的年月（只能导入允许的当前帐期年月）
	IF EXISTS (SELECT 1 FROM #DealerPurchaseForecastAdjust_Import WHERE II_User = @UserId 
		AND PFA_ForecastVersion <> @YEARMONTH)
	BEGIN
		SET @IsValid = '只能导入'+@YEARMONTH+'的预测数据！'
		RETURN 
	END
	
	--校验数据是否一致（条目数一致，主键一致）
    SELECT  A.* INTO #DealerPurchaseForecastAdjust FROM DealerPurchaseForecastAdjust a, Lafite_IDENTITY b
	WHERE a.PFA_DMA_ID = b.Corp_ID AND b.Id = @UserId AND a.PFA_ForecastVersion = @YEARMONTH  
	and a.PFA_BU in( select distinct v.DivisionCode from #DealerPurchaseForecastAdjust_Import c
    inner join V_DivisionProductLineRelation v on v.DivisionName=c.PFA_BU and v.IsEmerging='0')
	
	--此时两个#表中应该都是该经销商该年月的数据，因此只要比较CFN
	IF EXISTS (SELECT 1 FROM #DealerPurchaseForecastAdjust_Import A 
		WHERE NOT EXISTS (SELECT 1 FROM #DealerPurchaseForecastAdjust WHERE PFA_UPN = A.PFA_UPN))
	or EXISTS (SELECT 1 FROM #DealerPurchaseForecastAdjust A 
		WHERE NOT EXISTS (SELECT 1 FROM #DealerPurchaseForecastAdjust_Import WHERE PFA_UPN = A.PFA_UPN))
	BEGIN 
		SET @IsValid = '数据不一致，请重新下载模板填写！'
		RETURN 
	END
	
	--放入正式表*****************************************************************************
	 ALTER TABLE #DealerPurchaseForecastAdjust_Import ADD PFA_ID UNIQUEIDENTIFIER

	UPDATE B SET PFA_ID = A.PFA_ID
	FROM #DealerPurchaseForecastAdjust A,#DealerPurchaseForecastAdjust_Import B
	WHERE A.PFA_UPN = B.PFA_UPN
	
	UPDATE B SET PFA_ForecastAdj_M1 = CONVERT(INT,CONVERT(DECIMAL,A.PFA_ForecastAdj_M1)),
	PFA_ForecastAdj_M2 = CONVERT(INT,CONVERT(DECIMAL,A.PFA_ForecastAdj_M2)),
	PFA_ForecastAdj_M3 = CONVERT(INT,CONVERT(DECIMAL,A.PFA_ForecastAdj_M3)),
	PFA_ForecastAdj_Remark = A.PFA_ForecastAdj_Remark,
	PFA_UpdateDate = GETDATE(),
	PFA_UpdateUser = @UserId
	FROM #DealerPurchaseForecastAdjust_Import A,DealerPurchaseForecastAdjust B
	WHERE A.PFA_ID = B.PFA_ID
	
 	SET @IsValid = 'Success'
END TRY
BEGIN CATCH
	declare @error_number int
	declare @error_serverity int
	declare @error_state int
	declare @error_message nvarchar(256)
	declare @error_line int
	declare @error_procedure nvarchar(256)
	declare @vError nvarchar(1000)
	
	set @error_number = ERROR_NUMBER()
	set @error_serverity = ERROR_SEVERITY()
	set @error_state = ERROR_STATE()
	set @error_message = ERROR_MESSAGE()
	set @error_line = ERROR_LINE()
	set @error_procedure = ERROR_PROCEDURE()
	set @vError = ISNULL(@error_procedure,'')+'第'+convert(nvarchar(10),ISNULL(@error_line,''))+'行出错[错误号：'+convert(nvarchar(10),ISNULL(@error_number,''))+']，'+ISNULL(@error_message,'')
	
	--ROLLBACK TRAN
	SET @IsValid = @vError
END CATCH


GO


