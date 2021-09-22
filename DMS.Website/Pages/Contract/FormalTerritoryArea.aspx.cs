using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Coolite.Ext.Web;
using DMS.Business;
using DMS.Website.Common;

namespace DMS.Website.Pages.Contract
{
    public partial class FormalTerritoryArea : BasePage
    {
        private IContractMasterBLL _contractBll = new ContractMasterBLL();
     
        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.Request.QueryString["DivisionID"] != null && this.Request.QueryString["DealerID"] != null && this.Request.QueryString["PartsContractCode"] != null)
            {
                this.hdDivisionId.Text = this.Request.QueryString["DivisionID"];
                this.hdDmaId.Text = this.Request.QueryString["DealerID"];
                this.hdSubDepCode.Text = this.Request.QueryString["PartsContractCode"];
                this.hidContractId.Text = this.Request.QueryString["InstanceID"];

            }
            Guid empty = Guid.Empty;

            if (this.hdDivisionId.Text.Equals(""))
            {
                this.hdDivisionId.Text = "0";
            }
            if (this.hdDmaId.Text.Equals(""))
            {
                this.hdDmaId.Text = empty.ToString();
            }
            if (this.hdSubDepCode.Text.Equals(""))
            {
                this.hdSubDepCode.Text = "0";
            }
            if (this.hidContractId.Text.Equals(""))
            {
                this.hidContractId.Text = empty.ToString();
            }
        }


        protected void AreaStore_OnRefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.hidContractId.Value.ToString()); //合同ID
            obj.Add("DivisionId", this.hdDivisionId.Value.ToString());
            obj.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
            obj.Add("DmaId", this.hdDmaId.Value.ToString());
            DataTable provinces = _contractBll.GetProvincesForAreaSelectedOld(obj).Tables[0];
            this.pnlCenter.Title = "授权区域(共计：" + provinces.Rows.Count + " 个区域)";
            AreaStore.DataSource = provinces;
            AreaStore.DataBind();
            
        }

        protected void ExcludeHospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.hidContractId.Value.ToString()); //合同ID
            obj.Add("DivisionId", this.hdDivisionId.Value.ToString());
            obj.Add("SubDepCode", this.hdSubDepCode.Value.ToString());
            obj.Add("DmaId", this.hdDmaId.Value.ToString());

            DataSet query = _contractBll.GetPartAreaExcHospitalOld(obj);
            this.pnlSouth.Title = "区域内排除医院(共计：" + query.Tables[0].Rows.Count + " 家医院)";
            this.ExcludeHospitalStore.DataSource = query;
            this.ExcludeHospitalStore.DataBind();
            
        }
    }


}
