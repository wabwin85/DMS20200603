using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace DMS.Website.Revolution.Pages.Transfer
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

    public partial class TransferPrint : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private ITransferBLL _business = null;
        private IDealerMasters _master = null;
        [Dependency]
        public ITransferBLL business
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
                e.Row.Cells[2].Visible = !Convert.ToBoolean(this.hfUPN.Value);
                e.Row.Cells[5].Visible = !Convert.ToBoolean(this.hfUOM.Value);
            }
        }

        private void BindMain(Guid id)
        {
            DMS.Model.Transfer mainData = business.GetObject(id);

            if (mainData.FromDealerDmaId != null)
            {
                this.tbDealer.Text = DealerCacheHelper.GetDealerName(mainData.FromDealerDmaId.Value);
            }
            //if (mainData.ToDealerDmaId != null)
            //{
            //    this.tb.Text = mainData.ToDealerDmaId.Value.ToString();
            //}
            if (mainData.ProductLineBumId != null)
            {
                Guid pid = mainData.ProductLineBumId.Value;
                this.tbProductLine.Text = master.GetProductLineById(pid).Tables[0].Rows[0]["AttributeName"].ToString();
            }
            if (mainData.TransferDate != null)
            {
                this.tbDate.Text = mainData.TransferDate.Value.ToString("yyyyMMdd");
            }
            this.tbTransferNumber.Text = mainData.TransferNumber;

            this.tbStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_DealerTransfer_Status, mainData.Status);
        }

        private void DetailRefershData()
        {
            Hashtable param = new Hashtable();

            param.Add("hid", id);

            DataSet ds = business.QueryTransferLotHasFromToWarehouse(param);

            this.GridView1.DataSource = ds;
            this.GridView1.DataBind();
            
        }
    }
}
