DROP FUNCTION [dbo].[GC_Fn_SplitStringToMultiColsTable] 
GO

CREATE FUNCTION [dbo].[GC_Fn_SplitStringToMultiColsTable] (
   @SourceSql     NVARCHAR (MAX),
   @RowSeprate    NVARCHAR (10),
   @ColSeprate    NVARCHAR (10))
   RETURNS @ReTable TABLE
                    (
                       Col1   NVARCHAR (200),
                       Col2   NVARCHAR (200) NULL,
                       Col3   NVARCHAR (200) NULL,
                       Col4   NVARCHAR (200) NULL,
                       Col5   NVARCHAR (200) NULL
                    )
AS
   BEGIN
      DECLARE @i   INT
      DECLARE @j   INT
      DECLARE @StrRow   NVARCHAR (MAX)
      DECLARE @RowNum   INT
      DECLARE @SortNo   INT
      DECLARE @Col1   NVARCHAR (200)
      DECLARE @Col2   NVARCHAR (200)
      DECLARE @Col3   NVARCHAR (200)
      DECLARE @Col4   NVARCHAR (200)
      DECLARE @Col5   NVARCHAR (200)


      SET @SourceSql = rtrim (ltrim (@SourceSql))      
      SET @i = charindex (@RowSeprate, @SourceSql)
      SET @RowNum = 1
      WHILE @i >= 1
      BEGIN
         
         IF datalength (left (@SourceSql, @i - 1)) > 0
            BEGIN
               SET @Col1 = NULL
               SET @Col2 = NULL
               SET @Col3 = NULL
               SET @Col4 = NULL
               SET @Col5 = NULL

               --获取行记录
               SET @StrRow = left (@SourceSql, @i - 1)
               SET @j = charindex (@ColSeprate, @StrRow)
               SET @Col1 = left (@StrRow, @j - 1)
               SET @StrRow = substring (@StrRow, @j + 1, len (@StrRow))


               IF len (@StrRow) > 0
                  BEGIN
                     SET @j = charindex (@ColSeprate, @StrRow)

                     IF @j > 0
                        BEGIN
                           SET @Col2 = left (@StrRow, @j - 1)
                           SET @StrRow =
                                  substring (@StrRow, @j + 1, len (@StrRow))
                        END
                     ELSE
                        BEGIN
                           SET @Col2 = @StrRow
                           SET @StrRow = ''
                        END
                  END

               IF len (@StrRow) > 0
                  BEGIN
                     SET @j = charindex (@ColSeprate, @StrRow)
                     IF @j > 0
                        BEGIN
                           SET @Col3 = left (@StrRow, @j - 1)
                           SET @StrRow =
                                  substring (@StrRow, @j + 1, len (@StrRow))
                        END
                     ELSE
                        BEGIN
                           SET @Col3 = @StrRow
                           SET @StrRow = ''
                        END
                  END

               IF len (@StrRow) > 0
                  BEGIN
                     SET @j = charindex (@ColSeprate, @StrRow)

                     IF @j > 0
                        BEGIN
                           SET @Col4 = left (@StrRow, @j - 1)
                           SET @StrRow =
                                  substring (@StrRow, @j + 1, len (@StrRow))
                        END
                     ELSE
                        BEGIN
                           SET @Col4 = @StrRow
                           SET @StrRow = ''
                        END
                  END

               IF len (@StrRow) > 0
                  BEGIN
                     SET @j = charindex (@ColSeprate, @StrRow)

                     IF @j > 0
                        BEGIN
                           SET @Col5 = left (@StrRow, @j - 1)
                           SET @StrRow =
                                  substring (@StrRow, @j + 1, len (@StrRow))
                        END
                     ELSE
                        BEGIN
                           SET @Col5 = @StrRow
                           SET @StrRow = ''
                        END
                  END

               INSERT @ReTable
               VALUES (@Col1,
                       @Col2,
                       @Col3,
                       @Col4,
                       @Col5)
            END

         SET @SourceSql =
                substring (@SourceSql,
                           @i + len (@RowSeprate),
                           len (@SourceSql) - @i)
         SET @i = charindex (@RowSeprate, @SourceSql)
         SET @RowNum = @RowNum + 1
      END

      IF @SourceSql <> ''
         BEGIN
            --获取最后一行记录



            SET @Col1 = NULL
            SET @Col2 = NULL
            SET @Col3 = NULL
            SET @Col4 = NULL
            SET @Col5 = NULL

            --获取行记录
            --select left ('1@A@F1,2@B@F2,3@C@F3',6)
            SET @StrRow = @SourceSql
            --SET @SortNo = 1


            --select charindex('@','1@A@F1')
            SET @j = charindex (@ColSeprate, @StrRow)
            --select left('1@A@F1',2-1)
            SET @Col1 = left (@StrRow, @j - 1)
            --select substring('1@A@F1',2 + 1,len('1@A@F1'))
            SET @StrRow = substring (@StrRow, @j + 1, len (@StrRow))

            --select charindex('@','A@F1')

            IF len (@StrRow) > 0
               BEGIN
                  SET @j = charindex (@ColSeprate, @StrRow)

                  IF @j > 0
                     BEGIN
                        SET @Col2 = left (@StrRow, @j - 1)
                        SET @StrRow =
                               substring (@StrRow, @j + 1, len (@StrRow))
                     END
                  ELSE
                     BEGIN
                        SET @Col2 = @StrRow
                        SET @StrRow = ''
                     END
               END

            IF len (@StrRow) > 0
               BEGIN
                  SET @j = charindex (@ColSeprate, @StrRow)

                  IF @j > 0
                     BEGIN
                        SET @Col3 = left (@StrRow, @j - 1)
                        SET @StrRow =
                               substring (@StrRow, @j + 1, len (@StrRow))
                     END
                  ELSE
                     BEGIN
                        SET @Col3 = @StrRow
                        SET @StrRow = ''
                     END
               END

            IF len (@StrRow) > 0
               BEGIN
                  SET @j = charindex (@ColSeprate, @StrRow)

                  IF @j > 0
                     BEGIN
                        SET @Col4 = left (@StrRow, @j - 1)
                        SET @StrRow =
                               substring (@StrRow, @j + 1, len (@StrRow))
                     END
                  ELSE
                     BEGIN
                        SET @Col4 = @StrRow
                        SET @StrRow = ''
                     END
               END

            IF len (@StrRow) > 0
               BEGIN
                  SET @j = charindex (@ColSeprate, @StrRow)

                  IF @j > 0
                     BEGIN
                        SET @Col5 = left (@StrRow, @j - 1)
                        SET @StrRow =
                               substring (@StrRow, @j + 1, len (@StrRow))
                     END
                  ELSE
                     BEGIN
                        SET @Col5 = @StrRow
                        SET @StrRow = ''
                     END
               END

            INSERT @ReTable
            VALUES (@Col1,
                    @Col2,
                    @Col3,
                    @Col4,
                    @Col5)
         END

      RETURN
   END
GO


