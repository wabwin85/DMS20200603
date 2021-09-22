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
    public partial class SampleReturnList : BasePage
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
            if (!string.IsNullOrEmpty(this.IptReturnNo.Text.Trim()))
            {
                param.Add("ReturnNo", IptReturnNo.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.IptReturnStatus.SelectedItem.Value))
            {
                param.Add("ReturnStatus", IptReturnStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.IptReturnHosp.Text.Trim()))
            {
                param.Add("ReturnHosp", IptReturnHosp.Text.Trim());
            }
            if (!string.IsNullOrEmpty(this.IptReturnUser.Text.Trim()))
            {
                param.Add("ReturnUser", IptReturnUser.Text.Trim());
            }
            DataSet ds = Bll.GetSampleReturnList(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagSampleList.PageSize : e.Limit), out totalCount);
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
