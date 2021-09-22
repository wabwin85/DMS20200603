DROP PROCEDURE [dbo].[Proc_DCMS_HospitalInit] 
GO


/**********************************************
	���ܣ�У����ȨҽԺ
	���ߣ�GrapeCity
	������ʱ�䣺	2016-12-23
	���¼�¼˵����
	1.���� 2016-12-23
**********************************************/
CREATE PROCEDURE [dbo].[Proc_DCMS_HospitalInit] 
	@DatId NVARCHAR(36),
	@MarketType NVARCHAR(10),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN 
	DECLARE @ProductLineId   uniqueidentifier ;
	SET @IsValid='Success';
	
	SELECT @ProductLineId=A.DAT_ProductLine_BUM_ID FROM DealerAuthorizationTableTemp A WHERE A.DAT_ID=@DatId
	UPDATE A SET ErrMsg='ҽԺ���벻��Ϊ��'
	FROM ContractTerritoryInsetTemp A WHERE ISNULL(A.HospitalCode,'')='' AND DatId=@DatId ;
	
	UPDATE A SET A.HospitalName=b.HOS_HospitalName  
	FROM ContractTerritoryInsetTemp A ,Hospital B 
	WHERE A.HospitalCode=B.HOS_Key_Account and b.HOS_ActiveFlag=1 and b.HOS_DeletedFlag=0  AND ISNULL(ErrMsg,'')='' AND DatId=@DatId

	UPDATE A SET ErrMsg='ҽԺ������д����'
	FROM ContractTerritoryInsetTemp A WHERE isnull(A.HospitalName,'')='' AND ISNULL(A.ErrMsg,'')='' AND DatId=@DatId;
	
	IF (@MarketType <>2)
	BEGIN
		UPDATE A SET ErrMsg='ҽԺ�г��������ͬ��ƥ��'
		FROM ContractTerritoryInsetTemp A ,V_AllHospitalMarketProperty B  
		WHERE A.HospitalCode=B.Hos_Code AND B.ProductLineID=@ProductLineId AND B.MarketProperty<>@MarketType
		AND ISNULL(A.ErrMsg,'')='' AND DatId=@DatId; 
	END
	  
	IF EXISTS(SELECT 1 FROM ContractTerritoryInsetTemp  WHERE ISNULL(ErrMsg,'')<>'' AND DatId=@DatId)
	BEGIN
		SET @IsValid='Error';
	END
	 
	 
	  
END 

GO


