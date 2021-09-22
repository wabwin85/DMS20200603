UPDATE Contract.ExportTemplate SET BrandName='波科' WHERE TemplateName IN('第三方公司管理流程_T1','法律合规负责人岗位职责_T1') AND ContractType IN('Appointment','Renewal') AND DealerType='T1'
UPDATE Contract.ExportTemplate SET IsRequired=0,IsActive=0 WHERE TemplateName IN('经销商协议_T1 附件一（授权清单）','经销商协议_T1_附件二（指标清单）','数据质量保证函_T1','渠道管理规则_T1','承诺书产品仓储地址合规性声明_T1','设备采购附件（仅适用于PUL,Uro设备,PION设备）') AND ContractType IN('Appointment','Renewal') AND DealerType='T1'

--第三方公司管理流程_国产厂家_T1
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'第三方公司管理流程_国产厂家_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/第三方公司管理流程_国产厂家_T1.docx',1,1,16,NULL,N'瑞奇')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'第三方公司管理流程_国产厂家_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/第三方公司管理流程_国产厂家_T1.docx',1,1,16,NULL,N'瑞奇')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'第三方公司管理流程_国产厂家_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/第三方公司管理流程_国产厂家_T1.docx',1,1,16,NULL,N'法兰克曼')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'第三方公司管理流程_国产厂家_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/第三方公司管理流程_国产厂家_T1.docx',1,1,16,NULL,N'法兰克曼')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'第三方公司管理流程_国产厂家_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/第三方公司管理流程_国产厂家_T1.docx',1,1,16,NULL,N'康德莱')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'第三方公司管理流程_国产厂家_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/第三方公司管理流程_国产厂家_T1.docx',1,1,16,NULL,N'康德莱')
--反腐败保证函-国产
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'反腐败保证函_国内产品_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/反腐败保证函_国内产品_T1.docx',1,1,17,NULL,N'瑞奇')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'反腐败保证函_国内产品_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/反腐败保证函_国内产品_T1.docx',1,1,17,NULL,N'瑞奇')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'反腐败保证函_国内产品_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/反腐败保证函_国内产品_T1.docx',1,1,17,NULL,N'法兰克曼')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'反腐败保证函_国内产品_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/反腐败保证函_国内产品_T1.docx',1,1,17,NULL,N'法兰克曼')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'反腐败保证函_国内产品_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/反腐败保证函_国内产品_T1.docx',1,1,17,NULL,N'康德莱')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'反腐败保证函_国内产品_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/反腐败保证函_国内产品_T1.docx',1,1,17,NULL,N'康德莱')
--反腐败保证函-波科
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'反腐败保证函_波科产品_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/反腐败保证函_波科产品_T1.docx',1,1,18,NULL,N'波科')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'反腐败保证函_波科产品_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/反腐败保证函_波科产品_T1.docx',1,1,18,NULL,N'波科')
--合规政策
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'蓝威经销商合规政策(v1-2019)',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/蓝威经销商合规政策(v1-2019).docx',1,1,19,NULL,NULL)
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'蓝威经销商合规政策(v1-2019)',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/蓝威经销商合规政策(v1-2019).docx',1,1,19,NULL,NULL)
