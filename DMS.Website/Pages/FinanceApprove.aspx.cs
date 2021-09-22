using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Business;
using Microsoft.Practices.Unity;
using DMS.Model;
using DMS.Model.Data;
using DMS.Website.Common;

namespace DMS.Website.Pages
{
    public partial class FinanceApprove : BasePage
    {
        string ShipmentNbr = "";
        private IShipmentBLL _business = null;
        [Dependency]
        public IShipmentBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            btnApprove.Visible = false;
            //校验销售单是否已经添加过批注
            if (!string.IsNullOrEmpty(Request.QueryString["ShipmentID"]))
            {
                System.Data.DataSet approvings = business.SelectShipmentLog(Request.QueryString["ShipmentID"]);
                if (approvings.Tables[0].Rows.Count == 0)
                {
                    ShipmentHeader sph = business.GetShipmentHeaderById(new Guid(Request.QueryString["ShipmentID"]));
                    ShipmentNbr = sph.ShipmentNbr;
                    lbWarn.Visible = false;
                    btnApprove.Visible = true;
                }
                else
                {
                    lbWarn.Text = "该销售单已经添加过批注";
                    txtRemark.Visible = false;

                }
            }
            else
            {
                lbWarn.Text = "未传入 'ShipmentID'";
                txtRemark.Visible = false;
            }
        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            ShipmentBLL bll = new ShipmentBLL();
            //保存批注到销售单操作记录
            bll.InsertPurchaseOrderLog(new Guid(Request.QueryString["ShipmentID"]),Guid.Empty, PurchaseOrderOperationType.Approve, txtRemark.Text);
            //生成清指定批号订单
            string RtnVal = string.Empty;
            string RtnMsg = string.Empty;
            bll.GenClearBorrow(Request.QueryString["ShipmentID"], out RtnVal, out RtnMsg);
            if (RtnVal == "Failure")
            {
                lbWarn.Text = RtnMsg;
            }
            else
            {
                lbWarn.Text = "单据号：" + ShipmentNbr + " 已被您添加批注！";
            }
            btnApprove.Visible = false;
            lbWarn.Visible = true;
            txtRemark.Visible = false;
            
        }

    }
}