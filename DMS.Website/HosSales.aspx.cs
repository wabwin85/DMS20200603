using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using System.Web.Security;
using DMS.Business.DataInterface;
using System.Data;
using System.Text;

namespace DMS.Website
{
    public partial class HosSales : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (this.Request.QueryString["id"] != null)
                {
                    this.hfBarch.Value = this.Request.QueryString["id"];
                    BindPageHtml();
                }
            }
        }

        /*
        private void BindPageHtml()
        {
            StringBuilder HtmlString = new StringBuilder();
            SalesBLL business = new SalesBLL();
            DataTable dtRsl = business.SelectHospitalSalesByBatchNbr(this.hfBarch.Value).Tables[0];
            if (dtRsl.Rows.Count > 0)
            {
                HtmlString.Append("      <br/>");
                HtmlString.Append("<b>" + dtRsl.Rows[0]["HospiatlName"].ToString() + "当前已产生以下销量：</b><br/><br/>");
                HtmlString.Append("<TABLE style=\"BACKGROUND: #ccccff; border:1px solid\" cellSpacing=\"3\" cellPadding=\"0\">");
                HtmlString.Append("<TBODY>");
                //表头
                HtmlString.Append("<TR>");
                HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">上报人</SPAN></STRONG>");
                HtmlString.Append("</TD>");
                HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">产品</SPAN></STRONG>");
                HtmlString.Append("</TD>");
                HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">数量</SPAN></STRONG>");
                HtmlString.Append("</TD>");
                HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">批次</SPAN></STRONG>");
                HtmlString.Append("</TD>");
                HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">有效期</SPAN></STRONG>");
                HtmlString.Append("</TD>");
                HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">用量时间</SPAN></STRONG>");
                HtmlString.Append("</TD>");
                HtmlString.Append("</TR>");
                foreach (DataRow row in dtRsl.Rows)
                {
                    HtmlString.Append("<TR>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    HtmlString.Append(row["SubUser"].ToString());
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    HtmlString.Append(row["ProductName"].ToString());
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    HtmlString.Append(Convert.ToDecimal(row["Qty"].ToString()).ToString("f0"));
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    HtmlString.Append(row["LotNumber"].ToString());
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    HtmlString.Append(row["ExpiredDate"].ToString());
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    HtmlString.Append(row["CreatDate"].ToString());
                    HtmlString.Append("</TD>");
                    HtmlString.Append("</TR>");

                }
                HtmlString.Append("</TBODY>");
                HtmlString.Append("</TABLE>");

                this.spSales.InnerHtml = HtmlString.ToString();
            }

        }
        */

        private void BindPageHtml()
        {
            StringBuilder HtmlString = new StringBuilder();
            SalesBLL business = new SalesBLL();
            DataTable dtRsl = business.SelectHospitalSalesByBatchNbr(this.hfBarch.Value).Tables[0];
            if (dtRsl.Rows.Count > 0)
            {
                HtmlString.Append("      <br/>");
                HtmlString.Append("<b>" + dtRsl.Rows[0]["HospiatlName"].ToString() + "当前已产生以下销量：</b><br/><br/>");
                HtmlString.Append("<TABLE style=\"BACKGROUND: #ccccff; border:1px\" cellSpacing=\"3\" cellPadding=\"0\" >");
                HtmlString.Append("<TBODY>");
                //表头
                foreach (DataRow row in dtRsl.Rows)
                {
                    HtmlString.Append("<TR>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt; width:20%; \">");
                    HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">上报人</SPAN></STRONG>");
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\" colspan=\"3\">");
                    HtmlString.Append(row["SubUser"].ToString());
                    HtmlString.Append("</TD>");
                    HtmlString.Append("</TR>");

                    HtmlString.Append("<TR>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt; width:20%; \">");
                    HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">产品</SPAN></STRONG>");
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\" colspan=\"3\">");
                    HtmlString.Append(row["ProductName"].ToString());
                    HtmlString.Append("</TD>");
                    HtmlString.Append("</TR>");

                    HtmlString.Append("<TR>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt; width:20%; \">");
                    HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">数量</SPAN></STRONG>");
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt; width:30%; \">");
                    HtmlString.Append(row["Qty"].ToString());
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt; width:20%; \">");
                    HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">批次</SPAN></STRONG>");
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt; width:30%; \">");
                    HtmlString.Append(row["LotNumber"].ToString());
                    HtmlString.Append("</TD>");
                    HtmlString.Append("</TR>");

                    HtmlString.Append("<TR>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">有效期</SPAN></STRONG>");
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt; font-size:small;\">");
                    HtmlString.Append(row["ExpiredDate"].ToString());
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                    HtmlString.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">用量时间</SPAN></STRONG>");
                    HtmlString.Append("</TD>");
                    HtmlString.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt; font-size:small;\">");
                    HtmlString.Append(row["ScanDate"].ToString());
                    HtmlString.Append("</TD>");
                    HtmlString.Append("</TR>");
                 
                }
                HtmlString.Append("</TBODY>");
                HtmlString.Append("</TABLE>");

                this.spSales.InnerHtml = HtmlString.ToString();
            }

        }
    }
}
