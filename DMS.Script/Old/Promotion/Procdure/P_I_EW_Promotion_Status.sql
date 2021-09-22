
DROP PROCEDURE [Promotion].[P_I_EW_Promotion_Status]
GO



CREATE PROCEDURE [Promotion].[P_I_EW_Promotion_Status]
@PolicyNo nvarchar(50),@Status nvarchar(20), @RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT
WITH EXEC AS CALLER
AS

DECLARE @Division NVARCHAR(100)
DECLARE @ProductLine uniqueidentifier
DECLARE @CON_NUMB NVARCHAR(20)	
DECLARE @POLICYID INT

DECLARE @PolicyName NVARCHAR(500)
DECLARE @BU NVARCHAR(20)	
DECLARE @MMQSubject NVARCHAR(500)
DECLARE @PolicyBeginDate DATETIME	
DECLARE @SubBU NVARCHAR(20)
DECLARE @MMQBody NVARCHAR(MAX)
DECLARE @MMQBodyLP NVARCHAR(MAX)
DECLARE @LPString NVARCHAR(800)

SET NOCOUNT ON
BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY A WHERE A.PolicyNo=@PolicyNo)
	BEGIN
		INSERT INTO Promotion.PRO_Operation_LOG (OperId,PolicyNo,OperDate,OperType,OperNote)
		VALUES(NEWID(),@PolicyNo,GETDATE(),'Failure',@PolicyNo+'��Ų�����')
	END
	ELSE
	BEGIN
		UPDATE Promotion.PRO_POLICY SET [Status]=@Status WHERE PolicyNo=@PolicyNo;
		
		INSERT INTO Promotion.PRO_Operation_LOG (OperId,PolicyNo,OperDate,OperType,OperNote)
		VALUES(NEWID(),@PolicyNo,GETDATE(),'Success',@PolicyNo+':'+@Status+'״̬ͬ���ɹ�')
		
		SELECT @POLICYID =A.PolicyId,@PolicyName=A.PolicyName,@BU=A.BU ,
		@SubBU = A.SubBU,
		@PolicyBeginDate=ISNULL(SUBSTRING(A.StartDate,1,4)+'-'+SUBSTRING(A.StartDate,5,2)+'-01','2010-01-01')
		FROM Promotion.PRO_POLICY A WHERE A.PolicyNo=@PolicyNo;
		EXEC [Promotion].[Proc_Pro_CreateTable] @POLICYID
		
		--���ʼ�֪ͨCO��ƽ̨
		IF @Status='��Ч'
		BEGIN
			SET @MMQSubject= @BU+'���������������֪ͨ'
			
			CREATE TABLE #TMP_DEALER
			(
				DealerId UNIQUEIDENTIFIER,
				DealerName NVARCHAR(100)
			)
			--�����ĵ���������
			INSERT INTO #TMP_DEALER(DealerId,DealerName)
			SELECT A.DMA_ID,A.DMA_ChineseName FROM dbo.DealerMaster A,Promotion.PRO_DEALER B 
			WHERE A.DMA_ID = B.DEALERID AND B.WithType = 'ByDealer' AND B.OperType = '����' AND B.PolicyId = @PolicyId 

			--��������Ȩ������	
			INSERT INTO #TMP_DEALER(DealerId,DealerName)
			SELECT DISTINCT A.DMA_ID,A.DMA_ChineseName 
			FROM dbo.DealerMaster A,Promotion.PRO_DEALER B ,V_DealerContractMaster C,
			INTERFACE.ClassificationContract D,V_DivisionProductLineRelation E
			WHERE B.WithType = 'ByAuth' AND B.OperType = '����' AND B.PolicyId = @PolicyId 
			AND C.DMA_ID=A.DMA_ID AND YEAR(C.MinDate)>=  YEAR(@PolicyBeginDate)  AND D.CC_Division=E.DivisionCode 
			AND E.IsEmerging='0' AND E.DivisionName=@BU  AND C.Division=D.CC_Division
			AND ((ISNULL(@SubBU,'')<>'' AND D.CC_ID=C.CC_ID AND  D.CC_Code=@SubBU ) OR ( ISNULL(@SubBU,'')=''))

			--ɾ���������ĵ���������
			DELETE C FROM dbo.DealerMaster A,Promotion.PRO_DEALER B,#TMP_DEALER C
			WHERE A.DMA_ID = B.DEALERID AND B.WithType = 'ByDealer' AND B.OperType = '������' AND B.PolicyId = @PolicyId 
			AND A.DMA_ID = C.DealerId
			
			IF EXISTS(SELECT 1 FROM #TMP_DEALER )
			BEGIN
				SELECT @LPString=STUFF(REPLACE(REPLACE((
					SELECT A.DMA_ChineseName+'-'+A.DMA_SAP_Code RESULT FROM DealerMaster A WHERE  A.DMA_DealerType='LP'
					AND (EXISTS (SELECT 1 FROM #TMP_DEALER B WHERE B.DealerId=A.DMA_ID)
					OR EXISTS(SELECT 1 FROM #TMP_DEALER C INNER JOIN DealerMaster D ON C.DealerId=D.DMA_ID AND D.DMA_Parent_DMA_ID=A.DMA_ID ))
				FOR XML AUTO ), '<A RESULT="', ','), '"/>', ''), 1, 1, '')
			END
			ELSE
			BEGIN
				--���������Hospital������Ҫ��д����������
				SELECT DealerId INTO #HOSPITALDEALER FROM Promotion.Pro_Hospital_PrdSalesTaget b,Promotion.PRO_POLICY_FACTOR a 
				WHERE a.PolicyFactorId=b.PolicyFactorId
				and FactId in (7,15) and a.PolicyId=@POLICYID
				SELECT @LPString=STUFF(REPLACE(REPLACE((
					SELECT A.DMA_ChineseName+'-'+A.DMA_SAP_Code RESULT FROM DealerMaster A WHERE  A.DMA_DealerType='LP'
					AND (EXISTS (SELECT 1 FROM #HOSPITALDEALER B WHERE B.DealerId=A.DMA_ID)
					OR EXISTS(SELECT 1 FROM #HOSPITALDEALER C INNER JOIN DealerMaster D ON C.DealerId=D.DMA_ID AND D.DMA_Parent_DMA_ID=A.DMA_ID ))
				FOR XML AUTO ), '<A RESULT="', ','), '"/>', ''), 1, 1, '')
			END
			
			IF ISNULL(@LPString,'')<>''
			BEGIN
				SET @MMQBody=@BU+'��������:'+@PolicyName+'('+@PolicyNo+')�Ѿ�������ɣ��漰ƽ̨������'+@LPString+'<br> <br>��ʿ�ٿ�ѧ<br>------------------------------------------------------------------ <br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���лл��'
			END
			ELSE
			BEGIN
				SET @MMQBody=@BU+'��������:'+@PolicyName+'('+@PolicyNo+')�Ѿ�������ɣ���֪����<br> <br>��ʿ�ٿ�ѧ<br>------------------------------------------------------------------ <br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���лл��';
			END
			SET @MMQBodyLP=@BU+'��������:'+@PolicyName+'('+@PolicyNo+')�Ѿ�������ɣ������漰������ƽ̨����֪����<br> <br>��ʿ�ٿ�ѧ<br>------------------------------------------------------------------ <br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���лл��';
			
			--1. ֪ͨCO
			INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
			SELECT DISTINCT NEWID(),'email','',AD.MDA_MailAddress,@MMQSubject,@MMQBody,'Waiting',GETDATE(),NULL
			FROM MailDeliveryAddress AD WHERE MDA_MailType='DCMS_BSC' AND MDA_MailTo='CO' AND MDA_ActiveFlag=1
			
			--2.֪ͨLP
			IF  EXISTS( SELECT 1 FROM DealerMaster A WHERE  A.DMA_SAP_Code IN ('369307','442091')
				AND (EXISTS (SELECT 1 FROM #TMP_DEALER B WHERE B.DealerId=A.DMA_ID)
				OR EXISTS(SELECT 1 FROM #TMP_DEALER C INNER JOIN DealerMaster D ON C.DealerId=D.DMA_ID AND D.DMA_Parent_DMA_ID=A.DMA_ID )))
				BEGIN
					INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
					SELECT DISTINCT NEWID(),'email','','jlli@fc-medical.cn',@MMQSubject,@MMQBodyLP,'Waiting',GETDATE(),NULL
				END
				
			IF  EXISTS( SELECT 1 FROM DealerMaster A WHERE  A.DMA_SAP_Code IN ('342859','442090')
			AND (EXISTS (SELECT 1 FROM #TMP_DEALER B WHERE B.DealerId=A.DMA_ID)
			OR EXISTS(SELECT 1 FROM #TMP_DEALER C INNER JOIN DealerMaster D ON C.DealerId=D.DMA_ID AND D.DMA_Parent_DMA_ID=A.DMA_ID )))
				BEGIN
					INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
					SELECT DISTINCT NEWID(),'email','','yhliu@heng-tai.com.cn',@MMQSubject,@MMQBodyLP,'Waiting',GETDATE(),NULL
				END
		END
		
		
	END
	
	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	
	INSERT INTO Promotion.PRO_Operation_LOG (OperId,PolicyNo,OperDate,OperType,OperNote)
	VALUES(NEWID(),@PolicyNo,GETDATE(),'Success',@PolicyNo+'״̬ͬ��ʧ��')
	
	SET @RtnMsg = @vError
    return -1
END CATCH
GO


