using DMS.Business.Promotion;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.PagesKendo.Promotion
{
    public partial class PolicyTemplateInit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            PolicyTemplateInitService service = new PolicyTemplateInitService();
            String policyId = service.Init(Request.QueryString["TemplateId"]);
            String pageType = Request.QueryString["PageType"];
            String showPreview = Request.QueryString["ShowPreview"];

            Response.Redirect("PolicyTemplate.aspx?PolicyId=" + policyId + "&PageType=" + pageType + "&ShowPreview=" + showPreview, false);
        }
    }
}