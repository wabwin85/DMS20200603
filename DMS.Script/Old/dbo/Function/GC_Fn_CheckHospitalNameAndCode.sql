DROP FUNCTION [dbo].[GC_Fn_CheckHospitalNameAndCode]
GO

CREATE FUNCTION [dbo].[GC_Fn_CheckHospitalNameAndCode]()
RETURNS BIT
AS 
BEGIN
    IF (EXISTS(select HOS_HospitalName from Hospital where HOS_DeletedFlag=0 and HOS_ActiveFlag=1 group by HOS_HospitalName having count(*)>1)
        or EXISTS(select HOS_Key_Account from Hospital where HOS_DeletedFlag=0 group by  HOS_Key_Account having count(*)>1))
        RETURN 0
    
    RETURN 1
END
GO


