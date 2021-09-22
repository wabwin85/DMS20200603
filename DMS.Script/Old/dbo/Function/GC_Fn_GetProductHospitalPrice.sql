DROP function [dbo].[GC_Fn_GetProductHospitalPrice]
GO




Create function [dbo].[GC_Fn_GetProductHospitalPrice](@HospitalId nvarchar(36),
@CQId nvarchar(36),@PriceYear nvarchar(10),@PriceMonth nvarchar(10))
returns decimal(18,6)
as
BEGIN
	declare @Price decimal(18,6), @HospitalCode NVARCHAR(50),@CQCode NVARCHAR(50),@Province NVARCHAR(50),@PriceDate datetime

	SET @PriceDate=@PriceYear +'-' +@PriceMonth+'-' +'01';
	
	SELECT @HospitalCode=A.HOS_Key_Account,@Province=b.TER_Code FROM Hospital A 
	left join Territory B on a.HOS_Province=B.TER_Description
	WHERE A.HOS_ID=@HospitalId;
	SELECT TOP 1  @CQCode=A.CQ_Code FROM INTERFACE.ClassificationQuota A WHERE A.CQ_ID=@CQId;

	SELECT @Price=A.Price FROM interface.ProductHospitalPrice A  
	WHERE  A.CQCode=@CQCode
		AND(ISNULL(HospitalCode,'')<>'' and A.HospitalCode=@HospitalCode)
		AND CONVERT(NVARCHAR(10),A.BeginDate,120) <= CONVERT(NVARCHAR(10),@PriceDate,120)
		AND CONVERT(NVARCHAR(10),A.EndDate,120)>=CONVERT(NVARCHAR(10),@PriceDate,120)
	
	IF @Price IS NULL
	BEGIN
		SELECT @Price=A.Price FROM interface.ProductHospitalPrice A  
		WHERE  A.CQCode=@CQCode
			AND (ISNULL(HospitalCode,'')='' AND  ISNULL(Province,'')<>''  and A.Province=@Province)
			AND CONVERT(NVARCHAR(10),A.BeginDate,120) <= CONVERT(NVARCHAR(10),@PriceDate,120)
			AND CONVERT(NVARCHAR(10),A.EndDate,120)>=CONVERT(NVARCHAR(10),@PriceDate,120)
	END
	IF @Price IS NULL
	BEGIN	
		SELECT @Price=A.Price FROM interface.ProductHospitalPrice A  
		WHERE  A.CQCode=@CQCode
			AND (ISNULL(HospitalCode,'')='' AND  ISNULL(Province,'')='') 
			AND CONVERT(NVARCHAR(10),A.BeginDate,120) <= CONVERT(NVARCHAR(10),@PriceDate,120)
			AND CONVERT(NVARCHAR(10),A.EndDate,120)>=CONVERT(NVARCHAR(10),@PriceDate,120)
	END	
	
	return ISNULL(@Price,0); 
END



GO


