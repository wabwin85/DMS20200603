ALTER TABLE [interface].[T_I_MDM_DealerTraining] ADD [TestType] [nvarchar](50);
ALTER TABLE [interface].[T_I_MDM_DealerTraining] ADD [TestScore] float;
ALTER TABLE [interface].[T_I_MDM_DealerTraining] ADD [CertificateStartDate] DATETIME;
ALTER TABLE [interface].[T_I_MDM_DealerTraining] ADD [CertificateExpireDate] DATETIME;
ALTER TABLE [interface].[T_I_MDM_DealerTraining] ADD [Remark] [nvarchar](1000);