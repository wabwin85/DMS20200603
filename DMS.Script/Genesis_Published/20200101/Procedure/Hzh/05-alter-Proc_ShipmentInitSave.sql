SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
/**********************************************
	功能：销售单批量导入执行
	作者：GrapeCity
	最后更新时间：	2018-06-22
	更新记录说明：
	1.创建 2018-06-22
**********************************************/
ALTER PROCEDURE [dbo].[Proc_ShipmentInitSave] 
	
AS
BEGIN TRY

DECLARE @SPI_NO nvarchar(50)
DECLARE @UserId UNIQUEIDENTIFIER
DECLARE @SubCompanyId UNIQUEIDENTIFIER
DECLARE @BrandId UNIQUEIDENTIFIER

CREATE TABLE #ShipmentInitTemp(
	[SPI_ID] [uniqueidentifier] NOT NULL,
	[SPI_USER] [uniqueidentifier] NOT NULL,
	[SPI_UploadDate] [datetime] NOT NULL,
	[SPI_LineNbr] [int] NOT NULL,
	[SPI_FileName] [nvarchar](200)          collate Chinese_PRC_CI_AS NOT NULL,
	[SPI_ErrorFlag] [bit] NOT NULL,
	[SPI_ErrorDescription] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_SaleType] [nvarchar](20)          collate Chinese_PRC_CI_AS NOT NULL,
	[SPI_HospitalCode] [nvarchar](50)          collate Chinese_PRC_CI_AS NULL,
	[SPI_HospitalName] [nvarchar](200)          collate Chinese_PRC_CI_AS NULL,
	[SPI_HospitalOffice] [nvarchar](200)          collate Chinese_PRC_CI_AS NULL,
	[SPI_InvoiceNumber] [nvarchar](400)          collate Chinese_PRC_CI_AS NULL,
	[SPI_InvoiceDate] [nvarchar](20)          collate Chinese_PRC_CI_AS NULL,
	[SPI_InvoiceTitle] [nvarchar](200)          collate Chinese_PRC_CI_AS NULL,
	[SPI_ShipmentDate] [nvarchar](20)          collate Chinese_PRC_CI_AS NULL,
	[SPI_ArticleNumber] [nvarchar](200)          collate Chinese_PRC_CI_AS NULL,
	[SPI_ChineseName] [nvarchar](200)          collate Chinese_PRC_CI_AS NULL,
	[SPI_LotNumber] [nvarchar](20)          collate Chinese_PRC_CI_AS NULL,
	[SPI_Price] [nvarchar](20)          collate Chinese_PRC_CI_AS NULL,
	[SPI_ExpiredDate] [nvarchar](20)          collate Chinese_PRC_CI_AS NULL,
	[SPI_UOM] [nvarchar](20)          collate Chinese_PRC_CI_AS NULL,
	[SPI_Qty] [nvarchar](20)          collate Chinese_PRC_CI_AS NULL,
	[SPI_Warehouse] [nvarchar](50)          collate Chinese_PRC_CI_AS NULL,
	[SPI_DMA_ID] [uniqueidentifier] NULL,
	[SPI_HOS_ID] [uniqueidentifier] NULL,
	[SPI_CFN_ID] [uniqueidentifier] NULL,
	[SPI_PMA_ID] [uniqueidentifier] NULL,
	[SPI_BUM_ID] [uniqueidentifier] NULL,
	[SPI_SubCompany_ID] [uniqueidentifier] NULL,
	[SPI_BrandId_ID] [uniqueidentifier] NULL,
	[SPI_WHM_ID] [uniqueidentifier] NULL,
	[SPI_LTM_ID] [uniqueidentifier] NULL,
	[SPI_HospitalCode_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_ShipmentDate_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_ArticleNumber_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_LotNumber_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_Qty_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_Price_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_Warehouse_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_InvoiceDate_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_HospitalName_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_LotShipmentDate] [nvarchar](20)          collate Chinese_PRC_CI_AS NULL,
	[SPI_Remark] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_LotShipmentDate_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_Remark_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_CAH_ID] [uniqueidentifier]  NULL,
	[SPI_ConsignmentNbr] [nvarchar](200)          collate Chinese_PRC_CI_AS NULL,
	[SPI_ConsignmentNbr_ErrMsg] [nvarchar](200)          collate Chinese_PRC_CI_AS NULL,
	[SPI_QrCode] [nvarchar](50)          collate Chinese_PRC_CI_AS NULL,
	[SPI_QrCode_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_NO] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,
	[SPI_InvQty] [float] NULL,	--库存数量
	[SPI_InvRemnantQty] [float] NULL,	--剩余库存数量
	[SPI_UOMQty] [float] NULL,	--包装系数
	[SPI_InvRemnantQty_ErrMsg] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,	--剩余库存是否符合包装系数规则
	[SPI_OperType] [nvarchar](100) NULL,
	
	[SPI_ErrType] [nvarchar](100)          collate Chinese_PRC_CI_AS NULL,	--错误类型
	[SPI_ErrTotle] [nvarchar](MAX)          collate Chinese_PRC_CI_AS NULL	--错误汇总
	)

	--1. 获取当前处理数据
	SELECT TOP 1 @SPI_NO=A.SPI_NO,@UserId=SPI_USER FROM ShipmentInit A WHERE A.SPI_NO IS NOT NULL  ORDER BY A.SPI_UploadDate ASC
	
	INSERT INTO #ShipmentInitTemp(SPI_ID,SPI_USER,SPI_UploadDate,SPI_LineNbr,SPI_FileName,SPI_ErrorFlag,SPI_ErrorDescription,SPI_SaleType,SPI_HospitalCode,SPI_HospitalName,SPI_HospitalOffice,SPI_InvoiceNumber,SPI_InvoiceDate,SPI_InvoiceTitle,SPI_ShipmentDate,SPI_ArticleNumber,SPI_ChineseName,SPI_LotNumber,SPI_Price,SPI_ExpiredDate,SPI_UOM,SPI_Qty,SPI_Warehouse,SPI_DMA_ID,SPI_HOS_ID,SPI_CFN_ID,SPI_PMA_ID,SPI_BUM_ID,SPI_WHM_ID,SPI_LTM_ID,SPI_HospitalCode_ErrMsg,SPI_ShipmentDate_ErrMsg,SPI_ArticleNumber_ErrMsg,SPI_LotNumber_ErrMsg,SPI_Qty_ErrMsg,SPI_Price_ErrMsg,SPI_Warehouse_ErrMsg,SPI_InvoiceDate_ErrMsg,SPI_HospitalName_ErrMsg,SPI_LotShipmentDate,SPI_Remark,SPI_LotShipmentDate_ErrMsg,SPI_Remark_ErrMsg,SPI_CAH_ID,SPI_ConsignmentNbr,SPI_ConsignmentNbr_ErrMsg,SPI_QrCode,SPI_QrCode_ErrMsg,SPI_NO,SPI_OperType)
	SELECT SPI_ID,SPI_USER,SPI_UploadDate,SPI_LineNbr,SPI_FileName,SPI_ErrorFlag,SPI_ErrorDescription,SPI_SaleType,SPI_HospitalCode,SPI_HospitalName,SPI_HospitalOffice,SPI_InvoiceNumber,SPI_InvoiceDate,SPI_InvoiceTitle,SPI_ShipmentDate,SPI_ArticleNumber,SPI_ChineseName,SPI_LotNumber,SPI_Price,SPI_ExpiredDate,SPI_UOM,SPI_Qty,SPI_Warehouse,SPI_DMA_ID,SPI_HOS_ID,SPI_CFN_ID,SPI_PMA_ID,SPI_BUM_ID,SPI_WHM_ID,SPI_LTM_ID,SPI_HospitalCode_ErrMsg,SPI_ShipmentDate_ErrMsg,SPI_ArticleNumber_ErrMsg,SPI_LotNumber_ErrMsg,SPI_Qty_ErrMsg,SPI_Price_ErrMsg,SPI_Warehouse_ErrMsg,SPI_InvoiceDate_ErrMsg,SPI_HospitalName_ErrMsg,SPI_LotShipmentDate,SPI_Remark,SPI_LotShipmentDate_ErrMsg,SPI_Remark_ErrMsg,SPI_CAH_ID,SPI_ConsignmentNbr,SPI_ConsignmentNbr_ErrMsg,SPI_QrCode,SPI_QrCode_ErrMsg ,SPI_NO,SPI_OperType
	FROM ShipmentInit where  SPI_NO=@SPI_NO ;
	
	PRINT @SPI_NO;
	--2. 处理程序
	/*先将错误标志设为0*/
	Update #ShipmentInitTemp SET SPI_ErrorFlag=0,SPI_HOS_ID=null,SPI_CFN_ID=null,SPI_BUM_ID=null,
		SPI_WHM_ID=null,SPI_PMA_ID=null,SPI_CAH_ID=NULL,SPI_ShipmentDate_ErrMsg=NULL
	WHERE SPI_USER=@UserId 
	
	--检查医院是否存在
	Update #ShipmentInitTemp SET SPI_HOS_ID=Hospital.HOS_ID,SPI_HospitalCode=HOS_Key_Account
	FROM Hospital
	WHERE Hospital.HOS_HospitalName=#ShipmentInitTemp.SPI_HospitalName
	and SPI_USER=@UserId and #ShipmentInitTemp.SPI_HospitalCode_ErrMsg is null
		
	Update #ShipmentInitTemp set SPI_HospitalName_ErrMsg='医院不存在',SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',医院不存在'
	WHERE SPI_HOS_ID is null and SPI_HospitalName_ErrMsg is null and SPI_HospitalName is not null and SPI_USER=@UserId
	
	UPDATE #ShipmentInitTemp SET SPI_ShipmentDate_ErrMsg = '超过90天未上传附件不能上报销量',SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',超过90天未上传附件不能上报销量'
	WHERE  (SELECT * FROM dbo.GC_Fn_ShipmentFileUpload(SPI_DMA_ID)) > 0
	AND SPI_USER=@UserId
	
	--检查销售日期
	UPDATE #ShipmentInitTemp SET SPI_ShipmentDate_ErrMsg='销售日期不能大于导入日期',SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',销售日期不能大于导入日期'
	WHERE SPI_ShipmentDate_ErrMsg is null and SPI_USER=@UserId 
		AND CONVERT(NVARCHAR(10),SPI_ShipmentDate,121)>CONVERT(NVARCHAR(10),SPI_UploadDate,121)
		--AND  CONVERT(NVARCHAR(10),SPI_ShipmentDate,121)>CONVERT(NVARCHAR(10),GETDATE(),121)
	
	UPDATE #ShipmentInitTemp SET  SPI_ShipmentDate_ErrMsg='销售日期应大于'+dbo.fn_GetShipmentMinDate(),SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',销售日期应大于'+dbo.fn_GetShipmentMinDate()
	WHERE SPI_ShipmentDate_ErrMsg is null and SPI_USER=@UserId and convert(NVARCHAR(10),SPI_ShipmentDate,121)<dbo.fn_GetShipmentMinDate()

	--检查产品是否存在
	DECLARE @CFN_Property6 INT
	UPDATE #ShipmentInitTemp 
	SET SPI_CFN_ID=CFN.CFN_ID,
	SPI_BUM_ID=CFN_ProductLine_BUM_ID,
	SPI_PMA_ID=Product.PMA_ID,SPI_UOM=CFN.CFN_Property3,@CFN_Property6=CFN_Property6
	,SPI_UOMQty=Product.PMA_ConvertFactor --获取包装系数
	FROM CFN
	INNER JOIN Product ON Product.PMA_CFN_ID = CFN.CFN_ID
	WHERE CFN.CFN_CustomerFaceNbr=SPI_ArticleNumber  and SPI_USER=@UserId
	and SPI_ArticleNumber_ErrMsg is null
	
	UPDATE #ShipmentInitTemp SET  SPI_ArticleNumber_ErrMsg='产品不存在',SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',产品不存在'
	WHERE SPI_ArticleNumber_ErrMsg is null and SPI_USER=@UserId AND 
	(SPI_CFN_ID is null or SPI_BUM_ID is null or SPI_PMA_ID is null)
	
	
	--检查仓库是否存在
	UPDATE #ShipmentInitTemp SET SPI_WHM_ID=WHM_ID
	FROM Warehouse
	where Warehouse.WHM_Name=#ShipmentInitTemp.SPI_Warehouse and SPI_Warehouse_ErrMsg is null and SPI_USER=@UserId
	and Warehouse.WHM_DMA_ID=SPI_DMA_ID and Warehouse.WHM_Type not in ('SystemHold','DefaultWH')

	UPDATE #ShipmentInitTemp SET SPI_Warehouse_ErrMsg='仓库不存在或不能使用在途库和主仓库',SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',仓库不存在或不能使用在途库和主仓库'
	WHERE SPI_WHM_ID is null and SPI_Warehouse_ErrMsg is null and SPI_Warehouse is not null and SPI_USER=@UserId
	
	UPDATE #ShipmentInitTemp SET SPI_SaleType=
	(case when WHM_Type='DefaultWH' or WHM_Type='Normal' or WHM_Type='Frozen' then '1'
	 when WHM_Type='Consignment' or WHM_Type='LP_Consignment' then '2'
	 when WHM_Type='Borrow' or  WHM_Type='LP_Borrow' then '3' else ''  end)
	from Warehouse
	where  Warehouse.WHM_Name=#ShipmentInitTemp.SPI_Warehouse and SPI_Warehouse_ErrMsg is null
	and SPI_USER=@UserId
	and Warehouse.WHM_DMA_ID=SPI_DMA_ID
		
	--检查医院授权
	UPDATE #ShipmentInitTemp SET SPI_HospitalName_ErrMsg = '当前医院未授权',SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',当前医院未授权'
	WHERE SPI_USER = @UserId AND SPI_HospitalName_ErrMsg IS NULL 
	AND SPI_ShipmentDate IS NOT NULL
	AND ISDATE(SPI_ShipmentDate)=1
	AND LEN(SPI_ShipmentDate)>6
	AND SPI_DMA_ID IS NOT NULL
	AND SPI_BUM_ID IS NOT NULL
	AND SPI_HOS_ID IS NOT NULL
	AND NOT EXISTS(
			SELECT 1 FROM DealerAuthorizationTable DA
					INNER JOIN HospitalList ON DA.DAT_ID = HospitalList.HLA_DAT_ID
					INNER JOIN Hospital ON HospitalList.HLA_HOS_ID = Hospital.HOS_ID
					WHERE DA.DAT_DMA_ID = #ShipmentInitTemp.SPI_DMA_ID 
					AND DA.DAT_ProductLine_BUM_ID = #ShipmentInitTemp.SPI_BUM_ID
					AND DA.DAT_Type IN ('Normal','Temp','Shipment')
					AND CONVERT(NVARCHAR(100), CONVERT(DATETIME,#ShipmentInitTemp.SPI_ShipmentDate), 112)
					BETWEEN CONVERT(NVARCHAR(100), HLA_StartDate, 112)
					AND CONVERT(NVARCHAR(100), HLA_EndDate, 112)
					AND Hospital.HOS_ID = SPI_HOS_ID 
					AND Hospital.Hos_ActiveFlag = 1
					AND Hospital.HOS_DeletedFlag = 0
			)
		
	--TODO: 检查产品授权
	CREATE TABLE #AuthTemp
	(
		DealerId UNIQUEIDENTIFIER,
		BumId UNIQUEIDENTIFIER,
		AuthCount INT
	)
	
	
	INSERT INTO #AuthTemp
	SELECT DAT_DMA_ID,DAT_ProductLine_BUM_ID,COUNT(1) FROM DealerAuthorizationTable 
	WHERE EXISTS(
		SELECT SPI_DMA_ID,SPI_BUM_ID FROM #ShipmentInitTemp
		WHERE SPI_USER = @UserId
		AND SPI_DMA_ID IS NOT NULL
		AND SPI_CFN_ID IS NOT NULL 
		AND SPI_BUM_ID IS NOT NULL
		AND DAT_DMA_ID = SPI_DMA_ID
		AND DAT_ProductLine_BUM_ID = SPI_BUM_ID
	)
	AND DAT_Type = 'Shipment'
	GROUP BY DAT_DMA_ID,DAT_ProductLine_BUM_ID
	
	UPDATE #ShipmentInitTemp SET SPI_ArticleNumber_ErrMsg = '当前产品未授权' ,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',当前产品未授权'
	FROM CFN
	WHERE SPI_USER = @UserId 
	AND SPI_CFN_ID IS NOT NULL 
	AND SPI_ArticleNumber_ErrMsg IS NULL 
	AND SPI_HOS_ID IS NOT NULL
	AND SPI_BUM_ID IS NOT NULL
	AND SPI_DMA_ID IS NOT NULL
	AND SPI_CFN_ID = CFN_ID
	AND ISDATE(SPI_ShipmentDate)=1
	AND LEN(SPI_ShipmentDate)>6
	AND NOT EXISTS(
			SELECT 1 FROM DealerAuthorizationTable DA
					INNER JOIN HospitalList ON DA.DAT_ID = HospitalList.HLA_DAT_ID
					INNER JOIN Cache_PartsClassificationRec CP ON PCT_ProductLine_BUM_ID = DA.DAT_ProductLine_BUM_ID
					
					INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
					
					WHERE DA.DAT_DMA_ID = #ShipmentInitTemp.SPI_DMA_ID 
					AND DA.DAT_ProductLine_BUM_ID = #ShipmentInitTemp.SPI_BUM_ID
					AND DA.DAT_Type IN ('Normal','Temp','Shipment')
					AND 
					(
						(
							DA.DAT_Type = 'Shipment' 
							AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),CONVERT(DATETIME,#ShipmentInitTemp.SPI_ShipmentDate),120)) 
							BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,CONVERT(DATETIME,#ShipmentInitTemp.SPI_ShipmentDate)))
						)
						OR 
						(
							--若经销商授权产品线有Shipment特殊授权，怎么忽略【Normal】和【Temp】只看Shipment特殊授权
							ISNULL((SELECT AuthCount FROM #AuthTemp WHERE BumId = DAT_ProductLine_BUM_ID AND DealerId = DAT_DMA_ID),0) = 0 
							AND (DA.DAT_Type IN ('Normal','Temp') AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),CONVERT(DATETIME,#ShipmentInitTemp.SPI_ShipmentDate),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,CONVERT(DATETIME,#ShipmentInitTemp.SPI_ShipmentDate))))
						)
					)
					AND
					(
						(
							DA.DAT_PMA_ID = DA.DAT_ProductLine_BUM_ID 
							AND DA.DAT_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID
						)
						OR
						(
							DA.DAT_PMA_ID != DA.DAT_ProductLine_BUM_ID
							AND CP.PCT_ParentClassification_PCT_ID = DA.DAT_PMA_ID
							AND CP.PCT_ID = CCF.ClassificationId
						)
					)
					AND CFN.CFN_ProductLine_BUM_ID = #ShipmentInitTemp.SPI_BUM_ID
					AND CFN_DeletedFlag = 0
					AND HLA_HOS_ID = SPI_HOS_ID
					AND CONVERT(NVARCHAR(100), CONVERT(DATETIME,#ShipmentInitTemp.SPI_ShipmentDate), 112)
					BETWEEN CONVERT(NVARCHAR(100), HLA_StartDate, 112)
					AND CONVERT(NVARCHAR(100), HLA_EndDate, 112)
			)

	--校验二维码
	UPDATE #ShipmentInitTemp SET SPI_QrCode_ErrMsg='必须填写二维码'  ,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',必须填写二维码'
	WHERE SPI_USER=@UserId  AND SPI_QrCode=''

	--先全部更新为NULL，防止修改明细后，原先的LTMID还保留，但是二维码填错导致没有更新的问题
	update #ShipmentInitTemp set SPI_LTM_ID = null where SPI_USER=@UserId

	--更新产品有效期
	Update #ShipmentInitTemp set SPI_ExpiredDate=convert(nvarchar(10),LTM_ExpiredDate,121),
	 SPI_LTM_ID=LTM_ID
	from Inventory,Lot,LotMaster
	where SPI_USER=@UserId 
	and SPI_WHM_ID = INV_WHM_ID 
	and INV_ID = LOT_INV_ID
	and LOT_LTM_ID =LTM_ID
	and LTM_LotNumber= SPI_LotNumber + '@@' + SPI_QrCode
	
	-- 检查序列号是否存在
	--Update #ShipmentInitTemp set SPI_LotNumber_ErrMsg='序列号不存在'
	--where SPI_LotNumber_ErrMsg is null and SPI_USER=@UserId and  SPI_LTM_ID is null


	UPDATE #ShipmentInitTemp SET SPI_QrCode_ErrMsg='序列号或二维码不存在',SPI_LotNumber_ErrMsg ='序列号或二维码不存在'
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',序列号或二维码不存在'
	WHERE SPI_USER=@UserId AND SPI_LTM_ID is null
		
	
	UPDATE spi
	SET  SPI_QrCode_ErrMsg = '此仓库的二维码不能为NoQR',SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',此仓库的二维码不能为NoQR'
	--select *
	FROM #ShipmentInitTemp spi,Warehouse
	WHERE SPI_WHM_ID = WHM_ID
	and WHM_Type not in  ('Normal','Frozen')
	and WHM_Code not like '%NoQR%'
	and SPI_QrCode='NoQR'
	and SPI_USER=@UserId
	and SPI_QrCode_ErrMsg is null
	
	UPDATE   #ShipmentInitTemp SET SPI_Qty_ErrMsg='填写的数量类型不正确' 
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',填写的数量类型不正确'
	WHERE SPI_USER=@UserId 
	AND ISNUMERIC(SPI_Qty) =0 and SPI_USER=@UserId AND SPI_QrCode!='NoQR'
  
	UPDATE   #ShipmentInitTemp SET SPI_Qty_ErrMsg='带二维码的产品数量不得大于1' 
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',带二维码的产品数量不得大于1'
	WHERE SPI_USER=@UserId
	AND Case When ISNUMERIC(SPI_Qty)=1 Then convert(float,SPI_Qty) else -1 end > 1   and SPI_USER=@UserId AND SPI_QrCode!='NoQR'
  
	UPDATE  #ShipmentInitTemp SET SPI_Qty_ErrMsg='销售数量不能为0' 
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',销售数量不能为0'
	WHERE Case When ISNUMERIC(SPI_Qty)=1 Then convert(float,SPI_Qty) else -1 end =0  and SPI_USER=@UserId 
	
	--检查寄售销售单销售数量不能包含小数
	UPDATE   #ShipmentInitTemp SET SPI_Qty_ErrMsg='寄售销售单数量不能包含小数' 
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',寄售销售单数量不能包含小数'
	WHERE  SPI_Qty_ErrMsg IS NULL AND SPI_USER=@UserId 
	AND SPI_SaleType<> '1'
	AND convert(float,SPI_Qty) >cast(convert(float,SPI_Qty)  as int)


	 --有效期应大于用量日期
	Update t1 set  SPI_ShipmentDate_ErrMsg='产品有效期不能小于用量日期！'
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',产品有效期不能小于用量日期！'
	FROM #ShipmentInitTemp t1,CFN t2
	where SPI_ShipmentDate_ErrMsg is null and t1.SPI_CFN_ID = t2.CFN_ID
	and SPI_USER=@UserId 
	and CASE WHEN t2.CFN_Property6 = 0 then dateadd(month, datediff(month, 0, dateadd(month,1,SPI_ExpiredDate)), 0)
										ELSE dateadd(day,1,SPI_ExpiredDate) END <= SPI_ShipmentDate 
	   

	Update t1 set  SPI_ShipmentDate_ErrMsg='产品有效期小于当前日期需添加附件,请在页面上操作！'
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',产品有效期小于当前日期需添加附件,请在页面上操作！'
	FROM #ShipmentInitTemp t1,CFN t2
	where SPI_ShipmentDate_ErrMsg is null and t1.SPI_CFN_ID = t2.CFN_ID
	and SPI_USER=@UserId 
	and CASE WHEN t2.CFN_Property6 = 0 then dateadd(month, datediff(month, 0, dateadd(month,1,SPI_ExpiredDate)), 0)
										ELSE dateadd(day,1,SPI_ExpiredDate) END < getdate()
	
	
	
	
	--检查物料批次在仓库中是否存在
	Update #ShipmentInitTemp SET SPI_LotNumber_ErrMsg=N'该批次产品不存在仓库中'	
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',该批次产品不存在仓库中'
	Where SPI_LotNumber_ErrMsg is null and SPI_USER=@UserId
	and not exists (select 1 from Lot inner join Inventory inv on INV_ID=LOT_INV_ID
	where LOT_LTM_ID=SPI_LTM_ID and INV_WHM_ID=SPI_WHM_ID
	and INV_PMA_ID=SPI_PMA_ID)

	--检查物料批次在仓库中数量是否足够
	UPDATE #ShipmentInitTemp SET SPI_InvQty=T.LOT_OnHandQty,SPI_InvRemnantQty=(T.LOT_OnHandQty-T.SNL_LotQty)
	FROM (SELECT SPI_WHM_ID,SPI_PMA_ID,
	SPI_LTM_ID,SUM(convert(decimal(18,6),SPI_Qty)) AS 
	SNL_LotQty, MAX(Lot.LOT_OnHandQty) AS LOT_OnHandQty 
	FROM #ShipmentInitTemp
	INNER JOIN Lot ON Lot.LOT_LTM_ID = SPI_LTM_ID 
	INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID AND 
	INV.INV_WHM_ID = SPI_WHM_ID
	AND INV.INV_PMA_ID = SPI_PMA_ID
	WHERE SPI_Qty_ErrMsg IS NULL and SPI_USER=@UserId 
	GROUP BY SPI_WHM_ID,SPI_PMA_ID,SPI_LTM_ID) AS T
	WHERE #ShipmentInitTemp.SPI_Qty_ErrMsg IS NULL AND #ShipmentInitTemp.SPI_USER = @UserId
	AND T.SPI_WHM_ID = #ShipmentInitTemp.SPI_WHM_ID 
	AND T.SPI_PMA_ID = #ShipmentInitTemp.SPI_PMA_ID 
	AND T.SPI_LTM_ID = #ShipmentInitTemp.SPI_LTM_ID
	
	UPDATE #ShipmentInitTemp SET SPI_Qty_ErrMsg = N'该批次产品在仓库中数量不足'
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',该批次产品在仓库中数量不足'
	WHERE SPI_InvRemnantQty<0 
	AND #ShipmentInitTemp.SPI_Qty_ErrMsg IS NULL AND #ShipmentInitTemp.SPI_USER = @UserId
	
	--检查剩余数量是否符合包装系数规则
	UPDATE #ShipmentInitTemp SET SPI_InvRemnantQty_ErrMsg = N'该批号产品库存余数未用尽，调整销售用量'
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',该批号产品库存余数未用尽，调整销售用量'
	WHERE SPI_InvRemnantQty<0 
	AND #ShipmentInitTemp.SPI_Qty_ErrMsg IS NULL 
	AND #ShipmentInitTemp.SPI_USER = @UserId 
	AND #ShipmentInitTemp.SPI_InvRemnantQty<0.1
	
	
	/*
	UPDATE #ShipmentInitTemp SET SPI_Qty_ErrMsg = N'该批次产品在仓库中数量不足'
	FROM (SELECT SPI_WHM_ID,SPI_PMA_ID,
	SPI_LTM_ID,SUM(convert(decimal(18,6),SPI_Qty)) AS 
	SNL_LotQty, MAX(Lot.LOT_OnHandQty) AS LOT_OnHandQty 
	FROM #ShipmentInitTemp
	INNER JOIN Lot ON Lot.LOT_LTM_ID = SPI_LTM_ID 
	INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID AND 
	INV.INV_WHM_ID = SPI_WHM_ID
	AND INV.INV_PMA_ID = SPI_PMA_ID
	WHERE SPI_Qty_ErrMsg IS NULL and SPI_USER=@UserId
	GROUP BY SPI_WHM_ID,SPI_PMA_ID,SPI_LTM_ID) AS T
	WHERE #ShipmentInitTemp.SPI_Qty_ErrMsg IS NULL AND #ShipmentInitTemp.SPI_USER = @UserId
	AND T.SPI_WHM_ID = #ShipmentInitTemp.SPI_WHM_ID 
	AND T.SPI_PMA_ID = #ShipmentInitTemp.SPI_PMA_ID 
	AND T.SPI_LTM_ID = #ShipmentInitTemp.SPI_LTM_ID
	AND T.LOT_OnHandQty - T.SNL_LotQty < 0
	*/
	
		
	UPDATE #ShipmentInitTemp SET SPI_QrCode_ErrMsg=N'二维码已经使用过'
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',二维码已经使用过'
	where SPI_USER = @UserId 
	AND exists(SELECT 1 FROM ShipmentHeader inner join ShipmentLine on 
					ShipmentHeader.SPH_ID=ShipmentLine.SPL_SPH_ID
					inner join ShipmentLot on ShipmentLine.SPL_ID=ShipmentLot.SLT_SPL_ID
					inner join Lot on ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID)=Lot.LOT_ID
					 inner join LotMaster LotMaster on LotMaster.LTM_ID=Lot.LOT_LTM_ID
					 WHERE #ShipmentInitTemp.SPI_DMA_ID=ShipmentHeader.SPH_Dealer_DMA_ID 
					 AND ShipmentHeader.SPH_Status='Complete' and #ShipmentInitTemp.SPI_Qty_ErrMsg IS NULL
					 AND ((#ShipmentInitTemp.SPI_LotNumber+'@@'+#ShipmentInitTemp.SPI_QrCode)=LotMaster.LTM_LotNumber) 
					group by ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID) HAVING  SUM(ISNULL(ShipmentLot.SLT_LotShippedQty,0))+ISNULL(#ShipmentInitTemp.SPI_Qty,0)>1)
	--and exists(SELECT 1 FROM ShipmentQrCodeUsed
	--where #ShipmentInitTemp.SPI_DMA_ID=ShipmentQrCodeUsed.DMA_ID 
	--and ((#ShipmentInitTemp.SPI_LotNumber+'@@'+#ShipmentInitTemp.SPI_QrCode)=ShipmentQrCodeUsed.LTM_LotNumber) 
	--group by ShipmentQrCodeUsed.LOT_ID) HAVING  SUM(ISNULL(ShipmentQrCodeUsed.LotShippedQty,0))+ISNULL(#ShipmentInitTemp.SPI_Qty,0)>1)

	--产品价格警告
	--if @IsImport=0
	--Update #ShipmentInitTemp set SPI_Price_ErrMsg='警告:销售价低于产品价的10%'
	--where SPI_Price/interface.fn_GetPurchasePrice(SPI_CFN_ID,SPI_SaleType) <0.1
	
	/*** --------------------CRM医院销量重复UPN&Lot控制---------------------***/
	UPDATE #ShipmentInitTemp SET SPI_Qty_ErrMsg = N'此序列号的产品只允许销售一个'
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',此序列号的产品只允许销售一个'
	FROM 
	(SELECT SPI_PMA_ID,SPI_LTM_ID,SUM(convert(decimal(18,6),SPI_Qty)) AS SNL_LotQty
		FROM #ShipmentInitTemp
		WHERE SPI_Qty_ErrMsg IS NULL and SPI_USER=@UserId
		and SPI_BUM_ID='97a4e135-74c7-4802-af23-9d6d00fcb2cc' and SPI_ArticleNumber not like '66%' 
		GROUP BY SPI_PMA_ID,SPI_LTM_ID) 
	AS T
	WHERE #ShipmentInitTemp.SPI_Qty_ErrMsg IS NULL AND #ShipmentInitTemp.SPI_USER = @UserId
	AND T.SPI_PMA_ID = #ShipmentInitTemp.SPI_PMA_ID 
	AND T.SPI_LTM_ID = #ShipmentInitTemp.SPI_LTM_ID
	AND T.SNL_LotQty>1
	
	Update #ShipmentInitTemp set SPI_Qty_ErrMsg='此序列号的产品已经销售过'
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',此序列号的产品已经销售过'
	where SPI_Qty_ErrMsg IS NULL and SPI_USER=@UserId
	and dbo.fn_GetCanShipFlag(@CFN_Property6,SPI_LotNumber,SPI_ArticleNumber,SPI_DMA_ID)=N'否'
	
/*** ----------------------------------End---------------------------------------***/

	
/*** --------------------短期寄售申请单---------------------***/
Update #ShipmentInitTemp SET SPI_ConsignmentNbr_ErrMsg = '短期寄售申请单号不存在'
,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',短期寄售申请单号不存在'
where not exists (select 1 from ConsignmentApplyHeader where SPI_ConsignmentNbr = CAH_OrderNo)
and isnull(SPI_ConsignmentNbr ,'') <> ''

Update #ShipmentInitTemp set SPI_CAH_ID = CAH_ID
from ConsignmentApplyHeader
where CAH_OrderNo = SPI_ConsignmentNbr
and SPI_ConsignmentNbr_ErrMsg is null

Update #ShipmentInitTemp set SPI_CAH_ID = CAH_ID
--select *
FROM Warehouse,ConsignmentApplyHeader,ConsignmentApplyDetails,PurchaseOrderHeader,PurchaseOrderDetail,POReceiptHeader,POReceipt,POReceiptLot
where SPI_WHM_ID = WHM_ID
		and CAH_ID = CAD_CAH_ID
		and WHM_Type in ('Borrow','LP_Borrow')
		and CAH_OrderNo = POD_ShipmentNbr
        and CAH_CAH_ID is null
        and POD_POH_ID = POH_ID
        and POH_OrderNo = PRH_PurchaseOrderNbr
        and PRH_ID = POR_PRH_ID
        and POR_ID = PRL_POR_ID
        and SPI_USER= @UserId
        and SPI_CFN_ID = POD_CFN_ID
        and SPI_DMA_ID = CAH_DMA_ID
        and CAH_DMA_ID = POH_DMA_ID
        and SPI_BUM_ID = CAH_ProductLine_Id
        and SPI_LotNumber = PRL_LotNumber
        and isnull(SPI_ConsignmentNbr ,'') = ''
        and SPI_ConsignmentNbr_ErrMsg is null
        
        

	--如果是红海用户且产品线为Endo判断销售日期是否在6个工作日内，如果在6个工作日内调整为上个月最后一天lijie add

	UPDATE #ShipmentInitTemp SET 
		SPI_ShipmentDate=(select   CONVERT(VARCHAR(10),
		(dateadd(dd,-day(getdate()),convert(nvarchar(100),getdate(),23))),120))
		,SPI_ShipmentDate_ErrMsg='根据蓝威政策，经销商当月第6个工作日之前不能提交当月的医院销量，所以系统自动将填写的时间：'+SPI_ShipmentDate+'修改为上月最后一天。'
	,SPI_ErrTotle=ISNULL(SPI_ErrTotle,'')+',根据蓝威政策，经销商当月第6个工作日之前不能提交当月的医院销量，所以系统自动将填写的时间：'+SPI_ShipmentDate+'修改为上月最后一天。'
	WHERE --SPI_BUM_ID='8f15d92a-47e4-462f-a603-f61983d61b7b' AND
	ISDATE(SPI_ShipmentDate)=1
	AND LEN(SPI_ShipmentDate)>6
	 and (select count(*) from CalendarDate where CDD_Calendar 
		= (select convert(nvarchar(6),getdate(),112)) and CDD_Calendar+ 
	RIGHT (REPLICATE ('0', 2) + convert(nvarchar(2),CDD_Date1),2) >=(select convert(nvarchar(8),CONVERT(datetime,GETDATE()),112)))>0
	
	--AND (EXISTS(SELECT 1 FROM DealerMaster WHERE #ShipmentInitTemp.SPI_DMA_ID=DealerMaster.DMA_ID AND DMA_DealerType='T1')
	--or EXISTS(select  1
	--  from DealerMaster a inner join DealerMaster b
	--  on a.DMA_Parent_DMA_ID=b.DMA_ID
	--  where a.DMA_ID=#ShipmentInitTemp.SPI_DMA_ID AND a.DMA_DealerType='T2' AND b.DMA_Taxpayer='红海')
	--)
	AND MONTH(CONVERT(datetime,SPI_ShipmentDate))>=MONTH(CONVERT(datetime,GETDATE()))
	AND SPI_USER=@UserId
	and isnull(SPI_ShipmentDate_ErrMsg,'')=''
 
	/*** ----------------------------------End---------------------------------------***/

	--维护错误类型
	Update #ShipmentInitTemp Set SPI_ErrType='授权'
	where SPI_USER=@UserId
	AND SPI_NO=@SPI_NO
	AND ISNULL(SPI_HospitalName_ErrMsg,'')<>''  AND ISNULL(SPI_ErrType,'')=''
	
	Update #ShipmentInitTemp Set SPI_ErrType='商业规则'
	where SPI_USER=@UserId
	AND SPI_NO=@SPI_NO
	AND ISNULL(SPI_ShipmentDate_ErrMsg,'')<>''  AND ISNULL(SPI_ErrType,'')=''
	
	Update #ShipmentInitTemp Set SPI_ErrType='产品'
	where SPI_USER=@UserId
	AND SPI_NO=@SPI_NO
	AND ISNULL(SPI_ArticleNumber_ErrMsg,'')<>''  AND ISNULL(SPI_ErrType,'')=''
	
	Update #ShipmentInitTemp Set SPI_ErrType='库存'
	where SPI_USER=@UserId
	AND SPI_NO=@SPI_NO
	AND (ISNULL(SPI_Warehouse_ErrMsg,'')<>'' 
		OR ISNULL(SPI_QrCode_ErrMsg,'')<>'' 
		OR ISNULL(SPI_LotNumber_ErrMsg,'')<>'' 
		OR ISNULL(SPI_Qty_ErrMsg,'')<>''
		OR ISNULL(SPI_InvRemnantQty_ErrMsg,'')<>'')  
	AND ISNULL(SPI_ErrType,'')=''
	
	Update #ShipmentInitTemp Set SPI_ErrType='寄售'
	where SPI_USER=@UserId
	AND SPI_NO=@SPI_NO
	AND ISNULL(SPI_ConsignmentNbr_ErrMsg,'')<>''
	AND ISNULL(SPI_ErrType,'')=''
	
	--设定错误标识
	Update #ShipmentInitTemp Set SPI_ErrorFlag=1
	where SPI_USER=@UserId
	and SPI_NO=@SPI_NO
	and (SPI_HospitalName_ErrMsg is not null or SPI_ShipmentDate_ErrMsg is not null or
	SPI_ArticleNumber_ErrMsg is not null or SPI_LotNumber_ErrMsg is not null or
	SPI_Qty_ErrMsg is not null or SPI_Price_ErrMsg is not null or SPI_InvoiceDate_ErrMsg is not null
	or SPI_LotShipmentDate_ErrMsg is not null or SPI_Remark_ErrMsg is not null or SPI_QrCode_ErrMsg is not null)
	
	DECLARE @SPIStatus nvarchar(50)
	IF EXISTS(SELECT * FROM #ShipmentInitTemp WHERE SPI_USER=@UserId AND SPI_NO=@SPI_NO AND ISNULL(SPI_ErrorFlag,0)=0)
		and EXISTS(SELECT * FROM #ShipmentInitTemp WHERE SPI_USER=@UserId AND SPI_NO=@SPI_NO AND ISNULL(SPI_ErrorFlag,0)=1)
	BEGIN
		SET @SPIStatus ='PartCompleted'
	END 
	ELSE IF EXISTS(SELECT * FROM #ShipmentInitTemp WHERE SPI_USER=@UserId AND SPI_NO=@SPI_NO AND ISNULL(SPI_ErrorFlag,0)=0)
	BEGIN
		SET @SPIStatus ='Completed'
	END
	ELSE IF EXISTS(SELECT * FROM #ShipmentInitTemp WHERE SPI_USER=@UserId AND SPI_NO=@SPI_NO AND ISNULL(SPI_ErrorFlag,0)=1)
	BEGIN
		SET @SPIStatus ='Error'
	END
	ELSE
	BEGIN
		SET @SPIStatus =''
	END
	
	/*维护结果表*/
	DECLARE @SRH_ID uniqueidentifier
	SET @SRH_ID=NEWID();
	INSERT INTO ShipmentResultHeader (SRH_ID,SRH_SPI_NO,SRH_Dealer_DMA_ID,SRH_SubmitDate,SRH_Status,SRH_IsCheck,SRH_OperType)
	SELECT DISTINCT @SRH_ID, SPI_NO, A.SPI_DMA_ID,SPI_UploadDate,@SPIStatus,'0',SPI_OperType
	FROM #ShipmentInitTemp A
	WHERE   SPI_USER=@UserId AND SPI_NO=@SPI_NO
	PRINT 'Header';
	
	INSERT INTO ShipmentResultDetail 
	(SRD_ID,SRD_SRH_ID,SRD_LineNbr,SRD_TypeFlg,SRD_HospitalName,SRD_HospitalOffice,SRD_ShipmentDate,SRD_ProductLine_BUM_ID,SRD_Shipment_User
	,SRD_InvoiceNo,SRD_UpdateDate,SRD_InvoiceTitle,SRD_InvoiceDate,SRD_UPN,SRD_ExpiredDate,SRD_LotShippedQty,SRD_LotNumber,SRD_QrCode,SRD_ConsignmentNbr
	,SRD_Warehouse,SRD_UnitPrice,SRI_UOM,SRD_InputTime,SRD_Remark,
	SRI_UOMQty,SRD_InvQty,SRD_InvRemnantQty,SRD_ErrorType,SRD_ErrorMassage,SRD_ProposedMassage)
	SELECT NEWID(),@SRH_ID,a.SPI_LineNbr,ISNULL(a.SPI_ErrorFlag,0),A.SPI_HospitalName,A.SPI_HospitalOffice,
	CASE WHEN ISDATE(A.SPI_ShipmentDate)=1 AND LEN(A.SPI_ShipmentDate)>6 THEN A.SPI_ShipmentDate ELSE NULL  END AS SPI_ShipmentDate 
	,A.SPI_BUM_ID,A.SPI_USER
	,a.SPI_InvoiceNumber,A.SPI_UploadDate,a.SPI_InvoiceTitle
	,CASE WHEN ISNULL(A.SPI_InvoiceDate_ErrMsg,'')=''  THEN a.SPI_InvoiceDate ELSE NULL  END AS SPI_InvoiceDate 
	,a.SPI_ArticleNumber,ISNULL(a.SPI_ExpiredDate,'1900-01-01'),a.SPI_Qty ,a.SPI_LotNumber,a.SPI_QrCode,A.SPI_ConsignmentNbr
	,a.SPI_Warehouse
	--,CASE WHEN ISNULL(SPI_Price_ErrMsg,'-1')='-1' THEN  REPLACE(REPLACE(a.SPI_Price,',',''),' ','') ELSE NULL  END AS SPI_Price 
	,CASE WHEN ISNULL(SPI_Price_ErrMsg,'-1')='-1' THEN  REPLACE(REPLACE(REPLACE(ltrim(rtrim(REPLACE(a.SPI_Price,',',''))),CHAR(13),''),CHAR(10),''),CHAR(9),'') ELSE NULL  END AS SPI_Price 
	,a.SPI_UOM
	,a.SPI_UploadDate,null
	,a.SPI_UOMQty --包装数
	,ISNULL(a.SPI_InvQty,0) --库存数量
	,ISNULL(a.SPI_InvRemnantQty,0) --剩余库存
	,a.SPI_ErrType --错误类型
	,CASE WHEN ISNULL(a.SPI_ErrTotle,'')='' THEN NULL ELSE SUBSTRING(a.SPI_ErrTotle,2,LEN(a.SPI_ErrTotle)) End--错误信息
	--,a.SPI_ErrTotle --错误信息
	,CASE WHEN ISNULL(SPI_ErrType,'')='授权' THEN '调整医院名称并确认是否授权'
	WHEN ISNULL(SPI_ErrType,'')='商业规则' THEN '确认销量上传日是否符合商业规则，以及是否包含超过90天未上传发票附件的销售单'
	WHEN ISNULL(SPI_ErrType,'')='产品' THEN '确认产品是否被授权，以及产品编号正确性'
	WHEN ISNULL(SPI_ErrType,'')='库存' THEN '确认当前二维码库存是否充足，以及销售数量是否正确'
	WHEN ISNULL(SPI_ErrType,'')='寄售' THEN '确认寄售编号是否正确' End AS ProposedMassage
	--建议修改信息
	FROM #ShipmentInitTemp A
	WHERE SPI_USER=@UserId AND SPI_NO=@SPI_NO
	PRINT 'Detail';

	DELETE dbo.ShipmentInit WHERE SPI_USER=@UserId  and SPI_NO=@SPI_NO
	DELETE dbo.ShipmentInitProcessing WHERE SPI_USER=@UserId
	
	----20191231 add
	UPDATE  t SET t.SPI_SubCompany_ID=vp.SubCompanyId,t.SPI_BrandId_ID=vp.BrandId
	 FROM #ShipmentInitTemp t INNER JOIN dbo.View_ProductLine vp ON t.SPI_BUM_ID=vp.Id

	INSERT INTO dbo.ShipmentInitProcessing (SPI_ID,SPI_USER,SPI_UploadDate,SPI_LineNbr,SPI_FileName,SPI_ErrorFlag,SPI_ErrorDescription,SPI_SaleType,SPI_HospitalCode,SPI_HospitalName,SPI_HospitalOffice,SPI_InvoiceNumber,SPI_InvoiceDate,SPI_InvoiceTitle,SPI_ShipmentDate,SPI_ArticleNumber,SPI_ChineseName,SPI_LotNumber,SPI_Price,SPI_ExpiredDate,SPI_UOM,SPI_Qty,SPI_Warehouse,SPI_DMA_ID,SPI_HOS_ID,SPI_CFN_ID,SPI_PMA_ID,SPI_BUM_ID,SPI_WHM_ID,SPI_LTM_ID,SPI_HospitalCode_ErrMsg,SPI_ShipmentDate_ErrMsg,SPI_ArticleNumber_ErrMsg,SPI_LotNumber_ErrMsg,SPI_Qty_ErrMsg,SPI_Price_ErrMsg,SPI_Warehouse_ErrMsg,SPI_InvoiceDate_ErrMsg,SPI_HospitalName_ErrMsg,SPI_LotShipmentDate,SPI_Remark,SPI_LotShipmentDate_ErrMsg,SPI_Remark_ErrMsg,SPI_CAH_ID,SPI_ConsignmentNbr,SPI_ConsignmentNbr_ErrMsg,SPI_QrCode,SPI_QrCode_ErrMsg,SPI_NO)
	SELECT SPI_ID,SPI_USER,SPI_UploadDate,SPI_LineNbr,SPI_FileName,SPI_ErrorFlag,SPI_ErrorDescription,SPI_SaleType,SPI_HospitalCode,SPI_HospitalName,SPI_HospitalOffice,SPI_InvoiceNumber,SPI_InvoiceDate,SPI_InvoiceTitle,SPI_ShipmentDate,SPI_ArticleNumber,SPI_ChineseName,SPI_LotNumber,REPLACE(SPI_Price,',',''),SPI_ExpiredDate,SPI_UOM,SPI_Qty,SPI_Warehouse,SPI_DMA_ID,SPI_HOS_ID,SPI_CFN_ID,SPI_PMA_ID,SPI_BUM_ID,SPI_WHM_ID,SPI_LTM_ID,SPI_HospitalCode_ErrMsg,SPI_ShipmentDate_ErrMsg,SPI_ArticleNumber_ErrMsg,SPI_LotNumber_ErrMsg,SPI_Qty_ErrMsg,SPI_Price_ErrMsg,SPI_Warehouse_ErrMsg,SPI_InvoiceDate_ErrMsg,SPI_HospitalName_ErrMsg,SPI_LotShipmentDate,SPI_Remark,SPI_LotShipmentDate_ErrMsg,SPI_Remark_ErrMsg,SPI_CAH_ID,SPI_ConsignmentNbr,SPI_ConsignmentNbr_ErrMsg,SPI_QrCode,SPI_QrCode_ErrMsg ,SPI_NO
	FROM #ShipmentInitTemp A
	WHERE ISNULL(a.SPI_ErrorFlag,0)=0
	PRINT 'Processing';
	IF EXISTS (SELECT 1 FROM #ShipmentInitTemp WHERE SPI_OperType=1)
	BEGIN
	     --20191231 add
       	    --建立游标,上传每一个分子公司和品牌
			SELECT	SPI_SubCompany_ID ,SPI_BrandId_ID
			INTO	#SubCompany
			FROM	#ShipmentInitTemp
			WHERE	ISNULL(SPI_SubCompany_ID, '') <> '' AND ISNULL(SPI_BrandId_ID, '') <> ''
			GROUP BY SPI_SubCompany_ID ,SPI_BrandId_ID;
			DECLARE subBar CURSOR
			FOR
				SELECT	SPI_SubCompany_ID,SPI_BrandId_ID FROM	#SubCompany;
			OPEN subBar;
			FETCH NEXT FROM subBar INTO @SubCompanyId, @BrandId;
			WHILE @@FETCH_STATUS = 0
				BEGIN
					EXEC [dbo].[GC_Interface_Sales] NULL, NULL, @SubCompanyId,@BrandId, @UserId, '', ''; 
					FETCH NEXT FROM subBar INTO @SubCompanyId, @BrandId;
				END;
			CLOSE subBar;
			DEALLOCATE subBar;

	END
		PRINT 'Sales';
	
END TRY
BEGIN CATCH
 
    DECLARE @error_number INT
    DECLARE @error_serverity INT
    DECLARE @error_state INT
    DECLARE @error_message NVARCHAR(256)
    DECLARE @error_line INT
    DECLARE @error_procedure NVARCHAR(256)
    DECLARE @vError NVARCHAR(1000)
    SET @error_number = ERROR_NUMBER()
    SET @error_serverity = ERROR_SEVERITY()
    SET @error_state = ERROR_STATE()
    SET @error_message = ERROR_MESSAGE()
    SET @error_line = ERROR_LINE()
    SET @error_procedure = ERROR_PROCEDURE()
    SET @vError = ISNULL(@error_procedure, '') + '第'
        + CONVERT(NVARCHAR(10), ISNULL(@error_line, '')) + '行出错[错误号：'
        + CONVERT(NVARCHAR(10), ISNULL(@error_number, '')) + ']，'
        + ISNULL(@error_message, '')
    
    PRINT @vError
    
END CATCH



GO

