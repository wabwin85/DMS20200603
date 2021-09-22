DROP VIEW [dbo].[V_HospSalesQty]
GO


CREATE VIEW [dbo].[V_HospSalesQty]
AS
SELECT [YEAR],
       [Month],
       DivisionID,
       DMSCode,
       ISNULL(
           CONVERT(
               INT,
               SUM(
                   CASE 
                        WHEN ProductLine1 = 'Core'
                   AND ProductLine2 = 'PE' THEN QTY ELSE 0 END
               )
           ),
           0
       ) PE,
       ISNULL(
           CONVERT(
               INT,
               SUM(
                   CASE 
                        WHEN ProductLine1 = 'Core'
                   AND ProductLine2 = 'TL' THEN QTY ELSE 0 END
               )
           ),
           0
       ) TL,
       ISNULL(
           CONVERT(
               INT,
               SUM(
                   CASE 
                        WHEN ProductLine1 = 'Core'
                   AND ProductLine2 = '��ͨ����' THEN QTY ELSE 0 END
               )
           ),
           0
       ) BALLON,
       ISNULL(
           CONVERT(
               INT,
               SUM(
                   CASE 
                        WHEN ProductLine1 = 'Rovus�Ĳ�'
                   AND ProductLine2 = 'IVUS�Ĳ�' THEN QTY ELSE 0 END
               )
           ),
           0
       ) IVUS,
       ISNULL(
           CONVERT(
               INT,
               SUM(
                   CASE 
                        WHEN ProductLine1 = 'Rovus�Ĳ�'
                   AND ProductLine2 = '�и�����' THEN QTY ELSE 0 END
               )
           ),
           0
       ) CB,
       ISNULL(
           CONVERT(
               INT,
               SUM(
                   CASE 
                        WHEN ProductLine1 = 'Rovus�Ĳ�'
                   AND ProductLine2 = '��ĥ�Ĳ�'
                   AND ProductLine3 = '��ĥ�ƽ���' THEN QTY ELSE 0 END
               )
           ),
           0
       ) ROTA,
       ISNULL(
           CONVERT(
               INT,
               SUM(
                   CASE 
                        WHEN ProductLine1 = 'VA'
                   AND ProductLine2 = 'ָ������' THEN QTY ELSE 0 END
               )
           ),
           0
       ) GUIDING
FROM   interface.RV_HospSalesQty
WHERE  DivisionID = 17
       AND UPN <> 'H749A70200'
GROUP BY [YEAR], [Month], DivisionID, DMSCode




GO


