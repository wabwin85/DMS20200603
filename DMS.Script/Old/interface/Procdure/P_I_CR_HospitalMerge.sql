DROP Procedure [interface].[P_I_CR_HospitalMerge]
GO


/*
医院合并处理接口
*/
CREATE Procedure [interface].[P_I_CR_HospitalMerge]
	@CurHosCode NVARCHAR(50),	  
	@newHosCode NVARCHAR(50), 
  @RtnVal NVARCHAR(20) OUTPUT,
  @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @ErrFlag NVARCHAR(50)
	DECLARE @HosRowCnt INT
  
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
  SET @ErrFlag = 'Correct'
  SET @HosRowCnt = 0
	
	--新老医院合并的逻辑
  --校验新老医院的编号是否存在

	select @HosRowCnt=count(*) from hospital where HOS_Key_Account = @CurHosCode
	IF @HosRowCnt = 0
	BEGIN
	  SET @ErrFlag='Error'
	  SET @RtnMsg = '当前医院编号不存在'
	END
 
  

  select @HosRowCnt=count(*) from hospital where HOS_Key_Account = @newHosCode
  IF @HosRowCnt = 0
    BEGIN
      SET @ErrFlag='Error'
      SET @RtnMsg = '新医院编号不存在'
    END


  IF @ErrFlag = 'Correct'
    BEGIN
      --1、将原医院的ActiveFlag改为"无效"
      UPDATE Hospital
         SET HOS_ActiveFlag = 0
       WHERE HOS_Key_Account = @CurHosCode
  
      --2、授权表中增加新医院的授权（原医院不用删除）
       update HospitalList set HLA_HOS_ID=(SELECT TOP 1 hos_id FROM Hospital WHERE HOS_Key_Account = @newHosCode)
                  where HLA_HOS_ID in (SELECT TOP 1 hos_id FROM Hospital WHERE HOS_Key_Account = @CurHosCode)
      
      --INSERT INTO HospitalList (HLA_DAT_ID, HLA_HOS_ID, HLA_ID)
      --     SELECT HL.HLA_DAT_ID,
      --            (SELECT TOP 1 hos_id
      --               FROM Hospital
      --              WHERE HOS_Key_Account = @newHosCode),
      --            NEWID ()
      --       FROM HospitalList HL,
      --            hospital H,
      --            DealerAuthorizationTable DAT,
      --            V_DealerContractMaster AS DCM,
      --            V_DivisionProductLineRelation AS DPL
      --      WHERE     HL.HLA_HOS_ID = H.HOS_ID
      --            AND HL.HLA_DAT_ID = DAT.DAT_ID
      --            AND DAT.DAT_DMA_ID = DCM.DMA_ID
      --            AND DAT.DAT_ProductLine_BUM_ID = DPL.ProductLineID
      --            AND DPL.DivisionCode = DCM.Division
      --            AND H.HOS_Key_Account = @CurHosCode
      --            AND DCM.ActiveFlag = 1
      
      --3、将当前仓库对应的医院也改为新医院
      UPDATE WH
         SET WHM_Hospital_HOS_ID = NewHos.hos_id
        FROM warehouse AS WH,
             (SELECT TOP 1 hos_id
                FROM Hospital
               WHERE HOS_Key_Account = @newHosCode) AS NewHos
       WHERE WHM_Hospital_HOS_ID IN (SELECT hos_id
                                       FROM Hospital
                                      WHERE HOS_Key_Account = @CurHosCode)
      
      --4、将医院指标对应医院更改为新医院
      --HospitalProduct
      UPDATE AOPICDealerHospital SET AOPICH_Hospital_ID=(SELECT TOP 1 hos_id FROM Hospital WHERE HOS_Key_Account = @newHosCode)
				WHERE AOPICH_Hospital_ID=(SELECT TOP 1 hos_id FROM Hospital WHERE HOS_Key_Account = @CurHosCode);
      --Hospital
      UPDATE AOPDealerHospital SET AOPDH_Hospital_ID=(SELECT TOP 1 hos_id FROM Hospital WHERE HOS_Key_Account = @newHosCode)
				WHERE AOPDH_Hospital_ID=(SELECT TOP 1 hos_id FROM Hospital WHERE HOS_Key_Account = @CurHosCode);
      
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
  return -1
END CATCH





GO


