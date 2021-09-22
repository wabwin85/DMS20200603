
/****** Object:  StoredProcedure [Workflow].[Proc_DealerMasterLicense_GetFormData]    Script Date: 2019/12/16 15:54:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Workflow].[Proc_DealerMasterLicense_GetFormData]
	@InstanceId uniqueidentifier
AS

--DECLARE @RecordCount INT
--SELECT @RecordCount = COUNT(1) FROM DealerMasterLicenseModify WHERE DML_MID = @InstanceId

--DECLARE @DealerId uniqueidentifier
--SELECT @DealerId= A.DML_DMA_ID FROM DealerMasterLicenseModify A WHERE DML_MID = @InstanceId
--IF @RecordCount = 1
--	BEGIN
--		IF EXISTS (SELECT 1 FROM SAPWarehouseAddress A WHERE A.SWA_DMA_ID=@DealerId)
--		BEGIN
--			SELECT '0' AS IsNewDealer
--		END
--		ELSE
--		BEGIN
--			SELECT '1' AS IsNewDealer
--		END
		
--	END
select 1 'NoData'