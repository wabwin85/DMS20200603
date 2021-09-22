DROP FUNCTION [dbo].[GetFormatString]
GO

CREATE FUNCTION [dbo].[GetFormatString] (@dec DECIMAL (28, 15), @n INT)
   RETURNS NVARCHAR (32)
AS
   BEGIN
      DECLARE
         @str      NVARCHAR (32),
         @len      INT,
         @left     NVARCHAR (32),
         @right    NVARCHAR (32),
         @end      NVARCHAR (32),
         @Flag     NVARCHAR (1),
         @fright   NVARCHAR (32),
         @dend     DECIMAL (28, 15)

      IF (@dec < 0)
         BEGIN
            SET @dec = -@dec;
            SET @Flag = 0
         END
      ELSE
         BEGIN
            SET @Flag = 1
         END

      IF @n > '0'
         BEGIN
            SET @str = round (@dec, @n)
            SELECT @left = left (@str, charindex ('.', @str) - 1),
                   @len = len (@left) - 2

            WHILE @len > 1
            BEGIN
               SELECT @left =
                         stuff (@left,
                                @len,
                                0,
                                ','),
                      @len = @len - 3
            END

            SELECT @right =
                      left (stuff (@str,
                                   1,
                                   charindex ('.', @str),
                                   ''),
                            @n),
                   @len = 4

            WHILE @len <= len (@right)
            BEGIN
               SELECT @right =
                         stuff (@right,
                                @len,
                                0,
                                ','),
                      @len = @len + 4
            END

            SET @end = @left + '.' + @right
         END
      ELSE
         IF @n = '0'
            BEGIN
               SET @str = round (@dec, @n)
               SELECT @left = left (@str, charindex ('.', @str) - 1),
                      @len = len (@left) - 2

               WHILE @len > 1
               BEGIN
                  SELECT @left =
                            stuff (@left,
                                   @len,
                                   0,
                                   ','),
                         @len = @len - 3
               END

               SELECT @right =
                         left (stuff (@str,
                                      1,
                                      charindex ('.', @str),
                                      ''),
                               @n),
                      @len = 4

               WHILE @len <= len (@right)
               BEGIN
                  SELECT @right =
                            stuff (@right,
                                   @len,
                                   0,
                                   ','),
                         @len = @len + 4
               END

               SET @end = @left
            END
         -- 负数 保留完整小数位数
         ELSE
            IF @n < '0'
               --
               BEGIN
                  SET @str = round (@dec, 0)
                  SELECT @left = Floor (@dec),
                         @len = len (@left) - 2

                  WHILE @len > 1
                  BEGIN
                     SELECT @left =
                               stuff (@left,
                                      @len,
                                      0,
                                      ','),
                            @len = @len - 3
                  END

                  SELECT @right = @dec - Floor (@dec)
                  SET @fright = cast (@right AS FLOAT)

                  SELECT @right =
                            SUBSTRING (
                               cast (@dec AS VARCHAR),
                               (PATINDEX ('%.%', cast (@dec AS VARCHAR)) + 1),
                               len (@dec))
                  SET @end = @left + '.' + @right

                  IF @fright != '0'
                     BEGIN
                        SET @end = @left + '.' + @right
                        
                     END
                  ELSE
                     SET @end = @end
               END

      IF (@Flag = 0)
         BEGIN
            SET @end = '-' + @end
         END

      RETURN @end
   END
GO


