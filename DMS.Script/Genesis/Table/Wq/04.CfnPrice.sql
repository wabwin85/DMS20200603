--经销商价格增加省市，分子公司，品牌，及优先级

Alter table CfnPrice ADD CFNP_SubCompanyId [uniqueidentifier] NULL 
Alter table CfnPrice ADD CFNP_BrandId [uniqueidentifier] NULL 
Alter table CfnPrice ADD CFNP_Province [uniqueidentifier] NULL 
Alter table CfnPrice ADD CFNP_City [uniqueidentifier] NULL 
--Alter table CfnPrice ADD CFNP_LevelKey [nvarchar](50) NULL 
