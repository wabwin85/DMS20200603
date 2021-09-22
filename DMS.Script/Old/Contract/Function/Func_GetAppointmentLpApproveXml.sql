DROP FUNCTION [Contract].[Func_GetAppointmentLpApproveXml]
GO



CREATE FUNCTION [Contract].[Func_GetAppointmentLpApproveXml]
(
  @ContractId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @Rtn NVARCHAR(MAX);
  
  DECLARE @EID NVARCHAR(200);
  DECLARE @DEPID NVARCHAR(200);
  DECLARE @SUBDEPID NVARCHAR(200);
  DECLARE @REQUESTDATE NVARCHAR(200);
  DECLARE @DEALERTYPE NVARCHAR(200);
  DECLARE @APPLICATIONID NVARCHAR(200);
  DECLARE @REASON NVARCHAR(200);
  DECLARE @REAGIONRSM NVARCHAR(200);
  DECLARE @DEALERNAME NVARCHAR(200);
  DECLARE @PAYTYPE NVARCHAR(200);
  DECLARE @TOTALAMOUNTRMB NVARCHAR(200);
  DECLARE @TOTALAMOUNTUSD NVARCHAR(200);
  DECLARE @ALLTOTALUSD NVARCHAR(200);
  
  DECLARE @COAPPROVE NVARCHAR(500);
  DECLARE @CREDITAPPROVE NVARCHAR(500);
  DECLARE @COIAFAPPROVE NVARCHAR(500);
  DECLARE @FINAPPROVE NVARCHAR(500);
  
  DECLARE @CUSTXML NVARCHAR(MAX);
  
  SELECT @EID = ISNULL(A.EId, ''),
         @DEPID = ISNULL(A.DepId, ''),
         @SUBDEPID = ISNULL(A.SUBDEPID, ''),
         @REQUESTDATE = CONVERT(NVARCHAR(10), A.RequestDate, 121),
         @DEALERTYPE = ISNULL(A.DealerType, ''),
         @APPLICATIONID = ISNULL(A.ContractId, ''),
         @REASON = ISNULL(A.REASON, ''),
         @REAGIONRSM = ISNULL(A.ReagionRSM, ''),
         @DEALERNAME = ISNULL(B.CompanyName, ''),
         @PAYTYPE = ISNULL(C.Payment, ''),
         @TOTALAMOUNTRMB = ISNULL(C.QuotaTotal, ''),
         @TOTALAMOUNTUSD = ISNULL(C.QUOTAUSD, ''),
         @ALLTOTALUSD = ISNULL(C.AllProductAopUSD, '')
  FROM   [Contract].AppointmentMain A,
         [Contract].AppointmentCandidate B,
         [Contract].AppointmentProposals C
  WHERE  A.ContractId = B.ContractId
         AND A.ContractId = C.ContractId
         AND A.ContractId = @ContractId;
  
  SET @COAPPROVE = 'http://www.bokezhijia.cn/Contract/PagesEwf/Contract/AppointmentApprove.aspx?ContractId=' + @APPLICATIONID + '&UserRole=CO';
  SET @CREDITAPPROVE = 'http://www.bokezhijia.cn/Contract/PagesEwf/Contract/AppointmentApprove.aspx?ContractId=' + @APPLICATIONID + '&UserRole=CC';
  SET @COIAFAPPROVE = 'http://www.bokezhijia.cn/Contract/PagesEwf/Contract/AppointmentApprove.aspx?ContractId=' + @APPLICATIONID + '&UserRole=COA';
  SET @FINAPPROVE = 'http://www.bokezhijia.cn/Contract/PagesEwf/Contract/AppointmentApprove.aspx?ContractId=' + @APPLICATIONID + '&UserRole=FIN';
  
  SELECT @CUSTXML = [Contract].Func_GetAppointmentHtml(@ContractId);
  
  SET @Rtn = '';
  SET @Rtn += '<Data>';
  SET @Rtn += '<FlowId>1274</FlowId>';
  SET @Rtn += '<IgnoreAlarm>1</IgnoreAlarm>';
  SET @Rtn += '<Initiator>' + @EID + '</Initiator>';
  SET @Rtn += '<ApproveSelect/>';
  SET @Rtn += '<Principal/>';
  SET @Rtn += '<Tables>';
  SET @Rtn += '<Table Name="BIZ_DEALER_NEW_NEWMAIN">';
  SET @Rtn += '<R Index="1">';
  SET @Rtn += '<CUSTXML><![CDATA[' + @CUSTXML + ']]></CUSTXML>';
  SET @Rtn += '<SAPCODE><![CDATA[]]></SAPCODE>';
  SET @Rtn += '<COAPPROVE><![CDATA[' + @COAPPROVE + ']]></COAPPROVE>';
  SET @Rtn += '<CREDITAPPROVE><![CDATA[' + @CREDITAPPROVE + ']]></CREDITAPPROVE>';
  SET @Rtn += '<COIAFAPPROVE><![CDATA[' + @COIAFAPPROVE + ']]></COIAFAPPROVE>';
  SET @Rtn += '<FINAPPROVE><![CDATA[' + @FINAPPROVE + ']]></FINAPPROVE>';
  SET @Rtn += '<DEPID><![CDATA[' + @DEPID + ']]></DEPID>';
  SET @Rtn += '<PAYTYPE><![CDATA[' + @PAYTYPE + ']]></PAYTYPE>';
  SET @Rtn += '<SUBDEPID><![CDATA[' + @SUBDEPID + ']]></SUBDEPID>';
  SET @Rtn += '<EID><![CDATA[' + @EID + ']]></EID>';
  SET @Rtn += '<APPLICANTDEP><![CDATA[]]></APPLICANTDEP>';
  SET @Rtn += '<REQUESTDATE><![CDATA[' + @REQUESTDATE + ']]></REQUESTDATE>';
  SET @Rtn += '<DEALERTYPE><![CDATA[' + @DEALERTYPE + ']]></DEALERTYPE>';
  SET @Rtn += '<APPLICATIONID><![CDATA[' + @APPLICATIONID + ']]></APPLICATIONID>';
  SET @Rtn += '<REASON><![CDATA[' + @REASON + ']]></REASON>';
  SET @Rtn += '<REAGIONRSM><![CDATA[' + @REAGIONRSM + ']]></REAGIONRSM>';
  SET @Rtn += '<TOTALAMOUNTRMB><![CDATA[' + @TOTALAMOUNTRMB + ']]></TOTALAMOUNTRMB>';
  SET @Rtn += '<TOTALAMOUNTUSD><![CDATA[' + @TOTALAMOUNTUSD + ']]></TOTALAMOUNTUSD>';
  SET @Rtn += '<ALLTOTALUSD><![CDATA[' + @ALLTOTALUSD + ']]></ALLTOTALUSD>';
  SET @Rtn += '<DEALERNAME><![CDATA[' + @DEALERNAME + ']]></DEALERNAME>';
  SET @Rtn += '</R>';
  SET @Rtn += '</Table>';
  SET @Rtn += '</Tables>';
  SET @Rtn += '</Data>'; 
  
  RETURN ISNULL(@Rtn, '')
END

GO


