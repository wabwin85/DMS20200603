DROP PROCEDURE [Promotion].[Proc_Interface_TopValueInit] 
GO


/**********************************************
	���ܣ�У��ⶥֵ
	���ߣ�GrapeCity
	������ʱ�䣺	2015-12-23
	���¼�¼˵����
	1.���� 2015-12-23
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_TopValueInit] 
	@UserId NVARCHAR(36),
	@TopValueType NVARCHAR(20),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN 
	  SET @IsValid='Success';
	  
	  IF @TopValueType='DealerPeriod'
	  BEGIN
		UPDATE A SET ErrMsg='������SAP ACCOUNT���ڼ䲻��Ϊ��'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE (ISNULL(A.SAPCode,'')='' OR ISNULL(A.Period,'')='') AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
		UPDATE A SET ErrMsg='��������+���ڡ��ⶥֵ���Ͳ���Ҫ��дҽԺCode'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE ISNULL(A.HospitalId,'')<>'' AND ISNULL(A.ErrMsg,'')=''  AND CurrUser=@UserId
		
	  END
	  ELSE IF @TopValueType='Dealer'
	  BEGIN
		UPDATE A SET ErrMsg='������SAP ACCOUNT����Ϊ��'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE ISNULL(A.SAPCode,'')='' AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='�������̡��ⶥֵ���Ͳ���Ҫ��дҽԺCode��������'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE (ISNULL(A.HospitalId,'')<>'' OR ISNULL(A.Period,'')<>'')  AND ISNULL(A.ErrMsg,'')=''  AND CurrUser=@UserId
	  END
	  ELSE IF @TopValueType='HospitalPeriod'
	  BEGIN
		UPDATE A SET ErrMsg='������SAP ACCOUNT��ҽԺCode���ڼ䶼����Ϊ��'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE (ISNULL(A.HospitalId,'')='' OR ISNULL(A.Period,'')='' OR ISNULL(A.SAPCode,'')='') AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
	  END
	  ELSE IF @TopValueType='Hospital'
	  BEGIN
		UPDATE A SET ErrMsg='ҽԺCode����Ϊ��'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE ISNULL(A.HospitalId,'')='' AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='��ҽԺ���ⶥֵ���Ͳ���Ҫ��д������SAP ACCOUNT��������'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE (ISNULL(A.SAPCode,'')<>'' OR ISNULL(A.Period,'')<>'')  AND ISNULL(A.ErrMsg,'')=''  AND CurrUser=@UserId
	  END
	  
	  
	  IF @TopValueType='DealerPeriod' OR @TopValueType='Dealer' OR @TopValueType='HospitalPeriod'
	  BEGIN
			UPDATE A SET ErrMsg='������SAP ACCOUNT ��д����'
			FROM Promotion.PRO_POLICY_TOPVALUE_UI A
			WHERE NOT EXISTS (SELECT 1 FROM DealerMaster B WHERE A.SAPCode=B.DMA_SAP_Code)
			AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId

			UPDATE A SET DealerId=B.DMA_ID
			FROM Promotion.PRO_POLICY_TOPVALUE_UI A
			INNER JOIN DealerMaster B ON A.SAPCode=B.DMA_SAP_Code AND CurrUser=@UserId
	  END
	  IF @TopValueType='HospitalPeriod' OR @TopValueType='Hospital'
	  BEGIN
		  UPDATE A SET ErrMsg='ҽԺCode��д����'
		  FROM Promotion.PRO_POLICY_TOPVALUE_UI A
		  WHERE NOT EXISTS (SELECT 1 FROM Hospital B WHERE A.HospitalId=B.HOS_Key_Account) 
		  AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
	  END
	  IF @TopValueType='HospitalPeriod' OR @TopValueType='DealerPeriod'
	  BEGIN
		UPDATE A SET ErrMsg='���ڸ�ʽ��д����ȷ'
		  FROM Promotion.PRO_POLICY_TOPVALUE_UI A
		  WHERE  ISNULL(A.ErrMsg,'')='' AND LEN(A.Period)<>6 AND CurrUser=@UserId
	  END
	  
	  IF EXISTS(SELECT 1 FROM Promotion.PRO_POLICY_TOPVALUE_UI  WHERE ISNULL(ErrMsg,'')<>'' AND CurrUser=@UserId)
	  BEGIN
		SET @IsValid='Error';
	  END
	 
	 
	  
END 

GO


