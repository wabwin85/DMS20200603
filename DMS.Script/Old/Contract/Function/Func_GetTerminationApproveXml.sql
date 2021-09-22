DROP FUNCTION [Contract].[Func_GetTerminationApproveXml]
GO


CREATE FUNCTION [Contract].[Func_GetTerminationApproveXml]
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
  DECLARE @DEALERNAME NVARCHAR(200);
  DECLARE @DEALERCODE NVARCHAR(200);
  DECLARE @PAYTYPE NVARCHAR(200);
  DECLARE @TOTALAMOUNTRMB NVARCHAR(200);
  DECLARE @TOTALAMOUNTUSD NVARCHAR(200);
  DECLARE @ALLTOTALUSD NVARCHAR(200);
  DECLARE @MARKETTYPE NVARCHAR(200);
  DECLARE @RequestType NVARCHAR(200);
  
  DECLARE @COAPPROVE NVARCHAR(500);
  DECLARE @CSAPPROVE NVARCHAR(500);
  DECLARE @COIAFAPPROVE NVARCHAR(500);
  DECLARE @FINAPPROVE NVARCHAR(500);
  
  DECLARE @CUSTXML NVARCHAR(MAX);
  
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
         @DEALERCODE = ISNULL(A.DealerName, ''),
         @DEALERNAME = ISNULL(D.DMA_ChineseName, ''),
         @TOTALAMOUNTRMB = ISNULL(CONVERT(NVARCHAR(20), A.Quotatotal), ''),
         @TOTALAMOUNTUSD = ISNULL(CONVERT(NVARCHAR(20), A.QUOTAUSD), ''),
         @MARKETTYPE = ISNULL(A.MarketType, ''),
         @RequestType = CASE 
                             WHEN A.DealerType = 'Trade' THEN '2'
                             ELSE '1'
                        END
  FROM   [Contract].TerminationMain A,
         DealerMaster D
  WHERE  A.DealerName = D.DMA_SAP_Code
         AND A.ContractId = @ContractId;
  
  SET @COAPPROVE = '<a href="' + dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/PagesEwf/Contract/TerminationApprove.aspx?ContractId=' + @APPLICATIONID + '&UserRole=CO" target="_blank">页面更改链接</a>';
  SET @CSAPPROVE = '<a href="' + dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/PagesEwf/Contract/TerminationApprove.aspx?ContractId=' + @APPLICATIONID + '&UserRole=CS" target="_blank">页面更改链接</a>';
  SET @COIAFAPPROVE = '<a href="' + dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/PagesEwf/Contract/TerminationApprove.aspx?ContractId=' + @APPLICATIONID + '&UserRole=COA" target="_blank">页面更改链接</a>';
  SET @FINAPPROVE = '<a href="' + dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/PagesEwf/Contract/TerminationApprove.aspx?ContractId=' + @APPLICATIONID + '&UserRole=FIN" target="_blank">页面更改链接</a>';
  
  SELECT @CUSTXML = [Contract].Func_GetTerminationHtml(@ContractId);
  
  SET @Rtn = '';
  SET @Rtn += '<Data>';
  SET @Rtn += '<FlowId>' + dbo.Func_GetCode('CONST_CONTRACT_EwfFlowId', 'Contract_Termination') + '</FlowId>';
  SET @Rtn += '<IgnoreAlarm>1</IgnoreAlarm>';
  SET @Rtn += '<Initiator>' + @EID + '</Initiator>';
  SET @Rtn += '<ApproveSelect/>';
  SET @Rtn += '<Principal/>';
  SET @Rtn += '<Tables>';
  SET @Rtn += '<Table Name="BIZ_DEALER_END_NEWMAIN">';
  SET @Rtn += '<R Index="1">';
  SET @Rtn += '<CUSTXML><![CDATA[' + @CUSTXML + ']]></CUSTXML>';
  SET @Rtn += '<COAPPROVE><![CDATA[' + @COAPPROVE + ']]></COAPPROVE>';
  SET @Rtn += '<CSAPPROVE><![CDATA[' + @CSAPPROVE + ']]></CSAPPROVE>';
  SET @Rtn += '<FINAPPROVE><![CDATA[' + @FINAPPROVE + ']]></FINAPPROVE>';
  SET @Rtn += '<COIAFAPPROVE><![CDATA[' + @COIAFAPPROVE + ']]></COIAFAPPROVE>';
  SET @Rtn += '<DEPID><![CDATA[' + @DEPID + ']]></DEPID>';
  SET @Rtn += '<SUBDEPID><![CDATA[' + @SUBDEPID + ']]></SUBDEPID>';
  SET @Rtn += '<EID><![CDATA[' + @EID + ']]></EID>';
  SET @Rtn += '<APPLICANTDEP><![CDATA[]]></APPLICANTDEP>';
  SET @Rtn += '<REQUESTDATE><![CDATA[' + @REQUESTDATE + ']]></REQUESTDATE>';
  SET @Rtn += '<DEALERTYPE><![CDATA[' + @DEALERTYPE + ']]></DEALERTYPE>';
  SET @Rtn += '<APPLICATIONID><![CDATA[' + @APPLICATIONID + ']]></APPLICATIONID>';
  SET @Rtn += '<REAGIONRSM><![CDATA[' + @REAGIONRSM + ']]></REAGIONRSM>';
  SET @Rtn += '<TOTALAMOUNTRMB><![CDATA[' + @TOTALAMOUNTRMB + ']]></TOTALAMOUNTRMB>';
  SET @Rtn += '<TOTALAMOUNTUSD><![CDATA[' + @TOTALAMOUNTUSD + ']]></TOTALAMOUNTUSD>';
  SET @Rtn += '<DEALERNAME><![CDATA[' + @DEALERNAME + ']]></DEALERNAME>';
  SET @Rtn += '<DEALERCODE><![CDATA[' + @DEALERCODE + ']]></DEALERCODE>';
  SET @Rtn += '<MARKETTYPE><![CDATA[' + @MARKETTYPE + ']]></MARKETTYPE>';
  SET @Rtn += '<RequestType><![CDATA[' + @RequestType + ']]></RequestType>';
  SET @Rtn += '</R>';
  SET @Rtn += '</Table>';
  SET @Rtn += '</Tables>';
  SET @Rtn += '</Data>'; 
  
  RETURN ISNULL(@Rtn, '')
END

GO


