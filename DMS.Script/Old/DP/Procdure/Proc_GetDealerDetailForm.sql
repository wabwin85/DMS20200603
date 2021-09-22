DROP PROCEDURE [DP].[Proc_GetDealerDetailForm]
GO


/**********************************************
 功能：获取每个大类的所有相关信息，为提高速度集中进行查询
 作者：宋卫铭
 最后更新时间：2012-07-03
 更新记录说明：
 1.创建 2012-07-03
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


