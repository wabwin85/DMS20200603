
/****** Object:  StoredProcedure [Consignment].[GC_ConsignmentTransferInit]    Script Date: 2019/10/30 15:49:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
订单寄售申请单
*/
ALTER Procedure [Consignment].[GC_ConsignmentTransferInit]
    @UserId uniqueidentifier,
    @ImportType NVARCHAR(20),   --导入类型：校验、校验并提交
	@SubCompanyId uniqueidentifier,
	@BrandId uniqueidentifier,
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

CREATE TABLE #TransferHeader(
	[TH_ID] [uniqueidentifier] NOT NULL,
	[TH_DMA_ID_To] [uniqueidentifier] NULL,
	[TH_DMA_ID_From] [uniqueidentifier] NULL,
	[TH_No] [varchar](50) NULL,
	ProductLineName [varchar](200) NULL,
	[TH_ProductLine_BUM_ID] [uniqueidentifier] NULL,
	[TH_CCH_ID] [uniqueidentifier] NULL,
	[TH_Status] [varchar](50) NULL,
	[TH_HospitalId] [uniqueidentifier] NULL,
	[TH_Remark] [nvarchar](max) NULL,
	[TH_SalesAccount] [varchar](50) NULL,
	[TH_CreateUser] [uniqueidentifier] NULL,
	[TH_CreateDate] [datetime] NULL
)

CREATE TABLE #TransferDetails(
	[TD_ID] [uniqueidentifier] NOT NULL,
	[TD_TH_ID] [uniqueidentifier] NOT NULL,
	[TD_CFN_ID] [uniqueidentifier] NULL,
	[TD_UOM] [nvarchar](100) NULL,
	[TD_QTY] [decimal](18, 6) NULL,
	[TD_CFN_Price] [decimal](18, 6) NULL,
	[TD_Amount] [decimal](18, 6) NULL
)






--借入方ID
UPDATE A SET A.DealerIdTo=B.DMA_ID FROM  dbo.ConsignmentTransferInit A 
INNER JOIN DealerMaster B ON A.DealerCodeTo=B.DMA_SAP_Code
WHERE InputUser = @UserId and ISNULL(a.ErrFlg,0)=0
UPDATE dbo.ConsignmentTransferInit SET ErrFlg=1,ErrMassages='借入经销商SAP编号维护错误' WHERE DealerIdTo IS NULL AND InputUser = @UserId and ISNULL(ErrFlg,0)=0

--借出方ID
UPDATE A SET A.DealerIdFrom=B.DMA_ID FROM  dbo.ConsignmentTransferInit A 
INNER JOIN DealerMaster B ON A.DealerCodeFrom=B.DMA_SAP_Code
WHERE InputUser = @UserId and ISNULL(a.ErrFlg,0)=0
UPDATE dbo.ConsignmentTransferInit SET ErrFlg=1,ErrMassages='借出经销商SAP编号维护错误' WHERE DealerIdFrom IS NULL AND InputUser = @UserId and ISNULL(ErrFlg,0)=0

--校验产品名称
UPDATE A SET A.ProductLineId=B.Id  FROM dbo.ConsignmentTransferInit A 
INNER JOIN dbo.View_ProductLine B(NOLOCK) ON A.ProductLineName=B.ATTRIBUTE_NAME AND B.SubCompanyId=@SubCompanyId AND B.BrandId=@BrandId
 WHERE InputUser = @UserId and ISNULL(ErrFlg,0)=0
UPDATE dbo.ConsignmentTransferInit SET ErrFlg=1,ErrMassages='产品线维护错误' WHERE ProductLineId IS NULL AND InputUser = @UserId and ISNULL(ErrFlg,0)=0

--校验产品
UPDATE dbo.ConsignmentTransferInit SET ErrFlg=1,ErrMassages='产品编号不存在' 
WHERE InputUser = @UserId and ISNULL(ErrFlg,0)=0
AND NOT EXISTS (SELECT 1 FROM CFN WHERE CFN.CFN_CustomerFaceNbr=Upn)
 
--校验产品线与产品是否匹配
UPDATE A SET ErrFlg=1,ErrMassages='经销商产品编号与产品线不匹配' FROM dbo.ConsignmentTransferInit A 
WHERE InputUser = @UserId and ISNULL(ErrFlg,0)=0
AND NOT EXISTS (SELECT 1 FROM CFN WHERE CFN_ProductLine_BUM_ID=a.ProductLineId AND CFN.CFN_CustomerFaceNbr=a.Upn)

--校验医院信息是否维护正确
UPDATE A SET A.HospitalId=B.HOS_ID,a.HospitalName=b.HOS_HospitalName  FROM dbo.ConsignmentTransferInit A 
INNER JOIN Hospital B ON A.HospitalCode=B.HOS_Key_Account  WHERE InputUser = @UserId and ISNULL(ErrFlg,0)=0 AND ISNULL(A.HospitalName,'')<>''
UPDATE dbo.ConsignmentTransferInit SET ErrFlg=1,ErrMassages='医院编号维护不正确' WHERE ISNULL(HospitalCode,'')<>'' 
AND HospitalId IS NULL
AND InputUser = @UserId and ISNULL(ErrFlg,0)=0
 
--校验寄售合同是否正确
UPDATE A SET A.ContractId=B.CCH_ID  FROM dbo.ConsignmentTransferInit A 
INNER JOIN Consignment.ContractHeader B ON A.ContractNo=B.CCH_No  AND A.DealerIdTo=B.CCH_DMA_ID AND A.ProductLineId=B.CCH_ProductLine_BUM_ID
WHERE InputUser = @UserId and ISNULL(ErrFlg,0)=0
UPDATE dbo.ConsignmentTransferInit SET ErrFlg=1,ErrMassages='寄售合同与经销商不匹配' WHERE ContractId IS NULL AND InputUser = @UserId and ISNULL(ErrFlg,0)=0

--寄售合同与产品是否匹配
UPDATE A SET ErrFlg=1,ErrMassages='产品不在寄售合同允许范围内' 
FROM dbo.ConsignmentTransferInit A
WHERE InputUser = @UserId and ISNULL(ErrFlg,0)=0
AND NOT EXISTS (
	SELECT 1 FROM (
		SELECT D.CFN_CustomerFaceNbr FROM Consignment.ContractHeader B 
		INNER JOIN Consignment.ContractDetail C ON B.CCH_ID=C.CCD_CCH_ID AND C.CCD_CfnType='UPN'
		INNER JOIN CFN D ON C.CCD_CfnShortNumber=D.CFN_Property1 
		WHERE B.CCH_ID=A.ContractId
		UNION
		SELECT D.CFN_CustomerFaceNbr FROM Consignment.ContractHeader B 
		INNER JOIN Consignment.ContractDetail C ON B.CCH_ID=C.CCD_CCH_ID AND C.CCD_CfnType='组套'
		INNER JOIN MD.ProductBOM E ON E.BOMUPN=C.CCD_CfnShortNumber
		INNER JOIN CFN D ON E.BOMUPN=D.CFN_CustomerFaceNbr 
		WHERE B.CCH_ID=A.ContractId
	) TAB WHERE TAB.CFN_CustomerFaceNbr=A.Upn
)

--校验产品授权
UPDATE A SET ErrFlg=1,ErrMassages='产品不在经销商授权范围内' 
FROM dbo.ConsignmentTransferInit A
INNER JOIN CFN ON A.Upn=CFN.CFN_CustomerFaceNbr
WHERE InputUser = @UserId and ISNULL(ErrFlg,0)=0
AND dbo.GC_Fn_CFN_CheckDealerAuth(A.DealerIdTo,CFN.CFN_ID) = 0

--产品价格
UPDATE A SET ErrFlg=1,ErrMassages='经销商无该产品采购价' 
FROM dbo.ConsignmentTransferInit A
INNER JOIN CFN ON A.Upn=CFN.CFN_CustomerFaceNbr
WHERE InputUser = @UserId and ISNULL(ErrFlg,0)=0
AND NOT EXISTS (SELECT 1 FROM CFNPrice B WHERE CFN.CFN_ID=B.CFNP_CFN_ID AND A.DealerIdTo=B.CFNP_Group_ID AND B.CFNP_PriceType='DealerConsignment')


--校验寄售合同与医院关系(小于15天的寄售，需要选择医院信息)
UPDATE A SET ErrFlg=1,ErrMassages='小于等于15天的寄售必须填写医院' 
FROM dbo.ConsignmentTransferInit A 
INNER JOIN Consignment.ContractHeader B ON A.ContractId=B.CCH_ID
WHERE InputUser = @UserId and ISNULL(ErrFlg,0)=0
AND B.CCH_ConsignmentDay<=15
AND A.HospitalId IS NULL 




--检查是否存在错误
IF (SELECT COUNT(*) FROM dbo.ConsignmentTransferInit WHERE ErrFlg = 1 AND InputUser = @UserId) > 0
	BEGIN
		/*如果存在错误，则返回Error*/
		SET @IsValid = 'Error'
	END
ELSE
	BEGIN
		/*如果不存在错误，则返回Success*/		
		SET @IsValid = 'Success'		
	END

IF @ImportType = 'Import' AND @IsValid = 'Success'
BEGIN

	INSERT INTO #TransferHeader(TH_ID,TH_DMA_ID_To,TH_DMA_ID_From,TH_No,TH_ProductLine_BUM_ID,TH_CCH_ID,TH_Status,TH_HospitalId,TH_Remark,TH_SalesAccount,TH_CreateUser,TH_CreateDate) 
	
	SELECT NEWID() AS TH_ID,*
		FROM (SELECT DISTINCT 
		a.DealerIdTo,a.DealerIdFrom,NULL AS [No],a.ProductLineId,a.ContractId,'Draft' AS [Status],a.HospitalId,a.Remark,NULL AS SalesAccount,a.InputUser,getdate()as InputDate
	FROM dbo.ConsignmentTransferInit A 
	WHERE A.InputUser = @UserId) TAB
	
	INSERT INTO #TransferDetails (TD_ID,TD_TH_ID,TD_CFN_ID,TD_UOM,TD_QTY,TD_CFN_Price,TD_Amount)
	SELECT NEWID(),B.TH_ID,CFN.CFN_ID,C.PMA_UnitOfMeasure,SUM(A.Qty),D.CFNP_Price,SUM(A.Qty*D.CFNP_Price)
	FROM dbo.ConsignmentTransferInit A 
	INNER JOIN #TransferHeader B ON A.DealerIdTo=B.TH_DMA_ID_To AND A.ProductLineId=b.TH_ProductLine_BUM_ID AND A.ContractId=B.TH_CCH_ID AND A.HospitalId=B.TH_HospitalId AND A.DealerIdFrom=B.TH_DMA_ID_From
	INNER JOIN CFN ON A.Upn=CFN.CFN_CustomerFaceNbr
	INNER JOIN Product C ON C.PMA_CFN_ID=CFN.CFN_ID
	INNER JOIN CFNPrice D ON D.CFNP_Group_ID=A.DealerIdTo AND D.CFNP_PriceType='DealerConsignment' AND D.CFNP_CFN_ID=CFN.CFN_ID
	WHERE A.InputUser = @UserId 
	AND ISNULL(A.HospitalId,'')<>''
	GROUP BY B.TH_ID,CFN.CFN_ID,C.PMA_UnitOfMeasure,D.CFNP_Price
	
	INSERT INTO #TransferDetails (TD_ID,TD_TH_ID,TD_CFN_ID,TD_UOM,TD_QTY,TD_CFN_Price,TD_Amount)
	SELECT NEWID(),B.TH_ID,CFN.CFN_ID,C.PMA_UnitOfMeasure,SUM(A.Qty),D.CFNP_Price,SUM(A.Qty*D.CFNP_Price)
	FROM dbo.ConsignmentTransferInit A 
	INNER JOIN #TransferHeader B ON A.DealerIdTo=B.TH_DMA_ID_To AND A.ProductLineId=b.TH_ProductLine_BUM_ID AND A.ContractId=B.TH_CCH_ID AND A.DealerIdFrom=B.TH_DMA_ID_From
	INNER JOIN CFN ON A.Upn=CFN.CFN_CustomerFaceNbr
	INNER JOIN Product C ON C.PMA_CFN_ID=CFN.CFN_ID
	INNER JOIN CFNPrice D ON D.CFNP_Group_ID=A.DealerIdTo AND D.CFNP_PriceType='DealerConsignment' AND D.CFNP_CFN_ID=CFN.CFN_ID
	WHERE A.InputUser = @UserId 
	AND ISNULL(A.HospitalId,'')=''
	GROUP BY B.TH_ID,CFN.CFN_ID,C.PMA_UnitOfMeasure,D.CFNP_Price
	
	
	--寄售转移申请编号
	DECLARE @TH_ID	uniqueidentifier;
	DECLARE @TH_DMA_ID_To	uniqueidentifier;
	DECLARE @TH_DMA_ID_From	uniqueidentifier;
	DECLARE @TH_ProductLine_BUM_ID	uniqueidentifier;
	
	DECLARE @TH_NO	NVARCHAR(50);
	
	
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
		SELECT a.TH_ID ,a.TH_DMA_ID_To,a.TH_DMA_ID_From,a.TH_ProductLine_BUM_ID FROM #TransferHeader a
	OPEN @PRODUCT_CUR
	FETCH NEXT FROM @PRODUCT_CUR INTO @TH_ID,@TH_DMA_ID_To,@TH_DMA_ID_From,@TH_ProductLine_BUM_ID
	WHILE @@FETCH_STATUS = 0        
	BEGIN
		SET @TH_NO=''
		EXEC Consignment.Proc_GetNextAutoNumber NULL,@TH_ProductLine_BUM_ID,'CSTT','ConsignTrnsfer', @TH_NO OUTPUT
		UPDATE #TransferHeader SET TH_NO=ISNULL(@TH_NO,'') WHERE TH_ID=@TH_ID
		
	FETCH NEXT FROM @PRODUCT_CUR INTO @TH_ID,@TH_DMA_ID_To,@TH_DMA_ID_From,@TH_ProductLine_BUM_ID
	END
	CLOSE @PRODUCT_CUR
	DEALLOCATE @PRODUCT_CUR ;
	
	
	
	--维护正式表
	INSERT INTO Consignment.TransferHeader (TH_ID,TH_DMA_ID_To,TH_DMA_ID_From,TH_No,TH_ProductLine_BUM_ID,TH_CCH_ID,TH_Status,TH_HospitalId,TH_Remark,TH_SalesAccount,TH_CreateUser,TH_CreateDate)
	SELECT TH_ID,TH_DMA_ID_To,TH_DMA_ID_From,TH_No,TH_ProductLine_BUM_ID,TH_CCH_ID,TH_Status,TH_HospitalId,TH_Remark,TH_SalesAccount,TH_CreateUser,TH_CreateDate
	FROM #TransferHeader
	

	INSERT INTO Consignment.TransferDetail(TD_ID,TD_TH_ID,TD_CFN_ID,TD_UOM,TD_QTY,TD_CFN_Price,TD_Amount)
	SELECT TD_ID,TD_TH_ID,TD_CFN_ID,TD_UOM,TD_QTY,TD_CFN_Price,TD_Amount FROM #TransferDetails
	
	
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),A.TH_ID,A.TH_CreateUser,GETDATE(),'ExcelImport','批量导入草稿状态经销商寄售转移申请' 
	FROM #TransferHeader A
	
	
	
	
END



COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
    return -1
    
END CATCH

