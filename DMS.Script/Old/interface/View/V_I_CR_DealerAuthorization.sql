
DROP VIEW [interface].[V_I_CR_DealerAuthorization]
GO

CREATE VIEW [interface].[V_I_CR_DealerAuthorization]
AS
SELECT *
    FROM (SELECT 
                 dma_chinesename,
                 DMA_EnglishName,
                 DMA_SAP_Code,
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
                 dbo.PartsClassification,
                 View_ProductLine,
                 HospitalList,
                 hospital hos
           WHERE     DMA_ID = DCL_DMA_ID
                 AND dma_activeflag = '1'
                 AND getdate () BETWEEN DCL_STARTDATE AND dcl_stopdate
                 AND dat_dcl_id = dcl_id
                 AND dat_pma_id = pct_id
                 AND dat_productline_bum_id = View_ProductLine.id
                 AND dat_id = hla_dat_id
                 AND hos_id = hla_hos_id
          UNION
          SELECT 
                 dma_chinesename,
                 DMA_EnglishName,
                 DMA_SAP_Code,
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
                 hospital
           WHERE     DMA_ID = DCL_DMA_ID
                 AND dma_activeflag = '1'
                 AND getdate () BETWEEN DCL_STARTDATE AND dcl_stopdate
                 AND dat_dcl_id = dcl_id
                 AND dat_pma_id = View_ProductLine.id
                 AND dat_id = hla_dat_id
                 AND hla_hos_id = hos_id) table1
GO


