--合同增加备案凭证
ALTER TABLE [Contract].AppointmentDocuments ADD [Bak] [nvarchar](1000) NULL


--流程记录表中新增流程模板id字段

ALTER TABLE Workflow.FormInstanceMaster ADD [fdTemplateFormId] [nvarchar](50) NULL
ALTER TABLE Workflow.FormInstanceMaster ADD [docCreator] [nvarchar](100) NULL


--T2合同信息中增加邮寄地址
ALTER TABLE [Contract].AppointmentCandidate ADD [EmailAddress] [nvarchar](150) NULL

ALTER TABLE [dbo].[DealerMaster] ADD [DMA_DMM_ID] [uniqueidentifier] NOT NULL
ALTER TABLE [dbo].[DealerMaster] ADD [DMA_SubCompanyId] [uniqueidentifier] NOT NULL



--合同模板增加品牌
ALTER TABLE Contract.ExportTemplate ADD BrandName NVARCHAR(50) NULL