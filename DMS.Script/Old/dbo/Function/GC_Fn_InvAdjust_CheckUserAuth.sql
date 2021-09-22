DROP FUNCTION [dbo].[GC_Fn_InvAdjust_CheckUserAuth]
GO

CREATE FUNCTION [dbo].[GC_Fn_InvAdjust_CheckUserAuth] (
   @UserId    UNIQUEIDENTIFIER
   )
   RETURNS TINYINT
AS
   BEGIN
      DECLARE @RtnVal   TINYINT
      DECLARE @IsDealer INT    --1是经销商用户，0不是经销商用户
      DECLARE @IsOpenDate INT  --1为开放，0为不开放
      
      --是否是经销商用户（1是，0否）
      select @IsDealer = Case When substring(IDENTITY_CODE,len(IDENTITY_CODE)-1,Len(IDENTITY_CODE))='99' then 0 else 1 end
        from Lafite_IDENTITY where Id= @UserId
      
      --判断当前日期是否是放开其他入库时间段
      select @IsOpenDate = count(*)
        from CalendarDate 
       where CDD_Calendar= Convert(nvarchar(4),Datename(year,GetDate()))+Convert(nvarchar(2),Datename(month,GetDate()))
         and CDD_Date5<=Datename(day,GetDate())
         and CDD_Date6>=Datename(day,GetDate())
      
      --如果是经销商用户，且当前不是其他入库功能开放时间段，则返回0，否则返回1
      IF (@IsDealer =1 and @IsOpenDate = 0)
        SET @RtnVal = 0     
      ELSE
        SET @RtnVal = 1
                   
      IF @RtnVal IS NULL
         SET @RtnVal = 0

      RETURN @RtnVal
   END

GO


