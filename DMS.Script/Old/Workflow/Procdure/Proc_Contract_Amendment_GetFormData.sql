DROP PROCEDURE [Workflow].[Proc_Contract_Amendment_GetFormData]
GO


CREATE PROCEDURE [Workflow].[Proc_Contract_Amendment_GetFormData]
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
	
	SELECT @RequestNo = ISNULL(Main.ContractNo, ''),
	       @BU = ISNULL(Main.DepId, ''),
	       @RequestType = CASE 
	                           WHEN Main.DealerType = 'Trade' THEN '2'
	                           ELSE '1'
	                      END,
	       @SubBu = ISNULL(Main.SUBDEPID, ''),
	       @AllTotalUSD = ISNULL(CONVERT(NVARCHAR(20), Proposals.AllProductAopUSD), ''),
	       @DealerType = ISNULL(Main.DealerType, ''),
	       @PayType = ISNULL(Proposals.Payment, ''),
	       @RSM = CASE 
	                   WHEN ISNULL(Main.ReagionRSM, '') = '0' THEN ''
	                   ELSE ISNULL(Main.ReagionRSM, '')
	              END,
	       @DiffQuato = Proposals.QUATOUP,
	       @IsFirstIC = dbo.GC_Fn_IsNoFirstContract(Main.CompanyID, Main.DepId),
	       @Property = ISNULL(Main.MarketType, '')
	FROM   [Contract].AmendmentMain Main,
	       [Contract].AmendmentProposals Proposals
	WHERE  Main.ContractId = Proposals.ContractId
	       AND Main.ContractId = @InstanceId;
	
	SELECT @RequestNo RequestNo,
	       @BU BU,
	       @RequestType RequestType,
	       @SubBu SubBu,
	       @AllTotalUSD AllTotalUSD,
	       @DealerType DealerType,
	       @PayType PayType,
	       CASE WHEN @SubBu IN ('C1703') THEN '1'  --Éè±¸
				WHEN @SubBu IN ('C1705', 'C1706') THEN '2'  --ºÄ²Ä
				ELSE '0' END IsRovus, --·ÇRovus
	       @DiffQuato DiffQuato,
	       @IsFirstIC IsFirstIC,
	       @Property Property
END
GO


