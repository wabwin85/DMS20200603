
DROP FUNCTION [dbo].[fn_GetPriceForDealerRetrun]
GO

CREATE FUNCTION [dbo].[fn_GetPriceForDealerRetrun]
(
	@DealerID uniqueidentifier,
	@CFNID uniqueidentifier,
  @Lot nvarchar(50),
  @ReturnApplyType nvarchar(20)
)  
  RETURNS decimal(18,2)
AS  
BEGIN
DECLARE @ResultPrice decimal(18,2)
DECLARE @IsCRM BIT
DECLARE @DelaerType  nvarchar(50)
DECLARE @IsCRMType BIT
DECLARE @DiscountRate decimal(18,2)

SET @IsCRMType = 0
SET @ResultPrice = 0
SET @DiscountRate = 1
--获取经销商类型
SELECT @DelaerType=DMA_DealerType FROM DealerMaster(nolock) WHERE DMA_ID=@DealerID
--获取产品类型
SELECT @IsCRM=CASE WHEN CFN.CFN_Property6='1' THEN 1 ELSE 0 END,@IsCRMType=CASE WHEN LEFT(CFN.CFN_CustomerFaceNbr,2)='66' THEN 1 ELSE 0 END 
 FROM CFN(nolock) WHERE CFN.CFN_ID=@CFNID

--获取退货单对应的退货类型
--SELECT @ReturnApplyType = ISNULL(IAH_ApplyType,'0') from InventoryAdjustHeader where IAH_ID=@AdjustID

--如果是合同约定条款内的，则打8折
IF (@ReturnApplyType = '4')
 BEGIN 
   SET @DiscountRate = 0.8
 END


--获取CRM产品66开头
--IF(@IsCRM=1)
----如果是CRM产品判断是否为66开头
--   BEGIN
--   SELECT @IsCRMType=CASE WHEN LEFT(CFN.CFN_CustomerFaceNbr,2)='66' THEN 1 ELSE 0 END   FROM CFN WHERE CFN.CFN_ID=@CFNID
--   END
--T1或LP经销商的CRM非66开头产品
IF((@DelaerType='T1' OR @DelaerType='LP') AND @IsCRM=1 AND @IsCRMType=0)
 BEGIN
   --SELECT top 1 @ResultPrice=ISNULL(POD_CFN_Price,0) 
   --FROM PurchaseOrderHeader INNER JOIN 
   --    PurchaseOrderDetail ON PurchaseOrderHeader.POH_ID=PurchaseOrderDetail.POD_POH_ID
   --WHERE POH_OrderNo in (
   --SELECT distinct POReceiptHeader.PRH_PurchaseOrderNbr 
   --FROM POReceiptHeader 
   --INNER JOIN POReceipt ON POReceiptHeader.PRH_ID=POReceipt.POR_PRH_ID
   --INNER JOIN POReceiptLot ON POReceiptLot.PRL_POR_ID=POReceipt.POR_ID 
   --INNER JOIN Product ON POReceipt.POR_SAP_PMA_ID=Product.PMA_ID 
   --INNER JOIN CFN ON CFN.CFN_ID=Product.PMA_CFN_ID
   --WHERE CFN.CFN_ID=@CFNID AND POReceiptLot.PRL_LotNumber=@Lot )
   --and PurchaseOrderDetail.POD_CFN_ID=@CFNID
   --and POH_CreateType='Manual'
   --order by POH_SubmitDate desc
   
   
   SELECT top 1 @ResultPrice=ISNULL(POD_CFN_Price,0) * @DiscountRate
   FROM PurchaseOrderHeader INNER JOIN 
       PurchaseOrderDetail ON PurchaseOrderHeader.POH_ID=PurchaseOrderDetail.POD_POH_ID
       INNER JOIN  (SELECT distinct POReceiptHeader.PRH_PurchaseOrderNbr ,CFN.CFN_ID
   FROM POReceiptHeader(nolock) 
   INNER JOIN POReceipt(nolock) ON POReceiptHeader.PRH_ID=POReceipt.POR_PRH_ID
   INNER JOIN POReceiptLot(nolock) ON POReceiptLot.PRL_POR_ID=POReceipt.POR_ID 
   INNER JOIN Product(nolock) ON POReceipt.POR_SAP_PMA_ID=Product.PMA_ID 
   INNER JOIN CFN(nolock) ON CFN.CFN_ID=Product.PMA_CFN_ID
   WHERE CFN.CFN_ID=@CFNID AND POReceiptLot.PRL_LotNumber=@Lot and POReceiptHeader.PRH_Dealer_DMA_ID = @DealerID )
   C ON PurchaseOrderDetail.POD_CFN_ID=C.CFN_ID
   AND PurchaseOrderHeader.POH_OrderNo=C.PRH_PurchaseOrderNbr
   AND POH_CreateType='Manual'
   order by POH_SubmitDate desc
   
   IF @ResultPrice = 0
     BEGIN
       select top 1 @ResultPrice=ISNULL(CFNPrice.CFNP_Price,0) * @DiscountRate  
        from CFNPrice(nolock) inner join CFN(nolock) on (CFNPrice.CFNP_CFN_ID=CFN.CFN_ID ) 
        where CFNPrice.CFNP_CFN_ID=@CFNID and CFNPrice.CFNP_Group_ID=@DealerID
        order by CFNPrice.CFNP_CreateDate desc
     END
   
  END
  
--  T1或LP经销商的CRM的66开头产品  --从视图V_I_EW_DealerLastedMaintainedPrice表获取
IF((@DelaerType='T1' OR @DelaerType='LP') AND @IsCRM=1 AND @IsCRMType=1)
  BEGIN
  
    
    --SELECT top 1 @ResultPrice= ISNULL(NewPrice,0) FROM interface.T_I_EW_DistributorPrice INNER JOIN DealerMaster ON 
    --interface.T_I_EW_DistributorPrice.CustomerSapCode=DealerMaster.DMA_SAP_Code
    --WHERE EXISTS(SELECT 1 FROM CFN WHERE interface.T_I_EW_DistributorPrice.UPN=CFN.CFN_Property1
    --and CFN.CFN_ID=@CFNID)AND DealerMaster.DMA_ID=@DealerID order by ISNULL(ValidTo,'9999-12-31') desc,InstancdId desc
    
   --SELECT top 1 @ResultPrice=ISNULL(POD_CFN_Price,0) * @DiscountRate
   --FROM PurchaseOrderHeader INNER JOIN 
   --    PurchaseOrderDetail ON PurchaseOrderHeader.POH_ID=PurchaseOrderDetail.POD_POH_ID
   --    INNER JOIN  (SELECT distinct POReceiptHeader.PRH_PurchaseOrderNbr ,CFN.CFN_ID
   --FROM POReceiptHeader(nolock) 
   --INNER JOIN POReceipt(nolock) ON POReceiptHeader.PRH_ID=POReceipt.POR_PRH_ID
   --INNER JOIN POReceiptLot(nolock) ON POReceiptLot.PRL_POR_ID=POReceipt.POR_ID 
   --INNER JOIN Product(nolock) ON POReceipt.POR_SAP_PMA_ID=Product.PMA_ID 
   --INNER JOIN CFN(nolock) ON CFN.CFN_ID=Product.PMA_CFN_ID
   --WHERE CFN.CFN_ID=@CFNID AND POReceiptLot.PRL_LotNumber=@Lot and POReceiptHeader.PRH_Dealer_DMA_ID = @DealerID )
   --C ON PurchaseOrderDetail.POD_CFN_ID=C.CFN_ID
   --AND PurchaseOrderHeader.POH_OrderNo=C.PRH_PurchaseOrderNbr
   --AND POH_CreateType='Manual'
   --order by POH_SubmitDate desc
   
   IF @ResultPrice = 0
     BEGIN
       SELECT TOP 1 @ResultPrice=ISNULL(A.UnitPrice,0) * @DiscountRate 
		FROM (
  			SELECT TAB3.CustomerSapCode,TAB3.UPN,IDP.NewPrice as UnitPrice FROM 
  			interface.T_I_EW_DistributorPrice IDP
  			INNER JOIN 
  			(
  				select tab1.CustomerSapCode,tab1.UPN,max(tab1.CreateDate ) AS CreateDate
				from interface.T_I_EW_DistributorPrice tab1(NOLOCK),
				(select CustomerSapCode, UPN, max( CONVERT(DATETIME,CONVERT(NVARCHAR(10),ISNULL(ValidTo,'2999-12-31'),120))) AS ValidTo
				from interface.T_I_EW_DistributorPrice(NOLOCK)
				where Type = 2 OR SubtType in (112,122)
	            
				group by CustomerSapCode, UPN
				) tab2
				where tab1.CustomerSapCode=tab2.CustomerSapCode
				  and tab1.UPN = tab2.UPN
				  and CONVERT(NVARCHAR(10),tab1.ValidTo,120) =CONVERT(NVARCHAR(10),tab2.ValidTo,120)
				  and (Type = 2 OR SubtType in (112,122))            
				group by tab1.CustomerSapCode,tab1.UPN) TAB3 ON TAB3.UPN=IDP.UPN 
				AND TAB3.CustomerSapCode=IDP.CustomerSapCode 
				AND TAB3.CreateDate=IDP.CreateDate
				) as A--interface.V_I_EW_DealerLastedMaintainedPrice A
		INNER JOIN DealerMaster B(nolock) ON A.CustomerSapCode=B.DMA_SAP_Code INNER JOIN
		CFN C ON A.UPN=C.CFN_Property1 
		WHERE   B.DMA_ID=@DealerID AND C.CFN_ID=@CFNID
     END
    
    
  END
--T1或LP经销商的非CRM产品   --从视图V_I_EW_DealerLastedMaintainedPrice表获取
  IF((@DelaerType='T1' OR @DelaerType='LP') AND @IsCRM=0 )
  BEGIN
    -- SELECT top 1 @ResultPrice=ISNULL(POD_CFN_Price,0) 
	   --FROM PurchaseOrderHeader INNER JOIN 
		  -- PurchaseOrderDetail ON PurchaseOrderHeader.POH_ID=PurchaseOrderDetail.POD_POH_ID
		  -- INNER JOIN  (SELECT distinct POReceiptHeader.PRH_PurchaseOrderNbr ,CFN.CFN_ID
	   --FROM POReceiptHeader(nolock) 
	   --INNER JOIN POReceipt(nolock) ON POReceiptHeader.PRH_ID=POReceipt.POR_PRH_ID
	   --INNER JOIN POReceiptLot(nolock) ON POReceiptLot.PRL_POR_ID=POReceipt.POR_ID 
	   --INNER JOIN Product(nolock) ON POReceipt.POR_SAP_PMA_ID=Product.PMA_ID 
	   --INNER JOIN CFN(nolock) ON CFN.CFN_ID=Product.PMA_CFN_ID
	   --WHERE CFN.CFN_ID=@CFNID AND POReceiptLot.PRL_LotNumber=@Lot and POReceiptHeader.PRH_Dealer_DMA_ID = @DealerID )
	   --C ON PurchaseOrderDetail.POD_CFN_ID=C.CFN_ID
	   --AND PurchaseOrderHeader.POH_OrderNo=C.PRH_PurchaseOrderNbr
	   --AND POH_CreateType='Manual'
	   --order by POH_SubmitDate desc
    
       IF @ResultPrice = 0
         BEGIN
			SELECT top 1 @ResultPrice= ISNULL(NewPrice,0)
			FROM interface.T_I_EW_DistributorPrice(nolock) INNER JOIN DealerMaster(nolock) ON 
			interface.T_I_EW_DistributorPrice.CustomerSapCode=DealerMaster.DMA_SAP_Code
			WHERE (Type = 2 OR SubtType in (112,122))
			  and EXISTS(SELECT 1 FROM CFN(nolock) WHERE interface.T_I_EW_DistributorPrice.UPN=CFN.CFN_CustomerFaceNbr
			  and CFN.CFN_ID=@CFNID)AND  DealerMaster.DMA_ID=@DealerID 
			  order by CONVERT(NVARCHAR(10),ISNULL(ValidTo,'9999-12-31'),120) desc,
			  (case when LEN(InstancdId)<6 then InstancdId+1000000 else InstancdId end) desc
          END
  END
--T2经销商的CRM的非66开头产品
 IF(@DelaerType='T2'  AND @IsCRM=1 AND @IsCRMType=0)  --同T1、LP的逻辑
   BEGIN
   --SELECT top 1 @ResultPrice=ISNULL(POD_CFN_Price,0) FROM PurchaseOrderHeader INNER JOIN PurchaseOrderDetail ON PurchaseOrderHeader.POH_ID=PurchaseOrderDetail.POD_POH_ID
   --WHERE POH_OrderNo in (SELECT distinct POReceiptHeader.PRH_PurchaseOrderNbr FROM POReceiptHeader INNER JOIN POReceipt ON POReceiptHeader.PRH_ID=POReceipt.POR_PRH_ID
   --INNER JOIN POReceiptLot ON POReceiptLot.PRL_POR_ID=POReceipt.POR_ID INNER JOIN Product 
   --ON POReceipt.POR_SAP_PMA_ID=Product.PMA_ID INNER JOIN CFN ON CFN.CFN_ID=Product.PMA_CFN_ID
   --WHERE CFN.CFN_ID=@CFNID AND POReceiptLot.PRL_LotNumber=@Lot )
   --and PurchaseOrderDetail.POD_CFN_ID=@CFNID
   --order by POH_SubmitDate desc
    SELECT top 1 @ResultPrice=ISNULL(POD_CFN_Price,0) 
   FROM PurchaseOrderHeader(nolock) 
   INNER JOIN 
       PurchaseOrderDetail(nolock) ON PurchaseOrderHeader.POH_ID=PurchaseOrderDetail.POD_POH_ID
       INNER JOIN  (SELECT distinct POReceiptHeader.PRH_PurchaseOrderNbr ,CFN.CFN_ID
   FROM POReceiptHeader(nolock) 
   INNER JOIN POReceipt(nolock) ON POReceiptHeader.PRH_ID=POReceipt.POR_PRH_ID
   INNER JOIN POReceiptLot(nolock) ON POReceiptLot.PRL_POR_ID=POReceipt.POR_ID 
   INNER JOIN Product(nolock) ON POReceipt.POR_SAP_PMA_ID=Product.PMA_ID 
   INNER JOIN CFN(nolock) ON CFN.CFN_ID=Product.PMA_CFN_ID
   WHERE CFN.CFN_ID=@CFNID AND POReceiptLot.PRL_LotNumber=@Lot and POReceiptHeader.PRH_Dealer_DMA_ID = @DealerID )
   C ON PurchaseOrderDetail.POD_CFN_ID=C.CFN_ID
   AND PurchaseOrderHeader.POH_OrderNo=C.PRH_PurchaseOrderNbr
   AND POH_CreateType='Manual'
   order by POH_SubmitDate desc
   
   IF ISNULL(@ResultPrice,0)=0
   BEGIN
		SELECT top 1 @ResultPrice=POReceiptLot.PRL_UnitPrice
		FROM POReceiptHeader(nolock) 
		INNER JOIN POReceipt(nolock) ON POReceiptHeader.PRH_ID=POReceipt.POR_PRH_ID
		INNER JOIN POReceiptLot(nolock) ON POReceiptLot.PRL_POR_ID=POReceipt.POR_ID 
		INNER JOIN Product(nolock) ON POReceipt.POR_SAP_PMA_ID=Product.PMA_ID 
		INNER JOIN CFN(nolock) ON CFN.CFN_ID=Product.PMA_CFN_ID
		WHERE CFN.CFN_ID=@CFNID 
		AND POReceiptLot.PRL_LotNumber = @Lot
		and POReceiptHeader.PRH_Dealer_DMA_ID = @DealerID
		and POReceiptHeader.PRH_Status='Complete'
		and POReceiptHeader.PRH_Type='PurchaseOrder'
   END
   
   END
--T2经销商的CRM的66开头产品
  IF(@DelaerType='T2'  AND @IsCRM=1 AND @IsCRMType=1)
    BEGIN
     select top 1 @ResultPrice=ISNULL(CFNPrice.CFNP_Price,0)  
       from CFNPrice(nolock) inner join CFN(nolock) on (CFNPrice.CFNP_CFN_ID=CFN.CFN_ID ) 
      where CFNPrice.CFNP_CFN_ID=@CFNID and CFNPrice.CFNP_Group_ID=@DealerID and CFNPrice.CFNP_PriceType='Dealer'
      order by CFNPrice.CFNP_CreateDate desc
    
     --select top 1 @ResultPrice =ISNULL(CFNPrice.CFNP_Price,0)  
     --from CFNPrice 
     --where exists(select 1 from CFN where  CFNPrice.CFNP_CFN_ID=CFN.CFN_ID 
     --and CFNPrice.CFNP_Group_ID=@DealerID) and CFNPrice.CFNP_CFN_ID=@CFNID
     --order by CFNPrice.CFNP_CreateDate desc
     /*
     SELECT TOP 1 @ResultPrice=A.UnitPrice 
     FROM (select tab1.CustomerSapCode,tab1.UPN,max(tab1.NewPrice ) AS UnitPrice
            from interface.T_I_EW_DistributorPrice tab1(NOLOCK),
            (select CustomerSapCode, UPN, max( ValidTo) AS ValidTo
            from interface.T_I_EW_DistributorPrice(NOLOCK)
            where Type = 2 OR SubtType in (112,122)
            group by CustomerSapCode, UPN
            ) tab2
            where tab1.CustomerSapCode=tab2.CustomerSapCode
            and tab1.UPN = tab2.UPN
            and tab1.ValidTo =tab2.ValidTo
            and (Type = 2 OR SubtType in (112,122))
            group by tab1.CustomerSapCode,tab1.UPN) AS A  --interface.V_I_EW_DealerLastedMaintainedPrice A
      INNER JOIN DealerMaster B(nolock) ON A.CustomerSapCode=B.DMA_SAP_Code 
      INNER JOIN CFN C(nolock) ON A.UPN=C.CFN_Property1 
       WHERE   B.DMA_ID=@DealerID AND C.CFN_ID=@CFNID
     */
    END  
--T2经销商的非CRM的产品
  IF(@DelaerType='T2'  AND @IsCRM=0)
   BEGIN
    select top 1 @ResultPrice=ISNULL(CFNPrice.CFNP_Price,0)  
    from CFNPrice(nolock) inner join CFN(nolock) on (CFNPrice.CFNP_CFN_ID=CFN.CFN_ID ) 
    where CFNPrice.CFNP_CFN_ID=@CFNID and CFNPrice.CFNP_Group_ID=@DealerID and CFNPrice.CFNP_PriceType='Dealer'
    order by CFNPrice.CFNP_CreateDate desc
    
    
   END
Cleanup: 
    --set @ResultPrice=0
	RETURN  @ResultPrice
END
