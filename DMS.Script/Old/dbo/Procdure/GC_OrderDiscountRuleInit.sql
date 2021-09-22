DROP PROCEDURE [dbo].[GC_OrderDiscountRuleInit] 
GO


/**********************************************
	功能：校验近效期打折导入规则
	作者：GrapeCity
	最后更新时间：	2017-03-14
	更新记录说明：
	1.创建 2017-03-14
**********************************************/
CREATE PROCEDURE [dbo].[GC_OrderDiscountRuleInit] 
	@UserId NVARCHAR(36),
	@ImportType NVARCHAR(10),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN
	
	CREATE TABLE #RELUTEMP(
		BU [int] NULL,
		UPN NVARCHAR(200) collate Chinese_PRC_CI_AS NULL ,
		LeftValue INT NULL,
		RightValue INT NULL,
		DiscountValue decimal(18, 5) NULL,
		BeginDate Datetime NULL,
		EndDate Datetime NULL
	)
	
	CREATE TABLE #RELUTSUM(
		BU NVARCHAR(200) collate Chinese_PRC_CI_AS NULL ,
		DealerSAP NVARCHAR(200) collate Chinese_PRC_CI_AS NULL ,
		PctLevel NVARCHAR(200) collate Chinese_PRC_CI_AS NULL ,
		PctLevelCode NVARCHAR(200) collate Chinese_PRC_CI_AS NULL ,
		UPN NVARCHAR(200) collate Chinese_PRC_CI_AS NULL ,
		LOT NVARCHAR(200) collate Chinese_PRC_CI_AS NULL ,
		QRCode NVARCHAR(200) collate Chinese_PRC_CI_AS NULL ,
		PctNameGroup NVARCHAR(200) collate Chinese_PRC_CI_AS NULL ,
		LeftValue INT NULL,
		RightValue INT NULL,
		DiscountValue decimal(18, 5) NULL,
		ErrMassage NVARCHAR(2000) collate Chinese_PRC_CI_AS NULL ,
		CreateUser uniqueidentifier null,
		BeginDate Datetime NULL,
		EndDate Datetime NULL
	)
	 
	SET @IsValid='Success';
	
	UPDATE ConsignmentDiscountRuleInit SET ErrMassage='经销商账号为空' 
	WHERE ISNULL(DealerSAP,'')='' AND ISNULL(ErrMassage,'')='' AND CreateUser=@UserId;
	
	UPDATE ConsignmentDiscountRuleInit SET ErrMassage='产品线不能为空' 
	WHERE ISNULL(BU,'')='' AND ISNULL(ErrMassage,'')='' AND CreateUser=@UserId;
	
	UPDATE ConsignmentDiscountRuleInit SET ErrMassage='产品线不存在' 
	WHERE ISNULL(ErrMassage,'')='' AND CreateUser=@UserId
	AND NOT EXISTS (SELECT 1 FROM V_DivisionProductLineRelation R WHERE R.ProductLineName=BU);
	
	--UPDATE A SET A.BU=R.DivisionCode FROM ConsignmentDiscountRuleInit A 
	--INNER JOIN V_DivisionProductLineRelation R ON A.BU=R.DivisionName AND R.IsEmerging='0'
	--WHERE ISNULL(ErrMassage,'')='' AND CreateUser=@UserId
	
	UPDATE ConsignmentDiscountRuleInit SET ErrMassage='UPN不能为空' 
	WHERE ISNULL(UPN,'')='' AND ISNULL(ErrMassage,'')='' AND CreateUser=@UserId;
	
	UPDATE A SET A.ErrMassage='经销商账号为空' FROM ConsignmentDiscountRuleInit A 
	WHERE ISNULL(ErrMassage,'')='' AND CreateUser=@UserId
	AND NOT EXISTS(SELECT 1 FROM DealerMaster B WHERE A.DealerSAP=B.DMA_SAP_Code);
	
	UPDATE A SET ErrMassage='UPN与BU不匹配' 
	FROM ConsignmentDiscountRuleInit A 
	INNER JOIN V_DivisionProductLineRelation B ON CONVERT(NVARCHAR,A.BU)=B.ProductLineName AND B.IsEmerging='0'
	WHERE ISNULL(ErrMassage,'')='' 
	AND CreateUser=@UserId
	AND NOT EXISTS(SELECT 1 FROM CFN WHERE CFN.CFN_CustomerFaceNbr=A.UPN AND CFN.CFN_ProductLine_BUM_ID=B.ProductLineID);
	
	UPDATE ConsignmentDiscountRuleInit SET ErrMassage='折扣规则定义不全' 
	WHERE (((ISNULL(CONVERT(NVARCHAR,LeftValue),'')<>'' OR ISNULL(CONVERT(NVARCHAR,RightValue),'')<>'') AND isnull(DiscountValue,0.00)=0.00 )
	OR (ISNULL(CONVERT(NVARCHAR,LeftValue),'')='' AND ISNULL(CONVERT(NVARCHAR,RightValue),'')='' and isnull(DiscountValue,0.00)<>0.00))
	AND ISNULL(ErrMassage,'')=''  
	AND CreateUser=@UserId;
	
	UPDATE ConsignmentDiscountRuleInit SET ErrMassage='折扣规则适用时间没有限定' 
	WHERE isnull(DiscountValue,0.00)<>0.00 
	and (ISNULL(BeginDate,'')='' OR ISNULL(EndDate,'')='')
	AND ISNULL(ErrMassage,'')=''  
	AND CreateUser=@UserId;
	
	
	--解析规则表
	DECLARE @BU INT
	DECLARE @ID NVARCHAR(50) 
	DECLARE @LeftValue INT
	DECLARE @RightValue INT
	DECLARE @DiscountValue decimal(18, 5)
	DECLARE @BeginDate Datetime
	DECLARE @EndDate Datetime
	
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
		SELECT BU,ID,LeftValue,RightValue,DiscountValue,BeginDate,EndDate 
		FROM dbo.ProductDiscountRule A 
		INNER JOIN V_DivisionProductLineRelation C ON  CONVERT(NVARCHAR(10),A.BU)=C.DivisionCode and C.IsEmerging='0'
		WHERE EXISTS (SELECT 1 FROM ConsignmentDiscountRuleInit B WHERE B.CreateUser=@UserId and CONVERT(NVARCHAR(10),C.ProductLineName)=CONVERT(NVARCHAR(10),B.BU) AND ISNULL(B.ErrMassage,'')='' and ISNULL(B.DiscountValue,0.00)<>0.00)
		AND GETDATE() BETWEEN BeginDate AND EndDate
		
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @BU,@ID,@LeftValue,@RightValue,@DiscountValue,@BeginDate,@EndDate
    WHILE @@FETCH_STATUS = 0        
        BEGIN
			INSERT INTO #RELUTEMP (BU,UPN,LeftValue,RightValue,DiscountValue,BeginDate,EndDate) 
			SELECT @BU,UPN,@LeftValue,@RightValue,@DiscountValue,@BeginDate,@EndDate  
			FROM dbo.func_DiscountRule_getUPN(@ID)
				
         FETCH NEXT FROM @PRODUCT_CUR INTO @BU,@ID,@LeftValue,@RightValue,@DiscountValue,@BeginDate,@EndDate
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
    
	
	UPDATE A SET A.ErrMassage='无折扣规则匹配' FROM ConsignmentDiscountRuleInit A 
	INNER JOIN CFN B ON A.UPN=B.CFN_CustomerFaceNbr 
	INNER JOIN V_DivisionProductLineRelation D ON A.BU=D.DivisionName and d.IsEmerging='0'
	WHERE (ISNULL(CONVERT(NVARCHAR,LeftValue),'')='' OR ISNULL(CONVERT(NVARCHAR,RightValue),'')='') 
	AND isnull(DiscountValue,0.00)=0.00 
	AND ISNULL(ErrMassage,'')=''  
	AND CreateUser=@UserId
	AND ISNULL(DiscountValue,0.00)=0.00 
	AND NOT EXISTS(SELECT 1 FROM #RELUTEMP C WHERE CONVERT(INT,C.BU)=CONVERT(INT,D.DivisionCode) AND CONVERT(NVARCHAR(100),a.UPN)=CONVERT(NVARCHAR(100),c.UPN))
	
	IF EXISTS(SELECT 1 FROM ConsignmentDiscountRuleInit  WHERE ISNULL(ErrMassage,'')<>'' AND CreateUser=@UserId)
	BEGIN
		SET @IsValid='Error';
		RETURN;
	END
	ELSE --IF NOT EXISTS (SELECT 1 FROM ConsignmentDiscountRuleInit  WHERE CreateUser=@UserId and  isnull(DiscountValue,0.00)<>0.00)
	BEGIN
		INSERT INTO #RELUTSUM (BU,DealerSAP,PctLevel,PctLevelCode,UPN,LOT,QRCode,PctNameGroup,LeftValue,RightValue,DiscountValue,ErrMassage,CreateUser,BeginDate,EndDate )
		SELECT A.BU,A.DealerSAP,A.PctLevel,A.PctLevelCode,A.UPN,A.LOT,A.QRCode,A.PctNameGroup,b.LeftValue,b.RightValue,b.DiscountValue,A.ErrMassage,A.CreateUser, isnull(A.BeginDate,CONVERT(NVARCHAR(10),B.BeginDate,120)) BeginDate,isnull(A.EndDate,CONVERT(NVARCHAR(10),B.EndDate,120)) EndDate 
		FROM ConsignmentDiscountRuleInit A 
		INNER JOIN V_DivisionProductLineRelation C ON C.ProductLineName=A.BU AND C.IsEmerging='0'
		INNER JOIN #RELUTEMP B ON CONVERT(INT,C.DivisionCode)=CONVERT(INT,B.BU) AND A.UPN=B.UPN 
		--AND  (A.BeginDate IS NULL OR CONVERT(NVARCHAR(10),A.BeginDate,120)
		WHERE A.CreateUser=@UserId AND isnull(A.DiscountValue,0.00)=0.00 
		
		INSERT INTO #RELUTSUM (BU,DealerSAP,PctLevel,PctLevelCode,UPN,LOT,QRCode,PctNameGroup,LeftValue,RightValue,DiscountValue,ErrMassage,CreateUser,BeginDate,EndDate )
		SELECT A.BU,A.DealerSAP,A.PctLevel,A.PctLevelCode,A.UPN,A.LOT,A.QRCode,A.PctNameGroup,a.LeftValue,a.RightValue,a.DiscountValue,A.ErrMassage,A.CreateUser, isnull(A.BeginDate,CONVERT(NVARCHAR(10),A.BeginDate,120)) BeginDate,isnull(A.EndDate,CONVERT(NVARCHAR(10),A.EndDate,120)) EndDate 
		FROM ConsignmentDiscountRuleInit A 
		INNER JOIN V_DivisionProductLineRelation C ON C.ProductLineName=A.BU AND C.IsEmerging='0'
		WHERE A.CreateUser=@UserId 
		AND isnull(A.DiscountValue,0.00)<>0.00 
		
		DELETE ConsignmentDiscountRuleInit WHERE CreateUser=@UserId;
		
		INSERT INTO ConsignmentDiscountRuleInit (ID,DealerSAP,BU,PctLevel,PctLevelCode,UPN,LOT,QRCode,PctNameGroup,LeftValue,RightValue,DiscountValue,ErrMassage,CreateUser,CreateDate,BeginDate,EndDate)
		SELECT NEWID(),DealerSAP,BU,PctLevel,PctLevelCode,UPN,LOT,QRCode,PctNameGroup,LeftValue,RightValue,DiscountValue,ErrMassage,CreateUser,GETDATE() ,BeginDate,EndDate
		FROM #RELUTSUM
		
		DROP TABLE #RELUTSUM;
	END
	
	IF @ImportType='Import'
	BEGIN
		INSERT INTO dbo.ConsignmentDiscountRule(ID,BU,DealerId,PctLevel,PctLevelCode,UPN,LOT,QRCode,PctNameGroup,LeftValue,RightValue,DiscountValue,CreateUser,CreateDate,BeginDate,EndDate)
		SELECT ID,B.DivisionCode,C.DMA_ID,PctLevel,PctLevelCode,UPN,LOT,QRCode,PctNameGroup,
		CASE WHEN ISNULL(LeftValue,'')='' THEN NULL ELSE CONVERT(INT,LeftValue) END,
		CASE WHEN ISNULL(RightValue,'')='' THEN NULL ELSE CONVERT(INT,RightValue) END,
		CONVERT(DECIMAL(15,8),DiscountValue),CreateUser,CreateDate ,
		CASE WHEN ISNULL(BeginDate,'')='' THEN NULL ELSE CONVERT(datetime,BeginDate) END,
		CASE WHEN ISNULL(EndDate,'')='' THEN NULL ELSE CONVERT(datetime,EndDate) END
		FROM ConsignmentDiscountRuleInit A
		INNER JOIN V_DivisionProductLineRelation B ON A.BU=B.ProductLineName AND B.IsEmerging='0' 
		INNER JOIN DealerMaster C ON C.DMA_SAP_Code=A.DealerSAP
		WHERE CreateUser=@UserId;
	END
	
END 

GO


