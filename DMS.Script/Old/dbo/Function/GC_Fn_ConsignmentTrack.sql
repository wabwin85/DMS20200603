DROP FUNCTION [dbo].[GC_Fn_ConsignmentTrack]
GO


CREATE FUNCTION [dbo].[GC_Fn_ConsignmentTrack](
	@CahId UNIQUEIDENTIFIER,			--申请单主键
	@QueryType NVARCHAR(50),			--查询类型（Normal，Report）
	@UserId UNIQUEIDENTIFIER,			--查询人（For报表）
	@ProductLineId UNIQUEIDENTIFIER,	--产品线（For报表）
	@StartDate NVARCHAR(50),			--开始时间（For报表）
	@EndDate NVARCHAR(50),				--截止时间（For报表）
	@Upn NVARCHAR(10),					--产品型号（For报表）
	@LotNumber nvarchar(10)				--批次号（For报表）
)
RETURNS @Temp TABLE
--CREATE TABLE Temp 
(   CahId UNIQUEIDENTIFIER,
	CahOrderNo NVARCHAR(100),
	DealerId UNIQUEIDENTIFIER,
	ProduceLineId UNIQUEIDENTIFIER,
	CahSubmitDate DATETIME,
	CfnId UNIQUEIDENTIFIER,
	PmaId UNIQUEIDENTIFIER,
	CfnChineseName NVARCHAR(200),
	CfnEnglishName NVARCHAR(200),
	CfnCode NVARCHAR(100),
	CfnCode2 NVARCHAR(100),
	CfnUom NVARCHAR(100),
	LotId UNIQUEIDENTIFIER,
	LtmId UNIQUEIDENTIFIER,
	LotNumber NVARCHAR(100),
	ApplyQty DECIMAL(18,6),
	TotalQty DECIMAL(18,6),
	PurchaseId UNIQUEIDENTIFIER,
	PurchaseNo NVARCHAR(100),
	PurchaseDate DATETIME,
	PurchaseQty DECIMAL(18,6),
	POReceiptId UNIQUEIDENTIFIER,
	POReceiptNo NVARCHAR(100),
	POReceiptSapNo NVARCHAR(100),
	POReceiptDeliveryDate DATETIME,
	POReceiptDate DATETIME,
	POReceiptQty DECIMAL(18,6),
	ShipmentNo NVARCHAR(100),
	ShipmentType NVARCHAR(100),
	ShipmentQty DECIMAL(18,6),
	ShipmentDate DATETIME,
	ShipmentSubmitDate DATETIME,
	ReturnNo NVARCHAR(100),
	ReturnType NVARCHAR(100),
	ReturnQty DECIMAL(18,6),
	ReturnDate DATETIME,
	ReturnApprovelDate DATETIME,
	ExpirationDate DATETIME,
	ConsignmentDay INT,
	DelayNumber INT,
	ExpiredDate DATETIME
)
AS
BEGIN
	
	IF @QueryType = 'Normal'
		BEGIN
			INSERT INTO @Temp(CahId			--UNIQUEIDENTIFIER
							,CahOrderNo		--NVARCHAR(100),
							,DealerId		--UNIQUEIDENTIFIER,
							,ProduceLineId	--UNIQUEIDENTIFIER,
							,CahSubmitDate	--DATETIME,
							,CfnId			--UNIQUEIDENTIFIER,
							,PmaId			--UNIQUEIDENTIFIER,
							,CfnChineseName	--NVARCHAR(200),
							,CfnEnglishName	--NVARCHAR(200),
							,CfnCode			--NVARCHAR(100),
							,CfnCode2		--NVARCHAR(100),
							,CfnUom			--NVARCHAR(100),
							,ConsignmentDay	--INT,
							,ApplyQty
							)
			SELECT	CAH_ID
					,CAH_OrderNo
					,CAH_DMA_ID
					,CAH_ProductLine_Id
					,CAH_SubmitDate
					,CFN_ID
					,PMA_ID
					,CFN_ChineseName
					,CFN_EnglishName
					,CFN_CustomerFaceNbr
					,CFN_Property1
					,CFN_Property3 
					,CAH_CM_ConsignmentDay
					,CAD_Qty
				FROM ConsignmentApplyHeader 
				INNER JOIN ConsignmentApplyDetails ON CAH_ID = CAD_CAH_ID
				INNER JOIN CFN ON CFN_ID = CAD_CFN_ID
				INNER JOIN Product ON PMA_CFN_ID = CFN_ID
				WHERE CAH_OrderStatus = 'Approved'
				AND (@CahId IS NULL OR CAH_ID = @CahId)
		END
	ELSE IF @QueryType = 'Report'
		BEGIN 

			DECLARE @DealerId uniqueidentifier
			DECLARE @UserType nvarchar(20)
			SELECT @UserType = IDENTITY_TYPE ,@DealerId = Corp_ID FROM Lafite_IDENTITY WHERE Id = @UserId

			INSERT INTO @Temp(CahId			--UNIQUEIDENTIFIER
							,CahOrderNo		--NVARCHAR(100),
							,DealerId		--UNIQUEIDENTIFIER,
							,ProduceLineId	--UNIQUEIDENTIFIER,
							,CahSubmitDate	--DATETIME,
							,CfnId			--UNIQUEIDENTIFIER,
							,PmaId			--UNIQUEIDENTIFIER,
							,CfnChineseName	--NVARCHAR(200),
							,CfnEnglishName	--NVARCHAR(200),
							,CfnCode			--NVARCHAR(100),
							,CfnCode2		--NVARCHAR(100),
							,CfnUom			--NVARCHAR(100),
							,ConsignmentDay	--INT,
							,ApplyQty
							)
			SELECT	CAH_ID
					,CAH_OrderNo
					,CAH_DMA_ID
					,CAH_ProductLine_Id
					,CAH_SubmitDate
					,CFN_ID
					,PMA_ID
					,CFN_ChineseName
					,CFN_EnglishName
					,CFN_CustomerFaceNbr
					,CFN_Property1
					,CFN_Property3 
					,CAH_CM_ConsignmentDay
					,CAD_Qty
				FROM ConsignmentApplyHeader 
				INNER JOIN ConsignmentApplyDetails ON CAH_ID = CAD_CAH_ID
				INNER JOIN CFN ON CFN_ID = CAD_CFN_ID
				INNER JOIN Product ON PMA_CFN_ID = CFN_ID
				WHERE CONVERT(NVARCHAR(20),CAH_SubmitDate,112) >= @StartDate
				AND CONVERT(NVARCHAR(20),CAH_SubmitDate,112) <= @EndDate
				AND ((@ProductLineId IS NULL) OR CAH_ProductLine_Id = @ProductLineId)
				AND (
						(@UserType = 'User' AND EXISTS
						   ( 
								  SELECT 1 FROM Cache_OrganizationUnits OU, Lafite_IDENTITY_MAP IM , Cache_SalesOfDealer SD
								  WHERE OU.AttributeId = IM.MAP_ID AND IM.MAP_TYPE='Organization' AND convert(varchar(36),SD.SalesID) = IM.IDENTITY_ID
										  AND SD.DealerID = CAH_DMA_ID AND SD.BUM_ID = CAH_ProductLine_Id
										  AND OU.AttributeId<>OU.RootId
										  AND OU.RootID IN (select MAP_ID from Lafite_IDENTITY_MAP OM where OM.MAP_TYPE='Organization'  AND OM.IDENTITY_ID = @UserId)
							)
						OR
							EXISTS
						   ( 
								  SELECT 1 from Cache_SalesOfDealer SD 
								  WHERE SD.SalesID = @UserId
										 AND SD.DealerID = CAH_DMA_ID AND SD.BUM_ID = CAH_ProductLine_Id
						   )
						)
						OR 
						(@UserType = 'Dealer' AND (CAH_DMA_ID = @DealerId OR @DealerId = 'FB62D945-C9D7-4B0F-8D26-4672D2C728B7'))
					)
		END

	UPDATE @Temp SET PurchaseId = POH_ID
						,PurchaseNo = POH_OrderNo
						,PurchaseDate = POH_SubmitDate
						,PurchaseQty = POD_RequiredQty
					FROM PurchaseOrderHeader
						INNER JOIN PurchaseOrderDetail ON POH_ID = POD_POH_ID
					WHERE POD_ShipmentNbr = CahOrderNo
						AND POD_CFN_ID = CfnId

	
	DECLARE @ReturnTable TABLE
	(
		CahId UNIQUEIDENTIFIER,
		ReturnId UNIQUEIDENTIFIER,
		ReturnNo NVARCHAR(200),
		ReturnDate DATETIME,
		ReturnApprovelDate DATETIME,
		ReturnPmaId UNIQUEIDENTIFIER,
		ReturnLotId UNIQUEIDENTIFIER,
		ReturnLotNumber NVARCHAR(200),
		ReturnQty DECIMAL(18,6)
	)

	DECLARE @ShipmentTable TABLE
	(
		CahId UNIQUEIDENTIFIER,
		ShipmentId UNIQUEIDENTIFIER,
		ShipmentNo NVARCHAR(200),
		ShipmentDate DATETIME,
		ShipmentSubmitDate DATETIME,
		ShipmentPmaId UNIQUEIDENTIFIER,
		ShipmentLotId UNIQUEIDENTIFIER,
		ShipmentLtmId UNIQUEIDENTIFIER,
		ShipmentLotNumber NVARCHAR(200),
		ShipmentQty DECIMAL(18,6)
	)
	
	RETURN
	
END



GO


