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
    public partial class PromotionQuotaQuery : BasePage
    {
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();

        private IRoleModelContext _context = RoleModelContext.Current;
        private IConsignmentApplyHeaderBLL bll = new ConsignmentApplyHeaderBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                this.Bind_ProductLine(this.ProductLineStore);
                if (IsDealer)
                {
                    this.hidDealerType.Text = RoleModelContext.Current.User.CorpType;
                    this.hidDealerId.Text = RoleModelContext.Current.User.CorpId.ToString();
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
        protected void Store_PromotionTypeSotre(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.PRO_PointType);
            PromotionTypeSotre.DataSource = dicts;
            PromotionTypeSotre.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();
            DataSet ds = null;

            if (!string.IsNullOrEmpty(cbPromotionType.SelectedItem.Value))
            {
                param.Add("PromotionTyp", cbPromotionType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbDealer.SelectedItem.Value))
            {
                param.Add("Dma", cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbProductLine.SelectedItem.Value))
            {
                param.Add("Bu", cbProductLine.SelectedItem.Value);
            }
            if (cbPromotionType.SelectedItem.Value == "zp")
            {
                ds = _business.QueryPromotionQuotazp(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            }
            else if (cbPromotionType.SelectedItem.Value == "jf")
            {
                ds = _business.QueryPromotionQuotajf(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            }
            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }
        #endregion


        [AjaxMethod]
        public void DetailShow(string Id, string Type)
        {
            this.InitDetailWindow();
            this.DetailSetValue(Id, Type);
            this.WindowPoints.Show();
        }
        [AjaxMethod]
        public void Submit()
        {
            Hashtable obj = new Hashtable();
           _business.PromotionAdjustmentLimit(this.hidDlid.Value.ToString(), this.hidPolicyType.Value.ToString(), this.nubUpdateAmount.Number ,this.taRemark.Value.ToString());
        }
        

        public void InitDetailWindow()
        {
            this.hidDlid.Clear();
            this.hidPolicyType.Clear();
            this.labDealerName.Text = "";
            this.labPointAmount.Text = "";
            this.labSurplusAmount.Text = "";
            this.labProductLine.Text = "";
            this.labOrderAmount.Text = "";
            this.labPolicyType.Text = "";
            this.taRemark.Clear();
            this.nubUpdateAmount.Clear();
        }
        public void DetailSetValue(string Id, string Type)
        {
            this.hidDlid.Value = Id;
            this.hidPolicyType.Value = Type;

            DataTable dt = null;
            if (Type == "积分")
            {
                dt = _business.GetPromotionQuotajfById(Id).Tables[0];
            }
            if (Type == "赠品")
            {
                dt = _business.GetPromotionQuotazpById(Id).Tables[0];
            }
            if (dt.Rows.Count > 0)
            {
                this.labDealerName.Text = dt.Rows[0]["DealerName"].ToString();
                this.labPointAmount.Text = dt.Rows[0]["PointAmount"].ToString();
                this.labSurplusAmount.Text = dt.Rows[0]["SurplusAmount"].ToString();
                this.labProductLine.Text = dt.Rows[0]["ProductLineName"].ToString();
                this.labOrderAmount.Text = dt.Rows[0]["OrderAmount"].ToString();
                this.labPolicyType.Text = dt.Rows[0]["PoinType"].ToString();
                this.nubUpdateAmount.Number = 0;
            }
        }

        #region 页面方法
        protected void ExportExcel(object sender, EventArgs e)
        {
            Hashtable param = new Hashtable();
            DataSet ds = null;

            if (!string.IsNullOrEmpty(cbPromotionType.SelectedItem.Value))
            {
                param.Add("PromotionTyp", cbPromotionType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbDealer.SelectedItem.Value))
            {
                param.Add("Dma", cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbProductLine.SelectedItem.Value))
            {
                param.Add("Bu", cbProductLine.SelectedItem.Value);
            }
            if (cbPromotionType.SelectedItem.Value == "zp")
            {
                ds = _business.ExporPromotionQuotazp(param);
            }
            else if (cbPromotionType.SelectedItem.Value == "jf")
            {
                ds = _business.ExporPromotionQuotajf(param);
            }
            DataTable tb = ds.Tables[0];
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(tb));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }
        #endregion
    }
}
