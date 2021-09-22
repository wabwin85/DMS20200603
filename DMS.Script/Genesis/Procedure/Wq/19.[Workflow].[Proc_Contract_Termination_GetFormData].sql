﻿
/****** Object:  StoredProcedure [Workflow].[Proc_Contract_Termination_GetFormData]    Script Date: 2019/11/21 21:47:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [Workflow].[Proc_Contract_Termination_GetFormData]
	@InstanceId UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @RequestNo NVARCHAR(200);
	DECLARE @BU NVARCHAR(200);
	DECLARE @RequestType NVARCHAR(200);
	DECLARE @SubBu NVARCHAR(200);
	DECLARE @AllTotalUSD NVARCHAR(200);
	DECLARE @DealerType NVARCHAR(200);
	DECLARE @PayType NVARCHAR(200);
	DECLARE @RSM NVARCHAR(200);
	DECLARE @Property NVARCHAR(200);
	DECLARE @IsLanWei NVARCHAR(20);
	DECLARE @DealerName NVARCHAR(200);
	DECLARE @LPName NVARCHAR(200);

	--SELECT @RequestNo = ISNULL(Main.ContractNo, ''),
	--       @BU = ISNULL(Main.DepId, ''),
	--       @RequestType = CASE 
	--                           WHEN Main.DealerType = 'Trade' THEN '2'
	--                           ELSE '1'
	--                      END,
	--       @SubBu = ISNULL(Main.SUBDEPID, ''),
	--       @AllTotalUSD = ISNULL(CONVERT(NVARCHAR(20), Main.QUOTAUSD), ''),
	--       @DealerType = ISNULL(Main.DealerType, ''),
	--       @PayType = '',
	--       @RSM = CASE 
	--                   WHEN ISNULL(Main.ReagionRSM, '') = '0' THEN ''
	--                   ELSE ISNULL(Main.ReagionRSM, '')
	--              END,
	--       @Property = ISNULL(Main.MarketType, ''),
	--       @IsLanWei = CASE 
	--                   WHEN ISNULL(Main.EId, '') = '503800' THEN '1'
	--                   ELSE '0'
	--              END
	--FROM   [Contract].TerminationMain Main
	--WHERE  Main.ContractId = @InstanceId;
	
	--SELECT @RequestNo RequestNo,
	--       @BU BU,
	--       @RequestType RequestType,
	--       @SubBu SubBu,
	--       @AllTotalUSD AllTotalUSD,
	--       @DealerType DealerType,
	--       @PayType PayType,
	--       CASE WHEN @SubBu IN ('C1703') THEN '1'  --设备
	--			WHEN @SubBu IN ('C1702', 'C1706') THEN '2'  --耗材
	--			--WHEN @SubBu IN ('C1710') AND EXISTS (SELECT 1 FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@InstanceId AND DAT_PMA_ID='7F7A3087-6B05-41FB-9EBF-2FFE62955342')
	--			--	THEN '2' --蓝海耗材
	--			ELSE '0' END IsRovus, --非Rovus
	--       @Property Property,
	--       @IsLanWei IsLanWei
	SELECT @RequestNo = ISNULL(Main.ContractNo, ''),
	       @DealerType = CASE Main.DealerType WHEN 'LP' THEN '平台' WHEN 'T1' THEN '一级经销商'
		   WHEN 'T2' THEN '二级经销商' WHEN 'LS' THEN '服务商' ELSE ''END,
		   @DealerName = ISNULL(DM.DMA_ChineseName, ''),
		   @LPName = CASE Main.DealerType WHEN 'T2' THEN ld.VALUE1 ELSE '' END
	FROM       [Contract].TerminationMain Main
	INNER JOIN DealerMaster DM ON Main.DealerName=DM.DMA_SAP_Code
	LEFT JOIN DealerMaster LPDM ON LPDM.DMA_ID=DM.DMA_Parent_DMA_ID
	LEFT JOIN  Lafite_DICT ld ON LPDM.DMA_SAP_Code=ld.DICT_KEY AND DICT_TYPE='CONST_LPSAPCodeKey'
	WHERE      Main.ContractId = @InstanceId


	SELECT @RequestNo fd_contract_number,
			   @DealerType fd_dealer_type,
			   @DealerName fd_dealer_name,
			   @DealerType +'合同终止' fd_contract_type
END


