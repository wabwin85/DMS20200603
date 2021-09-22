using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Common.Common
{
   public class ContractTemplate
    {
        public static string CreditPaymentCn2 = "只要经销商的信用保持良好、对BSC的付款准时，"
        + "并且经销商对BSC应付的总金额限制在由BSC不定期地确定的信用限额范围内，产品的付款就在BSC SAP系统发票日后"
        + "{#PaymentDays}天内到期应付。自本协议生效，并且BSC收到经销商银行保函之日起，经销商的信用限额为人民币"
         + "{#Rmb1#}元（含增值税）。经销商应提供金额为人民币{#Rmb2#}元的银行保函以及人民币{#Rmb3#}的母公"
        + "司保函作为安全保证。实际信用额度以BSC财务部收到的有效保函为准。"
        + "由于经销商提供的保函期限和合同到期日有差别，经销商需要在原保函到期日前提"
        + "供新的保函，来保证其对于保函项下额度的担保。否则，BSC有权降低经销商相应的额度。"
        + "根据调整后的额度，经销商则需要支付所有超过额度的款项。由此产生的损失由经销商承担。"
        + "BSC有权要求经销商为该信用限额提供充分担保，作为使用记账方式进行销售的条件。"
        + "BSC有权不定期地调整经销商的支付条款及信用限额。同时，BSC延续对经销商的采购价格提高0.25 %。"
        + "价格提高后产生的与原采购价之间的差额金额将通过在经销商季度返利金额中扣除的方式执行。"
        + "即每个自然季度结算一次今个，并在经销商当季度可领取的返利金额中直接扣除。"
        + "若经销商当季度无返利或返利金额小于差价金额，则在之后有返利的季度中继续扣除，"
        + "直至差价金额完全扣除完毕。销售指标，返利，退换货额度，以及退货金额等，保持原有政策，计算方法以及金额都保持不变。";
        public static string CreditPaymentEn2= "Payment for Products is due within {#PaymentDays} days after date of BSC SAP system invoice on open account as long as DISTRIBUTOR’s credit remains good, payments to BSC are made on time, and the total amount owed by DISTRIBUTOR to BSC is within the"
       + " credit limits determined by BSC from time to time.DISTRIBUTOR’s credit limit as of the effective date of this Agreement and starting from the recipient date of DISTRIBUTOR’s guarantee shall be RMB {#Rmb1#} (include VAT)."
       +"DISTRIBUTOR shall secure open account payment terms with a security deposit of RMB {#Rmb2#} bank guarantee" 
       +" and RMB {#Rmb3#} parent company guarantee. Actual credit limit will be adjusted based on receipt guarantees "
       +"amount.For the guarantee period is different from the contract, DISTRIBUTOR need to provide renew guarantees"
       +"  to BSC to make sure their credit limit is fully covered. Otherwise BSC had the right to reduce relative"
       +" credit.And DISTRIBUTOR should support to pay all the value exceed the adjusted credit limit." 
       +"   BSC reserves the right to require DISTRIBUTOR to provide additional security for the amount of"
       +"  such credit limit as a condition to making sales on open account terms.BSC shall have the"
       +"    right to adjust DISTRIBUTOR’s payment terms and credit limits from time to time. BSC shall"
       +"    increase DISTRIBUTOR’s purchase price by 0.25%. The amount caused by the price gap between"
       +"     the original purchase price and increased price shall be calculated on quarterly basis and"
       +"    deducted in DISTRIBUTOR’s receivable rebate amount in the quarter. Inthe circumstance that"
       +"   DISTRIBUTOR does not have receivable rebate in the quarter or the receivable rebate is less"
       +"   than the amount, the amount shall be deducted in following quarters until it is completely"
       +"   settled. The sales quota, rebate, return goods limit, and return product price and others will"
       +"  not be impacted, and need keep same as original policy, calculation method and amount.";
        public static string CreditPaymentCnv1 = "只要经销商的信用保持良好、对BSC的付款准时，并且经销商对BSC应付的总金额限制在由BSC不定期地确定的信用限额范围内，产品的付款就在BSC SAP系统发票日后{#PaymentDays}天内到期应付。自本协议生效，并且BSC收到经销商银行保函之日起，经销商的信用限额为人民币{#Rmb1#}元（含增值税）。经销商应提供金额为人民币{#Rmb2#}元的银行保函以及人民币{#Rmb3#}的母公司保函作为安全保证。实际信用额度以BSC财务部收到的有效保函为准。由于经销商提供的保函期限和合同到期日有差别，经销商需要在原保函到期日前提供新的保函，来保证其对于保函项下额度的担保。否则，BSC有权降低经销商相应的额度。根据调整后的额度，经销商则需要支付所有超过额度的款项。由此产生的损失由经销商承担。BSC有权要求经销商为该信用限额提供充分担保，作为使用记账方式进行销售的条件。BSC有权不定期地调整经销商的支付条款及信用限额。";
        public static string CreditPaymentCnv2 = "只要经销商的信用保持良好、对BSC的付款准时，并且经销商对BSC应付的总金额限制在由BSC不定期地确定的信用限额范围内，产品的付款就在BSC SAP系统发票日后{#PaymentDays}天内到期应付。自本协议生效，并且BSC收到经销商银行保函之日起，经销商的信用限额为人民币{#Rmb1#}元（含增值税）。经销商应提供金额为人民币{#Rmb2#}元的银行保函。实际信用额度以BSC财务部收到的有效保函为准。由于经销商提供的保函期限和合同到期日有差别，经销商需要在原保函到期日前提供新的保函，来保证其对于保函项下额度的担保。否则，BSC有权降低经销商相应的额度。根据调整后的额度，经销商则需要支付所有超过额度的款项。由此产生的损失由经销商承担。BSC有权要求经销商为该信用限额提供充分担保，作为使用记账方式进行销售的条件。BSC有权不定期地调整经销商的支付条款及信用限额。";

        public static string CreditPaymentEnv1 = "Payment for Products is due within {#PaymentDays} days after date of BSC SAP system invoice on open account as long as DISTRIBUTOR’s credit remains good, payments to BSC are made on time, and the total amount owed by DISTRIBUTOR to BSC is within the credit limits determined by BSC from time to time. DISTRIBUTOR’s credit limit as of the effective date of this Agreement and starting from the recipient date of DISTRIBUTOR’s guarantee shall be RMB {#Rmb1#} (include VAT). DISTRIBUTOR shall secure open account payment terms with a security deposit of RMB {#Rmb2#} bank guarantee and RMB{#Rmb3#} parent company guarantee. Actual credit limit will be adjusted based on receipt guarantees amount. For the guarantee period is different from the contract, DISTRIBUTOR need to provide renew guarantees to BSC to make sure their credit limit is fully covered. Otherwise BSC had the right to reduce relative credit. And DISTRIBUTOR should support to pay all the value exceed the adjusted credit limit. BSC reserves the right to require DISTRIBUTOR to provide additional security for the amount of such credit limit as a condition to making sales on open account terms. BSC shall have the right to adjust DISTRIBUTOR’s payment terms and credit limits from time to time.";
        public static string CreditPaymentEnv2 = "Payment for Products is due within {#PaymentDays} days after date of BSC SAP system invoice on open account as long as DISTRIBUTOR’s credit remains good, payments to BSC are made on time, and the total amount owed by DISTRIBUTOR to BSC is within the credit limits determined by BSC from time to time. DISTRIBUTOR’s credit limit as of the effective date of this Agreement and starting from the recipient date of DISTRIBUTOR’s guarantee shall be RMB {#Rmb1#} (include VAT). DISTRIBUTOR shall secure open account payment terms with a security deposit of RMB {#Rmb2#} bank guarantee. Actual credit limit will be adjusted based on receipt guarantees amount. For the guarantee period is different from the contract, DISTRIBUTOR need to provide renew guarantees to BSC to make sure their credit limit is fully covered. Otherwise BSC had the right to reduce relative credit. And DISTRIBUTOR should support to pay all the value exceed the adjusted credit limit. BSC reserves the right to require DISTRIBUTOR to provide additional security for the amount of such credit limit as a condition to making sales on open account terms. BSC shall have the right to adjust DISTRIBUTOR’s payment terms and credit limits from time to time.";
        public static string CodPaymentCn = "现金预付款购货";
        public static string CodPaymentEn = "Payment for Products shall be prepaid by cash in advance";
        public static string ExpPDfPath = "ExportedPdf/";
        public static string ExpPDfPreview = "/resources/images/preview.png";
        public static string HtmlTempale = "<!DOCTYPE html><html><head></head><body><div>{0}</div></body></html>";
        public static string TerminationTextEn = "Please note that any accounts payable owed to BSC as of the expiration of the Agreement shall be due and payable on {#AgreementEndDateEn} in accordance with paragraph 6.3 of the Agreement. ";
        public static string TerminationTextCn = "请注意，根据该协议第6.3节的规定，所有在该协议到期之前仍未向BSCMT支付的款项，必须在{#AgreementEndDateCn}之前或当日支付。";



        public static string AmendmentHtml1= "<table style=\"width:100%;\">"
            +"<tr>"
             + "<td style=\"width:50%\" valign=\"top\"><u style =\" font-weight:bold; \" >{#Linbr#}. Products-Schedule B.</u>Pursuant to Section 1.1 of the Agreement, effective {#AgreementStartDateEn1#} Schedule B of the Agreement is hereby amended to read as follows;</td>"
             + "<td style=\"width:50%\" valign=\"top\"><u style = \"font-weight:bold;\" > {#Linbr#}. 产品 - B部分 </u> 根据该协议第1.1节规定，该协议B部分内容修改如下，并于{#AgreementStartDate1#}开始生效</td>"
            + "</tr>"
            +"<tr>"
             + "<td style=\"width:50%\" valign=\"top\">{#DeptNameEn#}</td>"
             + "<td style=\"width:50%\" valign=\"top\">{#DeptName#}</td>"
            + "</tr>"
        +"</table>";

            
        public static string AmendmentHtml2 = "<table style=\"width:100%;\">"
            + "<tr>"
             + "<td style=\"width:50%\" valign=\"top\"><u style =\" font-weight:bold; \" >{#Linbr#}. Prices–Schedule B.</u>Pursuant to Section 2.4.1 of the Agreement, effective {#AgreementStartDateYMDEn1#} the pricing of {#DeptNameEn1#} shall be hereby amended to read as follows</td>"
             + "<td style=\"width:50%\" valign=\"top\"><u style = \"font-weight:bold;\" > {#Linbr#}. 价格-B部分. </u > 根据该协议第2.4.1节规定，{#DeptName1#}的产品定价事项修改如下，并于{#AgreementStartDateYMD1#}开始生效</td>"
            + "</tr>"
            +"<tr>"
             + "<td style=\"width:50%\" valign=\"top\">Distributor Price in DMS</td>"
             + "<td style=\"width:50%\" valign=\"top\">见DMS系统中经销商价格</td>"
            + "</tr>"
        +"</table>";


        public static string AmendmentHtml3 = "<table style=\"width:100%;\">"
            + "<tr>"
             + "<td style=\"width:50%\" valign=\"top\"><u style=\" font-weight:bold;\">{#Linbr#}. Territory–Schedule C.</u>Effective {#AgreementStartDateYMDEn2#}, the authorized Territory of {#DeptNameEn2#} under the Agreement shall be hereby amended to read as follows:</td>"
             + "<td style=\"width:50%\" valign=\"top\"><u style=\" font-weight:bold;\">{#Linbr#}. 销售区域–C部分. </u >该协议中有关授权{#DeptName2#}的销售区域的内容将修改如下，并于{#AgreementStartDateYMD2#}开始生效：</td>"
            + "</tr>"
            + "<tr>"
             + "<td style=\"width:50%\" valign=\"top\">See attachment “Authorized Regions/Hospitals </td>"
             + "<td style=\"width:50%\" valign=\"top\">见附件“授权清单”</td>"
            + "</tr>"
        + "</table>";


        public static string AmendmentHtml4 = "<table style=\"width:100%;\">"
           + "<tr>"
            + "<td style=\"width:50%\" valign=\"top\"><u style=\" font-weight:bold;\">{#Linbr#}. Minimum Purchase Quotas – Schedule D. </u >Pursuant to Section 2.1.1, effective ：{#AgreementStartDateYMDEn3#}, the quarterly minimum purchase quotas of {#DeptNameEn3#} contained in Schedule shall be hereby amended as follows: (see attachment ‘Quota Form’)</td>"
            + "<td style=\"width:50%\" valign=\"top\"><u style=\" font-weight:bold;\">{#Linbr#}. 最低采购额度–D部分. </u >根据该协议第2.1.1节规定，该部分中规定的{#DeptName3#}的每季度最低采购额度将修改如下，并于{#AgreementStartDateYMD3#}开始生效：（见附件“指标清单”）</td>"
           + "</tr>"
           + "<tr>"
            + "<td style=\"width:50%\" valign=\"top\"> Quotas listed above are the net sales CNY value and exclude Value Added Tax (VAT).Or include Value Added Tax (VAT), (see attachment ‘Quota Form’) </td>"
            + "<td style=\"width:50%\" valign=\"top\">上述购买额为净采购人民币金额且不含增值税。或含增值税，（见附件“指标清单”）</td>"
           + "</tr>"
       + "</table>";

        public static string AmendmentHtml5 = "<table style=\"width:100%;\">"
       + "<tr>"
        + "<td style=\"width:50%\" valign=\"top\"><u style=\" font-weight:bold;\">{#Linbr#}. Payment Terms – Schedule E. </u > Effective {#AgreementStartDateYMDEn4#}, the payment terms of {#DeptNameEn4#} contained in Schedule E shall be hereby amended to:</td>"
        + "<td style=\"width:50%\" valign=\"top\"><u style=\" font-weight:bold;\">{#Linbr#}. 支付条款–E部分. E </u >部分中规定的{#DeptName4#}的支付条款将修改如下，并于{#AgreementStartDateYMD4#}开始生效：</td>"
       + "</tr>"
       + "<tr>"
        + "<td style=\"width:50%\" valign=\"top\"> {#PaymentEn#}</td>"
        + "<td style=\"width:50%\" valign=\"top\">{#PaymentCn#}</td>"
       + "</tr>"
   + "</table>";
    }
}

