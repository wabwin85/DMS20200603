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
    public partial class ContractTerritoryEditor : BasePage
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

        #region PageLoad
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
                    this.PageOperationType = this.Request.QueryString["OperationType"];

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

                    PageInit();
                    PagePermissions();
                }
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            this.HospitalSearchDCMSDialog1.AfterSelectedHandler += OnAfterSelectedHospitalRow;
        }
        #endregion

        #region 数据绑定
        //绑定指定SubBU下所有可选授权分类
        protected void AllProductStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("SubBU", this.SubBU);
            obj.Add("BeginDate", Convert.ToDateTime(this.BeginDate).Year.ToString());
            DataTable dtProduct = _contractMasterBll.GetAuthorizationProductAll(obj).Tables[0];
            AllProductStore.DataSource = dtProduct;
            AllProductStore.DataBind();
        }

        //当前授权产品线
        protected void AuthorizationStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            obj.Add("SubBU", this.SubBU);
            obj.Add("BeginDate", Convert.ToDateTime(this.BeginDate).Year.ToString());
            DataTable dtProduct = _contractMasterBll.GetAuthorizationProductSelected(obj).Tables[0];
            AuthorizationStore.DataSource = dtProduct;
            AuthorizationStore.DataBind();
        }

        protected void DeleteProductStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            int start = 0; int limit = this.DeleteProductPagingToolBar.PageSize;
            if (e.Start > -1)
            {
                start = e.Start;
                limit = e.Limit;
            }
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            obj.Add("LastContractId", this.LastContractId.Equals("")? "00000000-0000-0000-0000-000000000000": this.LastContractId);
            obj.Add("BeginDate", Convert.ToDateTime(this.BeginDate).Year.ToString());
            DataTable dtDeleteProduct = _contractMasterBll.GetDeleteProductQutery(obj, start, limit, out totalCount).Tables[0];
            DeleteProductStore.DataSource = dtDeleteProduct;
            DeleteProductStore.DataBind();
        }

        //加载授权医院
        protected void HospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (this.hiddenId.Text != string.Empty)
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("DealerId", this.DealerId);
                obj.Add("DctId", this.hiddenId.Text);
                obj.Add("BeginDate", this.BeginDate);
                obj.Add("EndDate", this.EndDate);

                obj.Add("start", (e.Start == -1 ? 0 : e.Start / this.PagingToolBar1.PageSize));
                obj.Add("limit", this.PagingToolBar1.PageSize);
                DataSet query = _contractMasterBll.QueryDcmsHospitalSelecedTemp(obj);

                DataTable dtCount = query.Tables[0];
                DataTable dtValue = query.Tables[1];
                DataTable dtProduct = query.Tables[2];

                if (dtValue != null && dtValue.Rows.Count > 0)
                {
                    this.pnlSouth.Title = "包含医院: <img src='/resources/images/icons/flag_ch.png' > </img> 代表本次" + dtProduct.Rows[0]["ProductName"].ToString() + "新授权医院 (共计：" + Convert.ToInt32(dtCount.Rows[0]["CNT"].ToString()) + "家医院)";
                }
                else { this.pnlSouth.Title = "包含医院: <img src='/resources/images/icons/flag_ch.png' > </img> 代表本次" + dtProduct.Rows[0]["ProductName"].ToString() + "新授权医院 (共计：0 家医院)"; }

                (this.HospitalStore.Proxy[0] as DataSourceProxy).TotalCount = Convert.ToInt32(dtCount.Rows[0]["CNT"].ToString());
                this.HospitalStore.DataSource = dtValue;
                this.HospitalStore.DataBind();
            }
        }

        protected void DeleteHospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            int start = 0; int limit = this.DeleteHospitalPagingToolbar.PageSize;
            if (e.Start > -1)
            {
                start = e.Start;
                limit = e.Limit;
            }
            if (this.hiddenId.Text != string.Empty)
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("LastContractId", this.LastContractId.Equals("") ? "00000000-0000-0000-0000-000000000000" : this.LastContractId);
                obj.Add("DctId", this.hiddenId.Text);

                DataTable dtDeleteHospital = _contractMasterBll.GetDeleteHospitalQutery(obj, start, limit, out totalCount).Tables[0];
                (this.DeleteHospitalStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                DeleteHospitalStore.DataSource = dtDeleteHospital;
                DeleteHospitalStore.DataBind();
            }
        }
        

        //删除授权医院
        protected void HospitalStore_BeforeStoreChanged(object sender, BeforeStoreChangedEventArgs e)
        {
            if (this.ContractId != "")
            {
                string json = e.DataHandler.JsonData;
                StoreDataHandler dataHandler = new StoreDataHandler(json);

                ChangeRecords<Hospital> data = dataHandler.CustomObjectData<Hospital>();

                IList<Hospital> selDeleted = data.Deleted;
                Guid[] hosList = (from p in selDeleted select p.Id).ToArray<Guid>();

                _contractMasterBll.DeleteAuthorizationHospitalTemp(hosList);

                string hospitalString = "";
                for (int i = 0; i < hosList.Length; i++)
                {
                    hospitalString += (hosList[i].ToString() + ",");
                }
                if (!hospitalString.Equals(""))
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("ContractId", this.ContractId);
                    obj.Add("PartsContractCode", this.SubBU); //合同产品分类
                    obj.Add("HospitalString", hospitalString);
                    obj.Add("BeginDate", this.BeginDate);
                    obj.Add("RtnVal", "");
                    obj.Add("RtnMsg", "");
                    _contractMasterBll.DeleteAuthorizationAOP(obj);
                }
                this.gpDeleteHospital.Reload();
                e.Cancel = true;
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
                this.AuthorizationSelectorStore.DataSource = _contractMasterBll.GetCopyProductCan(obj);
                this.AuthorizationSelectorStore.DataBind();
            }
        }

        /// <summary>
        /// 科室维护页面产品
        /// </summary>
        protected void ProductTempStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!string.IsNullOrEmpty(this.ContractId))
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("BeginDate", this.BeginDate);
                this.ProductTempStore.DataSource = _contractMasterBll.DepartProductTemp(obj);
                this.ProductTempStore.DataBind();
            }
        }

        /// <summary>
        /// 科室维护页面列表
        /// </summary>
        protected void HospitalProductStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            if (!string.IsNullOrEmpty(this.ContractId))
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("BeginDate", this.BeginDate);
                obj.Add("EndDate", this.EndDate);
                if (!string.IsNullOrEmpty(this.cbDepartProduct.SelectedItem.Value))
                {
                    obj.Add("PctId", this.cbDepartProduct.SelectedItem.Value);
                }
                if (!string.IsNullOrEmpty(this.txtDepartHospitalName.Text))
                {
                    obj.Add("HospitalName", this.txtDepartHospitalName.Text);
                }
                DataSet dsHP = _contractMasterBll.QueryHospitalProductTemp(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);

                (this.HospitalProductStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                this.HospitalProductStore.DataSource = dsHP;
                this.HospitalProductStore.DataBind();
            }
        }

        /// <summary>
        /// 对于产品线科室信息
        /// </summary>
        protected void HospitalDepartStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("Type", "HospitalDepart");
            obj.Add("DivisionCode", this.DivisionId);
            DataSet dsHospitalDepartment = _contractMasterBll.GetHospitalDepartment(obj);

            this.HospitalDepartStore.DataSource = dsHospitalDepartment;
            this.HospitalDepartStore.DataBind();
        }

        #endregion

        #region 按钮事件
        protected void DeleteAuthorization_Click(object sender, AjaxEventArgs e)
        {

            RowSelectionModel sm = this.gplAuthorization.SelectionModel.Primary as RowSelectionModel;
            string id = sm.SelectedRow.RecordID;
            if (!string.IsNullOrEmpty(id))
            {
                bool isdeleted = _contractMasterBll.DeleteProductSelected(id);

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("PartsContractCode", this.SubBU); //合同产品分类
                obj.Add("HospitalString", "");
                obj.Add("BeginDate", this.BeginDate);
                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");
                _contractMasterBll.DeleteAuthorizationAOP(obj);
                e.Success = isdeleted;
            }
        }

        protected void RowSelect(object sender, AjaxEventArgs e)
        {
            try
            {
                DepartClaerInit();
                string editData = e.ExtraParams["HospitalDepartEdite"];
                SelectedEventArgs editArgs = new SelectedEventArgs(editData);
                IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
                if (sellist != null && sellist.Length > 0)
                {
                    //this.hidHosListId.Value = new Guid(sellist[0]["TerritoryId"]);
                    this.txtHidDatId.Value = sellist[0]["Id"].ToString();
                    this.txtHospitalName.Text = sellist[0]["HospitalName"].ToString();
                    this.tetProductName.Text = sellist[0]["ProductName"].ToString();
                    this.txtHospitalDepartment.Text = sellist[0]["Depart"] != null ? sellist[0]["Depart"].ToString() : "";
                    if (sellist[0]["HosDepartTypeName"] != null)
                    {
                        this.txtHospitalDepartType.SelectedItem.Value = sellist[0]["HosDepartTypeName"].ToString();
                    }
                    this.txtHospitalRemark.Text = sellist[0]["DepartRemark"] != null ? sellist[0]["DepartRemark"].ToString() : "";

                    e.Success = true;
                }
            }
            catch
            {
                e.Success = false;
            }
        }


        protected void SaveTerritoryDepart_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("Id", this.txtHidDatId.Text);
                obj.Add("HlaDep", this.txtHospitalDepartment.Text);
                obj.Add("HlaDepType", this.txtHospitalDepartType.SelectedItem.Value);
                obj.Add("HlaDepRemark", this.txtHospitalRemark.Text);
                _contractMasterBll.UpdateHospitalDepartmentTemp(obj);
                e.Success = true;
            }
            catch
            {
                e.Success = false;
            }
        }

        /// <summary>
        /// 选择医院后，添加数据
        /// </summary>
        public void OnAfterSelectedHospitalRow(SelectedEventArgs e)
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


            //IDealerContracts bll = new DealerContracts();

            //Guid datId = new Guid(this.hiddenId.Text);
            string hosProvince = e.Parameters["Province"];
            string hosCity = e.Parameters["City"];
            string hosDistrict = e.Parameters["District"];
            string dept = e.Parameters["Dept"];
            //Guid lineId = new Guid(this.hiddenProductLine.Text);
            //保存同一Division下所有产品线

            if (!this.hiddenId.Text.Equals("") && this.hidHospitalInitType.Text.Equals("alone"))
            {
                _contractMasterBll.SaveHospitalOfAuthorization(new Guid(this.hiddenId.Text), selected, selectType, hosProvince, hosCity, hosDistrict, new Guid(this.ProductLineId), dept);
            }
            else if (this.hidHospitalInitType.Text.Equals("all"))
            {
                Guid conId = new Guid(this.ContractId);
                DataTable dtquery = _contractMasterBll.QueryAuthorizationTempListForDataSet(conId).Tables[0];
                for (int i = 0; i < dtquery.Rows.Count; i++)
                {
                    Guid datId = new Guid(dtquery.Rows[i]["Id"].ToString());
                    Guid lineId = new Guid(dtquery.Rows[i]["ProductLineBumId"].ToString());
                    _contractMasterBll.SaveHospitalOfAuthorization(datId, selected, selectType, hosProvince, hosCity, hosDistrict, lineId, dept);
                }
            }
            this.gplAuthHospital.Reload();
        }

        protected void OnAfterSelectdDelHospitalClosed(SelectedEventArgs e)
        {
            this.gplAuthHospital.Reload();
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
            obj.Add("LastContractId", this.LastContractId);
            _contractMasterBll.CopyHospitalTempFromOtherAuth(obj);

            this.gplAuthHospital.Reload();

            e.Success = true;
        }

        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = _contractMasterBll.ExcelHospitalProductTemp(this.ContractId == "" ? Guid.Empty : new Guid(this.ContractId)).Tables[0];//dt是从后台生成的要导出的datatable
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

        #region AjaxMethod
        [AjaxMethod]
        public void addProduct(string param)
        {
            param = param.Substring(0, param.Length - 1);
            Hashtable obj = new Hashtable();
            obj.Add("ProductString", param);
            obj.Add("ProductLineId", ProductLineId);
            obj.Add("DealerId", DealerId);
            obj.Add("ContractId", ContractId);
            _contractMasterBll.AddContractProduct(obj);
        }

        [AjaxMethod]
        public void UpdateHospitalDepart()
        {
            //1. 清空页面数据
            DepartClaerInit();

            RowSelectionModel sm = this.txtGPHospitalUpdate.SelectionModel.Primary as RowSelectionModel;
            sm.SelectedRows.Clear();
            sm.UpdateSelection();
        }

        [AjaxMethod]
        public void HospitalDepartClear()
        {
            if (!this.txtHidDatId.Text.Equals(""))
            {
                Hashtable obj = new Hashtable();
                obj.Add("Id", this.txtHidDatId.Text);
                _contractMasterBll.HospitalDepartClear(obj);
            }
        }

        #endregion

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
            obj.Add("PropertyType", "0");
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

        //DepartClaerInit
        private void DepartClaerInit()
        {
            this.tetProductName.Text = "";
            this.txtHidDatId.Clear();
            this.txtHospitalName.Text = "";
            this.txtHospitalDepartType.SelectedItem.Value = "";
            this.txtHospitalDepartment.Clear();
            this.txtHospitalRemark.Clear();
        }

        private void PagePermissions()
        {
            if (this.PageOperationType == "Query")
            {
                this.gplAuthorization.ColumnModel.SetHidden(4, true);
                this.btnAdd.Hidden = true;
                this.btnDelete.Hidden = true;
                this.btnAddHospital.Hidden = true;
                this.btnCopyHospital.Hidden = true;
                this.btnDeleteHospital.Hidden = true;
                this.SaveButton.Hidden = true;
                this.ClearButton.Hidden = true;
                this.BtnExecl.Hidden = true;
                this.btnAllProduct.Hidden = true;
            }
        }
        #endregion
    }
}
