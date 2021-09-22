DROP view [interface].[V_I_EW_BasePrice]
GO


create view [interface].[V_I_EW_BasePrice]
as
with tmp_price (instanceid,upn) as 
(SELECT MAX(InstancdId) as instanceid,UPN as upn FROM interface.T_I_EW_DistributorPrice 
WHERE [Type] = 99 GROUP BY UPN)
SELECT a.UPN, a.NewPrice as Price
FROM interface.T_I_EW_DistributorPrice a
INNER JOIN tmp_price b ON a.InstancdId = b.instanceid and a.UPN = b.upn

GO


