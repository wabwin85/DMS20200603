DROP view [interface].[V_I_Wechat_GetUsageInfo]
GO

CREATE view [interface].[V_I_Wechat_GetUsageInfo]
as
select bwu.BWU_DealerName as ����������,bwu.BWU_DealerType as ����������,
bwu.BWU_UserName as �û���,bwu.BWU_NickName �ǳ�,  WOL_OperatTime as ����ʱ��,   WOL_OperatMenu as �˵����,
case 
when WOL_OperatMenu='M1001' then '�ɹ����'
when WOL_OperatMenu='M1002' then '��ʱ�Դ��'
when WOL_OperatMenu='M1003' then '����ѯ'
when WOL_OperatMenu='M1004' then '�¹��ܽ���'
when WOL_OperatMenu='M1005' then '�ʾ����'
when WOL_OperatMenu='M2006' then '��������'
when WOL_OperatMenu='M2001' then 'Ͷ�߽���'
when WOL_OperatMenu='M2003' then '΢��Ϣ'
when WOL_OperatMenu='M2004' then '���߷���'
when WOL_OperatMenu='M2005' then '��ϵ����'
when WOL_OperatMenu='M3001' then '���߷���'
when WOL_OperatMenu='M3002' then 'ÿ��ǩ��'
when WOL_OperatMenu='M3003' then '�ҵ�΢��'
when WOL_OperatMenu='M3005' then '�ʾ����'
when WOL_OperatMenu='M3004' then '��΢����' end as  �˵�,
case
when WOL_OperatMenu='M1001' then '��������'
when WOL_OperatMenu='M1002' then '��������'
when WOL_OperatMenu='M1003' then '��������'
when WOL_OperatMenu='M1004' then '��������'
when WOL_OperatMenu='M1005' then '�Խ��'
when WOL_OperatMenu='M2006' then '������΢'
when WOL_OperatMenu='M2001' then '������΢'
when WOL_OperatMenu='M2003' then '������΢'
when WOL_OperatMenu='M2004' then '������΢'
when WOL_OperatMenu='M2005' then '������΢'
when WOL_OperatMenu='M3001' then '�Խ��'
when WOL_OperatMenu='M3002' then '�Խ��'
when WOL_OperatMenu='M3003' then '�Խ��'
when WOL_OperatMenu='M3005' then '�Խ��'
when WOL_OperatMenu='M3004' then '�Խ��' end as  �ϼ��˵�
from dbo.WechatOperatLog a
inner join BusinessWechatUser bwu on bwu.BWU_ID= a.WOL_BWU_ID




GO


