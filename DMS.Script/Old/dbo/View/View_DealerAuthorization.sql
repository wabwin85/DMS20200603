DROP VIEW [dbo].[View_DealerAuthorization]
GO





CREATE VIEW [dbo].[View_DealerAuthorization]
AS
SELECT *
    FROM (SELECT 
                 dma_chinesename as Dealer,
                 DMA_EnglishName as DealerEN,
                 DMA_SAP_Code as  SAPID,
                 dp.DivisionCode as DivisionID,
                 dp.DivisionName as Division,
                 dat_productline_bum_id as ProductLineID,
                 attribute_name AS 'ProductLine',
                 DCL_STARTDATE,
                 dcl_stopdate,                
                 HOS_HospitalName as Hospital,
                 HOS_HospitalShortName,
                 HOS_Province as Province,                 
                 HOS_City as City,                
                 HOS_Key_Account,                
                 HOS_District,                
                 HOS_ActiveFlag                
            FROM dbo.DealerContract(nolock),
                 DEALERMASTER(nolock),
                 DealerAuthorizationTable(nolock),
                 dbo.PartsClassification(nolock),
                 View_ProductLine,
                 HospitalList(nolock),
                 hospital hos(nolock),
                 V_DivisionProductLineRelation dp 
           WHERE     DMA_ID = DCL_DMA_ID
                 AND dma_activeflag = '1'
                 --AND getdate () BETWEEN DCL_STARTDATE AND dcl_stopdate
                 AND dat_dcl_id = dcl_id
                 AND dat_pma_id = pct_id
                 AND dat_productline_bum_id = View_ProductLine.id
                 AND PCT_ParentClassification_PCT_ID is null
                 AND dat_id = hla_dat_id
                 AND hos_id = hla_hos_id
                 AND HOS_ActiveFlag='1'
                 AND dp.ProductLineID=dat_productline_bum_id
          UNION
          SELECT 
                 dma_chinesename,
                 DMA_EnglishName,
                 DMA_SAP_Code,
                 dp.DivisionCode as  DivisionID,
                 dp.DivisionName as Division,
                 dat_productline_bum_id,
                 attribute_name AS 'ProductLine',
                 DCL_STARTDATE,
                 dcl_stopdate,                
                 HOS_HospitalName,
                 HOS_HospitalShortName,
                 HOS_Province,                 
                 HOS_City,                
                 HOS_Key_Account,                
                 HOS_District,                
                 HOS_ActiveFlag  
            FROM dbo.DealerContract,
                 DEALERMASTER,
                 DealerAuthorizationTable,
                 dbo.View_ProductLine,
                 HospitalList,
                 hospital,
                 V_DivisionProductLineRelation dp 
           WHERE     DMA_ID = DCL_DMA_ID
                 AND dma_activeflag = '1'
                 --AND getdate () BETWEEN DCL_STARTDATE AND dcl_stopdate
                 AND dat_dcl_id = dcl_id
                 AND dat_pma_id = View_ProductLine.id
                 AND dat_id = hla_dat_id
                 AND hla_hos_id = hos_id
                 AND HOS_ActiveFlag='1'
                 AND dp.ProductLineID= dat_pma_id ) table1




GO


