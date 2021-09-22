DROP VIEW [dbo].[V_DealerAuthorizationNoBR]
GO






CREATE VIEW [dbo].[V_DealerAuthorizationNoBR]
AS
select f.ID,g.DMA_ID,g.DMA_SAP_Code ,g.DMA_ChineseName,b.DAT_ProductLine_BUM_ID,f.CC_ID,e.CC_Code,e.CC_NameCN,d.CA_ID,d.CA_Code,d.CA_NameCN,a.HLA_HOS_ID,h.HOS_Key_Account ,h.HOS_HospitalName,e.CC_DistinguishRB ,'不区分红蓝海' AS DistinguishRBName
from HospitalList a with(nolock)
inner join DealerAuthorizationTable  b with(nolock) on a.HLA_DAT_ID=b.DAT_ID
inner join V_DivisionProductLineRelation c  on b.DAT_ProductLine_BUM_ID=c.ProductLineID and c.IsEmerging='0'
inner join interface.ClassificationAuthorization d  with(nolock)on d.CA_ID=b.DAT_PMA_ID
inner join interface.ClassificationContract e  with(nolock) on d.CA_ParentCode=e.CC_Code and e.CC_DistinguishRB='0'
inner join V_DealerContractMaster f on f.DMA_ID=b.DAT_DMA_ID and CONVERT(NVARCHAR(10), f.Division)=c.DivisionCode and f.CC_ID=e.CC_ID and f.ActiveFlag=1

inner join DealerMaster g with(nolock) on g.DMA_ID=b.DAT_DMA_ID
inner join Hospital h with(nolock) on h.HOS_ID=a.HLA_HOS_ID






GO


