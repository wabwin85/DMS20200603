DROP PROCEDURE [DP].[Proc_GetDealerDetailForm]
GO


/**********************************************
 ���ܣ���ȡÿ����������������Ϣ��Ϊ����ٶȼ��н��в�ѯ
 ���ߣ�������
 ������ʱ�䣺2012-07-03
 ���¼�¼˵����
 1.���� 2012-07-03
**********************************************/
CREATE PROCEDURE [DP].[Proc_GetDealerDetailForm]
	@DealerId UNIQUEIDENTIFIER,
	@ThirdClass UNIQUEIDENTIFIER,
	@VersionId NVARCHAR(100),
	@UserId UNIQUEIDENTIFIER
AS
BEGIN
	--ContentAll
	SELECT a.ContentID,
	       a.ControlID,
	       a.ContentType,
	       a.ContentLeble,
	       a.ContentWidth,
	       a.ContentHight,
	       a.ColumnSite,
	       a.RowSite,
	       c.CM_ColumnID
	FROM   DP.DPContent a
	       INNER JOIN DP.ColumnMapping c
	            ON  a.ContentID = c.ContentID
	WHERE  a.IsAction = 'true'
	       AND a.IsDeleted = 'false'
	       AND a.ModleID = @ThirdClass
	
	IF ISNULL(@VersionId, '') = ''
	BEGIN
	    SELECT 'A'
	    WHERE  1 = 2
	END
	ELSE
	BEGIN
	    SELECT *
	    FROM   DP.DealerMaster
	    WHERE  DealerId = @DealerId
	           AND ModleID = @ThirdClass
	           AND [Version] = @VersionId
	END
END
GO


