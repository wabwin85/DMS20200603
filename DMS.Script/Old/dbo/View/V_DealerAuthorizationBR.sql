
DROP VIEW [dbo].[V_DealerAuthorizationBR]
GO







CREATE VIEW [dbo].[V_DealerAuthorizationBR]
AS
select f.ID,h.DMA_ID,h.DMA_SAP_Code ,h.DMA_ChineseName,b.DAT_ProductLine_BUM_ID,f.CC_ID,e.CC_Code,e.CC_NameCN,d.CA_ID,d.CA_Code,d.CA_NameCN,a.HLA_HOS_ID,l.HOS_Key_Account ,l.HOS_HospitalName,e.CC_DistinguishRB ,'Çø·ÖºìÀ¶º£' AS DistinguishRBName,g.MarketName
from HospitalList a  with(nolock)
inner join DealerAuthorizationTable  b with(nolock) on a.HLA_DAT_ID=b.DAT_ID
inner join V_DivisionProductLineRelation c  on b.DAT_ProductLine_BUM_ID=c.ProductLineID and c.IsEmerging='0'
inner join interface.ClassificationAuthorization d with(nolock) on d.CA_ID=b.DAT_PMA_ID
inner join interface.ClassificationContract e with(nolock) on d.CA_ParentCode=e.CC_Code and e.CC_DistinguishRB='1'
inner join V_DealerContractMaster f on f.DMA_ID=b.DAT_DMA_ID and CONVERT(nvarchar(10),f.Division)=c.DivisionCode and f.CC_ID=e.CC_ID  and f.ActiveFlag=1
INNER JOIN V_AllHospitalMarketProperty g on g.ProductLineID=b.DAT_ProductLine_BUM_ID and g.Hos_Id=a.HLA_HOS_ID and ISNULL(f.MarketType,0)=g.MarketProperty

inner join DealerMaster h with(nolock) on h.DMA_ID=b.DAT_DMA_ID
inner join Hospital l with(nolock) on l.HOS_ID=a.HLA_HOS_ID







GO


