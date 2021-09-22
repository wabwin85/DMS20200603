using Common.Logging;
using DMS.Business.EKPWorkflow;
using DMS.Common.Common;
using DMS.Model.EKPWorkflow;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.EKPWorkflow
{
    public partial class EkpService : System.Web.UI.Page
    {
        private static ILog _log = LogManager.GetLogger("EkpService");
        private EkpHtmlBLL htmlBll = new EkpHtmlBLL();
        private EkpWorkflowBLL ekpBLL = new EkpWorkflowBLL();
        private FormInstanceMaster formInstance = null;
        private string method = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            method = HttpContext.Current.Items["EkpMethod"].ToString();

            _log.Info(method);

            if (Request.QueryString["processId"] == null)
                throw new Exception("无法打开页面，EKP传递的参数不正确");

            formInstance = ekpBLL.GetFormInstanceMasterProcessId(Request.QueryString["processId"]);
            //formInstance = new FormInstanceMaster();
            //formInstance.Id = Guid.NewGuid();
            //formInstance.processId = Request.QueryString["processId"];
            //formInstance.modelId = "ContractAppointment";
            //formInstance.templateFormId = "ContractAppointmentTemplate";
            //formInstance.ApplyId = new Guid("33853E92-12C3-44C4-BB1D-7E04879DA9C5");

            if (formInstance == null)
                throw new Exception("EKP获取表单数据出错");

            HttpContext.Current.Items["EkpFormInstance"] = formInstance;

            if (method == "GetWebContent")
            {
                Server.Transfer("~/Pages/EKPWorkflow/EkpCommonPage.aspx");
            }
            else if (method == "DoWebApprove")
            {
                Server.Transfer("~/Pages/EKPWorkflow/EkpApprovePage.aspx");
            }
            else if (method == "GetWeChatContent")
            {
                string userName = Encryption.Decoder(Request.QueryString["wechattoken"]);
                //Response.Write(userName);
                HttpContext.Current.Items["UserLoginId"] = userName;
                Server.Transfer("~/Pages/EKPWorkflow/EkpCommonPage.aspx");
            }
            else if (method == "GetMobileContentBySaml2Token")
            {
                string userName = Encryption.Decoder(Request.QueryString["saml2token"]);
                //Response.Write(userName);
                HttpContext.Current.Items["UserLoginId"] = userName;
                Server.Transfer("~/Pages/EKPWorkflow/EkpCommonPage.aspx");
            }
            else if (method == "DoMobileApproveBySaml2Token")
            {
                //Response.Write(Request.QueryString["saml2token"]);
                string userName = Encryption.Decoder(Request.QueryString["saml2token"]);
                //Response.Write(userName);
                HttpContext.Current.Items["UserLoginId"] = userName;
                Server.Transfer("~/Pages/EKPWorkflow/EkpApprovePage.aspx");
            }
            else if (method == "GetMobileContentBySSO")
            {
                Server.Transfer("~/Pages/EKPWorkflow/EkpCommonPage.aspx");
            }
            else if (method == "GetMailContent")
            {
                string htmlString = htmlBll.GetDmsHtmlCommonById(formInstance.ApplyId.ToString(), formInstance.modelId, formInstance.templateFormId, DmsTemplateHtmlType.Email,"");
                Response.Write(htmlString);
            }
        }
    }
}