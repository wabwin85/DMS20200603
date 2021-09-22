DROP view [interface].[V_I_Wechat_GetUsageInfo]
GO

CREATE view [interface].[V_I_Wechat_GetUsageInfo]
as
select bwu.BWU_DealerName as 经销商名称,bwu.BWU_DealerType as 经销商类型,
bwu.BWU_UserName as 用户名,bwu.BWU_NickName 昵称,  WOL_OperatTime as 操作时间,   WOL_OperatMenu as 菜单编号,
case 
when WOL_OperatMenu='M1001' then '采购达成'
when WOL_OperatMenu='M1002' then '及时性达标'
when WOL_OperatMenu='M1003' then '库存查询'
when WOL_OperatMenu='M1004' then '新功能建议'
when WOL_OperatMenu='M1005' then '问卷调查'
when WOL_OperatMenu='M2006' then '关于我们'
when WOL_OperatMenu='M2001' then '投诉建议'
when WOL_OperatMenu='M2003' then '微消息'
when WOL_OperatMenu='M2004' then '政策发布'
when WOL_OperatMenu='M2005' then '联系我们'
when WOL_OperatMenu='M3001' then '政策发布'
when WOL_OperatMenu='M3002' then '每日签到'
when WOL_OperatMenu='M3003' then '我的微币'
when WOL_OperatMenu='M3005' then '问卷调查'
when WOL_OperatMenu='M3004' then '无微不至' end as  菜单,
case
when WOL_OperatMenu='M1001' then '进销服务'
when WOL_OperatMenu='M1002' then '进销服务'
when WOL_OperatMenu='M1003' then '进销服务'
when WOL_OperatMenu='M1004' then '进销服务'
when WOL_OperatMenu='M1005' then '淘金币'
when WOL_OperatMenu='M2006' then '服务入微'
when WOL_OperatMenu='M2001' then '服务入微'
when WOL_OperatMenu='M2003' then '服务入微'
when WOL_OperatMenu='M2004' then '服务入微'
when WOL_OperatMenu='M2005' then '服务入微'
when WOL_OperatMenu='M3001' then '淘金币'
when WOL_OperatMenu='M3002' then '淘金币'
when WOL_OperatMenu='M3003' then '淘金币'
when WOL_OperatMenu='M3005' then '淘金币'
when WOL_OperatMenu='M3004' then '淘金币' end as  上级菜单
from dbo.WechatOperatLog a
inner join BusinessWechatUser bwu on bwu.BWU_ID= a.WOL_BWU_ID




GO


