USE [GenesisDMS_PRD]
GO
/****** Object:  StoredProcedure [dbo].[GC_LargessForT2Init]    Script Date: 2020/2/26 9:56:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
订单导入
*/
ALTER Procedure [dbo].[GC_LargessForT2Init]
    @UserId uniqueidentifier,
    @ImportType NVARCHAR(20),   --导入类型
	@BrandId NVARCHAR(50),
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
    
AS
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

	Declare @DealerID uniqueidentifier
	Declare @DealerType nvarchar(5)
	DECLARE @m_DmaId uniqueidentifier
	DECLARE @m_ProductLine uniqueidentifier
	DECLARE @m_Id uniqueidentifier
	DECLARE @m_OrderNo nvarchar(50)

	--创建赠品临时表
	create table #mmbo_PRO_DEALER_LARGESS (
	   ID				uniqueidentifier     not null,
	   DEALERID			uniqueidentifier     not null,
	   GiftType			nvarchar(100)         collate Chinese_PRC_CI_AS null,
	   BU				nvarchar(100)         collate Chinese_PRC_CI_AS null,
	   SubBU			nvarchar(100)         collate Chinese_PRC_CI_AS null,
	   LargessAmount	decimal(18,6)        null,
	   OrderAmount		decimal(18,6)        null,
	   OtherAmount		decimal(18,6)        null,
	   DetailDesc		nvarchar(2000)       collate Chinese_PRC_CI_AS null,
	   CreateTime		DATETIME			NULL,
	   Remark1			nvarchar(2000)       collate Chinese_PRC_CI_AS null,
	   primary key (ID)
	)

	create table #mmbo_PRO_DEALER_LARGESS_DETAIL (
	   ID				uniqueidentifier		NOT NULL,
	   ConditionId		INT						NULL,
	   OperTag			nvarchar(30)			collate Chinese_PRC_CI_AS NULL,
	   ConditionValue	nvarchar(2000)			collate Chinese_PRC_CI_AS NULL
	)
	
	
	--创建积分临时表
	create table #mmbo_PRO_DEALER_POINT (
		ID				uniqueidentifier     not null,
		DEALERID		uniqueidentifier     not null,
		PointType		nvarchar(100)         collate Chinese_PRC_CI_AS null,
		BU				nvarchar(100)         collate Chinese_PRC_CI_AS null,
		ListDesc		nvarchar(2000)        collate Chinese_PRC_CI_AS null,
		DetailDesc		nvarchar(2000)        collate Chinese_PRC_CI_AS null,
		CreateTime		DATETIME			NULL,
		ModifyDate		DATETIME			NULL,
		Remark1			nvarchar(2000)        collate Chinese_PRC_CI_AS null,
	   primary key (ID)
	)
	
	create table #mmbo_PRO_DEALER_POINT_SUB(
		ID				uniqueidentifier    not null,
		ValidDate		DATETIME			NULL,
		PointAmount		decimal(18,6)		NULL,
		OrderAmount		decimal(18,6)		NULL,
		OtherAmount		decimal(18,6)		NULL,
		CreateTime		DATETIME			NULL,
		ModifyDate		DATETIME			NULL,
		[Status]			INT				NULL,
		[ExpireDate]		DATETIME		NULL,
		Remark1			nvarchar(2000)      collate Chinese_PRC_CI_AS null,
	)
	

	create table #mmbo_PRO_DEALER_POINT_DETAIL (
	   ID				uniqueidentifier		NOT NULL,
	   ConditionId		INT						NULL,
	   OperTag			nvarchar(30)			collate Chinese_PRC_CI_AS NULL,
	   ConditionValue	nvarchar(2000)			collate Chinese_PRC_CI_AS NULL
	)
	

	/*先将错误标志设为0*/
	--UPDATE Pro_LargessForT2_Init SET ErrorFlag = 0,PolicyNoErrMsg = NULL,PolicyTypeErrmsg=NULL,SAPCodeErrMsg=NULL,BUErrMsg=NULL,ValidDateErrMsg=NULL,PointTypeErrMsg=NULL,FreeGoodsErrMsg=NULL ,CurrentPeriodErrMsg=NULL    WHERE UserId = @UserId

	--检查经销商是否存在
	UPDATE A SET A.SAPCodeErrMsg =  N'经销商不存在',ErrorFlag = 1  FROM Pro_LargessForT2_Init A 
	WHERE UserId=@UserId 
	AND NOT EXISTS (select 1 from DealerMaster B WHERE B.DMA_SAP_Code=ISNULL(A.SAPCode,''))
	AND ISNULL(SAPCodeErrMsg,'')=''
	
	--20191230 add 内部用户允许导入LP、T1、T2的积分；LP只允许导入它下级的经销商
	 IF EXISTS(SELECT 1 FROM  dbo.Lafite_IDENTITY
               WHERE Id=@UserId AND IDENTITY_TYPE='Dealer')
	  BEGIN 
		UPDATE A SET A.SAPCodeErrMsg =  N'此经销商不属于贵司二级',ErrorFlag = 1  FROM Pro_LargessForT2_Init A 
		WHERE UserId=@UserId 
		AND NOT EXISTS (select 1 from DealerMaster B WHERE B.DMA_SAP_Code=ISNULL(A.SAPCode,'') AND B.DMA_Parent_DMA_ID IN (SELECT CC.Corp_ID FROM Lafite_IDENTITY CC WHERE Id=@UserId))
		AND ISNULL(SAPCodeErrMsg,'')=''
	END 
	--检查政策类型是否正确
	UPDATE A SET A.PolicyTypeErrmsg =  N'促销类型填写不正确（请填写积分或者赠品）',ErrorFlag = 1  FROM Pro_LargessForT2_Init A 
	WHERE UserId=@UserId 
	AND ISNULL(A.PolicyType,'') NOT IN ('积分','赠品')
	AND ISNULL(PolicyTypeErrmsg,'')=''
	
	--检查促销编号
	UPDATE A SET A.PolicyNoErrMsg =  N'促销编号填写不正确',ErrorFlag = 1  FROM Pro_LargessForT2_Init A 
	WHERE UserId=@UserId 
	AND NOT EXISTS (SELECT 1 FROM Promotion.T_Pro_Use_Product B WHERE A.PolicyNo=B.PolicyNo)
	AND A.PolicyNo <>'平台促销奖励'	
	AND ISNULL(PolicyNoErrMsg,'')=''
	
	
	--产品线填写不正确
	UPDATE A SET A.BUErrMsg =  N'产品线填写不正确',ErrorFlag = 1  FROM Pro_LargessForT2_Init A 
	WHERE UserId=@UserId 
	AND NOT EXISTS (SELECT 1 FROM V_DivisionProductLineRelation B WHERE B.IsEmerging='0' AND  A.BU=B.ProductLineName AND B.BrandId=@BrandId)
	AND ISNULL(BUErrMsg,'')=''
	
	--积分有效期填写不正确
	UPDATE A SET A.ValidDateErrMsg =  N'积分有效期填写不正确(必须大于当前日期)',ErrorFlag = 1  FROM Pro_LargessForT2_Init A 
	WHERE UserId=@UserId 
	AND A.PolicyType='积分'
	AND CONVERT(NVARCHAR(8),CONVERT(datetime,isnull(ValidDate,'1999-01-01')),112)<=CONVERT(NVARCHAR(8),GETDATE(),112)
	AND ISNULL(ValidDateErrMsg,'')=''
	
	--积分类型填写不正确
	UPDATE A SET A.PointTypeErrMsg =  N'积分类型填写不正确(Point,Money)',ErrorFlag = 1  FROM Pro_LargessForT2_Init A 
	WHERE UserId=@UserId 
	AND A.PolicyType='积分'
	AND ISNULL(A.PointType,'')  NOT IN ('Point','Money')
	AND ISNULL(PointTypeErrMsg,'')=''
	

	--20200114,积分、促销验证产品线下的授权是否正确
	UPDATE A SET A.AuthProductTypeErrMsg =  N'该产品线的授权不正确或部分不存在；请检查excel导入文件对应行授权',ErrorFlag = 1  FROM Pro_LargessForT2_Init A 
	WHERE UserId=@UserId 
	 AND dbo.Func_ReturnAuthTypeStatus(A.AuthProductType,a.BU)=1
	AND ISNULL(A.AuthProductTypeErrMsg,'')=''

	UPDATE A SET A.PL5ErrMsg =  N'该产品线的PL5不存在；请检查excel导入文件对应行PL5',ErrorFlag = 1  FROM Pro_LargessForT2_Init A 
	WHERE UserId=@UserId 
	AND NOT EXISTS(
	 SELECT 1 FROM View_LocalProductMaster E 
							WHERE CONVERT(NVARCHAR(20),E.DivisionID) IN (SELECT PR.DivisionCode FROM V_DivisionProductLineRelation PR WHERE PR.IsEmerging='0' AND PR.ProductLineName=A.BU AND PR.BrandId=@BrandId)
							  AND E.ProductLine5=A.PL5
	)
	 AND ISNULL(A.PL5,'')<>''
	AND ISNULL(A.PL5ErrMsg,'')=''


	--积分额度
	--无校验
	
	--账期填写不正确(账期填写实例：2019Q1 、 201901 、 2019)
	UPDATE A SET A.CurrentPeriodErrMsg =  N'账期填写不正确（季度结算：2019Q1 ，月度结算：201901，年度结算：2019）',ErrorFlag = 1  FROM Pro_LargessForT2_Init A 
	WHERE UserId=@UserId 
	AND LEN(ISNULL(CurrentPeriod,'')) NOT IN (6,4)
		AND ISNULL(CurrentPeriodErrMsg,'')=''


	--检查是否存在错误
	IF (SELECT COUNT(*) FROM Pro_LargessForT2_Init WHERE ErrorFlag = 1 AND UserId = @UserId) > 0  
		BEGIN
			/*如果存在错误，则返回Error*/
			SET @IsValid = 'Error'
		END
	ELSE
		BEGIN
			/*如果不存在错误，则返回Success*/		
			SET @IsValid = 'Success'
		
  
  IF @ImportType = 'Import'
  BEGIN
  
	/*Begin 赠品*/
	--插入临时订单主表
	--select * from #mmbo_PRO_DEALER_LARGESS
	INSERT INTO #mmbo_PRO_DEALER_LARGESS (ID,DEALERID,GiftType,BU,SubBU,LargessAmount,OrderAmount,OtherAmount,DetailDesc,CreateTime,Remark1)
	SELECT A.Id,b.DMA_ID,'FreeGoods',C.DivisionName
		,(select TOP 1 SubBU from Promotion.T_Pro_Use_Product PO WHERE A.PolicyNo=PO.PolicyNo) AS SubBU
		,A.FreeGoods,0 AS OrderAmount,0 AS OtherAmount
		,A.RemarMag  AS DetailDesc
		,GETDATE() AS CreateTime
		,ID AS Remark1
		FROM Pro_LargessForT2_Init A 
		INNER JOIN DealerMaster B ON A.SAPCode=B.DMA_SAP_Code
		INNER JOIN V_DivisionProductLineRelation C ON C.IsEmerging='0' AND A.BU=C.ProductLineName AND C.BrandId=@BrandId
	WHERE A.UserId=@UserId
	AND  A.PolicyType='赠品'
	
	INSERT INTO #mmbo_PRO_DEALER_LARGESS_DETAIL(ID,ConditionId,OperTag,ConditionValue)
	SELECT A.Id
		,ConditionId=(CASE WHEN B.PolicyScope='产品' AND B.SelectCode='ALL'  --全部产品
						THEN 3
					 WHEN B.PolicyScope='产品' AND B.SelectCode<>'ALL'  --部分指定UPN
						THEN 1
					 WHEN (B.PolicyScope='产品线1' OR B.PolicyScope='产品线2' OR B.PolicyScope='产品线3' OR B.PolicyScope='产品线4'  OR B.PolicyScope='产品线5') --产品组
						THEN 3
					ELSE 3 END)
		,B.SelectType
		,ConditionValue=(CASE 
							WHEN B.PolicyScope='产品' AND B.SelectCode='ALL'   --全部产品
								THEN (SELECT STUFF(REPLACE(REPLACE((SELECT distinct 'Level1,'+CONVERT(NVARCHAR(20),ProductLineID1) RESULT 
									FROM View_LocalProductMaster E 
								WHERE 
									(E.SubBUCode=B.SubBU AND ISNULL(B.ProductApplyRange,'Bu')='SubBU'  AND E.DivisionID=b.BU)
									OR (ISNULL(B.ProductApplyRange,'Bu')='Bu' AND E.DivisionID=b.BU)
								  FOR XML AUTO), '<E RESULT="', '|'), '"/>', ''), 1, 1, ''))
							WHEN B.PolicyScope='产品' AND B.SelectCode<>'ALL'  --部分指定UPN
								THEN b.SelectCode
							WHEN B.PolicyScope='授权' AND B.SelectCode='ALL'--全部授权 
							     THEN (SELECT STUFF(REPLACE(REPLACE((SELECT distinct 'AuthType,'+CONVERT(NVARCHAR(20),CA_Code) RESULT 
								      FROM dbo.V_ProductClassificationStructure V
									  INNER JOIN view_ProductLine vp ON V.CC_ProductLineID=vp.ID AND vp.BrandId=@BrandId
                             WHERE V.CC_ProductLineName=A.BU
							      FOR XML AUTO), '<V RESULT="', '|'), '"/>', ''), 1, 1, ''))
							WHEN B.PolicyScope='授权' AND B.SelectCode<>'ALL'  --部分指定授权
								THEN  'AuthType,'+b.SelectCode	
							WHEN (B.PolicyScope='产品线1' OR B.PolicyScope='产品线2' OR B.PolicyScope='产品线3' OR B.PolicyScope='产品线4'  OR B.PolicyScope='产品线5') --产品组
								THEN CASE	
										WHEN PolicyScope='产品线1'  THEN 'Level1,'+b.SelectCode 
										WHEN PolicyScope='产品线2'  THEN 'Level2,'+b.SelectCode 
										WHEN PolicyScope='产品线3'  THEN 'Level3,'+b.SelectCode 
										WHEN PolicyScope='产品线4'  THEN 'Level4,'+b.SelectCode 
										WHEN PolicyScope='产品线5'  THEN 'Level5,'+b.SelectCode 
									END 
								ELSE b.SelectCode
							END
						)
	FROM Pro_LargessForT2_Init A
	INNER JOIN Promotion.T_Pro_Use_Product B ON A.PolicyNo=B.PolicyNo
	WHERE A.UserId=@UserId
	AND  A.PolicyType='赠品'
	AND A.PolicyNo<>'平台促销奖励'

	/*处理平台特殊编号适用全产品*/
	INSERT INTO #mmbo_PRO_DEALER_LARGESS_DETAIL(ID,ConditionId,OperTag,ConditionValue)
	SELECT A.Id ,3 ,'包含'
		--,ConditionValue=(SELECT STUFF(REPLACE(REPLACE((SELECT distinct 'Level1,'+CONVERT(NVARCHAR(20),ProductLineID1) RESULT 
		--						FROM View_LocalProductMaster E 
		--					WHERE CONVERT(NVARCHAR(20),E.DivisionID) IN (SELECT PR.DivisionCode FROM V_DivisionProductLineRelation PR WHERE PR.IsEmerging='0' AND PR.ProductLineName=A.BU )
		--					 FOR XML AUTO), '<E RESULT="', '|'), '"/>', ''), 1, 1, ''))
	      ,ConditionValue=(
		         CASE WHEN ISNULL(A.PL5,'')<>'' THEN (SELECT STUFF(REPLACE(REPLACE((SELECT distinct 'Level5,'+CONVERT(NVARCHAR(20),E.ProductLine5) RESULT 
								FROM View_LocalProductMaster E 
							WHERE CONVERT(NVARCHAR(20),E.DivisionID) IN (SELECT PR.DivisionCode FROM V_DivisionProductLineRelation PR WHERE PR.IsEmerging='0' AND PR.ProductLineName=A.BU AND PR.BrandId=@BrandId)
							  AND E.ProductLine5=A.PL5
							 FOR XML AUTO), '<E RESULT="', '|'), '"/>', ''), 1, 1, '')) --PL5
	            WHEN ISNULL(A.PL5,'')='' AND ISNULL(A.AuthProductType,'')<>'' THEN dbo.Func_GetAuthTypeStr(A.AuthProductType,A.BU) --授权产品线

		        ELSE (SELECT STUFF(REPLACE(REPLACE((SELECT distinct 'AuthType,'+CONVERT(NVARCHAR(20),CA_Code) RESULT 
								      FROM dbo.V_ProductClassificationStructure V
									  INNER JOIN view_ProductLine vp ON V.CC_ProductLineID=vp.ID AND vp.BrandId=@BrandId
                             WHERE V.CC_ProductLineName=A.BU
							      FOR XML AUTO), '<V RESULT="', '|'), '"/>', ''), 1, 1, ''))  --全产品线
		          END
		         )
	FROM Pro_LargessForT2_Init A
	WHERE A.UserId=@UserId
	AND  A.PolicyType='赠品'
	AND A.PolicyNo='平台促销奖励'

	
    --插入赠品主表
	insert into Promotion.PRO_DEALER_LARGESS(DEALERID,GiftType,BU,SubBU,LargessAmount,OrderAmount,OtherAmount,DetailDesc,CreateTime,Remark1)
	SELECT DEALERID,GiftType,BU,SubBU,LargessAmount,OrderAmount,OtherAmount,DetailDesc,CreateTime,Remark1 
	FROM #mmbo_PRO_DEALER_LARGESS

	--插入使用产品区间
    INSERT INTO Promotion.PRO_DEALER_LARGESS_DETAIL(DLid,ConditionId,OperTag,ConditionValue) 
	SELECT B.DLid,A.ConditionId,A.OperTag,A.ConditionValue
	FROM #mmbo_PRO_DEALER_LARGESS_DETAIL A 
	INNER JOIN Promotion.PRO_DEALER_LARGESS B ON CONVERT(NVARCHAR(36),A.ID)=B.Remark1 --通过备注表ID关系数据

	--插入操作日志
	INSERT INTO PROMOTION.PRO_DEALER_LARGESS_LOG(DLid,DLFrom,PolicyId,DEALERID,Period,MXID,Amount,OtherMemo,LogDate,Remark)
	SELECT B.DLid,'政策奖励'
	,(SELECT TOP 1 C.PolicyNo FROM  Pro_LargessForT2_Init C WHERE CONVERT(NVARCHAR(36),C.Id)=A.Remark1)
	,A.DEALERID
	,(SELECT TOP 1 C.CurrentPeriod FROM  Pro_LargessForT2_Init C WHERE CONVERT(NVARCHAR(36),C.Id)=A.Remark1)
	,NULL
	,A.LargessAmount
	,A.DetailDesc
	,GETDATE()
	,(SELECT TOP 1 BB.DMA_SAP_Code FROM DealerMaster AA INNER JOIN DealerMaster BB ON AA.DMA_Parent_DMA_ID=BB.DMA_ID WHERE AA.DMA_ID=A.DEALERID)
	 FROM #mmbo_PRO_DEALER_LARGESS A 
	INNER JOIN Promotion.PRO_DEALER_LARGESS B ON CONVERT(NVARCHAR(36),A.ID)=B.Remark1
	
	UPDATE A SET A.Remark1=''
	FROM Promotion.PRO_DEALER_LARGESS A 
	INNER JOIN #mmbo_PRO_DEALER_LARGESS B ON A.Remark1=CONVERT(NVARCHAR(36),B.ID)
	
	/*End 赠品*/
	
	
	/*Begin 积分*/
	--SELECT * FROM #mmbo_PRO_DEALER_POINT
	INSERT INTO #mmbo_PRO_DEALER_POINT (ID,DEALERID,PointType,BU,ListDesc,DetailDesc,CreateTime,ModifyDate,Remark1)
	SELECT A.Id,b.DMA_ID,a.PointType,C.DivisionName
		,NULL AS ListDesc
		,A.RemarMag  AS DetailDesc
		,GETDATE() AS CreateTime
		,NULL ModifyDate
		,ID AS Remark1
		FROM Pro_LargessForT2_Init A 
		INNER JOIN DealerMaster B ON A.SAPCode=B.DMA_SAP_Code
		INNER JOIN V_DivisionProductLineRelation C ON C.IsEmerging='0' AND A.BU=C.ProductLineName AND C.BrandId=@BrandId
	WHERE A.UserId=@UserId
	AND  A.PolicyType='积分'
	
	--SELECT * FROM #mmbo_PRO_DEALER_POINT_SUB
	INSERT INTO #mmbo_PRO_DEALER_POINT_SUB(ID,ValidDate,PointAmount,OrderAmount,OtherAmount,CreateTime,ModifyDate,Status,ExpireDate,Remark1)
	SELECT A.Id,A.ValidDate,A.FreeGoods,0 AS OrderAmount,0 AS OtherAmount, GETDATE(),NULL,1 ,NULL,A.Id
	FROM Pro_LargessForT2_Init A  
	WHERE A.UserId=@UserId
	AND  A.PolicyType='积分'
	
	--SELECT * FROM #mmbo_PRO_DEALER_POINT_DETAIL
	INSERT INTO #mmbo_PRO_DEALER_POINT_DETAIL(ID,ConditionId,OperTag,ConditionValue)
	SELECT A.Id
		,ConditionId=(CASE WHEN B.PolicyScope='产品' AND B.SelectCode='ALL'  --全部产品
						THEN 3
					 WHEN B.PolicyScope='产品' AND B.SelectCode<>'ALL'  --部分指定UPN
						THEN 1
					 WHEN (B.PolicyScope='产品线1' OR B.PolicyScope='产品线2' OR B.PolicyScope='产品线3' OR B.PolicyScope='产品线4'  OR B.PolicyScope='产品线5') --产品组
						THEN 3
					ELSE 3 END)
		,B.SelectType
		,ConditionValue=(CASE 
							WHEN B.PolicyScope='产品' AND B.SelectCode='ALL'   --全部产品
								THEN (SELECT STUFF(REPLACE(REPLACE((SELECT distinct 'Level1,'+CONVERT(NVARCHAR(20),ProductLineID1) RESULT FROM View_LocalProductMaster E 
								WHERE --E.SubBUCode=B.SubBU AND E.DivisionID=b.BU  
								(E.SubBUCode=B.SubBU AND ISNULL(B.ProductApplyRange,'Bu')='SubBU'  AND E.DivisionID=b.BU)
									OR (ISNULL(B.ProductApplyRange,'Bu')='Bu' AND E.DivisionID=b.BU)
								FOR XML AUTO), '<E RESULT="', '|'), '"/>', ''), 1, 1, ''))
							WHEN B.PolicyScope='产品' AND B.SelectCode<>'ALL'  --部分指定UPN
								THEN b.SelectCode
							WHEN B.PolicyScope='授权' AND B.SelectCode='ALL'--全部授权 
							     THEN (SELECT STUFF(REPLACE(REPLACE((SELECT distinct 'AuthType,'+CONVERT(NVARCHAR(20),CA_Code) RESULT 
								      FROM dbo.V_ProductClassificationStructure V
									  INNER JOIN view_ProductLine vp ON V.CC_ProductLineID=vp.ID AND vp.BrandId=@BrandId
                             WHERE V.CC_ProductLineName=A.BU
							      FOR XML AUTO), '<V RESULT="', '|'), '"/>', ''), 1, 1, ''))
							WHEN B.PolicyScope='授权' AND B.SelectCode<>'ALL'  --部分指定授权
								THEN  'AuthType,'+b.SelectCode
							WHEN (B.PolicyScope='产品线1' OR B.PolicyScope='产品线2' OR B.PolicyScope='产品线3' OR B.PolicyScope='产品线4'  OR B.PolicyScope='产品线5') --产品组
								THEN CASE	
										WHEN PolicyScope='产品线1'  THEN 'Level1,'+b.SelectCode 
										WHEN PolicyScope='产品线2'  THEN 'Level2,'+b.SelectCode 
										WHEN PolicyScope='产品线3'  THEN 'Level3,'+b.SelectCode 
										WHEN PolicyScope='产品线4'  THEN 'Level4,'+b.SelectCode 
										WHEN PolicyScope='产品线5'  THEN 'Level5,'+b.SelectCode 
									END 
								ELSE b.SelectCode
							END
						)
	FROM Pro_LargessForT2_Init A
	INNER JOIN Promotion.T_Pro_Use_Product B ON A.PolicyNo=B.PolicyNo
	WHERE A.UserId=@UserId
	AND  A.PolicyType='积分'
	AND A.PolicyNo<>'平台促销奖励'

	/*处理平台特殊编号适用全产品*/
	INSERT INTO #mmbo_PRO_DEALER_POINT_DETAIL(ID,ConditionId,OperTag,ConditionValue)
	SELECT A.Id ,3 ,'包含'
		--,ConditionValue=(SELECT STUFF(REPLACE(REPLACE((SELECT distinct 'Level5,'+CONVERT(NVARCHAR(20),ProductLineID5) RESULT 
		--						FROM View_LocalProductMaster E 
		--					WHERE CONVERT(NVARCHAR(20),E.DivisionID) IN (SELECT PR.DivisionCode FROM V_DivisionProductLineRelation PR WHERE PR.IsEmerging='0' AND PR.ProductLineName=A.BU )
		--					 FOR XML AUTO), '<E RESULT="', '|'), '"/>', ''), 1, 1, ''))
		,ConditionValue=(
		CASE WHEN ISNULL(A.PL5,'')<>'' THEN (SELECT STUFF(REPLACE(REPLACE((SELECT distinct 'Level5,'+CONVERT(NVARCHAR(20),E.ProductLine5) RESULT 
								FROM View_LocalProductMaster E 
							WHERE CONVERT(NVARCHAR(20),E.DivisionID) IN (SELECT PR.DivisionCode FROM V_DivisionProductLineRelation PR WHERE PR.IsEmerging='0' AND PR.ProductLineName=A.BU AND PR.BrandId=@BrandId)
							  AND E.ProductLine5=A.PL5
							 FOR XML AUTO), '<E RESULT="', '|'), '"/>', ''), 1, 1, '')) --PL5
	        WHEN ISNULL(A.PL5,'')='' AND ISNULL(A.AuthProductType,'')<>'' THEN dbo.Func_GetAuthTypeStr(A.AuthProductType,A.BU) --授权产品线

		    ELSE (SELECT STUFF(REPLACE(REPLACE((SELECT distinct 'AuthType,'+CONVERT(NVARCHAR(20),CA_Code) RESULT 
								      FROM dbo.V_ProductClassificationStructure V
									  INNER JOIN view_ProductLine vp ON V.CC_ProductLineID=vp.ID AND vp.BrandId=@BrandId
                             WHERE V.CC_ProductLineName=A.BU
							      FOR XML AUTO), '<V RESULT="', '|'), '"/>', ''), 1, 1, ''))  --全产品线
		END
		)
	FROM Pro_LargessForT2_Init A
	WHERE A.UserId=@UserId
	AND  A.PolicyType='积分'
	AND A.PolicyNo='平台促销奖励'



	--插入赠品主表
	insert into Promotion.PRO_DEALER_POINT(DEALERID,PointType,BU,ListDesc,DetailDesc,CreateTime,ModifyDate,Remark1)
	SELECT DEALERID,PointType,BU,ListDesc,DetailDesc,CreateTime,ModifyDate,Remark1 
	FROM #mmbo_PRO_DEALER_POINT
	
	--插入明细表
	INSERT INTO Promotion.PRO_DEALER_POINT_SUB(DLid,ValidDate,PointAmount,OrderAmount,OtherAmount,CreateTime,ModifyDate,Status,ExpireDate,Remark1)
	SELECT B.DLid,A.ValidDate,A.PointAmount,OrderAmount,OtherAmount,A.CreateTime,A.ModifyDate,[Status],[ExpireDate],A.Remark1
	FROM #mmbo_PRO_DEALER_POINT_SUB A
	INNER JOIN Promotion.PRO_DEALER_POINT B ON CONVERT(NVARCHAR(36),A.ID)=B.Remark1


	--插入使用产品区间
    INSERT INTO Promotion.PRO_DEALER_POINT_DETAIL(DLid,ConditionId,OperTag,ConditionValue) 
	SELECT B.DLid,A.ConditionId,A.OperTag,A.ConditionValue
	FROM #mmbo_PRO_DEALER_POINT_DETAIL A 
	INNER JOIN Promotion.PRO_DEALER_POINT B ON CONVERT(NVARCHAR(36),A.ID)=B.Remark1 --通过备注表ID关系数据

	--插入操作日志
	INSERT INTO PROMOTION.PRO_DEALER_POINT_LOG(DLid,DLFrom,PolicyId,DEALERID,Period,MXID,Amount,OtherMemo,LogDate,Remark)
	SELECT B.DLid,'政策奖励'
	,(SELECT TOP 1 C.PolicyNo FROM  Pro_LargessForT2_Init C WHERE CONVERT(NVARCHAR(36),C.Id)=A.Remark1)
	,A.DEALERID
	,(SELECT TOP 1 C.CurrentPeriod FROM  Pro_LargessForT2_Init C WHERE CONVERT(NVARCHAR(36),C.Id)=A.Remark1)
	,NULL
	,C.PointAmount
	,A.DetailDesc
	,GETDATE()
	,(SELECT TOP 1 BB.DMA_SAP_Code FROM DealerMaster AA INNER JOIN DealerMaster BB ON AA.DMA_Parent_DMA_ID=BB.DMA_ID WHERE AA.DMA_ID=A.DEALERID)
	 FROM #mmbo_PRO_DEALER_POINT A
	INNER JOIN #mmbo_PRO_DEALER_POINT_SUB C ON A.ID=C.ID
	INNER JOIN Promotion.PRO_DEALER_POINT B ON CONVERT(NVARCHAR(36),A.ID)=B.Remark1
	
	UPDATE A SET A.Remark1=''
	FROM Promotion.PRO_DEALER_POINT_SUB A 
	INNER JOIN #mmbo_PRO_DEALER_POINT_SUB B ON A.Remark1=CONVERT(NVARCHAR(36),B.ID)
	
	UPDATE A SET A.Remark1=''
	FROM Promotion.PRO_DEALER_POINT A 
	INNER JOIN #mmbo_PRO_DEALER_POINT B ON A.Remark1=CONVERT(NVARCHAR(36),B.ID)
	
	/*End 积分*/
	
			
	END
		
				
		
			
END

COMMIT TRAN

SET NOCOUNT OFF
return 1
END TRY
BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
    return -1
    
END CATCH



























