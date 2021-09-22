DROP PROCEDURE [Promotion].[Proc_Interface_TopValueInit] 
GO


/**********************************************
	功能：校验封顶值
	作者：GrapeCity
	最后更新时间：	2015-12-23
	更新记录说明：
	1.创建 2015-12-23
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
		UPDATE A SET ErrMsg='经销商SAP ACCOUNT和期间不能为空'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE (ISNULL(A.SAPCode,'')='' OR ISNULL(A.Period,'')='') AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
		UPDATE A SET ErrMsg='“经销商+周期”封顶值类型不需要填写医院Code'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE ISNULL(A.HospitalId,'')<>'' AND ISNULL(A.ErrMsg,'')=''  AND CurrUser=@UserId
		
	  END
	  ELSE IF @TopValueType='Dealer'
	  BEGIN
		UPDATE A SET ErrMsg='经销商SAP ACCOUNT不能为空'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE ISNULL(A.SAPCode,'')='' AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='“经销商”封顶值类型不需要填写医院Code或者周期'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE (ISNULL(A.HospitalId,'')<>'' OR ISNULL(A.Period,'')<>'')  AND ISNULL(A.ErrMsg,'')=''  AND CurrUser=@UserId
	  END
	  ELSE IF @TopValueType='HospitalPeriod'
	  BEGIN
		UPDATE A SET ErrMsg='经销商SAP ACCOUNT、医院Code和期间都不能为空'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE (ISNULL(A.HospitalId,'')='' OR ISNULL(A.Period,'')='' OR ISNULL(A.SAPCode,'')='') AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
	  END
	  ELSE IF @TopValueType='Hospital'
	  BEGIN
		UPDATE A SET ErrMsg='医院Code不能为空'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE ISNULL(A.HospitalId,'')='' AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='“医院”封顶值类型不需要填写经销商SAP ACCOUNT或者周期'
		FROM Promotion.PRO_POLICY_TOPVALUE_UI A WHERE (ISNULL(A.SAPCode,'')<>'' OR ISNULL(A.Period,'')<>'')  AND ISNULL(A.ErrMsg,'')=''  AND CurrUser=@UserId
	  END
	  
	  
	  IF @TopValueType='DealerPeriod' OR @TopValueType='Dealer' OR @TopValueType='HospitalPeriod'
	  BEGIN
			UPDATE A SET ErrMsg='经销商SAP ACCOUNT 填写错误'
			FROM Promotion.PRO_POLICY_TOPVALUE_UI A
			WHERE NOT EXISTS (SELECT 1 FROM DealerMaster B WHERE A.SAPCode=B.DMA_SAP_Code)
			AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId

			UPDATE A SET DealerId=B.DMA_ID
			FROM Promotion.PRO_POLICY_TOPVALUE_UI A
			INNER JOIN DealerMaster B ON A.SAPCode=B.DMA_SAP_Code AND CurrUser=@UserId
	  END
	  IF @TopValueType='HospitalPeriod' OR @TopValueType='Hospital'
	  BEGIN
		  UPDATE A SET ErrMsg='医院Code填写错误'
		  FROM Promotion.PRO_POLICY_TOPVALUE_UI A
		  WHERE NOT EXISTS (SELECT 1 FROM Hospital B WHERE A.HospitalId=B.HOS_Key_Account) 
		  AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
	  END
	  IF @TopValueType='HospitalPeriod' OR @TopValueType='DealerPeriod'
	  BEGIN
		UPDATE A SET ErrMsg='周期格式填写不正确'
		  FROM Promotion.PRO_POLICY_TOPVALUE_UI A
		  WHERE  ISNULL(A.ErrMsg,'')='' AND LEN(A.Period)<>6 AND CurrUser=@UserId
	  END
	  
	  IF EXISTS(SELECT 1 FROM Promotion.PRO_POLICY_TOPVALUE_UI  WHERE ISNULL(ErrMsg,'')<>'' AND CurrUser=@UserId)
	  BEGIN
		SET @IsValid='Error';
	  END
	 
	 
	  
END 

GO


