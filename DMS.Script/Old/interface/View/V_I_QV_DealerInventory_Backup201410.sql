DROP view [interface].[V_I_QV_DealerInventory_Backup201410]
GO























CREATE view [interface].[V_I_QV_DealerInventory_Backup201410]
as
--是否需要过滤停用经销商的库存
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
                --and i.WHM_Type='Normal' and i.WHM_Name=N'波科借货库'
                and i.WHM_Type='Borrow'
                then 1 --平台中波科的寄售货
		   when IsForReceipt=0 and DMA_DealerType='LP'
		        and i.WHM_Type in ('Normal','DefaultWH')
		        --and i.WHM_Name<>N'波科借货库' 
		        then 2 --平台的平台正常采购货
		  when IsForReceipt=0 and DMA_DealerType='T1' and i.WHM_Type in ('Normal','DefaultWH')
		        then 3   --一级的一级采购库
          when IsForReceipt=0 and DMA_DealerType='T1' 
          --and i.WHM_Type not in ('Normal','DefaultWH')
          and i.WHM_Type='Borrow'
		        then 4   --一级的波科借货库
		   when IsForReceipt=0 and DMA_DealerType='T2' and i.WHM_Type in ('Normal','DefaultWH')
		        then 5   --二级的二级采购库
		   when  IsForReceipt=0 and DMA_DealerType='T2'
		         --and i.WHM_Type='LP_Consignment' and i.WHM_Name like '%波科%'
		         and i.WHM_Type='Consignment'
		         then 6  --二级的波科寄售货
		   when  IsForReceipt=0 and DMA_DealerType='T2' 
		         and i.WHM_Type='LP_Consignment'
		          --and i.WHM_Name not like '%波科%'
		         then 7  --二级的平台寄售货
		   when  IsForReceipt=1 and DMA_DealerType='LP' and 
				 --i.WHM_Type='Normal' and i.WHM_Name=N'波科借货库'
				 i.WHM_Type='Borrow'
		         then 8  --放在平台的波科寄售货
	       when IsForReceipt=1 and DMA_DealerType='LP'
		        and i.WHM_Type in ('Normal','DefaultWH')
		        --and i.WHM_Name<>N'波科借货库'
		        then 9 --平台的正常采购在途
		   when IsForReceipt=1 and DMA_DealerType='T1'
		        and i.WHM_Type in ('Normal','DefaultWH') and PRH_Type='PurchaseOrder'
		        then 10 --T1代理商的正常采购货
		   when IsForReceipt=1 and DMA_DealerType='T1'
		        and PRH_Type='Rent'
		        then 11 --T1代理商间的借货
		   when IsForReceipt=1 and DMA_DealerType='T1'
		        and i.WHM_Type not in ('Normal','DefaultWH')
		        then 12 --T1代理商处的波科借货
		   when IsForReceipt=1 and DMA_DealerType='T2' and i.WHM_Type in ('Normal','DefaultWH')
		         and PRH_Type='PurchaseOrder' then 13   --T2代理商的正常采购货
           when  IsForReceipt=1 and DMA_DealerType='T2'
                 --and i.WHM_Type='LP_Consignment' and i.WHM_Name like '%波科%'
                 and i.WHM_Type='Consignment'
                 then 14 --T2代理商处的波科寄售货
           when  IsForReceipt=1 and DMA_DealerType='T2' 
		         and i.WHM_Type='LP_Consignment'
		          --and i.WHM_Name not like  '%波科%'
		         then 15 --T2代理商平台的寄售货
           when IsForReceipt=1 and DMA_DealerType='T2' and PRH_Type='Rent'
		        then 16   --T2代理商间的借货
		   when IsForReceipt=2 and DMA_DealerType='LP' and PRH_Type='GoodsReturn' and i.WHM_Type in ('Borrow','Consignment')
		        then 17   --LP退货待批(波科物权)
		    when IsForReceipt=2 and DMA_DealerType='LP' and PRH_Type='GoodsReturn' and i.WHM_Type in ('DefaultWH','Normal')
		        then 18   --LP退货待批(LP物权)
		   when IsForReceipt=2 and DMA_DealerType='T1' and PRH_Type='GoodsReturn' and i.WHM_Type in ('DefaultWH','Normal')
		        then 19   --T1退货待批(波科物权)
		    when IsForReceipt=2 and DMA_DealerType='T1' and PRH_Type='GoodsReturn' and i.WHM_Type in ('Borrow','Consignment')
		        then 20   --T1退货待批(T1物权)
		   when IsForReceipt=2 and DMA_DealerType='T2' and PRH_Type='GoodsReturn'  and i.WHM_Type in ('DefaultWH','Normal')
		        then 21   --T2退货待批(T2物权)
		   when IsForReceipt=2 and DMA_DealerType='T2' and PRH_Type='GoodsReturn' and i.WHM_Type in ('Consignment')
		        then 22   --T2退货待批(波科物权)
		   when IsForReceipt=2 and DMA_DealerType='T2' and PRH_Type='GoodsReturn' and i.WHM_Type in ('Borrow','LP_Consignment')
		        then 23   --T2退货待批(平台物权)
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


