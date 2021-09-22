DROP PROCEDURE [dbo].[GC_GetNextAutoNumberForPO]
GO

/*
接口编号生成，目前暂时用于订单接口生成批号（文件名）
*/

CREATE PROCEDURE [dbo].[GC_GetNextAutoNumberForPO]
	@DMA_RecID		uniqueidentifier,
	@Setting      NVarChar(60),
	@ProdLine		  uniqueidentifier,	
  @OrderType    nvarchar(30),
	@NextAutoNbr  NVarChar(50) = '0' OUTPUT
AS
	DECLARE @LastIDDate DATETIME
	DECLARE @IncrementCount INTEGER
	DECLARE @Prefix NVARCHAR(50)         --订单前缀
  DECLARE @DMAShortEName NVARCHAR(50)  --经销商英文缩写
  DECLARE @ProdLineCode NVARCHAR(120)  --产品组别的编号 
  DECLARE @DMASapCode NVARCHAR(50)     --经销商SAP编号
SET NOCOUNT ON


	--判断是否存在
	IF NOT EXISTS(SELECT 1 FROM dbo.AutoNbrData WHERE AND_DMA_ID = @DMA_RecID AND AND_ATO_Setting = @Setting)
     INSERT INTO AutoNbrData(AND_DMA_ID,AND_ATO_Setting,AND_Prefix,AND_NextID,AND_AutoNbrDate)
     SELECT @DMA_RecID,ATO_Setting,ATO_DefaultPrefix,ATO_DefaultNextID,GetDate()
     FROM AutoNumber WHERE ATO_Setting = @Setting

	SET @IncrementCount = 1
	
	--BSC订单编号的格式：代理商英文名称缩写＋产品组别＋年份月份＋流水号+NN(订单类型的前缀 Dict表 Rev3)
  --根据订单类型,获取前缀
  SELECT @Prefix = REV3 FROM Lafite_DICT WHERE DICT_TYPE='CONST_Order_Type' and DICT_KEY = @OrderType
  
  --获取代理商英文名称缩写
	SELECT @DMAShortEName = replace(DMA_EnglishShortName,'-',''),@DMASapCode = DMA_SAP_Code FROM dbo.DealerMaster Where DMA_ID = @DMA_RecID
  IF (@DMAShortEName IS NULL OR @DMAShortEName='')
    --如果经销商没有短编号，则使用经销商的SAPCode
    SET @DMAShortEName=@DMASapCode
  
  --获取产品组别
	SELECT @ProdLineCode = ISNULL(REV2,REPLACE(REPLACE(ATTRIBUTE_NAME,'Product Line',''),' ','')) FROM Lafite_ATTRIBUTE WHERE Id = @ProdLine
  
  --获取时间是流水号
  SELECT 
		@NextAutoNbr = AND_NextID,		
		@LastIDDate = AND_AutoNbrDate
	FROM AutoNumber(NOLOCK) INNER JOIN AutoNbrData(NOLOCK) ON AutoNumber.ATO_Setting = AutoNbrData.AND_ATO_Setting
	WHERE AND_ATO_Setting = @Setting AND AND_DMA_ID = @DMA_RecID

  
  --判断是否为同一年同一个月，若不是同一年则重新计数
	IF DATEDIFF(mm,@LastIDDate, getdate()) <> 0
	Begin
		Update AutoNbrData Set AND_AutoNbrDate = getdate(), AND_NextID = '1' 
		WHERE AND_ATO_Setting = @Setting AND AND_DMA_ID = @DMA_RecID
		
		SET @NextAutoNbr = '1'
	end
	
	--更新计数器
	UPDATE AutoNbrData SET 
	  AND_NextID = Convert(VarChar(50), Convert(Int, @NextAutoNbr) + @IncrementCount)
	WHERE AND_ATO_Setting = @Setting AND AND_DMA_ID = @DMA_RecID
      
	IF LEN(@NextAutoNbr) < 4
		SET @NextAutoNbr = RIGHT( REPLICATE('0', 3) + @NextAutoNbr, 3)
	
  SET @NextAutoNbr = @DMAShortEName +  @ProdLineCode + Convert(nvarchar(4),getdate(),12)+ @NextAutoNbr + @Prefix
GO


