SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


/*
维护合同主数据
*/
ALTER Procedure [Consignment].[Proc_CreateReturnOrder]
AS
	--参数
	DECLARE @CST_ID uniqueidentifier
	DECLARE @RtnVal nvarchar(20)
	DECLARE @RtnMsg nvarchar(4000) 
	
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
	
		DECLARE @Sysflg INT
		DECLARE @UserId uniqueidentifier
		DECLARE @CCH_ID UNIQUEIDENTIFIER
	    DECLARE  @SubCompanyId NVARCHAR(50)
        DECLARE  @BrandId NVARCHAR(50)

		Create table #CompleteList (
			TCL_ID uniqueidentifier NOT NULL,
			TCL_CST_ID  uniqueidentifier NOT NULL,
			TCL_CompleteDate datetime NOT NULL,
			TCL_SynStatus INT NULL,
			TCL_SynDate datetime NULL,
		)
		
		Create table #ReturnList (
		    OrderNo NVARCHAR(50) NOT NULL,
			LPDealerId uniqueidentifier NOT NULL,
			PMA_ID uniqueidentifier NOT NULL,
			LotNumber  NVARCHAR(200) collate Chinese_PRC_CI_AS NOT NULL ,
		)
		
		Create table #InventoryReturnInit (
			IRI_ID uniqueidentifier  NULL,
			IRI_USER uniqueidentifier NULL,
			IRI_UploadDate datetime NULL,
			IRI_LineNbr INT NULL,
			IRI_Warehouse NVARCHAR(200) collate Chinese_PRC_CI_AS NOT NULL,
			IRI_ArticleNumber NVARCHAR(200) collate Chinese_PRC_CI_AS NOT NULL,
			IRI_LotNumber NVARCHAR(200) collate Chinese_PRC_CI_AS NOT NULL,
			IRI_ReturnQty NVARCHAR(200) collate Chinese_PRC_CI_AS NOT NULL,
			IRI_DMA_ID uniqueidentifier  NULL,
			IRI_WHM_ID uniqueidentifier  NULL,
			IRI_SubCompany_ID uniqueidentifier  NULL,
			IRI_Brand_ID uniqueidentifier  NULL,
			IRI_QrCode  NVARCHAR(200) collate Chinese_PRC_CI_AS NOT NULL
			)
		
		UPDATE  A SET TCL_SynStatus=1  from Consignment.TerminationCompleteList a 
		WHERE a.TCL_SynStatus=0 ;
		
		INSERT INTO #CompleteList(TCL_ID,TCL_CST_ID,TCL_CompleteDate,TCL_SynStatus,TCL_SynDate)
		SELECT TCL_ID,TCL_CST_ID,TCL_CompleteDate,TCL_SynStatus,TCL_SynDate 
		FROM Consignment.TerminationCompleteList  where TCL_SynStatus=1
		
		
		DECLARE @PRODUCT_CUR cursor;
		SET @PRODUCT_CUR=cursor for 
			SELECT TCL_CST_ID
			FROM #CompleteList WHERE TCL_SynStatus=1
		OPEN @PRODUCT_CUR
		FETCH NEXT FROM @PRODUCT_CUR INTO @CST_ID
		WHILE @@FETCH_STATUS = 0        
			BEGIN
				DELETE #ReturnList
				DELETE #InventoryReturnInit
				
				SELECT @CCH_ID=CST_CCH_ID FROM Consignment.ConsignmentTermination A WHERE A.CST_ID = @CST_ID
			
				INSERT INTO #ReturnList(OrderNo,LPDealerId,PMA_ID,LotNumber)
				SELECT OInfo.OrderNo, PRH.PRH_Dealer_DMA_ID,POR_SAP_PMA_ID,PRL.PRL_LotNumber
					FROM POReceiptHeader PRH, POReceipt PR, POReceiptLot PRL,
					(
						select H.POH_OrderNo AS OrderNo, H.POH_DMA_ID AS DMAID, D.POD_CFN_ID AS CFN_ID,P.PMA_ID AS PMA_ID, CCH.CCH_ID, min(D.POD_ConsignmentDay) As ConsignmentDay ,max(isnull(CCH.CCH_EndDate,Convert(datetime,'2099-01-01'))) AS ContractEndDate,UPPER(LI.IDENTITY_CODE) AS UserAccount
						from PurchaseOrderHeader H 
						inner join PurchaseOrderDetail_WithQR D ON (H.POH_ID = D.POD_POH_ID)
						inner join product P on (P.PMA_CFN_ID = D.POD_CFN_ID)
						left join Consignment.ContractHeader CCH on (CCH.CCH_ID = D.POD_ConsignmentContractID )
						left join Lafite_IDENTITY LI on (LI.Id = CCH.CCH_CreateUser )
						where H.POH_OrderType='Consignment'
						AND H.POH_CreateType='Manual'
						AND H.POH_SubmitDate>'2018-10-01'
						AND CCH.CCH_ID=@CCH_ID
						group by H.POH_OrderNo, H.POH_DMA_ID, D.POD_CFN_ID,P.PMA_ID, LI.IDENTITY_CODE , CCH.CCH_ID
					) AS OInfo  
				where PRH.PRH_ID= PR.POR_PRH_ID and PR.POR_ID = PRL.PRL_POR_ID 
				and PRH.PRH_PurchaseOrderNbr = OInfo.OrderNo and PR.POR_SAP_PMA_ID = OInfo.PMA_ID
				and PRH.PRH_Dealer_DMA_ID = OInfo.DMAID
				AND PRH.PRH_SAPShipmentDate>'2018-10-01'
				
				INSERT INTO #InventoryReturnInit(IRI_ID,IRI_USER,IRI_UploadDate,IRI_LineNbr,IRI_Warehouse,IRI_ArticleNumber,IRI_LotNumber,IRI_ReturnQty,IRI_DMA_ID,IRI_WHM_ID,IRI_QrCode,IRI_SubCompany_ID,IRI_Brand_ID)
				SELECT NEWID(), G.Id,GETDATE(),ROW_NUMBER() OVER (ORDER BY WHM_Name),c.WHM_Name,Product.PMA_UPN
				,CASE WHEN CHARINDEX('@@',A.LotNumber) > 0 THEN substring(A.LotNumber,1,CHARINDEX('@@',A.LotNumber)-1) ELSE A.LotNumber END AS LotNumber
				,E.LOT_OnHandQty
				,B.DMA_ID,C.WHM_ID
				,CASE WHEN CHARINDEX('@@',A.LotNumber) > 0 THEN substring(A.LotNumber,CHARINDEX('@@',A.LotNumber)+2,LEN(A.LotNumber)-CHARINDEX('@@',A.LotNumber)) ELSE 'NoQR' END AS QrCode
				,h.SubCompanyId
				,h.BrandId
				FROM #ReturnList A 
				INNER JOIN Product ON A.PMA_ID=Product.PMA_ID
				INNER JOIN DealerMaster B ON A.LPDealerId=B.DMA_Parent_DMA_ID
				INNER JOIN Lafite_IDENTITY G ON B.DMA_ID=G.Corp_ID AND g.IDENTITY_CODE LIKE '%_99'
				INNER JOIN Warehouse C ON C.WHM_DMA_ID=B.DMA_ID AND C.WHM_Type IN ('Consignment')
				INNER JOIN Inventory D ON D.INV_WHM_ID=C.WHM_ID
				INNER JOIN Lot E ON E.LOT_INV_ID=D.INV_ID
				INNER JOIN LotMaster F ON F.LTM_ID=E.LOT_LTM_ID AND F.LTM_LotNumber=A.LotNumber
				LEFT JOIN  PurchaseOrderHeader h ON h.POH_OrderNo=A.OrderNo
				--删除历史导入数据
				DELETE A FROM InventoryReturnInit A
				INNER JOIN #InventoryReturnInit B ON A.IRI_USER=B.IRI_USER
				
				--维护本次需要退货数据
				INSERT INTO InventoryReturnInit(IRI_ID,IRI_USER,IRI_UploadDate,IRI_LineNbr,IRI_Warehouse,IRI_ArticleNumber,IRI_LotNumber,IRI_ReturnQty,IRI_DMA_ID,IRI_WHM_ID,IRI_QrCode,IRI_FileName,IRI_ErrorFlag)
				SELECT IRI_ID,IRI_USER,IRI_UploadDate,IRI_LineNbr,IRI_Warehouse,IRI_ArticleNumber,IRI_LotNumber,IRI_ReturnQty,IRI_DMA_ID,IRI_WHM_ID,IRI_QrCode,NEWID(),0 FROM #InventoryReturnInit
				
				--20191231 add SubCompany Brand获取
				DECLARE @PRODUCT_CUR2 cursor;
				SET @PRODUCT_CUR2=cursor for 
					SELECT DISTINCT IRI_USER,IRI_SubCompany_ID,IRI_Brand_ID
					FROM #InventoryReturnInit
				OPEN @PRODUCT_CUR2
				FETCH NEXT FROM @PRODUCT_CUR2 INTO @UserId,@SubCompanyId,@BrandId
				WHILE @@FETCH_STATUS = 0        
					BEGIN
					    IF(ISNULL(@SubCompanyId,'')<>'' AND ISNULL(@BrandId,'')<>'')
						  EXEC [dbo].[GC_InventoryReturnInit] @UserId,@SubCompanyId,@BrandId,'ForceImport',''

						SET @SubCompanyId=''
						SET @BrandId=''
					FETCH NEXT FROM @PRODUCT_CUR2 INTO @UserId
					END
				CLOSE @PRODUCT_CUR2
				DEALLOCATE @PRODUCT_CUR2 ;
				
			
			FETCH NEXT FROM @PRODUCT_CUR INTO @CST_ID
			END
		CLOSE @PRODUCT_CUR
		DEALLOCATE @PRODUCT_CUR ;
		
		
		UPDATE Consignment.TerminationCompleteList  SET TCL_SynStatus=2,TCL_SynDate=GETDATE() WHERE TCL_SynStatus=1 
		
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 

 SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
	INSERT INTO MailMessageQueue 
	VALUES(NEWID(),'email','','cooper.xu@grapecity.com','寄售终止同步错误[Consignment].[Proc_CreateReturnOrder]，终止编号：'+CONVERT(nvarchar(50),@CST_ID),@RtnMsg,'Waiting',GETDATE(),null)
	
    return -1
		
END CATCH






GO

