DROP Procedure [dbo].[GC_ReturnLineSettlement]
GO



Create Procedure [dbo].[GC_ReturnLineSettlement]
AS
 
    
declare @QuarterFirstDay datetime --上个季度的第一天
declare @year int
declare @month int
declare @SubmitBeginDate datetime --额度使用开始时间
declare @SubmitEndDate datetime --额度使用结束时间
declare @ExpBeginDate datetime  --有效期开始时间
declare @ExpEndDate datetime    --有效期结束时间
set @SubmitBeginDate= dateadd(quarter,1+datediff(quarter,0, DATEADD(yy, DATEDIFF(yy,0,getdate()), 0) ),0)--获得今年的第二个季度的第一天
set @SubmitEndDate = dateadd(quarter,1+datediff(quarter,0,CONVERT(datetime,convert(nvarchar(4),datepart(year,getdate())+1)+'-01-01')),-1) --根据第二年的第一个季度的第一天
set @ExpBeginDate=  DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)
set @ExpEndDate = dateadd(ms,-3,DATEADD(yy, DATEDIFF(yy,0,getdate())+1, 0)) 
set @QuarterFirstDay=  dateadd(quarter,datediff(quarter,0,GETDATE())-1,0) -----当前日期的上个季度的第一天
set @year = year(@QuarterFirstDay)
set @month = month(@QuarterFirstDay)
begin
---- ic 耗材
select * into  #ic from(
select d.DMA_ID,SUM(ISNULL(SellingAmount,0))*0.02 *1.17 as SellingAmount
,'0f71530b-66d5-44af-9cab-ad65d5449c51' as CC_ProductLineID 
from INTERFACE.T_I_QV_BSCPurchase  P
inner join dealermaster d on d.DMA_SAP_Code=SAPID 
WHERE P.DealerType='LP' and p.[YEAR]=@year and p.[MONTH] in (@month,@month+1,@month+2)
and p.DivisionID=17
and not exists (select 1 from CfnClassification cc 
				where cc.CfnCustomerFaceNbr=p.UPN and cc.ClassificationId in ('78992F61-A96C-46C8-8B58-10467438FFE4','F848617C-B14D-40DA-8946-E162CCE9815C','CE77CA8C-99B9-45E0-8B45-4836A613D546')) 
GROUP BY  DMA_ID)tab


insert into DealerReturnPosition(DRP_ID,DRP_DMA_ID,DRP_BUM_ID,DRP_Year,DRP_Quarter,DRP_DetailAmount,DRP_IsInit,DRP_ReturnId,DRP_ReturnNo,DRP_ReturnLotId,DRP_Sku,DRP_LotNumber,DRP_QrCode,DRP_ReturnQty,DRP_Price,DRP_Type,DRP_Desc,DRP_REV1,DRP_REV2,DRP_REV3,DRP_CreateDate,DRP_CreateUser,DRP_CreateUserName,DRP_SubmitBeginDate,DRP_SubmitEndDate,DRP_ExpBeginDate,DRP_ExpEndDate,DRP_IsActived)
select  newid(),DMA_ID,CC_ProductLineID,YEAR(@QuarterFirstDay), datepart(quarter,@QuarterFirstDay), SellingAmount,1,null,null,null,null,null,null,null,null ,'系统计算额度','系统计算额度',null,null,null,getdate(),'00000000-0000-0000-0000-000000000000','系统',@SubmitBeginDate,@SubmitEndDate ,@ExpBeginDate,@ExpEndDate,1 from #ic


 ----CRM LP T1
select * into  #CRMLP from(
select d.DMA_ID,SUM(ISNULL(SellingAmount,0))*0.02*1.17 as SellingAmount,'97a4e135-74c7-4802-af23-9d6d00fcb2cc'as CC_ProductLineID 
from INTERFACE.T_I_QV_BSCPurchase  P
inner join dealermaster d on d.DMA_SAP_Code=SAPID
WHERE P.DealerType in('T1','LP')  and p.[YEAR]=@year and p.[MONTH] in (@month,@month+1,@month+2)
AND EXISTS (
select 1 from CFN
inner join V_DivisionProductLineRelation c on c.ProductLineID=CFN_ProductLine_BUM_ID and c.IsEmerging='0'
inner join CfnClassification b on CFN_CustomerFaceNbr=b.CfnCustomerFaceNbr
where c.DivisionCode=19
and b.ClassificationId not in ('38AB5F3B-BFE0-4FBD-9D3A-BC7C18A3DBBD')
AND CFN_CustomerFaceNbr=P.UPN
)
GROUP BY  DMA_ID)tab
--CRMLP插入
insert into DealerReturnPosition(DRP_ID,DRP_DMA_ID,DRP_BUM_ID,DRP_Year,DRP_Quarter,DRP_DetailAmount,DRP_IsInit,DRP_ReturnId,DRP_ReturnNo,DRP_ReturnLotId,DRP_Sku,DRP_LotNumber,DRP_QrCode,DRP_ReturnQty,DRP_Price,DRP_Type,DRP_Desc,DRP_REV1,DRP_REV2,DRP_REV3,DRP_CreateDate,DRP_CreateUser,DRP_CreateUserName,DRP_SubmitBeginDate,DRP_SubmitEndDate,DRP_ExpBeginDate,DRP_ExpEndDate,DRP_IsActived)
select  newid(),DMA_ID,CC_ProductLineID,YEAR(@QuarterFirstDay), datepart(quarter,@QuarterFirstDay), SellingAmount,1,null,null,null,null,null,null,null,null ,'系统计算额度','系统计算额度',null,null,null,getdate(),'00000000-0000-0000-0000-000000000000','系统',@SubmitBeginDate,@SubmitEndDate ,@ExpBeginDate,@ExpEndDate,1 from #CRMLP




------EP耗材LP
select * into  #EPLP from(
select d.DMA_ID,SUM(ISNULL(SellingAmount,0))*0.05*1.17 as SellingAmount,
'8de26929-588b-4e24-9dcd-a26200a9d56b' AS CC_ProductLineID 
from INTERFACE.T_I_QV_BSCPurchase  P
inner join dealermaster d on d.DMA_SAP_Code=p.SAPID
WHERE P.DealerType='LP'  and  p.[YEAR]=@year and p.[MONTH] in (@month,@month+1,@month+2) and p.DivisionID=32
 and p.transactionDate between convert (datetime,'2017-01-01') and convert (datetime,'2017-12-31') 
 and DATEDIFF(DD,p.transactionDate,p.EXPDate)>180
 and DATEDIFF(DD,P.transactionDate,p.EXPDate)<=270
 and p.UPN not in('M004RC64S0','M004RAPATCH11')
AND  EXISTS (
select 1 from  CfnClassification c 
inner join V_ProductClassificationStructure cc on c.ClassificationId=cc.CA_ID and cc.ActiveFlag=1
				where  cc.CA_ID  in ('316BF7ED-42BC-4F2D-80FA-A26200AB6299')
				and  c.CfnCustomerFaceNbr=P.UPN)
GROUP BY DMA_ID) TAB
insert into DealerReturnPosition(DRP_ID,DRP_DMA_ID,DRP_BUM_ID,DRP_Year,DRP_Quarter,DRP_DetailAmount,DRP_IsInit,DRP_ReturnId,DRP_ReturnNo,DRP_ReturnLotId,DRP_Sku,DRP_LotNumber,DRP_QrCode,DRP_ReturnQty,DRP_Price,DRP_Type,DRP_Desc,DRP_REV1,DRP_REV2,DRP_REV3,DRP_CreateDate,DRP_CreateUser,DRP_CreateUserName,DRP_SubmitBeginDate,DRP_SubmitEndDate,DRP_ExpBeginDate,DRP_ExpEndDate,DRP_IsActived)
select  newid(),DMA_ID,CC_ProductLineID,YEAR(@QuarterFirstDay), datepart(quarter,@QuarterFirstDay), SellingAmount,1,null,null,null,null,null,null,null,null ,'系统计算额度','系统计算额度',null,null,null,getdate(),'00000000-0000-0000-0000-000000000000','系统',@SubmitBeginDate,@SubmitEndDate ,@ExpBeginDate,@ExpEndDate,1 from #EPLP



----EndoT1
select * into  #EndoT1 from(
select  DMA_ID,SUM(ISNULL(p.SellingAmount,0))*0.02*1.17 as SellingAmount , '8f15d92a-47e4-462f-a603-f61983d61b7b' AS CC_ProductLineID 
from INTERFACE.T_I_QV_BSCPurchase  P
inner join dealermaster d on d.DMA_SAP_Code=SAPID
WHERE P.DealerType='T1'  and p.[YEAR]=@year and p.[MONTH] in (@month,@month+1,@month+2)
 and EXISTS (
select 1 from CFN
inner join CfnClassification b on CFN_CustomerFaceNbr=b.CfnCustomerFaceNbr
where  EXISTS
 (select 1 FROM V_ProductClassificationStructure A WHERE 
 A.CC_Division=18 AND CC_Code='C1801' and a.ActiveFlag=1 and
 b.ClassificationId=A.CA_ID)
AND CFN_CustomerFaceNbr=P.UPN
)
GROUP BY DMA_ID
)tab

insert into DealerReturnPosition(DRP_ID,DRP_DMA_ID,DRP_BUM_ID,DRP_Year,DRP_Quarter,DRP_DetailAmount,DRP_IsInit,DRP_ReturnId,DRP_ReturnNo,DRP_ReturnLotId,DRP_Sku,DRP_LotNumber,DRP_QrCode,DRP_ReturnQty,DRP_Price,DRP_Type,DRP_Desc,DRP_REV1,DRP_REV2,DRP_REV3,DRP_CreateDate,DRP_CreateUser,DRP_CreateUserName,DRP_SubmitBeginDate,DRP_SubmitEndDate,DRP_ExpBeginDate,DRP_ExpEndDate,DRP_IsActived)
select  newid(),DMA_ID,CC_ProductLineID,YEAR(@QuarterFirstDay), datepart(quarter,@QuarterFirstDay), SellingAmount,1,null,null,null,null,null,null,null,null ,'系统计算额度','系统计算额度',null,null,null,getdate(),'00000000-0000-0000-0000-000000000000','系统',@SubmitBeginDate,@SubmitEndDate ,@ExpBeginDate,@ExpEndDate,1 from #EndoT1



------EndoLP
select * into #EndoLP from(
select d.DMA_ID,SUM(ISNULL(p.SellingAmount,0))*0.03*1.17 as SellingAmount , '8f15d92a-47e4-462f-a603-f61983d61b7b' AS CC_ProductLineID 
from INTERFACE.T_I_QV_BSCPurchase  P
inner join dealermaster d on d.DMA_SAP_Code=SAPID
WHERE P.DealerType='LP'  and p.[YEAR]=@year and p.[MONTH] in (@month,@month+1,@month+2)
 and EXISTS (
select 1 from CFN
inner join CfnClassification b on CFN_CustomerFaceNbr=b.CfnCustomerFaceNbr
where  EXISTS
 (select 1 FROM V_ProductClassificationStructure A WHERE 
 A.CC_Division=18 AND CC_Code='C1801' and a.ActiveFlag=1 and
 b.ClassificationId=A.CA_ID)
AND CFN_CustomerFaceNbr=P.UPN
)
GROUP BY DMA_ID
) tab
insert into DealerReturnPosition(DRP_ID,DRP_DMA_ID,DRP_BUM_ID,DRP_Year,DRP_Quarter,DRP_DetailAmount,DRP_IsInit,DRP_ReturnId,DRP_ReturnNo,DRP_ReturnLotId,DRP_Sku,DRP_LotNumber,DRP_QrCode,DRP_ReturnQty,DRP_Price,DRP_Type,DRP_Desc,DRP_REV1,DRP_REV2,DRP_REV3,DRP_CreateDate,DRP_CreateUser,DRP_CreateUserName,DRP_SubmitBeginDate,DRP_SubmitEndDate,DRP_ExpBeginDate,DRP_ExpEndDate,DRP_IsActived)
select  newid(),DMA_ID,CC_ProductLineID,YEAR(@QuarterFirstDay), datepart(quarter,@QuarterFirstDay), SellingAmount,1,null,null,null,null,null,null,null,null ,'系统计算额度','系统计算额度',null,null,null,getdate(),'00000000-0000-0000-0000-000000000000','系统',@SubmitBeginDate,@SubmitEndDate ,@ExpBeginDate,@ExpEndDate,1 from #EndoLP



------Endo新型市场LP
select * into #EndonewLP from(
select d.DMA_ID,SUM(ISNULL(SellingAmount,0))*0.03*1.17 as SellingAmount ,'8f15d92a-47e4-462f-a603-f61983d61b7b' as CC_ProductLineID from INTERFACE.T_I_QV_BSCPurchase  P
inner join dealermaster d on d.DMA_SAP_Code=SAPID
WHERE P.DealerType='LP'  and p.[YEAR]=@year and p.[MONTH] in (@month,@month+1,@month+2)
AND EXISTS (
select 1 from CFN
inner join V_DivisionProductLineRelation c on c.ProductLineID=CFN_ProductLine_BUM_ID and c.IsEmerging='0'
inner join CfnClassification b on CFN_CustomerFaceNbr=b.CfnCustomerFaceNbr
where c.DivisionCode=18 and b.ClassificationId not in ('82B5D669-4EC7-442A-8635-F598415A10B6')
AND CFN_CustomerFaceNbr=P.UPN
)
GROUP BY DMA_ID)tab
insert into DealerReturnPosition(DRP_ID,DRP_DMA_ID,DRP_BUM_ID,DRP_Year,DRP_Quarter,DRP_DetailAmount,DRP_IsInit,DRP_ReturnId,DRP_ReturnNo,DRP_ReturnLotId,DRP_Sku,DRP_LotNumber,DRP_QrCode,DRP_ReturnQty,DRP_Price,DRP_Type,DRP_Desc,DRP_REV1,DRP_REV2,DRP_REV3,DRP_CreateDate,DRP_CreateUser,DRP_CreateUserName,DRP_SubmitBeginDate,DRP_SubmitEndDate,DRP_ExpBeginDate,DRP_ExpEndDate,DRP_IsActived)
select  newid(),DMA_ID,CC_ProductLineID,YEAR(@QuarterFirstDay), datepart(quarter,@QuarterFirstDay), SellingAmount,1,null,null,null,null,null,null,null,null ,'系统计算额度','系统计算额度',null,null,null,getdate(),'00000000-0000-0000-0000-000000000000','系统',@SubmitBeginDate,@SubmitEndDate ,@ExpBeginDate,@ExpEndDate,1 from #EndonewLP



----Cardio新型市场
select * into #CardionewLP FROM(
select d.DMA_ID,SUM(ISNULL(SellingAmount,0))*0.02 *1.17as SellingAmount ,'dd1b6adf-3772-4e4a-b9cc-a2b900b5f935' as CC_ProductLineID from INTERFACE.T_I_QV_BSCPurchase  P
inner join dealermaster d on d.DMA_SAP_Code=SAPID
WHERE P.DealerType='LP'  and p.[YEAR]=@year and p.[MONTH] in (@month,@month+1,@month+2)
AND EXISTS (
select 1 from CFN
inner join V_DivisionProductLineRelation c on c.ProductLineID=CFN_ProductLine_BUM_ID and c.IsEmerging='0'
inner join CfnClassification b on CFN_CustomerFaceNbr=b.CfnCustomerFaceNbr
where c.DivisionCode=17 and b.ClassificationId not in ('78992F61-A96C-46C8-8B58-10467438FFE4',
'CE77CA8C-99B9-45E0-8B45-4836A613D546',
'F848617C-B14D-40DA-8946-E162CCE9815C')
AND CFN_CustomerFaceNbr=P.UPN
)
GROUP BY DMA_ID)tab
insert into DealerReturnPosition(DRP_ID,DRP_DMA_ID,DRP_BUM_ID,DRP_Year,DRP_Quarter,DRP_DetailAmount,DRP_IsInit,DRP_ReturnId,DRP_ReturnNo,DRP_ReturnLotId,DRP_Sku,DRP_LotNumber,DRP_QrCode,DRP_ReturnQty,DRP_Price,DRP_Type,DRP_Desc,DRP_REV1,DRP_REV2,DRP_REV3,DRP_CreateDate,DRP_CreateUser,DRP_CreateUserName,DRP_SubmitBeginDate,DRP_SubmitEndDate,DRP_ExpBeginDate,DRP_ExpEndDate,DRP_IsActived)
select  newid(),DMA_ID,CC_ProductLineID,YEAR(@QuarterFirstDay), datepart(quarter,@QuarterFirstDay), SellingAmount,1,null,null,null,null,null,null,null,null ,'系统计算额度','系统计算额度',null,null,null,getdate(),'00000000-0000-0000-0000-000000000000','系统',@SubmitBeginDate,@SubmitEndDate ,@ExpBeginDate,@ExpEndDate,1 from #CardionewLP




-------Uro耗材
select * into #Urolp from (
select d.DMA_ID,SUM(ISNULL(SellingAmount,0))*0.02*1.17 as SellingAmount ,'e9da0666-2eda-4883-8f28-a24301255cc3' as CC_ProductLineID from INTERFACE.T_I_QV_BSCPurchase  P
inner join dealermaster d on d.DMA_SAP_Code=SAPID
WHERE P.DealerType='LP'  and p.[YEAR]=@year and P.[MONTH] in (@month,@month+1,@month+2)
AND  EXISTS (
select 1 from CFN
inner join V_DivisionProductLineRelation c on c.ProductLineID=CFN_ProductLine_BUM_ID and c.IsEmerging='0'
inner join CfnClassification b on CFN_CustomerFaceNbr=b.CfnCustomerFaceNbr
where c.DivisionCode=22 and b.ClassificationId  ='2B7CE4CD-0909-409E-9F6E-D21982962A40'
AND CFN_CustomerFaceNbr=P.UPN
)
GROUP BY DMA_ID )tab
insert into DealerReturnPosition(DRP_ID,DRP_DMA_ID,DRP_BUM_ID,DRP_Year,DRP_Quarter,DRP_DetailAmount,DRP_IsInit,DRP_ReturnId,DRP_ReturnNo,DRP_ReturnLotId,DRP_Sku,DRP_LotNumber,DRP_QrCode,DRP_ReturnQty,DRP_Price,DRP_Type,DRP_Desc,DRP_REV1,DRP_REV2,DRP_REV3,DRP_CreateDate,DRP_CreateUser,DRP_CreateUserName,DRP_SubmitBeginDate,DRP_SubmitEndDate,DRP_ExpBeginDate,DRP_ExpEndDate,DRP_IsActived)
select  newid(),DMA_ID,CC_ProductLineID,YEAR(@QuarterFirstDay), datepart(quarter,@QuarterFirstDay), SellingAmount,1,null,null,null,null,null,null,null,null ,'系统计算额度','系统计算额度',null,null,null,getdate(),'00000000-0000-0000-0000-000000000000','系统',@SubmitBeginDate,@SubmitEndDate ,@ExpBeginDate,@ExpEndDate,1 from #Urolp




-----PILP
select *into #PIIOHAMLP FROM(
select  d.DMA_ID,  '18847e4a-e133-4ccc-bc7a-e93564e65003' as CC_ProductLineID 
,SUM(ISNULL(a.SellingAmount,0))*0.015 *1.17   
 as SellingAmount
from interface.T_I_QV_BSCPurchase a 
inner join DealerMaster d on d.DMA_SAP_Code=a.SAPID
where a.[YEAR]=@year and a.[MONTH] in (@month,@month+1,@month+2)
and a.UPN not in ('105650-037','M001262210')
AND A.DivisionID=10
and a.DealerType='LP'
and not exists (select 1 from PurchaseOrderHeader B 
INNER JOIN PurchaseOrderDetail C ON B.POH_ID=C.POD_POH_ID 
INNER JOIN CFN ON CFN.CFN_ID=C.POD_CFN_ID  
WHERE B.POH_OrderNo=A.PONumber AND B.POH_OrderType='SpecialPrice' and CFN.CFN_CustomerFaceNbr='M001262210')
GROUP BY DMA_ID)tab
insert into DealerReturnPosition(DRP_ID,DRP_DMA_ID,DRP_BUM_ID,DRP_Year,DRP_Quarter,DRP_DetailAmount,DRP_IsInit,DRP_ReturnId,DRP_ReturnNo,DRP_ReturnLotId,DRP_Sku,DRP_LotNumber,DRP_QrCode,DRP_ReturnQty,DRP_Price,DRP_Type,DRP_Desc,DRP_REV1,DRP_REV2,DRP_REV3,DRP_CreateDate,DRP_CreateUser,DRP_CreateUserName,DRP_SubmitBeginDate,DRP_SubmitEndDate,DRP_ExpBeginDate,DRP_ExpEndDate,DRP_IsActived)
select  newid(),DMA_ID,CC_ProductLineID,YEAR(@QuarterFirstDay), datepart(quarter,@QuarterFirstDay), SellingAmount,1,null,null,null,null,null,null,null,null ,'系统计算额度','系统计算额度',null,null,null,getdate(),'00000000-0000-0000-0000-000000000000','系统',@SubmitBeginDate,@SubmitEndDate ,@ExpBeginDate,@ExpEndDate,1 from #PIIOHAMLP




----AngioJet
select * into #AngioJett1 from (
select d.DMA_ID,SUM(ISNULL(SellingAmount,0))*0.03 *1.17as SellingAmount ,'18847e4a-e133-4ccc-bc7a-e93564e65003' as CC_ProductLineID from INTERFACE.T_I_QV_BSCPurchase  P
inner join dealermaster d on d.DMA_SAP_Code=SAPID
WHERE P.DealerType='T1'  and p.[YEAR]=@year and p.[MONTH]in (@month,@month+1,@month+2)
AND  EXISTS (
select 1 from CFN
inner join V_DivisionProductLineRelation c on c.ProductLineID=CFN_ProductLine_BUM_ID and c.IsEmerging='0'
inner join CfnClassification b on CFN_CustomerFaceNbr=b.CfnCustomerFaceNbr
where c.DivisionCode=10 and b.ClassificationId  in ('441ED9E4-FA52-408B-A813-F80F01EF99FD')
AND CFN_CustomerFaceNbr=P.UPN
)
GROUP BY DMA_ID)tab
insert into DealerReturnPosition(DRP_ID,DRP_DMA_ID,DRP_BUM_ID,DRP_Year,DRP_Quarter,DRP_DetailAmount,DRP_IsInit,DRP_ReturnId,DRP_ReturnNo,DRP_ReturnLotId,DRP_Sku,DRP_LotNumber,DRP_QrCode,DRP_ReturnQty,DRP_Price,DRP_Type,DRP_Desc,DRP_REV1,DRP_REV2,DRP_REV3,DRP_CreateDate,DRP_CreateUser,DRP_CreateUserName,DRP_SubmitBeginDate,DRP_SubmitEndDate,DRP_ExpBeginDate,DRP_ExpEndDate,DRP_IsActived)
select  newid(),DMA_ID,CC_ProductLineID,YEAR(@QuarterFirstDay), datepart(quarter,@QuarterFirstDay), SellingAmount,1,null,null,null,null,null,null,null,null ,'系统计算额度','系统计算额度',null,null,null,getdate(),'00000000-0000-0000-0000-000000000000','系统',@SubmitBeginDate,@SubmitEndDate ,@ExpBeginDate,@ExpEndDate,1 from #AngioJett1
 
END

GO


