DROP PROCEDURE [dbo].[GC_GetNextAutoNumberForPO]
GO

/*
�ӿڱ�����ɣ�Ŀǰ��ʱ���ڶ����ӿ��������ţ��ļ�����
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
	DECLARE @Prefix NVARCHAR(50)         --����ǰ׺
  DECLARE @DMAShortEName NVARCHAR(50)  --������Ӣ����д
  DECLARE @ProdLineCode NVARCHAR(120)  --��Ʒ���ı�� 
  DECLARE @DMASapCode NVARCHAR(50)     --������SAP���
SET NOCOUNT ON


	--�ж��Ƿ����
	IF NOT EXISTS(SELECT 1 FROM dbo.AutoNbrData WHERE AND_DMA_ID = @DMA_RecID AND AND_ATO_Setting = @Setting)
     INSERT INTO AutoNbrData(AND_DMA_ID,AND_ATO_Setting,AND_Prefix,AND_NextID,AND_AutoNbrDate)
     SELECT @DMA_RecID,ATO_Setting,ATO_DefaultPrefix,ATO_DefaultNextID,GetDate()
     FROM AutoNumber WHERE ATO_Setting = @Setting

	SET @IncrementCount = 1
	
	--BSC������ŵĸ�ʽ��������Ӣ��������д����Ʒ�������·ݣ���ˮ��+NN(�������͵�ǰ׺ Dict�� Rev3)
  --���ݶ�������,��ȡǰ׺
  SELECT @Prefix = REV3 FROM Lafite_DICT WHERE DICT_TYPE='CONST_Order_Type' and DICT_KEY = @OrderType
  
  --��ȡ������Ӣ��������д
	SELECT @DMAShortEName = replace(DMA_EnglishShortName,'-',''),@DMASapCode = DMA_SAP_Code FROM dbo.DealerMaster Where DMA_ID = @DMA_RecID
  IF (@DMAShortEName IS NULL OR @DMAShortEName='')
    --���������û�ж̱�ţ���ʹ�þ����̵�SAPCode
    SET @DMAShortEName=@DMASapCode
  
  --��ȡ��Ʒ���
	SELECT @ProdLineCode = ISNULL(REV2,REPLACE(REPLACE(ATTRIBUTE_NAME,'Product Line',''),' ','')) FROM Lafite_ATTRIBUTE WHERE Id = @ProdLine
  
  --��ȡʱ������ˮ��
  SELECT 
		@NextAutoNbr = AND_NextID,		
		@LastIDDate = AND_AutoNbrDate
	FROM AutoNumber(NOLOCK) INNER JOIN AutoNbrData(NOLOCK) ON AutoNumber.ATO_Setting = AutoNbrData.AND_ATO_Setting
	WHERE AND_ATO_Setting = @Setting AND AND_DMA_ID = @DMA_RecID

  
  --�ж��Ƿ�Ϊͬһ��ͬһ���£�������ͬһ�������¼���
	IF DATEDIFF(mm,@LastIDDate, getdate()) <> 0
	Begin
		Update AutoNbrData Set AND_AutoNbrDate = getdate(), AND_NextID = '1' 
		WHERE AND_ATO_Setting = @Setting AND AND_DMA_ID = @DMA_RecID
		
		SET @NextAutoNbr = '1'
	end
	
	--���¼�����
	UPDATE AutoNbrData SET 
	  AND_NextID = Convert(VarChar(50), Convert(Int, @NextAutoNbr) + @IncrementCount)
	WHERE AND_ATO_Setting = @Setting AND AND_DMA_ID = @DMA_RecID
      
	IF LEN(@NextAutoNbr) < 4
		SET @NextAutoNbr = RIGHT( REPLICATE('0', 3) + @NextAutoNbr, 3)
	
  SET @NextAutoNbr = @DMAShortEName +  @ProdLineCode + Convert(nvarchar(4),getdate(),12)+ @NextAutoNbr + @Prefix
GO


