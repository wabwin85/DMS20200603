DROP PROCEDURE [dbo].[Pro_Authorization_Init]
GO

/**********************************************
	功能：经销商授权产品初始化
	作者：Huakaichun
	最后更新时间：	2016-06-14
	更新记录说明：
	1.创建 2016-06-14
**********************************************/
CREATE PROCEDURE [dbo].[Pro_Authorization_Init]
	
WITH EXEC AS CALLER
AS
DECLARE @LastContractId uniqueidentifier
	 
CREATE TABLE #ConTol
(
	ContractId uniqueidentifier,
	DealerId uniqueidentifier,
	SubBU NVARCHAR(50),
	MarketType INT,
	BeginDate DATETIME,
	EndDate DATETIME,
	ContractType NVARCHAR(50),
	UpdateDate DATETIME
)

CREATE TABLE #AuHospital
(
	ContractType nvarchar(50),
	ProductLineId uniqueidentifier,
	PctId uniqueidentifier,
	DealerId uniqueidentifier,
	HospitalId uniqueidentifier,
	BeginDate DATETIME,
	EndDate DATETIME,
	Row INT
)
	
SET NOCOUNT ON

BEGIN TRY

--BEGIN TRAN

INSERT INTO #ConTol (ContractId,DealerId,MarketType,BeginDate,EndDate,SubBU,ContractType,UpdateDate)
SELECT a.CAP_ID,a.CAP_DMA_ID,a.CAP_MarketType,CAP_EffectiveDate,CAP_ExpirationDate,a.CAP_SubDepID ,'Appointment',CAP_Update_Date from ContractAppointment a where a.CAP_Status='Completed' 
UNION
SELECT a.CAM_ID,a.CAM_DMA_ID,a.CAM_MarketType,CAM_Amendment_EffectiveDate,CAM_Agreement_ExpirationDate,a.CAM_SubDepID,'Amendment',CAM_Update_Date from ContractAmendment a where a.CAM_Status='Completed' and a.CAM_Territory_IsChange='1'
UNION
SELECT  a.CRE_ID,a.CRE_DMA_ID,a.CRE_MarketType,CRE_Agrmt_EffectiveDate_Renewal,CRE_Agrmt_ExpirationDate_Renewal,a.CRE_SubDepID,'Renewal',CRE_Update_Date  from ContractRenewal a where a.CRE_Status='Completed' 
UNION
SELECT  a.CTE_ID,a.CTE_DMA_ID,a.CTE_MarketType,CTE_Termination_EffectiveDate,NULL,a.CTE_SubDepID,'Termination',CTE_Update_Date  from ContractTermination a where a.CTE_Status='Completed' 

--获取2016合同
DECLARE @ContractId uniqueidentifier
DECLARE @ContractType nvarchar(50)
DECLARE @SubBU nvarchar(50)
DECLARE @BeginDate datetime
DECLARE @Enddate datetime
DECLARE @Row int


DECLARE @ProductLineId uniqueidentifier
DECLARE @PctId uniqueidentifier
DECLARE @DealerId uniqueidentifier
DECLARE @HospitalId uniqueidentifier
set @ContractType=null
set @ProductLineId=null 
set @PctId=null
set @DealerId=null 
set @HospitalId=null
set @BeginDate=null
set @EndDate=null

DECLARE @PRODUCT_CUR cursor;
SET @PRODUCT_CUR=cursor for 
	select ContractId,ContractType,SubBU,BeginDate,EndDate, DealerId from #ConTol where YEAR(EndDate)>=2016  order by UpdateDate ASC
OPEN @PRODUCT_CUR
FETCH NEXT FROM @PRODUCT_CUR INTO @ContractId,@ContractType,@SubBU,@BeginDate,@Enddate,@DealerId
WHILE @@FETCH_STATUS = 0        
BEGIN
	if @ContractType='Appointment'
	begin
		update A set a.DAT_StartDate=@BeginDate,a.DAT_EndDate=@Enddate   ,a.DAT_Type='Normal'
		from DealerAuthorizationTable(NOLOCK) a  
		inner join DealerAuthorizationTableTemp(NOLOCK) b on a.DAT_DMA_ID= b.DAT_DMA_ID_Actual 
		and a.DAT_ProductLine_BUM_ID=b.DAT_ProductLine_BUM_ID  and a.DAT_PMA_ID=b.DAT_PMA_ID
		where b.DAT_DCL_ID=@ContractId
		;
		
		update A set a.HLA_StartDate=@BeginDate,a.HLA_EndDate=@Enddate  
		from HospitalList(NOLOCK) a
		inner join DealerAuthorizationTable(NOLOCK)  b on a.HLA_DAT_ID=b.DAT_ID
		inner join DealerAuthorizationTableTemp(NOLOCK) c on b.DAT_DMA_ID= c.DAT_DMA_ID_Actual 
		and b.DAT_ProductLine_BUM_ID=c.DAT_ProductLine_BUM_ID  and b.DAT_PMA_ID=c.DAT_PMA_ID
		inner join ContractTerritory(NOLOCK) d on c.DAT_ID=d.Contract_ID and d.HOS_ID=a.HLA_HOS_ID
		where c.DAT_DCL_ID=@ContractId;
	end
	else if @ContractType='Amendment' or @ContractType='Renewal'
	begin
		--新授权产品添加开始时间与终止时间
		update A set a.DAT_StartDate=@BeginDate,a.DAT_EndDate=@Enddate   ,a.DAT_Type='Normal'
		from DealerAuthorizationTable(NOLOCK) a  
		inner join DealerAuthorizationTableTemp(NOLOCK) b on a.DAT_DMA_ID= b.DAT_DMA_ID_Actual 
		and a.DAT_ProductLine_BUM_ID=b.DAT_ProductLine_BUM_ID  and a.DAT_PMA_ID=b.DAT_PMA_ID
		where b.DAT_DCL_ID=@ContractId and (a.DAT_StartDate is  null  or  a.DAT_EndDate is  null);
		
		--终止授权的产品修改终止时间
		update A set a.DAT_EndDate=@BeginDate   
		from DealerAuthorizationTable(NOLOCK) a  
		where a.DAT_DMA_ID =@DealerId
		and a.DAT_PMA_ID in (select b.CA_ID from interface.ClassificationAuthorization(NOLOCK) b where b.CA_ParentCode=@SubBU)
		and not exists (select 1 from DealerAuthorizationTableTemp(NOLOCK) c where C.DAT_DCL_ID=@ContractId AND c.DAT_DMA_ID_Actual=a.DAT_DMA_ID and c.DAT_ProductLine_BUM_ID=a.DAT_ProductLine_BUM_ID and c.DAT_PMA_ID=a.DAT_PMA_ID)
		and (a.DAT_StartDate is not null or a.DAT_EndDate is not null );
		
		--新授权的医院添加合作时间
		update A set a.HLA_StartDate=@BeginDate,a.HLA_EndDate=@Enddate  
		from HospitalList(NOLOCK) a
		inner join DealerAuthorizationTable(NOLOCK) b on a.HLA_DAT_ID=b.DAT_ID
		inner join DealerAuthorizationTableTemp(NOLOCK) c on b.DAT_DMA_ID= c.DAT_DMA_ID_Actual 
		and b.DAT_ProductLine_BUM_ID=c.DAT_ProductLine_BUM_ID  and b.DAT_PMA_ID=c.DAT_PMA_ID
		inner join ContractTerritory (NOLOCK)d on c.DAT_ID=d.Contract_ID and d.HOS_ID=a.HLA_HOS_ID
		where c.DAT_DCL_ID=@ContractId and (a.HLA_StartDate is  null  or  a.HLA_EndDate is  null);
		
		--终止授权医院修改终止时间
		--产品线被拿掉
		update A set a.HLA_EndDate=@BeginDate  
		from HospitalList(NOLOCK) a
		inner join DealerAuthorizationTable(NOLOCK) b on a.HLA_DAT_ID=b.DAT_ID
		where  
		b.DAT_DMA_ID =@DealerId
		and b.DAT_PMA_ID in (select d.CA_ID from interface.ClassificationAuthorization d where d.CA_ParentCode=@SubBU)
		and not exists (select 1 from DealerAuthorizationTableTemp c where c.DAT_DCL_ID=@ContractId and  c.DAT_DMA_ID_Actual=b.DAT_DMA_ID and c.DAT_ProductLine_BUM_ID=b.DAT_ProductLine_BUM_ID and c.DAT_PMA_ID=b.DAT_PMA_ID)
		and (A.HLA_StartDate is not null or a.HLA_EndDate is not null );
		
		--产品线保留，授权医院被拿掉
		update A set a.HLA_EndDate=@BeginDate  
		from HospitalList(NOLOCK) a
		inner join DealerAuthorizationTable(NOLOCK) b on a.HLA_DAT_ID=b.DAT_ID
		inner join DealerAuthorizationTableTemp(NOLOCK) c on b.DAT_DMA_ID= c.DAT_DMA_ID_Actual 
		and b.DAT_ProductLine_BUM_ID=c.DAT_ProductLine_BUM_ID  and b.DAT_PMA_ID=c.DAT_PMA_ID
		and not exists(select 1 from ContractTerritory(NOLOCK) d where d.Contract_ID=c.DAT_ID and d.HOS_ID=a.HLA_HOS_ID)
		where c.DAT_DCL_ID=@ContractId and (a.HLA_StartDate is  null  or  a.HLA_EndDate is  null);  
		
	end
	
	else if @ContractType='Termination'
	begin
		update DealerAuthorizationTable set DAT_EndDate=@BeginDate
		where DAT_DMA_ID=@DealerId
		and DAT_PMA_ID in (select distinct CA_ID from interface.ClassificationAuthorization(NOLOCK) where CA_ParentCode=@SubBU)
		and (DAT_StartDate is not null or DAT_EndDate is not null ); 
		
		update A set  a.HLA_EndDate=@BeginDate from HospitalList(NOLOCK) a 
		inner join   DealerAuthorizationTable(NOLOCK) b on a.HLA_DAT_ID=b.DAT_ID
		where b.DAT_DMA_ID=@DealerId
		and DAT_PMA_ID in (select distinct CA_ID from interface.ClassificationAuthorization(NOLOCK) where CA_ParentCode=@SubBU)
		and (a.HLA_StartDate is not null or a.HLA_EndDate is not null ); 
	end
	
	PRINT @DealerId
FETCH NEXT FROM @PRODUCT_CUR INTO @ContractId,@ContractType,@SubBU,@BeginDate,@Enddate,@DealerId
END
CLOSE @PRODUCT_CUR
DEALLOCATE @PRODUCT_CUR ;


--COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	select @vError
	
	
END CATCH	
GO


