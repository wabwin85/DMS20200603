DROP Procedure [dbo].[GC_SYN_WeChat]
GO



/*
微信数据库同步
*/
CREATE Procedure [dbo].[GC_SYN_WeChat]
AS

SET NOCOUNT ON

--CFN
--Update Exists CFN 
UPDATE WECHAT.WECHAT.dbo.CFN SET 
	   CFN_EnglishName = C.CFN_EnglishName
      ,CFN_ChineseName = C.CFN_ChineseName
      ,CFN_Implant = C.CFN_Implant
      ,CFN_Tool = C.CFN_Tool
      ,CFN_Description = C.CFN_Description
      --,CFN_CustomerFaceNbr = C.CFN_CustomerFaceNbr
      ,CFN_ProductCatagory_PCT_ID = C.CFN_ProductCatagory_PCT_ID
      ,CFN_Property1 = C.CFN_Property1
      ,CFN_Property2 = C.CFN_Property2
      ,CFN_Property3 = C.CFN_Property3
      ,CFN_Property4 = C.CFN_Property4
      ,CFN_Property5 = C.CFN_Property5
      ,CFN_Property6 = C.CFN_Property6
      ,CFN_Property7 = C.CFN_Property7
      ,CFN_Property8 = C.CFN_Property8
      ,CFN_LastModifiedDate = C.CFN_LastModifiedDate
      ,CFN_DeletedFlag = C.CFN_DeletedFlag
      ,CFN_ProductLine_BUM_ID = C.CFN_ProductLine_BUM_ID
      ,CFN_LastModifiedBy_USR_UserID = C.CFN_LastModifiedBy_USR_UserID
      ,CFN_Share = C.CFN_Share
      ,CFN_Level1Code = C.CFN_Level1Code
      ,CFN_Level1Desc = C.CFN_Level1Desc
      ,CFN_Level2Code = C.CFN_Level2Code
      ,CFN_Level2Desc = C.CFN_Level2Desc
      ,CFN_Level3Code = C.CFN_Level3Code
      ,CFN_Level3Desc = C.CFN_Level3Desc
      ,CFN_Level4Code = C.CFN_Level4Code
      ,CFN_Level4Desc = C.CFN_Level4Desc
      ,CFN_Level5Code = C.CFN_Level5Code
      ,CFN_Level5Desc = C.CFN_Level5Desc
FROM CFN C 
WHERE CONVERT(NVARCHAR(8),C.CFN_LastModifiedDate,112) >= CONVERT(NVARCHAR(8),DATEADD(D,-1,GETDATE()),112)
AND C.CFN_ID = CFN.CFN_ID

--INSERT NOT Exists CFN 
INSERT INTO WECHAT.WECHAT.dbo.CFN
SELECT C.* FROM CFN C
WHERE CONVERT(NVARCHAR(8),C.CFN_LastModifiedDate,112) >= CONVERT(NVARCHAR(8),DATEADD(D,-1,GETDATE()),112)
AND NOT EXISTS (SELECT 1 FROM WECHAT.WECHAT.dbo.CFN W
WHERE W.CFN_ID = C.CFN_ID)

--Product
--Update Exists Product 
UPDATE WECHAT.WECHAT.dbo.Product SET 
	   PMA_UnitOfMeasure = P.PMA_UnitOfMeasure
	  --,PMA_UPN = P.PMA_UPN
      ,PMA_Name = P.PMA_Name
      ,PMA_LotTrack = P.PMA_LotTrack
      ,PMA_Version = P.PMA_Version
      ,PMA_DMA_ID = P.PMA_DMA_ID
      ,PMA_SAPUnitPrice = P.PMA_SAPUnitPrice
      ,PMA_Desc_Chinese = P.PMA_Desc_Chinese
      ,PMA_Desc_English = P.PMA_Desc_English
      ,PMA_ConvertFromPart_PMA_ID = P.PMA_ConvertFromPart_PMA_ID
      ,PMA_ConvertFactor = P.PMA_ConvertFactor
      ,PMA_LastModifiedDate = P.PMA_LastModifiedDate
      ,PMA_LastModifiedBy_USR_UserID = P.PMA_LastModifiedBy_USR_UserID
      ,PMA_DeletedFlag = P.PMA_DeletedFlag
      ,PMA_CFN_ID = P.PMA_CFN_ID
      ,PMA_PackageFactor = P.PMA_PackageFactor
FROM Product P 
WHERE CONVERT(NVARCHAR(8),P.PMA_LastModifiedDate,112) >= CONVERT(NVARCHAR(8),DATEADD(D,-1,GETDATE()),112)
AND P.PMA_ID = Product.PMA_ID

--INSERT NOT Exists Product
INSERT INTO WECHAT.WECHAT.dbo.Product
SELECT P.* FROM Product P
WHERE CONVERT(NVARCHAR(8),P.PMA_LastModifiedDate,112) >= CONVERT(NVARCHAR(8),DATEADD(D,-1,GETDATE()),112)
AND NOT EXISTS (SELECT 1 FROM WECHAT.WECHAT.dbo.Product W
WHERE W.PMA_ID = P.PMA_ID)

--LotMaster
INSERT INTO WECHAT.WECHAT.dbo.LotMaster
SELECT L.* FROM LotMaster L
WHERE CONVERT(NVARCHAR(8),L.LTM_CreatedDate,112) >= CONVERT(NVARCHAR(8),DATEADD(D,-1,GETDATE()),112)
AND NOT EXISTS (SELECT 1 FROM WECHAT.WECHAT.dbo.LotMaster W
WHERE W.LTM_ID = L.LTM_ID)

SET NOCOUNT OFF
SELECT ERROR_MESSAGE()

GO


