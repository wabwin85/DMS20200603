DROP procedure [dbo].[GC_Interface_DealerInventoryQuery]
GO


CREATE procedure [dbo].[GC_Interface_DealerInventoryQuery]
(
	@DealerCode nvarchar(20),
	@QrCode nvarchar(max)
)
as

BEGIN

create table #tmp_result
(
	DealerCode nvarchar(20) null,
	UPN nvarchar(50) null,
	LOT nvarchar(50) null,
	QRCode nvarchar(50) null,
	GTIN nvarchar(50) null,
	Qty decimal(18,2) null,
	ExpDate nvarchar(10) null,
	DOM nvarchar(10) null,
	IsQRUsable nvarchar(20) null,
	Remark nvarchar(2000) null,
	WHMType nvarchar(20) null
)

insert into #tmp_result(DealerCode,QRCode)
select @DealerCode,* from dbo.GC_Fn_SplitStringToTable(@QrCode,',')

--查找经销商主仓库和寄售库，更新内容

update A
set A.LOT = substring(T.LTM_LotNumber,1,charindex('@',T.LTM_LotNumber)-1),
	ExpDate = CONVERT(nvarchar(10),LTM_ExpiredDate,112),
	DOM = LTM_Type,
	UPN = PMA_UPN,
	GTIN = CFN_Property7
from #tmp_result A inner join LotMaster T
on A.QRCode = substring(T.LTM_LotNumber,charindex('@',T.LTM_LotNumber)+2,len(T.LTM_LotNumber))
left join lot on T.LTM_ID = LOT_LTM_ID
left join inventory on LOT_INV_ID = INV_ID
left join Product on INV_PMA_ID = PMA_ID
left join cfn on PMA_CFN_ID = CFN_ID

;WITH T AS (
     	select WHM_Type,substring(LTM_LotNumber,1,charindex('@',LTM_LotNumber)-1) AS LTM_LotNumber,
     	substring(LTM_LotNumber,charindex('@',LTM_LotNumber)+2,len(LTM_LotNumber)) AS LTM_QrCode,sum(LOT_OnHandQty ) as LOT_OnHandQty
		from DealerMaster,Warehouse,Inventory,Lot,LotMaster
		where DMA_ID = WHM_DMA_ID
		and WHM_ID = INV_WHM_ID
		and INV_ID = LOT_INV_ID
		and LOT_LTM_ID = LTM_ID
		and LOT_OnHandQty > 0
		and DMA_SAP_Code=@DealerCode
		--and WHM_Type not in ('Normal','SystemHold')
		group by WHM_Type,LTM_LotNumber
     	)
      UPDATE A SET --UPN = PMA_UPN,
					--LOT = LTM_LotNumber,
					--ExpDate = CONVERT(nvarchar(10),LTM_ExpiredDate,112),
					--DOM = LTM_Type,
					Qty = LOT_OnHandQty,
					--GTIN = CFN_Property7,
					WHMType = WHM_Type
      FROM #tmp_result A,T
      WHERE A.QRCode = T.LTM_QrCode


UPDATE t1 set IsQRUsable = 'Error',Remark ='经销商编号不正确'  
from #tmp_result t1
left join DealerMaster t2 on t1.DealerCode = t2.DMA_SAP_Code
where t2.DMA_ID is null

update #tmp_result set IsQRUsable = 'Error',Remark ='二维码不正确'
where isnull(LOT,'') = '' AND IsQRUsable IS NULL

update #tmp_result set IsQRUsable = 'Error',Remark ='库存不可用'
where WHMType in ('Normal','SystemHold') AND IsQRUsable IS NULL

update #tmp_result set IsQRUsable = 'Error',Remark ='没有库存'
where isnull(Qty,0) = 0 AND IsQRUsable IS NULL

update #tmp_result set IsQRUsable = 'Active',Remark =''
where IsQRUsable is null


select DealerCode,isnull(UPN,'') as UPN,isnull(LOT,'') as LOT,isnull(QRCode,'') as QRCode,isnull(GTIN,'') as GTIN,isnull(ExpDate,'') as ExpDate,isnull(DOM,'') as DOM,isnull(IsQRUsable,'') as IsQRUsable,isnull(Remark ,'') as Remark
from #tmp_result

END



GO


