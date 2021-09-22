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

/*��ȡ�û��ĵȼ�*/
select @level = Attribute_level from Lafite_ATTRIBUTE 
where Id = (select MAP_ID from Lafite_IDENTITY_MAP where map_type = 'Organization'
and IDENTITY_ID = @UserId)

set @cnt = 0;
	/*����û��ȼ�С��3�������²��ң��Ƿ���Ȩ�޲鿴�˲�Ʒ��*/
  if(@level < 3)
    begin
      select @cnt = count(*) from Lafite_ATTRIBUTE where Id in (
        select AttributeID from Cache_OrganizationUnits 
          where RootID = (select MAP_ID from Lafite_IDENTITY_MAP where map_type = 'Organization'
                        and IDENTITY_ID = @UserId))
        and ATTRIBUTE_LEVEL = 3 and Id = @BUM_ID
    end
  /*����û��ȼ�����3����ȡ�û������Ĳ�Ʒ�ߣ��ж��Ƿ��봫��Ĳ�Ʒ����ͬ*/  
  else if(@level = 3)
    begin
      select @cnt = count(*) from Lafite_ATTRIBUTE where Id in (
        select AttributeID from Cache_OrganizationUnits 
          where RootID = (select MAP_ID from Lafite_IDENTITY_MAP where map_type = 'Organization'
                        and IDENTITY_ID = @UserId))
        and ATTRIBUTE_LEVEL = 3 and Id = @BUM_ID
    end
  /*����û��ȼ�����3�������ϲ��ң��Ƿ��ڴ˲�Ʒ�ߵ��¼�*/
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


