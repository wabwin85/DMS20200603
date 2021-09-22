DROP Procedure [dbo].[GC_Interface_T_PRO_RedInvoice]
GO


/*
经销商红票额度信息上传接口
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
	--经销商主键
    UPDATE interface.T_PRO_RedInvoice SET ERMassage=NULL	
    --校验二级经销商SAP编号
    UPDATE interface.T_PRO_RedInvoice SET ERMassage='二级经销商SAP编号不存在'
    WHERE NoT EXISTS(SELECT 1 FROM DealerMaster WHERE 
    interface.T_PRO_RedInvoice.Tier2DealerCode=DealerMaster.DMA_SAP_Code)
    AND ERMassage IS NULL AND BatchNbr=@BatchNbr
    --检查发票号是否填写
    UPDATE interface.T_PRO_RedInvoice SET ERMassage='发票号未填写' 
    WHERE InvoiceNumber IS NULL  AND ERMassage IS NULL AND BatchNbr=@BatchNbr
    --检查发票额度是否填写
    UPDATE interface.T_PRO_RedInvoice SET ERMassage='发票额度未填写' 
    WHERE InvoiceAmount IS NULL  AND ERMassage IS NULL AND BatchNbr=@BatchNbr
    --检查发票日是否填写
    UPDATE interface.T_PRO_RedInvoice SET ERMassage='发票日期未填写'
    WHERE (InvoiceDate IS NULL OR InvoiceDate='')
    AND BatchNbr=@BatchNbr AND ERMassage IS NULL
    --校验经销商是否有该BU
    UPDATE interface.T_PRO_RedInvoice SET ERMassage='该二级经销商下不存在该BU'
    WHERE NOT EXISTS(SELECT 1 FROM V_DivisionProductLineRelation A INNER JOIN V_DealerContractMaster B
    ON CONVERT(NVARCHAR(30),A.DivisionCode)=CONVERT(NVARCHAR(30),B.Division) INNER JOIN DealerMaster 
    C ON B.DMA_ID=C.DMA_ID WHERE interface.T_PRO_RedInvoice.Tier2DealerCode=C.DMA_SAP_Code
    AND A.DivisionName=interface.T_PRO_RedInvoice.BSCBU)
    AND interface.T_PRO_RedInvoice.BatchNbr=@BatchNbr
    AND interface.T_PRO_RedInvoice.ERMassage IS NULL
    
    --检查票据唯一性
    UPDATE B SET ERMassage='该发票号已被上传过，不能重复上传' FROM interface.T_PRO_RedInvoice B
    WHERE  B.BatchNbr=@BatchNbr AND B.ERMassage IS NULL
    AND EXISTS (SELECT 1 FROM Promotion.T_PRO_RedInvoice A WHERE A.InvoiceNumber=B.InvoiceNumber)
    
    
    --如果没有错误，插入正式表
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
	
	--记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH

GO


