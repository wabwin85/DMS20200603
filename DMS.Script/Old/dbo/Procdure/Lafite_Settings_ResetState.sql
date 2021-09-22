DROP procedure [dbo].[Lafite_Settings_ResetState]
GO


CREATE procedure [dbo].[Lafite_Settings_ResetState](@title varchar(50))
as begin
  declare @settingId int
  declare @updatedate datetime
  select top 1 @settingId =SettingId from dbo.Lafite_Settings where Title= @title
  if(@settingId is not null )  
  begin
	select @updatedate = GetDate() ;
		WITH Dependencys(SettingId, Title,[State],Dependency) AS 
		(
		  SELECT SettingId, Title,[State],Dependency from dbo.Lafite_Settings where  SettingId = 5
		  UNION ALL
		  SELECT S.SettingId, S.Title,S.[State],S.Dependency from dbo.Lafite_Settings S, Dependencys D
		  where ','+S.Dependency+',' like '%,'+convert(varchar(36),D.SettingID)+',%' and S.[State]=1
		)

		update dbo.Lafite_Settings set [State] =0,LastUpdateDate=@updatedate 
		--select * from dbo.Lafite_Settings
		where  [State] = 1  and exists(select 1 from Dependencys D where D.SettingId = dbo.Lafite_Settings.SettingId)
		return @@rowcount
  end
end



GO


