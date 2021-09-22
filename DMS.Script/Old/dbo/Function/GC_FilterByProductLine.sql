DROP FUNCTION [dbo].[GC_FilterByProductLine] 
GO


CREATE FUNCTION [dbo].[GC_FilterByProductLine] 
(
   @UserId UNIQUEIDENTIFIER,
   @BUM_ID UNIQUEIDENTIFIER
)
RETURNS bit
AS
BEGIN
DECLARE @result bit
DECLARE @level int
DECLARE @cnt int

/*获取用户的等级*/
select @level = Attribute_level from Lafite_ATTRIBUTE 
where Id = (select MAP_ID from Lafite_IDENTITY_MAP where map_type = 'Organization'
and IDENTITY_ID = @UserId)

set @cnt = 0;
	/*如果用户等级小于3，则往下查找，是否有权限查看此产品线*/
  if(@level < 3)
    begin
      select @cnt = count(*) from Lafite_ATTRIBUTE where Id in (
        select AttributeID from Cache_OrganizationUnits 
          where RootID = (select MAP_ID from Lafite_IDENTITY_MAP where map_type = 'Organization'
                        and IDENTITY_ID = @UserId))
        and ATTRIBUTE_LEVEL = 3 and Id = @BUM_ID
    end
  /*如果用户等级等于3，则取用户所属的产品线，判断是否与传入的产品线相同*/  
  else if(@level = 3)
    begin
      select @cnt = count(*) from Lafite_ATTRIBUTE where Id in (
        select AttributeID from Cache_OrganizationUnits 
          where RootID = (select MAP_ID from Lafite_IDENTITY_MAP where map_type = 'Organization'
                        and IDENTITY_ID = @UserId))
        and ATTRIBUTE_LEVEL = 3 and Id = @BUM_ID
    end
  /*如果用户等级大于3，则往上查找，是否在此产品线的下级*/
  else if(@level > 3)
    begin
      select @cnt = count(*) from Lafite_ATTRIBUTE where Id in (
          select rootid from Cache_OrganizationUnits 
          where AttributeID = (select MAP_ID from Lafite_IDENTITY_MAP where map_type = 'Organization'
                        and IDENTITY_ID = @UserId))
         and ATTRIBUTE_LEVEL = 3 and Id = @BUM_ID
    end
    
  if(@cnt <> 0)
  begin
    set @result = 1;
    GOTO Cleanup	
  end
  
  	RETURN 0
	
Cleanup: 
	RETURN @result;
END

GO


