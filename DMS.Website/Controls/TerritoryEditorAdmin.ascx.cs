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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "TerritoryEditorAdmin")]
    public partial class TerritoryEditorAdmin : BaseUserControl
    {
        ContractAmendmentService ContractBll = new ContractAmendmentService();
        IContractMasterBLL _contractMasterBll = new ContractMasterBLL();
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
        protected void AuthorizationStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            obj.Add("TempId", this.TempId);
            obj.Add("SubBU", this.SubBU);
            DataTable dtProduct = ContractBll.AuthorizationProductSelectedAdmin(obj).Tables[0];
            AuthorizationStore.DataSource = dtProduct;
            AuthorizationStore.DataBind();
        }

        protected void AllProductStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("SubBU", this.SubBU);
            obj.Add("BeginDate", Convert.ToDateTime(this.BeginDate).Year.ToString());
            DataTable dtProduct = _contractMasterBll.GetAuthorizationProductAll(obj).Tables[0];
            AllProductStore.DataSource = dtProduct;
            AllProductStore.DataBind();
        }

        protected void HospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (this.hiddenId.Text != string.Empty)
            {
                int totalCount = 0;
                Hashtable obj = new Hashtable();
                obj.Add("DctId", this.hiddenId.Text);
                obj.Add("ContractId", this.ContractId);
                obj.Add("TempId", this.TempId);
                DataTable dt = ContractBll.GetProductHospitalSeletedAdmin(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
                (this.HospitalStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

                this.HospitalStore.DataSource = dt;
                this.HospitalStore.DataBind();
            }
        }
        //复制医院数据绑定
        protected void AuthorizationSelectorStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string authId = this.hiddenId.Text;
            if (!string.IsNullOrEmpty(this.ContractId) && !string.IsNullOrEmpty(authId) && !string.IsNullOrEmpty(this.TempId))
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("TempId", this.TempId);
                obj.Add("Id", authId);
                obj.Add("BeginDate", this.BeginDate);
                this.AuthorizationSelectorStore.DataSource = ContractBll.GetCopyProductCanAdmin(obj);
                this.AuthorizationSelectorStore.DataBind();
            }
        }
        protected void HospitalSearchDlgStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            IHospitals bll = new Hospitals();
            int totalCount = 0, start = 0, limit = 0;
            limit = this.PagingToolBar1.PageSize;
            if (e.Start > 0)
            {
                start = e.Start;
                limit = e.Limit;
            }
            Hospital param = new Hospital();
            param.HosHospitalName = this.txtSearchHospitalName.Text.Trim();
            param.HosKeyAccount = this.txtHospitalCode.Text.Trim();

            IList<Hospital> query = bll.SelectByFilter(param, start, limit, out totalCount);
          
            (this.HospitalSearchDlgStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.HospitalSearchDlgStore.DataSource = query;
            this.HospitalSearchDlgStore.DataBind();
        }
        protected void SubmitSelection(object sender, AjaxEventArgs e)
        {
            string datId = this.hiddenId.Value.ToString();
            string fromData = e.ExtraParams["SelectValues"];
            SelectedEventArgs ee = new SelectedEventArgs(fromData);
            IList<DealerAuthorization> data = ee.ToList<DealerAuthorization>();
            if (data.Count <= 0) return;
            Guid fromDatId = data[0].Id.Value;
            Hashtable obj = new Hashtable();
            obj.Add("DatId", datId);
            obj.Add("FromDatID", fromDatId);
            obj.Add("TempId", this.TempId);
            ContractBll.CopyHospitalTempFromOtherAuthAdmin(obj);
            this.gplAuthHospital.Reload();

            e.Success = true;
        }
        protected void SaveTerritoryDepart_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("Id", this.txtHidDatId.Text);
                obj.Add("HlaDep", this.txtHospitalDepartment.Text);
                obj.Add("HlaDepType", DBNull.Value);
                obj.Add("HlaDepRemark", this.txtHospitalRemark.Text);
                //_contractMasterBll.UpdateHospitalDepartmentTemp(obj);
                e.Success = true;
            }
            catch
            {
                e.Success = false;
            }
        }
        protected void HospitalStore_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            if (this.ContractId != "")
            {
                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);

                ChangeRecords<Hospital> data = dataHandler.CustomObjectData<Hospital>();

                IList<Hospital> selDeleted = data.Deleted;
                Guid[] hosList = (from p in selDeleted select p.Id).ToArray<Guid>();

                ContractBll.DeleteAuthorizationHospitalTempAdmin(hosList,this.TempId);

                string hospitalString = "";
                for (int i = 0; i < hosList.Length; i++)
                {
                    hospitalString += (hosList[i].ToString() + ",");
                }
                if (!hospitalString.Equals(""))
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("TempId", this.TempId);
                    ContractBll.DeleteHospitalAOPTempAdmin(obj);
                    ContractBll.DeleteDealerAOPTempAdmin(obj);
                }
                e.Cancel = true;
            }
        }

        protected void DeleteAuthorization_Click(object sender, AjaxEventArgs e)
        {
            RowSelectionModel sm = this.gplAuthorization.SelectionModel.Primary as RowSelectionModel;
            string id = sm.SelectedRow.RecordID;
            if (!string.IsNullOrEmpty(id))
            {
                Hashtable obj = new Hashtable();
                obj.Add("TempId", this.TempId);
                obj.Add("DctId", id);
                bool isdeleted = ContractBll.DeleteProductSelectedAdmin(obj);
                e.Success = isdeleted;
            }
        }
        [AjaxMethod]
        public void Show(string contractId,string tempId,string contracttype,string subu,string begindate,string dealerId,string bu)
        {
            ClearFormValue();
            this.ContractId = contractId;
            this.TempId = tempId;
            this.ContractType = contracttype;
            this.SubBU = subu;
            this.BeginDate = begindate;
            this.DealerId = dealerId;
            this.ProductLine = bu;
            TerritoryEditorInit();
            this.PartsDetailsWindow.Show();

        }
        [AjaxMethod]
        public void addProduct(string param)
        {
            param = param.Substring(0, param.Length - 1);
            Hashtable obj = new Hashtable();
            obj.Add("ProductString", param);
            obj.Add("DealerId", this.DealerId);
            obj.Add("ContractId", this.ContractId);
            obj.Add("TempId", this.TempId);
            obj.Add("BuName", this.ProductLine);
            ContractBll.AddContractProductAdmin(obj);
        }
        [AjaxMethod]
        public void HospitalDepartClear()
        {
            if (!this.txtHidDatId.Text.Equals(""))
            {
                Hashtable obj = new Hashtable();
                obj.Add("Id", this.txtHidDatId.Text);
                //_contractMasterBll.HospitalDepartClear(obj);
            }
        }
        [AjaxMethod]
        public void SubmintHospitalAdd(string param)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("HospitalIdString", param);
                obj.Add("TempId", this.TempId);
                obj.Add("DatId", this.hiddenId.Text);
                ContractBll.AddProductHospitalAdmin(obj);
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("错误", ex.ToString()).Show();
            }
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
        private void TerritoryEditorInit()
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", ContractId);
            obj.Add("TempId", TempId);
            obj.Add("ContractType", ContractType);
            ContractBll.TerritoryEditorInitAdmin(obj);
            this.gplAuthorization.Reload();
        }
    }
}