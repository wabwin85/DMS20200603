DROP VIEW  [interface].[V_I_QV_Policy]
GO




CREATE VIEW  [interface].[V_I_QV_Policy]
AS
SELECT [PolicyId]
      ,[PolicyNo]
      ,[PolicyName]
      ,[Description]
      ,[Period]
      ,[StartDate]
      ,[EndDate]
      ,[BU]
      ,[SubBu]
      ,[PolicyClass]--��������
      ,[PolicyGroupName]
      ,[TopType]
      ,[TopValue]
      ,case [CalType] when 'ByDealer' then N'������' when 'ByHospital' then N'ҽԺ' else '' end CalType  --��������
      ,[Status]
      ,[PolicyType]--������ʽ
      ,case when isnull(ifConvert,'N')='Y' then N'ת����' when isnull(ifConvert,'N')='N' then N'��ת��' else N'ת���' end as  ifConvert --�Ƿ�ת����
      ,case when isnull(ifMinusLastGift,'N')='Y' then N'�۳�������Ʒ'  else N'���۳�������Ʒ' end as  ifMinusLastGift --�Ƿ�۳�������Ʒ
	  ,case when isnull(ifAddLastLeft,'N')='Y' then N'�����������'  else N'�������������' end as  ifAddLastLeft --�����������
      ,case when isnull(ifCalPurchaseAR,'N')='Y' then N'��Ʒ������ҵ�ɹ����'  else N'��Ʒ��������ҵ�ɹ����' end as  ifCalPurchaseAR --��������Ʒ�Ƿ�������ҵ�ɹ����
	  ,case when isnull(ifCalSalesAR,'N')='Y' then N'��Ʒ����ֲ����'  else N'��Ʒ������ֲ����' end as  ifCalSalesAR --��������Ʒ�Ƿ�����ֲ����
	  ,case [CarryType] when 'Round' then N'��������' when 'KeepValue' then N'����ԭ��' when 'Ceiling' then N'����ȡ��' when 'Floor' then N'����ȡ��'  else '' end CarryType  --��λ��ʽ
      ,case when isnull(ifIncrement,'N')='Y' then N'��������'  else '' end as  ifIncrement --�Ƿ���������
      ,case when isnull(ifCalRebateAR,'N')='Y' then N'��Ʒ��Ϊ��������'  else N'��Ʒ����Ϊ��������' end as  ifCalRebateAR --�Ƿ���Ϊ��������
      ,PolicyStyle
      ,PolicySubStyle
	  ,[CreateBy]
      ,[CreateTime]
      ,[ModifyBy]
      ,[ModifyDate]
      ,[Remark1]
      ,[Remark2]
      ,[Remark3]
  FROM [Bsc_Prd].[Promotion].[PRO_POLICY]



GO


