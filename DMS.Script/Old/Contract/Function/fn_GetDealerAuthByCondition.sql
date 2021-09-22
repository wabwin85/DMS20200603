DROP FUNCTION [Contract].[fn_GetDealerAuthByCondition]
GO

CREATE FUNCTION [Contract].[fn_GetDealerAuthByCondition] (@ContractId NVARCHAR(36),@SubBUCode NVARCHAR(20),@IsArea NVARCHAR(20),@BEGINDATE DATETIME)
	RETURNS @re TABLE
	(
		ProductCode          NVARCHAR (30) NULL,
		ProductName          NVARCHAR (30) NULL,
		AuthCode         NVARCHAR (30) NULL,
		AuthName         NVARCHAR (30) NULL,
		Depart				NVARCHAR (30) NULL,
		DepartType			NVARCHAR (30) NULL,
		Remark				NVARCHAR (max) NULL
	)
AS
   BEGIN
	
      INSERT INTO @re(ProductCode,ProductName,AuthCode,AuthName,Depart,DepartType,Remark)
      SELECT CA.CA_Code,CA.CA_NameCN,C.HOS_Key_Account,C.HOS_HospitalName,B.HOS_Depart,D.VALUE1,B.HOS_DepartRemark 
      FROM DealerAuthorizationTableTemp a 
      INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
      INNER JOIN Hospital C ON C.HOS_ID=B.HOS_ID
      INNER JOIN (SELECT DISTINCT CA_ID,CA_Code,CA_NameCN FROM interface.ClassificationAuthorization WHERE CA_ParentCode=@SubBUCode) CA ON CA.CA_ID=A.DAT_PMA_ID
      LEFT JOIN Lafite_DICT D ON D.DICT_KEY=B.HOS_DepartType AND D.DICT_TYPE='HospitalDepart'
      WHERE A.DAT_DCL_ID=@ContractId AND ISNULL(@IsArea,'')<>'1'
      UNION
      SELECT CA.CA_Code,CA.CA_NameCN,c.TER_Code,c.TER_Description,NULL,NULL,
      'ÅÅ³ýÒ½Ôº£º'+(SELECT STUFF(REPLACE(REPLACE((
						SELECT HOS_HospitalName AS RESULT FROM TerritoryAreaExcTemp EX,Hospital HOS WHERE EX.TAE_DA_ID=A.DA_ID AND HOS.HOS_ID=EX.TAE_HOS_ID AND HOS_Province=C.TER_Description
					FOR XML AUTO), '<HOS RESULT="', ','), '"/>', ''), 1, 1, ''))
      FROM DealerAuthorizationAreaTemp a 
      INNER JOIN TerritoryAreaTemp B ON A.DA_ID=B.TA_DA_ID
      INNER JOIN Territory C ON C.TER_ID=B.TA_Area
      INNER JOIN (SELECT DISTINCT CA_ID,CA_Code,CA_NameCN FROM interface.ClassificationAuthorization WHERE CA_ParentCode=@SubBUCode) CA ON CA.CA_ID=A.DA_PMA_ID
	  WHERE A.DA_DCL_ID=@ContractId AND ISNULL(@IsArea,'')='1';

      RETURN
   END
GO


