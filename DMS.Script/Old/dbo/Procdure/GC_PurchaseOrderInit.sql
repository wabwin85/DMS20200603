DROP Procedure [dbo].[GC_PurchaseOrderInit]
GO

/*
��������
*/
CREATE Procedure [dbo].[GC_PurchaseOrderInit]
    @UserId uniqueidentifier,
    @ImportType NVARCHAR(20),   --�������ͣ���Ϊ������ƽ̨��һ��
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

Declare @DealerID uniqueidentifier
Declare @DealerType nvarchar(5)
--������ʱ��
create table #mmbo_PurchaseOrderHeader (
   POH_ID               uniqueidentifier     not null,
   POH_OrderNo          nvarchar(30)         collate Chinese_PRC_CI_AS null,
   POH_ProductLine_BUM_ID uniqueidentifier     null,
   POH_DMA_ID           uniqueidentifier     null,
   POH_VendorID         nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_TerritoryCode    nvarchar(200)        null,
   POH_RDD              datetime             null,
   POH_ContactPerson    nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_Contact          nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_ContactMobile    nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_Consignee        nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POH_ShipToAddress    nvarchar(200)        collate Chinese_PRC_CI_AS null,
   POH_ConsigneePhone   nvarchar(200)        collate Chinese_PRC_CI_AS null,
   POH_Remark           nvarchar(400)        collate Chinese_PRC_CI_AS null,
   POH_InvoiceComment   nvarchar(200)        collate Chinese_PRC_CI_AS null,
   POH_CreateType       nvarchar(20)         collate Chinese_PRC_CI_AS not null,
   POH_CreateUser       uniqueidentifier     not null,
   POH_CreateDate       datetime             not null,
   POH_UpdateUser       uniqueidentifier     null,
   POH_UpdateDate       datetime             null,
   POH_SubmitUser       uniqueidentifier     null,
   POH_SubmitDate       datetime             null,
   POH_LastBrowseUser   uniqueidentifier     null,
   POH_LastBrowseDate   datetime             null,
   POH_OrderStatus      nvarchar(20)         collate Chinese_PRC_CI_AS not null,
   POH_LatestAuditDate  datetime             null,
   POH_IsLocked         bit                  not null,
   POH_SAP_OrderNo      nvarchar(50)         collate Chinese_PRC_CI_AS null,
   POH_SAP_ConfirmDate  datetime             null,
   POH_LastVersion      int                  not null,
   POH_OrderType        nvarchar(50)         collate Chinese_PRC_CI_AS null,
   POH_VirtualDC        nvarchar(50)         collate Chinese_PRC_CI_AS null,
   POH_SpecialPriceID   uniqueidentifier     null,
   POH_WHM_ID           uniqueidentifier     null,
   POH_POH_ID           uniqueidentifier     null,
   POH_PointType       NVARCHAR(100)    collate Chinese_PRC_CI_AS null

   primary key (POH_ID)
)

create table #mmbo_PurchaseOrderDetail (
   POD_ID               uniqueidentifier     not null,
   POD_POH_ID           uniqueidentifier     not null,
   POD_CFN_ID           uniqueidentifier     not null,
   POD_CFN_Price        decimal(18,6)        null,
   POD_UOM              nvarchar(100)        collate Chinese_PRC_CI_AS null,
   POD_RequiredQty      decimal(18,6)        null,
   POD_Amount           decimal(18,6)        null,
   POD_Tax              decimal(18,6)        null,
   POD_ReceiptQty       decimal(18,6)        null,
   POD_Status           nvarchar(50)         collate Chinese_PRC_CI_AS null,
   POD_LotNumber		    nvarchar(50)		     collate Chinese_PRC_CI_AS null,
   POD_CurRegNo nvarchar(500)    collate Chinese_PRC_CI_AS NULL,
   POD_CurValidDateFrom datetime NULL,
   POD_CurValidDataTo datetime NULL,
   POD_CurManuName nvarchar(500) collate Chinese_PRC_CI_AS NULL,
   POD_LastRegNo nvarchar(500) collate Chinese_PRC_CI_AS NULL,
   POD_LastValidDateFrom datetime NULL,
   POD_LastValidDataTo datetime NULL,
   POD_LastManuName nvarchar(500) collate Chinese_PRC_CI_AS NULL,
   POD_CurGMKind nvarchar(200) collate Chinese_PRC_CI_AS NULL,
   POD_CurGMCatalog nvarchar(200) collate Chinese_PRC_CI_AS NULL,
    primary key (POD_ID)
)

create table #dealer_Price (
   CFNID                uniqueidentifier     not null,
   Price                decimal(18, 6)       null,
   PriceType            nvarchar(50)         collate Chinese_PRC_CI_AS not null,
   Uom                  nvarchar(50)         collate Chinese_PRC_CI_AS null,
   primary key (CFNID,PriceType)
)



/*�Ƚ������־��Ϊ0*/
--UPDATE PurchaseOrderInit SET POI_ErrorFlag = 0,POI_ArticleNumber_ErrMsg = null,
--POI_OrderType_ErrMsg=null,
--POI_LotNumber_ErrMsg=null,
--POI_Amount_ErrMsg=null,
--POI_ProductLine_ErrMsg=null
--WHERE POI_USER = @UserId

--��龭�����Ƿ����
UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_OrderType_ErrMsg =  N'�����̲�����'
WHERE POI_USER = @UserId
and POI_DMA_ID is null

--IF (SELECT COUNT(*) AS Cnt FROM PurchaseOrderInit WHERE POI_USER = @UserId AND POI_DMA_ID is NOT null group by POI_DMA_ID ) > 1
--  UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_OrderType_ErrMsg =  N'�����̲�һ��'
--   WHERE POI_USER = @UserId

--��ȡ������
Select top 1 @DealerID=  POI_DMA_ID from PurchaseOrderInit WHERE POI_USER = @UserId
select @DealerType=  DMA_DealerType from DealerMaster where DMA_ID = @DealerID


--���۸�д����ʱ��
/*
    insert into #dealer_Price
    SELECT C.CFN_ID AS Id,P.CFNP_Price,P.CFNP_PriceType,C.CFN_Property3 AS Uom     
      FROM
      (
      select * from CFN
      where EXISTS (SELECT 1 FROM (select b.*
							  from V_DealerContractMaster a
							  inner join (select distinct CC_Code,CC_ID,CA_Code,CA_ID,CC_ProductLineID,CC_Division from V_ProductClassificationStructure) pc
							  on CONVERT(nvarchar(10), a.Division)=pc.CC_Division and pc.CC_ID=a.CC_ID
							  inner join DealerAuthorizationTable b on b.DAT_DMA_ID=a.DMA_ID and pc.CC_ProductLineID=b.DAT_ProductLine_BUM_ID and b.DAT_PMA_ID=pc.CA_ID
							  where a.ActiveFlag='1') AS DA
      INNER JOIN DealerContract AS DC
      ON DA.DAT_DCL_ID = DC.DCL_ID
      INNER JOIN Cache_PartsClassificationRec AS CP
      ON CP.PCT_ProductLine_BUM_ID = DA.DAT_ProductLine_BUM_ID
      WHERE DC.DCL_DMA_ID = @DealerID     
      AND CFN.CFN_DeletedFlag = 0
      AND DA.DAT_PMA_ID = DA.DAT_ProductLine_BUM_ID
      AND DA.DAT_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID)
      AND CFN_Property4 = '1'
      union
      select * from CFN
      where EXISTS (SELECT 1 FROM (select b.*
							  from V_DealerContractMaster a
							  inner join (select distinct CC_Code,CC_ID,CA_Code,CA_ID,CC_ProductLineID,CC_Division from V_ProductClassificationStructure) pc
							  on CONVERT(nvarchar(10), a.Division)=pc.CC_Division and pc.CC_ID=a.CC_ID
							  inner join DealerAuthorizationTable b on b.DAT_DMA_ID=a.DMA_ID and pc.CC_ProductLineID=b.DAT_ProductLine_BUM_ID and b.DAT_PMA_ID=pc.CA_ID
							  where a.ActiveFlag='1') AS DA
      INNER JOIN DealerContract AS DC
      ON DA.DAT_DCL_ID = DC.DCL_ID
      INNER JOIN Cache_PartsClassificationRec AS CP
      ON CP.PCT_ProductLine_BUM_ID = DA.DAT_ProductLine_BUM_ID
      WHERE DC.DCL_DMA_ID = @DealerID      
      AND CFN.CFN_DeletedFlag = 0
      AND DA.DAT_PMA_ID != DA.DAT_ProductLine_BUM_ID
      AND CP.PCT_ParentClassification_PCT_ID = DA.DAT_PMA_ID
      AND CP.PCT_ID = CFN.CFN_ProductCatagory_PCT_ID)
      AND CFN_Property4 = '1'
      ) AS C,dbo.CFNPrice AS P
      where P.CFNP_CFN_ID = C.CFN_ID 
      AND P.CFNP_Group_ID = @DealerID
      AND P.CFNP_DeletedFlag = 0
      AND CFNP_Price > 0
*/
--update By HuaKaichun ��Ʒ�ṹ����
insert into #dealer_Price
 SELECT distinct C.CFN_ID AS Id,P.CFNP_Price,P.CFNP_PriceType,C.CFN_Property3 AS Uom     
   FROM
      (
       SELECT * FROM CFN 
       INNER JOIN CfnClassification CC ON CC.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
       AND CC.ClassificationId IN (SELECT ProducPctId FROM GC_FN_GetDealerAuthProductSub(@DealerID) WHERE ActiveFlag=1)
       WHERE EXISTS
		  (
		  SELECT 1 FROM DealerAuthorizationTable DAT
		  INNER JOIN Cache_PartsClassificationRec AS CP
		  ON CP.PCT_ProductLine_BUM_ID = DAT.DAT_ProductLine_BUM_ID
		  WHERE DAT.DAT_DMA_ID = @DealerID  
		  AND DAT.DAT_PMA_ID = DAT.DAT_ProductLine_BUM_ID
		  AND CP.PCT_ProductLine_BUM_ID = DAT.DAT_PMA_ID
		  AND DAT.DAT_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID
		  

		  AND ((DAT.DAT_Type = 'Order' AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
		  OR ((DAT.DAT_Type IN ('Normal','Temp') AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
		  )
		  )
		  )
		  AND CFN.CFN_DeletedFlag = 0
		  UNION
		  SELECT * FROM CFN 
		  INNER JOIN CfnClassification CC ON CC.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
		  AND CC.ClassificationId IN (SELECT ProducPctId FROM GC_FN_GetDealerAuthProductSub(@DealerID) WHERE ActiveFlag=1)
		  WHERE EXISTS
		  (
		  SELECT 1 FROM DealerAuthorizationTable DAT
		  INNER JOIN Cache_PartsClassificationRec AS CP
		  ON CP.PCT_ProductLine_BUM_ID = DAT.DAT_ProductLine_BUM_ID
		  
		  WHERE DAT.DAT_DMA_ID = @DealerID  
		  AND CP.PCT_ProductLine_BUM_ID = dat.DAT_ProductLine_BUM_ID
		  AND DAT.DAT_PMA_ID != DAT.DAT_ProductLine_BUM_ID
		  AND CP.PCT_ParentClassification_PCT_ID = DAT.DAT_PMA_ID
		  --AND CP.PCT_ID = CFN.CFN_ProductCatagory_PCT_ID
		  AND CC.ClassificationId=CP.PCT_ID
		  
		  AND ((DAT.DAT_Type = 'Order' AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
		  OR ((DAT.DAT_Type IN ('Normal','Temp') AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
		  )
		  )
		  )
		  AND CFN.CFN_DeletedFlag = 0
		  ) AS C,
		  dbo.CFNPrice AS P
      where P.CFNP_CFN_ID = C.CFN_ID 
      AND P.CFNP_Group_ID = @DealerID
      AND P.CFNP_DeletedFlag = 0
      AND CFNP_Price > 0




--��鵥�������Ƿ���ȷ
update PurchaseOrderInit
set POI_OrderTypeName = (select DICT_KEY from Lafite_DICT where DICT_TYPE = N'CONST_Order_Type'
							and POI_OrderType = VALUE1 )
where POI_USER = @UserId					

--��һ���Լ�ƽ̨�Ļ��������ж�
if(@DealerType<>'t2')
begin
--��鶩��Ϊ�������͵��Ƿ���ȷ
update PurchaseOrderInit set POI_ErrorFlag =1,POI_PointType_ErrMsg=N'��������ֻ��Ϊ�㷵�����ɡ����㷵��������'
where  POI_USER = @UserId and
POI_PointType not in('�㷵������','���㷵��������') and POI_OrderType='���ֶ���'


update PurchaseOrderInit set POI_ErrorFlag =1,POI_PointType_ErrMsg=N'����Ϊ���ֶ���ʱ,��������Ϊ������'
where  POI_USER = @UserId
and POI_OrderType='���ֶ���' and POI_PointType is null  
end
 
--���¶�������code
update PurchaseOrderInit set POI_PointTypeCode = (select DICT_KEY from Lafite_DICT where DICT_TYPE = N'PRO_PointOrderType'
							and POI_PointType = VALUE1 )
       where POI_USER = @UserId 



--����ͬ�Ƿ��Ѿ�����,
--UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_OrderType_ErrMsg =  N'�����̺�ͬ�ѵ���'
--WHERE POI_USER = @UserId 
--AND NOT EXISTS
--      (select 1 from dealermaster AS DM,DealerContract AS DC
--        where DM.DMA_ID=PurchaseOrderInit.POI_DMA_ID
--         AND DM.DMA_ID =DC.DCL_DMA_ID         
--         AND CONVERT(varchar(100), GETDATE(), 112)
--          BETWEEN  CONVERT(varchar(100), DC.DCL_StartDate, 112)
--           AND  Case when DM.DMA_DealerAuthentication = 'Normal' then CONVERT(varchar(100),  dateadd(mm,3,DC.DCL_StopDate), 112)
--            when DM.DMA_DealerAuthentication = 'OneTime' then CONVERT(varchar(100),  DC.DCL_StopDate, 112)
--            ELSE CONVERT(varchar(100),  dateadd(mm,1000,DC.DCL_StopDate), 112) END
--       )

--һ�������̺�����ƽֻ̨�ܵ�����ͨ�����ͽ��Ӷ���
--����������ֻ�ܵ�����ͨ���������۶��������ֶ�������������
IF (@DealerType = 'T2') 
  BEGIN
    UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_OrderType_ErrMsg =  N'�������Ͳ���ȷ,����������ֻ�ܵ�����ͨ���������۶��������ֶ�������������'
     WHERE POI_USER = @UserId
       and (POI_OrderTypeName is null OR POI_OrderTypeName NOT in ('Normal','Consignment','CRPO','PRO'))
       
  END
ELSE
  BEGIN
    UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_OrderType_ErrMsg =  N'�������Ͳ���ȷ'
     WHERE POI_USER = @UserId
       and (POI_OrderTypeName is null OR POI_OrderTypeName NOT in ('CRPO','Normal','Transfer','EEGoodsReturn','PEGoodsReturn','ClearBorrowManual','SpecialPrice'))
  END



--����Ʒ�Ƿ����
UPDATE PurchaseOrderInit SET POI_CFN_ID = CFN_ID
FROM CFN WHERE CFN_CustomerFaceNbr = POI_ArticleNumber
AND POI_USER = @UserId

UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_ArticleNumber_ErrMsg = N'��Ʒ������,'
WHERE POI_CFN_ID IS NULL AND POI_USER = @UserId AND POI_ArticleNumber_ErrMsg IS NULL

--����Ʒ�Ƿ��ѷ��ࣨ�Ƿ��Ӧ��Ʒ�ߣ�
UPDATE POI SET POI_BUM_ID = (CASE WHEN CFNS_BUM_ID IS NULL THEN CFN_ProductLine_BUM_ID ELSE CFNS_BUM_ID END)
FROM PurchaseOrderInit POI inner join CFN on CFN_ID = POI_CFN_ID 
left join CFNSHARE on CFN_ID = CFNS_CFN_ID AND CFNS_PROPERTY1 = 1
WHERE POI_CFN_ID IS NOT NULL
AND POI_USER = @UserId

UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_ArticleNumber_ErrMsg =  N'��Ʒδ����(�޶�Ӧ��Ʒ��),'
WHERE POI_BUM_ID IS NULL AND POI_USER = @UserId AND POI_ArticleNumber_ErrMsg IS NULL



--����Ʒ�Ƿ�����¶������ݵ������ͻ�ȡ�۸����ͣ�
UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_ArticleNumber_ErrMsg = N'��Ʒδ��Ȩ��δά���۸�,'
WHERE POI_CFN_ID IS NOT NULL 
  AND POI_USER = @UserId 
  AND POI_ArticleNumber_ErrMsg IS NULL
  AND Not Exists 
  (select 1 
    from #dealer_Price AS Price , Lafite_DICT AS Dict 
    where Dict.DICT_TYPE = N'CONST_Order_Type'
    AND Price.PriceType = Dict.Value2
    AND Dict.Dict_Key = PurchaseOrderInit.POI_OrderTypeName
    AND Price.CFNID = PurchaseOrderInit.POI_CFN_ID
   )

--����Ʒ�����Ƿ���ȷ
UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_LotNumber_ErrMsg = N'��Ʒ���Ų�����,'
WHERE (POI_LotNumber IS NOT NULL and POI_LotNumber<>'')
  AND POI_USER = @UserId 
  AND POI_LotNumber_ErrMsg IS NULL
  AND POI_ArticleNumber_ErrMsg IS NULL
  AND Not Exists 
  (SELECT 1
     FROM cfn t1, Product t2, LotMaster t3
    WHERE  t1.CFN_ID = t2.PMA_CFN_ID
       AND t2.PMA_ID = t3.LTM_Product_PMA_ID
       AND t3.LTM_LotNumber = PurchaseOrderInit.POI_LotNumber+'@@NoQR' and t1.CFN_CustomerFaceNbr = PurchaseOrderInit.POI_ArticleNumber
   )
   
--Add by SongWeiming���ڶ�����������Ҫ��д��Ʒ�ߣ����ݹ����Ʒ���жϲ�Ʒ�Ƿ����ѡ���Ӧ�Ĳ�Ʒ��

--��д�Ĳ�Ʒ���Ƿ���ȷ
UPDATE PurchaseOrderInit SET  POI_ErrorFlag = 1, POI_ProductLine_ErrMsg =  N'��д�Ĳ�Ʒ�߲����ڻ���д�Ĳ�Ʒ�߲���ȷ'
 WHERE POI_USER = @UserId
   and NOT Exists (select 1 from Lafite_ATTRIBUTE where ATTRIBUTE_TYPE='Product_Line' and ATTRIBUTE_NAME = PurchaseOrderInit.POI_ProductLine)

--��Ʒ���Ƿ�����Ȩ
update PurchaseOrderInit SET  POI_ErrorFlag = 1, POI_ProductLine_ErrMsg =  N'û���趨�˲�Ʒ�ߵ���Ȩ'
 WHERE POI_USER = @UserId
   --and NOT EXISTS (select 1 from (select b.*
			--				  from V_DealerContractMaster a
			--				  inner join (select distinct CC_Code,CC_ID,CA_Code,CA_ID,CC_ProductLineID,CC_Division from V_ProductClassificationStructure) pc
			--				  on CONVERT(nvarchar(10), a.Division)=pc.CC_Division and pc.CC_ID=a.CC_ID
			--				  inner join DealerAuthorizationTable b on b.DAT_DMA_ID=a.DMA_ID and pc.CC_ProductLineID=b.DAT_ProductLine_BUM_ID and b.DAT_PMA_ID=pc.CA_ID
			--				  where a.ActiveFlag='1') AS DAT,Lafite_ATTRIBUTE AS LA 
   --                 where DAT.DAT_ProductLine_BUM_ID = LA.Id and DAT.DAT_DMA_ID = PurchaseOrderInit.POI_DMA_ID
   --                   and PurchaseOrderInit.POI_ProductLine = LA.ATTRIBUTE_NAME and LA.ATTRIBUTE_TYPE='Product_Line')
   AND POI_ProductLine_ErrMsg is null
   AND NOT EXISTS 
	(
		SELECT 1 FROM DealerAuthorizationTable 
		WHERE DAT_DMA_ID = PurchaseOrderInit.POI_DMA_ID
		AND DAT_ProductLine_BUM_ID = PurchaseOrderInit.POI_BUM_ID
		AND DAT_Type IN ('Normal','Temp','Order')
	)
    
IF (@DealerType = 'T2') 
  BEGIN
    --��Ʒ��Ӧ�Ĳ�Ʒ���Ƿ���ȷ
    UPDATE PurchaseOrderInit SET  POI_ErrorFlag = 1, POI_ProductLine_ErrMsg =  N'��Ʒ��Ӧ�Ĳ�Ʒ�߲���ȷ'
     WHERE POI_USER = @UserId
       and NOT Exists (select 1 from (select cfns_cfn_id AS CfnID,CFNS_BUM_ID AS BUMID from CFNShare where CFNS_Property2='T2'
										union 
										select cfn_ID,CFN_ProductLine_BUM_ID from cfn 
										) tab1,cfn tab2,Lafite_ATTRIBUTE tab3
										where tab1.CfnID=tab2.CFN_ID and tab1.BUMID=tab3.Id
										and tab3.ATTRIBUTE_TYPE='Product_Line' 
										and PurchaseOrderInit.POI_ArticleNumber = tab2.CFN_CustomerFaceNbr
										and PurchaseOrderInit.POI_ProductLine = tab3.ATTRIBUTE_NAME)
       and POI_ProductLine_ErrMsg is null
       and POI_ArticleNumber_ErrMsg is null
  END
ELSE
  BEGIN
    --���ݾ����̵Ĳ�Ʒ������룬�жϲ�Ʒ�Ƿ���Զ���
    UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_ArticleNumber_ErrMsg = N'���������޴˲�Ʒ�������:'+ isnull(REG.CurGMCatalog,'')+'(���:' + isnull(REG.curGMKind,'') +'),�޷�����'
    From PurchaseOrderInit PI 
       left join DealerMasterLicense DML ON (PI.POI_DMA_ID = DML.DML_DMA_ID )
       left join MD.V_INF_UPN_REG REG ON (REG.CurUPN = PI.POI_ArticleNumber)
    WHERE PI.POI_CFN_ID IS NOT NULL 
      AND PI.POI_USER = @UserId 
      AND PI.POI_ArticleNumber_ErrMsg IS NULL
      AND dbo.GC_Fn_CFN_CheckDealerLicenseGatagory(PI.POI_DMA_ID,PI.POI_CFN_ID,REG.CurGMCatalog,REG.curGMKind,DML.DML_CurSecondClassCatagory,DML.DML_CurThirdClassCatagory) = 0
     
    
    
    UPDATE PurchaseOrderInit SET  POI_ErrorFlag = 1, POI_ProductLine_ErrMsg =  N'��Ʒ��Ӧ�Ĳ�Ʒ�߲���ȷ'
     WHERE POI_USER = @UserId
       and NOT Exists (select 1 from (select cfns_cfn_id AS CfnID,CFNS_BUM_ID AS BUMID from CFNShare where CFNS_Property2='T1'
										   union 
										   select cfn_ID,CFN_ProductLine_BUM_ID from cfn 
  										) tab1,cfn tab2,Lafite_ATTRIBUTE tab3
  										where tab1.CfnID=tab2.CFN_ID and tab1.BUMID=tab3.Id
  										and tab3.ATTRIBUTE_TYPE='Product_Line' 
  										and PurchaseOrderInit.POI_ArticleNumber = tab2.CFN_CustomerFaceNbr
  										and PurchaseOrderInit.POI_ProductLine = tab3.ATTRIBUTE_NAME)
       and POI_ProductLine_ErrMsg is null
       and POI_ArticleNumber_ErrMsg is null   
       
  END
       

    
--���²�Ʒ��ID
UPDATE POI SET POI_BUM_ID = LA.Id
FROM PurchaseOrderInit POI inner join Lafite_ATTRIBUTE LA on LA.ATTRIBUTE_NAME = POI.POI_ProductLine
WHERE LA.ATTRIBUTE_TYPE='Product_Line'
AND POI_USER = @UserId 
 

IF (@DealerType <> 'T2')
BEGIN
--���ͬһ���κŵĲ�Ʒ����Ƿ�һ��
IF (SELECT COUNT(*) AS CNT FROM (SELECT POI_OrderTypeName,POI_ArticleNumber,POI_LotNumber,COUNT(POI_Amount) as cnt from (
					select distinct POI_OrderTypeName,POI_LotNumber,POI_ArticleNumber,ISNULL(poi_amount,0) AS poi_amount from PurchaseOrderInit
					where POI_USER=@UserId
					and POI_OrderTypeName in ('SpecialPrice','Transfer','ClearBorrowManual') 
					) tab group by POI_OrderTypeName,POI_ArticleNumber,POI_LotNumber having COUNT(POI_Amount) >1) tab2
	) > 0
	BEGIN
	UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_Amount_ErrMsg = N'ͬһ��Ʒ���ŵĽ�����һ��,'
	WHERE POI_USER = @UserId 
	AND (POI_LotNumber IS NOT NULL OR  POI_LotNumber<>'')
	AND (POI_ArticleNumber IS NOT NULL OR  POI_ArticleNumber<>'')
	AND POI_Amount_ErrMsg IS NULL
	AND EXISTS (SELECT 1 FROM (SELECT POI_OrderTypeName,POI_ArticleNumber,POI_LotNumber,COUNT(POI_Amount) as cnt from (
					select distinct POI_OrderTypeName,POI_LotNumber,POI_ArticleNumber,ISNULL(poi_amount,0) AS poi_amount from PurchaseOrderInit
					where POI_USER=@UserId
					and POI_OrderTypeName in ('SpecialPrice','Transfer','ClearBorrowManual') 
					) tab group by POI_OrderTypeName,POI_ArticleNumber,POI_LotNumber having COUNT(POI_Amount) >1) tab2
					WHERE PurchaseOrderInit.POI_OrderTypeName = TAB2.POI_OrderTypeName
					AND PurchaseOrderInit.POI_LotNumber = TAB2.POI_LotNumber
					AND PurchaseOrderInit.POI_ArticleNumber = TAB2.POI_ArticleNumber)
	END
END

--����Ʒ���Ƿ�Ψһ
--IF (SELECT COUNT(DISTINCT POI_BUM_ID) FROM PurchaseOrderInit WHERE POI_USER = @UserId) > 1
--	UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_ArticleNumber_ErrMsg = N'��Ʒ������ͬһ��Ʒ��,'
--	WHERE POI_USER = @UserId AND POI_ArticleNumber_ErrMsg IS NULL

--����Ʒ�Ƿ���Ȩ
UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_ArticleNumber_ErrMsg = N'��Ʒδ��Ȩ,'
WHERE POI_USER = @UserId
AND dbo.GC_Fn_CFN_CheckDealerAuth(POI_DMA_ID,POI_CFN_ID) = 0
AND POI_ArticleNumber_ErrMsg IS NULL

--����Ʒ�Ƿ�ɶ���
--UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_ArticleNumber_ErrMsg = N'��Ʒ��������,'
--WHERE POI_USER = @UserId
--AND dbo.GC_Fn_CFN_CheckBSCDealerCanOrder(POI_DMA_ID,POI_CFN_ID,(select VALUE2 from Lafite_DICT where DICT_TYPE = 'CONST_Order_Type'
--							and POI_OrderTypeName = DICT_KEY )) = 0
--AND POI_ArticleNumber_ErrMsg IS NULL		

--��龭������������
--UPDATE PurchaseOrderInit 
--SET POI_TerritoryCode = (SELECT MIN(TerritoryMaster.TEM_Code) FROM DealerTerritory 
--						INNER JOIN TerritoryMaster ON TerritoryMaster.TEM_ID = DealerTerritory.DT_TEM_ID
--						INNER JOIN TerritoryHierarchy ON TerritoryHierarchy.TH_ID =TerritoryMaster.TEM_Parent_ID
--						WHERE TerritoryHierarchy.TH_Level = 'Province'
--						AND DealerTerritory.DT_DeleteFlag = 0
--						AND TerritoryMaster.TEM_DeleteFlag = 0
--						AND TerritoryHierarchy.TH_DeleteFlag = 0
--						AND DealerTerritory.DT_DMA_ID = POI_DMA_ID
--						AND TerritoryHierarchy.TH_BUM_ID = POI_BUM_ID)
--WHERE POI_USER = @UserId						

--UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1, POI_ErrorDescription = isnull(POI_ErrorDescription,'') + '���������򲻴���,'
--WHERE POI_TerritoryCode IS NULL AND POI_USER = @UserId

UPDATE PurchaseOrderInit SET POI_ErrorFlag = 1
WHERE POI_USER = @UserId
AND (POI_ArticleNumber_ErrMsg IS NOT NULL OR POI_LotNumber_ErrMsg IS NOT NULL OR POI_OrderType_ErrMsg IS NOT NULL OR POI_RequiredQty_ErrMsg IS NOT NULL or POI_PointType_ErrMsg is not null)

--����Ƿ���ڴ���
IF (SELECT COUNT(*) FROM PurchaseOrderInit WHERE POI_ErrorFlag = 1 AND POI_USER = @UserId) > 0
	BEGIN
		/*������ڴ����򷵻�Error*/
		SET @IsValid = 'Error'
	END
ELSE
	BEGIN
		/*��������ڴ����򷵻�Success*/		
		SET @IsValid = 'Success'
		
		
    
    
    /*�ϴ���ť��д��ʽ�����밴ť��д*/
		IF @ImportType = 'Import'
		BEGIN
			--������ʱ��������
			insert into #mmbo_PurchaseOrderHeader (POH_ID,POH_ProductLine_BUM_ID,POH_DMA_ID,POH_OrderType,POH_CreateType,
			POH_CreateUser,POH_CreateDate,POH_OrderStatus,POH_IsLocked,POH_LastVersion,POH_TerritoryCode,POH_VirtualDC,POH_PointType )
			select newid(),a.POI_BUM_ID,a.POI_DMA_ID,POI_OrderTypeName,'Manual',a.POI_USER,getdate(),'Draft',0,0,a.POI_TerritoryCode,
      (select VDC_Plant from VirtualDC where VDC_DMA_ID=POI_DMA_ID and VDC_BUM_ID=POI_BUM_ID) AS VirtualDC,a.POI_PointTypeCode
			from (select DISTINCT POI_USER,POI_BUM_ID,POI_DMA_ID,POI_TerritoryCode,POI_OrderTypeName,POI_PointTypeCode
			from PurchaseOrderInit where POI_USER = @UserId) a 
			
			--������ϵ�˺��ջ���Ϣ
			update #mmbo_PurchaseOrderHeader set POH_ContactPerson = DST_ContactPerson,POH_Contact = DST_Contact,
			POH_ContactMobile = DST_ContactMobile,POH_Consignee = DST_Consignee,POH_ConsigneePhone = DST_ConsigneePhone
			from DealerShipTo where DST_Dealer_DMA_ID = POH_DMA_ID and DST_Dealer_User_ID = POH_CreateUser
      
   				
     
     
      --���³�����
Update #mmbo_PurchaseOrderHeader set POH_TerritoryCode = DMA_Certification
FROM DealerMaster where DMA_ID = POH_DMA_ID


	--������ʱ������ϸ�� ���Ӷ�����ҪLotNumber
 insert into #mmbo_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
	POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM,
POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,
POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
	select newid(),POH_ID,POI_CFN_ID,POI_Amount,POI_RequiredQty,POI_Amount*POI_RequiredQty,0,0,POI_LotNumber,CFN_UOM,
REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,REG.LastValidDataTo,
REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
	from(
	select b.POH_ID,a.POI_CFN_ID,Price.Price,a.POI_RequiredQty,POI_LotNumber,Price.Uom as CFN_UOM,POI_Amount
	from (select POI_USER,POI_OrderTypeName,POI_CFN_ID,POI_BUM_ID,POI_DMA_ID,POI_LotNumber,sum(convert(decimal(8,2),POI_RequiredQty)) as POI_RequiredQty ,ISNULL(POI_Amount,0) AS POI_Amount
	       from PurchaseOrderInit 
     where POI_OrderTypeName  in ('SpecialPrice','Transfer','ClearBorrowManual') 
		AND POI_USER = @UserId 
   group by  POI_USER,POI_OrderTypeName,POI_CFN_ID,POI_BUM_ID,POI_DMA_ID,POI_LotNumber,isnull(POI_Amount,0)) as a, 
	#mmbo_PurchaseOrderHeader as b,#dealer_Price as Price,Lafite_DICT AS Dict
	where a.POI_USER = b.POH_CreateUser
	and a.POI_BUM_ID = b.POH_ProductLine_BUM_ID
	and a.POI_DMA_ID = b.POH_DMA_ID		
	and a.POI_OrderTypeName = b.POH_OrderType
	and a.POI_CFN_ID = Price.CFNID
and Dict.DICT_TYPE = N'CONST_Order_Type'
AND Price.PriceType = Dict.Value2
AND Dict.Dict_Key = a.POI_OrderTypeName
	) as c 
inner join cfn on (c.POI_CFN_ID = CFN.cfn_ID) 
LEFT join MD.V_INF_UPN_REG AS REG ON (cfn.CFN_CustomerFaceNbr = REG.CurUPN)

       
        
			--������ʱ������ϸ�� ������������Ҫ����LotNumber����
			 
			
			--insert into #mmbo_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
			--   POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM,
   --      POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,
   --      POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
			--select newid(),POH_ID,POI_CFN_ID,price,POI_RequiredQty,price*POI_RequiredQty,0,0,'',CFN_UOM,
   --      REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
   --      REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
			--from(
			
			--select b.POH_ID,a.POI_CFN_ID,Price.Price,a.POI_RequiredQty,Price.Uom as CFN_UOM
			--from (select POI_USER,POI_OrderTypeName,POI_CFN_ID,POI_BUM_ID,POI_DMA_ID,sum(convert(decimal(8,2),POI_RequiredQty)) as POI_RequiredQty ,POI_PointTypeCode
			--        from PurchaseOrderInit 
   --          where POI_OrderTypeName not in ('SpecialPrice','Transfer','ClearBorrowManual') 
			--	AND POI_USER = @UserId 
   --          group by POI_PointTypeCode,POI_USER,POI_OrderTypeName,POI_CFN_ID,POI_BUM_ID,POI_DMA_ID) as a, 
			--#mmbo_PurchaseOrderHeader as b,#dealer_Price as Price,Lafite_DICT AS Dict
			--where a.POI_USER = b.POH_CreateUser
			--and a.POI_BUM_ID = b.POH_ProductLine_BUM_ID
			--and a.POI_DMA_ID = b.POH_DMA_ID			
			--and a.POI_OrderTypeName = b.POH_OrderType
			--and a.POI_CFN_ID = Price.CFNID
   --   and Dict.DICT_TYPE = N'CONST_Order_Type'
   --   AND Price.PriceType = Dict.Value2
   --   AND Dict.Dict_Key = a.POI_OrderTypeName
	  --and ISNULL( b.POH_PointType,'')= isnull(a.POI_PointTypeCode ,'')	  
			--) as c 			 
   --     inner join cfn on (c.POI_CFN_ID = CFN.cfn_ID) 
   --     LEFT join MD.V_INF_UPN_REG AS REG ON (cfn.CFN_CustomerFaceNbr = REG.CurUPN)
        
  
  
      if(@DealerType='t2')
      begin
        insert into #mmbo_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
			   POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM,
         POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,
         POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
			select newid(),POH_ID,POI_CFN_ID,price,POI_RequiredQty,price*POI_RequiredQty,0,0,'',CFN_UOM,
         REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
         REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
			from(
			
			select b.POH_ID,a.POI_CFN_ID,Price.Price,a.POI_RequiredQty,Price.Uom as CFN_UOM
			from (select POI_USER,POI_OrderTypeName,POI_CFN_ID,POI_BUM_ID,POI_DMA_ID,sum(convert(decimal(8,2),POI_RequiredQty)) as POI_RequiredQty ,POI_PointTypeCode
			        from PurchaseOrderInit 
             where POI_OrderTypeName not in ('SpecialPrice','Transfer','ClearBorrowManual') 
				AND POI_USER = @UserId 
             group by POI_PointTypeCode,POI_USER,POI_OrderTypeName,POI_CFN_ID,POI_BUM_ID,POI_DMA_ID) as a, 
			#mmbo_PurchaseOrderHeader as b,#dealer_Price as Price,Lafite_DICT AS Dict
			where a.POI_USER = b.POH_CreateUser
			and a.POI_BUM_ID = b.POH_ProductLine_BUM_ID
			and a.POI_DMA_ID = b.POH_DMA_ID			
			and a.POI_OrderTypeName = b.POH_OrderType
			and a.POI_CFN_ID = Price.CFNID
      and Dict.DICT_TYPE = N'CONST_Order_Type'
      AND Price.PriceType = case when POI_OrderTypeName in ('CRPO','PRO') then 'Base' ELSE  Dict.Value2 end
      AND Dict.Dict_Key = a.POI_OrderTypeName
	  and ISNULL( b.POH_PointType,'')= isnull(a.POI_PointTypeCode ,'')	  
			) as c 			 
        inner join cfn on (c.POI_CFN_ID = CFN.cfn_ID) 
        LEFT join MD.V_INF_UPN_REG AS REG ON (cfn.CFN_CustomerFaceNbr = REG.CurUPN)
      
      
      end
    else
      begin
      insert into #mmbo_PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
			   POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM,
         POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,
         POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog)
			select newid(),POH_ID,POI_CFN_ID,price,POI_RequiredQty,price*POI_RequiredQty,0,0,'',CFN_UOM,
         REG.CurRegNo,REG.CurValidDateFrom,REG.CurValidDataTo,REG.CurManuName,REG.LastRegNo,REG.LastValidDateFrom,
         REG.LastValidDataTo,REG.LastManuName,REG.CurGMKind,REG.CurGMCatalog
			from(
			
			select b.POH_ID,a.POI_CFN_ID,Price.Price,a.POI_RequiredQty,Price.Uom as CFN_UOM
			from (select POI_USER,POI_OrderTypeName,POI_CFN_ID,POI_BUM_ID,POI_DMA_ID,sum(convert(decimal(8,2),POI_RequiredQty)) as POI_RequiredQty ,POI_PointTypeCode
			        from PurchaseOrderInit 
             where POI_OrderTypeName not in ('SpecialPrice','Transfer','ClearBorrowManual')
				AND POI_USER = @UserId 
             group by POI_PointTypeCode,POI_USER,POI_OrderTypeName,POI_CFN_ID,POI_BUM_ID,POI_DMA_ID) as a, 
			#mmbo_PurchaseOrderHeader as b,#dealer_Price as Price,Lafite_DICT AS Dict
			where a.POI_USER = b.POH_CreateUser
			and a.POI_BUM_ID = b.POH_ProductLine_BUM_ID
			and a.POI_DMA_ID = b.POH_DMA_ID			
			and a.POI_OrderTypeName = b.POH_OrderType
			and a.POI_CFN_ID = Price.CFNID
      and Dict.DICT_TYPE = N'CONST_Order_Type'
      AND Price.PriceType = Dict.Value2
      AND Dict.Dict_Key = a.POI_OrderTypeName
	  and ISNULL( b.POH_PointType,'')= isnull(a.POI_PointTypeCode ,'')	  
	 
			) as c 			 
        inner join cfn on (c.POI_CFN_ID = CFN.cfn_ID) 
        LEFT join MD.V_INF_UPN_REG AS REG ON (cfn.CFN_CustomerFaceNbr = REG.CurUPN)
       
       end
  
  
    
        
   


			--���붩���������ϸ��
			--insert into PurchaseOrderHeader 
			--select * from #mmbo_PurchaseOrderHeader
			insert into PurchaseOrderHeader(POH_ID,
											POH_OrderNo,
											POH_ProductLine_BUM_ID,
											POH_DMA_ID,
											POH_VendorID,
											POH_TerritoryCode,
											POH_RDD,
											POH_ContactPerson,
											POH_Contact,
											POH_ContactMobile,
											POH_Consignee,
											POH_ShipToAddress,
											POH_ConsigneePhone,
											POH_Remark,
											POH_InvoiceComment,
											POH_CreateType,
											POH_CreateUser,
											POH_CreateDate,
											POH_UpdateUser,
											POH_UpdateDate,
											POH_SubmitUser,
											POH_SubmitDate,
											POH_LastBrowseUser,
											POH_LastBrowseDate,
											POH_OrderStatus,
											POH_LatestAuditDate,
											POH_IsLocked,
											POH_SAP_OrderNo,
											POH_SAP_ConfirmDate,
											POH_LastVersion,
											POH_OrderType,
											POH_VirtualDC,
											POH_SpecialPriceID,
											POH_WHM_ID,
											POH_POH_ID,
											POH_PointType)
											select POH_ID,
											POH_OrderNo,
											POH_ProductLine_BUM_ID,
											POH_DMA_ID,
											POH_VendorID,
											POH_TerritoryCode,
											POH_RDD,
											POH_ContactPerson,
											POH_Contact,
											POH_ContactMobile,
											POH_Consignee,
											POH_ShipToAddress,
											POH_ConsigneePhone,
											POH_Remark,
											POH_InvoiceComment,
											POH_CreateType,
											POH_CreateUser,
											POH_CreateDate,
											POH_UpdateUser,
											POH_UpdateDate,
											POH_SubmitUser,
											POH_SubmitDate,
											POH_LastBrowseUser,
											POH_LastBrowseDate,
											POH_OrderStatus,
											POH_LatestAuditDate,
											POH_IsLocked,
											POH_SAP_OrderNo,
											POH_SAP_ConfirmDate,
											POH_LastVersion,
											POH_OrderType,
											POH_VirtualDC,
											POH_SpecialPriceID,
											POH_WHM_ID,
											POH_POH_ID,POH_PointType FROM #mmbo_PurchaseOrderHeader


			insert into PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
			POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM,
			POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog) 
			select POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,POD_Amount,
			POD_Tax,POD_ReceiptQty,POD_LotNumber,POD_UOM,POD_CurRegNo,POD_CurValidDateFrom,POD_CurValidDataTo,POD_CurManuName,POD_LastRegNo,POD_LastValidDateFrom,POD_LastValidDataTo,POD_LastManuName,POD_CurGMKind,POD_CurGMCatalog
			from #mmbo_PurchaseOrderDetail

			--���붩��������־
			INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
			SELECT NEWID(),POH_ID,POH_CreateUser,GETDATE(),'ExcelImport',NULL FROM #mmbo_PurchaseOrderHeader
			
			--����м�������
			DELETE FROM PurchaseOrderInit WHERE POI_USER = @UserId
		END
	
	end
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










































			
GO


