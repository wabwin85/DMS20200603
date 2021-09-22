DROP Procedure [dbo].[GC_Interface_PROOutLinePoints]
GO


/*
经销商积分调整（购买积分）信息上传
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
	--经销商主键
    UPDATE interface.T_PRO_OutLinePoints SET ERMassage=NULL	
    --校验二级经销商SAP编号
    UPDATE interface.T_PRO_OutLinePoints SET ERMassage='二级经销商SAP编号不存在'
    WHERE NoT EXISTS(SELECT 1 FROM DealerMaster WHERE interface.T_PRO_OutLinePoints.Tier2DealerCode=DealerMaster.DMA_SAP_Code)
    AND ERMassage IS NULL AND BatchNbr=@BatchNbr
    --校验经销商是否有该BU
    UPDATE interface.T_PRO_OutLinePoints SET ERMassage='该二级经销商下不存在该BU'
    WHERE NOT EXISTS(SELECT 1 FROM V_DivisionProductLineRelation A INNER JOIN V_DealerContractMaster B
    ON CONVERT(NVARCHAR(30),A.DivisionCode)=CONVERT(NVARCHAR(30),B.Division) INNER JOIN DealerMaster C ON B.DMA_ID=C.DMA_ID WHERE interface.T_PRO_OutLinePoints.Tier2DealerCode=C.DMA_SAP_Code
    AND A.DivisionName=interface.T_PRO_OutLinePoints.BSCBU)
    AND interface.T_PRO_OutLinePoints.BatchNbr=@BatchNbr
    AND interface.T_PRO_OutLinePoints.ERMassage IS NULL
    --校验积分有效期
    UPDATE interface.T_PRO_OutLinePoints SET ERMassage='积分有效期必须大于当前日期'
    WHERE   convert(varchar(100),interface.T_PRO_OutLinePoints.PointsValidToDate,112)<=convert(varchar(100),GETDATE(),112)
    AND interface.T_PRO_OutLinePoints.BatchNbr=@BatchNbr
    AND interface.T_PRO_OutLinePoints.ERMassage IS NULL
    --如果没有错误，插入正式表
    IF((SELECT COUNT(*) FROM interface.T_PRO_OutLinePoints A WHERE A.BatchNbr=@BatchNbr AND A.ERMassage IS NOT  NULL)<=0)
      BEGIN
       DECLARE @FOWID INT;
     
      --建立游标
      DECLARE POINTCURSOR CURSOR 
      FOR SELECT FlowId FROM interface.T_PRO_OutLinePoints A 
      WHERE A.BatchNbr=@BatchNbr
      OPEN POINTCURSOR
      FETCH NEXT FROM POINTCURSOR INTO @FOWID
      WHILE @@FETCH_STATUS = 0
		BEGIN
		   SET IDENTITY_INSERT Promotion.PRO_DEALER_POINT ON ; 
      --判断表中是否有数据
      IF((SELECT COUNT(*) FROM Promotion.PRO_DEALER_POINT)<=0)
        BEGIN
             SET @DLID=1;
        END
             ELSE
        BEGIN
            SELECT @DLID=MAX(DLid)+1  FROM Promotion.PRO_DEALER_POINT
        END
        --获取经销商ID
        SELECT TOP 1 @DealerId=DMA_ID FROM 
        DealerMaster WHERE EXISTS(SELECT 1 FROM
        interface.T_PRO_OutLinePoints WHERE interface.T_PRO_OutLinePoints.BatchNbr=@BatchNbr
        AND interface.T_PRO_OutLinePoints.FlowId=@FOWID AND interface.T_PRO_OutLinePoints.Tier2DealerCode=DealerMaster.DMA_SAP_Code
        )
        --写入表1
        INSERT INTO Promotion.PRO_DEALER_POINT(DLid,DEALERID,PointType,BU,ListDesc,DetailDesc,CreateTime,ModifyDate,Remark1)
        SELECT  @DLID,@DealerId,'Point',A.BSCBU,NULL,NULL,GETDATE(),NULL,NULL FROM interface.T_PRO_OutLinePoints A 
        WHERE A.BatchNbr=@BatchNbr AND A.FlowId=@FOWID
        --写入表2

        INSERT INTO Promotion.PRO_DEALER_POINT_SUB(DLid,ValidDate,PointAmount,OrderAmount,OtherAmount,CreateTime,ModifyDate,Status,ExpireDate,Remark1)
        SELECT @DLID,A.PointsValidToDate,A.PointsAmount,'0.00','0.00',GETDATE(),GETDATE(),'1',NULL,NULL FROM interface.T_PRO_OutLinePoints A 
        WHERE A.BatchNbr=@BatchNbr AND A.FlowId=@FOWID
        --写入表3
     
        INSERT INTO Promotion.PRO_DEALER_POINT_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
        SELECT @DLID,3,'包含',(SELECT STUFF((SELECT distinct CAST(',|Leve1,'+CFN_Level1Code AS NVARCHAR(MAX)) 
        from CFN  WHERE EXISTS(SELECT 1 FROM V_DivisionProductLineRelation B
        WHERE CFN.CFN_ProductLine_BUM_ID=B.ProductLineID AND B.DivisionName=A.BSCBU) FOR XML PATH('')),1,2,''))
        FROM interface.T_PRO_OutLinePoints A 
        WHERE A.BatchNbr=@BatchNbr AND A.FlowId=@FOWID
        --写入表4
      
        INSERT INTO Promotion.PRO_DEALER_POINT_LOG (DLid,DLFrom,PolicyId,DEALERID,Period,MXID,Amount,OtherMemo,LogDate,Remark)
        SELECT @DLID,'购买积分',NULL,@DealerId,NULL,NULL,A.PointsAmount,NULL,GETDATE(),NULL FROM interface.T_PRO_OutLinePoints A WHERE A.BatchNbr=@BatchNbr
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


