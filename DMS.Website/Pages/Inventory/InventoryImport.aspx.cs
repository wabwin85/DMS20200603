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

namespace DMS.Website.Pages.Inventory
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class InventoryImport : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IInventoryInitBLL business = new InventoryInitBLL();

        #endregion


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.btnImport.Visible = IsDealer;
                this.Bind_DealerListByFilter(DealerStore, true);

                if(string.IsNullOrEmpty(this.txtImportDate.Text))
                {
                    this.txtImportDate.Text = DateTime.Now.AddMonths(-1).ToString("yyyyMM");
                }

                if (IsDealer)
                {

                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();

                    if (RoleModelContext.Current.User.CorpType == DealerType.T1.ToString() ||
                        RoleModelContext.Current.User.CorpType == DealerType.T2.ToString())
                    {
                        this.cbDealer.Disabled = true;
                        //this.btnImport.Visible = false;
                    }


                }
                else
                {
                    this.cbDealer.Disabled = false;
                    this.btnImport.Visible = false;
                }
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();

            //经销商ID
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DMA_ID", this.cbDealer.SelectedItem.Value);
            }
            //导入时间
            if (!string.IsNullOrEmpty(this.txtImportDate.Text) && this.txtImportDate.Text.Length==6)
            {
                param.Add("DID_Period", this.txtImportDate.Text);



                IList<DealerInventoryData> list = business.QueryDID(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

                e.TotalCount = totalCount;

                DealerInventoryData obj = business.QueryRecord(param);
                if (obj != null)
                {
                    this.txtTotalCount.Text = obj.TotalCount.ToString();
                    this.txtTotalQty.Text = obj.TotalQty.ToString("0.00");
                }

                this.ResultStore.DataSource = list;
                this.ResultStore.DataBind();
            }
        }

    }

}
