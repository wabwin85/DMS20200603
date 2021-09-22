CREATE TABLE [dbo].[HospitalPositionMap]
(
[HPM_ID] [uniqueidentifier] NOT NULL,
[HPM_PositionID] [uniqueidentifier] NOT NULL,
[HPM_HospitalID] [uniqueidentifier] NOT NULL,
[HPM_ProductLineID] [uniqueidentifier] NOT NULL,
[HPM_CreateDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_HospitalPositionMap] ON [dbo].[HospitalPositionMap] ([HPM_PositionID], [HPM_ProductLineID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HospitalPositionMap] ADD CONSTRAINT [PK_HospitalPositionMap] PRIMARY KEY NONCLUSTERED ([HPM_ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'医院与工作岗位关系表，原为TSR与医院关系表', 'SCHEMA', N'dbo', 'TABLE', N'HospitalPositionMap', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'岗位id', 'SCHEMA', N'dbo', 'TABLE', N'HospitalPositionMap', 'COLUMN', N'HPM_PositionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'医院id', 'SCHEMA', N'dbo', 'TABLE', N'HospitalPositionMap', 'COLUMN', N'HPM_HospitalID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'岗位所属产品线。为便于快速筛选数据设立此字段。例如配置经销商的产品授权医院时，直接利用此字段即可获取某个产品线全部可供授权的医院清单；销售出库中，根据产品线获取对应医院与岗位信息时，也应该指定此字段，便于快速查询', 'SCHEMA', N'dbo', 'TABLE', N'HospitalPositionMap', 'COLUMN', N'HPM_ProductLineID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'创建日期', 'SCHEMA', N'dbo', 'TABLE', N'HospitalPositionMap', 'COLUMN', N'HPM_CreateDate'
GO
