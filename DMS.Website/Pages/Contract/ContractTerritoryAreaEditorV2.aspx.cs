using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Contract
{
    using DMS.Model;
    using DMS.Business;
    using DMS.Business.Cache;
    using DMS.Common;
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using System.Data;
    using System.Collections;
    public partial class ContractTerritoryAreaEditorV2 : BasePage
    {
        private IContractMasterBLL _contractMasterBll = new ContractMasterBLL();
        private IContractCommonBLL _contractCommon = new ContractCommonBLL();

        #region 公开属性

        public string ContractId
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
        public string DealerId
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
        public string DivisionId
        {
            get
            {
                return this.hidDivisionID.Text;
            }
            set
            {
                this.hidDivisionID.Text = value.ToString();
            }
        }

        public string SubBU
        {
            get
            {
                return this.hidPartsContractCode.Text;
            }
            set
            {
                this.hidPartsContractCode.Text = value.ToString();
            }
        }

        public string IsEmerging
        {
            get
            {
                return this.hidIsEmerging.Text;
            }
            set
            {
                this.hidIsEmerging.Text = value.ToString();
            }
        }

        public string ContractType
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
        public string ProductLineId
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


        public string IsChangeProduct
        {
            get
            {
                return this.hidIsChange.Text;
            }
            set
            {
                this.hidIsChange.Text = value.ToString();
            }
        }

        public string BeginDate
        {
            get
            {
                return (this.hidBeginDate.Text == "" ? DateTime.Now.ToShortDateString() : this.hidBeginDate.Text);
            }
            set
            {
                this.hidBeginDate.Text = value.ToString();
            }
        }

        public string EndDate
        {
            get
            {
                return (this.hidEndDate.Text == "" ? DateTime.Now.ToShortDateString() : this.hidEndDate.Text);
            }
            set
            {
                this.hidEndDate.Text = value.ToString();
            }
        }

        public string LastContractId
        {
            get
            {
                return this.hidLastContractId.Text;
            }
            set
            {
                this.hidLastContractId.Text = value.ToString();
            }
        }

        public string PageOperationType
        {
            get
            {
                return this.hidPageOperation.Text;
            }
            set
            {
                this.hidPageOperation.Text = value.ToString();
            }
        }
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if ((!IsPostBack) && (!Ext.IsAjaxRequest))
            {
                if (this.Request.QueryString["InstanceID"] != null &&
                    this.Request.QueryString["DivisionID"] != null &&
                    this.Request.QueryString["PartsContractCode"] != null &&
                    this.Request.QueryString["TempDealerID"] != null &&
                    this.Request.QueryString["ContractType"] != null)
                {

                    this.ContractId = this.Request.QueryString["InstanceID"];//合同ID
                    this.DivisionId = this.Request.QueryString["DivisionID"];//产品线
                    this.SubBU = this.Request.QueryString["PartsContractCode"];//合同分类Code
                    this.DealerId = this.Request.QueryString["TempDealerID"];//经销商ID
                    this.ContractType = this.Request.QueryString["ContractType"];//合同类型
                    this.ProductLineId = getProductLineId(this.Request.QueryString["DivisionID"].ToString()); //获取产品线ID

                    if (this.Request.QueryString["IsEmerging"] != null)
                    {   // 0:红海,  1:蓝海,  2:不分红蓝海  
                        this.IsEmerging = this.Request.QueryString["IsEmerging"].ToString();
                    }
                    else
                    {
                        this.IsEmerging = "0";
                    }

                    if (this.Request.QueryString["ProductAmend"] != null)
                    {   //是否修改授权产品分类
                        this.IsChangeProduct = this.Request.QueryString["ProductAmend"].ToString().Equals("") ? "0" : this.Request.QueryString["ProductAmend"].ToString();
                    }
                    else
                    {
                        this.IsChangeProduct = "0";
                    }
                    if (this.Request.QueryString["EffectiveDate"] != null && !this.Request.QueryString["EffectiveDate"].ToString().Equals(""))
                    {
                        this.BeginDate = this.Request.QueryString["EffectiveDate"].ToString();
                    }
                    if (this.Request.QueryString["ExpirationDate"] != null && !this.Request.QueryString["ExpirationDate"].ToString().Equals(""))
                    {
                        this.EndDate = this.Request.QueryString["ExpirationDate"].ToString();
                    }
                    this.PageOperationType = this.Request.QueryString["OperationType"];

                    PageInit();
                    PagePermissions();
                }
            }
        }

        #region 时间绑定
        //当前授权产品线
        protected void AuthorizationStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            obj.Add("SubBU", this.SubBU);
            obj.Add("BeginDate", this.BeginDate);
            DataTable dtProduct = _contractMasterBll.GetAuthorizationAreaProductSelected(obj).Tables[0];
            AuthorizationStore.DataSource = dtProduct;
            AuthorizationStore.DataBind();
        }
        //绑定指定SubBU下所有可选授权分类
        protected void AllProductStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("SubBU", this.SubBU);
            obj.Add("BeginDate", this.BeginDate);
            DataTable dtProduct = _contractMasterBll.GetAuthorizationProductAll(obj).Tables[0];
            AllProductStore.DataSource = dtProduct;
            AllProductStore.DataBind();
        }
        //绑定SuBu下的授权区域
        protected void AreaTempStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", ContractId);
            if (!string.IsNullOrEmpty(this.hiddenId.Text))
            {
                obj.Add("DA_ID", this.hiddenId.Text);
                DataTable dtArea = _contractMasterBll.GetAuthorizatonArea(obj).Tables[0];
                AreaTempStore.DataSource = dtArea;
                AreaTempStore.DataBind();
            }
        }
        //绑定区域
        protected void TerritoryStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("Type", "Province");
            DataTable dttrrea = _contractMasterBll.GetnArea(obj).Tables[0];
            TerritoryStore.DataSource = dttrrea;
            TerritoryStore.DataBind();
        }
        //绑定授权的医院
        protected void AuthorizationHospitStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!String.IsNullOrEmpty(this.ContractId))
            {
                int totalCount = 0;
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId); //合同ID
                if (!string.IsNullOrEmpty(this.hiddenId.Text))
                {
                    obj.Add("DA_ID", hiddenId.Text);
                    DataSet query = _contractMasterBll.QueryPartAreaExcHospitalTemp(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

                    if (query != null && query.Tables[0].Rows.Count > 0)
                    {
                        this.pnlSouth.Title = "第三步：区域内<font color='red' size='3px' >排除</font>医院 (共计：" + query.Tables[0].Rows.Count.ToString() + "家医院)";
                    }
                    else { this.pnlSouth.Title = "第三步：区域内<font color='red' size='3px' >排除</font>医院 (共计：0 家医院)"; }
                    e.TotalCount = totalCount;
                    this.AuthorizationHospitStore.DataSource = query;
                    this.AuthorizationHospitStore.DataBind();
                }
            }
        }
        //复制医院数据绑定
        protected void AuthorizationSelectorStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string contractId = this.ContractId;
            string authId = this.hiddenId.Text;
            if (!string.IsNullOrEmpty(contractId) && !string.IsNullOrEmpty(authId))
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", contractId);
                obj.Add("Id", authId);
                obj.Add("BeginDate", this.BeginDate);
                this.AuthorizationSelectorStore.DataSource = _contractMasterBll.GetCopHospit(obj);
                this.AuthorizationSelectorStore.DataBind();
            }
        }
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.HospitalSearchDCMSDialog1.AfterSelectedHandler += SaveAuthorizationAreaHospit;
        }
        #endregion
        [AjaxMethod]
        public string addProduct(string param)
        {
            try
            {
                param = param.Substring(0, param.Length - 1);
                Hashtable obj = new Hashtable();
                obj.Add("ProductString", param);
                obj.Add("ProductLineId", ProductLineId);
                obj.Add("DealerId", DealerId);
                obj.Add("ContractId", ContractId);
                _contractMasterBll.AddContractAreaProduct(obj);
                return "Success";
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

        }
        [AjaxMethod]
        public string addArea(string param)
        {
            try
            {
                param = param.Substring(0, param.Length - 1);
                Hashtable obj = new Hashtable();
                obj.Add("DA_ID", hiddenId.Text);
                obj.Add("AreaString", param);
                _contractMasterBll.AddContractArea(obj);
                return "Success";
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
        #region 私有方法
        private void PageInit()
        {
            //获取上个合同授权数据
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            obj.Add("DealerId", this.DealerId);
            obj.Add("ProductLineId", this.ProductLineId);
            obj.Add("SubBU", this.SubBU);
            obj.Add("BeginDate", this.BeginDate);
            obj.Add("EndDate", this.EndDate);
            obj.Add("PropertyType", "2"); //区域授权
            obj.Add("ContractType", this.ContractType);
            this.LastContractId = _contractMasterBll.GetContractProperty_Last(obj);

            if (this.IsChangeProduct == "0")
            {
                this.btnAdd.Hidden = true;
                this.btnDelete.Hidden = true;
            }
        }

        //获取产品线ID
        private string getProductLineId(string divisionID)
        {
            string productLineId = "00000000-0000-0000-0000-000000000000";
            Hashtable obj = new Hashtable();
            obj.Add("DivisionID", divisionID);
            obj.Add("IsEmerging", "0");
            DataTable dtProductLine = _contractMasterBll.GetProductLineByDivisionID(obj).Tables[0];
            if (dtProductLine.Rows.Count > 0)
            {
                productLineId = dtProductLine.Rows[0]["AttributeID"].ToString();
            }
            return productLineId;
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
            _contractMasterBll.CopeAuthorizatonAreaHospit(obj);

            this.gplAuthHospital.Reload();

            e.Success = true;
        }

        protected void SubmitSelectionArea(object sender, AjaxEventArgs e)
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
            _contractMasterBll.CopeAuthorizatonAreaArea(obj);

            this.GridPanel1.Reload();

            e.Success = true;
        }
        //删除授权医院
        protected void DeleteHospit_Click(object sender, AjaxEventArgs e)
        {
            RowSelectionModel sm = this.gplAuthHospital.SelectionModel.Primary as RowSelectionModel;
            string id = sm.SelectedRow.RecordID;
            if (!string.IsNullOrEmpty(id))
            {
                Hashtable obj = new Hashtable();
                obj.Add("Id", id);
                bool isdeleted = _contractMasterBll.RemoveAreaSelectedHospital(obj);
                e.Success = isdeleted;
            }
        }

        //权限管理
        private void PagePermissions()
        {
            if (this.PageOperationType == "Query")
            {
                this.btnAdd.Hidden = true;
                this.btnDelete.Hidden = true;
                this.BtnAddArea.Hidden = true;
                this.butAreaCopye.Hidden = true;
                this.BtnCaneArea.Hidden = true;
                this.btnAddHospital.Hidden = true;
                this.btnCopyHospital.Hidden = true;
                this.btnDeleteHospital.Hidden = true;
            }
        }
        #endregion
        #region 按钮事件
        public void DeleteAreaAuthorization_Click(object sender, AjaxEventArgs e)
        {
            RowSelectionModel sm = this.gplAuthorization.SelectionModel.Primary as RowSelectionModel;
            string id = sm.SelectedRow.RecordID;
            if (!string.IsNullOrEmpty(id))
            {
                bool isdeleted = _contractMasterBll.DeleteAreaProductSelected(id);
                e.Success = isdeleted;
                this.GridPanel1.Reload();
                this.gplAuthHospital.Reload();
            }
        }

        //public void DeleteAuthorizationArea_Click(object sender, AjaxEventArgs e)
        //{
        //    RowSelectionModel sm = this.GridPanel1.SelectionModel.Primary as RowSelectionModel;
        //    string id = sm.SelectedRow.RecordID;
        //    if (!string.IsNullOrEmpty(id))
        //    {
        //        bool isdeleted = _contractMasterBll.DeleteAreaAreaSelected(id);
        //        e.Success = isdeleted;

        //    }
        //}
        public void SaveAuthorizationAreaHospit(SelectedEventArgs e)
        {
            if (e.Parameters == null) return;

            SelectTerritoryType selectType = (SelectTerritoryType)Enum.Parse(typeof(SelectTerritoryType), e.Parameters["SelectType"]);

            IDictionary<string, string>[] sellist = e.ToDictionarys();
            IDictionary<string, string>[] disSellist = e.GetDisSelectDictionarys();

            IDictionary<string, string>[] selected = null;

            if (disSellist.Length > 0)
            {
                var query = from p in sellist
                            where disSellist.FirstOrDefault(c => c["HosId"] == p["HosId"]) == null
                            select p;

                selected = query.ToArray<IDictionary<string, string>>();
            }
            else

                selected = sellist;

            string hosProvince = e.Parameters["Province"];
            string hosCity = e.Parameters["City"];
            string hosDistrict = e.Parameters["District"];
            string dept = e.Parameters["Dept"];

            //保存同一Division下所有产品线
            Hashtable obj = new Hashtable();
            obj.Add("DclId", this.ContractId);


            Guid datId = new Guid(this.hiddenId.Text);
            Guid lineId = Guid.Empty;
            _contractMasterBll.SaveHospitalOfAuthorizationArea(datId, selected, selectType, hosProvince, hosCity, hosDistrict, lineId, dept);

            this.gplAuthHospital.Reload();
        }
        //删除区域
        protected void AreaTempStore_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            if (this.ContractId != "")
            {
                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);

                ChangeRecords<TerritoryAreaTemp> data = dataHandler.CustomObjectData<TerritoryAreaTemp>();
                IList<TerritoryAreaTemp> selDeleted = data.Deleted;
                Guid[] AreaTempList = (from p in selDeleted select p.Id).ToArray<Guid>();
                _contractMasterBll.DeleteAreaAreaSelected(AreaTempList);
                //如果删除区域最后一条或者全部删除则要删除医院 lijie edit
                if (this.hiddenIsDeleteHospit.Text == "true")
                {
                    _contractMasterBll.DeleteHospitByDaId(hiddenId.Text);

                }
                string hospitalString = "";
                for (int i = 0; i < AreaTempList.Length; i++)
                {
                    hospitalString += (AreaTempList[i].ToString() + ",");
                }
                if (!hospitalString.Equals(""))
                {
                    //Hashtable obj = new Hashtable();
                    //obj.Add("ContractId", this.hidInstanceID.Text);
                    //obj.Add("PartsContractCode", this.hidPartsContractCode.Value.ToString()); //合同产品分类
                    //obj.Add("HospitalString", hospitalString);
                    //obj.Add("RtnVal", "");
                    //obj.Add("RtnMsg", "");
                    //_contractMasterBll.DeleteAuthorizationAOP(obj);
                }
                if (this.hiddenIsDeleteHospit.Text == "true")
                {
                    this.gplAuthHospital.Reload();
                }
                hiddenIsDeleteHospit.Clear();

                e.Cancel = true;
            }
        }
        //删除医院
        protected void AuthorizationHospitStore_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            if (this.hiddenId.Text != string.Empty)
            {
                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);

                ChangeRecords<Hospital> data = dataHandler.CustomObjectData<Hospital>();

                IList<Hospital> selDeleted = data.Deleted;
                Guid[] hosList = (from p in selDeleted select p.HosId).ToArray<Guid>();

                _contractMasterBll.DeleteHospitByDaidHspit(this.hiddenId.Text, hosList);

                e.Cancel = true;
            }
        }
        #endregion
    }
    public class TerritoryAreaTemp
    {
        public Guid Id { set; get; }
        public string Description { set; get; }
        public string Code { set; get; }
    }
}
