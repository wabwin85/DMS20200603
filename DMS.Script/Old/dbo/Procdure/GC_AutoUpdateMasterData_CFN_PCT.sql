DROP PROCEDURE [dbo].[GC_AutoUpdateMasterData_CFN_PCT] 
GO




/*
更新CFN表产品分类
*/
CREATE PROCEDURE [dbo].[GC_AutoUpdateMasterData_CFN_PCT] 
@RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT
WITH EXEC AS CALLER
AS
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
	--ENDO PI CARDIO EP URO SH
	UPDATE CFN SET CFN_ProductCatagory_PCT_ID=CA_ID ,CFN_ProductLine_BUM_ID=dp.ProductLineID
	FROM interface.T_I_QV_CfnClassification a  
	INNER JOIN (SELECT DISTINCT CA_ID,CA_Code FROM interface.ClassificationAuthorization ) b 
		ON CONVERT(NVARCHAR(10), a.Classification)=b.CA_Code
	INNER JOIN V_DivisionProductLineRelation DP ON DP.IsEmerging='0' AND DP.DivisionCode=CONVERT(nvarchar(10),a.DivisionId)
	WHERE CFN.CFN_CustomerFaceNbr=a.UPN
	AND DP.ProductLineID IN (
	'0f71530b-66d5-44af-9cab-ad65d5449c51',
	'18847e4a-e133-4ccc-bc7a-e93564e65003',
	'8de26929-588b-4e24-9dcd-a26200a9d56b',
	'8f15d92a-47e4-462f-a603-f61983d61b7b',
	'e9da0666-2eda-4883-8f28-a24301255cc3',
	'e2964379-9323-4009-9cf9-a33800b55a2b',
	'5D0327F2-C360-442F-9961-A3100116F8C3',
	'97a4e135-74c7-4802-af23-9d6d00fcb2cc');
	
	
	--未同步关系的UPN 产品分类设置为空
	--UPDATE T1  SET CFN_ProductCatagory_PCT_ID='00000000-0000-0000-0000-000000000000'
	--FROM CFN T1 
	--WHERE NOT EXISTS(SELECT 1 FROM interface.T_I_QV_CfnClassification a
	--						INNER JOIN (SELECT DISTINCT CA_ID,CA_Code FROM interface.ClassificationAuthorization ) b ON CONVERT(NVARCHAR(10), a.Classification)=b.CA_Code
	--						INNER JOIN V_DivisionProductLineRelation DP ON DP.IsEmerging='0' AND DP.DivisionCode=CONVERT(nvarchar(10),a.DivisionId)
	--						WHERE  T1.CFN_CustomerFaceNbr=A.UPN AND DP.ProductLineID=T1.CFN_ProductLine_BUM_ID)
	--AND T1.CFN_ProductLine_BUM_ID IN (
	--'0f71530b-66d5-44af-9cab-ad65d5449c51',
	--'18847e4a-e133-4ccc-bc7a-e93564e65003',
	--'8de26929-588b-4e24-9dcd-a26200a9d56b',
	--'8f15d92a-47e4-462f-a603-f61983d61b7b',
	--'e9da0666-2eda-4883-8f28-a24301255cc3',
	--'e2964379-9323-4009-9cf9-a33800b55a2b');
	
	
	
	--更新接口表
	UPDATE interface.T_I_QV_CFN SET ProductLine_ID=DP.ProductLineID,	DivisionID=a.DivisionId,	Division=dp.DivisionName
	FROM interface.T_I_QV_CfnClassification a  
	INNER JOIN V_DivisionProductLineRelation DP ON DP.IsEmerging='0' AND DP.DivisionCode=CONVERT(nvarchar(10),a.DivisionId)
	WHERE interface.T_I_QV_CFN.UPN=a.UPN
	AND DP.ProductLineID IN (
	'0f71530b-66d5-44af-9cab-ad65d5449c51',
	'18847e4a-e133-4ccc-bc7a-e93564e65003',
	'8de26929-588b-4e24-9dcd-a26200a9d56b',
	'8f15d92a-47e4-462f-a603-f61983d61b7b',
	'e9da0666-2eda-4883-8f28-a24301255cc3',
	'e2964379-9323-4009-9cf9-a33800b55a2b',
	'5D0327F2-C360-442F-9961-A3100116F8C3',
	'97a4e135-74c7-4802-af23-9d6d00fcb2cc');
		
	--Other ProductLine 
	UPDATE CFN SET CFN_ProductCatagory_PCT_ID=A.PCT_ID
	FROM PartsClassification A   
	WHERE   a.PCT_ProductLine_BUM_ID=CFN.CFN_ProductLine_BUM_ID
		AND A.PCT_ParentClassification_PCT_ID IS NULL
		AND CFN.CFN_ProductLine_BUM_ID NOT IN ('0f71530b-66d5-44af-9cab-ad65d5449c51',
												'18847e4a-e133-4ccc-bc7a-e93564e65003',
												'8de26929-588b-4e24-9dcd-a26200a9d56b',
												'8f15d92a-47e4-462f-a603-f61983d61b7b',
												'e9da0666-2eda-4883-8f28-a24301255cc3',
												'e2964379-9323-4009-9cf9-a33800b55a2b',
												'5D0327F2-C360-442F-9961-A3100116F8C3',
												'97a4e135-74c7-4802-af23-9d6d00fcb2cc');
	
	--解决共享产品问题											
	UPDATE CFN SET CFN_ProductCatagory_PCT_ID='0A3B34DA-43D6-4FED-B62B-A253010D7DD0',CFN_ProductLine_BUM_ID='0f71530b-66d5-44af-9cab-ad65d5449c51'
	WHERE 
	 CFN.CFN_CustomerFaceNbr IN (
	'H74938931010',
	'H74938931012',
	'H7493893101J0',
	'H7493893101J2',
	'H74938931020',
	'H74938931022',
	'H7493893102J0',
	'H7493893102J2',
	'H74938931030',
	'H74938931032',
	'H7493893103J0',
	'H7493893103J2',
	'H74938931040',
	'H74938931042',
	'H7493893104J0',
	'H7493893104J2');
	
	--IC马达共享IC耗材经销商
	UPDATE CFN SET CFN_ProductCatagory_PCT_ID='B1F7A22A-7BB2-49C1-BB34-A5DF009BADC9' ,CFN_ProductLine_BUM_ID='0f71530b-66d5-44af-9cab-ad65d5449c51'
	WHERE 
	 CFN.CFN_CustomerFaceNbr IN ('H749MDU5PLUS0');
	
	--IC 共享EP
	update CFN set CFN_ProductCatagory_PCT_ID='0D3127E0-CC6F-488D-AAAB-352F27F4E751' ,CFN_ProductLine_BUM_ID='0f71530b-66d5-44af-9cab-ad65d5449c51'
	where  CFN_CustomerFaceNbr='H749PVCADISTMM30M0';
	
	UPDATE CFN SET CFN_ProductCatagory_PCT_ID='C3A82E41-8248-4B75-A58C-A348017D9901',CFN_ProductLine_BUM_ID='18847E4A-E133-4CCC-BC7A-E93564E65003'
	WHERE 
	 CFN.CFN_CustomerFaceNbr IN (
	'M001151050',
	'M001151062');
	
	
	UPDATE CFN SET CFN_ProductCatagory_PCT_ID='90B1A3D7-C235-4194-B139-A54E01088C14',CFN_ProductLine_BUM_ID='8F15D92A-47E4-462F-A603-F61983D61B7B'
	WHERE 
	 CFN.CFN_CustomerFaceNbr IN (
	'M00550601',
	'M00550620',
	'M00515191',
	'M00515201');
	
	--UPDATE CFN SET CFN_ProductCatagory_PCT_ID='90B1A3D7-C235-4194-B139-A54E01088C14'
	--WHERE CFN.CFN_CustomerFaceNbr IN ('M00515181')
	
--Begin （Endo 产品转AS 特殊处理）
	
	CREATE TABLE #Tmp_Product_Speical
	(
		 [UPN]            NVARCHAR (50) NOT NULL,
		 [Divison]        NVARCHAR (100) NULL,
		 [CreateDate]     NVARCHAR (55) NULL,        
		 PRIMARY KEY ([UPN])
	)

	INSERT INTO #Tmp_Product_Speical
	 SELECT distinct t1.*
	   FROM dbo.Tmp_Product_Special t1 where t1.CreateDate =
			(SELECT max (createDate) AS CreateDate
			   FROM dbo.Tmp_Product_Special
			) 
                
	--Asthma产品更新
	update interface.T_I_QV_CFN set DivisionID=34, Division='AS', ProductLine_ID='5d0327f2-c360-442f-9961-a3100116f8c3' where UPN IN (select UPN from #Tmp_Product_Speical where Divison='AS')      
      
      
	--更新产品线信息(Asthma产品)
	update CFN set CFN_ProductLine_BUM_ID='5d0327f2-c360-442f-9961-a3100116f8c3' where CFN_CustomerFaceNbr IN (select UPN from #Tmp_Product_Speical where Divison='AS')      
           
--End  （Endo 产品转AS 特殊处理）


--begin（产品结构调整，单个UPN可挂多个产品分类）
--select * from CfnClassification
--select * FROM interface.T_I_QV_CfnClassification a  
--select * from interface.T_I_QV_CFN 

truncate table CfnClassification;
INSERT INTO CfnClassification (CfnCustomerFaceNbr,ClassificationId)
SELECT distinct a.UPN,CA_ID FROM 
interface.T_I_QV_CfnClassification a 
INNER JOIN (SELECT DISTINCT CA_ID,CA_Code FROM interface.ClassificationAuthorization ) b 
		ON CONVERT(NVARCHAR(10), a.Classification)=b.CA_Code
	INNER JOIN V_DivisionProductLineRelation DP ON DP.IsEmerging='0' AND DP.DivisionCode=CONVERT(nvarchar(10),a.DivisionId)
	--AND a.UPN='60S502-352'
	AND DP.ProductLineID IN (
	'0f71530b-66d5-44af-9cab-ad65d5449c51',
	'18847e4a-e133-4ccc-bc7a-e93564e65003',
	'8de26929-588b-4e24-9dcd-a26200a9d56b',
	'8f15d92a-47e4-462f-a603-f61983d61b7b',
	'e9da0666-2eda-4883-8f28-a24301255cc3',
	'e2964379-9323-4009-9cf9-a33800b55a2b',
	'5D0327F2-C360-442F-9961-A3100116F8C3',
	'97a4e135-74c7-4802-af23-9d6d00fcb2cc');

INSERT INTO CfnClassification (CfnCustomerFaceNbr,ClassificationId)
SELECT distinct CFN.CFN_CustomerFaceNbr,A.PCT_ID FROM  CFN INNER JOIN PartsClassification A   
	ON   a.PCT_ProductLine_BUM_ID=CFN.CFN_ProductLine_BUM_ID
		AND A.PCT_ParentClassification_PCT_ID IS NULL
		--AND CFN.CFN_CustomerFaceNbr='60S502-352'
		AND CFN.CFN_ProductLine_BUM_ID NOT IN ('0f71530b-66d5-44af-9cab-ad65d5449c51',
												'18847e4a-e133-4ccc-bc7a-e93564e65003',
												'8de26929-588b-4e24-9dcd-a26200a9d56b',
												'8f15d92a-47e4-462f-a603-f61983d61b7b',
												'e9da0666-2eda-4883-8f28-a24301255cc3',
												'e2964379-9323-4009-9cf9-a33800b55a2b',
												'5D0327F2-C360-442F-9961-A3100116F8C3',
												'97a4e135-74c7-4802-af23-9d6d00fcb2cc');

INSERT INTO CfnClassification (CfnCustomerFaceNbr,ClassificationId)
SELECT CFN.CFN_CustomerFaceNbr,'00000000-0000-0000-0000-000000000000' 
FROM CFN WHERE NOT EXISTS(SELECT 1 FROM CfnClassification A WHERE A.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr)										
--法兰克曼特殊处理
update CfnClassification set ClassificationId='96414B25-2D85-40FC-857C-F2994B857256' where CfnCustomerFaceNbr in ('91157375-02','91157375-03','91157375-04','91157375-01')


--临时解决共享产品问题
insert into  CfnClassification (CfnCustomerFaceNbr,ClassificationId)
select CFN_CustomerFaceNbr,'0A3B34DA-43D6-4FED-B62B-A253010D7DD0' from CFN
WHERE CFN.CFN_CustomerFaceNbr IN ('H74938931010',	'H74938931012',	'H7493893101J0',	'H7493893101J2',	'H74938931020',	'H74938931022',
'H7493893102J0',	'H7493893102J2',	'H74938931030',	'H74938931032',	'H7493893103J0',	'H7493893103J2',	'H74938931040',
'H74938931042',	'H7493893104J0',	'H7493893104J2');

insert into  CfnClassification (CfnCustomerFaceNbr,ClassificationId)
select CFN_CustomerFaceNbr,'0D3127E0-CC6F-488D-AAAB-352F27F4E751' from CFN
WHERE CFN.CFN_CustomerFaceNbr IN ('H749PVCADISTMM30M0');

insert into  CfnClassification (CfnCustomerFaceNbr,ClassificationId)
select CFN_CustomerFaceNbr,'C3A82E41-8248-4B75-A58C-A348017D9901' from CFN
WHERE CFN.CFN_CustomerFaceNbr IN ('M001151050',	'M001151062');

insert into  CfnClassification (CfnCustomerFaceNbr,ClassificationId)
select CFN_CustomerFaceNbr,'90B1A3D7-C235-4194-B139-A54E01088C14' from CFN
WHERE CFN.CFN_CustomerFaceNbr IN ('M00550601',	'M00550620',	'M00515191',	'M00515201');

--end （产品结构调整，单个UPN可挂多个产品分类）

	
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


