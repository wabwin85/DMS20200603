DROP VIEW [interface].[V_I_EW_HospitalPrice]
GO

CREATE VIEW [interface].[V_I_EW_HospitalPrice]
AS
   SELECT t1.UPN,
          t1.NewPrice AS Price,
          t1.ValidFrom,
          t1.ValidTo
     FROM interface.T_I_EW_DistributorPrice t1(nolock),
          (SELECT UPN, max (createdate) AS CreateDate
             FROM interface.T_I_EW_DistributorPrice(nolock)
            WHERE SubtType IN (113, 123)
           GROUP BY UPN) t2
    WHERE     SubtType IN (113, 123)
          AND t1.UPN = t2.UPN
          AND t1.CreateDate = t2.CreateDate
GO


