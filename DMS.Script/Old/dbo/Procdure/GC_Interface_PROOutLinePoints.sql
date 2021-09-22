DROP Procedure [dbo].[GC_Interface_PROOutLinePoints]
GO


/*
�����̻��ֵ�����������֣���Ϣ�ϴ�
*/
Create Procedure [dbo].[GC_Interface_PROOutLinePoints]
@BatchNbr NVARCHAR(30),
	@ClientID NVARCHAR(50),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(MAX) OUTPUT
    AS
	DECLARE @SysUserId uniqueidentifier
	DECLARE @DealerId uniqueidentifier
	DECLARE @DLID INT
SET NOCOUNT ON
BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	--����������
    UPDATE interface.T_PRO_OutLinePoints SET ERMassage=NULL	
    --У�����������SAP���
    UPDATE interface.T_PRO_OutLinePoints SET ERMassage='����������SAP��Ų�����'
    WHERE NoT EXISTS(SELECT 1 FROM DealerMaster WHERE interface.T_PRO_OutLinePoints.Tier2DealerCode=DealerMaster.DMA_SAP_Code)
    AND ERMassage IS NULL AND BatchNbr=@BatchNbr
    --У�龭�����Ƿ��и�BU
    UPDATE interface.T_PRO_OutLinePoints SET ERMassage='�ö����������²����ڸ�BU'
    WHERE NOT EXISTS(SELECT 1 FROM V_DivisionProductLineRelation A INNER JOIN V_DealerContractMaster B
    ON CONVERT(NVARCHAR(30),A.DivisionCode)=CONVERT(NVARCHAR(30),B.Division) INNER JOIN DealerMaster C ON B.DMA_ID=C.DMA_ID WHERE interface.T_PRO_OutLinePoints.Tier2DealerCode=C.DMA_SAP_Code
    AND A.DivisionName=interface.T_PRO_OutLinePoints.BSCBU)
    AND interface.T_PRO_OutLinePoints.BatchNbr=@BatchNbr
    AND interface.T_PRO_OutLinePoints.ERMassage IS NULL
    --У�������Ч��
    UPDATE interface.T_PRO_OutLinePoints SET ERMassage='������Ч�ڱ�����ڵ�ǰ����'
    WHERE   convert(varchar(100),interface.T_PRO_OutLinePoints.PointsValidToDate,112)<=convert(varchar(100),GETDATE(),112)
    AND interface.T_PRO_OutLinePoints.BatchNbr=@BatchNbr
    AND interface.T_PRO_OutLinePoints.ERMassage IS NULL
    --���û�д��󣬲�����ʽ��
    IF((SELECT COUNT(*) FROM interface.T_PRO_OutLinePoints A WHERE A.BatchNbr=@BatchNbr AND A.ERMassage IS NOT  NULL)<=0)
      BEGIN
       DECLARE @FOWID INT;
     
      --�����α�
      DECLARE POINTCURSOR CURSOR 
      FOR SELECT FlowId FROM interface.T_PRO_OutLinePoints A 
      WHERE A.BatchNbr=@BatchNbr
      OPEN POINTCURSOR
      FETCH NEXT FROM POINTCURSOR INTO @FOWID
      WHILE @@FETCH_STATUS = 0
		BEGIN
		   SET IDENTITY_INSERT Promotion.PRO_DEALER_POINT ON ; 
      --�жϱ����Ƿ�������
      IF((SELECT COUNT(*) FROM Promotion.PRO_DEALER_POINT)<=0)
        BEGIN
             SET @DLID=1;
        END
             ELSE
        BEGIN
            SELECT @DLID=MAX(DLid)+1  FROM Promotion.PRO_DEALER_POINT
        END
        --��ȡ������ID
        SELECT TOP 1 @DealerId=DMA_ID FROM 
        DealerMaster WHERE EXISTS(SELECT 1 FROM
        interface.T_PRO_OutLinePoints WHERE interface.T_PRO_OutLinePoints.BatchNbr=@BatchNbr
        AND interface.T_PRO_OutLinePoints.FlowId=@FOWID AND interface.T_PRO_OutLinePoints.Tier2DealerCode=DealerMaster.DMA_SAP_Code
        )
        --д���1
        INSERT INTO Promotion.PRO_DEALER_POINT(DLid,DEALERID,PointType,BU,ListDesc,DetailDesc,CreateTime,ModifyDate,Remark1)
        SELECT  @DLID,@DealerId,'Point',A.BSCBU,NULL,NULL,GETDATE(),NULL,NULL FROM interface.T_PRO_OutLinePoints A 
        WHERE A.BatchNbr=@BatchNbr AND A.FlowId=@FOWID
        --д���2

        INSERT INTO Promotion.PRO_DEALER_POINT_SUB(DLid,ValidDate,PointAmount,OrderAmount,OtherAmount,CreateTime,ModifyDate,Status,ExpireDate,Remark1)
        SELECT @DLID,A.PointsValidToDate,A.PointsAmount,'0.00','0.00',GETDATE(),GETDATE(),'1',NULL,NULL FROM interface.T_PRO_OutLinePoints A 
        WHERE A.BatchNbr=@BatchNbr AND A.FlowId=@FOWID
        --д���3
     
        INSERT INTO Promotion.PRO_DEALER_POINT_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
        SELECT @DLID,3,'����',(SELECT STUFF((SELECT distinct CAST(',|Leve1,'+CFN_Level1Code AS NVARCHAR(MAX)) 
        from CFN  WHERE EXISTS(SELECT 1 FROM V_DivisionProductLineRelation B
        WHERE CFN.CFN_ProductLine_BUM_ID=B.ProductLineID AND B.DivisionName=A.BSCBU) FOR XML PATH('')),1,2,''))
        FROM interface.T_PRO_OutLinePoints A 
        WHERE A.BatchNbr=@BatchNbr AND A.FlowId=@FOWID
        --д���4
      
        INSERT INTO Promotion.PRO_DEALER_POINT_LOG (DLid,DLFrom,PolicyId,DEALERID,Period,MXID,Amount,OtherMemo,LogDate,Remark)
        SELECT @DLID,'�������',NULL,@DealerId,NULL,NULL,A.PointsAmount,NULL,GETDATE(),NULL FROM interface.T_PRO_OutLinePoints A WHERE A.BatchNbr=@BatchNbr
        AND A.FlowId=@FOWID
        
        SET IDENTITY_INSERT Promotion.PRO_DEALER_POINT OFF ; 
		FETCH NEXT FROM POINTCURSOR INTO @FOWID
		END
		CLOSE POINTCURSOR
		DEALLOCATE POINTCURSOR
   
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
	SET @RtnMsg = @vError
    return -1
    
END CATCH

GO


