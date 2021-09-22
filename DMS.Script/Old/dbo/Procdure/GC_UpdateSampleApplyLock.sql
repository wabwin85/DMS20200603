DROP procedure  [dbo].[GC_UpdateSampleApplyLock]
GO

CREATE procedure  [dbo].[GC_UpdateSampleApplyLock]
as
begin
	declare @ApplyUser nvarchar(20)
	declare @Status nvarchar(20)
	declare @Qty decimal(18,2)
	declare @UploadDate int
	declare @UnlockDate datetime
	
	create table #tmp_Sample
	(
		ApplyUser nvarchar(20) null,
		ApplyNo nvarchar(20) null,
		Qty decimal(18,2) null,
		UploadDate int null
	)
	
	UPDATE A
    SET    A.ApplyStatus = 'Complete'
    FROM   SampleApplyHead A
    WHERE  A.SampleType = '��ҵ��Ʒ'
           AND A.ApplyStatus = 'Delivery'
           AND (
                   (
                       A.ApplyPurpose NOT IN ('����', 'CRM��������')
                       AND dbo.Func_IsSampleComplete(A.SampleApplyHeadId) = 1
                   )
                   OR (
                          A.ApplyPurpose IN ('����', 'CRM��������')
                          AND (
                                  SELECT SUM(B.ApplyQuantity)
                                  FROM   SampleUpn B
                                  WHERE  A.SampleApplyHeadId = B.SampleHeadId
                              ) = (
                                  SELECT SUM(D.PRL_ReceiptQty)
                                  FROM   POReceiptHeader_SAPNoQR B,
                                         POReceipt_SAPNoQR C,
                                         POReceiptLot_SAPNoQR D
                                  WHERE  B.PRH_ID = C.POR_PRH_ID
                                         AND C.POR_ID = D.PRL_POR_ID
                                         AND B.PRH_PurchaseOrderNbr = A.ApplyNo
                              )
                      )
               )
                       
	insert into #tmp_Sample		
	select CreateUser,ApplyNo,--PRH_SAPShipmentDate,-- UpnNO, Lot,
	sum(isnull(DeliveryQuantity,0)) - sum(isnull(EvalQuantity,0)) - sum(isnull(ReturnQuantity,0)) AS Qty,
	DATEDIFF ( day , PRH_SAPShipmentDate , getdate() ) as UploadDate
	from 
	(
	select tab.*, EvalQuantity = (
				   SELECT COUNT(*)
               FROM   SampleEval B
               WHERE  tab.UpnNo = B.UpnNo
                      AND tab.Lot = B.Lot
                      AND B.SampleHeadId = tab.SampleApplyHeadId
           ),
           ReturnQuantity = (
               SELECT ISNULL(SUM(B.ApplyQuantity), 0)
               FROM   SampleUpn B,
                      SampleReturnHead C
               WHERE  tab.UpnNo = B.UpnNo
                      AND tab.Lot = B.Lot
                      AND C.ApplyNo = tab.ApplyNo
                      AND B.SampleHeadId = C.SampleReturnHeadId
                      AND C.ReturnStatus <> 'Deny'
           ) from (
		SELECT     E.SampleApplyHeadId,
				   E.ApplyUserId,
				   E.ApplyNo,
				   D.PMA_UPN UpnNo,
				   C.PRL_LotNumber Lot,
				   F.ProductName,
				   F.ProductDesc,
				   E.CreateUser,
				  max(A.PRH_SAPShipmentDate) As PRH_SAPShipmentDate,
				   SUM(C.PRL_ReceiptQty) DeliveryQuantity,
				   CASE WHEN E.SampleType='��ҵ��Ʒ' or A.PRH_Status='Complete' then SUM(C.PRL_ReceiptQty) else 0 end AS ReciveQuantity
				   --select * 
			FROM   POReceiptHeader_SAPNoQR A(nolock),
				   POReceipt_SAPNoQR B(nolock),
				   POReceiptLot_SAPNoQR C(nolock),
				   Product D(nolock),
				   SampleApplyHead E(nolock),
				   SampleUpn F(nolock)
			WHERE  A.PRH_ID = B.POR_PRH_ID
				   AND B.POR_ID = C.PRL_POR_ID
				   AND B.POR_SAP_PMA_ID = D.PMA_ID
				   AND A.PRH_PurchaseOrderNbr = E.ApplyNo
				   AND E.SampleApplyHeadId = F.SampleHeadId
				   AND D.PMA_UPN = F.UpnNo 
				   AND E.SampleType='��ҵ��Ʒ'
				   and E.ApplyDate>'2016-01-01'	
				   --and e.ApplyUserId not in ('1541009')  --�������Ȳ�����
                   and case when ApplyPurpose in ('��Ʒ��ʾ�����','����','CRM��������') 
                       or F.UpnNo in (SELECT Value1 
                                        FROM [dbo].Lafite_DICT 
                                       WHERE dict_type='CONST_Sample_CrmUpn') then 'No' else 'Yes' end = 'Yes'      
			GROUP BY E.SampleApplyHeadId,E.ApplyUserId,E.ApplyNo, D.PMA_UPN, C.PRL_LotNumber, F.ProductName,F.ProductDesc,E.SampleType,A.PRH_Status,E.CreateUser
			) tab
			) resultTab 
		group by CreateUser, ApplyNo,PRH_SAPShipmentDate--, UpnNO, Lot

	--���LOCK����û�м�¼��������
	insert into SampleApplyLock(SampleApplyLockId,UserId,LockStatus,LockDate,UnlockDate)
	select NEWID(),ApplyUser,null,null,null
	from (select distinct ApplyUser from #tmp_Sample
	where not exists (select 1 from SampleApplyLock where ApplyUser = UserId)
	) tab
	
	
	DECLARE ListCursor CURSOR FOR 
		SELECT ApplyUser,sum(Qty),max(UploadDate),isnull(LockStatus,''),UnlockDate
		FROM #tmp_Sample,SampleApplyLock
		WHERE  ApplyUser = UserId
		and Qty > 0
		group by ApplyUser,LockStatus,UnlockDate
	OPEN ListCursor
	FETCH NEXT FROM ListCursor INTO @ApplyUser,@Qty,@UploadDate,@Status,@UnlockDate
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--��Ʒ��ʣ�����������ҳ���60��δ���
		IF(@UploadDate > 60 or @UploadDate = 60)
		BEGIN	
			--��鵱ǰ����״̬�������δ�������޸�״̬Ϊ������UnlockDate��Ϊ�գ�LockDate��Ϊ��ǰ����
			IF(@Status = 'UnLock' or @Status = '')
			BEGIN
				update SampleApplyLock set LockStatus = 'Lock',LockDate = GETDATE(),UnlockDate = null where UserId = @ApplyUser
			END
			--���������״̬����UnlockDate��Ϊ�գ���������
			ELSE 
			BEGIN
				update SampleApplyLock set UnlockDate = null where UserId = @ApplyUser
			END
		END
		--�����ڳ���60��δ�ϴ�
		ELSE 
		BEGIN
			--��鵱ǰ����״̬�������δ��������
			--���������״̬���޸�״̬Ϊ����������UnlockDate�ж�
			IF(@Status = 'Lock')
			BEGIN
				--���UnlockDateΪ�գ���UnlockDate��Ϊ��ǰ����+7��
				IF(@UnlockDate is null)
				begin
					update SampleApplyLock set UnlockDate = DATEADD(day,7,getdate()) where UserId = @ApplyUser		
				end	
				--���UnlockDate���ڵ�ǰ���ڣ���״̬��ΪUnlock��UnlockDate��Ϊ��		
				else if(convert(nvarchar(10),@UnlockDate,112) = CONVERT(nvarchar(10),getdate(),112))
				begin
					update SampleApplyLock set LockStatus = 'UnLock', UnlockDate = null where UserId = @ApplyUser				
				end
			END
			
		END
	
		FETCH NEXT FROM ListCursor INTO @ApplyUser,@Qty,@UploadDate,@Status,@UnlockDate
		
	END
	CLOSE ListCursor
	DEALLOCATE ListCursor
	
	--��Ʒ����ʣ������Ϊ0
	DECLARE ListCursor2 CURSOR FOR 
		SELECT ApplyUser,Qty,UploadDate,LockStatus,UnlockDate
		FROM (
		SELECT ApplyUser,sum(Qty) AS Qty,max(UploadDate) AS UploadDate,isnull(LockStatus,'') AS LockStatus,UnlockDate
		FROM #tmp_Sample,SampleApplyLock
		WHERE  ApplyUser = UserId
		group by ApplyUser,LockStatus,UnlockDate
		) TAB 
		WHERE Qty <= 0
	OPEN ListCursor2
	FETCH NEXT FROM ListCursor2 INTO @ApplyUser,@Qty,@UploadDate,@Status,@UnlockDate
	WHILE @@FETCH_STATUS = 0
	BEGIN
			--�����ڳ���60��δ�ϴ�
			--��鵱ǰ����״̬�������δ��������
			--���������״̬���޸�״̬Ϊ����������UnlockDate�ж�
			IF(@Status = 'Lock')
			BEGIN
				--���UnlockDateΪ�գ���UnlockDate��Ϊ��ǰ����+7��
				IF(@UnlockDate is null)
				begin
					update SampleApplyLock set UnlockDate = DATEADD(day,7,getdate()) where UserId = @ApplyUser		
				end	
				--���UnlockDate���ڵ�ǰ���ڣ���״̬��ΪUnlock��UnlockDate��Ϊ��		
				else if(convert(nvarchar(10),@UnlockDate,112) <= CONVERT(nvarchar(10),getdate(),112))
				begin
					update SampleApplyLock set LockStatus = 'UnLock', UnlockDate = null where UserId = @ApplyUser				
				end
			END
	
		FETCH NEXT FROM ListCursor2 INTO @ApplyUser,@Qty,@UploadDate,@Status,@UnlockDate
		
	END
	CLOSE ListCursor2
	DEALLOCATE ListCursor2

end
GO


