
/****** Object:  StoredProcedure [dbo].[Pro_GetShipmentInitList]    Script Date: 2019/9/24 9:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [dbo].[Pro_GetShipmentInitList] '62A62037-A71E-47EF-BD49-FD20C10A6AAC','','20180101','20191231','','','62A62037-A71E-47EF-BD49-FD20C10A6AAC','0','100'
/**********************************************
	功能：经销商销售单批量导入查询
	作者：Huakaichun
	最后更新时间：	2019-08-23
	更新记录说明：
	1.创建 2019-08-23
**********************************************/
CREATE PROCEDURE [dbo].[Pro_GetShipmentInitList]
	@DtmId NVARCHAR(36),
	@ShipmentStatus NVARCHAR(36),
	@SubmitDateStart NVARCHAR(36),
	@SubmitDateEnd NVARCHAR(36),
	@ShipmentInitNo NVARCHAR(50),
	@UserType NVARCHAR(50),
	@CreateUser NVARCHAR(36),
	@PageNum INT,
	@PageSize INT
AS
BEGIN
	DECLARE @HospitalId uniqueidentifier 

	CREATE TABLE #GetDateTable(
		Id uniqueidentifier,
		OrderNo NVARCHAR(36),
		DmaId NVARCHAR(36),
		SubmitDate DATETIME,
		InitStatus NVARCHAR(100),
		TotalQty NVARCHAR(200),
		OperType NVARCHAR(100)
	)

	CREATE TABLE #ReturnTable(
		Id uniqueidentifier,
		OrderNo NVARCHAR(36),
		DmaId NVARCHAR(36),
		SubmitDate DATETIME,
		InitStatus NVARCHAR(100),
		TotalQty NVARCHAR(200),
		OperType NVARCHAR(100),
		ROWNUMBER   INT,
		PRIMARY KEY(ROWNUMBER)
	)
		INSERT INTO #GetDateTable(Id,OrderNo,DmaId,SubmitDate,InitStatus,TotalQty,OperType)
		SELECT A.SRH_ID AS Id,A.SRH_SPI_NO AS OrderNo,A.SRH_Dealer_DMA_ID AS DmaId,A.SRH_SubmitDate AS SubmitDate,A.SRH_Status AS InitStatus,SUM(B.SRD_LotShippedQty) AS TotalQty
		,CASE WHEN ISNULL(A.SRH_OperType,'1') =1 THEN '校验并提交' ELSE '仅校验不提交' END AS OperType
		FROM ShipmentResultHeader A(nolock)
		INNER JOIN ShipmentResultDetail B(nolock) ON A.SRH_ID=B.SRD_SRH_ID
		INNER JOIN DealerMaster C(nolock) ON A.SRH_Dealer_DMA_ID=C.DMA_ID
		WHERE 
		( ISNULL(@DtmId,'')='' OR A.SRH_Dealer_DMA_ID=@DtmId)
		AND (A.SRH_Status=@ShipmentStatus OR ISNULL(@ShipmentStatus,'')='')
		AND CONVERT(NVARCHAR(8), A.SRH_SubmitDate, 112)>=@SubmitDateStart
		AND CONVERT(NVARCHAR(8), A.SRH_SubmitDate, 112) <= @SubmitDateEnd
		AND (A.SRH_SPI_NO=@ShipmentInitNo OR ISNULL(@ShipmentInitNo,'')='')
		AND ((ISNULL(@UserType,'')='Dealer' AND  (C.DMA_ID=@CreateUser OR C.DMA_Parent_DMA_ID=@CreateUser)) OR (ISNULL(@UserType,'') <> 'Dealer' ))
	    GROUP BY A.SRH_ID,A.SRH_SPI_NO,A.SRH_Dealer_DMA_ID,A.SRH_SubmitDate,A.SRH_Status,SRH_OperType


		INSERT INTO #GetDateTable(Id,OrderNo,DmaId,SubmitDate,InitStatus,TotalQty,OperType)
		SELECT  NEWID() AS Id,SPI_NO AS OrderNo ,B.Corp_ID AS DmaId,CONVERT(DATETIME,CONVERT(NVARCHAR(10),SPI_UploadDate,120)) AS SubmitDate,'Submitted' AS InitStatus,
		SUM(CONVERT(decimal(18,4),CASE WHEN ISNULL(A.SPI_Qty,'0')='' THEN '0' ELSE A.SPI_Qty END)) AS TotalQty
		,CASE WHEN ISNULL(A.SPI_OperType,'1') =1 THEN '校验并提交' ELSE '仅校验不提交' END AS OperType
		FROM ShipmentInit A(nolock)
		INNER JOIN Lafite_IDENTITY B(nolock) ON A.SPI_USER=B.Id
		INNER JOIN DealerMaster C(nolock) ON B.Corp_ID=C.DMA_ID
		WHERE A.SPI_NO IS NOT NULL
		AND (ISNULL(@DtmId,'')='' OR B.Corp_ID=@DtmId )
		AND (@ShipmentStatus='Submitted' OR ISNULL(@ShipmentStatus,'')='')
		AND CONVERT(NVARCHAR(8), A.SPI_UploadDate, 112)>=@SubmitDateStart
		AND CONVERT(NVARCHAR(8), A.SPI_UploadDate, 112) <= @SubmitDateEnd
		AND (A.SPI_NO=@ShipmentInitNo OR ISNULL(@ShipmentInitNo,'')='')
		AND ((ISNULL(@UserType,'')='Dealer' AND  ((C.DMA_ID=@CreateUser OR C.DMA_Parent_DMA_ID=@CreateUser))) OR (ISNULL(@UserType,'') <> 'Dealer' ))
		GROUP BY SPI_NO,B.Corp_ID,CONVERT(NVARCHAR(10),SPI_UploadDate,120),A.SPI_OperType
		
	
	INSERT INTO #ReturnTable(Id,OrderNo,DmaId,SubmitDate,InitStatus,TotalQty,OperType,ROWNUMBER)
	SELECT Id,OrderNo,DmaId,SubmitDate,InitStatus,TotalQty,OperType,row_number () OVER (ORDER BY SubmitDate DESC)
	FROM #GetDateTable

	SELECT COUNT(*) CNT FROM #ReturnTable;
	
	SELECT Id,OrderNo,DmaId,SubmitDate,InitStatus,TotalQty,OperType,ROWNUMBER
	FROM   #ReturnTable  A
	WHERE  ROWNUMBER  BETWEEN @PageSize * @PageNum + 1 AND @PageSize * (@PageNum+1);
	
	
END  


