ALTER TABLE Promotion.PRO_POLICY ADD IsTemplate BIT
ALTER TABLE Promotion.PRO_POLICY_UI ADD IsTemplate BIT
ALTER TABLE Promotion.PRO_POLICY ADD PolicyMode NVARCHAR(100)
ALTER TABLE Promotion.PRO_POLICY_UI ADD PolicyMode NVARCHAR(100)
ALTER TABLE Promotion.PRO_POLICY ADD SoucePolicy INT
GO

UPDATE Promotion.PRO_POLICY SET IsTemplate = 0, PolicyMode = 'Advance';
UPDATE Promotion.PRO_POLICY_UI SET IsTemplate = 0, PolicyMode = 'Advance';

INSERT INTO Promotion.PRO_Description VALUES ('PolicyGeneral', 'TemplateName', '', '模板名称')
INSERT INTO Promotion.PRO_Description VALUES ('PolicyGeneral', 'PolicyDesc', '', '模板介绍')

DECLARE @ParentId INT
DECLARE @ResourceId UNIQUEIDENTIFIER;
DECLARE @StrategyId UNIQUEIDENTIFIER;
DECLARE @RoleId UNIQUEIDENTIFIER;

SELECT @ParentId = MenuId
FROM   Lafite_SiteMap
WHERE  MenuTitle = '促销管理'
       AND ResourceKey = 'KendoSite'

INSERT INTO Lafite_SiteMap
VALUES
  ('Menu', 2, '促销政策模板维护', @ParentId, 0, 'PagesKendo/Promotion/PolicyTemplateList.aspx', NULL, 1, NULL, 
  'KendoSite', 'M2_PromotionPolicyTemplate_New', NULL, 1, 'Administrator', GETDATE())
INSERT INTO Lafite_FUNCTION
VALUES
  (NEWID(), 'M2_PromotionPolicyTemplate_New', 'M2-促销政策模板维护（kendo）', 'Promotion', 15, '', 'Menu', 1, NULL, NULL, NULL, 
  '4028931b0f0fc135010f0fc1356a0001', NULL, 0, 'Administrator', GETDATE(), 'Administrator', GETDATE())
INSERT INTO Lafite_STRATEGY
VALUES
  (NEWID(), '', '', '促销政策模板维护', 1, '促销政策模板维护', NULL, NULL, NULL, '4028931b0f0fc135010f0fc1356a0001', 0, 0, 
  'Administrator', GETDATE(), 'Administrator', GETDATE())

SELECT @ResourceId = Id
FROM   Lafite_FUNCTION
WHERE  FUNCTION_CODE = 'M2_PromotionPolicyTemplate_New';
SELECT @StrategyId = Id
FROM   Lafite_STRATEGY
WHERE  STRATEGY_NAME = '促销政策模板维护'

INSERT INTO Lafite_STRATEGY_MAP
VALUES
  (NEWID(), @StrategyId, 'Function', @ResourceId, 15, '4028931b0f0fc135010f0fc1356a0001', NULL, NULL, 0, 'Administrator', GETDATE(), 'Administrator', GETDATE())
INSERT INTO Lafite_ATTRIBUTE
VALUES
  (NEWID(), '促销政策模板维护', 'Role', 1, '促销政策模板维护', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
  '4028931b0f0fc135010f0fc1356a0001', 0, 0, 'Administrator', GETDATE(), 'Administrator', GETDATE())

SELECT @RoleId = Id
FROM   Lafite_ATTRIBUTE
WHERE  ATTRIBUTE_TYPE = 'Role'
       AND ATTRIBUTE_NAME = '促销政策模板维护'

INSERT INTO Lafite_ATTRIBUTE_MAP
SELECT NEWID(),
       @RoleId,
       MAP_TYPE,
       MAP_ID,
       APP_ID,
       BOOLEAN_FLAG,
       SORT_COL,
       DELETE_FLAG,
       CREATE_USER,
       CREATE_DATE,
       LAST_UPDATE_USER,
       LAST_UPDATE_DATE
FROM   Lafite_ATTRIBUTE_MAP
WHERE  ATTRIBUTE_ID = (
           SELECT Id
           FROM   Lafite_ATTRIBUTE
           WHERE  ATTRIBUTE_TYPE = 'Role'
                  AND ATTRIBUTE_NAME = '促销政策维护'
       )
       AND map_id NOT IN (SELECT Id
                          FROM   Lafite_STRATEGY
                          WHERE  STRATEGY_NAME = '促销政策维护')

INSERT INTO Lafite_ATTRIBUTE_MAP
VALUES
  (NEWID(), @RoleId, 'Strategy', @StrategyId, '4028931b0f0fc135010f0fc1356a0001', NULL, 0, 0, 'Administrator', GETDATE(), 'Administrator', GETDATE())

--添加用户角色


--[Promotion].[Proc_Interface_PolicyTempLoad]
--[Promotion].[Proc_Interface_PolicySave]
--[Promotion].[Proc_Interface_PolicyTempCopy]
--[Promotion].[func_Interface_Policy_List]
--[Promotion].[func_Pro_PolicyToHtml_Appendix1]
--[Promotion].[func_Pro_PolicyToHtml_Appendix2]
--[Promotion].[func_Pro_PolicyToHtml_Appendix3]
--[Promotion].[func_Pro_PolicyToHtml_Appendix4]
--[Promotion].[func_Pro_PolicyToHtml_Appendix5]
--[Promotion].[func_Pro_PolicyToHtml_Dealer]
--[Promotion].[func_Pro_PolicyToHtml_Factor_Hospital]
--[Promotion].[func_Pro_PolicyToHtml_Factor_Product]
--[Promotion].[func_Pro_PolicyToHtml_Factor]
--[Promotion].[func_Pro_PolicyToHtml_Rule_Result]
--[Promotion].[func_Pro_PolicyToHtml_SummaryProduct]
--[Promotion].[func_Pro_PolicyToHtml_SummaryRule]
--[Promotion].[func_Pro_PolicyToHtml_Summary]
--[Promotion].[func_Pro_PolicyToHtml]

UPDATE Lafite_SiteMap SET Helplink = Url WHERE ResourceKey='KendoSite'
UPDATE Lafite_SiteMap SET URL='~/PagesKendo/Home.aspx?PowerKey=' + PowerKey WHERE ResourceKey='KendoSite' AND URL IS NOT NULL

DELETE AM FROM Lafite_ATTRIBUTE_MAP AM 
WHERE EXISTS (SELECT 1 FROM Lafite_STRATEGY_MAP SM,Lafite_FUNCTION F, Lafite_STRATEGY S
              WHERE F.FUNCTION_NAME LIKE '%coolite%' AND F.Id = SM.MAP_ID AND S.Id = SM.STRATEGY_ID AND AM.MAP_ID = S.Id)
              
DELETE S FROM Lafite_STRATEGY S 
WHERE EXISTS (SELECT 1 FROM Lafite_STRATEGY_MAP SM,Lafite_FUNCTION F 
              WHERE F.FUNCTION_NAME LIKE '%coolite%' AND F.Id = SM.MAP_ID AND S.Id = SM.STRATEGY_ID)

DELETE SM FROM Lafite_STRATEGY_MAP SM 
WHERE EXISTS (SELECT 1 FROM Lafite_FUNCTION F WHERE F.FUNCTION_NAME LIKE '%coolite%' AND F.Id = SM.MAP_ID)

DELETE S FROM Lafite_SiteMap S
WHERE EXISTS (SELECT 1 FROM Lafite_FUNCTION F WHERE F.FUNCTION_NAME LIKE '%coolite%' AND F.FUNCTION_CODE = S.PowerKey)

DELETE F FROM Lafite_FUNCTION F 
WHERE F.FUNCTION_NAME LIKE '%coolite%'