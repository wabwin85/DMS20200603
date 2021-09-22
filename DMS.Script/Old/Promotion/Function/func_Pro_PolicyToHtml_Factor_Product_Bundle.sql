DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_Product_Bundle]
GO

CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_Product_Bundle](
	@BundleId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @RETURN NVARCHAR(MAX);
	DECLARE @DETAIL NVARCHAR(MAX); 
	DECLARE @HierType NVARCHAR(50)
	DECLARE @HierId NVARCHAR(MAX)
	DECLARE @Qty INT
	
	SET @RETURN = ''
	
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT a.HierType,a.HierId,a.Qty FROM Promotion.Pro_Bundle_Setting_Detail a WHERE BundleId = @BundleId 
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @HierType,@HierId,@Qty
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @DETAIL = ''
		
		IF @HierType = 'HIER' --产品组
		BEGIN
			SET @DETAIL = '【'+STUFF(REPLACE(REPLACE(
					(
					    SELECT Promotion.func_Pro_PolicyToHtml_Factor_Product_PrdGrp(A.COLA,A.COLB) COL
							FROM Promotion.func_Pro_Utility_getStringSplit(@HierId) A
					    FOR XML AUTO
					), '<A COL="', '，'), '"/>', ''), 1, 1, '')+'】'+ CONVERT(NVARCHAR,@Qty)+'件'
		END
		
		IF @HierType = 'UPN'
		BEGIN
			 SET @DETAIL = '【'+'UPN('+REPLACE(@HierId,'|','，')+')'+'】'+ CONVERT(NVARCHAR,@Qty)+'件'
		END
		
		SET @RETURN += CASE @RETURN WHEN '' THEN '' ELSE ',' END + @DETAIL
		
		FETCH NEXT FROM @iCURSOR INTO @HierType,@HierId,@Qty
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	SET @RETURN = '套装{'+@RETURN+'}'
	RETURN @RETURN
END


GO


