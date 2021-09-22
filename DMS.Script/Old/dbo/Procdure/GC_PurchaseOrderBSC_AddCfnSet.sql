DROP Procedure [dbo].[GC_PurchaseOrderBSC_AddCfnSet]
GO

/*
����������ӳ��ײ�Ʒ
*/
CREATE Procedure [dbo].[GC_PurchaseOrderBSC_AddCfnSet]
  @PohId uniqueidentifier,
	@DealerId uniqueidentifier,
	@CfnString NVARCHAR(1000),
  @PriceType NVARCHAR (20),
  @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
AS
  DECLARE @ErrorCount INTEGER
	DECLARE @CfnId uniqueidentifier
	DECLARE @CfnQty nvarchar(200)
  DECLARE @CfnQtyInt INT
	DECLARE @ArticleNumber NVARCHAR(200)
  DECLARE @UOM NVARCHAR(200)
  DECLARE @CFNPPrice Decimal(18,6)
  DECLARE @CurRegNo nvarchar(500)
  DECLARE @CurValidDateFrom datetime 
  DECLARE @CurValidDataTo datetime
  DECLARE @CurManuName nvarchar(500)
  DECLARE @LastRegNo nvarchar(500)
  DECLARE @LastValidDateFrom datetime
  DECLARE @LastValidDataTo datetime
  DECLARE @LastManuName nvarchar(500)
  DECLARE @CurGMKind nvarchar(200)
  DECLARE @CurGMCatalog nvarchar(200)
  DECLARE @ErrUPN nvarchar(2000)
  DECLARE @BOMUPNSUMAMT decimal(18,6)
  DECLARE @MASTERUPNSUMAMT decimal(18,6)
  DECLARE @DISCOUNTRATE decimal(18,6)
  DECLARE @DIFAMOUNT decimal(18,2)
  
	/*�����ݽ�����CFNID�ַ���ת�����ݱ�*/
	DECLARE CfnCursor CURSOR FOR 
		  SELECT T1.SET_ID,T2.CFN_CustomerFaceNbr,T1.SET_QTY,
             REG.CurRegNo,
             REG.CurValidDateFrom,
             REG.CurValidDataTo,
             REG.CurManuName,
             REG.LastRegNo,
             REG.LastValidDateFrom,
             REG.LastValidDataTo,
             REG.LastManuName,
             REG.CurGMKind,
             REG.CurGMCatalog
        FROM (
           SELECT LEFT(VAL,CHARINDEX('|',VAL)-1) AS SET_ID,SUBSTRING(VAL,CHARINDEX('|',VAL)+1,LEN(VAL)-CHARINDEX('|',VAL)) AS SET_QTY
				    FROM dbo.GC_Fn_SplitStringToTable(@CfnString,',') A
           ) T1 INNER JOIN CFN T2 ON (T1.SET_ID = T2.CFN_ID)
                LEFT JOIN MD.V_INF_UPN_REG AS REG ON (T2.CFN_CustomerFaceNbr = REG.CurUPN)
              
	DECLARE @Price decimal(18,6)	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
  
  CREATE TABLE #CFN(
			[CFN_ID] [uniqueidentifier] NOT NULL,
			[CFN_No] [nvarchar](200) NOT NULL)
      
  CREATE TABLE #ErrCFN(		
			[CFN_No] [nvarchar](200) NOT NULL)
  
	IF (SELECT count(*) FROM (
                  SELECT LEFT(VAL,CHARINDEX('|',VAL)-1) AS SET_ID,SUBSTRING(VAL,CHARINDEX('|',VAL)+1,LEN(VAL)-CHARINDEX('|',VAL)) AS SET_QTY
            				FROM dbo.GC_Fn_SplitStringToTable(@CfnString,',') A
                  ) T1, CFN T2
                  WHERE T1.SET_ID = T2.CFN_ID) > 1
        SET @RtnMsg = @RtnMsg + 'ֻ��ѡ��һ���豸<BR/>' 
	
  OPEN CfnCursor
	FETCH NEXT FROM CfnCursor INTO @CfnId, @ArticleNumber, @CfnQty, @CurRegNo, @CurValidDateFrom, @CurValidDataTo, @CurManuName, 
                                 @LastRegNo, @LastValidDateFrom, @LastValidDataTo, @LastManuName, @CurGMKind, @CurGMCatalog
	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF ISNUMERIC(@CfnQty) =0 OR FLOOR(Convert(Decimal(18,6),@CfnQty))<CEILING(Convert(Decimal(18,6),@CfnQty))
        SET @RtnMsg = @RtnMsg + @ArticleNumber + '��������������<BR/>'      
      ELSE
        IF Convert(INT,Convert(Decimal(18,2),@CfnQty)) = 0 or Convert(INT,Convert(Decimal(18,2),@CfnQty)) < 0
          SET @RtnMsg = @RtnMsg + @ArticleNumber + '�����������0<BR/>'  
        ELSE
          SET @CfnQtyInt = Convert(INT,Convert(Decimal(18,2),@CfnQty))
            
      --Edit By SongWeiming on 2017-05-02 ȡ�������Ŀ���
      --�����ײ�Ʒ�Ƿ��б���
      --select @CFNPPrice =CFNP_Price from cfnprice where CFNP_CFN_ID=@CfnId and CFNP_Group_ID = @DealerId and CFNP_PriceType = @PriceType
      --
      --IF @CFNPPrice is null or @CFNPPrice > 2
      --  SET @RtnMsg = @RtnMsg + @ArticleNumber + 'û���趨�ۿ۱������ۿ۱�������2<BR/>'      
      --�ж������豸������UPN�Ƿ���
      DELETE FROM #CFN
      DELETE FROM #ErrCFN
      INSERT INTO #CFN
      SELECT C.CFN_ID, C.CFN_CustomerFaceNbr FROM CFN C, MD.ProductBOM BM where C.CFN_CustomerFaceNbr = BM.BOMUPN and BM.MasterUPN = @ArticleNumber
     
      
      IF ((select COUNT(*) from MD.INF_UPN t1, MD.INF_REG t2, cfn t3
                           where t1.REG_NO=t2.REG_NO and t3.CFN_Property1 = t1.SAP_Code
                             AND t3.CFN_ID in (select T.CFN_ID from #CFN AS T))>0 AND (select COUNT(*) from DealerMasterLicense where DML_DMA_ID=@DealerId)>0)
         BEGIN   
            INSERT INTO #ErrCFN
            SELECT t1.SAP_Code
              from MD.INF_UPN t1, MD.INF_REG t2, cfn t3
              where t1.REG_NO=t2.REG_NO and t3.CFN_Property1 = t1.SAP_Code AND t3.CFN_ID in (select T.CFN_ID from #CFN AS T)
                AND NOT EXISTS(SELECT 1 FROM (   select DML_CurLicenseValidFrom,  
                                                    DML_CurLicenseValidTo,    
                                                    DML_CurSecondClassCatagory,
                                                    DML_CurFilingValidFrom,    
                                                    DML_CurFilingValidTo ,    
                                                    DML_CurThirdClassCatagory  
                                               from DealerMasterLicense
                                               where DML_DMA_ID=@DealerId)tb 
                                   where (tb.DML_CurSecondClassCatagory like '%'+t2.GM_CATALOG +'%' and t2.GM_Kind in ('2','II') )
                                           or (tb.DML_CurThirdClassCatagory like '%'+t2.GM_CATALOG +'%' and t2.GM_KIND in ('3','III') )
                                           or t2.GM_KIND = '1'  ) 
            
            IF ((SELECT COUNT(*) FROM #ErrCFN)>0)
               BEGIN                 
                 select @ErrUPN = stuff((select BOMUPN+',' from MD.ProductBOM where MasterUPN='Labsystem 40IC' for xml path('')),1,0,'')
                 SET @RtnMsg = @RtnMsg +'�������豸������UPN��' + @ErrUPN + ',�����������޴˲�Ʒ������룬���ɶ���<BR/>' 
               
               END
         END  
      --End Edit By SongWeiming on 2017-05-02 ȡ�������Ŀ���     
     
      
      
      IF len(@RtnMsg) = 0      
        BEGIN
          --����Ʒ��Ȩ
    			IF dbo.GC_Fn_CFN_CheckDealerAuth(@DealerId,@CfnId) = 1
    				BEGIN
    					--����Ƿ�ɶ���
    					IF dbo.GC_Fn_CFN_CheckBSCDealerCanOrder(@DealerId,@CfnId,@PriceType) = 1
    						BEGIN
                    delete from PurchaseOrderDetail where POD_POH_ID=@PohId
                    
    							  
                    insert into PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_UOM,POD_RequiredQty,
                                                     POD_Amount,POD_Tax,POD_ReceiptQty, POD_Field2,POD_CurRegNo,
                                                         POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,
                                                         POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
                                                         POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog )
                                   SELECT newid(),@PohId,DT.CFN_ID,DT.Price,DT.UOM,DT.DefaultQuantity * isnull(@CfnQtyInt,0),
                           PackagePrice * isnull(@CfnQtyInt,0),0,0, DT.DiscountRate,
                           @CurRegNo,@CurValidDateFrom,@CurValidDataTo,@CurManuName,@LastRegNo,@LastValidDateFrom,@LastValidDataTo,@LastManuName,
                                @CurGMKind,@CurGMCatalog
                      from (
                    SELECT t1.CFN_ID,
                           ISNULL (t2.CFNP_Price, 0) AS Price,
                           t1.CFN_CustomerFaceNbr AS UPN,
                           t1.CFN_Property3 AS UOM,
                           t1.CFN_ChineseName AS ChineseName,
                           t1.CFN_EnglishName AS EnglishName,
                           --Convert(nvarchar(15),t3.DiscountRate) + '(EWF:' + t3.CFNP_UOM_Inventory + ')' AS DiscountRate ,--t3.DiscountRate,
                           '(EWF:' + t3.CFNP_UOM_Inventory + ')��UPN:'+t3.MasterUPN  AS DiscountRate ,
                           t3.Qty AS DefaultQuantity,
                           --ISNULL (t2.CFNP_Price, 0) *  t3.DiscountRate * t3.Qty AS PackagePrice,
                           ISNULL (t2.CFNP_Price, 0) * t3.Qty AS PackagePrice,  --����ʹ���ۿ���
                           ROW_NUMBER () OVER (ORDER BY t1.CFN_CustomerFaceNbr) AS row_number
                      FROM cfn t1
                           LEFT JOIN
                           (SELECT CFNP_CFN_ID, CFNP_Price
                              FROM CFNPrice
                             WHERE CFNP_Group_ID = @DealerId AND CFNP_PriceType = @PriceType)
                           t2
                              ON (t1.CFN_ID = t2.CFNP_CFN_ID)
                           INNER JOIN
                           (SELECT DISTINCT BOM.Qty,
                                            convert(decimal(18,2),CFP.CFNP_Price) AS DiscountRate,
                                            BOM.BOMUPN,
                                            BOM.MasterUPN,
                                            CFP.CFNP_UOM_Inventory
                              FROM MD.ProductBOM BOM, CFN, CFNPrice CFP
                             WHERE     BOM.MasterUPN = CFN.CFN_CustomerFaceNbr
                                   AND CFN.CFN_ID = CFP.CFNP_CFN_ID
                                   AND CFP.CFNP_Group_ID = @DealerId
                                   AND CFP.CFNP_PriceType = @PriceType
                                   AND CFN.CFN_ID = @CfnId) t3
                              ON t1.CFN_CustomerFaceNbr = t3.BOMUPN
                     WHERE     t3.MasterUPN IN (SELECT CFN_CustomerFaceNbr
                                                  FROM cfn
                                                 WHERE CFN_ID = @CfnId)
                    ) AS DT     
                    
                  --����BOM������Ʒ�ĺϼƲɹ��ܽ��
                  SELECT @BOMUPNSUMAMT =  SUM(ISNULL(t1.CFNP_Price,0)* ISNULL(t2.Qty,0))
                    FROM CFNPrice t1, MD.ProductBOM t2, CFN t3 
                   WHERE t1.CFNP_CFN_ID = t3.CFN_ID 
                     AND t3.CFN_CustomerFaceNbr = t2.BOMUPN                      
                     AND t2.MasterUPN = @ArticleNumber                       
                     AND t1.CFNP_PriceType = @PriceType
                     AND t1.CFNP_Group_ID =  @DealerId
                   
                  SELECT @MASTERUPNSUMAMT = ISNULL(t1.CFNP_Price,0)
                    FROM CFNPrice t1, CFN t2
                   WHERE t1.CFNP_CFN_ID =t2.CFN_ID
                     AND t2.CFN_CustomerFaceNbr=@ArticleNumber
                     AND t1.CFNP_PriceType = @PriceType
                     AND t1.CFNP_Group_ID =  @DealerId
                    
                  --�������������6λС����
                  SET @DISCOUNTRATE = Convert(decimal(18,6),  @MASTERUPNSUMAMT / @BOMUPNSUMAMT)
                    
                  --���½��
                  UPDATE PurchaseOrderDetail SET POD_CFN_Price = convert(decimal(18,2),POD_CFN_Price * @DISCOUNTRATE) , POD_Amount=convert(decimal(18,2),POD_CFN_Price * @DISCOUNTRATE) * POD_RequiredQty
                  where POD_POH_ID=@PohId
                  
                  --����ֵ���ַ��ڵ�������һ����¼��
                  SELECT @DIFAMOUNT = Convert(decimal(18,2),@MASTERUPNSUMAMT * isnull(@CfnQtyInt,0) )- sum(POD_Amount) FROM PurchaseOrderDetail where POD_POH_ID=@PohId
                  
                  --���¼�¼
                  update PurchaseOrderDetail
                     set POD_CFN_Price = POD_CFN_Price + Convert(decimal(18,2),@DIFAMOUNT/POD_RequiredQty),
                         POD_Amount = POD_Amount + @DIFAMOUNT
                  where POD_ID = (
                  SELECT top 1 POD_ID FROM PurchaseOrderDetail POD
                  WHERE POD.POD_POH_ID=@PohId and POD.POD_Amount>@DIFAMOUNT
                  order by POD_CFN_Price desc)
                  
                  PRINT 'Insert Complete'
    						END
    					ELSE
    						SET @RtnMsg = @RtnMsg + @ArticleNumber + '���ɶ���<BR/>'
    				END
    			ELSE
    				SET @RtnMsg = @RtnMsg + @ArticleNumber + '��Ȩδͨ��<BR/>'
        END
			FETCH NEXT FROM CfnCursor INTO @CfnId, @ArticleNumber, @CfnQty, @CurRegNo, @CurValidDateFrom, @CurValidDataTo, @CurManuName, 
                                 @LastRegNo, @LastValidDateFrom, @LastValidDataTo, @LastManuName, @CurGMKind, @CurGMCatalog
		END
	CLOSE CfnCursor
	DEALLOCATE CfnCursor
COMMIT TRAN

IF len(@RtnMsg) > 1 
  SET @RtnVal = 'Warn'
SET NOCOUNT OFF
return 1


END TRY
BEGIN CATCH
    SET  NOCOUNT OFF
    ROLLBACK TRAN
    CLOSE CfnCursor
	  DEALLOCATE CfnCursor
    SET @RtnVal = 'Failure'

    --��¼������־��ʼ
    DECLARE @error_line   INT
    DECLARE @error_number   INT
    DECLARE @error_message   NVARCHAR (256)
    DECLARE @vError   NVARCHAR (1000)
    SET @error_line = ERROR_LINE ()
    SET @error_number = ERROR_NUMBER ()
    SET @error_message = ERROR_MESSAGE ()
    SET @vError =
             '��'
           + CONVERT (NVARCHAR (10), @error_line)
           + '����[�����'
           + CONVERT (NVARCHAR (10), @error_number)
           + '],'
           + @error_message
    SET @RtnMsg = @vError
    RETURN -1
END CATCH
GO


