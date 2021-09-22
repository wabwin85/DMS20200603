
/****** Object:  StoredProcedure [Workflow].[Proc_Contract_Amendment_GetFormData]    Script Date: 2019/11/21 21:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Workflow].[Proc_Contract_Amendment_GetFormData]
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
	DECLARE @DiffQuato NVARCHAR(200);
	DECLARE @IsFirstIC NVARCHAR(200);
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
	--       @AllTotalUSD = ISNULL(CONVERT(NVARCHAR(20), Proposals.AllProductAopUSD), ''),
	--       @DealerType = ISNULL(Main.DealerType, ''),
	--       @PayType = ISNULL(Proposals.Payment, ''),
	--       @RSM = CASE 
	--                   WHEN ISNULL(Main.ReagionRSM, '') = '0' THEN ''
	--                   ELSE ISNULL(Main.ReagionRSM, '')
	--              END,
	--       @DiffQuato = Proposals.QUATOUP,
	--       @IsFirstIC = dbo.GC_Fn_IsNoFirstContract(Main.CompanyID, Main.DepId),
	--       @Property = ISNULL(Main.MarketType, ''),
	--       @IsLanWei = CASE 
	--                   WHEN ISNULL(Main.EId, '') = '503800' THEN '1'
	--                   ELSE '0'
	--              END
	--FROM   [Contract].AmendmentMain Main,
	--       [Contract].AmendmentProposals Proposals
	--WHERE  Main.ContractId = Proposals.ContractId
	--       AND Main.ContractId = @InstanceId;
	
	--SELECT @RequestNo RequestNo,
	--       @BU BU,
	--       @RequestType RequestType,
	--       @SubBu SubBu,
	--       @AllTotalUSD AllTotalUSD,
	--       @DealerType DealerType,
	--       @PayType PayType,
	--       CASE WHEN @SubBu IN ('C1703') THEN '1'  --设备
	--			WHEN @SubBu IN ('C1705', 'C1706') THEN '2'  --耗材
	--			--WHEN @SubBu IN ('C1710') AND EXISTS (SELECT 1 FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@InstanceId AND DAT_PMA_ID='7F7A3087-6B05-41FB-9EBF-2FFE62955342')
	--			--	THEN '2' --蓝海耗材
	--			ELSE '0' END IsRovus, --非Rovus
	--       @DiffQuato DiffQuato,
	--       @IsFirstIC IsFirstIC,
	--       @Property Property,
	--       @IsLanWei IsLanWei

	SELECT @RequestNo = ISNULL(Main.ContractNo, ''),
	       @DealerType = CASE Main.DealerType WHEN 'LP' THEN '平台' WHEN 'T1' THEN '一级经销商'
		   WHEN 'T2' THEN '二级经销商' WHEN 'LS' THEN '服务商' ELSE ''END,
		   @DealerName = ISNULL(DM.DMA_ChineseName, ''),
		   @LPName = CASE Main.DealerType WHEN 'T2' THEN ld.VALUE1 ELSE '' END
	FROM       [Contract].AmendmentMain Main
	INNER JOIN DealerMaster DM ON Main.CompanyID=DM.DMA_ID
	LEFT JOIN DealerMaster LPDM ON LPDM.DMA_ID=DM.DMA_Parent_DMA_ID
	LEFT JOIN  Lafite_DICT ld ON LPDM.DMA_SAP_Code=ld.DICT_KEY AND DICT_TYPE='CONST_LPSAPCodeKey'
	WHERE      Main.ContractId = @InstanceId
	
	SELECT @RequestNo fd_contract_number,
			   @DealerType fd_dealer_type,
			   @DealerName fd_dealer_name,
			   @DealerType +'合同修改' fd_contract_type
END




