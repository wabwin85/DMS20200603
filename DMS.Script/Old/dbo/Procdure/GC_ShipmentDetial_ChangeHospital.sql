DROP  PROCEDURE [dbo].[GC_ShipmentDetial_ChangeHospital]
GO

CREATE PROCEDURE [dbo].[GC_ShipmentDetial_ChangeHospital]
	@ShipmentId NVARCHAR(36),
	@ShipmentType NVARCHAR(50), --Consignment
	@DealerId NVARCHAR(36),
	@ProductLineId NVARCHAR(36),
	@HospitalId NVARCHAR(36),
	@ShipmentDate DATETIME,
	@retMassage NVARCHAR(2000) OUTPUT
AS
BEGIN
DECLARE @LastContractId uniqueidentifier
  IF @DealerId='' 
    select @DealerId = convert(nvarchar(36),SPH_Dealer_DMA_ID) from ShipmentHeader where SPH_ID=@ShipmentId
	
  IF EXISTS(SELECT 1 FROM DealerMaster WHERE DMA_ID=@DealerId AND DMA_DealerType='T2') and @ShipmentType='Consignment'
	BEGIN
		--二级寄售单
		--SELECT * FROM ShipmentConsignment
		--SELECT * FROM ShipmentHeader
		--DELETE FROM ShipmentConsignment WHERE SPC_SPH_ID = @ShipmentId
		
		DELETE A 
		FROM ShipmentConsignment A,LotMaster B,Product C,CFN ,ShipmentHeader SPH,CfnClassification CCF
		WHERE A.SPC_LTM_ID=B.LTM_ID AND C.PMA_ID=B.LTM_Product_PMA_ID AND CFN.CFN_ID=C.PMA_CFN_ID
		AND SPH.SPH_ID=A.SPC_SPH_ID
		AND CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
		AND A.SPC_SPH_ID = @ShipmentId
		AND NOT EXISTS 
				(SELECT 1 FROM DealerAuthorizationTable
					INNER JOIN HospitalList ON DAT_ID = HLA_DAT_ID
					WHERE DAT_Type IN ('Normal','Temp','Shipment')
					AND DAT_ProductLine_BUM_ID = @ProductLineId
					AND DAT_DMA_ID = SPH.SPH_Dealer_DMA_ID
					AND  HLA_HOS_ID=@HospitalId
					AND CCF.ClassificationId=DAT_PMA_ID
					AND ShipmentDate BETWEEN ISNULL(HLA_StartDate,'1900-01-01') AND ISNULL(HLA_EndDate,DATEADD(DAY,-1,ShipmentDate))
				)
	END
	ELSE
	BEGIN
		--非二级寄售单
		--判断表头中状态是否是草稿
		IF EXISTS(SELECT 1 FROM ShipmentHeader WHERE ShipmentHeader.SPH_ID=@ShipmentId AND SPH_Status='Draft')
		BEGIN
			--删除lot表
			DELETE FROM ShipmentLot
			WHERE SLT_SPL_ID IN 
			(SELECT SPL_ID FROM ShipmentLine  a
								inner join Product b on a.SPL_Shipment_PMA_ID=b.PMA_ID
								inner join CFN c on c.CFN_ID=b.PMA_CFN_ID
								INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN_CustomerFaceNbr
			WHERE SPL_SPH_ID = @ShipmentId
			AND NOT EXISTS(SELECT 1 FROM DealerAuthorizationTable
					INNER JOIN HospitalList ON DAT_ID = HLA_DAT_ID
					WHERE DAT_Type IN ('Normal','Temp','Shipment')
					AND DAT_ProductLine_BUM_ID = @ProductLineId
					AND DAT_DMA_ID = @DealerId
					AND  HLA_HOS_ID=@HospitalId
					AND CCF.ClassificationId=DAT_PMA_ID
					AND @ShipmentDate BETWEEN ISNULL(HLA_StartDate,'1900-01-01') AND ISNULL(HLA_EndDate,DATEADD(DAY,-1,ShipmentDate)) 
					)
			)
			--删除line表
		
			
			DELETE a FROM ShipmentLine  a
								inner join Product b on a.SPL_Shipment_PMA_ID=b.PMA_ID
								inner join CFN c on c.CFN_ID=b.PMA_CFN_ID
								INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=c.CFN_CustomerFaceNbr
			WHERE SPL_SPH_ID = @ShipmentId
			AND NOT EXISTS(SELECT 1 FROM DealerAuthorizationTable
					INNER JOIN HospitalList ON DAT_ID = HLA_DAT_ID
					WHERE DAT_Type IN ('Normal','Temp','Shipment')
					AND DAT_ProductLine_BUM_ID = @ProductLineId
					AND DAT_DMA_ID = @DealerId
					AND  HLA_HOS_ID=@HospitalId
					AND CCF.ClassificationId=DAT_PMA_ID
					AND @ShipmentDate BETWEEN ISNULL(HLA_StartDate,'1900-01-01') AND ISNULL(HLA_EndDate,DATEADD(DAY,-1,@ShipmentDate)) 
					)
		END
	END
	
	--删除销售调整中数据
	--DELETE FROM ShipmentAdjustLot WHERE SAL_SPH_ID = @ShipmentId
	DELETE  A FROM ShipmentAdjustLot A 
	INNER JOIN CFN B ON A.SAL_CFN_ID=B.CFN_ID
	INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=B.CFN_CustomerFaceNbr
	WHERE SAL_SPH_ID = @ShipmentId
	AND NOT EXISTS(SELECT 1 FROM DealerAuthorizationTable
					INNER JOIN HospitalList ON DAT_ID = HLA_DAT_ID
					WHERE DAT_Type IN ('Normal','Temp','Shipment')
					AND DAT_ProductLine_BUM_ID = @ProductLineId
					AND DAT_DMA_ID = @DealerId
					AND  HLA_HOS_ID=@HospitalId
					AND CCF.ClassificationId=DAT_PMA_ID
					AND @ShipmentDate BETWEEN ISNULL(HLA_StartDate,'1900-01-01') AND ISNULL(HLA_EndDate,DATEADD(DAY,-1,@ShipmentDate)) ) 
	
	
	
IF ISNULL(@retMassage,'')='' 
	SET @retMassage='';

END
GO


