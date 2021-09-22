DROP PROCEDURE [dbo].[Proc_CreateNewDirectSellingHospital]
GO




/**********************************************
	功能：创建直销医院账号
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2016-08-31
**********************************************/
Create PROCEDURE [dbo].[Proc_CreateNewDirectSellingHospital]
	@HospitalSAPCode nvarchar(200),	--直销医院SAP账号
	@HospitalName nvarchar(200),	--直销医院名称
	@ShortName nvarchar(200),	--英文编号
	@RtnVal nvarchar(200) OUTPUT,
	@RtnMsg nvarchar(Max) OUTPUT
WITH EXEC AS CALLER
AS
DECLARE @DMA_ID uniqueidentifier

SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	CREATE TABLE #tbCon
	(
		CC_ID uniqueidentifier,
		CC_Code NVARCHAR(100),
		CC_Division  INT ,
		CC_ProductLineId uniqueidentifier
	)

	
	--SELECT * FROM DealerMaster where  Dma_dealerType='T1'
	--1 创建账号
	SET @DMA_ID=NEWID();
	INSERT INTO DealerMaster (DMA_ID,DMA_ChineseName,DMA_ChineseShortName,DMA_EnglishName,DMA_SAP_Code,DMA_DealerType,DMA_FirstContractDate,DMA_ActiveFlag,DMA_DeletedFlag,DMA_DealerAuthentication,DMA_Parent_DMA_ID,DMA_Taxpayer,DMA_EnglishShortName)
	VALUES(@DMA_ID,@HospitalName,@HospitalName+'-T1-'+@HospitalSAPCode,NULL,@HospitalSAPCode,'T1',GETDATE(),1,0,'Normal','FB62D945-C9D7-4B0F-8D26-4672D2C728B7','直销医院',@ShortName)
	
	DECLARE @IDENTITY_ID uniqueidentifier
	DECLARE @IDENTITY_ID_ADMIN uniqueidentifier
	SET @IDENTITY_ID=NEWID();
	SET @IDENTITY_ID_ADMIN=NEWID();
	INSERT INTO Lafite_IDENTITY 
				(Id,IDENTITY_CODE,LOWERED_IDENTITY_CODE,IDENTITY_NAME,
				BOOLEAN_FLAG,IDENTITY_TYPE,LastActivityDate,Corp_ID,APP_ID,DELETE_FLAG,
				CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE,REV1)
			VALUES(@IDENTITY_ID,@HospitalSAPCode+'_01',@HospitalSAPCode+'_01',@HospitalName,
				1,'Dealer',getdate(),@DMA_ID,'4028931b0f0fc135010f0fc1356a0001',0,
				'00000000-0000-0000-0000-000000000000',GETDATE(),'00000000-0000-0000-0000-000000000000',GETDATE(),'D');
	INSERT INTO Lafite_IDENTITY 
				(Id,IDENTITY_CODE,LOWERED_IDENTITY_CODE,IDENTITY_NAME,
				BOOLEAN_FLAG,IDENTITY_TYPE,LastActivityDate,Corp_ID,APP_ID,DELETE_FLAG,
				CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE,REV1)
			VALUES(@IDENTITY_ID_ADMIN,@HospitalSAPCode+'_99',@HospitalSAPCode+'_99',@HospitalName,
				1,'Dealer','1754-01-01',@DMA_ID,'4028931b0f0fc135010f0fc1356a0001',0,
				'00000000-0000-0000-0000-000000000000',GETDATE(),'00000000-0000-0000-0000-000000000000',GETDATE(),'D');
				
	INSERT INTO dbo.Lafite_Membership
	values(@IDENTITY_ID,'JwSWJpN51898uJjc7eriHZY/MSc=','1','rcmX5PF2DpzU5uP09ilGuA==',
	null,'','',null,null,'4028931b0f0fc135010f0fc1356a0001',1,0,GETDATE(),GETDATE(),'j3Mj1nPQ5V3HA5wvn6CvSvMq0qY=',GETDATE(),GETDATE(),0,GETDATE(),'0',GETDATE(),null)

	INSERT INTO dbo.Lafite_Membership
	values(@IDENTITY_ID_ADMIN,'JwSWJpN51898uJjc7eriHZY/MSc=','1','rcmX5PF2DpzU5uP09ilGuA==',
	null,'','',null,null,'4028931b0f0fc135010f0fc1356a0001',1,0,GETDATE(),GETDATE(),'j3Mj1nPQ5V3HA5wvn6CvSvMq0qY=',GETDATE(),GETDATE(),0,GETDATE(),'0',GETDATE(),null)

	--insert into [dbo].[Lafite_IDENTITY_MAP]([Id],[IDENTITY_ID],[MAP_TYPE],[MAP_ID],[APP_ID],[DELETE_FLAG],[CREATE_USER],[CREATE_DATE],[LAST_UPDATE_USER],[LAST_UPDATE_DATE]) 
	--values (NEWID(),@IDENTITY_ID,'Role','5fb483d8-e1c0-47d7-b6fa-a2bc00b73fc5','4028931b0f0fc135010f0fc1356a0001','0','Administrator',GETDATE(),'Administrator',GETDATE());

	--insert into [dbo].[Lafite_IDENTITY_MAP]([Id],[IDENTITY_ID],[MAP_TYPE],[MAP_ID],[APP_ID],[DELETE_FLAG],[CREATE_USER],[CREATE_DATE],[LAST_UPDATE_USER],[LAST_UPDATE_DATE]) 
	--values (NEWID(),@IDENTITY_ID_ADMIN,'Role','5fb483d8-e1c0-47d7-b6fa-a2bc00b73fc5','4028931b0f0fc135010f0fc1356a0001','0','Administrator',GETDATE(),'Administrator',GETDATE());

	--EXEC [dbo].[GC_Cache_InitDealer];
	
	--2 合同
	INSERT INTO #tbCon(CC_ID,CC_CODE,CC_Division,CC_ProductLineId)
	SELECT A.CC_ID,A.CC_Code,a.CC_Division,b.ProductLineID FROM interface.ClassificationContract A 
	inner join V_DivisionProductLineRelation b on a.CC_Division=b.DivisionCode and b.IsEmerging=0
	WHERE A.CC_NameCN NOT LIKE '%新兴%' AND A.CC_NameCN NOT LIKE '%平台%' AND A.CC_NameCN NOT LIKE '%蓝海%'
	
	
	
	
	INSERT INTO DealerContractMaster
	(DCM_CC_ID,[DCM_ID],[DCM_DMA_ID],[DCM_Division],[DCM_MarketType],[DCM_ContractType],[DCM_DealerType],[DCM_BSCEntity]
	,[DCM_Exclusiveness],[DCM_EffectiveDate],[DCM_ExpirationDate],[DCM_ProductLine],[DCM_ProductLineRemark],[DCM_Delete_flag],
	[DCM_Update_Date],[DCM_FirstContractDate],DCM_FristCooperationDate)
	SELECT a.CC_ID,NEWID(),@DMA_ID,a.CC_Division,
		(SELECT DISTINCT TOP 1   b.DCM_MarketType FROM DealerContractMaster b WHERE a.CC_ID=b.DCM_CC_ID and b.DCM_MarketType is not null),
		'Dealer','T1','China','Exclusive',
	getdate(),'2099-12-31','All',NULL,0,getdate(),getdate(),getdate() FROM #tbCon a
	
	
	--3 授权
	
	DECLARE @HasDCL_ID uniqueidentifier
	DECLARE @CON_NUMB NVARCHAR(200);
	DECLARE @Hospital_ID uniqueidentifier
	
	SET @HasDCL_ID=NULL;
	SELECT @HasDCL_ID=DCL_ID FROM DealerContract A WHERE A.DCL_DMA_ID=@DMA_ID
	IF @HasDCL_ID IS NULL
	BEGIN
		SELECT @CON_NUMB='Contract-'+CONVERT(VARCHAR,(MAX(substring(DCL_ContractNumber,10,LEN(DCL_ContractNumber)))+1),20) FROM DealerContract WHERE DCL_ContractNumber  NOT IN ('Contract-TM','Contract-GKHT')
		SET @HasDCL_ID=NEWID();

		INSERT INTO DealerContract(DCL_ID,DCL_StartDate,DCL_ApprovedBy,DCL_StopDate,DCL_ContractNumber,DCL_ContractYears,DCL_DMA_ID,DCL_Approval_ID,DCL_CreatedDate,DCL_CreatedBy)
		VALUES(@HasDCL_ID,GETDATE(),NULL,'2099-12-31',@CON_NUMB,NULL,@DMA_ID,NULL,GETDATE(),'00000000-0000-0000-0000-000000000000');

		INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,	DAT_ID,	DAT_DCL_ID,	DAT_DMA_ID,	DAT_ProductLine_BUM_ID,	DAT_AuthorizationType,DAT_StartDate,DAT_EndDate,DAT_Type)
		SELECT DISTINCT A.CA_ID,NEWID(),@HasDCL_ID,@DMA_ID,b.CC_ProductLineId ,case when a.CA_ID=b.CC_ProductLineId then '0' else '1' end,GETDATE(),'2099-12-31'  ,'Normal' 
		FROM INTERFACE.ClassificationAuthorization A ,#tbCon B 
		WHERE A.CA_ParentCode=B.CC_Code 
		AND A.CA_NameCN  NOT LIKE '%LP%'
		AND A.CA_NameCN  NOT LIKE '%平台%'
		
		SELECT @Hospital_ID=a.HOS_ID FROM Hospital A WHERE A.HOS_HospitalName=@HospitalName
		IF @Hospital_ID IS NOT NULL
		BEGIN
		insert into HospitalList (HLA_DAT_ID,HLA_HOS_ID,HLA_ID,HLA_StartDate,HLA_EndDate)
		SELECT A.DAT_ID,@Hospital_ID,NEWID(),GETDATE(),'2099-12-31' FROM DealerAuthorizationTable A WHERE A.DAT_DMA_ID=@DMA_ID
		END
		
	END
	
	EXEC [dbo].[GC_OpenAccountPermissions_New] @DMA_ID
	
										
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
    return -1
END CATCH

GO


