DROP Procedure [dbo].[GC_GetDealerPurchaseOrderCfn_Info]
GO






/*
获取平台下载的日志信息
*/
CREATE Procedure [dbo].[GC_GetDealerPurchaseOrderCfn_Info]
	@DealerId uniqueidentifier,
	@Upn nvarchar(50)
AS

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
--临时表用于返回table
 
 CREATE TABLE #CfnInfo
 (
  Id uniqueidentifier,
  CfnName nvarchar(50),
  Upn nvarchar(50),
  Title nvarchar(50),
  Messing nvarchar(100)
 )	     

  IF EXISTS(SELECT 1 FROM CFN WHERE CFN_CustomerFaceNbr=@Upn)
  BEGIN

  --将产品状态是否可订购写入临时表
    INSERT INTO #CfnInfo
   SELECT CFN.CFN_ID,CFN.CFN_ChineseName,CFN.CFN_CustomerFaceNbr, '产品状态（波科系统参数）' AS 
   title,CASE WHEN CONVERT (NVARCHAR(10), ISNULL(CFN.CFN_Property4,'0'))='1' THEN '可订购' ELSE '不可订购' END AS Messing FROM
    CFN WHERE CFN_CustomerFaceNbr=@Upn
--将产品是否有对应经销商的授权写入临时表
  --  INSERT INTO #CfnInfo
  --  SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr,'产品对应经销商是否有授权' AS title,
		--	CASE WHEN (CONVERT(NVARCHAR(10),DAT_StartDate, 112)<=(CONVERT(NVARCHAR(10),GETDATE(), 112)) 
		--	AND CONVERT(NVARCHAR(10),DAT_EndDate, 112)>=(CONVERT(NVARCHAR(10),GETDATE(), 112))) 
		--	THEN '可订购' 
		--	ELSE '该产品的经销商授权已过期，不可订购' 
		--	END AS Messing 
		--FROM ( SELECT B.CFN_ID,B.CFN_ChineseName,B.CFN_CustomerFaceNbr,A.DAT_StartDate,A.DAT_EndDate 
		--			FROM (SELECT * FROM DealerAuthorizationTable WHERE DAT_PMA_ID=DAT_ProductLine_BUM_ID) A
		--			INNER JOIN CFN B ON A.DAT_PMA_ID=B.CFN_ProductLine_BUM_ID WHERE  DAT_DMA_ID=@DealerId
		--			AND B.CFN_CustomerFaceNbr=@Upn AND DAT_Type='Normal'
		--		UNION 
		--		SELECT  B.CFN_ID,B.CFN_ChineseName,B.CFN_CustomerFaceNbr,A.DAT_StartDate,A.DAT_EndDate 
		--		FROM (SELECT * FROM DealerAuthorizationTable WHERE DAT_PMA_ID<>DAT_ProductLine_BUM_ID) A
		--		INNER JOIN CfnClassification CCF ON CCF.ClassificationId=A.DAT_PMA_ID
		--		INNER JOIN CFN B ON CCF.CfnCustomerFaceNbr=B.CFN_CustomerFaceNbr
		--		WHERE  DAT_DMA_ID=@DealerId
		--		AND B.CFN_CustomerFaceNbr=@Upn AND DAT_Type='Normal'
		--		AND CCF.ClassificationId IN (select ProducPctId from GC_FN_GetDealerAuthProductSub(DAT_DMA_ID) WHERE ActiveFlag=1)
		--	)TB 
		--	GROUP BY CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr,DAT_StartDate,DAT_EndDate
			
	INSERT INTO #CfnInfo
	SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr ,'产品对应经销商是否有授权' AS title,
		CASE WHEN EXISTS(SELECT 1 FROM CfnClassification CCF 
							INNER JOIN  DBO.GC_FN_GetDealerAuthProductSub(@DealerId) PL ON PL.ProducPctId=CCF.ClassificationId 
							WHERE CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr  and GETDATE() BETWEEN PL.ProductBeginDate AND PL.ProductEndDate
							)
		THEN '可订购'
		ELSE '无该产品的经销商授权或者授权已过期，不可订购' END  AS Messing
	FROM CFN 
	INNER JOIN CfnClassification CFC ON CFN.CFN_CustomerFaceNbr=CFC.CfnCustomerFaceNbr 
	WHERE CFN.CFN_CustomerFaceNbr=@Upn
			
	
--将产品是否在MDM中维护写入临时表
   INSERT INTO #CfnInfo
   SELECT CFN.CFN_ID,CFN.CFN_ChineseName,CFN.CFN_CustomerFaceNbr, '产品分类是否在MDM中维护' AS title,CASE WHEN CONVERT (NVARCHAR(50), CCF.ClassificationId)='00000000-0000-0000-0000-000000000000' THEN '产品分类没有在MDS中维护，不可订购' ELSE '可订购' END AS Messing 
   FROM CFN 
   INNER JOIN CfnClassification CCF ON CFN.CFN_CustomerFaceNbr=CCF.CfnCustomerFaceNbr
   WHERE CFN.CFN_CustomerFaceNbr=@Upn
   
--将客户是否申请价格写入临时表
   IF EXISTS(SELECT 1 FROM CFN WHERE EXISTS(SELECT 1 FROM CFNPrice A WHERE CFN.CFN_ID=A.CFNP_CFN_ID 
   AND CFNP_Group_ID=@DealerId AND CFN.CFN_CustomerFaceNbr=@Upn AND 
   ISNULL(CFNP_Price,0)>0 AND CFNP_PriceType IN('DealerConsignment','Dealer')))
    BEGIN
    INSERT INTO #CfnInfo
     SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr,'客户是否申请过正常采购价格','可订购' FROM CFN WHERE CFN_CustomerFaceNbr=@Upn
    END
   ELSE
    BEGIN
     INSERT INTO #CfnInfo
     SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr,'客户是否申请过正常采购价格','未维护过价格，不可订购' FROM CFN WHERE CFN_CustomerFaceNbr=@Upn
    END
--将产品注册证与客户经营许可分类是否相同写入临时表
 IF ((select COUNT(*) from MD.INF_UPN t1, MD.INF_REG t2, cfn t3
      where t1.REG_NO=t2.REG_NO and t3.CFN_Property1 = t1.SAP_Code
     and t3.CFN_CustomerFaceNbr=@Upn)>0 AND  (select COUNT(*)
     from DealerMasterLicense
     where DML_DMA_ID=@DealerId)>0)
 BEGIN   
      IF EXISTS(select t3.CFN_CustomerFaceNbr, t1.SAP_Code, t2.GM_KIND, t2.GM_CATALOG 
       from MD.INF_UPN t1, MD.INF_REG t2, cfn t3
      where t1.REG_NO=t2.REG_NO and t3.CFN_Property1 = t1.SAP_Code AND t3.CFN_CustomerFaceNbr=@Upn
      AND EXISTS(SELECT 1 FROM (  select DML_CurLicenseValidFrom,  
                          DML_CurLicenseValidTo,    
                          DML_CurSecondClassCatagory,
                          DML_CurFilingValidFrom,    
                          DML_CurFilingValidTo ,    
                          DML_CurThirdClassCatagory  
                          from DealerMasterLicense
      where DML_DMA_ID=@DealerId)tb 
      where (tb.DML_CurSecondClassCatagory like '%'+t2.GM_CATALOG +'%' and t2.GM_Kind in ('2','II') )
        or (tb.DML_CurThirdClassCatagory like '%'+t2.GM_CATALOG +'%' and t2.GM_KIND in ('3','III') )
        or t2.GM_KIND = '1'  ) )
     BEGIN
       INSERT INTO #CfnInfo
        SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr,'经销商经营许可是否包含该产品','可订购' FROM CFN WHERE CFN_CustomerFaceNbr=@Upn
     END
   ELSE
    BEGIN
      INSERT INTO #CfnInfo
      SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr,'经销商经营许可是否包含该产品','经销商资质无此产品分类代码，不可订购' FROM CFN WHERE CFN_CustomerFaceNbr=@Upn
    END
    
    
    
   
  END 
 ELSE
    BEGIN
       INSERT INTO #CfnInfo
       SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr,'经销商经营许可是否包含该产品','可订购' FROM CFN WHERE CFN_CustomerFaceNbr=@Upn
    END
 END 
 ELSE
  BEGIN
      INSERT INTO #CfnInfo
      SELECT NULL,NULL,NULL,'提示','产品编号填写错误或对应的经销商没有该产品' 
  END
  
  
  
  
  
  
   IF EXISTS(select t3.CFN_CustomerFaceNbr, t1.SAP_Code, t2.GM_KIND, t2.GM_CATALOG 
       from MD.INF_UPN t1, MD.INF_REG t2, cfn t3
      where t1.REG_NO=t2.REG_NO and t3.CFN_Property1 = t1.SAP_Code AND t3.CFN_CustomerFaceNbr=@Upn
      AND EXISTS(SELECT 1 FROM (  select DML_CurLicenseValidFrom,  
                                         DML_CurLicenseValidTo,    
                                         DML_CurSecondClassCatagory,
                                         DML_CurFilingValidFrom,    
                                         DML_CurFilingValidTo ,    
                                         DML_CurThirdClassCatagory  
                                    from DealerMasterLicense
                                   where DML_DMA_ID=@DealerId )tb 
                         where t2.GM_KIND = '3' and (DML_CurLicenseValidFrom > GETDATE() or  DML_CurLicenseValidTo < GETDATE())                         
                         ))
     BEGIN
       INSERT INTO #CfnInfo
        SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr,'经销商经营许可证是否在有效期','不在有效期，不可订购' FROM CFN WHERE CFN_CustomerFaceNbr=@Upn
     END
   ELSE
    BEGIN
      INSERT INTO #CfnInfo
      SELECT CFN_ID,CFN_ChineseName,CFN_CustomerFaceNbr,'经销商经营许可证是否不在有效期','可订购' FROM CFN WHERE CFN_CustomerFaceNbr=@Upn
    END
    
 SELECT * FROM #CfnInfo
      

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    return -1
    
END CATCH




