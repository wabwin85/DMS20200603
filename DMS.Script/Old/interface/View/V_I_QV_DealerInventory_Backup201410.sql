DROP view [interface].[V_I_QV_DealerInventory_Backup201410]
GO























CREATE view [interface].[V_I_QV_DealerInventory_Backup201410]
as
--�Ƿ���Ҫ����ͣ�þ����̵Ŀ��
select * from (
		select	
			 ID=i.ID
			,DealerID=[DealerID]
			,ParentDealerID=DMA_Parent_DMA_ID
			,Dealer=DMA_ChineseName
			,WHM_Code=WHM_Code
			,i.WHM_Type
			,i.UPN
			,LOT
			,EXPDate
			,QTY=case when DMA_SAP_Code='162878' and Division<>'Endo' then 0
			          --then case when Division='Endo' then Qty else 0 end
		              when DMA_SAP_Code='3106' and Division='Endo' then 0 
			          else Qty end
			,PurchasePrice
			,PurchaseAmount=PurchasePrice*Qty
			,InvDate=GETDATE()
		    ,[Month]=DATEPART(month,getdate())
		    ,[Year]=DATEPART(year,getdate())
			,Division
			,DivisionID=b.DivisionID
			,Province=WHM_Province
			,ProvinceID=TER_ID
			,Region=''
			,RegionID=''
			,InventoryStatus=IsForReceipt
			,SAPID=DMA_SAP_Code
			,ParentSAPID=(select DMA_SAP_Code from DealerMaster dm where dm.DMA_ID=d.DMA_Parent_DMA_ID)
	,case when IsForReceipt=0 and  DMA_DealerType='LP'
                --and i.WHM_Type='Normal' and i.WHM_Name=N'���ƽ����'
                and i.WHM_Type='Borrow'
                then 1 --ƽ̨�в��Ƶļ��ۻ�
		   when IsForReceipt=0 and DMA_DealerType='LP'
		        and i.WHM_Type in ('Normal','DefaultWH')
		        --and i.WHM_Name<>N'���ƽ����' 
		        then 2 --ƽ̨��ƽ̨�����ɹ���
		  when IsForReceipt=0 and DMA_DealerType='T1' and i.WHM_Type in ('Normal','DefaultWH')
		        then 3   --һ����һ���ɹ���
          when IsForReceipt=0 and DMA_DealerType='T1' 
          --and i.WHM_Type not in ('Normal','DefaultWH')
          and i.WHM_Type='Borrow'
		        then 4   --һ���Ĳ��ƽ����
		   when IsForReceipt=0 and DMA_DealerType='T2' and i.WHM_Type in ('Normal','DefaultWH')
		        then 5   --�����Ķ����ɹ���
		   when  IsForReceipt=0 and DMA_DealerType='T2'
		         --and i.WHM_Type='LP_Consignment' and i.WHM_Name like '%����%'
		         and i.WHM_Type='Consignment'
		         then 6  --�����Ĳ��Ƽ��ۻ�
		   when  IsForReceipt=0 and DMA_DealerType='T2' 
		         and i.WHM_Type='LP_Consignment'
		          --and i.WHM_Name not like '%����%'
		         then 7  --������ƽ̨���ۻ�
		   when  IsForReceipt=1 and DMA_DealerType='LP' and 
				 --i.WHM_Type='Normal' and i.WHM_Name=N'���ƽ����'
				 i.WHM_Type='Borrow'
		         then 8  --����ƽ̨�Ĳ��Ƽ��ۻ�
	       when IsForReceipt=1 and DMA_DealerType='LP'
		        and i.WHM_Type in ('Normal','DefaultWH')
		        --and i.WHM_Name<>N'���ƽ����'
		        then 9 --ƽ̨�������ɹ���;
		   when IsForReceipt=1 and DMA_DealerType='T1'
		        and i.WHM_Type in ('Normal','DefaultWH') and PRH_Type='PurchaseOrder'
		        then 10 --T1�����̵������ɹ���
		   when IsForReceipt=1 and DMA_DealerType='T1'
		        and PRH_Type='Rent'
		        then 11 --T1�����̼�Ľ��
		   when IsForReceipt=1 and DMA_DealerType='T1'
		        and i.WHM_Type not in ('Normal','DefaultWH')
		        then 12 --T1�����̴��Ĳ��ƽ��
		   when IsForReceipt=1 and DMA_DealerType='T2' and i.WHM_Type in ('Normal','DefaultWH')
		         and PRH_Type='PurchaseOrder' then 13   --T2�����̵������ɹ���
           when  IsForReceipt=1 and DMA_DealerType='T2'
                 --and i.WHM_Type='LP_Consignment' and i.WHM_Name like '%����%'
                 and i.WHM_Type='Consignment'
                 then 14 --T2�����̴��Ĳ��Ƽ��ۻ�
           when  IsForReceipt=1 and DMA_DealerType='T2' 
		         and i.WHM_Type='LP_Consignment'
		          --and i.WHM_Name not like  '%����%'
		         then 15 --T2������ƽ̨�ļ��ۻ�
           when IsForReceipt=1 and DMA_DealerType='T2' and PRH_Type='Rent'
		        then 16   --T2�����̼�Ľ��
		   when IsForReceipt=2 and DMA_DealerType='LP' and PRH_Type='GoodsReturn' and i.WHM_Type in ('Borrow','Consignment')
		        then 17   --LP�˻�����(������Ȩ)
		    when IsForReceipt=2 and DMA_DealerType='LP' and PRH_Type='GoodsReturn' and i.WHM_Type in ('DefaultWH','Normal')
		        then 18   --LP�˻�����(LP��Ȩ)
		   when IsForReceipt=2 and DMA_DealerType='T1' and PRH_Type='GoodsReturn' and i.WHM_Type in ('DefaultWH','Normal')
		        then 19   --T1�˻�����(������Ȩ)
		    when IsForReceipt=2 and DMA_DealerType='T1' and PRH_Type='GoodsReturn' and i.WHM_Type in ('Borrow','Consignment')
		        then 20   --T1�˻�����(T1��Ȩ)
		   when IsForReceipt=2 and DMA_DealerType='T2' and PRH_Type='GoodsReturn'  and i.WHM_Type in ('DefaultWH','Normal')
		        then 21   --T2�˻�����(T2��Ȩ)
		   when IsForReceipt=2 and DMA_DealerType='T2' and PRH_Type='GoodsReturn' and i.WHM_Type in ('Consignment')
		        then 22   --T2�˻�����(������Ȩ)
		   when IsForReceipt=2 and DMA_DealerType='T2' and PRH_Type='GoodsReturn' and i.WHM_Type in ('Borrow','LP_Consignment')
		        then 23   --T2�˻�����(ƽ̨��Ȩ)
           else 0 end as InventoryTypeID
			,ExpYear=YEAR(EXPDate)
			,ExpMonth=MONTH(EXPDate)
			,Aging=convert(decimal(10,2),DATEDIFF(Day,GETDATE(),EXPDate)/30.0)
  FROM interface.V_I_CR_Inventory_Backup201410 i
  left join DealerMaster d on d.DMA_ID=[DealerID]
  left join Warehouse on WHM_ID=LocationID
  left join interface.T_I_CR_Product b on b.UPN=i.UPN
  left join interface.T_I_CR_Division c on c.DivisionID=b.DivisionID
  left join Territory a on WHM_Province=a.TER_Description and a.TER_Type='Province'
  where i.InvType=0 --and DMA_ActiveFlag=1
) as inv
where QTY<>0



















GO


