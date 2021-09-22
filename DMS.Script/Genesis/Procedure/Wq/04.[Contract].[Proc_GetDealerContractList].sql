SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO









-- =============================================
-- Author:		Ye Pan Fei
-- Create date: 2017-08-01
-- Description:	分页获取用户信息
-- =============================================
ALTER PROCEDURE [Contract].[Proc_GetDealerContractList]
    (
      @DealerType NVARCHAR(50) ,
      @ProductLine NVARCHAR(50) ,
      @ContractNo NVARCHAR(50) ,
      @DealerName NVARCHAR(50) ,
      @ContractStatus NVARCHAR(50),
      @ContractTypeName NVARCHAR(50),
      @InitDealerName NVARCHAR(50),
      @DealerID NVARCHAR(50),
      @CorpType NVARCHAR(50),
		@SubCompanyId    UNIQUEIDENTIFIER,
		@BrandId         UNIQUEIDENTIFIER
      --@CurrentPageIndex INT = 0 ,
      --@PageSize INT = 0
    )
AS
    BEGIN  
   CREATE TABLE #Rust(
   ContractId uniqueidentifier,
   ContractNo NVARCHAR(50),
   ContractType NVARCHAR(50),
   ContractTypeName NVARCHAR(500),
   DealerType NVARCHAR(50),
   CNameCN NVARCHAR(200),
   CCode NVARCHAR(200),
   DealerName NVARCHAR(200),
   ProductLineName NVARCHAR(200),
   DivisionCode NVARCHAR(50),
   ContractStatus NVARCHAR(50),
   DMA_Phone NVARCHAR(50),
   DealerID uniqueidentifier
   )
    INSERT #Rust(ContractId,ContractNo,ContractType,ContractTypeName,DealerType,CNameCN,CCode,DealerName,
    ProductLineName,DivisionCode,ContractStatus,DMA_Phone,DealerID)
     SELECT
      T.ContractId,
      T.ContractNo,
      T.ContractType,
      T.ContractTypeName,
      T.DealerType,
      CC.CC_NameCN as CNameCN,
      CC.CC_Code as CCode,
      T.DMA_ChineseName as DealerName,
      PR.ProductLineName ,
      PR.DivisionCode,
      '' ContractStatus,
      T.DMA_Phone,
      T.CompanyID
      FROM
      (
      SELECT
      A.ContractId,
      A.ContractNo,
      A.DealerType,
      A.SUBDEPID,
      A.DepId,
      A.ContractStatus,
      B.DMA_ChineseName,
      'Amendment' AS ContractType,
      '经销商修改' as ContractTypeName,
      B.DMA_Phone,
      CompanyID
      FROM Contract.AmendmentMain A
      INNER JOIN DealerMaster B ON A.CompanyID=CAST(B.DMA_ID AS NVARCHAR(100))
      WHERE CONVERT(NVARCHAR(10),A.AmendEffectiveDate,120)>='2017-01-01'
      UNION
      SELECT
      A.ContractId,
      A.ContractNo,
      A.DealerType,
      A.SUBDEPID,
      A.DepId,
      A.ContractStatus,
      B.CompanyName,
      'Appointment' AS ContractType,
      '新经销商申请' as ContractTypeName,
      B.Mobile,
      CompanyID
      FROM Contract.AppointmentMain A
      INNER JOIN Contract.AppointmentCandidate B ON A.ContractId=B.ContractId
      INNER JOIN Contract.AppointmentProposals C ON C.ContractId=B.ContractId
      WHERE CONVERT(NVARCHAR(10),C.AgreementBegin,120)>='2017-01-01'
      UNION
      SELECT
      A.ContractId,
      A.ContractNo,
      A.DealerType,
      A.SUBDEPID,
      A.DepId,
      A.ContractStatus,
      B.DMA_ChineseName,
      'Renewal' AS ContractType,
      '经销商续约' as ContractTypeName,
      B.DMA_Phone,
      CompanyID
      FROM Contract.RenewalMain A
      INNER JOIN DealerMaster B ON A.DealerName=B.DMA_SAP_Code
      INNER JOIN Contract.RenewalProposals C ON A.ContractId=C.ContractId
      WHERE CONVERT(NVARCHAR(10),C.AgreementBegin,120)>='2017-01-01'
      UNION
      SELECT
      A.ContractId,
      A.ContractNo,
      A.DealerType,
      A.SUBDEPID,
      A.DepId,
      A.ContractStatus,
      B.DMA_ChineseName,
      'Termination' AS ContractType,
      '经销商终止' as ContractTypeName,
      B.DMA_Phone,
      DMA_ID as CompanyID
      FROM Contract.TerminationMain A
      INNER JOIN DealerMaster B ON A.DealerName=B.DMA_SAP_Code
      WHERE CONVERT(NVARCHAR(10),A.PlanExpiration,120)>='2017-01-01'
       ) T
      INNER JOIN [interface].[ClassificationContract] CC ON T.SUBDEPID=CC.CC_Code
      INNER JOIN V_DivisionProductLineRelation PR ON T.DepId=PR.DivisionCode

      WHERE ((@DealerType='AllDealer' AND T.DealerType IN ('LP','T1')) OR T.DealerType=@DealerType)
      --AND (ISNULL(@InitDealerName,'')='' OR T.DMA_ChineseName IN (@InitDealerName))
      AND (@DealerName='' OR T.DMA_ChineseName LIKE '%'+@DealerName+'%')
      AND (@ContractTypeName='' OR T.ContractTypeName=@ContractTypeName)
      AND (@ContractNo='' OR T.ContractNo LIKE '%'+@ContractNo+'%')
      AND T.ContractStatus='Approved'
	  AND (ISNULL(@ProductLine,'') = '' OR PR.DivisionCode = @ProductLine)
      AND ((T.DealerType='LP' and T.ContractType<>'Termination') 
      OR (T.DealerType='T1' OR T.DealerType='T2'))
		AND ((PR.SubCompanyId = @SubCompanyId AND PR.BrandId = @BrandId) 
					OR (T.ContractStatus='Draft' AND ISNULL(T.DepId,0)=0)
				)
      IF @DealerType='T2'
        BEGIN
		  
          UPDATE  A SET A.ContractStatus='NewContract'
		  FROM  #Rust A 
		  INNER JOIN Contract.ExportT2Main Em on A.ContractId=Em.ContractId 
		  INNER JOIN Contract.ExportVersion Ex on Em.ExportId=Ex.ExportId 
		  WHERE Ex.VersionStatus in('WaitDealerSign','WaitBscSign','Complete','BscAbandonment','Cancelled','WaitDealerAbandonment','Abandonment','WaitLPSign')
        END
     else
        BEGIN
           UPDATE  A SET A.ContractStatus='NewContract'
		  FROM  #Rust A INNER JOIN Contract.ExportMain Em on
		  A.ContractId=Em.ContractId INNER JOIN Contract.ExportVersion Ex
		  on Em.ExportId=Ex.ExportId 
		  WHERE Ex.VersionStatus in('WaitDealerSign','WaitBscSign','Complete','BscAbandonment','Cancelled','WaitDealerAbandonment','Abandonment')
        END
        
       UPDATE  A SET A.ContractStatus='NoContract'
       FROM  #Rust A WHERE ISNULL(A.ContractStatus,'')=''
       
      
      IF(@DealerType='T2')
       BEGIN
        IF(@CorpType='LP')
        BEGIN
          SELECT ROW_NUMBER() OVER(ORDER BY ContractNo DESC) AS ROWNUMBER,ContractId,ContractNo,ContractType,ContractTypeName,DealerType,CNameCN,CCode,DealerName,
        ProductLineName,DivisionCode,CASE  ContractStatus WHEN 'NewContract' THEN '已生成' ELSE '未生成' END AS ContractStatus,DMA_Phone,DealerID,dbo.FN_Contract_IsPassTraining(DealerID,DealerType) AS IsPassTraining
        FROM #Rust WHERE (@ContractStatus='AllContract' OR ContractStatus=@ContractStatus) AND  DealerID IN (SELECT DMA_ID FROM DealerMaster WHERE DMA_Parent_DMA_ID=@DealerID) AND DealerID<>@DealerID
        END
        ELSE
        BEGIN
        SELECT ROW_NUMBER() OVER(ORDER BY ContractNo DESC) AS ROWNUMBER,ContractId,ContractNo,ContractType,ContractTypeName,DealerType,CNameCN,CCode,DealerName,
        ProductLineName,DivisionCode,CASE  ContractStatus WHEN 'NewContract' THEN '已生成' ELSE '未生成' END AS ContractStatus,DMA_Phone,DealerID,dbo.FN_Contract_IsPassTraining(DealerID,DealerType) AS IsPassTraining
        FROM #Rust WHERE (@ContractStatus='AllContract' OR ContractStatus=@ContractStatus) AND (ISNULL(@DealerName,'')='' OR DealerName=@DealerName) AND (ISNULL(@DealerID,'')='' OR cast(DealerID as nvarchar(50))=@DealerID)
        END
       END
      ELSE
       BEGIN
        SELECT ROW_NUMBER() OVER(ORDER BY ContractNo DESC) AS ROWNUMBER,ContractId,ContractNo,ContractType,ContractTypeName,DealerType,CNameCN,CCode,DealerName,
        ProductLineName,DivisionCode,CASE  ContractStatus WHEN 'NewContract' THEN '已生成' ELSE '未生成' END AS ContractStatus,DMA_Phone,DealerID,dbo.FN_Contract_IsPassTraining(DealerID,DealerType) AS IsPassTraining
        FROM #Rust WHERE (@ContractStatus='AllContract' OR ContractStatus=@ContractStatus)
       END
      
     
       

    END;










GO

