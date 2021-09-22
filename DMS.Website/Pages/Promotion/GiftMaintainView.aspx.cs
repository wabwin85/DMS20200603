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
    public partial class GiftMaintainView : System.Web.UI.Page
    {
        private IGiftMaintainBLL _business = new GiftMaintainBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["FlowId"] != null && Request.QueryString["FlowType"] != null)
                {
                    //非促销政策结算HTML查看
                    if (Request.QueryString["FlowType"].ToString().Equals("InsertGift"))
                    {
                        BindGiftNoPolicy(Request.QueryString["FlowId"].ToString());
                    }
                }
                else if (Request.QueryString["FlowId"] != null)
                {
                    //促销政策赠送结算HTML查看
                    ViewGift(Request.QueryString["FlowId"].ToString());
                }
             
            }
        }

        private void ViewGift(string flowId)
        {
            string htmlValue = _business.GetProGiftHtml(flowId);
            if (!String.IsNullOrEmpty(htmlValue))
            {
                this.div1.InnerHtml = htmlValue;
            }
            else
            {
                this.div1.InnerHtml = "HTML 文件生成失败，请联系DMS管理员。";
            }

        }

        private void BindGiftNoPolicy(string flowId)
        {
            this.div1.InnerHtml = "HTML 文件生成失败，请联系DMS管理员。";
            DataTable PointsHrader = _business.GetInitialPoints(flowId).Tables[0];
            if (PointsHrader.Rows.Count > 0)
            {
                if (PointsHrader.Rows[0]["HtmlStr"] != null && !PointsHrader.Rows[0]["HtmlStr"].ToString().Equals(""))
                {
                    this.div1.InnerHtml = PointsHrader.Rows[0]["HtmlStr"].ToString();
                }
            }
            
        }

    }
}
