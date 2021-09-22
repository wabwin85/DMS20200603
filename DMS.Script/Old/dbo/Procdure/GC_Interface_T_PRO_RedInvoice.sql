DROP Procedure [dbo].[GC_Interface_T_PRO_RedInvoice]
GO


/*
�����̺�Ʊ�����Ϣ�ϴ��ӿ�
*/
CREATE Procedure [dbo].[GC_Interface_T_PRO_RedInvoice]
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
    UPDATE interface.T_PRO_RedInvoice SET ERMassage=NULL	
    --У�����������SAP���
    UPDATE interface.T_PRO_RedInvoice SET ERMassage='����������SAP��Ų�����'
    WHERE NoT EXISTS(SELECT 1 FROM DealerMaster WHERE 
    interface.T_PRO_RedInvoice.Tier2DealerCode=DealerMaster.DMA_SAP_Code)
    AND ERMassage IS NULL AND BatchNbr=@BatchNbr
    --��鷢Ʊ���Ƿ���д
    UPDATE interface.T_PRO_RedInvoice SET ERMassage='��Ʊ��δ��д' 
    WHERE InvoiceNumber IS NULL  AND ERMassage IS NULL AND BatchNbr=@BatchNbr
    --��鷢Ʊ����Ƿ���д
    UPDATE interface.T_PRO_RedInvoice SET ERMassage='��Ʊ���δ��д' 
    WHERE InvoiceAmount IS NULL  AND ERMassage IS NULL AND BatchNbr=@BatchNbr
    --��鷢Ʊ���Ƿ���д
    UPDATE interface.T_PRO_RedInvoice SET ERMassage='��Ʊ����δ��д'
    WHERE (InvoiceDate IS NULL OR InvoiceDate='')
    AND BatchNbr=@BatchNbr AND ERMassage IS NULL
    --У�龭�����Ƿ��и�BU
    UPDATE interface.T_PRO_RedInvoice SET ERMassage='�ö����������²����ڸ�BU'
    WHERE NOT EXISTS(SELECT 1 FROM V_DivisionProductLineRelation A INNER JOIN V_DealerContractMaster B
    ON CONVERT(NVARCHAR(30),A.DivisionCode)=CONVERT(NVARCHAR(30),B.Division) INNER JOIN DealerMaster 
    C ON B.DMA_ID=C.DMA_ID WHERE interface.T_PRO_RedInvoice.Tier2DealerCode=C.DMA_SAP_Code
    AND A.DivisionName=interface.T_PRO_RedInvoice.BSCBU)
    AND interface.T_PRO_RedInvoice.BatchNbr=@BatchNbr
    AND interface.T_PRO_RedInvoice.ERMassage IS NULL
    
    --���Ʊ��Ψһ��
    UPDATE B SET ERMassage='�÷�Ʊ���ѱ��ϴ����������ظ��ϴ�' FROM interface.T_PRO_RedInvoice B
    WHERE  B.BatchNbr=@BatchNbr AND B.ERMassage IS NULL
    AND EXISTS (SELECT 1 FROM Promotion.T_PRO_RedInvoice A WHERE A.InvoiceNumber=B.InvoiceNumber)
    
    
    --���û�д��󣬲�����ʽ��
    IF((SELECT COUNT(*) FROM interface.T_PRO_RedInvoice A WHERE A.BatchNbr=@BatchNbr AND A.ERMassage IS NOT  NULL)<=0)
      BEGIN
      INSERT INTO Promotion.T_PRO_RedInvoice (Tier2DealerCode,BSCBU,InvoiceNumber,InvoiceDate,InvoiceAmount,Remark)
      SELECT Tier2DealerCode,BSCBU,InvoiceNumber,InvoiceDate,InvoiceAmount,NULL FROM interface.T_PRO_RedInvoice WHERE interface.T_PRO_RedInvoice.BatchNbr=@BatchNbr
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


