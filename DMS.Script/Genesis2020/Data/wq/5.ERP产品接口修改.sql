ALTER TABLE [dbo].[InterfaceERPProduct] ADD FDESCRIPTION [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'产品描述信息' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'FDESCRIPTION'
																	
ALTER TABLE [dbo].[InterfaceERPProduct] ADD F_BGP_APPROVALNO [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'注册证编号' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_BGP_APPROVALNO'
 																		
ALTER TABLE [dbo].[InterfaceERPProduct] ADD F_BGP_COMMONNAME [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'注册证产品名称' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_BGP_COMMONNAME'
 																		
ALTER TABLE [dbo].[InterfaceERPProduct] ADD F_BGP_ORIGIN [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'注册证产品产地' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_BGP_ORIGIN'
 																		
ALTER TABLE [dbo].[InterfaceERPProduct] ADD F_BGP_PRODUCTENT [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'注册证产品制造商' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_BGP_PRODUCTENT'
 																		
																		
ALTER TABLE [dbo].[InterfaceERPProduct] ADD F_BGP_GRANTDATE [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'注册证有效时间-开始日期' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_BGP_GRANTDATE'
 																		
ALTER TABLE [dbo].[InterfaceERPProduct] ADD F_BGP_PERIODVALIDITY [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'注册证有效时间-结束日期' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_BGP_PERIODVALIDITY'
 																		
ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_BGP_BIGCLASS.FNumber] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'注册证对应二类证号/三类' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_BGP_BIGCLASS'


--ALTER TABLE [dbo].[InterfaceERPProduct] ADD F_BGP_MulMinQty [NVARCHAR](50) NULL
--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'包装系数' , @level0type=N'SCHEMA',@level0name=N'dbo',
-- @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_BGP_MulMinQty'
ALTER TABLE [dbo].[InterfaceERPProduct] ADD F_BGP_NUMPACKAGE [NVARCHAR](50) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'包装系数' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_BGP_NUMPACKAGE'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD FORDERQTY [NVARCHAR](50) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'最小订单系数' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'FORDERQTY'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD F_BGP_StopPin [NVARCHAR](10) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否可订购' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_BGP_StopPin'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_ProductLine1] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Level1 Desc' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_ProductLine1'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_ProductLine2] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Level2 Desc' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_ProductLine2'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_ProductLine3] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Level3 Desc' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_ProductLine3'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_ProductLine4] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Level4 Desc' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_ProductLine4'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_ProductLine5] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Level5 Desc' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_ProductLine5'




--------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_SPPP.FDataValue] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'品牌' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_SPPP'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_YWX.FDataValue] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'产品线' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_YWX'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_ProductLineNO1] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Level1 Code' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_ProductLineNO1'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_ProductLineNO2] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Level2 Code' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_ProductLineNO2'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_ProductLineNO3] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Level3 Code' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_ProductLineNO3'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_ProductLineNO4] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Level4 Code' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_ProductLineNO4'

ALTER TABLE [dbo].[InterfaceERPProduct] ADD [F_SRT_ProductLineNO5] [NVARCHAR](200) NULL
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Level5 Code' , @level0type=N'SCHEMA',@level0name=N'dbo',
 @level1type=N'TABLE',@level1name=N'InterfaceERPProduct', @level2type=N'COLUMN',@level2name=N'F_SRT_ProductLineNO5'

 ALTER TABLE [dbo].[InterfaceERPProduct] ADD F_SRT_RegAddress [NVARCHAR](500) NULL


