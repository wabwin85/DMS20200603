using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace DMS.Website.Pages.Inventory
{
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using DMS.Business;
    using DMS.Model;
    using Lafite.RoleModel.Security;
    using DMS.Common;
    using DMS.Model.Data;
    using DMS.Business.Cache;
    using Microsoft.Practices.Unity;
    public partial class InventoryReturnPrint : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IInventoryAdjustBLL _business = null;
        private IDealerMasters _master = null;
        [Dependency]
        public IInventoryAdjustBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        [Dependency]
        public IDealerMasters master
        {
            get { return _master; }
            set { _master = value; }
        }
        private static Guid id = Guid.Empty;

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] == null)
                    Response.Redirect("TransferEditor.aspx");
                else
                {
                    id = new Guid(Request.QueryString["id"].ToString());
                    BindMain(id);
                    DetailRefershData();
                }
            }
        }

        protected void result_RowCreated(object sender, GridViewRowEventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("result_RowCreated");
            if (e.Row.RowType == DataControlRowType.DataRow || e.Row.RowType == DataControlRowType.Header)
            {
                //判断是否显示编辑列
                e.Row.Cells[3].Visible = !Convert.ToBoolean(this.hfUPN.Value);
                e.Row.Cells[6].Visible = !Convert.ToBoolean(this.hfUOM.Value);
            }
        }

        private void BindMain(Guid id)
        {
            //DMS.Model.InventoryAdjustHeader mainData = business.GetInventoryAdjustById(id);
             DMS.Model.InventoryAdjustHeader mainData = business.GetInventoryAdjustByIdPrint(id);
            
            if (mainData.DmaId != null)
            {
                this.tbDealer.Text = DealerCacheHelper.GetDealerName(mainData.DmaId);
            }
          
            if (mainData.ProductLineBumId != null)
            {
                Guid pid = mainData.ProductLineBumId.Value;
                this.tbProductLine.Text = master.GetProductLineById(pid).Tables[0].Rows[0]["AttributeName"].ToString();
            }
            if (mainData.CreateDate != null)
            {
                this.tbDate.Text = mainData.CreateDate.Value.ToString("yyyyMMdd");
            }
            if (mainData.ApplyType != null)
            {
                tbApplyType.Text = mainData.ApplyType;
            }
            if (mainData.Reason != null)
            {
                tbReosson.Text = mainData.Reason == "Return" ? "退款(寄售产品仅退货)" : mainData.Reason == "Exchange" ? "换货" : "";
            }
            if (mainData.RetrunReason != null)
            {
                tbRetrunReason.Text = mainData.RetrunReason;
            }
            this.tbReturnNumber.Text = mainData.InvAdjNbr;

            this.tbStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_AdjustQty_Status, mainData.Status);
        }

        private void DetailRefershData()
        {
            Hashtable param = new Hashtable();

            param.Add("AdjustId", id);

            DataSet ds = business.QueryInventoryAdjustLot(param);

            this.GridView1.DataSource = ds;
            this.GridView1.DataBind();

        }
    }
}
