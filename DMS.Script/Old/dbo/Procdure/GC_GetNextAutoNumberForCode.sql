DROP  PROCEDURE [dbo].[GC_GetNextAutoNumberForCode]
GO


/*
�ӿڴ���������
*/

CREATE PROCEDURE [dbo].[GC_GetNextAutoNumberForCode]
	@Setting        NVarChar(50),
	@NextAutoNbr    NVarChar(50) = '0' OUTPUT
AS
	DECLARE @LastIDDate DATETIME
	DECLARE @IncrementCount INTEGER
	DECLARE @Prefix NVARCHAR(50)
SET NOCOUNT ON

	--�ж��Ƿ����
	IF NOT EXISTS (SELECT 1 FROM CodeAutoNbrData WHERE CAND_ATO_Setting = @Setting)
		INSERT INTO CodeAutoNbrData(CAND_ATO_Setting,CAND_Prefix,CAND_NextID,CAND_AutoNbrDate)
		SELECT ATO_Setting,ATO_DefaultPrefix,ATO_DefaultNextID,GetDate() FROM AutoNumber 
		WHERE ATO_Setting = @Setting

	SET @IncrementCount = 1
	
	--��ѯ��ǰֵ
	SELECT 
		@NextAutoNbr = CAND_NextID,
		@Prefix = ISNULL(CAND_Prefix,''),
		@LastIDDate = CAND_AutoNbrDate
	FROM AutoNumber INNER JOIN CodeAutoNbrData ON AutoNumber.ATO_Setting = CodeAutoNbrData.CAND_ATO_Setting
	WHERE CAND_ATO_Setting = @Setting
    
	--���¼�����
	UPDATE CodeAutoNbrData SET 
	  CAND_NextID = Convert(VarChar(50), Convert(Int, @NextAutoNbr) + @IncrementCount)
	WHERE CAND_ATO_Setting = @Setting
      
	IF LEN(@NextAutoNbr) < 6
		SET @NextAutoNbr = REPLICATE('0',6-LEN(@NextAutoNbr))+ @NextAutoNbr
	SET @NextAutoNbr = @Prefix + @NextAutoNbr


GO


