UPDATE Contract.ExportTemplate SET BrandName='����' WHERE TemplateName IN('��������˾��������_T1','���ɺϹ渺���˸�λְ��_T1') AND ContractType IN('Appointment','Renewal') AND DealerType='T1'
UPDATE Contract.ExportTemplate SET IsRequired=0,IsActive=0 WHERE TemplateName IN('������Э��_T1 ����һ����Ȩ�嵥��','������Э��_T1_��������ָ���嵥��','����������֤��_T1','�����������_T1','��ŵ���Ʒ�ִ���ַ�Ϲ�������_T1','�豸�ɹ���������������PUL,Uro�豸,PION�豸��') AND ContractType IN('Appointment','Renewal') AND DealerType='T1'

--��������˾��������_��������_T1
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'��������˾��������_��������_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/��������˾��������_��������_T1.docx',1,1,16,NULL,N'����')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'��������˾��������_��������_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/��������˾��������_��������_T1.docx',1,1,16,NULL,N'����')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'��������˾��������_��������_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/��������˾��������_��������_T1.docx',1,1,16,NULL,N'��������')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'��������˾��������_��������_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/��������˾��������_��������_T1.docx',1,1,16,NULL,N'��������')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'��������˾��������_��������_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/��������˾��������_��������_T1.docx',1,1,16,NULL,N'������')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'��������˾��������_��������_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/��������˾��������_��������_T1.docx',1,1,16,NULL,N'������')
--�����ܱ�֤��-����
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'�����ܱ�֤��_���ڲ�Ʒ_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/�����ܱ�֤��_���ڲ�Ʒ_T1.docx',1,1,17,NULL,N'����')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'�����ܱ�֤��_���ڲ�Ʒ_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/�����ܱ�֤��_���ڲ�Ʒ_T1.docx',1,1,17,NULL,N'����')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'�����ܱ�֤��_���ڲ�Ʒ_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/�����ܱ�֤��_���ڲ�Ʒ_T1.docx',1,1,17,NULL,N'��������')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'�����ܱ�֤��_���ڲ�Ʒ_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/�����ܱ�֤��_���ڲ�Ʒ_T1.docx',1,1,17,NULL,N'��������')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'�����ܱ�֤��_���ڲ�Ʒ_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/�����ܱ�֤��_���ڲ�Ʒ_T1.docx',1,1,17,NULL,N'������')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'�����ܱ�֤��_���ڲ�Ʒ_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/�����ܱ�֤��_���ڲ�Ʒ_T1.docx',1,1,17,NULL,N'������')
--�����ܱ�֤��-����
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'�����ܱ�֤��_���Ʋ�Ʒ_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/�����ܱ�֤��_���Ʋ�Ʒ_T1.docx',1,1,18,NULL,N'����')
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'�����ܱ�֤��_���Ʋ�Ʒ_T1',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/�����ܱ�֤��_���Ʋ�Ʒ_T1.docx',1,1,18,NULL,N'����')
--�Ϲ�����
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Appointment',N'T1',N'���������̺Ϲ�����(v1-2019)',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/���������̺Ϲ�����(v1-2019).docx',1,1,19,NULL,NULL)
INSERT INTO Contract.ExportTemplate
(TemplateId,ContractType,DealerType,TemplateName,TemplateFile,IsRequired,IsActive,DisplayOrder,TemplateType,BrandName)
VALUES
(NEWID(),N'Renewal',N'T1',N'���������̺Ϲ�����(v1-2019)',N'~/Upload/ContractElectronicAttachmentTemplate/T1/AppointmentRenewal/���������̺Ϲ�����(v1-2019).docx',1,1,19,NULL,NULL)
