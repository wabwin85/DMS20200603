DROP PROCEDURE [interface].[P_I_EW_ContractAuthorComplete]
GO



CREATE PROCEDURE [interface].[P_I_EW_ContractAuthorComplete]
@Contract_ID nvarchar(36), @Contract_Type nvarchar(50),@RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT
WITH EXEC AS CALLER
AS
DECLARE @MarktType NVARCHAR(10)
DECLARE @SubDepID NVARCHAR(50)
DECLARE @Division NVARCHAR(10)
DECLARE @DMA_ID uniqueidentifier
DECLARE @HasChange bit;

DECLARE @ProductLineId uniqueidentifier
DECLARE @SAPCode NVARCHAR(50)
DECLARE @CON_BEGIN DATETIME
DECLARE @CON_END DATETIME

--Amandment
DECLARE @DAT_ID uniqueidentifier
DECLARE @DAT_ID_New uniqueidentifier
	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	CREATE TABLE #tmp(
		DAT_ID uniqueidentifier
	)

	/*1. 数据准备*/
	
	IF @Contract_Type='Appointment'
	BEGIN
		SELECT @DMA_ID=CAP_DMA_ID,@MarktType= CONVERT(NVARCHAR(10),ISNULL(A.CAP_MarketType,0)), @Division=A.CAP_Division,@SubDepID= A.CAP_SubDepID ,@CON_BEGIN=CONVERT(NVARCHAR(10),CAP_EffectiveDate,120),@CON_END=CONVERT(NVARCHAR(10),CAP_ExpirationDate,120)
		FROM  ContractAppointment A WHERE CAP_ID= @Contract_ID
		SELECT @ProductLineId=A.ProductLineID FROM V_DivisionProductLineRelation A WHERE A.IsEmerging='0' AND A.DivisionName=@Division;
		SET @HasChange=1;
		
	END
	IF @Contract_Type='Amendment'
	BEGIN
		SELECT @DMA_ID=CAM_DMA_ID,@MarktType= CONVERT(NVARCHAR(10),ISNULL(A.CAM_MarketType,0)), @Division=A.CAM_Division,@SubDepID= A.CAM_SubDepID ,@CON_END=CONVERT(NVARCHAR(10),CAM_Agreement_ExpirationDate,120),@CON_BEGIN=CONVERT(NVARCHAR(10),CAM_Amendment_EffectiveDate,120)
		,@HasChange=ISNULL(CAM_Territory_IsChange,0)
		FROM  ContractAmendment A WHERE CAM_ID= @Contract_ID
		SELECT @ProductLineId=A.ProductLineID FROM V_DivisionProductLineRelation A WHERE A.IsEmerging='0' AND A.DivisionName=@Division;
		
	END
	IF @Contract_Type='Renewal'
	BEGIN
		SELECT @DMA_ID=CRE_DMA_ID,@MarktType= CONVERT(NVARCHAR(10),ISNULL(A.CRE_MarketType,0)), @Division=A.CRE_Division,@SubDepID= A.CRE_SubDepID ,@CON_BEGIN=CONVERT(NVARCHAR(10),CRE_Agrmt_EffectiveDate_Renewal,120),@CON_END=CONVERT(NVARCHAR(10),CRE_Agrmt_ExpirationDate_Renewal,120)
		FROM  ContractRenewal A WHERE CRE_ID= @Contract_ID
		SELECT @ProductLineId=A.ProductLineID FROM V_DivisionProductLineRelation A WHERE A.IsEmerging='0' AND A.DivisionName=@Division;
		SET @HasChange=1;
	END
	IF @Contract_Type='Termination'
	BEGIN
		SELECT @DMA_ID=CTE_DMA_ID,@MarktType= CONVERT(NVARCHAR(10),ISNULL(A.CTE_MarketType,0)), @Division=A.CTE_Division,@SubDepID= A.CTE_SubDepID ,@CON_BEGIN=CTE_Termination_EffectiveDate
		FROM  ContractTermination A WHERE CTE_ID= @Contract_ID
		SELECT @ProductLineId=A.ProductLineID FROM V_DivisionProductLineRelation A WHERE A.IsEmerging='0' AND A.DivisionName=@Division;
		DECLARE @CCID uniqueidentifier
		DECLARE @DCLID uniqueidentifier
		select @CCID=CC_ID from interface.ClassificationContract where CC_Code=@SubDepID
		IF EXISTS(select 1 from DealerContract a where a.DCL_DMA_ID=@DMA_ID and a.DCL_CC_ID=@CCID)
		BEGIN
			SELECT @DCLID=DCL_ID FROM  DealerContract a where a.DCL_DMA_ID=@DMA_ID and a.DCL_CC_ID=@CCID
			UPDATE A SET  A.DAT_EndDate=@CON_BEGIN
			FROM DealerAuthorizationTable  A  
			WHERE DAT_DCL_ID=@DCLID
			AND CONVERT(NVARCHAR(10),A.DAT_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120)
			AND A.DAT_Type='Normal'
			
			UPDATE A SET  A.HLA_EndDate= @CON_BEGIN 
			FROM HospitalList  A  ,DealerAuthorizationTable B 
			WHERE A.HLA_DAT_ID =B.DAT_ID AND B.DAT_DCL_ID=@DCLID
			AND CONVERT(NVARCHAR(10),A.HLA_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120)
		END
	END
	
	IF @HasChange=1
	BEGIN
		DECLARE @CC_ID uniqueidentifier
		DECLARE @DCL_ID uniqueidentifier
		select @CC_ID=CC_ID from interface.ClassificationContract where CC_Code=@SubDepID
		IF EXISTS(select 1 from DealerContract a where a.DCL_DMA_ID=@DMA_ID and a.DCL_CC_ID=@CC_ID)
		BEGIN
			SELECT @DCL_ID=DCL_ID FROM  DealerContract a where a.DCL_DMA_ID=@DMA_ID and a.DCL_CC_ID=@CC_ID
			
			--删除已同步数据
			DELETE  A  FROM HospitalList A  WHERE A.HLA_DAT_ID IN (SELECT B.DAT_ID FROM DealerAuthorizationTableTemp B WHERE B.DAT_DCL_ID=@Contract_ID)
			DELETE  A  FROM DealerAuthorizationTable A  WHERE A.DAT_ID IN (SELECT B.DAT_ID FROM DealerAuthorizationTableTemp B WHERE B.DAT_DCL_ID=@Contract_ID)
			
			
			if @Contract_Type IN ('Appointment','Renewal')
			BEGIN
				--更新上次个合同授权终止时间
				UPDATE A SET  A.DAT_EndDate= dateadd(day,-1,@CON_BEGIN) 
				FROM DealerAuthorizationTable  A  
				WHERE DAT_DCL_ID=@DCL_ID
				AND CONVERT(NVARCHAR(10),A.DAT_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120)
				AND A.DAT_Type='Normal'
				
				UPDATE A SET  A.HLA_EndDate= dateadd(day,-1,@CON_BEGIN) 
				FROM HospitalList  A  ,DealerAuthorizationTable B 
				WHERE A.HLA_DAT_ID =B.DAT_ID AND B.DAT_DCL_ID=@DCL_ID
				AND CONVERT(NVARCHAR(10),A.HLA_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120)
				
				
				--重新维护授权信息
				INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription,DAT_StartDate,DAT_EndDate,DAT_Type)
				SELECT DAT_PMA_ID,DAT_ID,@DCL_ID,A.DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription,@CON_BEGIN,@CON_END,'Normal' 
				FROM DealerAuthorizationTableTemp A WHERE A.DAT_DCL_ID=@Contract_ID
				
				INSERT INTO HospitalList (HLA_DAT_ID,HLA_HOS_ID,HLA_ID,HLA_HOS_Depart,HLA_HOS_DepartType,HLA_HOS_DepartRemark,HLA_StartDate,HLA_EndDate)
				SELECT A.Contract_ID,A.HOS_ID,NEWID(),A.HOS_Depart,A.HOS_DepartType,A.HOS_DepartRemark,@CON_BEGIN,@CON_END 
				FROM ContractTerritory A ,DealerAuthorizationTableTemp B 
				WHERE A.Contract_ID=B.DAT_ID AND B.DAT_DCL_ID=@Contract_ID
			END
			ELSE
			BEGIN
				--正式、临时都包含的产品分类
				DECLARE @PRODUCT_CUR cursor;
				SET @PRODUCT_CUR=cursor for 
					SELECT A.DAT_ID,B.DAT_ID FROM DealerAuthorizationTable A ,DealerAuthorizationTableTemp B
							WHERE A.DAT_DCL_ID=@DCL_ID 
							AND ISNULL(B.DAT_DMA_ID_Actual,B.DAT_DMA_ID)=A.DAT_DMA_ID 
							AND B.DAT_PMA_ID=A.DAT_PMA_ID 
							AND B.DAT_ProductLine_BUM_ID=A.DAT_ProductLine_BUM_ID
							AND B.DAT_DCL_ID=@Contract_ID
							AND CONVERT(NVARCHAR(10),@CON_BEGIN,120) BETWEEN CONVERT(NVARCHAR(10),A.DAT_StartDate,120) AND CONVERT(NVARCHAR(10),A.DAT_EndDate,120)
				OPEN @PRODUCT_CUR
				FETCH NEXT FROM @PRODUCT_CUR INTO @DAT_ID,@DAT_ID_New
				WHILE @@FETCH_STATUS = 0        
					BEGIN
						--包含产品分类的授权医院
						UPDATE A SET  A.HLA_EndDate= dateadd(day,-1,@CON_BEGIN) 
						FROM HospitalList  A
						WHERE A.HLA_DAT_ID=@DAT_ID
						AND CONVERT(NVARCHAR(10),A.HLA_EndDate,120) >CONVERT(NVARCHAR(10),@CON_BEGIN,120) 
						AND NOT EXISTS (SELECT 1 FROM ContractTerritory CT WHERE CT.Contract_ID=@DAT_ID_New AND CT.HOS_ID=A.HLA_HOS_ID )
						
							
						INSERT INTO HospitalList (HLA_DAT_ID,HLA_HOS_ID,HLA_ID,HLA_HOS_Depart,HLA_HOS_DepartType,HLA_HOS_DepartRemark,HLA_StartDate,HLA_EndDate)
						SELECT @DAT_ID,A.HOS_ID,NEWID(),A.HOS_Depart,A.HOS_DepartType,A.HOS_DepartRemark,@CON_BEGIN,@CON_END 
						FROM ContractTerritory A 
						WHERE A.Contract_ID=@DAT_ID_New
						and NOT EXISTS (SELECT 1 FROM HospitalList HL 
									WHERE HL.HLA_DAT_ID=@DAT_ID 
									AND A.HOS_ID=HL.HLA_HOS_ID 
									AND CONVERT(NVARCHAR(10),HL.HLA_EndDate,120) >=CONVERT(NVARCHAR(10),@CON_BEGIN,120) )
						
						FETCH NEXT FROM @PRODUCT_CUR INTO @DAT_ID,@DAT_ID_New
					END
				CLOSE @PRODUCT_CUR
				DEALLOCATE @PRODUCT_CUR ;
				
				--正式包含临时不包含的产品分类
				UPDATE B SET B.HLA_EndDate=dateadd(day,-1,@CON_BEGIN) FROM DealerAuthorizationTable A ,HospitalList B
				WHERE A.DAT_ID=B.HLA_DAT_ID AND A.DAT_DCL_ID=@DCL_ID
				AND CONVERT(NVARCHAR(10),b.HLA_EndDate,120) >=CONVERT(NVARCHAR(10),@CON_BEGIN,120) 
				AND CONVERT(NVARCHAR(10),a.DAT_EndDate,120) >=CONVERT(NVARCHAR(10),@CON_BEGIN,120) 
				AND NOT EXISTS (SELECT 1 FROM DealerAuthorizationTableTemp C 
							WHERE C.DAT_DCL_ID=@Contract_ID 
							and a.DAT_DMA_ID=ISNULL(c.DAT_DMA_ID_Actual,c.DAT_DMA_ID) 
							and a.DAT_PMA_ID=c.DAT_PMA_ID 
							and a.DAT_ProductLine_BUM_ID=c.DAT_ProductLine_BUM_ID)
				
				UPDATE A SET A.DAT_EndDate=dateadd(day,-1,@CON_BEGIN) FROM DealerAuthorizationTable A 
				WHERE A.DAT_DCL_ID=@DCL_ID
				AND CONVERT(NVARCHAR(10),a.DAT_EndDate,120) >=CONVERT(NVARCHAR(10),@CON_BEGIN,120) 
				AND NOT EXISTS (SELECT 1 FROM DealerAuthorizationTableTemp C 
							WHERE C.DAT_DCL_ID=@Contract_ID 
							and a.DAT_DMA_ID=ISNULL(c.DAT_DMA_ID_Actual,c.DAT_DMA_ID) 
							and a.DAT_PMA_ID=c.DAT_PMA_ID 
							and a.DAT_ProductLine_BUM_ID=c.DAT_ProductLine_BUM_ID)
				
				
				--正式不包含临时包含的产品分类
				DELETE #tmp ;
				
				INSERT INTO #tmp (DAT_ID)
				SELECT A.DAT_ID
				FROM DealerAuthorizationTableTemp A WHERE A.DAT_DCL_ID=@Contract_ID
				and NOT EXISTS (SELECT 1 FROM DealerAuthorizationTable B 
						WHERE B.DAT_DCL_ID=@DCL_ID 
						AND ISNULL(A.DAT_DMA_ID_Actual,A.DAT_DMA_ID)=B.DAT_DMA_ID 
						AND A.DAT_PMA_ID=B.DAT_PMA_ID 
						AND B.DAT_ProductLine_BUM_ID=A.DAT_ProductLine_BUM_ID 
						AND (CONVERT(NVARCHAR(10),@CON_BEGIN,120) BETWEEN CONVERT(NVARCHAR(10),B.DAT_StartDate,120) AND CONVERT(NVARCHAR(10),B.DAT_EndDate,120)) )
				
				
				INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription,DAT_StartDate,DAT_EndDate,DAT_Type)
				SELECT DAT_PMA_ID,A.DAT_ID,@DCL_ID,A.DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription,@CON_BEGIN,@CON_END,'Normal' 
				FROM DealerAuthorizationTableTemp A,#tmp B WHERE A.DAT_DCL_ID=@Contract_ID AND B.DAT_ID=A.DAT_ID
				
				--不包含产品分类的授权医院
				INSERT INTO HospitalList (HLA_DAT_ID,HLA_HOS_ID,HLA_ID,HLA_HOS_Depart,HLA_HOS_DepartType,HLA_HOS_DepartRemark,HLA_StartDate,HLA_EndDate)
				SELECT A.Contract_ID,A.HOS_ID,NEWID(),A.HOS_Depart,A.HOS_DepartType,A.HOS_DepartRemark,@CON_BEGIN,@CON_END 
				FROM ContractTerritory A ,DealerAuthorizationTableTemp B ,#tmp C
				WHERE A.Contract_ID=B.DAT_ID and b.DAT_ID=c.DAT_ID AND B.DAT_DCL_ID=@Contract_ID
				
			END
		END
		ELSE
		BEGIN
			SET @DCL_ID=NEWID()
			SELECT @SAPCode=A.DMA_SAP_Code FROM DealerMaster A WHERE A.DMA_ID=@DMA_ID
			insert into DealerContract (DCL_ID,DCL_StartDate,DCL_StopDate,DCL_ContractNumber,DCL_DMA_ID,DCL_CreatedDate,DCL_CreatedBy,DCL_CC_ID)
			values(@DCL_ID,@CON_BEGIN,@CON_END,ISNULL(@SAPCode,'')+'-'+@SubDepID,@DMA_ID,GETDATE(),'00000000-0000-0000-0000-000000000000',@CC_ID)
			
			INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription,DAT_StartDate,DAT_EndDate,DAT_Type)
			SELECT DAT_PMA_ID,DAT_ID,@DCL_ID,A.DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription,@CON_BEGIN,@CON_END,'Normal' 
			FROM DealerAuthorizationTableTemp A WHERE A.DAT_DCL_ID=@Contract_ID
			
			INSERT INTO HospitalList (HLA_DAT_ID,HLA_HOS_ID,HLA_ID,HLA_HOS_Depart,HLA_HOS_DepartType,HLA_HOS_DepartRemark,HLA_StartDate,HLA_EndDate)
			SELECT A.Contract_ID,A.HOS_ID,NEWID(),A.HOS_Depart,A.HOS_DepartType,A.HOS_DepartRemark,@CON_BEGIN,@CON_END 
			FROM ContractTerritory A ,DealerAuthorizationTableTemp B 
			WHERE A.Contract_ID=B.DAT_ID AND B.DAT_DCL_ID=@Contract_ID
		END
	END
		
	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	VALUES(NEWID(),@Contract_ID,'00000000-0000-0000-0000-000000000000',GETDATE (),'Failure',@Contract_Type+' 合同 授权 同步失败:'+@vError)
	
    return -1
END CATCH
		

GO


