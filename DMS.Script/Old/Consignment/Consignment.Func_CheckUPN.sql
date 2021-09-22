

/*
1. 功能名称：寄售合同申请添加产品 UPN重复验证
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create FUNCTION [Consignment].[Func_CheckUPN]
(
	@Dealer uniqueidentifier,
	@BeginDate Datetime,
	@EndDate Datetime,
	@UPN nvarchar(max)
)
RETURNS nvarchar(max)
AS 
BEGIN
	 declare @OutUPN nvarchar(max)
	 set @OutUPN=''
	 select @OutUPN=stuff((select ','+A.CCD_CfnShortNumber from 
     (select distinct CCD_CfnShortNumber from Consignment.ContractHeader h
      left join Consignment.ContractDetail c on c.CCD_CCH_ID=h.CCH_ID
      where CCH_DMA_ID=@Dealer and CCH_Status in('InApproval','Completed')
      and @BeginDate>=CCH_BeginDate and @EndDate<=CCH_EndDate and CCD_CfnShortNumber in (select * from GC_Fn_SplitStringToTable(@UPN,','))
      )
      A FOR xml PATH('')), 1, 1, '')
      
      IF @OutUPN!=''
        BEGIN
         set @OutUPN='以下UPN, '+@OutUPN+',寄售合同中存在'
        END
	RETURN @OutUPN
END
