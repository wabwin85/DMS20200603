using DMS.Business.EKPWorkflow;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.EKPWorkflow
{
    public partial class EkpApprovePage : System.Web.UI.Page
    {
        EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
        kmReviewWebserviceBLL krw = new kmReviewWebserviceBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["method"] != null && Request.QueryString["formInstanceId"] != null)
            {
                DoApprove(Request.QueryString["method"], Request.QueryString["formInstanceId"]);
            }
            else
            {
                this.lbRemark.Text = "参数错误";
            }
        }

        private void DoApprove(string method, string instancdId)
        {
            string loginId;
            if (HttpContext.Current.Items["UserLoginId"] != null)
            {
                loginId = HttpContext.Current.Items["UserLoginId"].ToString();
            }
            else
            {
                loginId = RoleModelContext.Current.User.LoginId;
            }

            if (method == "Approve")
            {
                try
                {
                    krw.DoAgree(loginId, instancdId, "");
                    this.lbRemark.Text = "执行通过成功！";
                }
                catch (Exception ex)
                {
                    this.lbRemark.Text = ex.Message;
                }
            }
            else if (method == "Refuse")
            {
                try
                {
                    krw.DoReject(loginId, instancdId, "");
                    this.lbRemark.Text = "执行驳回成功！";
                }
                catch (Exception ex)
                {
                    this.lbRemark.Text = ex.Message;
                }
            }
            else
            {
                this.lbRemark.Text = "操作类型不存在！";
            }
        }
    }
}