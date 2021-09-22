DROP Procedure [dbo].[GC_Interface_DealerConsignmentSalesPrice]

GO

CREATE Procedure [dbo].[GC_Interface_DealerConsignmentSalesPrice]
   @BatchNbr NVARCHAR (30),
   @ClientID NVARCHAR (50),
   @IsValid NVARCHAR (20) OUTPUT,
   @RtnMsg NVARCHAR (4000) OUTPUT
AS
   DECLARE @ErrorCount    INTEGER
   DECLARE @SysUserId     UNIQUEIDENTIFIER
   DECLARE @DealerId uniqueidentifier
   SET  NOCOUNT ON

BEGIN TRY
      BEGIN TRAN
      SET @IsValid = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'
      
      --����������
	 SELECT @DealerId = CLT_Corp_Id FROM Client WHERE CLT_ID = @ClientID
	 
	 --У�����۵����Ƿ����
	 update t1
	 set t1.IDP_ProblemDescription = N'���۵��Ų�����'
	 --select * 
	 from InterfaceDealerConsignmentSalesPrice t1 
	 left join ShipmentHeader t2
	 on t1.IDP_SalesNo = t2.SPH_ShipmentNbr
	 where t2.SPH_ID is null
	 and IDP_BatchNbr = @BatchNbr
	 
	 --У��UPN��LOT�Ƿ������۵��д���
	 update t1
	 set t1.IDP_ProblemDescription = N'��Ʒ�ͺź����������۵��в�����'
	 --select * 
	 from InterfaceDealerConsignmentSalesPrice t1 
	 left join (select SPH_ShipmentNbr,PMA_UPN,LTM_LotNumber 
                from ShipmentHeader,ShipmentLine,ShipmentLot,Product,Lot,LotMaster
	             where SPH_ID = SPL_SPH_ID 
	               and SPL_ID = SLT_SPL_ID
	               and SPL_Shipment_PMA_ID = PMA_ID
	               AND isnull(SLT_QRLot_ID,SLT_LOT_ID) = LOT_ID
	               AND LOT_LTM_ID = LTM_ID ) T2
	 on t1.IDP_SalesNo = t2.SPH_ShipmentNbr
	 AND T1.IDP_UPN = T2.PMA_UPN
	 AND CASE WHEN charindex('@@', T1.IDP_Lot) > 0 and charindex('NoQR', T1.IDP_Lot) > 0  and charindex('NoQR', T1.IDP_Lot)+3 = len(T1.IDP_Lot)  
            THEN substring( T1.IDP_Lot,1,charindex('@@', T1.IDP_Lot)-1) + '@@NoQR'
            ELSE T1.IDP_Lot
            END = T2.LTM_LotNumber  --�����ά�����NOQR��������ֱ�Ӳ���Lot +@@+ NoQR�ķ�ʽ
	 where (T2.PMA_UPN IS NULL OR T2.LTM_LotNumber IS NULL)
	 and isnull(IDP_ProblemDescription,'') = ''
	 and IDP_BatchNbr = @BatchNbr
	 
	 declare @cnt int;
	 select @cnt = COUNT(*) from InterfaceDealerConsignmentSalesPrice
	 where isnull(IDP_ProblemDescription,'') <> ''
	 and IDP_BatchNbr = @BatchNbr
	 
	 create table #tmpShipmentLPConfirmHeader
	 (
		[TSCH_ID] [uniqueidentifier] ,
		[TSCH_SalesNo] [nvarchar](30) collate Chinese_PRC_CI_AS ,
		[TSCH_OrderNo] [nvarchar](30) collate Chinese_PRC_CI_AS,
		[TSCH_ConfirmDate] [datetime]  ,
		[TSCH_Remark] [nvarchar](2000) collate Chinese_PRC_CI_AS,
		[TSCH_ImportUser] [uniqueidentifier] ,
		[TSCH_ImportDate] [datetime] ,
		primary key (TSCH_ID)
	)
	
	create table #tmpShipmentLPConfirmDetail
	 (
		[TSCD_ID] [uniqueidentifier],
		[TSCD_TSCH_ID] [uniqueidentifier] ,
		[TSCD_UPN] [nvarchar](200) collate Chinese_PRC_CI_AS,
		[TSCD_Lot] [nvarchar](50)  collate Chinese_PRC_CI_AS,
		[TSCD_Qty] [decimal](18,2) ,
		[TSCD_UnitPrice] [decimal](18,2)  ,
		primary key (TSCD_ID)
	)

	 
	 if(@cnt = 0)
	 BEGIN
	 --д����ʱHEADER��
	 insert into #tmpShipmentLPConfirmHeader(TSCH_ID,TSCH_SalesNo,TSCH_OrderNo,TSCH_ConfirmDate,TSCH_Remark,TSCH_ImportUser,TSCH_ImportDate)
	 select NEWID(),IDP_SalesNo,IDP_OrderNo,IDP_ConfirmDate,IDP_Remark,@SysUserId,GETDATE() from (
	 select distinct IDP_SalesNo,IDP_OrderNo,MAX(IDP_ConfirmDate) as IDP_ConfirmDate,IDP_Remark
	 from InterfaceDealerConsignmentSalesPrice
	 where IDP_BatchNbr = @BatchNbr
	 group by IDP_SalesNo,IDP_OrderNo,IDP_Remark
	 ) a
	 
	 
	 --д��ShipmentLPConfirmHeader��
	 update ShipmentLPConfirmHeader
	 set SCH_OrderNo = TSCH_OrderNo,
		SCH_ConfirmDate = TSCH_ConfirmDate,
		SCH_Remark = TSCH_Remark
	 FROM  #tmpShipmentLPConfirmHeader
	 WHERE SCH_SalesNo = TSCH_SalesNo
	 
	 insert into ShipmentLPConfirmHeader
	 select TSCH_ID,TSCH_SalesNo,TSCH_OrderNo,TSCH_ConfirmDate,TSCH_Remark,TSCH_ImportUser,TSCH_ImportDate
	 from #tmpShipmentLPConfirmHeader
	 where NOT EXISTS (SELECT 1 FROM ShipmentLPConfirmHeader WHERE SCH_SalesNo = TSCH_SalesNo)
	 
	 --д����ʱDetail��
	 insert into #tmpShipmentLPConfirmDetail(TSCD_ID,TSCD_TSCH_ID,TSCD_UPN,TSCD_Lot,TSCD_Qty,TSCD_UnitPrice)
	 select NEWID(),SCH_ID,IDP_UPN,IDP_Lot,IDP_Qty,IDP_UnitPrice
	 from InterfaceDealerConsignmentSalesPrice,ShipmentLPConfirmHeader--#tmpShipmentLPConfirmHeader
	 where IDP_SalesNo = SCH_SalesNo
	 and IDP_BatchNbr = @BatchNbr
	 
	 
	 --д��ShipmentLPConfirmDetail��
	 UPDATE ShipmentLPConfirmDetail
	 set SCD_Qty = SCD_Qty + TSCD_Qty,SCD_UnitPrice= TSCD_UnitPrice
	 from ShipmentLPConfirmHeader,#tmpShipmentLPConfirmHeader,#tmpShipmentLPConfirmDetail
	 where SCH_SalesNo = TSCH_SalesNo
	 and SCH_ID = SCD_SCH_ID
	 and TSCH_ID = TSCD_TSCH_ID
	 and TSCD_UPN = SCD_UPN
	 AND TSCD_Lot = SCD_Lot
	 
	 insert into ShipmentLPConfirmDetail
	 select TSCD_ID,TSCD_TSCH_ID,TSCD_UPN,TSCD_Lot,TSCD_Qty,TSCD_UnitPrice
	 from #tmpShipmentLPConfirmDetail
	 where NOT EXISTS (SELECT 1 FROM ShipmentLPConfirmHeader,ShipmentLPConfirmDetail,#tmpShipmentLPConfirmHeader
	 WHERE SCH_ID = SCD_SCH_ID
	 and SCH_SalesNo = TSCH_SalesNo
	 and TSCD_UPN = SCD_UPN
	 AND TSCD_Lot = SCD_Lot)
	 
	 END
	 
	 COMMIT TRAN	
	
SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
	
	--��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH
GO


