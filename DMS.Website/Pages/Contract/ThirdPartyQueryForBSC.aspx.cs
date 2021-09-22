using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using Coolite.Ext.Web;
using System.Data;
using DMS.Business.Contract;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;


namespace DMS.Website.Pages.Contract
{
    using iTextSharp.text.pdf;
    using iTextSharp.text;
    using System.IO;
    using System.Reflection;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using DMS.Model.Data;
    using System.Text.RegularExpressions;
    using DMS.Business;
    using System.Collections;
    using DMS.Business.Cache;
    public partial class ThirdPartyQueryForBSC : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IThirdPartyDisclosureService _thirdPartyDisclosure = new ThirdPartyDisclosureService();
       
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = true;
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                        {
                            this.cbDealer.Disabled = true;
                        }
                    }
                    else
                    {
                        this.Bind_DealerList(this.DealerStore);
                    }

                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);

                }
            }
        }
       
        public void ThirdPartyDisclosure_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable ht = new Hashtable();
            if (!string.IsNullOrEmpty(cbDealer.SelectedItem.Value))
            {
                ht.Add("DmaId", cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(txtHospitName.Text))
            {
                ht.Add("Name", txtHospitName.Text);
            }
            if (!string.IsNullOrEmpty(cbIsAt.SelectedItem.Value))
            {
                ht.Add("IsAt", cbIsAt.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbApprovalStatus.SelectedItem.Value))
            {
                ht.Add("ApprovalStatus", cbApprovalStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbIsHospital.SelectedItem.Value))
            {
                ht.Add("IsHospital", cbIsHospital.SelectedItem.Value);
            }
            DataSet ds = _thirdPartyDisclosure.QueryThirdPartyDisclosure(ht, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            ThirdPartyDisclosurestore.DataSource = ds;
            ThirdPartyDisclosurestore.DataBind();
        }
     
        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = this.GetInventoryList().Tables[0];//dt是从后台生成的要导出的datatable
            dt.Columns.Remove("DmaId");
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
        private DataSet GetInventoryList()
        {
            Hashtable ht = new Hashtable();
            if (!string.IsNullOrEmpty(cbDealer.SelectedItem.Value))
            {
                ht.Add("DmaId", cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(txtHospitName.Text))
            {
                ht.Add("Name", txtHospitName.Text);
            }
            if (!string.IsNullOrEmpty(cbIsAt.SelectedItem.Value))
            {
                ht.Add("IsAt", cbIsAt.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbApprovalStatus.SelectedItem.Value))
            {
                ht.Add("ApprovalStatus", cbApprovalStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(cbIsHospital.SelectedItem.Value))
            {
                ht.Add("IsHospital", cbIsHospital.SelectedItem.Value);
            }
            DataSet ds = _thirdPartyDisclosure.ExportThirdPartyDisclosure(ht);
            return ds;
        }
    }
}
