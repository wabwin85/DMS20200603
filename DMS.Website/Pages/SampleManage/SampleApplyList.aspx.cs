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

namespace DMS.Website.Pages.SampleManage
{
    public partial class SampleApplyList : BasePage
    {
        SampleApplyBLL Bll = new SampleApplyBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.Bind_Dictionary(this.StoSampleStatus, "CONST_Sample_State");
            }
        }
        protected void StoSampleList_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.IptSampleType.SelectedItem.Value))
            {
                param.Add("SampleType", IptSampleType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.IptApplyNo.Text.Trim()))
            {
                param.Add("ApplyNo", IptApplyNo.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.IptApplyStatus.SelectedItem.Value))
            {
                param.Add("ApplyStatus", IptApplyStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.IptHosName.Text.Trim()))
            {
                param.Add("HospName", IptHosName.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.IptApplyUser.Text.Trim()))
            {
                param.Add("ApplyUser", IptApplyUser.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.ddlStatus.SelectedItem.Value))
            {
                param.Add("DeliveryStatus", ddlStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.tbUPN.Text.Trim()))
            {
                param.Add("ApplyUPN", tbUPN.Text.Trim());
            }
            DataSet ds = Bll.GetSampleApplyList(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagSampleList.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.StoSampleList.DataSource = ds;
            this.StoSampleList.DataBind();
        }

        [AjaxMethod]
        public string CheckApply(string FormId)
        {
            string retMassage = "";
            return retMassage;
        }
    }
}
