DROP proc [dbo].[GC_Interface_Promotion_Backup_Indicator]
GO



CREATE proc [dbo].[GC_Interface_Promotion_Backup_Indicator]
as
Insert into [interface].[T_I_Promotion_Dealer_Quota_B_Backup]
select * from [interface].[T_I_QV_Dealer_Quota_B]



GO


