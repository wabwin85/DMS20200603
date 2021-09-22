DROP PROCEDURE [Workflow].[Proc_SampleReturn_GetHtmlData]
GO


CREATE PROCEDURE [Workflow].[Proc_SampleReturn_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)

SELECT @ApplyType = SampleType from SampleReturnHead where SampleReturnHeadId=@InstanceId

SELECT case when @ApplyType = '商业样品' then 'SampleReturn' else 'SampleTestReturn' end AS TemplateName, 'Header,SampleUPN' AS TableNames

--数据信息
--表头
 SELECT SampleReturnHeadId as Id,SampleType,ReturnRequire,ReturnNo,ApplyNo,ReturnDate,ReturnUserId,ReturnUser,ProcessUserId,ProcessUser,ReturnHosp,
          ReturnDept,ReturnDivision,DealerId,DealerName,ReturnReason,isnull((select sum(convert(decimal(18,2),ApplyQuantity)) from SampleUpn where SampleReturnHeadId = SampleHeadID),0) AS ReturnQuantity,ConfirmQuantity,ReturnMemo,value1 as ReturnStatus
          ,CourierNumber
		  FROM SampleReturnHead,dbo.Lafite_DICT
	WHERE SampleReturnHeadId = @InstanceId
	and ReturnStatus = DICT_KEY
	and DICT_TYPE = 'CONST_Sample_State'
	

--产品信息
SELECT UpnNo,ProductName,ProductDesc,convert(decimal(18,2),ApplyQuantity) as ApplyQuantity,Lot,ProductMemo FROM SampleUpn WHERE SampleHeadId=@InstanceId ORDER BY SortNo




GO


