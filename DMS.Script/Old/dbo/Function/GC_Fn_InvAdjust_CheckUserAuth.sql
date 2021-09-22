DROP FUNCTION [dbo].[GC_Fn_InvAdjust_CheckUserAuth]
GO

CREATE FUNCTION [dbo].[GC_Fn_InvAdjust_CheckUserAuth] (
   @UserId    UNIQUEIDENTIFIER
   )
   RETURNS TINYINT
AS
   BEGIN
      DECLARE @RtnVal   TINYINT
      DECLARE @IsDealer INT    --1�Ǿ������û���0���Ǿ������û�
      DECLARE @IsOpenDate INT  --1Ϊ���ţ�0Ϊ������
      
      --�Ƿ��Ǿ������û���1�ǣ�0��
      select @IsDealer = Case When substring(IDENTITY_CODE,len(IDENTITY_CODE)-1,Len(IDENTITY_CODE))='99' then 0 else 1 end
        from Lafite_IDENTITY where Id= @UserId
      
      --�жϵ�ǰ�����Ƿ��Ƿſ��������ʱ���
      select @IsOpenDate = count(*)
        from CalendarDate 
       where CDD_Calendar= Convert(nvarchar(4),Datename(year,GetDate()))+Convert(nvarchar(2),Datename(month,GetDate()))
         and CDD_Date5<=Datename(day,GetDate())
         and CDD_Date6>=Datename(day,GetDate())
      
      --����Ǿ������û����ҵ�ǰ����������⹦�ܿ���ʱ��Σ��򷵻�0�����򷵻�1
      IF (@IsDealer =1 and @IsOpenDate = 0)
        SET @RtnVal = 0     
      ELSE
        SET @RtnVal = 1
                   
      IF @RtnVal IS NULL
         SET @RtnVal = 0

      RETURN @RtnVal
   END

GO


