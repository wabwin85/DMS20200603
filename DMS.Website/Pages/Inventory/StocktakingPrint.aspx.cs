using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;
using System.Collections;
using System.Data;
using DMS.Business.Cache;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using Microsoft.Practices.Unity;
using System.Web.Script.Serialization;

namespace DMS.Website.Pages.Inventory
{
    public partial class StocktakingPrint : BasePage
    {
        #region Properties
        IRoleModelContext _context = RoleModelContext.Current;
        private IStocktakingBLL _business = null;
        private IDealerMasters _master = null;
        private static Guid id = Guid.Empty;
        private static string status = string.Empty;

        [Dependency]
        public IStocktakingBLL business
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
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] == null)
                    Response.Redirect("ShipmentList.aspx");
                else
                {
                    id = new Guid(Request.QueryString["id"].ToString());
                    status = Request.QueryString["status"].ToString();
                    DetailRefershData();
                }
            }
        }

        protected void DetailRefershData()
        {
            DataSet ds = null;
            //表头赋值
            ds = business.GetReportHeaderById(id);
            if (ds.Tables[0].Rows.Count > 0)
            {
                this.tbDealer.Text = ds.Tables[0].Rows[0]["DMA_ChineseName"].ToString();
                this.tbStocktakingNo.Text = ds.Tables[0].Rows[0]["STH_StocktakingNo"].ToString();
                this.tbWarehouse.Text = ds.Tables[0].Rows[0]["WHM_Name"].ToString();
                this.tbStocktakingDate.Text = ds.Tables[0].Rows[0]["STH_CreateDate"].ToString();
            }

            if (status == "Dif")
                ds = business.GetDifReportById(id);
            else
                ds = business.GetStockReportById(id);

            this.GridView1.DataSource = ds;
            this.GridView1.DataBind();
        }

        protected void result_RowCreated(object sender, GridViewRowEventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("result_RowCreated");
            if (e.Row.RowType == DataControlRowType.DataRow || e.Row.RowType == DataControlRowType.Header)
            {
                //判断是否显示编辑列
                if (status == "Inv")
                {
                    e.Row.Cells[2].Visible = false;
                    e.Row.Cells[4].Visible = false;
                    e.Row.Cells[5].Visible = false;
                    e.Row.Cells[6].Visible = true;
                }
                else
                {
                    e.Row.Cells[6].Visible = false;
                }
            }
        }

    }
}
