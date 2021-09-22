
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Contract].[GC_Fn_AuthorizationData_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Contract].[GC_Fn_AuthorizationData_List]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**********************************************
 功能:获取新经销商申请授权区域
 作者：Grapecity
 最后更新时间： 2017-11-20
 更新记录说明：
 1.创建 2017-11-20
**********************************************/

Create FUNCTION [Contract].[GC_Fn_AuthorizationData_List]
(
	 @InstanceId UNIQUEIDENTIFIER
)
RETURNS @temp TABLE 
(
	ContractId	UNIQUEIDENTIFIER NOT NULL,	--合同Id
	ProductName	NVARCHAR(200)	NOT NULL,	--产品分类
	ProductEnglishName NVARCHAR(200) NULL,--产品分类英文名称
	TerritoryCode	NVARCHAR(200)	NULL,	--授权区域编号
	TerritoryName	NVARCHAR(200)	NULL,	--授权区域名称
	TerritoryEName	NVARCHAR(200)	NULL,	--授权区域英文名称
	DepartType		NVARCHAR(200)	NULL,	--科室类型
	DepartName		NVARCHAR(200)	NULL,	--科室名称
	DepartRemark	NVARCHAR(200)	NULL	--科室备注
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN
		IF EXISTS (SELECT 1 FROM DealerAuthorizationAreaTemp A WHERE A.DA_DCL_ID=@InstanceId)
		BEGIN
			INSERT INTO @temp(ContractId,ProductName,ProductEnglishName,TerritoryCode,TerritoryName,TerritoryEName,DepartType,DepartName,DepartRemark)
			SELECT DA_DCL_ID,D.CA_NameCN,D.CA_NameEN,C.TER_Code,C.TER_Description,F.VALUE1,NULL,NULL,NULL
				FROM DealerAuthorizationAreaTemp A
				INNER JOIN TerritoryAreaTemp B ON A.DA_ID=B.TA_DA_ID
				INNER JOIN Territory C ON C.TER_ID=B.TA_Area
				LEFT JOIN Lafite_DICT F ON F.DICT_TYPE='Contract_Province' AND F.DICT_KEY=TER_Description
				LEFT JOIN (SELECT DISTINCT CA_ID,CA_NameCN,CA_Code,CA_NameEN FROM INTERFACE.ClassificationAuthorization) D ON D.CA_ID=A.DA_PMA_ID
				WHERE A.DA_DCL_ID=@InstanceId
		END
		ELSE
		BEGIN
			INSERT INTO @temp(ContractId,ProductName,ProductEnglishName,TerritoryCode,TerritoryName,TerritoryEName,DepartType,DepartName,DepartRemark)
			SELECT DAT_DCL_ID,D.CA_NameCN,D.CA_NameEN,C.HOS_Key_Account,C.HOS_HospitalName,C.HOS_HospitalNameEN,B.HOS_DepartType,B.HOS_Depart,B.HOS_DepartRemark
				FROM DealerAuthorizationTableTemp A
				INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
				INNER JOIN Hospital C ON C.HOS_ID=B.HOS_ID
				LEFT JOIN (SELECT DISTINCT CA_ID,CA_NameCN,CA_Code,CA_NameEN FROM INTERFACE.ClassificationAuthorization) D ON D.CA_ID=A.DAT_PMA_ID
				WHERE A.DAT_DCL_ID=@InstanceId
		END
	
		
		RETURN
    END






GO


