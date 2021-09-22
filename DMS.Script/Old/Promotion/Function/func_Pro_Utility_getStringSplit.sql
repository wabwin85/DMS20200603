DROP FUNCTION [Promotion].[func_Pro_Utility_getStringSplit]
GO



/**********************************************
 功能:传入字符串，返回Table
 传入字符串格式AAA|CCC或者AAA,BBB|CCC,DDD，如果只有一列就放ColA
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_Utility_getStringSplit](
	@SourceString NVARCHAR(MAX)
	)
RETURNS @temp TABLE
             (
				ColA NVARCHAR (100),
                ColB NVARCHAR (100)
             )
WITH
EXECUTE AS CALLER
AS
BEGIN
	DECLARE @i INT
	DECLARE @n INT
	DECLARE @checkLeft INT
	DECLARE @checkRight INT
	DECLARE @valueMiddle NVARCHAR (max)
	DECLARE @valueLeft NVARCHAR (100)
	DECLARE @valueRight NVARCHAR (100)
	
	SET @SourceString = rtrim (ltrim (@SourceString))
	SET @i = charindex ('|', @SourceString)

	WHILE @i >= 1
		BEGIN
			IF len (left (@SourceString, @i - 1)) > 0
				BEGIN
					set @valueMiddle=left (@SourceString, @i - 1);
					SET @n = charindex (',', @valueMiddle)
					IF @n>=1
					BEGIN
						set @checkLeft=len (left (@valueMiddle, @n - 1))
						set @checkRight =LEN(right(@valueMiddle,LEN(@valueMiddle)-@n))
						IF @checkLeft>0
							BEGIN
								SET @valueLeft=left (@valueMiddle, @n - 1);
							END
						ELSE
							BEGIN
								SET @valueLeft=NULL;
							END
						IF @checkRight>0
							BEGIN
								SET @valueRight=right(@valueMiddle,LEN(@valueMiddle)-@n);
							END
						ELSE
							BEGIN
								SET @valueRight=NULL;
							END
						INSERT @temp(ColA,ColB)
						VALUES (@valueLeft,@valueRight)
					END
				ELSE
					BEGIN
					INSERT @temp(ColA,ColB)
						VALUES (@valueMiddle,NULL)
					END
					
					
					
				END
			SET @SourceString   = substring (@SourceString, @i + 1, len (@SourceString) - @i)
			SET @i   = charindex ('|', @SourceString)
		END

	IF @SourceString <> ''
	BEGIN
		SET @n = charindex (',', @SourceString)
		IF @n>=1
			BEGIN
				set @checkLeft=len (left (@SourceString, @n - 1))
				set @checkRight =LEN(right(@SourceString,LEN(@SourceString)-@n))
				IF @checkLeft>0
					BEGIN
						SET @valueLeft=left (@SourceString, @n - 1);
					END
				ELSE
					BEGIN
						SET @valueLeft=NULL;
					END
				IF @checkRight>0
					BEGIN
						SET @valueRight=right(@SourceString,LEN(@SourceString)-@n);
					END
				ELSE
					BEGIN
						SET @valueRight=NULL;
					END
				INSERT @temp(ColA,ColB)
				VALUES (@valueLeft,@valueRight)
			END
		ELSE
			BEGIN
			INSERT @temp(ColA,ColB)
				VALUES (@SourceString,NULL)
			END
	END
	
	RETURN
END



GO


