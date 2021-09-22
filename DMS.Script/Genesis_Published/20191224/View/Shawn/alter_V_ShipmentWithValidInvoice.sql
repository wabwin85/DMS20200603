
/****** Object:  View [dbo].[V_ShipmentWithValidInvoice]    Script Date: 2019/12/18 10:11:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_ShipmentWithValidInvoice] 
AS
SELECT DISTINCT ISNULL(ATH.SPH_ID,JYCode.SPH_ID) AS Valid_SPH_ID 
FROM interface.T_I_JY_ShipmentWithValidInvoice AS JYCode(NOLOCK) FULL JOIN (
SELECT H.SPH_ID FROM ShipmentHeader H(NOLOCK), Attachment AT(NOLOCK)
 WHERE  AT.AT_Main_ID = H.SPH_ID AND H.SPH_SubmitDate>'2017-01-01 0:00:00'
 ) ATH  ON ATH.SPH_ID = JYCode.SPH_ID
GO


