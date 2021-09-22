DROP PROCEDURE [dbo].[GC_MaintainAreaAutStatus]
GO


/*
区域授权更新正式表
*/
CREATE PROCEDURE [dbo].[GC_MaintainAreaAutStatus]
@ContractId nvarchar(36), @ContractType nvarchar(50)
WITH EXEC AS CALLER
AS
DECLARE @DMAID uniqueidentifier
DECLARE @PRODUCTLINEID uniqueidentifier
DECLARE @SUBBUCODE NVARCHAR(50)
DECLARE @MarketType NVARCHAR(50)
DECLARE @CON_BEGIN DATETIME
DECLARE @CON_END DATETIME
DECLARE @HasChange bit; 

DECLARE @CC_ID uniqueidentifier; 
DECLARE @DCL_ID uniqueidentifier; 


CREATE TABLE #DAT
(
	DAT_ID  uniqueidentifier
)
	
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
	--SELECT * FROM DealerAuthorizationAreaTemp
	--SELECT * FROM TerritoryAreaExcTemp
	--SELECT * FROM TerritoryAreaTemp
	
	DELETE TerritoryAreaExcHistory WHERE HLH_ChangeToContractID=@ContractId;
	DELETE TerritoryAreaHistory WHERE HLH_ChangeToContractID=@ContractId;
	DELETE TerritoryAreaExcHistory WHERE HLH_CurrentContractID=@ContractId;
	DELETE TerritoryAreaHistory WHERE HLH_CurrentContractID=@ContractId;
	IF @ContractType='Appointment'
	BEGIN
		SET @HasChange=1;
		SELECT @DMAID=CAP_DMA_ID,@SUBBUCODE=CAP_SubDepID,@MarketType=CAP_MarketType,@PRODUCTLINEID=b.ProductLineID,@CON_BEGIN=CAP_EffectiveDate,@CON_END=CAP_ExpirationDate FROM ContractAppointment A INNER JOIN V_DivisionProductLineRelation B ON A.CAP_Division=B.DivisionName AND B.IsEmerging='0' WHERE A.CAP_ID=@ContractId
		
		INSERT INTO TerritoryAreaExcHistory(HLH_ID,HLH_ChangeToContractID,HLH_CurrentContractID,HLH_HOS_ID) 
		SELECT DISTINCT NEWID(),NULL,B.DA_DCL_ID,A.TAE_HOS_ID FROM TerritoryAreaExcTemp A INNER JOIN DealerAuthorizationAreaTemp B ON A.TAE_DA_ID=B.DA_ID WHERE B.DA_DCL_ID=@ContractId;
		INSERT INTO TerritoryAreaHistory(HLH_ID,HLH_ChangeToContractID,HLH_CurrentContractID,HLH_Area_ID) 
		SELECT DISTINCT NEWID(),NULL,B.DA_DCL_ID,A.TA_Area FROM TerritoryAreaTemp A INNER JOIN DealerAuthorizationAreaTemp B ON A.TA_DA_ID=B.DA_ID WHERE B.DA_DCL_ID=@ContractId;
		
	END
	ELSE IF @ContractType='Amendment'
	BEGIN
		SELECT @DMAID=CAM_DMA_ID,@SUBBUCODE=CAM_SubDepID,@MarketType=CAM_MarketType,@PRODUCTLINEID=b.ProductLineID,@CON_BEGIN=CAM_Amendment_EffectiveDate,
		@CON_END=CAM_Agreement_ExpirationDate,
		@HasChange=(CASE WHEN ISNULL(CAM_Territory_IsChange,0)=1 THEN 1 ELSE 0 END)
		FROM ContractAmendment A INNER JOIN V_DivisionProductLineRelation B ON A.CAM_Division=B.DivisionName AND B.IsEmerging='0' WHERE A.CAM_ID=@ContractId
	END
	ELSE IF @ContractType='Renewal'
	BEGIN
		SET @HasChange=1;
		SELECT @DMAID=CRE_DMA_ID,@SUBBUCODE=CRE_SubDepID,@MarketType=CRE_MarketType,@PRODUCTLINEID=b.ProductLineID,@CON_BEGIN=CRE_Agrmt_EffectiveDate_Renewal,@CON_END=CRE_Agrmt_ExpirationDate_Renewal FROM ContractRenewal A INNER JOIN V_DivisionProductLineRelation B ON A.CRE_Division=B.DivisionName AND B.IsEmerging='0' WHERE A.CRE_ID=@ContractId
	END
	ELSE IF @ContractType='Termination'
	BEGIN
		SET @HasChange=1;
		SELECT @DMAID=CTE_DMA_ID,@SUBBUCODE=CTE_SubDepID,@MarketType=CTE_MarketType,@PRODUCTLINEID=b.ProductLineID,@CON_BEGIN=CTE_Termination_EffectiveDate FROM ContractTermination A INNER JOIN V_DivisionProductLineRelation B ON A.CTE_Division=B.DivisionName AND B.IsEmerging='0' WHERE A.CTE_ID=@ContractId
	END
	
	IF @ContractType<>'Appointment' 
	BEGIN
		INSERT INTO TerritoryAreaExcHistory(HLH_ID,HLH_ChangeToContractID,HLH_CurrentContractID,HLH_HOS_ID) 
		SELECT DISTINCT NEWID(),B.DA_DCL_ID,NULL,A.TAE_HOS_ID FROM TerritoryAreaExcTemp A INNER JOIN DealerAuthorizationAreaTemp B ON A.TAE_DA_ID=B.DA_ID WHERE B.DA_DCL_ID=@ContractId;
		INSERT INTO TerritoryAreaHistory(HLH_ID,HLH_ChangeToContractID,HLH_CurrentContractID,HLH_Area_ID) 
		SELECT DISTINCT NEWID(),B.DA_DCL_ID,NULL,A.TA_Area FROM TerritoryAreaTemp A INNER JOIN DealerAuthorizationAreaTemp B ON A.TA_DA_ID=B.DA_ID WHERE B.DA_DCL_ID=@ContractId;
	END
	
	--分时间段授权
	--1.0 删除已同步数据
	IF  @HasChange=1
	BEGIN
		IF EXISTS (SELECT 1 FROM DealerAuthorizationAreaTemp B WHERE B.DA_DCL_ID=@ContractId)
		BEGIN
			DELETE  A  FROM TerritoryArea A  WHERE A.TA_DA_ID IN (SELECT B.DA_ID FROM DealerAuthorizationAreaTemp B WHERE B.DA_DCL_ID=@ContractId)
			DELETE  A  FROM DealerAuthorizationArea A  WHERE A.DA_ID IN (SELECT B.DA_ID FROM DealerAuthorizationAreaTemp B WHERE B.DA_DCL_ID=@ContractId)
			DELETE  A  FROM TerritoryAreaExc A  WHERE A.TAE_DA_ID IN (SELECT B.DA_ID FROM DealerAuthorizationAreaTemp B WHERE B.DA_DCL_ID=@ContractId)
			
			UPDATE A SET  A.DA_EndDate= dateadd(day,-1,@CON_BEGIN) 
			FROM DealerAuthorizationArea  A  
			WHERE DA_DMA_ID=@DMAID AND DA_PMA_ID IN (SELECT DISTINCT CA_ID FROM INTERFACE.ClassificationAuthorization WHERE CA_ParentCode=@SUBBUCODE)
			AND CONVERT(NVARCHAR(10),A.DA_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120)

			UPDATE A SET  A.TA_EndDate= dateadd(day,-1,@CON_BEGIN) 
			FROM TerritoryArea  A  ,DealerAuthorizationArea B 
			WHERE A.TA_DA_ID =B.DA_ID AND b.DA_DMA_ID=@DMAID AND b.DA_PMA_ID IN (SELECT DISTINCT CA_ID FROM INTERFACE.ClassificationAuthorization WHERE CA_ParentCode=@SUBBUCODE)
			AND CONVERT(NVARCHAR(10),A.TA_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120)
			
			UPDATE A SET  A.TAE_EndDate= dateadd(day,-1,@CON_BEGIN) 
			FROM TerritoryAreaExc  A  ,DealerAuthorizationArea B 
			WHERE A.TAE_DA_ID =B.DA_ID AND b.DA_DMA_ID=@DMAID AND b.DA_PMA_ID IN (SELECT DISTINCT CA_ID FROM INTERFACE.ClassificationAuthorization WHERE CA_ParentCode=@SUBBUCODE)
			AND CONVERT(NVARCHAR(10),A.TAE_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120)
			
			
			INSERT INTO DealerAuthorizationArea (DA_PMA_ID,DA_ID,DA_DCL_ID,DA_DMA_ID,DA_ProductLine_BUM_ID,DA_AuthorizationType,DA_DeletedFlag,DA_StartDate,DA_EndDate)
			SELECT A.DA_PMA_ID,A.DA_ID,A.DA_DCL_ID,A.DA_DMA_ID_Actual,A.DA_ProductLine_BUM_ID,A.DA_AuthorizationType,0 ,@CON_BEGIN,@CON_END 
			FROM DealerAuthorizationAreaTemp A 
			WHERE A.DA_DCL_ID=@ContractId

			INSERT INTO TerritoryArea (TA_DA_ID,TA_ID,TA_Area,TA_Remark,TA_StartDate,TA_EndDate)
			SELECT TA_DA_ID,A.TA_ID,A.TA_Area,A.TA_Remark,@CON_BEGIN,@CON_END 
			FROM TerritoryAreaTemp A ,DealerAuthorizationAreaTemp B 
			WHERE A.TA_DA_ID=B.DA_ID AND B.DA_DCL_ID=@ContractId
			
			INSERT INTO TerritoryAreaExc (TAE_DA_ID,TAE_ID,TAE_HOS_ID,TAE_Remark,TAE_StartDate,TAE_EndDate)
			SELECT TAE_DA_ID,a.TAE_ID,a.TAE_HOS_ID,a.TAE_Remark,@CON_BEGIN,@CON_END 
			FROM TerritoryAreaExcTemp A ,DealerAuthorizationAreaTemp B 
			WHERE A.TAE_DA_ID=B.DA_ID AND B.DA_DCL_ID=@ContractId
			
			--维护医院授权信息
			SELECT @CC_ID=CC_ID FROM interface.ClassificationContract where CC_Code=@SUBBUCODE
			IF EXISTS(select 1 from DealerContract a where a.DCL_DMA_ID=@DMAID and a.DCL_CC_ID =@CC_ID)
			BEGIN
				SELECT @DCL_ID=DCL_ID FROM  DealerContract a where a.DCL_DMA_ID=@DMAID and a.DCL_CC_ID=@CC_ID
				UPDATE A SET  A.DAT_EndDate= dateadd(day,-1,@CON_BEGIN) 
				FROM DealerAuthorizationTable  A  
				WHERE DAT_DCL_ID=@DCL_ID
				AND CONVERT(NVARCHAR(10),A.DAT_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120)
				AND A.DAT_Type='Normal'
				
				DELETE DealerAuthorizationTable WHERE DAT_ID IN (SELECT DA_ID FROM DealerAuthorizationAreaTemp A WHERE A.DA_DCL_ID=@ContractId)
				
				INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_StartDate,DAT_EndDate,DAT_Type)
				SELECT DA_PMA_ID,DA_ID,@DCL_ID,A.DA_DMA_ID_Actual,DA_ProductLine_BUM_ID,DA_AuthorizationType,@CON_BEGIN,@CON_END,'Normal' 
				FROM DealerAuthorizationAreaTemp A WHERE A.DA_DCL_ID=@ContractId
			END
			ELSE
			BEGIN
				SET @DCL_ID=NEWID()
				DECLARE @SAPCode NVARCHAR(50)
				SELECT @SAPCode=A.DMA_SAP_Code FROM DealerMaster A WHERE A.DMA_ID=@DMAID
				insert into DealerContract (DCL_ID,DCL_StartDate,DCL_StopDate,DCL_ContractNumber,DCL_DMA_ID,DCL_CreatedDate,DCL_CreatedBy,DCL_CC_ID)
				values(@DCL_ID,@CON_BEGIN,@CON_END,ISNULL(@SAPCode,'')+'-'+@SUBBUCODE,@DMAID,GETDATE(),'00000000-0000-0000-0000-000000000000',@CC_ID)
				
				DELETE DealerAuthorizationTable WHERE DAT_ID IN (SELECT DA_ID FROM DealerAuthorizationAreaTemp A WHERE A.DA_DCL_ID=@ContractId)
				
				INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_StartDate,DAT_EndDate,DAT_Type)
				SELECT DA_PMA_ID,DA_ID,@DCL_ID,A.DA_DMA_ID_Actual,DA_ProductLine_BUM_ID,DA_AuthorizationType,@CON_BEGIN,@CON_END,'Normal' 
				FROM DealerAuthorizationAreaTemp A WHERE A.DA_DCL_ID=@ContractId
			END
		END
	END	
COMMIT TRAN

SET NOCOUNT OFF
return 1
END TRY
BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    return -1
END CATCH

GO


