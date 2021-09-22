using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Model;
using DMS.Business;
using DMS.Common;
using DMS.Website.Common;
using Microsoft.Practices.Unity;
using System.Data;
using System.Collections;
using DMS.Business.Contract;
namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "AopEditorAdmin")]
    public partial class AOPEditorAdmin : BaseUserControl
    {
        ContractAmendmentService ContractBll = new ContractAmendmentService();
        #region 公开属性
        public String ContractId
        {
            get
            {
                return this.hiddenContractId.Text;
            }
            set
            {
                this.hiddenContractId.Text = value.ToString();
            }
        }
        public String TempId
        {
            get
            {
                return this.hiddenTempId.Text;
            }
            set
            {
                this.hiddenTempId.Text = value.ToString();
            }
        }
        public String ContractType
        {
            get
            {
                return this.hidContractType.Text;
            }
            set
            {
                this.hidContractType.Text = value.ToString();
            }
        }
        public String SubBU
        {
            get
            {
                return this.hidSubBU.Text;
            }
            set
            {
                this.hidSubBU.Text = value.ToString();
            }
        }
        public String BeginDate
        {
            get
            {
                return this.hidBeginDate.Text;
            }
            set
            {
                this.hidBeginDate.Text = value.ToString();
            }
        }
        public String DealerId
        {
            get
            {
                return this.hiddenDealer.Text;
            }
            set
            {
                this.hiddenDealer.Text = value.ToString();
            }
        }
        public String ProductLine
        {
            get
            {
                return this.hiddenProductLine.Text;
            }
            set
            {
                this.hiddenProductLine.Text = value.ToString();
            }
        }
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void HospitalAOPStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            obj.Add("TempId", this.TempId);
            if (!string.IsNullOrEmpty(this.tfHospitalName.Text))
            {
                obj.Add("HospitalName", this.tfHospitalName.Text);
            }
            if (!string.IsNullOrEmpty(this.nfYear.Text))
            {
                obj.Add("Year", this.nfYear.Text);
            }
            if (!string.IsNullOrEmpty(this.tfProductName.Text))
            {
                obj.Add("ProductName", this.tfProductName.Text);
            }
            DataTable dtProduct = ContractBll.SelectHospitalProductAOPAdmin(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.HospitalAOPStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            HospitalAOPStore.DataSource = dtProduct;
            HospitalAOPStore.DataBind();
        }
        protected void DealerAOPStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            obj.Add("TempId", this.TempId);
            DataTable dtProduct = ContractBll.SelectDealerAOPAdmin(obj).Tables[0];
            DealerAOPStore.DataSource = dtProduct;
            DealerAOPStore.DataBind();
        }

        protected void EditAop_Click(object sender, AjaxEventArgs e)
        {
            //this.InitEditValue("Amount");
            string editData = e.ExtraParams["editData"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                this.hidAopid.Value = sellist[0]["Id"];
                string Id = sellist[0]["Id"];

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("TempId", this.TempId);
                obj.Add("Id", Id);
                DataTable dt = ContractBll.SelectHospitalProductAOPAdmin(obj).Tables[0];

                if (dt.Rows.Count > 0)
                {
                    this.txtYear.Text = dt.Rows[0]["Year"].ToString();
                    this.txtAopProductName.Text = dt.Rows[0]["CQName"].ToString();
                    this.txtAopHospitalName.Text = dt.Rows[0]["HospitalName"].ToString();
                    this.nfAmount1.Number =Convert.ToDouble(dt.Rows[0]["Amount_1"]);
                    this.nfAmount2.Number = Convert.ToDouble(dt.Rows[0]["Amount_2"]);
                    this.nfAmount3.Number = Convert.ToDouble(dt.Rows[0]["Amount_3"]);
                    this.nfAmount4.Number = Convert.ToDouble(dt.Rows[0]["Amount_4"]);
                    this.nfAmount5.Number = Convert.ToDouble(dt.Rows[0]["Amount_5"]);
                    this.nfAmount6.Number = Convert.ToDouble(dt.Rows[0]["Amount_6"]);
                    this.nfAmount7.Number = Convert.ToDouble(dt.Rows[0]["Amount_7"]);
                    this.nfAmount8.Number = Convert.ToDouble(dt.Rows[0]["Amount_8"]);
                    this.nfAmount9.Number = Convert.ToDouble(dt.Rows[0]["Amount_9"]);
                    this.nfAmount10.Number = Convert.ToDouble(dt.Rows[0]["Amount_10"]);
                    this.nfAmount11.Number = Convert.ToDouble(dt.Rows[0]["Amount_11"]);
                    this.nfAmount12.Number = Convert.ToDouble(dt.Rows[0]["Amount_12"]);
                }
                this.EditHospitalDepWindow.Show();
                e.Success = true;
            }
        }
        protected void EditDealerAop_Click(object sender, AjaxEventArgs e)
        {
            //this.InitEditValue("Amount");
            string editData = e.ExtraParams["editData"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                this.hidDealerAopId.Value = sellist[0]["Id"];
                string Id = sellist[0]["Id"];

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("TempId", this.TempId);
                obj.Add("Id", Id);
                DataTable dt = ContractBll.SelectDealerAOPAdmin(obj).Tables[0];

                if (dt.Rows.Count > 0)
                {
                    this.lbDealerYear.Text = dt.Rows[0]["Year"].ToString();
                    this.lbCcName.Text = dt.Rows[0]["CCName"].ToString();
                    this.NumberField1.Number = Convert.ToDouble(dt.Rows[0]["Amount_1"]);
                    this.NumberField2.Number = Convert.ToDouble(dt.Rows[0]["Amount_2"]);
                    this.NumberField3.Number = Convert.ToDouble(dt.Rows[0]["Amount_3"]);
                    this.NumberField4.Number = Convert.ToDouble(dt.Rows[0]["Amount_4"]);
                    this.NumberField5.Number = Convert.ToDouble(dt.Rows[0]["Amount_5"]);
                    this.NumberField6.Number = Convert.ToDouble(dt.Rows[0]["Amount_6"]);
                    this.NumberField7.Number = Convert.ToDouble(dt.Rows[0]["Amount_7"]);
                    this.NumberField8.Number = Convert.ToDouble(dt.Rows[0]["Amount_8"]);
                    this.NumberField9.Number = Convert.ToDouble(dt.Rows[0]["Amount_9"]);
                    this.NumberField10.Number = Convert.ToDouble(dt.Rows[0]["Amount_10"]);
                    this.NumberField11.Number = Convert.ToDouble(dt.Rows[0]["Amount_11"]);
                    this.NumberField12.Number = Convert.ToDouble(dt.Rows[0]["Amount_12"]);
                }
                this.EditDealerWindow.Show();
                e.Success = true;
            }
        }

        [AjaxMethod]
        public void Show(string contractId, string tempId, string contracttype, string subu, string begindate, string dealerId, string bu)
        {
            ClearFormValue();
            this.ContractId = contractId;
            this.TempId = tempId;
            this.ContractType = contracttype;
            this.SubBU = subu;
            this.BeginDate = begindate;
            this.DealerId = dealerId;
            this.ProductLine = bu;
            AOPEditorInitAdmin();
            this.AOPWindow.Show();

        }
        protected void SaveHospitalAOP_Click(object sender, AjaxEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("Id", this.hidAopid.Value);
            obj.Add("ContractId", this.ContractId);
            obj.Add("TempId", this.TempId);
            obj.Add("AOPDH_Amount1", this.nfAmount1.Number);
            obj.Add("AOPDH_Amount2", this.nfAmount2.Number);
            obj.Add("AOPDH_Amount3", this.nfAmount3.Number);
            obj.Add("AOPDH_Amount4", this.nfAmount4.Number);
            obj.Add("AOPDH_Amount5", this.nfAmount5.Number);
            obj.Add("AOPDH_Amount6", this.nfAmount6.Number);
            obj.Add("AOPDH_Amount7", this.nfAmount7.Number);
            obj.Add("AOPDH_Amount8", this.nfAmount8.Number);
            obj.Add("AOPDH_Amount9", this.nfAmount9.Number);
            obj.Add("AOPDH_Amount10", this.nfAmount10.Number);
            obj.Add("AOPDH_Amount11", this.nfAmount11.Number);
            obj.Add("AOPDH_Amount12", this.nfAmount12.Number);
            ContractBll.SaveHospitalAopAdmin(obj);
            e.Success = true;

        }
        protected void SaveDealerAOP_Click(object sender, AjaxEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("Id", this.hidDealerAopId.Value);
            obj.Add("ContractId", this.ContractId);
            obj.Add("TempId", this.TempId);
            obj.Add("AOPD_Amount1", this.NumberField1.Number);
            obj.Add("AOPD_Amount2", this.NumberField2.Number);
            obj.Add("AOPD_Amount3", this.NumberField3.Number);
            obj.Add("AOPD_Amount4", this.NumberField4.Number);
            obj.Add("AOPD_Amount5", this.NumberField5.Number);
            obj.Add("AOPD_Amount6", this.NumberField6.Number);
            obj.Add("AOPD_Amount7", this.NumberField7.Number);
            obj.Add("AOPD_Amount8", this.NumberField8.Number);
            obj.Add("AOPD_Amount9", this.NumberField9.Number);
            obj.Add("AOPD_Amount10", this.NumberField10.Number);
            obj.Add("AOPD_Amount11", this.NumberField11.Number);
            obj.Add("AOPD_Amount12", this.NumberField12.Number);
            ContractBll.SaveDealerAopAdmin(obj);
            e.Success = true;
        }
        
        private void ClearFormValue()
        {
            this.ContractId = "";
            this.TempId = "";
            this.ContractType = "";
            this.SubBU = "";
            this.BeginDate = "";
            this.DealerId = "";
            this.ProductLine = "";
        }
        private void AOPEditorInitAdmin()
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", ContractId);
            obj.Add("TempId", TempId);
            obj.Add("ContractType", ContractType);
            ContractBll.AOPEditorInitAdmin(obj);

            this.GridPanel1.Reload();
            this.GridDealerAop.Reload();
        }
    }
}