DROP PROCEDURE [DP].[Proc_GetDealerDetailGrid]
GO


/**********************************************
 功能：获取每个大类的所有相关信息，为提高速度集中进行查询
 作者：宋卫铭
 最后更新时间：2012-07-03
 更新记录说明：
 1.创建 2012-07-03
**********************************************/
CREATE PROCEDURE [DP].[Proc_GetDealerDetailGrid]
	@DealerId UNIQUEIDENTIFIER,
	@ThirdClass UNIQUEIDENTIFIER,
	@Version NVARCHAR(100),
	@UserId UNIQUEIDENTIFIER,
	@UserType NVARCHAR(100),
	@FilterBu NVARCHAR(100)
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
	       c.CM_ColumnID,
	       ROW_NUMBER() OVER(ORDER BY a.RowSite, a.ColumnSite) ROW_NUMBER
	FROM   DP.DPContent a
	       INNER JOIN DP.ColumnMapping c
	            ON  a.ContentID = c.ContentID
	WHERE  a.IsAction = 'true'
	       AND a.IsDeleted = 'false'
	       AND a.IsQuery = 'true'
	       AND a.ModleID = @ThirdClass
	
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
	ORDER BY a.RowSite, a.ColumnSite
	
	SELECT *,
	       ROW_NUMBER() OVER(ORDER BY ID) AS ROW_NUMBER
	FROM   DP.DealerMaster A
	WHERE  DealerId = @DealerId
	       AND ModleID = @ThirdClass
	       AND (ISNULL(@Version, '') = '' OR A.[Version] = @Version)
	       AND (
	               @UserType = 'User'
	               OR @FilterBu = 'FALSE'
	               OR A.Bu IN (SELECT BB.DivisionName
	                           FROM   View_ProductLine AA,
	                                  V_DivisionProductLineRelation BB
	                           WHERE  EXISTS (
	                                      SELECT 1
	                                      FROM   Lafite_IDENTITY_MAP BB,
	                                             Cache_OrganizationUnits CC
	                                      WHERE  BB.MAP_TYPE = 'Organization'
	                                             AND BB.IDENTITY_ID = @UserId
	                                             AND BB.MAP_ID = CC.RootID
	                                             AND CC.AttributeType = 
	                                                 'Product_Line'
	                                             AND CC.AttributeID = AA.Id
	                                  )
	                                  AND AA.ATTRIBUTE_NAME = BB.ProductLineName)
	           )
	ORDER BY A.SortId
END
GO


