DROP PROCEDURE [dbo].[Proc_SampleApply_CheckUPN]
GO

CREATE PROCEDURE [dbo].[Proc_SampleApply_CheckUPN]
	@HeaderId UNIQUEIDENTIFIER
AS
BEGIN

SELECT DISTINCT B.UpnNo 
INTO #TMP_UPN
FROM SampleApplyHead A, SampleUpn B
WHERE A.SampleApplyHeadId = B.SampleHeadId
AND A.SampleApplyHeadId = @HeaderId
AND NOT EXISTS (SELECT 1 FROM CFN C WHERE C.CFN_CustomerFaceNbr = B.UpnNo)

SELECT *,CONVERT(FLOAT,NULL) AS Sheet,CONVERT(NVARCHAR(200),NULL) AS UOM INTO #CFN FROM CFN WHERE 1=2
SELECT * INTO #Product FROM Product WHERE 1=2

INSERT INTO #CFN (CFN_ID,CFN_CustomerFaceNbr,CFN_Property1,CFN_ChineseName,CFN_EnglishName,CFN_Level5Code,CFN_Level5Desc,
CFN_Level4Code,CFN_Level4Desc,CFN_Level3Code,CFN_Level3Desc,CFN_Level2Code,CFN_Level2Desc,
CFN_Level1Code,CFN_Level1Desc,CFN_ProductLine_BUM_ID,CFN_Property5,CFN_Property2,CFN_Property3,CFN_Property4,
CFN_Property6,CFN_Property7,CFN_Property8,CFN_DeletedFlag,CFN_Implant,CFN_Tool,CFN_Share,CFN_ProductCatagory_PCT_ID,
Sheet,UOM)
SELECT NEWID(),UPN,UPN,UPN_ChineseName,UPN_EnglishName,Level5Code,Level5Desc,Level4Code,Level4Desc, 
Level3Code,Level3Desc,Level2Code,Level2Desc,Level1Code,Level1Desc,'00000000-0000-0000-0000-000000000000',SFDA,
0,'ºÐ',-1,0,'NoGTIN','ÐÂ×¢²á',0,0,NULL,NULL,'00000000-0000-0000-0000-000000000000',
Sheet,UOM
FROM interface.T_I_QV_CFN
WHERE UPN IN (SELECT UpnNo FROM #TMP_UPN)

INSERT INTO #CFN (CFN_ID,CFN_CustomerFaceNbr,CFN_Property1,CFN_ChineseName,CFN_EnglishName,CFN_Level5Code,CFN_Level5Desc,
CFN_Level4Code,CFN_Level4Desc,CFN_Level3Code,CFN_Level3Desc,CFN_Level2Code,CFN_Level2Desc,
CFN_Level1Code,CFN_Level1Desc,CFN_ProductLine_BUM_ID,CFN_Property5,CFN_Property2,CFN_Property3,CFN_Property4,
CFN_Property6,CFN_Property7,CFN_Property8,CFN_DeletedFlag,CFN_Implant,CFN_Tool,CFN_Share,CFN_ProductCatagory_PCT_ID,
Sheet,UOM)
SELECT NEWID(),A.UpnNo,A.UpnNo,A.UpnNo,A.UpnNo,NULL,NULL,NULL,NULL, 
NULL,NULL,NULL,NULL,NULL,NULL,'00000000-0000-0000-0000-000000000000',NULL,
0,'ºÐ',-1,0,'NoGTIN','ÐÂ×¢²á',0,0,NULL,NULL,'00000000-0000-0000-0000-000000000000',
1,'ºÐ'
FROM #TMP_UPN A
WHERE NOT EXISTS (SELECT 1 FROM #CFN B WHERE B.CFN_CustomerFaceNbr = A.UpnNo)

INSERT INTO #Product (PMA_ID,PMA_UPN,PMA_ConvertFactor,PMA_UnitOfMeasure,PMA_DeletedFlag,PMA_CFN_ID)
SELECT NEWID(),CFN_CustomerFaceNbr,Sheet,UOM,0,CFN_ID FROM #CFN

INSERT INTO CFN (CFN_ID,CFN_CustomerFaceNbr,CFN_Property1,CFN_ChineseName,CFN_EnglishName,CFN_Level5Code,CFN_Level5Desc,
CFN_Level4Code,CFN_Level4Desc,CFN_Level3Code,CFN_Level3Desc,CFN_Level2Code,CFN_Level2Desc,
CFN_Level1Code,CFN_Level1Desc,CFN_ProductLine_BUM_ID,CFN_Property5,CFN_Property2,CFN_Property3,CFN_Property4,
CFN_Property6,CFN_Property7,CFN_Property8,CFN_DeletedFlag,CFN_Implant,CFN_Tool,CFN_Share,CFN_ProductCatagory_PCT_ID)
SELECT CFN_ID,CFN_CustomerFaceNbr,CFN_Property1,CFN_ChineseName,CFN_EnglishName,CFN_Level5Code,CFN_Level5Desc,
CFN_Level4Code,CFN_Level4Desc,CFN_Level3Code,CFN_Level3Desc,CFN_Level2Code,CFN_Level2Desc,
CFN_Level1Code,CFN_Level1Desc,CFN_ProductLine_BUM_ID,CFN_Property5,CFN_Property2,CFN_Property3,CFN_Property4,
CFN_Property6,CFN_Property7,CFN_Property8,CFN_DeletedFlag,CFN_Implant,CFN_Tool,CFN_Share,CFN_ProductCatagory_PCT_ID
FROM #CFN

INSERT INTO Product (PMA_ID,PMA_UPN,PMA_ConvertFactor,PMA_UnitOfMeasure,PMA_DeletedFlag,PMA_CFN_ID)
SELECT PMA_ID,PMA_UPN,PMA_ConvertFactor,PMA_UnitOfMeasure,PMA_DeletedFlag,PMA_CFN_ID FROM #Product

END
GO


