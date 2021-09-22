DROP PROCEDURE [Promotion].[Proc_Interface_PointOrderCheck]
GO


/**********************************************
	功能：积分订单自动绑定使用积分
	作者：GrapeCity
	最后更新时间：	2016-03-30
	更新记录说明：
	1.创建 2016-03-30
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_PointOrderCheck]
	@POH_ID NVARCHAR(36),
	@DMA_ID NVARCHAR(36),
	@ProductLineId NVARCHAR(36),
	@PointType NVARCHAR(100),
	@RetValue NVARCHAR(MAX) OUTPUT
AS
BEGIN 
	SET @RetValue='';
	DECLARE @DivisionName NVARCHAR(100)
	  
	Create table #TampPointSub (
	  Id INT,
	  DLid INT,
	  LastAmount DECIMAL(14,2),
	  LastDate DATETIME
	)

	Create table #TampUPN (
	  DLid INT,
	  UPN NVARCHAR(100)
	)
	
	Create table #TampUPNCount (
	  DLid INT,
	  UPNCount INT
	)
	
	Create table #TeampUPNOrderBy(
		POD_POH_ID uniqueidentifier,
		POD_ID uniqueidentifier,
		UPN NVARCHAR(100),
		CFNAmount DECIMAL(14,2),
		DLid INT,
		UPNCount INT
	)
	
	--删除预扣减数据
	DELETE A FROM Promotion.PurchaseOrderPoint A INNER JOIN PurchaseOrderDetail B ON A.POD_ID=B.POD_ID WHERE B.POD_POH_ID=@POH_ID;
		
	--获取基本信息
	--SELECT @DMA_ID=A.POH_DMA_ID,@DivisionName=B.DivisionName,@PointType=POH_PointType FROM PurchaseOrderHeader A  
	--INNER JOIN V_DivisionProductLineRelation B ON A.POH_ProductLine_BUM_ID=B.ProductLineID AND B.IsEmerging='0'  WHERE POH_ID=@POH_ID;
	SELECT @DivisionName=A.DivisionName FROM V_DivisionProductLineRelation A WHERE A.IsEmerging='0' AND A.ProductLineID=@ProductLineId;

	--获取可用积分信息
	INSERT INTO #TampPointSub(Id,DLid,LastAmount,LastDate)
	SELECT b.id,b.DLid,(B.PointAmount-B.OrderAmount+B.OtherAmount) AS LastAmount , 
	CASE WHEN CONVERT(NVARCHAR(10),B.ValidDate,120)>=CONVERT(NVARCHAR(10),B.[ExpireDate],120) THEN B.[ExpireDate] ELSE B.ValidDate END AS ValidDate
	FROM Promotion.PRO_DEALER_POINT A 
	INNER JOIN Promotion.PRO_DEALER_POINT_SUB B ON A.DLid=B.DLid
	INNER JOIN Promotion.PRO_DEALER_POINT_DETAIL C ON A.DLid=C.DLid
	WHERE A.BU=@DivisionName AND A.DEALERID=@DMA_ID AND A.PointType=@PointType
	AND B.[Status]=1 
	AND CONVERT(NVARCHAR(10),B.ValidDate,120)>=CONVERT(NVARCHAR(10),GETDATE(),120) 
	AND (ISNULL(B.[ExpireDate],'')='' OR CONVERT(NVARCHAR(10),B.[ExpireDate],120)>=CONVERT(NVARCHAR(10),GETDATE(),120))
	
	--所有可用政策UPN解析
	DECLARE @DLid INT;
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT DISTINCT A.DLid FROM #TampPointSub A
	OPEN @PRODUCT_CUR
	FETCH NEXT FROM @PRODUCT_CUR INTO @DLid
	WHILE @@FETCH_STATUS = 0        
		BEGIN
			INSERT INTO #TampUPN (DLid,UPN) SELECT @DLid,UPN  FROM [Promotion].[func_Pro_Utility_getPointUPN](@DLid)
		FETCH NEXT FROM @PRODUCT_CUR INTO @DLid
		END
	CLOSE @PRODUCT_CUR
	DEALLOCATE @PRODUCT_CUR ;
	
	--政策区间大小排序
	INSERT INTO #TampUPNCount (DLid,UPNCount)
	SELECT DLid ,UPNCount FROM (
	SELECT DLid,COUNT(UPN) AS UPNCount  FROM #TampUPN GROUP BY DLid) TAB  ORDER BY UPNCount ASC
	
	
	--获取订单Detail产品与可用政策积分关系，并按照区间大小排序
	INSERT INTO #TeampUPNOrderBy(POD_POH_ID,POD_ID,UPN,CFNAmount,DLid,UPNCount)
	SELECT A.POD_POH_ID,A.POD_ID,B.CFN_CustomerFaceNbr,A.POD_Amount,C.DLid,D.UPNCount 
	FROM PurchaseOrderDetail  A 
	INNER JOIN CFN B ON A.POD_CFN_ID=B.CFN_ID 
	INNER JOIN #TampUPN C ON C.UPN=B.CFN_CustomerFaceNbr
	INNER JOIN #TampUPNCount D ON D.DLid=C.DLid
	WHERE A.POD_POH_ID=@POH_ID
	
	
	-----------------------------------------------------------------------------------------------------
	--积分扣减
	-----------------------------------------------------------------------------------------------------
	--1. 或取订单UPN仅在单个区间内的先扣(按照有效期排序)
	DECLARE @UPN NVARCHAR(100);
	DECLARE @PointAmountUser DECIMAL(14,2);
	DECLARE @POD_ID uniqueidentifier, @CFNAmount DECIMAL(14,2) , @Id INT, @LastAmount DECIMAL(14,2),@DeductedAmount DECIMAL(14,2)
	 
	DECLARE @PRODUCT_CUR2 cursor;
	SET @PRODUCT_CUR2=cursor for 
			--获取仅在单个区间的UPN
			--SELECT UPN FROM (
			--SELECT UPN,COUNT(DLid) UPNCOUNT FROM #TeampUPNOrderBy GROUP BY UPN) A WHERE A.UPNCOUNT=1;
			
			--先扣跨区间小的再扣跨区间多的
			SELECT UPN FROM (
			SELECT UPN,COUNT(DLid) UPNCOUNT FROM #TeampUPNOrderBy GROUP BY UPN) A ORDER BY UPNCOUNT ASC ;
	OPEN @PRODUCT_CUR2
	FETCH NEXT FROM @PRODUCT_CUR2 INTO @UPN
	WHILE @@FETCH_STATUS = 0        
		BEGIN
		SET @PointAmountUser=0
		
		/**BEGIN*****循环扣同一区间积分*/
		DECLARE @PRODUCT_CUR3 cursor;
		SET @PRODUCT_CUR3=cursor for 
			SELECT A.POD_ID,A.CFNAmount,B.Id,B.LastAmount FROM #TeampUPNOrderBy A
			INNER JOIN #TampPointSub B ON A.DLid=B.DLid
			WHERE A.UPN=@UPN
			ORDER BY B.LastDate ASC
		OPEN @PRODUCT_CUR3
		FETCH NEXT FROM @PRODUCT_CUR3 INTO @POD_ID ,@CFNAmount,@Id,@LastAmount
		WHILE @@FETCH_STATUS = 0        
			BEGIN
			--获取已扣除积分
			SELECT @DeductedAmount=ISNULL(SUM(Amount),0) 
			FROM Promotion.PurchaseOrderPoint A
			INNER JOIN PurchaseOrderDetail B ON A.POD_ID=B.POD_ID
			 WHERE B.POD_POH_ID=@POH_ID AND PointDetailId=@Id
			
			IF @CFNAmount-@PointAmountUser <= @LastAmount-@DeductedAmount
			BEGIN
				INSERT INTO Promotion.PurchaseOrderPoint (POD_ID,PointDetailId,Amount,CreateBy,CreateTime,ModifyBy,ModifyDate)
				VALUES(@POD_ID,@Id,@CFNAmount-@PointAmountUser,NULL,GETDATE(),NULL,GETDATE())
				SET  @PointAmountUser=@CFNAmount
			END
			ELSE
			BEGIN
				IF @LastAmount-@DeductedAmount>0
				BEGIN
					INSERT INTO Promotion.PurchaseOrderPoint (POD_ID,PointDetailId,Amount,CreateBy,CreateTime,ModifyBy,ModifyDate)
					VALUES(@POD_ID,@Id,(@LastAmount-@DeductedAmount),NULL,GETDATE(),NULL,GETDATE())
					SET  @PointAmountUser=@PointAmountUser+(@LastAmount-@DeductedAmount)
				END
			END
			
			--积分扣满跳出循环
			IF @PointAmountUser=@CFNAmount BREAK;
		
			FETCH NEXT FROM @PRODUCT_CUR3 INTO @POD_ID ,@CFNAmount,@Id,@LastAmount
			END
		CLOSE @PRODUCT_CUR3
		DEALLOCATE @PRODUCT_CUR3 ;
		
		/**END*****循环扣同一区间积分*/
		
		
		
		FETCH NEXT FROM @PRODUCT_CUR2 INTO @UPN
		END
	CLOSE @PRODUCT_CUR2
	DEALLOCATE @PRODUCT_CUR2 ;

	
END 

GO


