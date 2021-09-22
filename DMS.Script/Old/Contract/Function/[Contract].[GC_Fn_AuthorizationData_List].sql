
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Contract].[GC_Fn_AuthorizationData_List]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Contract].[GC_Fn_AuthorizationData_List]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/**********************************************
 ����:��ȡ�¾�����������Ȩ����
 ���ߣ�Grapecity
 ������ʱ�䣺 2017-11-20
 ���¼�¼˵����
 1.���� 2017-11-20
**********************************************/

Create FUNCTION [Contract].[GC_Fn_AuthorizationData_List]
(
	 @InstanceId UNIQUEIDENTIFIER
)
RETURNS @temp TABLE 
(
	ContractId	UNIQUEIDENTIFIER NOT NULL,	--��ͬId
	ProductName	NVARCHAR(200)	NOT NULL,	--��Ʒ����
	ProductEnglishName NVARCHAR(200) NULL,--��Ʒ����Ӣ������
	TerritoryCode	NVARCHAR(200)	NULL,	--��Ȩ������
	TerritoryName	NVARCHAR(200)	NULL,	--��Ȩ��������
	TerritoryEName	NVARCHAR(200)	NULL,	--��Ȩ����Ӣ������
	DepartType		NVARCHAR(200)	NULL,	--��������
	DepartName		NVARCHAR(200)	NULL,	--��������
	DepartRemark	NVARCHAR(200)	NULL	--���ұ�ע
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


