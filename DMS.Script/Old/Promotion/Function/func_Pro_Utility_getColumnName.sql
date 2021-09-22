DROP FUNCTION [Promotion].[func_Pro_Utility_getColumnName]
GO

CREATE FUNCTION [Promotion].[func_Pro_Utility_getColumnName]( 
	@PolicyFactorId INT, --政策因素id
	@CurrentPeriod NVARCHAR(6)	--账期
	)
RETURNS @temp TABLE
             (
				ColumnName NVARCHAR (100),
				ColumnDesc NVARCHAR (100),
                ColumnType NVARCHAR (100),
                DefaultValue NVARCHAR (100),
                isCondition NVARCHAR (100),
                SourceColumn NVARCHAR(100)
             )
AS
BEGIN
	--动态字段规则：因素固定名+政策因素ID+期间
	INSERT INTO @temp(ColumnName,ColumnDesc,ColumnType,DefaultValue,isCondition,SourceColumn) 
	SELECT C.ColName+CONVERT(NVARCHAR,@PolicyFactorId)+@CurrentPeriod,C.ColDesc+'$'+@CurrentPeriod,C.ColType,
	ISNULL(C.ColDefaultValue,'') ColDefaultValue,C.isCondition,C.SrcColumn
	FROM PROMOTION.PRO_POLICY_FACTOR A,PROMOTION.PRO_FACTOR B,PROMOTION.PRO_FACTOR_COLUMN C
	WHERE A.FactId = B.FactId AND B.FactId = C.FactId AND A.PolicyFactorId = @PolicyFactorId --AND C.IsPeriod = 'Y'
	ORDER BY c.SortNo
	
	RETURN
END


GO


