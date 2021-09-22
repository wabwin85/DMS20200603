DROP PROCEDURE [dbo].[GC_AutoUpdateMasterData_CFN_Test]
GO

Create PROCEDURE [dbo].[GC_AutoUpdateMasterData_CFN_Test]
   @RtnVal NVARCHAR (20) OUTPUT, @RtnMsg NVARCHAR (MAX) OUTPUT
AS
   DECLARE @SysUserId   UNIQUEIDENTIFIER
   DECLARE @CurrentDate datetime
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'
      SET @CurrentDate = GETDATE();

      /* BSC产品Level临时表*/
      CREATE TABLE #Tmp_Product_BSC_level
      (
         [UPN]          NVARCHAR (50) NOT NULL,
         [DESCRIPTIO]   NVARCHAR (70) NULL,
         [LEVEL1DESC]   NVARCHAR (55) NULL,
         [LEVEL1CODE]   NVARCHAR (50) NULL,
         [LEVEL2DESC]   NVARCHAR (50) NULL,
         [LEVEL2CODE]   NVARCHAR (50) NULL,
         [LEVEL3DESC]   NVARCHAR (50) NULL,
         [LVL3CODE]     NVARCHAR (50) NULL,
         [LVL4DESC]     NVARCHAR (50) NULL,
         [LEVEL4CODE]   NVARCHAR (50) NULL,
         [LVL5DESC]     NVARCHAR (50) NULL,
         [LVL5CODE]     NVARCHAR (50) NULL,
         [CreateDate]   NVARCHAR (10) NULL,
         PRIMARY KEY ([UPN])
      )

      /* CRM产品Level临时表*/
      CREATE TABLE #Tmp_Product_CRM_level
      (
         [UPN]          NVARCHAR (50) NOT NULL,
         [DESCRIPTIO]   NVARCHAR (70) NULL,
         [LEVEL1DESC]   NVARCHAR (50) NULL,
         [LEVEL1CODE]   NVARCHAR (50) NULL,
         [LEVEL2DESC]   NVARCHAR (50) NULL,
         [LEVEL2CODE]   NVARCHAR (50) NULL,
         [LEVEL3DESC]   NVARCHAR (50) NULL,
         [LVL3CODE]     NVARCHAR (50) NULL,
         [LVL4DESC]     NVARCHAR (55) NULL,
         [LEVEL4CODE]   NVARCHAR (50) NULL,
         [LVL5DESC]     NVARCHAR (55) NULL,
         [LVL5CODE]     NVARCHAR (50) NULL,
         [CreateDate]   NVARCHAR (10) NULL,
         PRIMARY KEY (UPN)
      )

      /* BSC产品主数据临时表*/
      CREATE TABLE #Tmp_Product_BSC_MDM
      (
         [Material]              NVARCHAR (50) NOT NULL,
         [MaterialDescription]   NVARCHAR (4000) NULL,
         [Sheets]                NVARCHAR (20) NULL,
         [MMPP]                  NVARCHAR (20) NULL,
         [SalesStatus]           NVARCHAR (20) NULL,
         [ProfitCenter]          NVARCHAR (20) NULL,
         [Grouping]              NVARCHAR (20) NULL,
         [ProdHierarchy]         NVARCHAR (50) NULL,
         [CreateDate]            NVARCHAR (10) NULL,
         PRIMARY KEY (Material)
      )

      /* CRM产品主数据临时表*/
      CREATE TABLE #Tmp_Product_CRM_MDM
      (
         [Material]              NVARCHAR (50) NOT NULL,
         [MaterialDescription]   NVARCHAR (MAX) NULL,
         [Sheets]                NVARCHAR (20) NULL,
         [MMPP]                  NVARCHAR (20) NULL,
         [SalesStatus]           NVARCHAR (20) NULL,
         [ProfitCenter]          NVARCHAR (20) NULL,
         [Grouping]              NVARCHAR (20) NULL,
         [ProdHierarchy]         NVARCHAR (50) NULL,
         [CreateDate]            NVARCHAR (10) NULL,
         PRIMARY KEY (Material)
      )

      /* 产品注册证信息主数据*/
      CREATE TABLE #Tmp_Product_tendering
      (
         [SAP Code]            NVARCHAR (50) NOT NULL,
         [SAP Code CRM]        NVARCHAR (100) NULL,
         [Reg Number]          NVARCHAR (55) NULL,
         [Prod Name Chinese]   NVARCHAR (69) NULL,
         [CreateDate]          NVARCHAR (10) NULL,
         PRIMARY KEY ([SAP Code])
      )


      CREATE TABLE #Tmp_Product_Merge
      (
         [Type]                NVARCHAR (55) NULL,
         [Code]                NVARCHAR (50) NOT NULL,
         [MMPP]                NVARCHAR (20) NULL,
         [SalesStatus]         NVARCHAR (20) NULL,
         [Sheets]              NVARCHAR (20) NULL,
         [CFDA]                NVARCHAR (55) NULL,
         [SAP_L6]              NVARCHAR (50) NOT NULL,
         [SAP_DESC]            NVARCHAR (MAX) NULL,
         [LEVEL1DESC]          NVARCHAR (55) NULL,
         [LEVEL1CODE]          NVARCHAR (50) NULL,
         [LEVEL2DESC]          NVARCHAR (50) NULL,
         [LEVEL2CODE]          NVARCHAR (50) NULL,
         [LEVEL3DESC]          NVARCHAR (50) NULL,
         [LVL3CODE]            NVARCHAR (50) NULL,
         [LVL4DESC]            NVARCHAR (55) NULL,
         [LEVEL4CODE]          NVARCHAR (50) NULL,
         [LVL5DESC]            NVARCHAR (55) NULL,
         [LVL5CODE]            NVARCHAR (50) NULL,
         [Prod Name Chinese]   NVARCHAR (69) NULL,
         [Grouping]            NVARCHAR (20) NULL,
         [CFN_Property8]       NVARCHAR (58) NULL,
         [CFN_Property7]       NVARCHAR (200) NULL,
         [CFN_Property5]       NVARCHAR (55) NULL,
         [CFN_Property4]       INT NOT NULL,
         [ProfitCenter]        NVARCHAR (20) NULL,
         [ProdHierarchy]       NVARCHAR (50) NULL,
         [CFN_Property2]       NVARCHAR (200) NULL,
         PRIMARY KEY ([SAP_L6])
      )



      --写入数据到临时表
      INSERT INTO #Tmp_Product_BSC_level
         SELECT t1.*
           FROM dbo.Tmp_Product_BSC_level t1,
                (SELECT UPN, max (createDate) AS CreateDate
                   FROM dbo.Tmp_Product_BSC_level
                 GROUP BY UPN) t2
          WHERE t1.UPN = t2.UPN AND t1.CreateDate = t2.CreateDate
          and t1.UPN='RBT_CRM'

      INSERT INTO #Tmp_Product_CRM_level
         SELECT t1.*
           FROM dbo.Tmp_Product_CRM_level t1,
                (SELECT UPN, max (createDate) AS CreateDate
                   FROM dbo.Tmp_Product_CRM_level
                 GROUP BY UPN) t2
          WHERE t1.UPN = t2.UPN AND t1.CreateDate = t2.CreateDate
          and t1.UPN='RBT_CRM'

      INSERT INTO #Tmp_Product_BSC_MDM
         SELECT t1.*
           FROM dbo.Tmp_Product_BSC_MDM t1,
                (SELECT Material, max (CreateDate) AS CreateDate
                   FROM dbo.Tmp_Product_BSC_MDM
                 GROUP BY Material) t2
          WHERE t1.Material = t2.Material AND t1.CreateDate = t2.CreateDate
          and t1.Material='RBT_CRM'

      INSERT INTO #Tmp_Product_CRM_MDM
         SELECT t1.*
           FROM dbo.Tmp_Product_CRM_MDM t1,
                (SELECT Material, max (CreateDate) AS CreateDate
                   FROM dbo.Tmp_Product_CRM_MDM
                 GROUP BY Material) t2
          WHERE t1.Material = t2.Material AND t1.CreateDate = t2.CreateDate
          and t1.Material='RBT_CRM'

      INSERT INTO #Tmp_Product_tendering
         SELECT t1.[SAP Code],
                max (isnull(t1.[SAP Code CRM],'')) AS [SAP Code CRM],
                max (isnull(t1.[Reg Number],'')) AS [Reg Number],
                max (isnull(t1.[Prod Name Chinese],'')) AS [Prod Name Chinese],
                t1.CreateDate
           FROM dbo.Tmp_Product_tendering t1,
                (SELECT [SAP Code], max (CreateDate) AS CreateDate
                   FROM Tmp_Product_tendering
                 GROUP BY [SAP Code]) t2
          WHERE     t1.[SAP Code] = t2.[SAP Code]
                AND t1.CreateDate = t2.CreateDate
                and t1.[SAP Code]='RBT_CRM'
         GROUP BY t1.[SAP Code], t1.CreateDate



      --写入数据到Merger临时表
      INSERT INTO #Tmp_Product_Merge
         SELECT DISTINCT
                Type,
                rtrim (ltrim (Code)) AS Code,
                MMPP,
                [SalesStatus],
                Sheets,
                CFDA,
                SAP_L6,
                SAP_DESC,
                LEVEL1DESC,
                LEVEL1CODE,
                LEVEL2DESC,
                LEVEL2CODE,
                LEVEL3DESC,
                LVL3CODE,
                LVL4DESC,
                LEVEL4CODE,
                LVL5DESC,
                LVL5CODE,
                [Prod Name Chinese],
                [Grouping],
                (SELECT PGM.[DMS 提示信息]
                   FROM Tmp_Product_GrpMsg AS PGM
                  WHERE     PGM.[产品线] = TAB.[产品线]
                        AND PGM.[CFDA NAME] = TAB.CFDA_Name
                        AND PGM.MMPP = TAB.MMPP
                        AND PGM.Dchain = TAB.[SalesStatus])
                   AS CFN_Property8,
                [SAP Code CRM] AS CFN_Property7,
                CFDA AS CFN_Property5,
                TAB.Status AS CFN_Property4,
                ProfitCenter,
                '' AS ProdHierarchy,
                0 AS CFN_Property2
           FROM (SELECT CASE
                           WHEN P.Type = 'CRM' THEN P.Type
                           ELSE P.LEVEL1DESC
                        END
                           AS Type,
                        CASE
                           WHEN P.Type = 'CRM' and SUBSTRING(P.[Material],1,1)='6' THEN P.LVL5CODE
                           ELSE P.[Material]
                        END
                           AS Code,
                        P.MMPP,
                        P.[SalesStatus],
                        P.Sheets,
                        isnull (t.[Reg Number], 'NULL') AS CFDA,
                        t.[SAP Code] AS SAP_L6,
                        P.[MaterialDescription] AS SAP_DESC,
                        P.LEVEL1DESC,
                        P.LEVEL1CODE,
                        P.LEVEL2DESC,
                        P.LEVEL2CODE,
                        P.LEVEL3DESC,
                        P.LVL3CODE,
                        P.LVL4DESC,
                        P.LEVEL4CODE,
                        P.LVL5DESC,
                        P.LVL5CODE,
                        t.[Prod Name Chinese],
                        P.[Grouping],
                        P.[ProfitCenter],
                        CASE WHEN P.Type = 'CRM' THEN P.Type ELSE 'BSC' END
                           AS '产品线',
                        CASE
                           WHEN t.[Reg Number] IS NULL THEN '空白'
                           ELSE '有信息'
                        END
                           AS 'CFDA_Name',
                        P.Status,
                        t.[SAP Code CRM]
                   FROM #Tmp_product_tendering AS t,
                        (SELECT BM.Material,
                                MaterialDescription,
                                Sheets,
                                BM.MMPP,
                                BM.SalesStatus,
                                ProfitCenter,
                                BM.Grouping,
                                BL.*,
                                'BSC' AS Type,
                                PS.Status
                           FROM #tmp_product_BSC_MDM AS BM,
                                #tmp_product_BSC_level AS BL,
                                Tmp_Product_GrpMsg AS PS
                          WHERE     rtrim (BL.UPN) = rtrim (BM.Material)
                                AND BM.MMPP = CONVERT (NVARCHAR (5), PS.MMPP)
                                AND BM.SalesStatus =
                                       CONVERT (NVARCHAR (5), PS.Dchain)
                                AND PS.[产品线] = 'BSC'
                                AND BM.MMPP IS NOT NULL
                                AND BM.SalesStatus IS NOT NULL
                                AND Convert(nvarchar(10),BM.MMPP) + '-' + Convert(nvarchar(10),BM.SalesStatus) in (select Convert(nvarchar(10),MMPP) + '-' + Convert(nvarchar(10),Dchain) from Tmp_Product_GrpMsg where [产品线]='BSC' )
                         UNION ALL
                         SELECT CM.Material,
                                MaterialDescription,
                                Sheets,
                                CM.MMPP,
                                CM.SalesStatus,
                                ProfitCenter,
                                CM.Grouping,
                                CL.*,
                                'CRM' AS Type,
                                PS.Status
                           FROM #tmp_product_CRM_MDM AS CM,
                                #Tmp_product_CRM_level AS CL,
                                Tmp_Product_GrpMsg AS PS
                          WHERE     rtrim (CL.UPN) = rtrim (CM.Material)
                                AND CM.MMPP = CONVERT (NVARCHAR (5), PS.MMPP)
                                AND CM.SalesStatus =
                                       CONVERT (NVARCHAR (5), PS.Dchain)
                                AND PS.[产品线] = 'CRM'
                                AND CM.MMPP IS NOT NULL
                                AND CM.SalesStatus IS NOT NULL
                                AND Convert(nvarchar(10),CM.MMPP) + '-' + Convert(nvarchar(10),CM.SalesStatus) in (select Convert(nvarchar(10),MMPP) + '-' + Convert(nvarchar(10),Dchain) from Tmp_Product_GrpMsg where [产品线]='CRM' )
                                ) AS P
                  WHERE P.Material = T.[SAP Code] AND MMPP <> '99') AS TAB
          WHERE     type IN ('TAVR-Str Heart VL',
                             'LAAC-Str Heart NV',
                             'CRM',
                             'Interventional Cardiology',
                             'Endoscopy',
                             'PERI INT/VASC SURG',
                             'Urology/Gynecology',
                             'Electrophysiology',
                             'Oncology',
                             'Peripheral Embolization')
                --AND [SalesStatus] IN ('0','1','3', '6','7','8','10')
                AND rtrim (ltrim (Code))<>'NULL'

      --根据Profit Center更新产品类型
      UPDATE #Tmp_Product_Merge
         SET [Type] = 'PERI INT/VASC SURG'
       WHERE [Type] = 'Oncology' AND ProfitCenter = '35000'

      UPDATE #Tmp_Product_Merge
         SET [Type] = 'Structured Heart'
       WHERE [Type] = 'LAAC-Str Heart NV' AND ProfitCenter = '60000'

      UPDATE #Tmp_Product_Merge
         SET [Type] = 'Structured Heart'
       WHERE [Type] = 'TAVR-Str Heart VL' AND ProfitCenter = '65000'
      
      --更新MMPP=88,SalesStatus=6的数据
      update #Tmp_Product_Merge set CFN_Property2=1 where MMPP=88 and SalesStatus=6
      
      --更新产品信息
      UPDATE t2
         SET t2.CFN_ChineseName = [Prod Name Chinese],
             t2.CFN_EnglishName = t1.SAP_DESC,
             t2.CFN_Description = t1.SAP_DESC,
             t2.CFN_Level1Desc = t1.LEVEL1DESC,
             t2.CFN_Level1Code = t1.LEVEL1CODE,
             t2.CFN_Level2Desc = t1.LEVEL2DESC,
             t2.CFN_Level2Code = t1.LEVEL2CODE,
             t2.CFN_Level3Desc = t1.LEVEL3DESC,
             t2.CFN_Level3Code = t1.LVL3CODE,
             t2.CFN_Level4Desc = t1.LVL4DESC,
             t2.CFN_Level4Code = t1.LEVEL4CODE,
             t2.CFN_Level5Desc = t1.LVL5DESC,
             t2.CFN_Level5Code = t1.LVL5CODE,
             t2.CFN_Property8 = t1.CFN_Property8,
             t2.CFN_Property7 = t1.CFN_Property7,
             t2.CFN_Property5 = isnull (t1.CFN_Property5, ''),
             t2.CFN_Property4 = t1.CFN_Property4,
             t2.CFN_Property2 = t1.CFN_Property2
        FROM (SELECT DISTINCT * FROM #tmp_product_merge) t1, cfn t2
       WHERE t1.SAP_L6 = t2.CFN_CustomerFaceNbr

      --更新接口表
     
      update TCFN 
      SET UPN_ChineseName=SCFN.[Prod Name Chinese],
          UPN_EnglishName = SCFN.MaterialDescription,
          Level5Code= SCFN.LVL5CODE,
          Level5Desc= SCFN.LVL5DESC,
          Level4Code= SCFN.LEVEL4CODE,
          Level4Desc= SCFN.LVL4DESC,
          Level3Code= SCFN.LVL3CODE,
          Level3Desc= SCFN.LEVEL3DESC,
          Level2Code= SCFN.LEVEL2CODE,
          Level2Desc= SCFN.LEVEL2DESC,
          Level1Code= SCFN.LEVEL1CODE,
          Level1Desc= SCFN.LEVEL1DESC,
          ProductLine_ID= SCFN.ProductLineID,
          DivisionID= SCFN.DivisionID,
          Division= SCFN.Division,
          UPN_Description= SCFN.MaterialDescription,
          SFDA= SCFN.[Reg Number],
          Sheet= SCFN.Sheets,
          ST= 1,
          MMPP= SCFN.MMPP,
          DChain= SCFN.SalesStatus,
          UOM= '盒'
      from interface.T_I_QV_CFN AS TCFN,(      
        select MDM.*,Tend.[Reg Number],Tend.[Prod Name Chinese],PC.Division,PC.DivisionID,PC.ProductLineID,PC.ProductLineName
        from (
          select t1.Material, t1.MaterialDescription, t1.Sheets, t1.MMPP, t1.SalesStatus, t1.ProfitCenter, t1.[Grouping], t1.ProdHierarchy,t2.UPN, t2.DESCRIPTIO, t2.LEVEL1DESC, t2.LEVEL1CODE, t2.LEVEL2DESC, t2.LEVEL2CODE, t2.LEVEL3DESC, t2.LVL3CODE, t2.LVL4DESC, t2.LEVEL4CODE, t2.LVL5DESC, t2.LVL5CODE 
          from #Tmp_Product_BSC_MDM t1, #Tmp_Product_BSC_level t2
          where t1.Material=t2.UPN and (t1.ProfitCenter >=60000 OR t1.ProfitCenter <50000) 
          union
          select t1.Material, t1.MaterialDescription, t1.Sheets, t1.MMPP, t1.SalesStatus, t1.ProfitCenter, t1.[Grouping], t1.ProdHierarchy,t2.UPN, t2.DESCRIPTIO, t2.LEVEL1DESC, t2.LEVEL1CODE, t2.LEVEL2DESC, t2.LEVEL2CODE, t2.LEVEL3DESC, t2.LVL3CODE, t2.LVL4DESC, t2.LEVEL4CODE, t2.LVL5DESC, t2.LVL5CODE
          from #Tmp_Product_CRM_MDM t1, #Tmp_Product_CRM_level t2
          where t1.Material=t2.UPN and (t1.ProfitCenter <60000 OR t1.ProfitCenter >=50000) 
        ) AS MDM left join #Tmp_Product_tendering AS Tend on (MDM.Material = Tend.[SAP Code])
                 left join (select distinct Level1Code, Division, DivisionID, ProductLineName, ProductLineID from Tmp_Product_ProfitCenter) AS PC on (MDM.LEVEL1CODE = PC.Level1Code)
    
      ) AS SCFN
      where TCFN.UPN=SCFN.UPN
      
      --添加新产品到中间表
      insert into interface.T_I_QV_CFN
      select
       SCFN.UPN,
       SCFN.[Prod Name Chinese],
       SCFN.MaterialDescription,
       SCFN.LVL5CODE,
        SCFN.LVL5DESC,
        SCFN.LEVEL4CODE,
         SCFN.LVL4DESC,
        SCFN.LVL3CODE,
       SCFN.LEVEL3DESC,
       SCFN.LEVEL2CODE,
       SCFN.LEVEL2DESC,
      SCFN.LEVEL1CODE,
       SCFN.LEVEL1DESC,
       SCFN.ProductLineID,
       SCFN.DivisionID,
       SCFN.Division,
       SCFN.MaterialDescription,
       SCFN.[Reg Number],
       SCFN.Sheets,
       1,
       SCFN.MMPP,
       SCFN.SalesStatus,
       '盒'     
      from (      
        select MDM.*,Tend.[Reg Number],Tend.[Prod Name Chinese],PC.Division,PC.DivisionID,PC.ProductLineID,PC.ProductLineName
        from (
          select t1.Material, t1.MaterialDescription, t1.Sheets, t1.MMPP, t1.SalesStatus, t1.ProfitCenter, t1.[Grouping], t1.ProdHierarchy,t2.UPN, t2.DESCRIPTIO, t2.LEVEL1DESC, t2.LEVEL1CODE, t2.LEVEL2DESC, t2.LEVEL2CODE, t2.LEVEL3DESC, t2.LVL3CODE, t2.LVL4DESC, t2.LEVEL4CODE, t2.LVL5DESC, t2.LVL5CODE 
          from #Tmp_Product_BSC_MDM t1, #Tmp_Product_BSC_level t2
          where t1.Material=t2.UPN and (t1.ProfitCenter >=60000 OR t1.ProfitCenter <50000) 
          union
          select t1.Material, t1.MaterialDescription, t1.Sheets, t1.MMPP, t1.SalesStatus, t1.ProfitCenter, t1.[Grouping], t1.ProdHierarchy,t2.UPN, t2.DESCRIPTIO, t2.LEVEL1DESC, t2.LEVEL1CODE, t2.LEVEL2DESC, t2.LEVEL2CODE, t2.LEVEL3DESC, t2.LVL3CODE, t2.LVL4DESC, t2.LEVEL4CODE, t2.LVL5DESC, t2.LVL5CODE
          from #Tmp_Product_CRM_MDM t1, #Tmp_Product_CRM_level t2
          where t1.Material=t2.UPN and (t1.ProfitCenter <60000 OR t1.ProfitCenter >=50000) 
        ) AS MDM left join #Tmp_Product_tendering AS Tend on (MDM.Material = Tend.[SAP Code])
                 left join (select distinct Level1Code, Division, DivisionID, ProductLineName, ProductLineID from Tmp_Product_ProfitCenter) AS PC on (MDM.LEVEL1CODE = PC.Level1Code)
        ) AS SCFN where UPN not in (select UPN from interface.T_I_QV_CFN)
      
      --Asthma产品更新
      update interface.T_I_QV_CFN set DivisionID=34, Division='AS', ProductLine_ID='5d0327f2-c360-442f-9961-a3100116f8c3' where Level2Code='236'     
      
      --添加新产品
      INSERT INTO CFN (CFN_ID,
                       CFN_EnglishName,
                       CFN_ChineseName,
                       CFN_Description,
                       CFN_CustomerFaceNbr,
                       CFN_ProductCatagory_PCT_ID,
                       CFN_LastModifiedDate,
                       CFN_DeletedFlag,
                       CFN_ProductLine_BUM_ID,
                       CFN_LastModifiedBy_USR_UserID,
                       CFN_Level1Code,
                       CFN_Level1Desc,
                       CFN_Level2Code,
                       CFN_Level2Desc,
                       CFN_Level3Code,
                       CFN_Level3Desc,
                       CFN_Level4Code,
                       CFN_Level4Desc,
                       CFN_Level5Code,
                       CFN_Level5Desc,
                       CFN_Property8,
                       CFN_Property7,
                       CFN_Property5,
                       CFN_Property4,
                       CFN_Property1,
                       CFN_Property3)
         SELECT newid (),
                SAP_DESC,
                [Prod Name Chinese],
                SAP_DESC,
                SAP_L6,
                '00000000-0000-0000-0000-000000000000',--PartsClassification.PCT_ID,
                GETDATE (),
                0,
                tab2.Id,--PartsClassification.PCT_ProductLine_BUM_ID,
                '00000000-0000-0000-0000-000000000000',
                LEVEL1CODE,
                LEVEL1DESC,
                LEVEL2CODE,
                LEVEL2DESC,
                LVL3CODE,
                LEVEL3DESC,
                LEVEL4CODE,
                LVL4DESC,
                LVL5CODE,
                LVL5DESC,
                CFN_Property8,
                CFN_Property7,
                CFN_Property5,
                CFN_Property4,
                Code,
                '盒'
           FROM (SELECT DISTINCT * FROM #Tmp_Product_Merge) tab1
                INNER JOIN 
                (select id, [DESCRIPTION] from Lafite_ATTRIBUTE where ATTRIBUTE_TYPE='Product_Line') tab2 on (tab1.[Type] = tab2.[DESCRIPTION] )
                --PartsClassification ON PCT_EnglishName = TYPE
          WHERE NOT EXISTS
                   (SELECT 1
                      FROM CFN
                     WHERE CFN.CFN_CustomerFaceNbr = tab1.SAP_L6)



      --插入不存在的产品
      INSERT INTO Product (PMA_ID,
                           PMA_UPN,
                           PMA_UnitOfMeasure,
                           PMA_ConvertFactor,
                           PMA_LastModifiedDate,
                           PMA_LastModifiedBy_USR_UserID,
                           PMA_DeletedFlag,
                           PMA_CFN_ID)
         SELECT newid (),
                cfn.CFN_CustomerFaceNbr,
                '盒',
                1,
                getdate (),
                '00000000-0000-0000-0000-000000000000',
                0,
                cfn.cfn_id
           FROM cfn
          WHERE NOT EXISTS
                   (SELECT 1
                      FROM product
                     WHERE PMA_CFN_ID = cfn.cfn_id)

      --更新产品信息
      UPDATE Product
         SET PMA_ConvertFactor = sheets
        FROM (SELECT DISTINCT * FROM #Tmp_Product_Merge) tab1
       WHERE tab1.SAP_L6 = PMA_UPN

      --更新产品线信息


      --更新产品单位
      UPDATE cfn
         SET CFN_Property3 = '盒'

      UPDATE cfn
         SET CFN_Property6 = 1
       WHERE CFN_ProductLine_BUM_ID = '97a4e135-74c7-4802-af23-9d6d00fcb2cc'

      UPDATE cfn
         SET CFN_Property6 = 0
       WHERE CFN_ProductLine_BUM_ID <> '97a4e135-74c7-4802-af23-9d6d00fcb2cc'

      --更新CRM短编号
      UPDATE cfn
         SET CFN_Property1 = CASE when SUBSTRING(CFN_CustomerFaceNbr,1,1)='6' then CFN_Level5Code else CFN_CustomerFaceNbr end
       WHERE CFN_ProductLine_BUM_ID = '97a4e135-74c7-4802-af23-9d6d00fcb2cc'

      --更新Asthma产品
      --update cfn set CFN_ProductCatagory_PCT_ID='b09f368d-5559-4d11-962e-a316016b6d7d', CFN_ProductLine_BUM_ID='5d0327f2-c360-442f-9961-a3100116f8c3' where CFN_Level2Code='236'     
      
      
      
      --更新价格
      
      --更新价格
      declare @ShortUPN nvarchar(200);
	declare @UPN uniqueidentifier;
	
	declare cur CURSOR	
	for select CFN_ID,CFN_Property1 from CFN where CFN_Property6 =1 and convert(nvarchar(10),CFN_LastModifiedDate,112) = convert(nvarchar(10),@CurrentDate,112)
	OPEN cur
		FETCH NEXT FROM cur INTO @UPN,@ShortUPN

		WHILE @@FETCH_STATUS = 0
		BEGIN
			--根据CFN_ID更新T1和LP的价格
			--UPDATE CP
			--SET CP.CFNP_Price = Price,CFNP_Market_Price = Price
			----select * 
			--from CFNPrice CP,DealerMaster DM,
			--(SELECT CustomerSapCode,MAX(NewPrice) as Price,MAX(CreateDate) as CreateDate
			--	from INTERFACE.T_I_EW_DistributorPrice
			--	where UPN = @ShortUPN
			--	AND [Type] = 2
			--	group by CustomerSapCode) IT
			--where CP.CFNP_Group_ID = DM.DMA_ID
			--AND DM.DMA_SAP_Code = IT.CustomerSapCode
			--AND DM.DMA_DealerType IN ('T1','LP')
			--AND CP.CFNP_CFN_ID = @UPN
			
			INSERT INTO CFNPrice
			SELECT NEWID(),@UPN,PriceType,DMA_ID,1,Price,Price,'CNY','盒',null,ValidFrom,ValidTo,'00000000-0000-0000-0000-000000000000',GETDATE(),null,null,0
			from DealerMaster DM,
			(SELECT distinct CustomerSapCode,ValidFrom,ValidTo,MAX(NewPrice) as Price,MAX(CreateDate) as CreateDate
				from INTERFACE.T_I_EW_DistributorPrice t1
				where UPN = @ShortUPN
				AND ([Type] = 2 or SubtType in (112,122))
				and InstancdId = (select MAX(InstancdId) from  INTERFACE.T_I_EW_DistributorPrice t2 where t1.CustomerSapCode = t2.CustomerSapCode and t1.UPN=t2.UPN and (t2.[Type]=2 or t2.SubtType in (112,122)))
				group by CustomerSapCode,ValidFrom,ValidTo) IT,
			(select 'Dealer' as PriceType union select 'DealerConsignment') as PType
			where DM.DMA_SAP_Code = IT.CustomerSapCode
			AND DM.DMA_DealerType IN ('T1','LP')
			AND not exists (select 1 from CFNPrice where CFNP_Group_ID = DMA_ID and CFNP_CFN_ID = @UPN and CFNP_PriceType = PriceType)
			
			
		FETCH NEXT FROM cur INTO @UPN,@ShortUPN
		END

		CLOSE cur
		DEALLOCATE cur
		
		--更新产品Property7
		update CFN
		set CFN_Property7='NOGTIN'
		 WHERE CFN_Property7='0' or CFN_Property7 is null or CFN_Property7=''
      
      
        update cfn set CFN_Property4=-1,CFN_Property8='参数设置不在同步逻辑内, 请复核' where CFN_CustomerFaceNbr not in (
		  select SAP_L6 from #Tmp_Product_Merge 
		)
        
        update cfn set CFN_Property4=-1,CFN_Property8='前后状态不一致, 暂不同步' where CFN_CustomerFaceNbr in (	
		select UPN from interface.T_I_QV_CFN where MMPP='99' and DChain= '8'
	    )
      
      --保存merge临时表
      INSERT INTO dbo.Tmp_Product_Merge
         SELECT t1.*, CONVERT (NVARCHAR (20), getdate (), 20)
           FROM #Tmp_Product_Merge t1
      
      --保持CFN表与interface.T_I_QV_CFN表的一致
      update t2 set t2.DivisionID = t1.DivisionID,t2.Division=t3.DivisionName,
              t2.Level1Code = t1.Level1code,t2.Level1Desc=t1.Level1,
              t2.Level2Code = t1.Level2code,t2.Level2Desc = t1.Level2,
              t2.Level3Code = t1.Level3code,t2.Level3Desc = t1.Level3,
              t2.Level4Code = t1.Level4code,t2.Level4Desc = t1.Level4,
              t2.Level5Code = t1.Level5code,t2.Level5Desc = t1.Level5              
		 from interface.V_I_EW_Product t1,interface.T_I_QV_CFN t2, (select distinct DivisionCode,DivisionName from V_DivisionProductLineRelation) t3
		where t1.UPN = t2.UPN and t1.DivisionID = t3.DivisionCode
		and (t1.DivisionID <> t2.DivisionID OR t1.Level1code<>t2.Level1Code or t1.Level2code<>t2.Level2Code or t1.Level3code<>t2.Level3Code or t1.Level4code<>t2.Level4Code
		or t1.Level5code<>t2.Level5Code)
      
      COMMIT TRAN

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @RtnVal = 'Failure'

      --记录错误日志开始
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError =
               '行'
             + CONVERT (NVARCHAR (10), @error_line)
             + '出错[错误号'
             + CONVERT (NVARCHAR (10), @error_number)
             + '],'
             + @error_message
      SET @RtnMsg = @vError
      RETURN -1
   END CATCH
GO


