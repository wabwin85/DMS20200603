DROP PROCEDURE [interface].[P_I_EW_ContractExtensionComplete]
GO



CREATE PROCEDURE [interface].[P_I_EW_ContractExtensionComplete]
@Contract_ID nvarchar(36), @Contract_Type nvarchar(50),@RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT
AS
BEGIN
	DECLARE @MarktType NVARCHAR(10)
	DECLARE @SubDepID NVARCHAR(50)
	DECLARE @Division NVARCHAR(10)
	DECLARE @DMA_ID uniqueidentifier
	DECLARE @HasChange bit;

	DECLARE @ProductLineId uniqueidentifier
	DECLARE @CON_BEGIN DATETIME
	DECLARE @CON_END DATETIME
	

	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	

	/*1. 数据准备*/
	
	IF @Contract_Type='Appointment'
	BEGIN
		SELECT @DMA_ID=CAP_DMA_ID,@MarktType= CONVERT(NVARCHAR(10),ISNULL(A.CAP_MarketType,0)), @Division=A.CAP_Division,@SubDepID= A.CAP_SubDepID ,@CON_BEGIN=CAP_EffectiveDate,@CON_END=CAP_ExpirationDate
		FROM  ContractAppointment A WHERE CAP_ID= @Contract_ID
		SELECT @ProductLineId=A.ProductLineID FROM V_DivisionProductLineRelation A WHERE A.IsEmerging='0' AND A.DivisionName=@Division;
		SET @HasChange=1;
		
	END
	IF @Contract_Type='Amendment'
	BEGIN
		SELECT @DMA_ID=CAM_DMA_ID,@MarktType= CONVERT(NVARCHAR(10),ISNULL(A.CAM_MarketType,0)), @Division=A.CAM_Division,@SubDepID= A.CAM_SubDepID ,@CON_END=CAM_Agreement_ExpirationDate,@CON_BEGIN=CAM_Amendment_EffectiveDate
		,@HasChange=ISNULL(CAM_Territory_IsChange,0)
		FROM  ContractAmendment A WHERE CAM_ID= @Contract_ID
		SELECT @ProductLineId=A.ProductLineID FROM V_DivisionProductLineRelation A WHERE A.IsEmerging='0' AND A.DivisionName=@Division;
		
	END
	IF @Contract_Type='Renewal'
	BEGIN
		SELECT @DMA_ID=CRE_DMA_ID,@MarktType= CONVERT(NVARCHAR(10),ISNULL(A.CRE_MarketType,0)), @Division=A.CRE_Division,@SubDepID= A.CRE_SubDepID ,@CON_BEGIN=CRE_Agrmt_EffectiveDate_Renewal,@CON_END=CRE_Agrmt_ExpirationDate_Renewal
		FROM  ContractRenewal A WHERE CRE_ID= @Contract_ID
		SELECT @ProductLineId=A.ProductLineID FROM V_DivisionProductLineRelation A WHERE A.IsEmerging='0' AND A.DivisionName=@Division;
		SET @HasChange=1;
	END
	
	IF @HasChange=1
	BEGIN
		DECLARE @CC_ID uniqueidentifier
		DECLARE @DCL_ID uniqueidentifier
		select @CC_ID=CC_ID from interface.ClassificationContract where CC_Code=@SubDepID
		IF EXISTS(select 1 from DealerContract a where a.DCL_DMA_ID=@DMA_ID and a.DCL_CC_ID=@CC_ID)
		BEGIN
			SELECT @DCL_ID=DCL_ID FROM  DealerContract a where a.DCL_DMA_ID=@DMA_ID and a.DCL_CC_ID=@CC_ID
			
			--更新延展授权时间为终止状态
			
			UPDATE A SET  A.HLA_EndDate= dateadd(day,-1,@CON_BEGIN) 
			FROM HospitalList  A  ,DealerAuthorizationTable B 
			WHERE A.HLA_DAT_ID =B.DAT_ID AND B.DAT_DCL_ID=@DCL_ID
			AND CONVERT(NVARCHAR(10),A.HLA_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120)
			AND CONVERT(NVARCHAR(10),b.DAT_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120)
			AND B.DAT_Type='Temp'
			
			
			UPDATE A SET  A.DAT_EndDate= dateadd(day,-1,@CON_BEGIN) 
			FROM DealerAuthorizationTable  A  
			WHERE DAT_DCL_ID=@DCL_ID
			AND CONVERT(NVARCHAR(10),A.DAT_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120)
			AND A.DAT_Type='Temp'
			
		END
	END
END		
	
GO


