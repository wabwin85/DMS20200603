using System;
using System.Collections;
using System.Configuration;
using System.Data;
using DMS.Website.Common;
using DMS.Business.DataInterface;
using Microsoft.Practices.Unity;
using DMS.Model.Data;
using Coolite.Ext.Web;
using DMS.Model;
using Lafite.RoleModel.Security;
using System.IO;
using System.Collections.Generic;
using DMS.Common;
using DMS.Business.Cache;
using DMS.Business.MasterData;
using System.Linq;
using DMS.Business;

namespace DMS.Website.Pages.Promotion
{
    public partial class PolargessorpointLog : BasePage
    {
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();

        private IRoleModelContext _context = RoleModelContext.Current;
        private IConsignmentApplyHeaderBLL bll = new ConsignmentApplyHeaderBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LogTypeSotre_Bindata();
                HidLogType.Text = this.CbLogType.SelectedItem.Value;
                this.Bind_ProductLine(this.ProductLineStore);
                if (IsDealer)
                {

                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        cbDealer.Disabled = false;
                        //DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ORDERNEW);
                    }
                    else
                    {
                        cbDealer.Disabled = true;
                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);
                    this.cbDealer.Enabled = true;
                }
            }
        }
        #region 数据绑定
        [AjaxMethod]
        public void LogTypeSotre_Bindata()
        {
            DataSet ds = null;

            if (this.cbPromotionType.SelectedItem.Value == "Point")
            {
                ds = _business.SelectPointlogType();
            }
            else if (this.cbPromotionType.SelectedItem.Value == "Laregss")
            {
                ds = _business.SelectLargesslogType();
            }
            LogTypeSotre.DataSource = ds;
            LogTypeSotre.DataBind();
        }
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet ds = new DataSet();
            int totalCount = 0;
            Hashtable ht = new Hashtable();
            if (!string.IsNullOrEmpty(cbDealer.SelectedItem.Value))
            {
                ht.Add("Dma", cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbProductLine.SelectedItem.Value))
            {
                ht.Add("Bu", cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(CbLogType.SelectedItem.Value))
            {
                ht.Add("DlFrom", CbLogType.SelectedItem.Value);
            }
            if (!StarData.IsNull)
            {
                ht.Add("StarData", StarData.SelectedDate);
            }
            if (!EndData.IsNull)
            {
                ht.Add("EndData", EndData.SelectedDate);
            }
            if (!string.IsNullOrEmpty(this.txtOrderNo.Text))
            {
                ht.Add("OrderNo", this.txtOrderNo.Text);
            }
            if (!string.IsNullOrEmpty(this.txtEwfNo.Text))
            {
                ht.Add("EwfNo", this.txtEwfNo.Text);
            }
            ht.Add("Type", this.cbPromotionType.SelectedItem.Value);
            if (this.cbPromotionType.SelectedItem.Value == "Point")
            {
                ds = _business.QueryPointlogByDmabu(ht, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            }
            else if (this.cbPromotionType.SelectedItem.Value == "Laregss")
            {
                ds = _business.QueryLargesslogByDmabu(ht, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            }
            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            ResultStore.DataSource = ds;
            ResultStore.DataBind();
        }
        public DataSet GetPolagessorpiontLogExportExcel()
        {
            DataSet ds = new DataSet();
            Hashtable ht = new Hashtable();
            if (!string.IsNullOrEmpty(cbDealer.SelectedItem.Value))
            {
                ht.Add("Dma", cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbProductLine.SelectedItem.Value))
            {
                ht.Add("Bu", cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(CbLogType.SelectedItem.Value))
            {
                ht.Add("DlFrom", CbLogType.SelectedItem.Value);
            }
            if (!StarData.IsNull)
            {
                ht.Add("StarData", StarData.SelectedDate);
            }
            if (!EndData.IsNull)
            {
                ht.Add("EndData", EndData.SelectedDate);
            }
            ht.Add("Type", this.cbPromotionType.SelectedItem.Value);
            if (this.cbPromotionType.SelectedItem.Value == "Point")
            {
                ds = _business.SelectPointlogByDmabuExportExcel(ht);
            }
            else if (this.cbPromotionType.SelectedItem.Value == "Laregss")
            {
                ds = _business.SelectargesslogByExportExcel(ht);
            }
            return ds;
        }
        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = this.GetPolagessorpiontLogExportExcel().Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }

        #endregion

    }
}
