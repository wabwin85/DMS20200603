SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
ALTER PROCEDURE [dbo].[GC_LPInventoryAnalytics]
AS
	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

declare @sumCOGS decimal(18,6);
declare @sumCount float;
declare @dmaid uniqueidentifier;
declare @divisionname nvarchar(200)

--删除本月已生成的记录
delete from LPInventoryAnalytics
where Convert(nvarchar(6),LIA_CreateDate ,112) =  Convert(nvarchar(6),Getdate() ,112)

create table #LPInventoryAnalytics
	(
		LIA_DivisionName nvarchar(200) collate Chinese_PRC_CI_AS,
		LIA_UPN nvarchar(50) collate Chinese_PRC_CI_AS,
		LIA_DMA_ID uniqueidentifier ,
		LIA_Month01 int ,
		LIA_Month02 int ,
		LIA_Month03 int ,
		LIA_Month04 int ,
		LIA_Month05 int ,
		LIA_Month06 int ,
		LIA_Total float ,   --前6个月总销量
		LIA_PercentCount decimal(18,6), --占总销量百分比
		LIA_SumPercentCount decimal(18,6), --累计占总销量百分比
		LIA_LBM float,      --销售成本金额
		LIA_TotalCOGS float,--总销售成本金额
		LIA_PercentCOGS decimal(18,6),--销售成本金额占总销售成本金额百分比
		LIA_CumCOGS float,  
		LIA_COGSABC nvarchar(2) collate Chinese_PRC_CI_AS,--金额ABC
		LIA_Freq nvarchar(2) collate Chinese_PRC_CI_AS,   --采购频率
		LIA_FABC nvarchar(2) collate Chinese_PRC_CI_AS,   --频率ABC
		LIA_SABC nvarchar(2) collate Chinese_PRC_CI_AS,   --销量ABC
		LIA_RFABC nvarchar(3) collate Chinese_PRC_CI_AS,  --ABC
		LIA_Type nvarchar(2) collate Chinese_PRC_CI_AS,
		LIA_BUM_ID uniqueidentifier,
		LIA_CreateDate datetime,
		LIA_LineNbr int
	)
	
create table #tmp_upnqty(
TU_Upn nvarchar(20) collate Chinese_PRC_CI_AS,
TU_Qty float,
TU_Date nvarchar(6) collate Chinese_PRC_CI_AS,
TU_DMA_ID uniqueidentifier
)

--获取所有产品信息
INSERT INTO #LPInventoryAnalytics(LIA_DivisionName,LIA_UPN,LIA_DMA_ID,LIA_Month01,LIA_Month02,LIA_Month03,LIA_Month04,LIA_Month05,LIA_Month06,LIA_BUM_ID,LIA_CreateDate,lIA_LineNbr)
select DivisionName,CFN_CustomerFaceNbr,DMA_ID,0,0,0,0,0,0,CFN_ProductLine_BUM_ID,GETDATE(),ROW_NUMBER() over(order by dma_id,DivisionName,CFN_CustomerFaceNbr) 
from
(SELECT (case when DivisionName='Cardio' then CFN_Level2Desc else DivisionName end) as DivisionName,CFN_CustomerFaceNbr,DMA_ID,CFN_ProductLine_BUM_ID
FROM CFN,(SELECT DISTINCT DMA_ID from V_DealerContractMaster WHERE DealerType='LP' AND ActiveFlag=1) DC,V_DivisionProductLineRelation
where CFN_ProductLine_BUM_ID = ProductLineID
) tab

----获取所有产品信息
--INSERT INTO #LPInventoryAnalytics(LIA_DivisionName,LIA_UPN,LIA_DMA_ID,LIA_Month01,LIA_Month02,LIA_Month03,LIA_Month04,LIA_Month05,LIA_Month06,LIA_BUM_ID,LIA_CreateDate,lIA_LineNbr)
--select DivisionName,CFN_CustomerFaceNbr,DMA_ID,0,0,0,0,0,0,CFN_ProductLine_BUM_ID,GETDATE(),ROW_NUMBER() over(order by dma_id,DivisionName,CFN_CustomerFaceNbr) 
--from
--(SELECT (case when DivisionName='Cardio' then CFN_Level2Desc else DivisionName end) as DivisionName,CFN_CustomerFaceNbr,DMA_ID,CFN_ProductLine_BUM_ID
--FROM CFN,DealerMaster,V_DivisionProductLineRelation
--where DMA_DealerType ='LP'
--and CFN_ProductLine_BUM_ID = ProductLineID
--and DMA_ActiveFlag = 1
--) tab

update t1
set t1.LIA_DivisionName = (case when vd.DivisionName='Cardio' then CFN_Level2Desc else vd.DivisionName end)
FROM #LPInventoryAnalytics t1 inner join DealerMaster 
on LIA_DMA_ID = DMA_ID
inner join V_DivisionProductLineRelation vd
on LIA_BUM_ID = vd.ProductLineID
inner join Product on LIA_UPN = PMA_UPN
inner join CFN on PMA_CFN_ID = CFN_ID


--获取平台的产品信息
insert into #tmp_upnqty
select upn,SUM(QTY),feecalendar,ParentDealerID
from (
select upn,QTY,CONVERT(nvarchar(6),Transaction_Date,112) as feecalendar,ParentDealerID from interface.V_I_QV_LPSales_WithQR
where DealerLevel = 'T2'
--and Staus in ('Complete','Accept')
and CONVERT(nvarchar(6),Transaction_Date,112) >= CONVERT(nvarchar(6),dateadd(month,-6,GETDATE()),112)
and isnull(Selltype,0)<>3
) tab
group by upn,feecalendar,ParentDealerID

----获取平台的产品信息
--insert into #tmp_upnqty
--select upn,SUM(QTY),feecalendar,ParentDealerID
--from (
--select upn,QTY,CONVERT(nvarchar(6),interfaceuploaddate,112) as feecalendar,ParentDealerID from interface.V_I_QV_LPSales
--where DealerLevel = 'T2'
--and Staus in ('Complete','Accept')
--and CONVERT(nvarchar(6),interfaceuploaddate,112) >= CONVERT(nvarchar(6),dateadd(month,-6,GETDATE()),112)
--) tab
--group by upn,feecalendar,ParentDealerID
--select CFN_CustomerFaceNbr,SUM(qty),feecalendar,DMA_ID from 
--(
--select c.CFN_CustomerFaceNbr,prl.PRL_ReceiptQty as qty,CONVERT(nvarchar(6),PRH_ReceiptDate,112) as feecalendar,DMA_ID 
--from POReceiptHeader prh,POReceipt por,POReceiptLot prl,DealerMaster dm,Product p,CFN c,Warehouse w
--where prh.PRH_ID = por.POR_PRH_ID
--and por.POR_ID = prl.PRL_POR_ID
--and prh.PRH_Dealer_DMA_ID = dm.DMA_ID
--and por.POR_SAP_PMA_ID = p.PMA_ID
--and p.PMA_CFN_ID = c.CFN_ID
--and w.WHM_ID = PRH_WHM_ID
--and prh.PRH_Type = 'PurchaseOrder'
--and dm.DMA_DealerType = 'LP'
--and dm.DMA_ActiveFlag = 1
--and PRH_Status='Complete'
--and (w.WHM_Type = 'DefaultWH' or PRH_FromWHM_ID is null)
--and CONVERT(nvarchar(6),PRH_ReceiptDate,112) >= CONVERT(nvarchar(6),dateadd(month,-6,GETDATE()),112)
--union
--select CFN_CustomerFaceNbr,POD_RequiredQty ,CONVERT(nvarchar(6),POH_SubmitDate,112) as feecalendar,DMA_ID
--from PurchaseOrderHeader ,PurchaseOrderDetail,CFN,DealerMaster
--where POH_OrderType='ClearBorrowManual'
--and POH_ID = POD_POH_ID
--and POD_CFN_ID = CFN_ID
--and POH_DMA_ID = DMA_ID
--and DMA_DealerType = 'LP'
--and DMA_ActiveFlag = 1
--and POH_OrderStatus = 'Completed'
--and CONVERT(nvarchar(6),POH_SubmitDate,112) >= CONVERT(nvarchar(6),dateadd(month,-6,GETDATE()),112)
--union
--select CFN_CustomerFaceNbr,IAL_LotQty, CONVERT(nvarchar(6),IAH_ApprovalDate,112),DMA_ID
--from InventoryAdjustHeader,InventoryAdjustDetail,InventoryAdjustLot,DealerMaster,Product,CFN
--where IAH_Reason = 'Return'
--and IAH_ID = IAD_IAH_ID
--and IAD_ID = IAL_IAD_ID
--and IAH_DMA_ID = DMA_ID
--and IAD_PMA_ID = PMA_ID
--and PMA_CFN_ID = CFN_ID
--and DMA_DealerType = 'LP'
--and DMA_ActiveFlag = 1
--and IAH_Status = 'Accept'
--and CONVERT(nvarchar(6),IAH_ApprovalDate,112) >= CONVERT(nvarchar(6),dateadd(month,-6,GETDATE()),112)
--) tab
--group by CFN_CustomerFaceNbr,feecalendar,DMA_ID

--更新过去6个月平台的产品信息
update t1
set LIA_Month01 = t2.TU_Qty
from #LPInventoryAnalytics t1,#tmp_upnqty t2
where t1.LIA_UPN = t2.TU_Upn
and t1.LIA_DMA_ID = t2.TU_DMA_ID
and t2.TU_Date = CONVERT(nvarchar(6),dateadd(month,-6,GETDATE()),112)

update t1
set LIA_Month02 = t2.TU_Qty
from #LPInventoryAnalytics t1,#tmp_upnqty t2
where t1.LIA_UPN = t2.TU_Upn
and t1.LIA_DMA_ID = t2.TU_DMA_ID
and t2.TU_Date = CONVERT(nvarchar(6),dateadd(month,-5,GETDATE()),112)

update t1
set LIA_Month03 = t2.TU_Qty
from #LPInventoryAnalytics t1,#tmp_upnqty t2
where t1.LIA_UPN = t2.TU_Upn
and t1.LIA_DMA_ID = t2.TU_DMA_ID
and t2.TU_Date = CONVERT(nvarchar(6),dateadd(month,-4,GETDATE()),112)

update t1
set LIA_Month04 = t2.TU_Qty
from #LPInventoryAnalytics t1,#tmp_upnqty t2
where t1.LIA_UPN = t2.TU_Upn
and t1.LIA_DMA_ID = t2.TU_DMA_ID
and t2.TU_Date = CONVERT(nvarchar(6),dateadd(month,-3,GETDATE()),112)

update t1
set LIA_Month05 = t2.TU_Qty
from #LPInventoryAnalytics t1,#tmp_upnqty t2
where t1.LIA_UPN = t2.TU_Upn
and t1.LIA_DMA_ID = t2.TU_DMA_ID
and t2.TU_Date = CONVERT(nvarchar(6),dateadd(month,-2,GETDATE()),112)

update t1
set LIA_Month06 = t2.TU_Qty
from #LPInventoryAnalytics t1,#tmp_upnqty t2
where t1.LIA_UPN = t2.TU_Upn
and t1.LIA_DMA_ID = t2.TU_DMA_ID
and t2.TU_Date = CONVERT(nvarchar(6),dateadd(month,-1,GETDATE()),112)

--更新过去6个月的产品合计
update #LPInventoryAnalytics
set LIA_Total = LIA_Month01 + LIA_Month02 + LIA_Month03 + LIA_Month04 + LIA_Month05 + LIA_Month06 


--更新每个产品的价格
--select * from cfnprice
update t1
--set t1.LIA_LBM = isnull(t3.CFNP_Price,0)
   set t1.LIA_LBM = isnull(dbo.fn_GetCfnPriceByDealer( t1.LIA_DMA_ID,t2.CFN_ID,(SELECT SubCompanyId FROM dbo.View_ProductLine
                        WHERE Id=t2.CFN_ProductLine_BUM_ID),(SELECT BrandId FROM dbo.View_ProductLine
                        WHERE Id=天.CFN_ProductLine_BUM_ID), 'Dealer',0),0)
from #LPInventoryAnalytics t1 
inner join CFN t2 on t1.LIA_UPN = t2.CFN_CustomerFaceNbr
left join cfnprice t3
on t2.CFN_ID = t3.CFNP_CFN_ID
and t1.LIA_DMA_ID = t3.CFNP_Group_ID
and t3.CFNP_PriceType = 'Dealer'

--更新产品合计价格
update #LPInventoryAnalytics
set LIA_TotalCOGS = LIA_Total*LIA_LBM

--select * from #LPInventoryAnalytics order by LIA_LineNbr
--按照销量从大到小重新排序
update t1
set t1.LIA_LineNbr = t2.LIA_LineNbr
from #LPInventoryAnalytics t1,
(select LIA_DivisionName,LIA_UPN,LIA_DMA_ID,ROW_NUMBER() over(order by LIA_DMA_ID,LIA_DivisionName,LIA_Total desc,LIA_UPN) as LIA_LineNbr
from #LPInventoryAnalytics) t2
where t1.LIA_DivisionName = t2.LIA_DivisionName
and t1.LIA_UPN = t2.LIA_UPN
and t1.LIA_DMA_ID = t2.LIA_DMA_ID



--统计每个经销商所有产品的总价格

declare curCogs CURSOR
for select sum(LIA_Total) as LIA_Total,LIA_DMA_ID,LIA_DivisionName from #LPInventoryAnalytics group by LIA_DMA_ID,LIA_DivisionName
OPEN curCogs
	FETCH NEXT FROM curCogs INTO @sumCount,@dmaid,@divisionname

	WHILE @@FETCH_STATUS = 0
	BEGIN
		--更新所占百分比
		update #LPInventoryAnalytics
		set LIA_PercentCount = (CASE WHEN @sumCount = 0 THEN 0 ELSE LIA_Total/@sumCount END)
		where LIA_DMA_ID = @dmaid
		and LIA_DivisionName = @divisionname

		
			
    FETCH NEXT FROM curCogs INTO @sumCount,@dmaid,@divisionname
	END

	CLOSE curCogs
	DEALLOCATE curCogs
	
	--更新每一个division的第一个产品销量百分比
	update #LPInventoryAnalytics
		set LIA_SumPercentCount = LIA_PercentCount
		where lIA_LineNbr in (select LIA_LineNbr from 
			(select min(LIA_LineNbr) as LIA_LineNbr,LIA_DMA_ID,LIA_DivisionName from #LPInventoryAnalytics
			group by LIA_DMA_ID,LIA_DivisionName) a
			)

declare @percent float;
declare @linenbr int;
declare @linenbr2 int;
--循环更新cum % COGS
declare curlinenbr CURSOR
for select min(LIA_LineNbr) as LIA_LineNbr,LIA_DMA_ID,LIA_DivisionName from #LPInventoryAnalytics
			group by LIA_DMA_ID,LIA_DivisionName
			order by LIA_LineNbr
			
OPEN curlinenbr
	FETCH NEXT FROM curlinenbr INTO @linenbr,@dmaid,@divisionname
	WHILE @@FETCH_STATUS = 0
	BEGIN

		declare cur CURSOR
		FOR SELECT LIA_LineNbr from #LPInventoryAnalytics 
		where LIA_LineNbr > @linenbr
		and LIA_DMA_ID = @dmaid 
		and LIA_DivisionName = @divisionname
		order by LIA_LineNbr

			OPEN cur
			FETCH NEXT FROM cur INTO @linenbr2

			WHILE @@FETCH_STATUS = 0
			BEGIN
				update t1
				set t1.LIA_SumPercentCount = t1.LIA_PercentCount + t2.LIA_SumPercentCount
				--select *--t1.LIA_PercentCOGS,t1.LIA_CumCOGS,t2.LIA_PercentCOGS,t2.LIA_CumCOGS 
				from #LPInventoryAnalytics t1,#LPInventoryAnalytics t2
				where t1.LIA_LineNbr = @linenbr2 
				and t2.LIA_LineNbr = @linenbr2 - 1
				and t1.LIA_DMA_ID = @dmaid
				and t2.LIA_DMA_ID = @dmaid
				and t1.LIA_DivisionName = @divisionname
				and t2.LIA_DivisionName = @divisionname
				
			FETCH NEXT FROM cur INTO @linenbr2
			END

			CLOSE cur
			DEALLOCATE cur
	
		FETCH NEXT FROM curlinenbr INTO @linenbr,@dmaid,@divisionname
		END

		CLOSE curlinenbr
		DEALLOCATE curlinenbr
		
		


declare curCogs2 CURSOR
for select SUM(LIA_TotalCOGS) as LIA_TotalCOGS,LIA_DMA_ID,LIA_DivisionName from #LPInventoryAnalytics group by LIA_DMA_ID,LIA_DivisionName
OPEN curCogs2
	FETCH NEXT FROM curCogs2 INTO @sumCOGS,@dmaid,@divisionname

	WHILE @@FETCH_STATUS = 0
	BEGIN
		--更新所占百分比
		update #LPInventoryAnalytics
		set LIA_PercentCOGS = (CASE WHEN @sumCOGS = 0 THEN 0 ELSE LIA_TotalCOGS/@sumCOGS END)
		where LIA_DMA_ID = @dmaid
		and LIA_DivisionName = @divisionname
			
    FETCH NEXT FROM curCogs2 INTO @sumCOGS,@dmaid,@divisionname
	END

	CLOSE curCogs2
	DEALLOCATE curCogs2

	
--按照金额从大到小重新排序
update t1
set t1.LIA_LineNbr = t2.LIA_LineNbr
from #LPInventoryAnalytics t1,
(select LIA_DivisionName,LIA_UPN,LIA_DMA_ID,ROW_NUMBER() over(order by LIA_DMA_ID,LIA_DivisionName,LIA_PercentCOGS desc,LIA_UPN) as LIA_LineNbr
from #LPInventoryAnalytics) t2
where t1.LIA_DivisionName = t2.LIA_DivisionName
and t1.LIA_UPN = t2.LIA_UPN
and t1.LIA_DMA_ID = t2.LIA_DMA_ID	

	
	update #LPInventoryAnalytics
		set LIA_CumCOGS = LIA_PercentCOGS
		where lIA_LineNbr in (select LIA_LineNbr from 
			(select min(LIA_LineNbr) as LIA_LineNbr,LIA_DMA_ID,LIA_DivisionName from #LPInventoryAnalytics
			group by LIA_DMA_ID,LIA_DivisionName) a
			)
		
--循环更新SumPercentCount
declare curlinenbr2 CURSOR
for select min(LIA_LineNbr) as LIA_LineNbr,LIA_DMA_ID,LIA_DivisionName from #LPInventoryAnalytics
			group by LIA_DMA_ID,LIA_DivisionName
			order by LIA_LineNbr
			
OPEN curlinenbr2
	FETCH NEXT FROM curlinenbr2 INTO @linenbr,@dmaid,@divisionname
	WHILE @@FETCH_STATUS = 0
	BEGIN

		declare cur2 CURSOR
		FOR SELECT LIA_LineNbr from #LPInventoryAnalytics 
		where LIA_LineNbr > @linenbr
		and LIA_DMA_ID = @dmaid 
		and LIA_DivisionName = @divisionname
		order by LIA_LineNbr

			OPEN cur2
			FETCH NEXT FROM cur2 INTO @linenbr2

			WHILE @@FETCH_STATUS = 0
			BEGIN
				update t1
				set t1.LIA_CumCOGS = t1.LIA_PercentCOGS + t2.LIA_CumCOGS
				--select *--t1.LIA_PercentCOGS,t1.LIA_CumCOGS,t2.LIA_PercentCOGS,t2.LIA_CumCOGS 
				from #LPInventoryAnalytics t1,#LPInventoryAnalytics t2
				where t1.LIA_LineNbr = @linenbr2 
				and t2.LIA_LineNbr = @linenbr2 - 1
				and t1.LIA_DMA_ID = @dmaid
				and t2.LIA_DMA_ID = @dmaid
				and t1.LIA_DivisionName = @divisionname
				and t2.LIA_DivisionName = @divisionname
				
			FETCH NEXT FROM cur2 INTO @linenbr2
			END

			CLOSE cur2
			DEALLOCATE cur2
	
		FETCH NEXT FROM curlinenbr2 INTO @linenbr,@dmaid,@divisionname
		END

		CLOSE curlinenbr2
		DEALLOCATE curlinenbr2
		
		
	--更新COGS ABC
	Update #LPInventoryAnalytics
	set LIA_COGSABC = (case when LIA_CumCOGS <= 0.8 then 'A' 
						else 
							case when LIA_CumCOGS >= 0.95 then 'C' else 'B' end 
						end)
	
	--更新SABC
	Update #LPInventoryAnalytics
	set LIA_SABC = (case when LIA_SumPercentCount <= 0.8 then 'A' 
						else 
							case when LIA_SumPercentCount >=0.95 then 'C' else 'B' end 
						end)
						
	--更新Freq
	UPDATE #LPInventoryAnalytics set LIA_Freq = 6
	UPDATE #LPInventoryAnalytics set LIA_Freq = LIA_Freq -1 where LIA_Month01 = 0
	UPDATE #LPInventoryAnalytics set LIA_Freq = LIA_Freq -1 where LIA_Month02 = 0
	UPDATE #LPInventoryAnalytics set LIA_Freq = LIA_Freq -1 where LIA_Month03 = 0
	UPDATE #LPInventoryAnalytics set LIA_Freq = LIA_Freq -1 where LIA_Month04 = 0
	UPDATE #LPInventoryAnalytics set LIA_Freq = LIA_Freq -1 where LIA_Month05 = 0
	UPDATE #LPInventoryAnalytics set LIA_Freq = LIA_Freq -1 where LIA_Month06 = 0
	
	--更新F ABC
	Update #LPInventoryAnalytics
	set LIA_FABC = (case when LIA_Freq >4 then 'A' 
						else 
							case when LIA_Freq < 3 then 'C' else 'B' end 
						end)
	
	--更新RF ABC					
	Update #LPInventoryAnalytics
	set LIA_RFABC = LIA_COGSABC + LIA_SABC + LIA_FABC 
	
	--更新最终类别
	Update #LPInventoryAnalytics
	set LIA_Type = (case when LIA_RFABC in ('AAA','AAB','ABA','BAA','BAB','BBA','CAA','CAB','AAC') then 'A' 
						else 
							case when LIA_RFABC in ('ABB','ACA','ACB','BAC','BBB','BCA','BCB','CBA','CBB','CCA') then 'B' else 'C' end 
						end)

	--update 		#LPInventoryAnalytics
	--set 	LIA_Type = 'D'		
	--where 	LIA_RFABC = 'CCC'
	--and LIA_Freq = 0

DECLARE @currentDate datetime;
set @currentDate = getdate()


INSERT INTO LPInventoryAnalytics	
SELECT NEWID(),* from 
(select LIA_DivisionName,
LIA_UPN,LIA_Month01,LIA_Month02,LIA_Month03,LIA_Month04,LIA_Month05,LIA_Month06,
LIA_Total,LIA_PercentCount,LIA_SumPercentCount,LIA_SABC,LIA_LBM,LIA_TotalCOGS,LIA_PercentCOGS,LIA_CumCOGS,LIA_COGSABC,
LIA_Freq,LIA_FABC,LIA_RFABC,LIA_Type,DMA_ChineseName,DMA_ID,LIA_LineNbr ,@currentDate as LIA_Createdate
FROM #LPInventoryAnalytics inner join DealerMaster 
on LIA_DMA_ID = DMA_ID
) tab
order by LIA_LineNbr

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	
    return @vError
    
END CATCH
GO

