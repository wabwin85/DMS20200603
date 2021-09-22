using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Model.Data;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using DMS.Common;
using Microsoft.Practices.Unity;
namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "HospitalAOPImport")]
    public partial class HospitalAOPImport : BaseUserControl
    {
        #region 公用
        private IContractCommonBLL _contractCommonbll = new ContractCommonBLL();
        #endregion

        #region 公开属性
        public string ContractId
        {
            get
            {
                return this.hidContractId.Text;
            }
            set
            {
                this.hidContractId.Text = value.ToString();
            }
        }
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) 
            {
                Hidden ContractId = this.Parent.FindControl("hidContractId") as Hidden;
                Hidden LastContractId = this.Parent.FindControl("hidLastContractId") as Hidden;
                Hidden DealerId = this.Parent.FindControl("hidDealerId") as Hidden;
                Hidden ProductLineId = this.Parent.FindControl("hidProductLineId") as Hidden;
                Hidden SubBuCode = this.Parent.FindControl("hidSubBuCode") as Hidden;
                Hidden IsEmerging = this.Parent.FindControl("hidIsEmerging") as Hidden;
                Hidden YearString = this.Parent.FindControl("hidYearString") as Hidden;
                Hidden BeginDate = this.Parent.FindControl("hidEffectiveDate") as Hidden;
                Hidden EndDate = this.Parent.FindControl("hidExpirationDate") as Hidden;
                Hidden PageType = this.Parent.FindControl("hidPageType") as Hidden;
                Hidden ContractType = this.Parent.FindControl("hidContractType") as Hidden;
                this.tabForm1.AutoLoad.Url = "~/Pages/Contract/AOPImport.aspx?ContractId=" + ContractId.Value.ToString() + "&DealerId=" + DealerId.Value.ToString() + "&ProductLineId=" + ProductLineId.Value.ToString() + "&SubBuCode=" + SubBuCode.Value.ToString()
                    + "&IsEmerging=" + IsEmerging.Value.ToString() + "&YearString=" + YearString.Value.ToString() + "&BeginDate=" + BeginDate.Value.ToString() + "&EndDate=" + EndDate.Value.ToString() + "&PageType=" + PageType.Value.ToString() + "&ContractType=" + ContractType.Value.ToString();
            }
        }

        #region 上传医院指标
        [AjaxMethod]
        public void Show(string contractId)
        {
            this.ContractId = contractId;
            this.HospitalAopUploadWindow.Show();
        }

        #endregion

    }
}