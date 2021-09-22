DROP FUNCTION [Promotion].[func_Pro_Utility_getLargess]
GO



CREATE FUNCTION [Promotion].[func_Pro_Utility_getLargess](
	@BU NVARCHAR(50),	--主界面上选择的产品线
	@LARGESSTYPE NVARCHAR(10), --FreeGoods,Point
	@DEALERID UNIQUEIDENTIFIER
	)
RETURNS @temp TABLE
	(
        DLID INT,
        ListValue NVARCHAR(1000),	--下拉选项中显示的内容
        Description NVARCHAR(1000),  --详细信息
        LeftNum Decimal(14,2) --剩余数量或积分
        
	)
AS
BEGIN
	
	IF @LARGESSTYPE = 'FreeGoods'
	BEGIN
		INSERT INTO @temp(DLID,ListValue,Description,LeftNum) 
		SELECT A.DLid,
		CASE ISNULL(a.ListDesc,'') WHEN '' THEN Promotion.func_Pro_Utility_getLargess_Desc(A.DLID,'LIST')+'(编号：'+CONVERT(NVARCHAR,a.DLid)+')' ELSE A.ListDesc+'(编号：'+CONVERT(NVARCHAR,a.DLid)+')' END ListDesc,
		CASE ISNULL(a.DetailDesc,'') WHEN '' THEN Promotion.func_Pro_Utility_getLargess_Desc(A.DLID,'DETAIL')  ELSE A.DetailDesc END DetailDesc,
		a.LargessAmount - OrderAmount + OtherAmount LeftAmount 
		FROM promotion.PRO_DEALER_LARGESS A
		WHERE BU = @BU AND GiftType = @LARGESSTYPE AND DEALERID = @DEALERID
		AND LargessAmount - OrderAmount + OtherAmount > 0 
	END
	ELSE
	BEGIN	--还没写
		INSERT INTO @temp(DLID,ListValue,Description,LeftNum) 
		SELECT A.DLid,
		'积分'+CONVERT(NVARCHAR,A.BU) ListDesc,
		'积分'+CONVERT(NVARCHAR,A.BU) ListDesc,
		a.LargessAmount - OrderAmount + OtherAmount LeftAmount 
		FROM promotion.PRO_DEALER_LARGESS A
		WHERE BU = @BU AND GiftType = @LARGESSTYPE AND DEALERID = @DEALERID
		AND LargessAmount - OrderAmount + OtherAmount > 0
	END
	
	RETURN
END



GO


