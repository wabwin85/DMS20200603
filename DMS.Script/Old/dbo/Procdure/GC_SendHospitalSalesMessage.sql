DROP  Procedure [dbo].[GC_SendHospitalSalesMessage]
GO


/*
给销售发送医院销售信息
*/
CREATE Procedure [dbo].[GC_SendHospitalSalesMessage]
	@PushType NVARCHAR(20),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	CREATE TABLE #TBSendMessage
	(
		ProductLineID NVARCHAR(36),
		HospitalID NVARCHAR(36),
		HospitalName  NVARCHAR(500),
		ProductName NVARCHAR(500),
		QTY INT
	)
	
	--发邮件
	
	CREATE TABLE #TBSendMessage4
	(
		ID NVARCHAR(36),
		ProductLineID NVARCHAR(36),
		Hos_ID NVARCHAR(36),
		Hos_Name NVARCHAR(500),
		Hos_City NVARCHAR(500),
		Sub_User NVARCHAR(500),
		ProductName NVARCHAR(500),
		LOT NVARCHAR(500), 
		ExpiredDate DATETIME,
		CreatDate NVARCHAR(500)
	)
	
	DECLARE @GatBachNumber NVARCHAR(20)

	DECLARE @ProductLineId NVARCHAR(36)
	DECLARE @HospitalID NVARCHAR(36) 
	DECLARE @Hospital NVARCHAR(500)
	DECLARE @MsgString NVARCHAR(max)

	DECLARE @CountUmb INT

	DECLARE @MailID NVARCHAR(36)
	
	DECLARE @Hos_Name NVARCHAR(500)
	DECLARE @Hos_City NVARCHAR(100)
	DECLARE @Sub_User NVARCHAR(500)
	DECLARE @ProductName NVARCHAR(2000) 
	DECLARE @LOT NVARCHAR(2000)
	DECLARE @ExpiredDate DATETIME
	DECLARE @CreatDate NVARCHAR(500)
	DECLARE @MailSubject NVARCHAR(2000)
	DECLARE @MailBody NVARCHAR(MAX)
	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	IF ISNULL(@PushType,'')<>'Instant'
	BEGIN
		UPDATE HospitalSalesLog SET  HSL_SendState=1 WHERE  HSL_SendState=0 ;
		--AND ISNULL (HSL_ErrorMessage,'')='';
	END
	ELSE 
	BEGIN
		UPDATE HospitalSalesLog SET  HSL_SendState=1 WHERE  HSL_SendState=0 
		AND ISNULL(HSL_Rv2,'')='Instant';
		--AND ISNULL (HSL_ErrorMessage,'')='' 
	END 
	
	--发短信
	INSERT INTO #TBSendMessage(ProductLineID,HospitalID,HospitalName,ProductName,QTY)
	SELECT  ProductLine,HospitalID,HospitalName,ProductName,SUM(QTY) AS QTY FROM (
	SELECT slog.HSL_ProductLine_BUM_ID AS ProductLine,hos.HOS_ID AS HospitalID, hos.HOS_HospitalName AS HospitalName ,vi.DivisionName  AS ProductName,1 AS  QTY 
	FROM HospitalSalesLog slog
	INNER JOIN Hospital   hos ON slog.HSL_HOS_ID=hos.HOS_ID
	INNER JOIN V_DivisionProductLineRelation vi ON  vi.ProductLineID=slog.HSL_ProductLine_BUM_ID
	WHERE HSL_SendState=1) TB
	GROUP BY TB.ProductLine,TB.HospitalID,TB.HospitalName ,TB.ProductName  
	
	
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT DISTINCT ProductLineID,HospitalID ,(HospitalName + '用量'),MessageString=STUFF (
      (SELECT   ','
      + (tt2.ProductName +' ' +CONVERT( NVARCHAR(10),tt2.QTY) +'个' )
      FROM #TBSendMessage tt2
      WHERE     tt2.ProductLineID =
      t1.ProductLineID
      AND tt2.HospitalID =
      t1.HospitalID
      FOR XML PATH ( '' )),
      1,
      1,
      '')
	FROM 
	#TBSendMessage t1;
	
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @ProductLineId,@HospitalID,@Hospital,@MsgString
    WHILE @@FETCH_STATUS = 0        
        BEGIN
        SET @GatBachNumber='';
        EXEC dbo.GC_GetNextAutoNumberForCode 'Next_HosSalesLog',@GatBachNumber OUTPUT
        UPDATE HospitalSalesLog SET HSL_Rv1=@GatBachNumber
        WHERE HSL_ProductLine_BUM_ID=@ProductLineId and HSL_HOS_ID=@HospitalID and HSL_SendState=1
        
        SELECT @CountUmb=COUNT(*) FROM  HospitalDealerSalesmen A WHERE A.HDS_HOS_ID=@HospitalID AND A.HDS_ProductLine_BUM_ID=@ProductLineId
        IF(@CountUmb>0)
        BEGIN
			INSERT INTO ShortMessageQueue (SMQ_ID,	SMQ_QueueNo,	SMQ_To,	SMQ_Message,	SMQ_Status,	SMQ_CreateDate)
			SELECT NEWID(),'sms',A.HDS_Telephone,(@Hospital+@MsgString+' http://bscdealer.cn/HosSales.aspx?id='+@GatBachNumber),'Waiting',GETDATE()
			FROM HospitalDealerSalesmen A WHERE A.HDS_HOS_ID=@HospitalID AND A.HDS_ProductLine_BUM_ID=@ProductLineId
		END
		
		FETCH NEXT FROM @PRODUCT_CUR INTO @ProductLineId,@HospitalID,@Hospital,@MsgString
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
	
	--发邮件
	SET @MailSubject='医院波士顿产品用量通知';
	
	INSERT INTO #TBSendMessage4(ID,ProductLineID,Hos_ID,Hos_Name,Hos_City,Sub_User,ProductName,LOT,ExpiredDate,CreatDate)
	SELECT m.HDS_ID,a.HSL_ProductLine_BUM_ID,a.HSL_HOS_ID,Hospital.HOS_HospitalName,Hospital.HOS_City,a.HSL_Sub_User,CFN.CFN_CustomerFaceNbr+CFN.CFN_EnglishName , HSL_LotNumber,HSL_ExpiredDate,HSL_Rv3
	FROM HospitalSalesLog  a
	INNER JOIN CFN ON a.HSL_CustomerFaceNbr=CFN.CFN_CustomerFaceNbr
	INNER JOIN Hospital ON a.HSL_HOS_ID=Hospital.HOS_ID
	INNER JOIN HospitalDealerSalesmen m ON m.HDS_HOS_ID= a.HSL_HOS_ID and m.HDS_ProductLine_BUM_ID=m.HDS_ProductLine_BUM_ID
	WHERE a.HSL_SendState=1
	ORDER BY  HSL_Sub_User
	
	DECLARE @PRODUCT_CUR2 cursor;
	SET @PRODUCT_CUR2=cursor for 
	SELECT DISTINCT ID FROM #TBSendMessage4
	OPEN @PRODUCT_CUR2
    FETCH NEXT FROM @PRODUCT_CUR2 INTO @MailID
    WHILE @@FETCH_STATUS = 0        
        BEGIN
			SET @MailBody='<font face="微软雅黑"><b style=''font-weight:bold;font-size:14.0pt;''>尊敬的波士顿科学经销商销售经理，您好!</b><br/> 目前医院已产生以下用量，请知晓！<br/></font>';
			SET @MailBody=@MailBody+'<TABLE style="BACKGROUND: #ccccff; border:1px solid" cellSpacing="3" cellPadding="0">'
			SET @MailBody=@MailBody+'<TBODY>'
			SET @MailBody=@MailBody+'<TR>'
			SET @MailBody=@MailBody+'<TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
			SET @MailBody=@MailBody+'<STRONG><SPAN style="FONT-FAMILY: 宋体">医院名称</SPAN></STRONG>'
			SET @MailBody=@MailBody+'</TD>'
			SET @MailBody=@MailBody+'<TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
			SET @MailBody=@MailBody+'<STRONG><SPAN style="FONT-FAMILY: 宋体">区/县</SPAN></STRONG>'
			SET @MailBody=@MailBody+'</TD>'
			SET @MailBody=@MailBody+'<TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
			SET @MailBody=@MailBody+'<STRONG><SPAN style="FONT-FAMILY: 宋体">上报人</SPAN></STRONG>'
			SET @MailBody=@MailBody+'</TD>'
			SET @MailBody=@MailBody+'<TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
			SET @MailBody=@MailBody+'<STRONG><SPAN style="FONT-FAMILY: 宋体">产品中文名</SPAN></STRONG>'
			SET @MailBody=@MailBody+'</TD>'
			SET @MailBody=@MailBody+'<TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
			SET @MailBody=@MailBody+'<STRONG><SPAN style="FONT-FAMILY: 宋体">上报数量</SPAN></STRONG>'
			SET @MailBody=@MailBody+'</TD>'
			SET @MailBody=@MailBody+'<TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
			SET @MailBody=@MailBody+'<STRONG><SPAN style="FONT-FAMILY: 宋体">批次</SPAN></STRONG>'
			SET @MailBody=@MailBody+'</TD>'
			SET @MailBody=@MailBody+'<TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
			SET @MailBody=@MailBody+'<STRONG><SPAN style="FONT-FAMILY: 宋体">有效期</SPAN></STRONG>'
			SET @MailBody=@MailBody+'</TD>'
			SET @MailBody=@MailBody+'<TD style="BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
			SET @MailBody=@MailBody+'<STRONG><SPAN style="FONT-FAMILY: 宋体">用量时间</SPAN></STRONG>'
			SET @MailBody=@MailBody+'</TD>'
			SET @MailBody=@MailBody+'</TR>'
			
			DECLARE @PRODUCT_CUR3 cursor;
			SET @PRODUCT_CUR3=cursor for 
			SELECT Hos_Name,Hos_City,Sub_User,ProductName,LOT,ExpiredDate,CreatDate FROM #TBSendMessage4 WHERE ID=@MailID  ORDER BY Hos_Name;
			OPEN @PRODUCT_CUR3
			FETCH NEXT FROM @PRODUCT_CUR3 INTO @Hos_Name,@Hos_City,@Sub_User,@ProductName,@LOT,@ExpiredDate,@CreatDate
			WHILE @@FETCH_STATUS = 0        
				BEGIN
					SET @MailBody=@MailBody+'<TR>'
					SET @MailBody=@MailBody+'<TD style="BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
					SET @MailBody=@MailBody+ISNULL(@Hos_Name,'')
					SET @MailBody=@MailBody+'</TD>'
					SET @MailBody=@MailBody+'<TD style="BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
					SET @MailBody=@MailBody+ISNULL(@Hos_City,'')
					SET @MailBody=@MailBody+'</TD>'
					SET @MailBody=@MailBody+'<TD style="BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
					SET @MailBody=@MailBody+ISNULL(@Sub_User,'')
					SET @MailBody=@MailBody+'</TD>'
					SET @MailBody=@MailBody+'<TD style="BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
					SET @MailBody=@MailBody+ISNULL(@ProductName,'')
					SET @MailBody=@MailBody+'</TD>'
					SET @MailBody=@MailBody+'<TD style="BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
					SET @MailBody=@MailBody+'1'
					SET @MailBody=@MailBody+'</TD>'
					SET @MailBody=@MailBody+'<TD style="BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
					SET @MailBody=@MailBody+ISNULL(@LOT,'')
					SET @MailBody=@MailBody+'</TD>'
					SET @MailBody=@MailBody+'<TD style="BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
					SET @MailBody=@MailBody+Convert(NVARCHAR(10),ISNULL(@ExpiredDate,'1900-01-01') ,120)
					SET @MailBody=@MailBody+'</TD>'
					SET @MailBody=@MailBody+'<TD style="BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt">'
					SET @MailBody=@MailBody+ISNULL(@CreatDate,'')
					SET @MailBody=@MailBody+'</TD></TR>'
				FETCH NEXT FROM @PRODUCT_CUR3 INTO @Hos_Name,@Hos_City,@Sub_User,@ProductName,@LOT,@ExpiredDate,@CreatDate
				END
			CLOSE @PRODUCT_CUR3
			DEALLOCATE @PRODUCT_CUR3 ;
			
			SET @MailBody=@MailBody+'</TBODY>'
			SET @MailBody=@MailBody+'</TABLE> <br/>'
			SET @MailBody=@MailBody+'<br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
			
			INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate)
			SELECT NEWID(),'email','',B.HDS_Mail,@MailSubject,@MailBody,'Waiting',GETDATE()
			FROM HospitalDealerSalesmen B WHERE HDS_ID=@MailID
			
        FETCH NEXT FROM @PRODUCT_CUR2 INTO @MailID
        END
    CLOSE @PRODUCT_CUR2
    DEALLOCATE @PRODUCT_CUR2 ;
     
    --更新数据状态    
	UPDATE HospitalSalesLog SET  HSL_SendState=2 WHERE  HSL_SendState=1
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


