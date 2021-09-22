DROP  FUNCTION [dbo].[GC_Fn_GetTerritoryAllParentTable]
GO


--∞—TerritoryHierarchyŒÂ≤„∆Ω∆Ã
CREATE  FUNCTION [dbo].[GC_Fn_GetTerritoryAllParentTable]()
RETURNS @temp TABLE 
(
     Id uniqueidentifier NULL,
	 Code NVARCHAR(200) NULL,
	 Name NVARCHAR(200) NULL,
	 ParentID uniqueidentifier NULL,
	 
	 Id1 uniqueidentifier NULL,
	 Code1 NVARCHAR(200) NULL,
	 Name1 NVARCHAR(200) NULL,
	 ParentID1 uniqueidentifier NULL,
	  
	 Id2 uniqueidentifier NULL,
	 Code2 NVARCHAR(200) NULL,
	 Name2 NVARCHAR(200) NULL,
	 ParentID2 uniqueidentifier NULL,
	 
	 Id3 uniqueidentifier NULL,
	 Code3 NVARCHAR(200) NULL,
	 Name3 NVARCHAR(200) NULL,
	 ParentID3 uniqueidentifier NULL,
	 
	 Id4 uniqueidentifier NULL,
	 Code4 NVARCHAR(200) NULL,
	 Name4 NVARCHAR(200) NULL,
	 ParentID4 uniqueidentifier NULL
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN
    
     --level 4
     insert into @temp(Id4,Code4,Name4,ParentID4)
     select TH_ID,TH_Code,TH_Name,TH_Parent_ID from TerritoryHierarchy as th
     where TH_Level='Province'
     
     --level3
     update @temp set Id3=TH_ID,Code3=TH_Code,Name3=TH_Name,ParentID3=TH_Parent_ID from TerritoryHierarchy as th
     where TH_Level='Area' and ParentID4=th.TH_ID
     
     --level2
     update @temp set Id2=TH_ID,Code2=TH_Code,Name2=TH_Name,ParentID2=TH_Parent_ID from TerritoryHierarchy th
     where TH_Level='Region' and ParentID3=th.TH_ID
     
    --level 1
    update @temp set Id1=TH_ID,Code1=TH_Code,Name1=TH_Name,ParentID1=TH_Parent_ID from TerritoryHierarchy th
    where TH_Level='SubBU' and ParentID2=th.TH_ID
    
    --level
    update @temp set Id=TH_ID,Code=TH_Code,Name=TH_Name,ParentID=TH_Parent_ID from TerritoryHierarchy th
    where TH_Level='BU' and ParentID1=th.TH_ID
        RETURN
    END

GO


