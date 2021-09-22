DROP FUNCTION [dbo].[GC_Fn_DCMS_CheckHospitalProductQuery]
GO


/**********************************************
 功能:医院产品授权是否被删除
 作者：Grapecity
 最后更新时间： 2016-07-28
 更新记录说明：
 1.创建 2016-07-28
 2.返回0 表示被删除 
**********************************************/

CREATE FUNCTION [dbo].[GC_Fn_DCMS_CheckHospitalProductQuery]
(
	 @ContractId NVARCHAR(36),
	 @HospitalId NVARCHAR(36),
	 @ProductId NVARCHAR(36)
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(10);
	IF EXISTS (SELECT 1 
				FROM DealerAuthorizationTableTemp A 
				INNER JOIN ContractTerritory b ON A.DAT_ID=B.Contract_ID
				INNER JOIN (SELECT Distinct CA_ID,CQ_ID FROM interface.ClassificationAuthorization inner join interface.ClassificationQuota on CA_Code=CQ_ParentCode) c on c.CA_ID=a.DAT_PMA_ID
				WHERE A.DAT_DCL_ID=@ContractId and b.HOS_ID=@HospitalId and c.CQ_ID=@ProductId )
	BEGIN
		SET @iReturn=1
	END
	ELSE
	BEGIN
		SET @iReturn=0
	END
	RETURN @iReturn
END




GO


