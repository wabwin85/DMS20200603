DROP FUNCTION [Promotion].[func_Pro_Utility_getPolicyTableName]
GO



/**********************************************
 ����:��������IDȡ�ü������
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-08-28
 ���¼�¼˵����
 1.���� 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_Utility_getPolicyTableName]( 
	@PolicyId INT, --����id
	@TableType NVARCHAR(10)	--�����ͣ���ʽ��REP�������TMP��Ԥ���CAL��
	)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @iTableName NVARCHAR(50)
	SET @iTableName = 'Promotion.TPRO_'+@TableType+'_'+RIGHT('000'+CONVERT(NVARCHAR,@PolicyId),4)
	
	RETURN @iTableName
END



GO


