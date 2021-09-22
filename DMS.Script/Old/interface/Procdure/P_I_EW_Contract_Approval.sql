DROP Procedure [interface].[P_I_EW_Contract_Approval]
GO


/*
合同审批节点同步接口
*/
Create Procedure [interface].[P_I_EW_Contract_Approval]
	@InstanceID NVARCHAR(36),	  
	@Contract_Type NVARCHAR(50), 
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @RSM NVARCHAR(50)
	DECLARE @RSM_DATE DATETIME
	DECLARE @NCM NVARCHAR(50)
	DECLARE @NCM_DATE DATETIME
	DECLARE @NSM NVARCHAR(50)
	DECLARE @NSM_DATE DATETIME
	DECLARE @NCMForPart2 NVARCHAR(50)
	DECLARE @NCMForPart2_DATE DATETIME
	DECLARE @DRM NVARCHAR(50)
	DECLARE @DRM_DATE DATETIME
	DECLARE @FC NVARCHAR(50)
	DECLARE @FC_DATE DATETIME
	DECLARE @CD NVARCHAR(50)
	DECLARE @CD_DATE DATETIME
	DECLARE @VPF NVARCHAR(50)
	DECLARE @VPF_DATE DATETIME
	DECLARE @VPAP NVARCHAR(50)
	DECLARE @VPAP_DATE DATETIME
	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	SELECT TOP 1 @RSM=Name,@RSM_DATE=DoneTime FROM [interface].[Biz_Dealer_Approval] WHERE ApprovalRole='RSM' AND ApplicationID=@InstanceID ORDER BY DoneTime ;
	SELECT TOP 1 @NCM=Name,@NCM_DATE=DoneTime FROM [interface].[Biz_Dealer_Approval] WHERE ApprovalRole='NCM' AND ApplicationID=@InstanceID ORDER BY DoneTime;
	SELECT TOP 1 @NSM=Name,@NSM_DATE=DoneTime FROM [interface].[Biz_Dealer_Approval] WHERE ApprovalRole='BUM' AND ApplicationID=@InstanceID ORDER BY DoneTime ;
	SELECT TOP 1 @NCMForPart2=Name,@NCMForPart2_DATE=DoneTime FROM [interface].[Biz_Dealer_Approval] WHERE ApprovalRole='NCM' AND ApplicationID=@InstanceID ORDER BY DoneTime ;
	SELECT TOP 1 @DRM=Name,@DRM_DATE=DoneTime FROM [interface].[Biz_Dealer_Approval] WHERE ApprovalRole='DRM' AND ApplicationID=@InstanceID ORDER BY DoneTime ;
	SELECT TOP 1 @FC=Name,@FC_DATE=DoneTime FROM [interface].[Biz_Dealer_Approval] WHERE ApprovalRole='FC' AND ApplicationID=@InstanceID ORDER BY DoneTime ;
	SELECT TOP 1 @CD=Name,@CD_DATE=DoneTime FROM [interface].[Biz_Dealer_Approval] WHERE ApprovalRole='CD' AND ApplicationID=@InstanceID ORDER BY DoneTime ;
	SELECT TOP 1 @VPF=Name,@VPF_DATE=DoneTime FROM [interface].[Biz_Dealer_Approval] WHERE ApprovalRole='VPF' AND ApplicationID=@InstanceID ORDER BY DoneTime ;
	SELECT TOP 1 @VPAP=Name,@VPAP_DATE=DoneTime FROM [interface].[Biz_Dealer_Approval] WHERE ApprovalRole='VPAP' AND ApplicationID=@InstanceID ORDER BY DoneTime ;
		
	IF (@Contract_Type='Appointment')
	BEGIN
		UPDATE ContractAppointment 
		 SET CAP_RSM_PrintName=@RSM
		,CAP_RSM_Date=@RSM_DATE
		,CAP_NCM_PrintName=@NCM
		,CAP_NCM_Date=@NCM_DATE
		,CAP_NSM_PrintName=@NSM
		,CAP_NSM_Date=@NSM_DATE
		,CAP_NCMForPart2_PrintName=@NCMForPart2
		,CAP_NCMForPart2_Date=@NCMForPart2_DATE
		,CAP_DRM_PrintName=@DRM
		,CAP_DRM_Date=@DRM_DATE
		,CAP_FC_PrintName=@FC
		,CAP_FC_Date=@FC_DATE
		,CAP_CD_PrintName=@CD
		,CAP_CD_Date=@CD_DATE
		,CAP_VPF_PrintName=@VPF
		,CAP_VPF_Date=@VPF_DATE
		,CAP_VPAP_PrintName=@VPAP
		,CAP_VPAP_Date=@VPAP_DATE
		WHERE CAP_ID=@InstanceID
	END
	IF (@Contract_Type='Amendment')
	BEGIN
		UPDATE ContractAmendment 
		 SET CAM_RSM_PrintName=@RSM
		,CAM_RSM_Date=@RSM_DATE
		,CAM_NCM_PrintName=@NCM
		,CAM_NCM_Date=@NCM_DATE
		,CAM_NSM_PrintName=@NSM
		,CAM_NSM_Date=@NSM_DATE
		,CAM_NCMForPart2_PrintName=@NCMForPart2
		,CAM_NCMForPart2_Date=@NCMForPart2_DATE
		,CAM_DRM_PrintName=@DRM
		,CAM_DRM_Date=@DRM_DATE
		,CAM_FC_PrintName=@FC
		,CAM_FC_Date=@FC_DATE
		,CAM_CD_PrintName=@CD
		,CAM_CD_Date=@CD_DATE
		,CAM_VPF_PrintName=@VPF
		,CAM_VPF_Date=@VPF_DATE
		,CAM_VPAP_PrintName=@VPAP
		,CAM_VPAP_Date=@VPAP_DATE
		WHERE CAM_ID=@InstanceID
	END
	IF (@Contract_Type='Renewal')
	BEGIN
		UPDATE ContractRenewal
		 SET  CRE_RSM_PrintName=@RSM
		,CRE_RSM_Date=@RSM_DATE
		,CRE_NCM_PrintName=@NCM
		,CRE_NCM_Date=@NCM_DATE
		,CRE_NSM_PrintName=@NSM
		,CRE_NSM_Date=@NSM_DATE
		,CRE_NCMForPart2_PrintName=@NCMForPart2
		,CRE_NCMForPart2_Date=@NCMForPart2_DATE
		,CRE_DRM_PrintName=@DRM
		,CRE_DRM_Date=@DRM_DATE
		,CRE_FC_PrintName=@FC
		,CRE_FC_Date=@FC_DATE
		,CRE_CD_PrintName=@CD
		,CRE_CD_Date=@CD_DATE
		,CRE_VPF_PrintName=@VPF
		,CRE_VPF_Date=@VPF_DATE
		,CRE_VPAP_PrintName=@VPAP
		,CRE_VPAP_Date=@VPAP_DATE
		WHERE CRE_ID=@InstanceID
	END
	IF (@Contract_Type='Termination')
	BEGIN
		UPDATE ContractTermination
		 SET  CTE_RSM_PrintName=@RSM
		,CTE_RSM_Date=@RSM_DATE
		,CTE_NCM_PrintName=@NCM
		,CTE_NCM_Date=@NCM_DATE
		,CTE_NSM_PrintName=@NSM
		,CTE_NSM_Date=@NSM_DATE
		,CTE_NCMForPart2_PrintName=@NCMForPart2
		,CTE_NCMForPart2_Date=@NCMForPart2_DATE
		,CTE_DRM_PrintName=@DRM
		,CTE_DRM_Date=@DRM_DATE
		,CTE_FC_PrintName=@FC
		,CTE_FC_Date=@FC_DATE
		,CTE_CD_PrintName=@CD
		,CTE_CD_Date=@CD_DATE
		,CTE_VPF_PrintName=@VPF
		,CTE_VPF_Date=@VPF_DATE
		,CTE_VPAP_PrintName=@VPAP
		,CTE_VPAP_Date=@VPAP_DATE
		WHERE CTE_ID=@InstanceID;
		
		UPDATE TerminationForm
		SET TF_RSM_PrintName=@DRM
		,TF_RSM_Date=@DRM_DATE
		,TF_FM_PrintName=@FC
		,TF_FM_Date=@FC_DATE
		,TF_VPFinance_PrintName=@VPF
		,TF_VPFinance_Date=@VPF_DATE
		,TF_VP_PrintName=@VPAP
		,TF_VP_Date=@VPAP_DATE
		WHERE TF_ID=@InstanceID;
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


