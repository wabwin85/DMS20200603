DROP function [dbo].[fn_GetDeptRemarkForHositpalList]
GO



CREATE function [dbo].[fn_GetDeptRemarkForHositpalList]
 (@HospitalId uniqueidentifier)
returns nvarchar(200)
as
Begin

declare @Hos_Id nvarchar(200)
select top 1 @Hos_Id=HLA_Remark 
from dbo.HospitalList
where HLA_HOS_ID=@HospitalId and HLA_Remark is not null

return isnull(@Hos_Id,'')
end



GO


