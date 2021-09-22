DROP PROCEDURE [dbo].[GC_GETProductLineByUser] 
GO



CREATE PROCEDURE [dbo].[GC_GETProductLineByUser] 
	@UserID varchar(36)
AS
BEGIN
	declare @att_id varchar(36)
	declare @att_level int 

	SELECT @att_id = OU.ID , @att_level = OU.Attribute_Level  
	FROM dbo.Lafite_ATTRIBUTE OU, Lafite_IDENTITY_MAP IM 
	WHERE OU.Id = IM.MAP_ID AND IM.MAP_TYPE='Organization' and IM.IDENTITY_ID = @UserID 
		AND OU.Delete_FLAG = 0 

	if(@att_id is null)
	   RETURN(1)

	if(@att_level = 3 )
	begin
		SELECT OU.ID AttributeId, OU.Attribute_Name AttributeName, OU.Attribute_Type AttributeType, 
		OU.Attribute_Level AttributeLevel FROM dbo.Lafite_ATTRIBUTE OU, Lafite_IDENTITY_MAP IM 
		WHERE OU.Id = IM.MAP_ID AND IM.MAP_TYPE='Organization' and IM.IDENTITY_ID = @UserID 
	end
	else if(@att_level <3)
	begin
		SELECT OU.AttributeId,OU.AttributeName , OU.AttributeType,OU.AttributeLevel
		FROM Cache_OrganizationUnits OU 
		where OU.RootID=@att_id and OU.AttributeType='Product_Line'
	end
	else begin
		SELECT OU.AttributeId, OU.AttributeName , OU.AttributeType,OU.AttributeLevel
		FROM Cache_OrganizationUnits OU 
		where OU.AttributeType='Product_Line' and OU.RootID=OU.AttributeID 
		and exists( select * from Cache_OrganizationUnits a where a.AttributeID=@att_id
		and a.RootId =OU.RootID)
	end

	RETURN(1)
end


GO


