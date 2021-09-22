DROP PROCEDURE [dbo].[GC_Update_CFN_From_Reg]
GO

CREATE PROCEDURE [dbo].[GC_Update_CFN_From_Reg] 
AS
BEGIN

SET NOCOUNT ON;


update dbo.CFN
set CFN_ChineseName = x.rd_chineseName,
CFN_Property1 = x.RD_Specification,
CFN_Implant = 
case x.RD_Implant
when 'ÊÇ' then 1
when '·ñ' then 0
else NULL
END,
CFN_LastModifiedDate = SYSDATETIME(),
CFN_LastModifiedBy_USR_UserID = 'b3c064c1-902e-44c1-8a5a-b0bc569cd80f'
from cfn a,RegistrationDetail x
where a.CFN_CustomerFaceNbr = x.RD_ArticleNumber

update CFN
set CFN_Property7='NOGTIN'
 WHERE CFN_Property7='0'

END
GO


