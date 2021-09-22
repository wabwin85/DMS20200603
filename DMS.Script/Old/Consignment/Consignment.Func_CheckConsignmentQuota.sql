DROP FUNCTION [Consignment].[Func_CheckConsignmentQuota]
GO

/*
1. 功能名称：寄售额度校验
2. 更能描述：获取经销商剩余额度及校验状态
*/
CREATE FUNCTION [Consignment].[Func_CheckConsignmentQuota]
(
	@CAH_ID uniqueidentifier,
	@DealerId uniqueidentifier,
	@CfnShortCode NVARCHAR(50),
	@Values DECIMAL(18,6),
	@CheckType NVARCHAR(50)
)
RETURNS DECIMAL(18,6)
AS 
BEGIN
	DECLARE @RETURNVALUES DECIMAL(18,6)
	DECLARE @Quota DECIMAL(18,6)
	DECLARE @Order DECIMAL(18,6)
	DECLARE @BeginDate DATETIME
	DECLARE @EndDate DATETIME
	
	--校验是否通过:1 校验通过，0 校验不同
	IF @CheckType='Money'
	BEGIN
		IF EXISTS(SELECT * FROM interface.T_MDS_ConsignmentQuota B 
		INNER JOIN DealerMaster A ON B.CQ_DMA_SAP_Code=A.DMA_SAP_Code
		WHERE GETDATE() BETWEEN  CQ_BeginDate AND CQ_EndDate AND A.DMA_ID=@DealerId AND B.CQ_UPN=@CfnShortCode AND B.CQ_Amount IS NOT NULL)
		BEGIN
			SELECT @Quota=b.CQ_Amount,@BeginDate=b.CQ_BeginDate,@EndDate=b.CQ_EndDate
			FROM interface.T_MDS_ConsignmentQuota B 
			INNER JOIN DealerMaster A ON B.CQ_DMA_SAP_Code=A.DMA_SAP_Code
			WHERE GETDATE() BETWEEN  CQ_BeginDate AND CQ_EndDate AND A.DMA_ID=@DealerId AND B.CQ_UPN=@CfnShortCode AND B.CQ_Amount IS NOT NULL
			
			SELECT @Order=SUM(b.CAD_Amount)
			FROM ConsignmentApplyHeader A 
			INNER JOIN ConsignmentApplyDetails B ON A.CAH_ID=B.CAD_CAH_ID
			INNER JOIN CFN C ON C.CFN_ID=B.CAD_CFN_ID
			WHERE A.CAH_DMA_ID=@DealerId 
				AND C.CFN_Property1=@CfnShortCode
				AND CONVERT(NVARCHAR(10),A.CAH_SubmitDate,112) > =CONVERT(NVARCHAR(10),@BeginDate,112) 
				AND CONVERT(NVARCHAR(10),A.CAH_SubmitDate,112) < =CONVERT(NVARCHAR(10),@EndDate,112)
				AND A.CAH_OrderStatus IN ('Approved','Submitted')
				AND (@CAH_ID IS NULL OR A.CAH_ID<>@CAH_ID)
			
			SET @RETURNVALUES= ISNULL(@Quota,0)-ISNULL(@Order,0)-ISNULL(@Values,0)
		END
		ELSE
		BEGIN
			SET @RETURNVALUES=1
		END
			
	END
	IF @CheckType='QTY'
	BEGIN
		IF EXISTS(SELECT * FROM interface.T_MDS_ConsignmentQuota B 
		INNER JOIN DealerMaster A ON B.CQ_DMA_SAP_Code=A.DMA_SAP_Code
		WHERE GETDATE() BETWEEN  CQ_BeginDate AND CQ_EndDate AND A.DMA_ID=@DealerId AND B.CQ_UPN=@CfnShortCode AND B.CQ_Qty IS NOT NULL)
		BEGIN
			SELECT @Quota=b.CQ_Qty,@BeginDate=b.CQ_BeginDate,@EndDate=b.CQ_EndDate
			FROM interface.T_MDS_ConsignmentQuota B 
			INNER JOIN DealerMaster A ON B.CQ_DMA_SAP_Code=A.DMA_SAP_Code
			WHERE GETDATE() BETWEEN  CQ_BeginDate AND CQ_EndDate AND A.DMA_ID=@DealerId AND B.CQ_UPN=@CfnShortCode AND B.CQ_Qty IS NOT NULL
			
			SELECT @Order=SUM(b.CAD_Qty)
			FROM ConsignmentApplyHeader A 
			INNER JOIN ConsignmentApplyDetails B ON A.CAH_ID=B.CAD_CAH_ID
			INNER JOIN CFN C ON C.CFN_ID=B.CAD_CFN_ID
			WHERE A.CAH_DMA_ID=@DealerId 
				AND C.CFN_Property1=@CfnShortCode
				AND CONVERT(NVARCHAR(10),A.CAH_SubmitDate,112) > =CONVERT(NVARCHAR(10),@BeginDate,112) 
				AND CONVERT(NVARCHAR(10),A.CAH_SubmitDate,112) < =CONVERT(NVARCHAR(10),@EndDate,112)
				AND A.CAH_OrderStatus IN ('Approved','Submitted')
				AND (@CAH_ID IS NULL OR A.CAH_ID<>@CAH_ID)
				
			SET @RETURNVALUES= ISNULL(@Quota,0)-ISNULL(@Order,0)-ISNULL(@Values,0)
			
		END
		ELSE
		BEGIN
			SET @RETURNVALUES=1
		END
	END
	
	RETURN @RETURNVALUES
END

GO


