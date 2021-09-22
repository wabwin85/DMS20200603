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
                   AND ProductLine2 = 'ÆÕÍ¨ÇòÄÒ' THEN QTY ELSE 0 END
               )
           ),
           0
       ) BALLON,
       ISNULL(
           CONVERT(
               INT,
               SUM(
                   CASE 
                        WHEN ProductLine1 = 'RovusºÄ²Ä'
                   AND ProductLine2 = 'IVUSºÄ²Ä' THEN QTY ELSE 0 END
               )
           ),
           0
       ) IVUS,
       ISNULL(
           CONVERT(
               INT,
               SUM(
                   CASE 
                        WHEN ProductLine1 = 'RovusºÄ²Ä'
                   AND ProductLine2 = 'ÇÐ¸îÇòÄÒ' THEN QTY ELSE 0 END
               )
           ),
           0
       ) CB,
       ISNULL(
           CONVERT(
               INT,
               SUM(
                   CASE 
                        WHEN ProductLine1 = 'RovusºÄ²Ä'
                   AND ProductLine2 = 'ÐýÄ¥ºÄ²Ä'
                   AND ProductLine3 = 'ÐýÄ¥ÍÆ½øÆ÷' THEN QTY ELSE 0 END
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
                   AND ProductLine2 = 'Ö¸Òýµ¼¹Ü' THEN QTY ELSE 0 END
               )
           ),
           0
       ) GUIDING
FROM   interface.RV_HospSalesQty
WHERE  DivisionID = 17
       AND UPN <> 'H749A70200'
GROUP BY [YEAR], [Month], DivisionID, DMSCode




GO


