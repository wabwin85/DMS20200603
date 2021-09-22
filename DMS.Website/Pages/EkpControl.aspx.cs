using Com.Zealan.Saml;
using Com.Zealan.Saml.Assertions;
using Com.Zealan.Saml.Bindings;
using Com.Zealan.Saml.Profiles;
using Com.Zealan.Saml.Protocols;
using Common.Logging;
using DMS.Business.Contract;
using DMS.Business.EKPWorkflow;
using DMS.Common;
using DMS.Common.Common;
using DMS.Model.EKPWorkflow;
using DMS.Model.SSO;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.MobileControls.Adapters;
using System.Web.UI.WebControls;
using System.Xml;

namespace DMS.Website.Pages
{
    public partial class EkpControl : BasePage
    {
        private static ILog _log = LogManager.GetLogger(typeof(EkpControl));

        EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        private string EkpControlPageUrl()
        {
            if (Request.QueryString["formInstanceId"] == null)
                throw new Exception("无法打开页面，EKP传递的参数不正确");
            
            string formInstanceId = Request.QueryString["formInstanceId"];
            
            string RedirectUrlEkp = string.Format("~/Pages/EkpCommonPage.aspx?InstanceId={0}", formInstanceId);
            return RedirectUrlEkp;
        }

        private void ReposeToEkp(string formInstanceId, string method, string samel2token)
        {
            EkpHtmlBLL htmlBll = new EkpHtmlBLL();
            string htmlString = string.Empty;
            
            if (method.Equals("approve", StringComparison.OrdinalIgnoreCase))
            {
                htmlString = "~/Pages/EkpApprovePage.aspx?Method=approve&InstanceId=" + formInstanceId;

                Response.Redirect(htmlString);
            }
            else if (method.Equals("refuse", StringComparison.OrdinalIgnoreCase))
            {
                htmlString = "~/Pages/EkpApprovePage.aspx?Method=refuse&InstanceId=" + formInstanceId;

                Response.Redirect(htmlString);
            }
            else if (method.Equals("GetMailContent", StringComparison.OrdinalIgnoreCase))
            {
                //htmlString = htmlBll.GetDmsHtmlCommonById(formInstanceId, DmsTemplateHtmlType.Email);
                Response.Write(htmlString);
            }
        }
        
        protected override void OnLoad(EventArgs e)
        {
            _log.Info(HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"]);

            bool sso = false;

            //如果EKP传递参数中包含method=GetMailContent，则无需认证获取邮件内容
            if (Request.QueryString["method"] == "GetMailContent")
            {
                HttpContext.Current.Items["EkpMethod"] = "GetMailContent";
                Server.Transfer("~/Pages/EKPWorkflow/EkpService.aspx");
            }

            /*
            如果是微信打开页面，则需要跳转到微信服务器认证之后返回页面（带上method和saml2token参数）
            如果是PC端或者移动端打开页面，则需SSO登录
            */
            //if (HtmlHelper.IsWeChat())
            //{
            //    if (string.IsNullOrEmpty(Request.QueryString["wechattoken"]))
            //    {
            //        Response.Redirect(string.Format("http://wechat.bostonscientific.cn/WeChatPages/WorkLogon.aspx?Forward={0}&Alias={1}", HttpUtility.UrlEncode(Request.Url.ToString()), "wechattoken"));
            //    }
            //    else
            //    {
            //        if (string.IsNullOrEmpty(Request.QueryString["dmsview"]))
            //        {
            //            Response.Redirect(string.Format(EkpSetting.CONST_EKP_REDIRECT_URL,
            //                HttpUtility.UrlEncode(string.Format("{0}&dmsview=ekp", Request.Url.ToString())),
            //                HttpUtility.UrlEncode(Request.QueryString["wechattoken"])));
            //        }
            //        else
            //        {
            //            HttpContext.Current.Items["EkpMethod"] = "GetWeChatContent";
            //            Server.Transfer("~/Pages/EKPWorkflow/EkpService.aspx");
            //        }
            //    }
            //}
            //else if (HtmlHelper.IsMobile())
            //{
            //    if (string.IsNullOrEmpty(Request.QueryString["saml2token"]))
            //    {
            //        sso = true;
            //    }
            //    else
            //    {
            //        if (Request.QueryString["method"] == "Approve" || Request.QueryString["method"] == "Refuse")
            //        {
            //            HttpContext.Current.Items["EkpMethod"] = "DoMobileApproveBySaml2Token";
            //        }
            //        else
            //        {
            //            HttpContext.Current.Items["EkpMethod"] = "GetMobileContentBySaml2Token";
            //        }
            //        Server.Transfer("~/Pages/EKPWorkflow/EkpService.aspx");
            //    }
            //}
            //else
            //{
            //    sso = true;
            //}
            sso = true;
            if (sso)
            {
                string ReturnUrl = HttpUtility.UrlEncode(HttpContext.Current.Request.RawUrl);
                if (RoleModelContext.Current == null || RoleModelContext.Current.User == null || RoleModelContext.Current.User.LoginId == null)
                {
                    //TODO：待后续实现SSO接口之后，修改此处跳转的链接
                    //Response.Redirect("~/Pages/SSO/Login.aspx" + "?ReturnUrl=" + ReturnUrl);
                    Response.Redirect("~/Login.aspx" + "?ReturnUrl=" + ReturnUrl);
                }
                else
                {
                    if (HtmlHelper.IsMobile())
                    {
                        if (Request.QueryString["method"] == "Approve" || Request.QueryString["method"] == "Refuse")
                        {
                            HttpContext.Current.Items["EkpMethod"] = "DoMobileApproveBySSO";
                        }
                        else
                        {
                            HttpContext.Current.Items["EkpMethod"] = "GetMobileContentBySSO";
                        }
                        Server.Transfer("~/Pages/EKPWorkflow/EkpService.aspx");
                    }
                    else
                    {
                        if (Request.QueryString["method"] == "Approve" || Request.QueryString["method"] == "Refuse")
                        {
                            HttpContext.Current.Items["EkpMethod"] = "DoWebApprove";
                        }
                        else
                        {
                            if (string.IsNullOrEmpty(Request.QueryString["dmsview"]))
                            {
                                Response.Redirect(string.Format(EkpSetting.CONST_EKP_REDIRECT_URL,
                                    HttpUtility.UrlEncode(string.Format("{0}&dmsview=ekp", Request.Url.ToString())),
                                    HttpUtility.UrlEncode(Encryption.Encoder(RoleModelContext.Current.User.LoginId))));
                            }
                            else
                            {
                                HttpContext.Current.Items["EkpMethod"] = "GetWebContent";
                            }
                        }
                        Server.Transfer("~/Pages/EkpWorkflow/EkpService.aspx");

                    }
                }
            }
        }
    }
}