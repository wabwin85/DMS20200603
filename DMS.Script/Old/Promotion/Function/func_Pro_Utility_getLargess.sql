DROP FUNCTION [Promotion].[func_Pro_Utility_getLargess]
GO



CREATE FUNCTION [Promotion].[func_Pro_Utility_getLargess](
	@BU NVARCHAR(50),	--��������ѡ��Ĳ�Ʒ��
	@LARGESSTYPE NVARCHAR(10), --FreeGoods,Point
	@DEALERID UNIQUEIDENTIFIER
	)
RETURNS @temp TABLE
	(
        DLID INT,
        ListValue NVARCHAR(1000),	--����ѡ������ʾ������
        Description NVARCHAR(1000),  --��ϸ��Ϣ
        LeftNum Decimal(14,2) --ʣ�����������
        
	)
AS
BEGIN
	
	IF @LARGESSTYPE = 'FreeGoods'
	BEGIN
		INSERT INTO @temp(DLID,ListValue,Description,LeftNum) 
		SELECT A.DLid,
		CASE ISNULL(a.ListDesc,'') WHEN '' THEN Promotion.func_Pro_Utility_getLargess_Desc(A.DLID,'LIST')+'(��ţ�'+CONVERT(NVARCHAR,a.DLid)+')' ELSE A.ListDesc+'(��ţ�'+CONVERT(NVARCHAR,a.DLid)+')' END ListDesc,
		CASE ISNULL(a.DetailDesc,'') WHEN '' THEN Promotion.func_Pro_Utility_getLargess_Desc(A.DLID,'DETAIL')  ELSE A.DetailDesc END DetailDesc,
		a.LargessAmount - OrderAmount + OtherAmount LeftAmount 
		FROM promotion.PRO_DEALER_LARGESS A
		WHERE BU = @BU AND GiftType = @LARGESSTYPE AND DEALERID = @DEALERID
		AND LargessAmount - OrderAmount + OtherAmount > 0 
	END
	ELSE
	BEGIN	--��ûд
		INSERT INTO @temp(DLID,ListValue,Description,LeftNum) 
		SELECT A.DLid,
		'����'+CONVERT(NVARCHAR,A.BU) ListDesc,
		'����'+CONVERT(NVARCHAR,A.BU) ListDesc,
		a.LargessAmount - OrderAmount + OtherAmount LeftAmount 
		FROM promotion.PRO_DEALER_LARGESS A
		WHERE BU = @BU AND GiftType = @LARGESSTYPE AND DEALERID = @DEALERID
		AND LargessAmount - OrderAmount + OtherAmount > 0
	END
	
	RETURN
END



GO


