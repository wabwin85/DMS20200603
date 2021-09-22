SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
/*
接口编号生成，目前暂时用于订单接口生成批号（文件名）
*/

ALTER PROCEDURE [dbo].[GC_GetNextAutoNumberForPO_New]
	@DMA_RecID UNIQUEIDENTIFIER ,
	@SubCompanyId UNIQUEIDENTIFIER ,
	@BrandId UNIQUEIDENTIFIER ,
	@Setting NVARCHAR(60) ,
	@ProdLine UNIQUEIDENTIFIER ,
	@OrderType NVARCHAR(30) ,
	@NextAutoNbr NVARCHAR(50) = '0' OUTPUT
AS
	DECLARE	@LastIDDate DATETIME;
	DECLARE	@IncrementCount INTEGER;
	DECLARE	@SubCompanyNo NVARCHAR(50);    --分子公司编号
	DECLARE	@BrandNo NVARCHAR(50);         --品牌编号 
	DECLARE	@Prefix NVARCHAR(50);         --订单前缀，订单类型编号
	DECLARE	@DMAShortEName NVARCHAR(50);  --经销商编号
	DECLARE	@ProdLineCode NVARCHAR(120);  --产品组别的编号、产品线编号
	DECLARE	@DMASapCode NVARCHAR(50);     --经销商SAP编号
	SET NOCOUNT ON;


	--判断是否存在
	IF NOT EXISTS ( SELECT	1
					FROM	dbo.AutoNbrData
					WHERE	AND_DMA_ID = @DMA_RecID
							AND AND_ATO_Setting = @Setting )
		INSERT	INTO AutoNbrData
				(	AND_DMA_ID ,
					AND_ATO_Setting ,
					AND_Prefix ,
					AND_NextID ,
					AND_AutoNbrDate
				)
				SELECT	@DMA_RecID ,
						ATO_Setting ,
						ATO_DefaultPrefix ,
						ATO_DefaultNextID ,
						GETDATE()
				FROM	AutoNumber
				WHERE	ATO_Setting = @Setting;

	SET @IncrementCount = 1;
	
	--（2位分子公司编号 +  3位品牌编号 + 1位产品线编号　＋‘经销商编号’ +　6位年月日　＋　2位序号 + 订单类型编号；
	--譬如：BP-BSC-I-700200-19051201-SP）
 --分子公司编号
	SELECT	@SubCompanyNo = SubCompanyAbbr
	FROM	dbo.View_ProductLine
	WHERE	SubCompanyId = @SubCompanyId;
 --品牌编号
	SELECT	@BrandNo = BrandAbbr
	FROM	dbo.View_ProductLine
	WHERE	BrandId = @BrandId;
   --获取产品组别
	SELECT	@ProdLineCode = ISNULL(REV2,
									REPLACE(REPLACE(ATTRIBUTE_NAME,
													'Product Line', ''), ' ', ''))
	FROM	Lafite_ATTRIBUTE
	WHERE	Id = @ProdLine;
  
  --获取代理商英文名称缩写
	SELECT	@DMAShortEName = REPLACE(DMA_EnglishShortName, '-', '') ,
			@DMASapCode = DMA_SAP_Code
	FROM	dbo.DealerMaster
	WHERE	DMA_ID = @DMA_RecID;
	IF ( @DMAShortEName IS NULL
			OR @DMAShortEName = ''
		)
    --如果经销商没有短编号，则使用经销商的SAPCode
		SET @DMAShortEName = @DMASapCode;
  
  --获取时间是流水号
	SELECT	@NextAutoNbr = AND_NextID ,
			@LastIDDate = AND_AutoNbrDate
	FROM	AutoNumber(NOLOCK)
			INNER JOIN AutoNbrData(NOLOCK) ON AutoNumber.ATO_Setting = AutoNbrData.AND_ATO_Setting
	WHERE	AND_ATO_Setting = @Setting
			AND AND_DMA_ID = @DMA_RecID;

  --根据订单类型,获取前缀
	SELECT	@Prefix = REV3
	FROM	Lafite_DICT
	WHERE	DICT_TYPE = 'CONST_Order_Type'
			AND DICT_KEY = @OrderType;
  
  --判断是否为同一年同一个月，若不是同一年则重新计数
	IF DATEDIFF(mm, @LastIDDate, GETDATE()) <> 0
		BEGIN
			UPDATE	AutoNbrData
			SET		AND_AutoNbrDate = GETDATE() ,
					AND_NextID = '1'
			WHERE	AND_ATO_Setting = @Setting
					AND AND_DMA_ID = @DMA_RecID;
		
			SET @NextAutoNbr = '1';
		END;
	
	--更新计数器
	UPDATE	AutoNbrData
	SET		AND_NextID = CONVERT(VARCHAR(50), CONVERT(INT, @NextAutoNbr)
			+ @IncrementCount)
	WHERE	AND_ATO_Setting = @Setting
			AND AND_DMA_ID = @DMA_RecID;
      
	IF LEN(@NextAutoNbr) < 3
		SET @NextAutoNbr = RIGHT(REPLICATE('0', 2) + @NextAutoNbr, 2);
	
	SET @NextAutoNbr = ISNULL(@SubCompanyNo, '') + '-' + ISNULL(@BrandNo,
																'') + '-'
		+ @ProdLineCode + '-' + @DMAShortEName + '-'
		+ CONVERT(NVARCHAR(20), GETDATE(), 12) + @NextAutoNbr + '-'
		+ @Prefix;



GO

