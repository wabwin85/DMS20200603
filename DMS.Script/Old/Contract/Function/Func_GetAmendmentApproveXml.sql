
DROP FUNCTION [Contract].[Func_GetAmendmentApproveXml]
GO


CREATE FUNCTION [Contract].[Func_GetAmendmentApproveXml]
(
  @ContractId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @Rtn NVARCHAR(MAX);
  
  DECLARE @EID NVARCHAR(200);
  DECLARE @APPLICANTDEP NVARCHAR(200);
  DECLARE @DEPID NVARCHAR(200);
  DECLARE @SUBDEPID NVARCHAR(200);
  DECLARE @REQUESTDATE NVARCHAR(200);
  DECLARE @DEALERTYPE NVARCHAR(200);
  DECLARE @APPLICATIONID NVARCHAR(200);
  DECLARE @REAGIONRSM NVARCHAR(200);
  DECLARE @DEALERID UNIQUEIDENTIFIER;
  DECLARE @DEALERCODE NVARCHAR(200);
  DECLARE @DEALERNAME NVARCHAR(200);
  DECLARE @PAYTYPE NVARCHAR(200);
  DECLARE @TOTALAMOUNTRMB NVARCHAR(200);
  DECLARE @TOTALAMOUNTUSD NVARCHAR(200);
  DECLARE @ALLTOTALUSD NVARCHAR(200);
  DECLARE @QUOTAUP NVARCHAR(200);
  DECLARE @MARKETTYPE NVARCHAR(200);
  DECLARE @RequestType NVARCHAR(200);
  DECLARE @CUSTXML NVARCHAR(MAX);
  DECLARE @ISFIRSTIC NVARCHAR(200);
  
  SELECT @EID = ISNULL(A.EId, ''),
         @APPLICANTDEP = ISNULL(A.ApplicantDep, ''),
         @DEPID = ISNULL(A.DepId, ''),
         @SUBDEPID = ISNULL(A.SUBDEPID, ''),
         @REQUESTDATE = CONVERT(NVARCHAR(10), A.RequestDate, 121),
         @DEALERTYPE = ISNULL(A.DealerType, ''),
         @APPLICATIONID = ISNULL(A.ContractId, ''),
         @REAGIONRSM = CASE 
                            WHEN ISNULL(A.ReagionRSM, '') = '0' THEN ''
                            ELSE ISNULL(A.ReagionRSM, '')
                       END,
         @DEALERID = A.CompanyID,
         @DEALERCODE = ISNULL(A.DealerName, ''),
         @DEALERNAME = ISNULL(E.DMA_ChineseName, ''),
         @PAYTYPE = ISNULL(C.Payment, ''),
         @TOTALAMOUNTRMB = ISNULL(CONVERT(NVARCHAR(20), C.QuotaTotal), ''),
         @TOTALAMOUNTUSD = ISNULL(CONVERT(NVARCHAR(20), C.QUOTAUSD), ''),
         @ALLTOTALUSD = ISNULL(CONVERT(NVARCHAR(20), C.AllProductAopUSD), ''),
         @QUOTAUP = ISNULL(C.Quota, ''),
         @MARKETTYPE = ISNULL(A.MarketType, ''),
         @RequestType = CASE 
                             WHEN A.DealerType = 'Trade' THEN '2'
                             ELSE '1'
                        END
  FROM   [Contract].AmendmentMain A,
         [Contract].AmendmentProposals C,
         DealerMaster E
  WHERE  A.ContractId = C.ContractId
         AND A.CompanyID = E.DMA_ID
         AND A.ContractId = @ContractId;
  
  SELECT @CUSTXML = [Contract].Func_GetAmendmentHtml(@ContractId);
  
  SELECT @ISFIRSTIC = dbo.GC_Fn_IsNoFirstContract(@DEALERID, @DEPID);
  
  SET @Rtn = '';
  SET @Rtn += '<Data>';
  SET @Rtn += '<FlowId>' + dbo.Func_GetCode('CONST_CONTRACT_EwfFlowId', 'Contract_Amendment') + '</FlowId>';
  SET @Rtn += '<IgnoreAlarm>1</IgnoreAlarm>';
  SET @Rtn += '<Initiator>' + @EID + '</Initiator>';
  SET @Rtn += '<ApproveSelect/>';
  SET @Rtn += '<Principal/>';
  SET @Rtn += '<Tables>';
  SET @Rtn += '<Table Name="BIZ_DEALER_AMENDMENT_NEWMAIN">';
  SET @Rtn += '<R Index="1">';
  SET @Rtn += '<CUSTXML><![CDATA[' + @CUSTXML + ']]></CUSTXML>';
  SET @Rtn += '<DEPID><![CDATA[' + @DEPID + ']]></DEPID>';
  SET @Rtn += '<PAYTYPE><![CDATA[' + @PAYTYPE + ']]></PAYTYPE>';
  SET @Rtn += '<SUBDEPID><![CDATA[' + @SUBDEPID + ']]></SUBDEPID>';
  SET @Rtn += '<EID><![CDATA[' + @EID + ']]></EID>';
  SET @Rtn += '<APPLICANTDEP><![CDATA[]]></APPLICANTDEP>';
  SET @Rtn += '<REQUESTDATE><![CDATA[' + @REQUESTDATE + ']]></REQUESTDATE>';
  SET @Rtn += '<DEALERTYPE><![CDATA[' + @DEALERTYPE + ']]></DEALERTYPE>';
  SET @Rtn += '<APPLICATIONID><![CDATA[' + @APPLICATIONID + ']]></APPLICATIONID>';
  SET @Rtn += '<REAGIONRSM><![CDATA[' + @REAGIONRSM + ']]></REAGIONRSM>';
  SET @Rtn += '<TOTALAMOUNTRMB><![CDATA[' + @TOTALAMOUNTRMB + ']]></TOTALAMOUNTRMB>';
  SET @Rtn += '<TOTALAMOUNTUSD><![CDATA[' + @TOTALAMOUNTUSD + ']]></TOTALAMOUNTUSD>';
  SET @Rtn += '<ALLTOTALUSD><![CDATA[' + @ALLTOTALUSD + ']]></ALLTOTALUSD>';
  SET @Rtn += '<QUOTAUP><![CDATA[' + @QUOTAUP + ']]></QUOTAUP>';
  SET @Rtn += '<ISFIRSTIC><![CDATA[' + @ISFIRSTIC + ']]></ISFIRSTIC>';
  SET @Rtn += '<DEALERCODE><![CDATA[' + @DEALERCODE + ']]></DEALERCODE>';
  SET @Rtn += '<DEALERNAME><![CDATA[' + @DEALERNAME + ']]></DEALERNAME>';
  SET @Rtn += '<MARKETTYPE><![CDATA[' + @MARKETTYPE + ']]></MARKETTYPE>';
  SET @Rtn += '<RequestType><![CDATA[' + @RequestType + ']]></RequestType>';
  SET @Rtn += '</R>';
  SET @Rtn += '</Table>';
  SET @Rtn += '</Tables>';
  SET @Rtn += '</Data>'; 
  
  RETURN ISNULL(@Rtn, '')
END

GO


