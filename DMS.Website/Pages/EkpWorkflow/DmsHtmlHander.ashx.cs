using Common.Logging;
using DMS.Business.EKPWorkflow;
using DMS.Common;
using DMS.Common.Common;
using DMS.Model.EKPWorkflow;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Xml;
using System.Xml.Serialization;

namespace DMS.Website.Pages.EKPWorkflow
{
    /// <summary>
    /// DmsHtmlHander 的摘要说明
    /// </summary>
    public class DmsHtmlHander : IHttpHandler
    {
        private static ILog _log = LogManager.GetLogger(typeof(DmsHtmlHander));
        public void ProcessRequest(HttpContext context)
        {
            EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
            DmsHtmlData htmlData = new DmsHtmlData();
            EkpHtmlBLL htmlBll = new EkpHtmlBLL();
            string htmlString = string.Empty;
            try
            {
                _log.Info("DmsHtmlHander start.............");
                context.Response.ClearContent();
                context.Response.ContentType = "text/plain";
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache); //无缓存

                byte[] byts = new byte[context.Request.InputStream.Length];
                context.Request.InputStream.Read(byts, 0, byts.Length);
                string data = Encoding.GetEncoding("utf-8").GetString(byts);

                htmlData = JsonHelper.Deserialize<DmsHtmlData>(data);
                string userLoginId = Encryption.Decoder(htmlData.User);

                if (htmlData.MethodName.Equals("GetHtml", StringComparison.OrdinalIgnoreCase))
                {
                    //htmlData.IsSuccess = ekpBll.ValidateUserCanReadEkpProcess(htmlData.Id, userLoginId);
                    htmlData.IsSuccess = true;
                    if (htmlData.IsSuccess)
                    {
                        //获取Html Temp文件名
                        kmReviewExtendWeserviceBLL krw = new kmReviewExtendWeserviceBLL();
                        htmlData.OptionList = krw.GetOperationList(userLoginId, htmlData.Id);

                        string strHtml = "";
                        XmlDocument xd = new XmlDocument();
                        using (StringWriter sw = new StringWriter())
                        {
                            XmlSerializer xz = new XmlSerializer(htmlData.OptionList.GetType());
                            xz.Serialize(sw, htmlData.OptionList);
                            xd.LoadXml(sw.ToString());
                            strHtml = xd.InnerXml;
                        }

                        htmlString = htmlBll.GetDmsHtmlCommonById(htmlData.Id, htmlData.modelId, htmlData.templateFormId, DmsTemplateHtmlType.Normal, strHtml);
                        htmlData.HtmlString = htmlString;
                        htmlData.EkpIframeUrl = ekpBll.GetEkpHistoryLogByInstanceId(htmlData.Id, userLoginId);
                    }
                    else
                    {
                        htmlData.ExecuteMessage = "没有查看申请单的权限！";
                    }
                }
                else if (htmlData.MethodName.Equals("DoApprove", StringComparison.OrdinalIgnoreCase))//通过
                {
                    kmReviewWebserviceBLL krw = new kmReviewWebserviceBLL();
                    string fdTemplateFormId = DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "ApointmentLP");
                    krw.DoAgree(userLoginId, htmlData.Id, htmlData.Remark);
                    htmlData.HtmlString = htmlString;
                    htmlData.EkpIframeUrl = ekpBll.GetEkpHistoryLogByInstanceId(htmlData.Id, userLoginId);
                    htmlData.IsSuccess = true;
                }
                else if (htmlData.MethodName.Equals("DoRefuse", StringComparison.OrdinalIgnoreCase))//驳回
                {
                    //ekpBll.DoReject(userLoginId, htmlData.Id, htmlData.Remark);
                    kmReviewWebserviceBLL krw = new kmReviewWebserviceBLL();
                    string fdTemplateFormId = DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "ApointmentLP");
                    krw.DoReject(userLoginId, htmlData.Id, htmlData.Remark);
                    htmlData.HtmlString = htmlString;
                    htmlData.EkpIframeUrl = ekpBll.GetEkpHistoryLogByInstanceId(htmlData.Id, userLoginId);
                    htmlData.IsSuccess = true;
                }
                else if (htmlData.MethodName.Equals("DoPress", StringComparison.OrdinalIgnoreCase))//催办
                {
                    ekpBll.DoPress(userLoginId, htmlData.Id, htmlData.Remark);
                    htmlData.HtmlString = htmlString;
                    htmlData.EkpIframeUrl = ekpBll.GetEkpHistoryLogByInstanceId(htmlData.Id, userLoginId);
                    htmlData.IsSuccess = true;
                }
                else if (htmlData.MethodName.Equals("DoAbandon", StringComparison.OrdinalIgnoreCase))//撤销
                {
                    ekpBll.DoAbandon(userLoginId, htmlData.Id, htmlData.Remark);
                    htmlData.HtmlString = htmlString;
                    htmlData.EkpIframeUrl = ekpBll.GetEkpHistoryLogByInstanceId(htmlData.Id, userLoginId);
                    htmlData.IsSuccess = true;
                }
                else if (htmlData.MethodName.Equals("DoAbandonByHandler", StringComparison.OrdinalIgnoreCase))//审批人废弃申请单
                {
                    ekpBll.DoAbandonByHandler(userLoginId, htmlData.Id, htmlData.Remark);
                    htmlData.HtmlString = htmlString;
                    htmlData.EkpIframeUrl = ekpBll.GetEkpHistoryLogByInstanceId(htmlData.Id, userLoginId);
                    htmlData.IsSuccess = true;
                }
                else if (htmlData.MethodName.Equals("DoAdditionSignYHU", StringComparison.OrdinalIgnoreCase))//加签
                {
                    ekpBll.DoAdditionSign(userLoginId, htmlData.Id, htmlData.Remark, "yhu");
                    htmlData.HtmlString = htmlString;
                    htmlData.EkpIframeUrl = ekpBll.GetEkpHistoryLogByInstanceId(htmlData.Id, userLoginId);
                    htmlData.IsSuccess = true;
                }
                else if (htmlData.MethodName.Equals("DoAdditionSignYSONG", StringComparison.OrdinalIgnoreCase))//加签
                {
                    ekpBll.DoAdditionSign(userLoginId, htmlData.Id, htmlData.Remark, "ysong");
                    htmlData.HtmlString = htmlString;
                    htmlData.EkpIframeUrl = ekpBll.GetEkpHistoryLogByInstanceId(htmlData.Id, userLoginId);
                    htmlData.IsSuccess = true;
                }
                else if (htmlData.MethodName.Equals("DoEdit", StringComparison.OrdinalIgnoreCase))//编辑
                {
                    if (htmlData.modelId == EkpModelId.ContractAppointment.ToString())
                    {
                        htmlData.RedirectUrl = string.Format("http://" + HttpContext.Current.Request.Url.Host + "/Contract/PagesEkp/Contract/AppointmentApprove.aspx?ContractId={0}", htmlData.Id);
                        htmlData.IsSuccess = true;
                    }
                    else if (htmlData.modelId == EkpModelId.ContractAmendment.ToString())
                    {
                        htmlData.RedirectUrl = string.Format("http://" + HttpContext.Current.Request.Url.Host + "/Contract/PagesEkp/Contract/AmendmentApprove.aspx?ContractId={0}", htmlData.Id);
                        htmlData.IsSuccess = true;
                    }
                    else if (htmlData.modelId == EkpModelId.ContractRenewal.ToString())
                    {
                        htmlData.RedirectUrl = string.Format("http://" + HttpContext.Current.Request.Url.Host + "/Contract/PagesEkp/Contract/RenewalApprove.aspx?ContractId={0}", htmlData.Id);
                        htmlData.IsSuccess = true;
                    }
                    else if (htmlData.modelId == EkpModelId.ContractTermination.ToString())
                    {
                        htmlData.RedirectUrl = string.Format("http://" + HttpContext.Current.Request.Url.Host + "/Contract/PagesEkp/Contract/TerminationApprove.aspx?ContractId={0}", htmlData.Id);
                        htmlData.IsSuccess = true;
                    }
                    else if (htmlData.modelId == EkpModelId.DealerReturn.ToString())
                    {
                        htmlData.RedirectUrl = string.Format("http://" + HttpContext.Current.Request.Url.Host + "/PagesKendo/InventoryReturn/InventoryReturnBsc.aspx?formInstanceId={0}", htmlData.Id);
                        htmlData.IsSuccess = true;
                    }
                    else if (htmlData.modelId == EkpModelId.DealerComplain.ToString())  
                    {
                        htmlData.RedirectUrl = string.Format("{0}://{1}/PagesKendo/InventoryReturn/DealerComplainBsc.aspx?formInstanceId={2}"
                            , HttpContext.Current.Request.Url.Scheme
                            , HttpContext.Current.Request.Url.Authority
                            , htmlData.Id);
                        htmlData.IsSuccess = true;
                    }
                    else
                    {
                        throw new Exception("Unknown edit model type('" + htmlData.modelId + "').");
                    }
                }
            }
            catch (Exception ex)
            {
                htmlData.IsSuccess = false;
                htmlData.ExecuteMessage = ex.Message.ToString();
                _log.Error(ex.ToString());
            }
            context.Response.Write(JsonHelper.Serialize(htmlData));
        }


        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }

    public class DmsHtmlData
    {
        public string Id;
        public string User;
        public string modelId;
        public string templateFormId;
        public string MethodName;
        public string Remark;
        public bool IsSuccess;
        public string HtmlString;
        public string EkpIframeUrl;
        public string ExecuteMessage;
        public List<EkpOperation> OptionList;
        public string RedirectUrl;
    }
}