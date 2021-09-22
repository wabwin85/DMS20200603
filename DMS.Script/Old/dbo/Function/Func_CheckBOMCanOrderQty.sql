DROP FUNCTION [dbo].[Func_CheckBOMCanOrderQty]
GO



CREATE FUNCTION [dbo].[Func_CheckBOMCanOrderQty]
(
	@POHId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
	DECLARE @Rtn INT;
	DECLARE @EwfCode NVARCHAR(100);
	DECLARE @BOMMasterUpn NVARCHAR(100);
	DECLARE @SAPCode NVARCHAR(100);
	DECLARE @TotalQty Decimal(18,4);
	
	DECLARE @BOMUpn NVARCHAR(100);
	DECLARE @BOMQty Decimal(18,4); --UPN���׻���
	DECLARE @UserBOMQty Decimal(18,4);--ʹ������
	DECLARE @LastBOMQty Decimal(18,4);--ʣ������
	DECLARE @OrderBOMQty Decimal(18,4);--��ǰ��������
	

	SELECT TOP 1 @EwfCode=SUBSTRING(POD_Field2,charindex('EWF:',POD_Field2)+4,charindex(')',POD_Field2)-charindex('EWF:',POD_Field2)-4),
	@BOMMasterUpn=SUBSTRING(POD_Field2,charindex('UPN:',POD_Field2)+4,LEN(POD_Field2)-charindex('UPN:',POD_Field2)-3),
	@SAPCode=C.DMA_SAP_Code
	FROM PurchaseOrderHeader a 
	INNER JOIN PurchaseOrderDetail b on a.POH_ID=b.POD_POH_ID
	INNER JOIN DealerMaster C ON C.DMA_ID=A.POH_DMA_ID
	WHERE a.POH_ID=@POHId
	
	--��ȡ����
	SELECT @TotalQty= ISNULL(IsForRebate,0) FROM INTERFACE.T_I_EW_DistributorPrice A WHERE A.InstancdId=@EwfCode and a.UPN=@BOMMasterUpn AND A.CustomerSapCode=@SAPCode
	
	IF  ISNULL(@TotalQty,0)>0
	BEGIN
		--��Ʒת����
		SELECT TOP 1  @BOMUpn=A.BOMUPN,@BOMQty=a.Qty FROM MD.ProductBOM A WHERE A.MasterUPN=ISNULL(@BOMMasterUpn,'')

		--ʹ������
		SELECT @UserBOMQty=(ISNULL(SUM(B.POD_RequiredQty),0)/ISNULL(@BOMQty,1.0)) FROM PurchaseOrderHeader A 
		INNER JOIN PurchaseOrderDetail B ON A.POH_ID=B.POD_POH_ID 
		INNER JOIN DealerMaster C ON C.DMA_ID=A.POH_DMA_ID
		INNER JOIN CFN ON CFN.CFN_ID=B.POD_CFN_ID
		WHERE C.DMA_SAP_Code=@SAPCode AND A.POH_OrderType='BOM' AND a.POH_OrderStatus NOT IN ('Draft','Rejected','Revoked')
		AND POD_Field2 like '%EWF:'+@EwfCode+'%'
		AND CFN.CFN_CustomerFaceNbr=@BOMUpn
		
		--SELECT @UserBOMQty=(ISNULL(SUM(tab.POD_RequiredQty),0)/ISNULL(@BOMQty,1.0)) FROM (
		--SELECT SUBSTRING(POD_Field2,charindex('EWF:',POD_Field2)+4,charindex(')',POD_Field2)-charindex('EWF:',POD_Field2)-4) EWFCode ,
		--B.POD_RequiredQty FROM PurchaseOrderHeader A 
		--INNER JOIN PurchaseOrderDetail B ON A.POH_ID=B.POD_POH_ID 
		--INNER JOIN DealerMaster C ON C.DMA_ID=A.POH_DMA_ID
		--INNER JOIN CFN ON CFN.CFN_ID=B.POD_CFN_ID
		--WHERE C.DMA_SAP_Code=@SAPCode AND A.POH_OrderType='BOM' AND a.POH_OrderStatus NOT IN ('Draft','Rejected','Revoked')
		--AND CFN.CFN_CustomerFaceNbr=@BOMUpn) tab
		--WHERE tab.EWFCode LIKE '%EWF:'+@EwfCode+'%'
		
		
		--ʣ������
		SET @LastBOMQty=ISNULL(@TotalQty,0)-ISNULL(@UserBOMQty,0)
		
		--У�������Ե�ǰ����
		SELECT @OrderBOMQty=SUM(B.POD_RequiredQty)/@BOMQty
		FROM PurchaseOrderHeader a 
		INNER JOIN PurchaseOrderDetail b on a.POH_ID=b.POD_POH_ID
		INNER JOIN CFN ON CFN.CFN_ID=B.POD_CFN_ID
		WHERE a.POH_ID=@POHId
		AND  CFN.CFN_CustomerFaceNbr=@BOMUpn
		
		IF ISNULL(@LastBOMQty,0.0)-ISNULL(@OrderBOMQty,0.0)>=0
		BEGIN
			SET @Rtn=1;
		END
		ELSE
		BEGIN
			SET @Rtn=0;
		END
	END
	ELSE
	BEGIN
		SET @Rtn=1;
	END
	RETURN ISNULL(@Rtn, 0)
END

GO


