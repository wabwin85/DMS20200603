DROP VIEW [interface].[V_I_EW_ReferencePrice]
GO

CREATE VIEW [interface].[V_I_EW_ReferencePrice]
AS
   SELECT t1.UPN,
          t1.NewPrice AS Price,
          t1.ValidFrom,
          t1.ValidTo
     FROM interface.T_I_EW_DistributorPrice t1(nolock),
          (SELECT UPN, max (createdate) AS CreateDate
             FROM interface.T_I_EW_DistributorPrice(nolock)
            WHERE (Type = '99' OR SubtType IN (111, 121))
           GROUP BY UPN) t2
    WHERE     (t1.[Type] = '99' OR SubtType IN (111, 121))
          AND t1.UPN = t2.UPN
          AND t1.CreateDate = t2.CreateDate
--and ValidFrom<getdate() and  isnull(ValidTo,Convert(datetime,'9999-12-31 0:00:00'))>getdate()
GO


