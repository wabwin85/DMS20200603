using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using DMS.Business;

namespace DMS.Website.Pages.Promotion
{
    public partial class PromotionView : System.Web.UI.Page
    {
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["PolicyId"] != null)
                {
                    ViewPromotion(Request.QueryString["PolicyId"].ToString());
                }
            }
        }

        private void ViewPromotion(string policyId)
        {
            string htmlValue = _business.GetPolicyHtml(policyId);
            if (!String.IsNullOrEmpty(htmlValue))
            {
                this.div1.InnerHtml = htmlValue;
            }
            else 
            {
                this.div1.InnerHtml = "HTML 文件生成失败，请联系DMS管理员。";
            }
            
        }

    }
}
