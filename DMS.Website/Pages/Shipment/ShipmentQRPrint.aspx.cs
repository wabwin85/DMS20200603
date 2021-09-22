using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Shipment
{
    public partial class ShipmentQRPrint : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["ChineseName"] == null || Request.QueryString["EnglishName"] == null
                    || Request.QueryString["LotNumber"] == null || Request.QueryString["SerialNumbe"] == null
                    || Request.QueryString["QrPath"] == null)
                    Response.Redirect("ShipmentQRCode.aspx");
                else
                {
                    this.lbChineseName.Text = Request.QueryString["ChineseName"].ToString();
                    this.lbEnglishName.Text = Request.QueryString["EnglishName"].ToString();
                    this.lbLotNumber.Text = Request.QueryString["LotNumber"].ToString();
                    this.lbSerialNumbe.Text = Request.QueryString["SerialNumbe"].ToString();
                    this.imageQr.ImageUrl = "../../Upload/QR/" + Request.QueryString["QrPath"].ToString();
                }
            }
        }
    }
}
