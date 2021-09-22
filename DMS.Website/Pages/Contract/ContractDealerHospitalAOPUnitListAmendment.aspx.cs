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
    using Microsoft.Practices.Unity;
    using System.Data;
    using System.Collections;
    public partial class ContractDealerHospitalAOPUnitListAmendment : BasePage
    {
        private IContractMasterBLL _contractMasterBll = new ContractMasterBLL();
        private IContractCommonBLL _contractCommon = new ContractCommonBLL();

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
        public string DealerId
        {
            get
            {
                return this.hidDealerId.Text;
            }
            set
            {
                this.hidDealerId.Text = value.ToString();
            }
        }
        public string DivisionId
        {
            get
            {
                return this.hidDivisionId.Text;
            }
            set
            {
                this.hidDivisionId.Text = value.ToString();
            }
        }

        public string SubBuCode
        {
            get
            {
                return this.hidSubBuCode.Text;
            }
            set
            {
                this.hidSubBuCode.Text = value.ToString();
            }
        }

        public string SubBuId
        {
            get
            {
                return this.hidSubBuId.Text;
            }
            set
            {
                this.hidSubBuId.Text = value.ToString();
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
                return this.hidProductLineId.Text;
            }
            set
            {
                this.hidProductLineId.Text = value.ToString();
            }
        }

        public string BeginDate
        {
            get
            {
                return (this.hidEffectiveDate.Text == "" ? DateTime.Now.ToShortDateString() : this.hidEffectiveDate.Text);
            }
            set
            {
                this.hidEffectiveDate.Text = value.ToString();
            }
        }

        public string EndDate
        {
            get
            {
                return (this.hidExpirationDate.Text == "" ? DateTime.Now.ToShortDateString() : this.hidExpirationDate.Text);
            }
            set
            {
                this.hidExpirationDate.Text = value.ToString();
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

        public string YearString
        {
            get
            {
                return this.hidYearString.Text;
            }
            set
            {
                this.hidYearString.Text = value.ToString();
            }
        }

        public string PageType
        {
            set
            {
                this.hidPageType.Text = value.ToString();
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
        public string CheckSheBei
        {
            get
            {
                return this.hidSheBei.Text;
            }
            set
            {
                this.hidSheBei.Text = value.ToString();
            }
        }
        public string SubBuType
        {
            get
            {
                return this.hidSubBuType.Text;
            }
            set
            {
                this.hidSubBuType.Text = value.ToString();
            }
        }
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            this.PageType = "Unit";
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (this.Request.QueryString["InstanceID"] != null &&
                    this.Request.QueryString["DivisionID"] != null &&
                    this.Request.QueryString["TempDealerID"] != null &&
                    this.Request.QueryString["EffectiveDate"] != null &&
                    this.Request.QueryString["ExpirationDate"] != null &&
                    this.Request.QueryString["PartsContractCode"] != null &&
                    this.Request.QueryString["ContractType"] != null)
                {
                    this.ContractId = this.Request.QueryString["InstanceID"];
                    this.DivisionId = this.Request.QueryString["DivisionID"];
                    this.DealerId = this.Request.QueryString["TempDealerID"];
                    this.BeginDate = this.Request.QueryString["EffectiveDate"];
                    this.EndDate = this.Request.QueryString["ExpirationDate"];
                    this.ContractType = this.Request.QueryString["ContractType"].ToString();
                    this.SubBuCode = this.Request.QueryString["PartsContractCode"];//合同分类Code

                    if (this.Request.QueryString["IsEmerging"] != null)
                    {
                        this.IsEmerging = this.Request.QueryString["IsEmerging"].ToString();
                    }
                    else
                    {
                        this.IsEmerging = "0";
                    }
                    this.PageOperationType = this.Request.QueryString["OperationType"];
                    SetInitialValue();
                    SynchronousFormalAOPToTemp();
                    PagePermissions();
                }
            }
        }

        #region 数据绑定
        public void AOPHospitalProductStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                int totalCount = 0;
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                if (this.LastContractId == "")
                {
                    obj.Add("LastContractId", "00000000-0000-0000-0000-000000000000");
                }
                else
                {
                    obj.Add("LastContractId", this.LastContractId);
                }

                if (!string.IsNullOrEmpty(this.txtQueryHospitalName.Text))
                {
                    obj.Add("HospitalName", this.txtQueryHospitalName.Text);
                }
                if (!string.IsNullOrEmpty(this.txtQueryProductName.Text))
                {
                    obj.Add("ProductName", this.txtQueryProductName.Text);
                }

                int start = 0; int limit = this.PagingToolBarAOP.PageSize;
                if (e.Start > -1)
                {
                    start = e.Start;
                    limit = e.Limit;
                }
                DataTable dt = _contractCommon.QueryHospitalProductAmountAmendmentTemp2(obj, start, limit, out totalCount).Tables[0];
                if (sender is Store)
                {
                    Store store1 = (sender as Store);
                    (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                    store1.DataSource = dt;
                    store1.DataBind();
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }
        public void AOPHospitalEditer_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                int totalCount = 0;
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                DataTable dt = _contractCommon.QueryHospitalCurrentAOP(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarEditer.PageSize : e.Limit), out totalCount).Tables[0];
                if (sender is Store)
                {
                    Store store1 = (sender as Store);
                    (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                    store1.DataSource = dt;
                    store1.DataBind();
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }
        public void AOPDealerStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            if (this.LastContractId == "")
            {
                obj.Add("LastContractId", "00000000-0000-0000-0000-000000000000");
            }
            else
            {
                obj.Add("LastContractId", this.LastContractId);
            }

            DataTable dt = _contractCommon.QueryDealerAOPTempUnitAmendment(obj).Tables[0];
            if (sender is Store)
            {
                Store store1 = (sender as Store);
                (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                store1.DataSource = dt;
                store1.DataBind();
            }
        }
        public void DealerAopYearStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            DataTable dt = _contractCommon.GetDealerIndexTempYears(obj).Tables[0];
            DealerAopYearStore.DataSource = dt;
            DealerAopYearStore.DataBind();
        }
        public void AOPHospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            obj.Add("DealerDmaId", this.DealerId);
            obj.Add("ProductLineBumId", this.ProductLineId);
            if (!string.IsNullOrEmpty(this.txtHospital.Text))
            {
                obj.Add("HospitalName", this.txtHospital.Text);
            }

            obj.Add("QueryType", "1");
            DataSet query = _contractCommon.QueryHospitalUnitAopTempP(obj, (e.Start == -1 ? 0 : e.Start / this.PagingToolBar1.PageSize), this.PagingToolBar1.PageSize);

            DataTable dtCount = query.Tables[0];
            DataTable dtValue = query.Tables[1];

            (this.AOPHospitalStore.Proxy[0] as DataSourceProxy).TotalCount = Convert.ToInt32(dtCount.Rows[0]["CNT"].ToString());
            AOPHospitalStore.DataSource = dtValue;
            AOPHospitalStore.DataBind();
        }
        public void AOPProductStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
          
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            obj.Add("DealerDmaId", this.DealerId);
            obj.Add("ProductLineBumId", this.ProductLineId);
            if (!string.IsNullOrEmpty(this.tfProdutName.Text))
            {
                obj.Add("ProductName", this.tfProdutName.Text);
            }

            obj.Add("QueryType", "2");
            DataSet query = _contractCommon.QueryHospitalUnitAopTempP(obj, (e.Start == -1 ? 0 : e.Start / this.PagingToolBarProduct.PageSize), this.PagingToolBarProduct.PageSize);

            DataTable dtCount = query.Tables[0];
            DataTable dtValue = query.Tables[1];

            (this.AOPProductStore.Proxy[0] as DataSourceProxy).TotalCount = Convert.ToInt32(dtCount.Rows[0]["CNT"].ToString());
            AOPProductStore.DataSource = dtValue;
            AOPProductStore.DataBind();
        }
        #endregion
      
        #region 按钮事件
        protected void RowSelect(object sender, AjaxEventArgs e)
        {
            ClearHospitalWindow();
            ClearHospitalValuePage();


            string editData = e.ExtraParams["HospitalAOPEditer"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                Guid?[] productLineBumId = new Guid?[1];
                productLineBumId[0] = new Guid(sellist[0]["ProductLineId"]);

                string hospitalid = sellist[0]["HospitalId"].ToString();
                string Productification = sellist[0]["ProductId"].ToString();
                string year = sellist[0]["Year"].ToString();

                SetHospitalWindow(hospitalid, Productification, year);
                SetHospitalValuePage(year);
                e.Success = true;
            }
        }

        protected void ExportHospitalExcel(object sender, EventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            DataTable dt = _contractMasterBll.ExportAopDealersHospitalByQuery(obj).Tables[0];
            Excel(dt, "DealerHospitalProductAOP.xls");
        }
        #endregion

        #region Ajax Method
        [AjaxMethod]
        public void HospitalProductWindowsShow(string hospitalId, string productId, string year)
        {

            ClearHospitalValuePage();
            SetHospitalValuePage(year);
            ClearHospitalWindow();
            SetHospitalWindow(hospitalId, productId, year);

            this.AOPHospitalWindow.Show();
        }
        [AjaxMethod]
        public string SubmintHospitalAOP()
        {
            string retMassage = "";
            VAopDealerHospitalTemp aopdealers = new VAopDealerHospitalTemp();
            aopdealers.DealerDmaId = new Guid(this.DealerId);
            aopdealers.ProductLineBumId = new Guid(this.ProductLineId);
            aopdealers.PctId = new Guid(this.hidClassification.Text);
            aopdealers.HospitalId = new Guid(this.hidHospitalID.Text);
            aopdealers.MarketType = this.IsEmerging.Equals("") ? "0" : this.hidIsEmerging.Text;

            double AOPValue = 0;
            double FormalValue = 0;
            for (int i = 1; i <= 12; i++)
            {
                TextField tempUnit = this.FindControl("txtUnit_" + i.ToString()) as TextField;
                TextField tempFormalUnit = this.FindControl("txtFormalUnit_" + i.ToString()) as TextField;
                AOPValue += double.Parse(tempUnit.Text);
                FormalValue += double.Parse(tempFormalUnit.Text);
            }
            if (this.hospitaleRemark.Text.Equals(""))
            {
                if (Math.Round(AOPValue, 4) != Math.Round(FormalValue, 4) && FormalValue!=0)
                {
                    retMassage = "实际指标不等于标准指标，请填写原因";
                }
            }
            else
            {
                //Save Remark
                AopRemark ar = new AopRemark();
                ar.Id = Guid.NewGuid();
                ar.Type = "Hospital";
                ar.Contractid = new Guid(this.ContractId);
                ar.HosId = new Guid(this.hidHospitalID.Text);
                ar.Body = this.hospitaleRemark.Text;
                ar.Rv1 = this.hidClassification.Text.ToString();

                _contractMasterBll.DeleteAopRemark(ar);
                _contractMasterBll.SaveAopRemark(ar);
            }

            if (retMassage == "")
            {
                aopdealers.Year = this.hidentxtYear.Value.ToString();
                aopdealers.Amount1 = double.Parse(this.txtUnit_1.Text);
                aopdealers.Amount2 = double.Parse(this.txtUnit_2.Text);
                aopdealers.Amount3 = double.Parse(this.txtUnit_3.Text);
                aopdealers.Amount4 = double.Parse(this.txtUnit_4.Text);
                aopdealers.Amount5 = double.Parse(this.txtUnit_5.Text);
                aopdealers.Amount6 = double.Parse(this.txtUnit_6.Text);
                aopdealers.Amount7 = double.Parse(this.txtUnit_7.Text);
                aopdealers.Amount8 = double.Parse(this.txtUnit_8.Text);
                aopdealers.Amount9 = double.Parse(this.txtUnit_9.Text);
                aopdealers.Amount10 = double.Parse(this.txtUnit_10.Text);
                aopdealers.Amount11 = double.Parse(this.txtUnit_11.Text);
                aopdealers.Amount12 = double.Parse(this.txtUnit_12.Text);

                int MinMonth = 1;
                if (Convert.ToDateTime(this.BeginDate).Year.ToString().Equals(this.hidentxtYear.Text.ToString()))
                {
                    MinMonth = Convert.ToDateTime(this.BeginDate).Month;
                    if (!CheckSheBei.Equals("1"))
                    {
                        MinMonth += 1;
                    }
                }
                bool mctl = _contractCommon.SaveHospitalProductAOPUnitMerge(new Guid(this.ContractId), this.SubBuCode, aopdealers, MinMonth);
            }
            return retMassage;
        }
        [AjaxMethod]
        public void DealerWindowsShow(string year)
        {
            this.hidUpdateDealerYear.Text = year;
            ClearDealerValuePage();
            SetDealerValuePage(year);
            SetDealerPageValueInit(year);
            this.AOPDealerWindow.Show();
        }
        [AjaxMethod]
        public void ChangePageDealerAOP(string year)
        {
            this.hidUpdateDealerYear.Text = year;
            ClearDealerValuePage();
            SetDealerValuePage(year);
            SetDealerPageValueInit(year);

        }
        [AjaxMethod]
        public string SubmintDealerAOP()
        {
            string massage = "";
            if (this.nfAmount1.Value.ToString().Equals("") || this.nfAmount2.Value.ToString().Equals("") || this.nfAmount3.Value.ToString().Equals("")
                || this.nfAmount4.Value.ToString().Equals("") || this.nfAmount5.Value.ToString().Equals("") || this.nfAmount6.Value.ToString().Equals("")
                || this.nfAmount7.Value.ToString().Equals("") || this.nfAmount8.Value.ToString().Equals("") || this.nfAmount9.Value.ToString().Equals("")
                || this.nfAmount10.Value.ToString().Equals("") || this.nfAmount11.Value.ToString().Equals("") || this.nfAmount12.Value.ToString().Equals(""))
            {
                massage = "请完整填写经销商指标信息";
            }
            if (massage != "") return massage;
            VAopDealer aopdealers = new VAopDealer();
            aopdealers.DealerDmaId = new Guid(this.DealerId);

            aopdealers.Year = this.cbDelaerAopYear.SelectedItem.Value;
            aopdealers.Amount1 = this.nfAmount1.Number;
            aopdealers.Amount2 = this.nfAmount2.Number;
            aopdealers.Amount3 = this.nfAmount3.Number;
            aopdealers.Amount4 = this.nfAmount4.Number;
            aopdealers.Amount5 = this.nfAmount5.Number;
            aopdealers.Amount6 = this.nfAmount6.Number;
            aopdealers.Amount7 = this.nfAmount7.Number;
            aopdealers.Amount8 = this.nfAmount8.Number;
            aopdealers.Amount9 = this.nfAmount9.Number;
            aopdealers.Amount10 = this.nfAmount10.Number;
            aopdealers.Amount11 = this.nfAmount11.Number;
            aopdealers.Amount12 = this.nfAmount12.Number;
            aopdealers.ProductLineBumId = new Guid(this.ProductLineId);
            aopdealers.MarketType = this.IsEmerging;


            double totalDealerAop = Math.Round(aopdealers.Amount1 + aopdealers.Amount2 + aopdealers.Amount3 + aopdealers.Amount4 + aopdealers.Amount5 + aopdealers.Amount6 + aopdealers.Amount7 + aopdealers.Amount8 + aopdealers.Amount9 + aopdealers.Amount10 + aopdealers.Amount11 + aopdealers.Amount12,2);

            AopRemark ar = new AopRemark();
            ar.Type = "Dealer";
            ar.Contractid = new Guid(this.ContractId.ToString());

            double hosAmounttotal = Math.Round(double.Parse(this.hidReReAmountTL.Text.Equals("") ? "0" : this.hidReReAmountTL.Text),2);


            if (((totalDealerAop - hosAmounttotal) >= 0 && ((hosAmounttotal == 0 || ((totalDealerAop - hosAmounttotal) / hosAmounttotal) < 0.1) || this.SubBuType.Equals("0"))) || !this.txtDealerAopRemark.Text.Equals(""))
            {
                bool mctl = _contractCommon.SaveAopDealerTemp(this.ContractId, this.SubBuId, aopdealers);
                _contractMasterBll.DeleteAopRemark(ar);
                ar.Body = this.txtDealerAopRemark.Text;
                ar.Id = Guid.NewGuid();
                _contractMasterBll.SaveAopRemark(ar);
            }
            else
            {
                if (this.SubBuType.Equals("0"))
                {
                    massage = "请填写经销商指标小于医院指标原因";
                }
                else
                {
                    massage = "请填写经销商指标小于医院指标或大于医院指标10%原因";
                }
            }
            return massage;
        }

        #endregion

        #region 初始化参数与指标
        private void SetInitialValue()
        {
            // 1. 获取产品线ID
            this.ProductLineId = GetProductLineId(this.DivisionId);
            // 2. 获取合同年份跨度
            int Effective = Convert.ToDateTime(this.BeginDate).Year;
            int Expiration = Convert.ToDateTime(this.EndDate).Year;
            string year = null;

            for (int getYear = Effective; getYear <= Expiration; getYear++)
            {
                year += (getYear.ToString() + ',');
            }
            this.YearString = year;

            //3.获取合同分类ID
            this.SubBuId = PartsContractId(this.SubBuCode);

            //4.获取合同分类修改类型
            this.CheckSheBei = _contractCommon.CheckSubBUType(this.SubBuCode);
        }
        private string GetProductLineId(string divisionID)
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
        private string PartsContractId(string PartsContractCode)
        {
            string partsContractId = "00000000-0000-0000-0000-000000000000";
            this.SubBuType = "1";
            Hashtable obj = new Hashtable();
            obj.Add("PartsContractCode", PartsContractCode);
            obj.Add("ProductYear", Convert.ToDateTime(this.BeginDate).Year.ToString());
            ClassificationContract pcc = _contractCommon.GetPartContractIdByCCCode(obj)[0];
            if (pcc != null)
            {
                partsContractId = pcc.Id.ToString();
                this.SubBuType = pcc.Rv2 == null ? "1" : (pcc.Rv2.ToString().Equals("1") ? "0" : "1");
            }
            return partsContractId;
        }

        //初始化指标
        private void SynchronousFormalAOPToTemp()
        {
            Guid conId = new Guid(this.ContractId);
            DataTable dtCheck = _contractMasterBll.QueryAuthorizationTempListForDataSet(conId).Tables[0];
            if (dtCheck.Rows.Count == 0 && this.ContractType.Equals("Appointment"))
            {
                Ext.MessageBox.Alert("错误", "请先维护经销商授权！").Show();
                return;
            }
            else if (dtCheck.Rows.Count == 0 && !this.ContractType.Equals("Appointment"))
            {
                //获取上个合同授权数据
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("DealerId", this.DealerId);
                obj.Add("ProductLineId", this.ProductLineId);
                obj.Add("SubBU", this.SubBuCode);
                obj.Add("BeginDate", this.BeginDate);
                obj.Add("EndDate", this.EndDate);
                obj.Add("PropertyType", "0");
                obj.Add("ContractType", this.ContractType);
                _contractMasterBll.GetContractProperty_Last(obj);
            }

            PageInit();
            SynchronousDealerAopTemp();
        }

        private void PageInit()
        {
            //获取上个合同指标数据
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            obj.Add("DealerId", this.DealerId);
            obj.Add("ProductLineId", this.ProductLineId);
            obj.Add("SubBU", this.SubBuCode);
            obj.Add("BeginDate", this.BeginDate);
            obj.Add("EndDate", this.EndDate);
            obj.Add("PropertyType", "1");
            obj.Add("ContractType", this.ContractType);
            this.LastContractId = _contractMasterBll.GetContractProperty_Last(obj);
        }

        private void PagePermissions()
        {
            if (this.PageOperationType == "Query")
            {
                this.btnInputRule.Hidden = true;
                this.SaveUnitButton.Hidden = true;
                this.SaveDealerButton.Hidden = true;
            }
        }

        private void SynchronousDealerAopTemp()
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("LastContractId", this.LastContractId);
                obj.Add("DealerId", this.DealerId);
                obj.Add("ProductLineId", this.ProductLineId);
                obj.Add("SubBU", this.SubBuCode);
                obj.Add("MarketType", this.IsEmerging);
                obj.Add("YearString", this.YearString);
                obj.Add("BeginDate", this.BeginDate);
                obj.Add("EndDate", this.EndDate);
                obj.Add("AOPType", "Unit");
                obj.Add("SyType", "2");
                obj.Add("ContractType", this.ContractType);
                _contractCommon.DealerAOPMerge(obj);
            }
            catch (Exception ex)
            {

            }
        }
        #endregion

        #region 医院维护页面清理与赋值
        //清空值
        private void ClearHospitalWindow()
        {
            this.hidClassification.Clear();
            this.hidProdLineID.Clear();
            this.txtYear.Text = "";
            this.txtHospitalName.Text = "";
            this.txtClassificationName.Text = "";
            this.hidHospitalID.Clear();
            this.hidentxtYear.Clear();
            this.txtFormalUnit_1.Text = "0";
            this.txtFormalUnit_2.Text = "0";
            this.txtFormalUnit_3.Text = "0";
            this.txtFormalUnit_4.Text = "0";
            this.txtFormalUnit_5.Text = "0";
            this.txtFormalUnit_6.Text = "0";
            this.txtFormalUnit_7.Text = "0";
            this.txtFormalUnit_8.Text = "0";
            this.txtFormalUnit_9.Text = "0";
            this.txtFormalUnit_10.Text = "0";
            this.txtFormalUnit_11.Text = "0";
            this.txtFormalUnit_12.Text = "0";
            this.txtReUnit_1.Text = "0";
            this.txtReUnit_2.Text = "0";
            this.txtReUnit_3.Text = "0";
            this.txtReUnit_4.Text = "0";
            this.txtReUnit_5.Text = "0";
            this.txtReUnit_6.Text = "0";
            this.txtReUnit_7.Text = "0";
            this.txtReUnit_8.Text = "0";
            this.txtReUnit_9.Text = "0";
            this.txtReUnit_10.Text = "0";
            this.txtReUnit_11.Text = "0";
            this.txtReUnit_12.Text = "0";
            this.txtUnit_1.Text = "0";
            this.txtUnit_2.Text = "0";
            this.txtUnit_3.Text = "0";
            this.txtUnit_4.Text = "0";
            this.txtUnit_5.Text = "0";
            this.txtUnit_6.Text = "0";
            this.txtUnit_7.Text = "0";
            this.txtUnit_8.Text = "0";
            this.txtUnit_9.Text = "0";
            this.txtUnit_10.Text = "0";
            this.txtUnit_11.Text = "0";
            this.txtUnit_12.Text = "0";
            this.hospitaleRemark.Clear();
        }
        public void SetHospitalWindow(string hospitalId, string productId, string year)
        {
            //1. 获取标准指标
            Hashtable obj = new Hashtable();
            obj.Add("ProductLineId", this.ProductLineId);
            obj.Add("HospitalId", hospitalId);
            obj.Add("ProductId", productId);
            obj.Add("Year", year);
            DataTable dtCriterion = _contractCommon.GetHospitalCriterionAOP(obj).Tables[0];
            if (dtCriterion.Rows.Count > 0)
            {
                DataRow drCriterion = dtCriterion.Rows[0];
                this.txtReUnit_1.Text = drCriterion["Amount1"].ToString();
                this.txtReUnit_2.Text = drCriterion["Amount2"].ToString();
                this.txtReUnit_3.Text = drCriterion["Amount3"].ToString();
                this.txtReUnit_4.Text = drCriterion["Amount4"].ToString();
                this.txtReUnit_5.Text = drCriterion["Amount5"].ToString();
                this.txtReUnit_6.Text = drCriterion["Amount6"].ToString();
                this.txtReUnit_7.Text = drCriterion["Amount7"].ToString();
                this.txtReUnit_8.Text = drCriterion["Amount8"].ToString();
                this.txtReUnit_9.Text = drCriterion["Amount9"].ToString();
                this.txtReUnit_10.Text = drCriterion["Amount10"].ToString();
                this.txtReUnit_11.Text = drCriterion["Amount11"].ToString();
                this.txtReUnit_12.Text = drCriterion["Amount12"].ToString();

            }
            //2. 获取历史指标
            if (this.LastContractId != "00000000-0000-0000-0000-000000000000" && this.LastContractId != "")
            {
                obj.Add("LastContractId", this.LastContractId);
                DataTable dtHistory = _contractCommon.GetHospitalHistoryAOP(obj).Tables[0];
                if (dtHistory.Rows.Count > 0)
                {
                    DataRow drHistory = dtHistory.Rows[0];
                    this.txtFormalUnit_1.Text = drHistory["Amount1"].ToString();
                    this.txtFormalUnit_2.Text = drHistory["Amount2"].ToString();
                    this.txtFormalUnit_3.Text = drHistory["Amount3"].ToString();
                    this.txtFormalUnit_4.Text = drHistory["Amount4"].ToString();
                    this.txtFormalUnit_5.Text = drHistory["Amount5"].ToString();
                    this.txtFormalUnit_6.Text = drHistory["Amount6"].ToString();
                    this.txtFormalUnit_7.Text = drHistory["Amount7"].ToString();
                    this.txtFormalUnit_8.Text = drHistory["Amount8"].ToString();
                    this.txtFormalUnit_9.Text = drHistory["Amount9"].ToString();
                    this.txtFormalUnit_10.Text = drHistory["Amount10"].ToString();
                    this.txtFormalUnit_11.Text = drHistory["Amount11"].ToString();
                    this.txtFormalUnit_12.Text = drHistory["Amount12"].ToString();
                }
            }
            //3. 获取当前合同指标
            obj.Add("ContractId", this.ContractId);
            DataTable dtFormal = _contractCommon.GetHospitalCurrentAOP(obj).Tables[0];
            if (dtFormal.Rows.Count > 0)
            {
                DataRow drFormal = dtFormal.Rows[0];
                this.txtUnit_1.Text = drFormal["Amount1"].ToString();
                this.txtUnit_2.Text = drFormal["Amount2"].ToString();
                this.txtUnit_3.Text = drFormal["Amount3"].ToString();
                this.txtUnit_4.Text = drFormal["Amount4"].ToString();
                this.txtUnit_5.Text = drFormal["Amount5"].ToString();
                this.txtUnit_6.Text = drFormal["Amount6"].ToString();
                this.txtUnit_7.Text = drFormal["Amount7"].ToString();
                this.txtUnit_8.Text = drFormal["Amount8"].ToString();
                this.txtUnit_9.Text = drFormal["Amount9"].ToString();
                this.txtUnit_10.Text = drFormal["Amount10"].ToString();
                this.txtUnit_11.Text = drFormal["Amount11"].ToString();
                this.txtUnit_12.Text = drFormal["Amount12"].ToString();
                this.hospitaleRemark.Text = drFormal["RmkBody"].ToString();

                this.txtClassificationName.Text = drFormal["ProductName"].ToString();
                this.hidHospitalID.Value = drFormal["HospitalId"].ToString();
                this.txtHospitalName.Text = drFormal["HospitalName"].ToString();
                this.hidProdLineID.Value = this.ProductLineId;
                this.txtYear.Text = drFormal["Year"].ToString();
                this.hidentxtYear.Value = drFormal["Year"].ToString();
                this.hidClassification.Value = drFormal["ProductId"].ToString();
            }
        }

        private void ClearHospitalValuePage()
        {
            this.txtUnit_1.Enabled = false;
            this.txtUnit_2.Enabled = false;
            this.txtUnit_3.Enabled = false;
            this.txtUnit_4.Enabled = false;
            this.txtUnit_5.Enabled = false;
            this.txtUnit_6.Enabled = false;
            this.txtUnit_7.Enabled = false;
            this.txtUnit_8.Enabled = false;
            this.txtUnit_9.Enabled = false;
            this.txtUnit_10.Enabled = false;
            this.txtUnit_11.Enabled = false;
            this.txtUnit_12.Enabled = false;
        }

        private void SetHospitalValuePage(string year)
        {
            if (year == Convert.ToDateTime(this.BeginDate).Year.ToString())
            {
                int minMonth = 0;
                if (Convert.ToDateTime(this.BeginDate).Month <= DateTime.Now.Month && Convert.ToDateTime(this.BeginDate).Year == DateTime.Now.Year && !CheckSheBei.Equals("1"))
                {
                    minMonth = Convert.ToDateTime(this.BeginDate).Month + 1;
                }
                else
                {
                    minMonth = Convert.ToDateTime(this.BeginDate).Month;
                }
                for (int i = minMonth; i <= 12; i++)
                {
                    TextField tempUnit = this.FindControl("txtUnit_" + i.ToString()) as TextField;
                  
                    if (year == Convert.ToDateTime(this.EndDate).Year.ToString() && Convert.ToDateTime(this.EndDate).Month < i)
                    {
                        tempUnit.Enabled = false;
                    }
                    else
                    {
                        tempUnit.Enabled = true;
                    }
                }
            }
            else
            {
                for (int i = 1; i <= 12; i++)
                {
                    TextField tempUnit = this.FindControl("txtUnit_" + i.ToString()) as TextField;
                  
                    if (year == Convert.ToDateTime(this.EndDate).Year.ToString() && Convert.ToDateTime(this.EndDate).Month < i)
                    {
                        tempUnit.Enabled = false;
                    }
                    else
                    {
                        tempUnit.Enabled = true;
                    }
                }
            }
        }
        #endregion

        #region 经销商维护页面清理与赋值
        private void SetDealerPageValueInit(string yearDealerAOP)
        {
            ClaerDealerPageValue();
            Hashtable obj = new Hashtable();
            if (yearDealerAOP != "")
            {
                obj.Add("AopYear", yearDealerAOP);
            }
            obj.Add("ContractId", this.ContractId);
            DataTable dtAop = _contractCommon.GetDealerTempIndex(obj).Tables[0];
            DataTable dtHospitalAop = _contractCommon.GetHospitalTempIndexUnitToAmountSum(obj).Tables[0];
            SetDealerPageValue(dtAop);
            SetDealerHospitalPageValue(dtHospitalAop);

            if (this.LastContractId != "" && this.LastContractId != "00000000-0000-0000-0000-000000000000")
            {
                obj.Add("LastContractId", this.LastContractId);
                DataTable dtHisAop = _contractCommon.GetDelaerHistoryAOP(obj).Tables[0];
                SetDealerHisPageValue(dtHisAop);
            }

            DataRow drDealer = null;
            DataRow drHospital = null;
            if (dtAop.Rows.Count > 0)
            {
                drDealer = dtAop.Rows[0];
                decimal Q1 = Math.Round(Convert.ToDecimal(drDealer["Q1"]), 2);
                decimal Q2 = Math.Round(Convert.ToDecimal(drDealer["Q2"]), 2);
                decimal Q3 = Math.Round(Convert.ToDecimal(drDealer["Q3"]), 2);
                decimal Q4 = Math.Round(Convert.ToDecimal(drDealer["Q4"]), 2);
                decimal Y = Math.Round(Convert.ToDecimal(drDealer["AmountY"]), 2);

                if (dtHospitalAop.Rows.Count > 0)
                {
                    drHospital = dtHospitalAop.Rows[0];

                    decimal diffQ1 = Q1 - Math.Round(Convert.ToDecimal(drHospital["ReQ1"]), 2);
                    decimal diffQ2 = Q2 - Math.Round(Convert.ToDecimal(drHospital["ReQ2"]), 2);
                    decimal diffQ3 = Q3 - Math.Round(Convert.ToDecimal(drHospital["ReQ3"]), 2);
                    decimal diffQ4 = Q4 - Math.Round(Convert.ToDecimal(drHospital["ReQ4"]), 2);
                    decimal diffY = Y - Math.Round(Convert.ToDecimal(drHospital["ReAmountY"]), 2);

                    this.labDiffQ1.Text = "Q1差异：" + diffQ1.ToString();
                    this.labDiffQ2.Text = "Q2差异：" + diffQ2.ToString();
                    this.labDiffQ3.Text = "Q3差异：" + diffQ3.ToString();
                    this.labDiffQ4.Text = "Q4差异：" + diffQ4.ToString();
                    this.labDiffY.Text = "全年差异：" + diffY.ToString();
                }
                else
                {
                    this.labDiffQ1.Text = "Q1差异" + Q1.ToString();
                    this.labDiffQ2.Text = "Q2差异" + Q2.ToString();
                    this.labDiffQ3.Text = "Q3差异" + Q3.ToString();
                    this.labDiffQ4.Text = "Q4差异" + Q4.ToString();
                    this.labDiffY.Text = "全年差异" + Y.ToString();

                }
            }
        }

        //清空值
        private void ClaerDealerPageValue()
        {
            this.txtReAmount1.Text = "0";
            this.txtReAmount2.Text = "0";
            this.txtReAmount3.Text = "0";
            this.txtReAmount4.Text = "0";
            this.txtReAmount5.Text = "0";
            this.txtReAmount6.Text = "0";
            this.txtReAmount7.Text = "0";
            this.txtReAmount8.Text = "0";
            this.txtReAmount9.Text = "0";
            this.txtReAmount10.Text = "0";
            this.txtReAmount11.Text = "0";
            this.txtReAmount12.Text = "0";
            this.txtHisAmount1.Text = "0";
            this.txtHisAmount2.Text = "0";
            this.txtHisAmount3.Text = "0";
            this.txtHisAmount4.Text = "0";
            this.txtHisAmount5.Text = "0";
            this.txtHisAmount6.Text = "0";
            this.txtHisAmount7.Text = "0";
            this.txtHisAmount8.Text = "0";
            this.txtHisAmount9.Text = "0";
            this.txtHisAmount10.Text = "0";
            this.txtHisAmount11.Text = "0";
            this.txtHisAmount12.Text = "0";
            this.txtHisAmountQ1.Text = "0";
            this.txtHisAmountQ2.Text = "0";
            this.txtHisAmountQ3.Text = "0";
            this.txtHisAmountQ4.Text = "0";
            this.txtHisAmountTL.Text = "0";

            this.hidReReAmountTL.Clear();

            this.nfAmount1.Number = 0;
            this.nfAmount2.Number = 0;
            this.nfAmount3.Number = 0;
            this.nfAmount4.Number = 0;
            this.nfAmount5.Number = 0;
            this.nfAmount6.Number = 0;
            this.nfAmount7.Number = 0;
            this.nfAmount8.Number = 0;
            this.nfAmount9.Number = 0;
            this.nfAmount10.Number = 0;
            this.nfAmount11.Number = 0;
            this.nfAmount12.Number = 0;
            this.nfAmountQ1.Text = "";
            this.nfAmountQ2.Text = "";
            this.nfAmountQ3.Text = "";
            this.nfAmountQ4.Text = "";
            this.nfAmountTL.Text = "";

            this.labDiffQ1.Text = "";
            this.labDiffQ2.Text = "";
            this.labDiffQ3.Text = "";
            this.labDiffQ4.Text = "";
            this.labDiffY.Text = "";

            this.txtDealerAopRemark.Text = "";
        }
        public void SetDealerPageValue(DataTable tabAop)
        {
            if (tabAop.Rows.Count > 0)
            {
                DataRow drAop = tabAop.Rows[0];
                this.nfAmount1.Number = (drAop["Amount1"] != null) ? Convert.ToDouble(drAop["Amount1"]) : 0;
                this.nfAmount2.Number = (drAop["Amount2"] != null) ? Convert.ToDouble(drAop["Amount2"]) : 0;
                this.nfAmount3.Number = (drAop["Amount3"] != null) ? Convert.ToDouble(drAop["Amount3"]) : 0;
                this.nfAmount4.Number = (drAop["Amount4"] != null) ? Convert.ToDouble(drAop["Amount4"]) : 0;
                this.nfAmount5.Number = (drAop["Amount5"] != null) ? Convert.ToDouble(drAop["Amount5"]) : 0;
                this.nfAmount6.Number = (drAop["Amount6"] != null) ? Convert.ToDouble(drAop["Amount6"]) : 0;
                this.nfAmount7.Number = (drAop["Amount7"] != null) ? Convert.ToDouble(drAop["Amount7"]) : 0;
                this.nfAmount8.Number = (drAop["Amount8"] != null) ? Convert.ToDouble(drAop["Amount8"]) : 0;
                this.nfAmount9.Number = (drAop["Amount9"] != null) ? Convert.ToDouble(drAop["Amount9"]) : 0;
                this.nfAmount10.Number = (drAop["Amount10"] != null) ? Convert.ToDouble(drAop["Amount10"]) : 0;
                this.nfAmount11.Number = (drAop["Amount11"] != null) ? Convert.ToDouble(drAop["Amount11"]) : 0;
                this.nfAmount12.Number = (drAop["Amount12"] != null) ? Convert.ToDouble(drAop["Amount12"]) : 0;
                this.nfAmountQ1.Text = Math.Round(Convert.ToDecimal(drAop["Q1"]), 2).ToString();
                this.nfAmountQ2.Text = Math.Round(Convert.ToDecimal(drAop["Q2"]), 2).ToString();
                this.nfAmountQ3.Text = Math.Round(Convert.ToDecimal(drAop["Q3"]), 2).ToString();
                this.nfAmountQ4.Text = Math.Round(Convert.ToDecimal(drAop["Q4"]), 2).ToString();
                this.nfAmountTL.Text = Math.Round(Convert.ToDecimal(drAop["AmountY"]), 2).ToString();

                this.txtDealerAopRemark.Text = (drAop["RmkBody"] != null) ? drAop["RmkBody"].ToString() : "";
            }
        }
        public void SetDealerHospitalPageValue(DataTable tabAop)
        {
            if (tabAop.Rows.Count > 0)
            {
                DataRow drAop = tabAop.Rows[0];
                this.txtReAmount1.Text = drAop["ReAmount1"].ToString();
                this.txtReAmount2.Text = drAop["ReAmount2"].ToString();
                this.txtReAmount3.Text = drAop["ReAmount3"].ToString();
                this.txtReAmount4.Text = drAop["ReAmount4"].ToString();
                this.txtReAmount5.Text = drAop["ReAmount5"].ToString();
                this.txtReAmount6.Text = drAop["ReAmount6"].ToString();
                this.txtReAmount7.Text = drAop["ReAmount7"].ToString();
                this.txtReAmount8.Text = drAop["ReAmount8"].ToString();
                this.txtReAmount9.Text = drAop["ReAmount9"].ToString();
                this.txtReAmount10.Text = drAop["ReAmount10"].ToString();
                this.txtReAmount11.Text = drAop["ReAmount11"].ToString();
                this.txtReAmount12.Text = drAop["ReAmount12"].ToString();
                this.txtReAmountQ1.Text = Math.Round(Convert.ToDecimal(drAop["ReQ1"]), 2).ToString();
                this.txtReAmountQ2.Text = Math.Round(Convert.ToDecimal(drAop["ReQ2"]), 2).ToString();
                this.txtReAmountQ3.Text = Math.Round(Convert.ToDecimal(drAop["ReQ3"]), 2).ToString();
                this.txtReAmountQ4.Text = Math.Round(Convert.ToDecimal(drAop["ReQ4"]), 2).ToString();
                this.txtReAmountTL.Text = Math.Round(Convert.ToDecimal(drAop["ReAmountY"]), 2).ToString();
                this.hidReReAmountTL.Value = Math.Round(Convert.ToDecimal(drAop["ReAmountY"]), 2).ToString();
            }
        }
        public void SetDealerHisPageValue(DataTable tabAop)
        {
            if (tabAop.Rows.Count > 0)
            {
                DataRow drAop = tabAop.Rows[0];
                this.txtHisAmount1.Text = drAop["Amount1"].ToString();
                this.txtHisAmount2.Text = drAop["Amount2"].ToString();
                this.txtHisAmount3.Text = drAop["Amount3"].ToString();
                this.txtHisAmount4.Text = drAop["Amount4"].ToString();
                this.txtHisAmount5.Text = drAop["Amount5"].ToString();
                this.txtHisAmount6.Text = drAop["Amount6"].ToString();
                this.txtHisAmount7.Text = drAop["Amount7"].ToString();
                this.txtHisAmount8.Text = drAop["Amount8"].ToString();
                this.txtHisAmount9.Text = drAop["Amount9"].ToString();
                this.txtHisAmount10.Text = drAop["Amount10"].ToString();
                this.txtHisAmount11.Text = drAop["Amount11"].ToString();
                this.txtHisAmount12.Text = drAop["Amount12"].ToString();
                this.txtHisAmountQ1.Text = Math.Round(Convert.ToDecimal(drAop["Q1"]), 2).ToString();
                this.txtHisAmountQ2.Text = Math.Round(Convert.ToDecimal(drAop["Q2"]), 2).ToString();
                this.txtHisAmountQ3.Text = Math.Round(Convert.ToDecimal(drAop["Q3"]), 2).ToString();
                this.txtHisAmountQ4.Text = Math.Round(Convert.ToDecimal(drAop["Q4"]), 2).ToString();
                this.txtHisAmountTL.Text = Math.Round(Convert.ToDecimal(drAop["AmountY"]), 2).ToString();
            }
        }

        private void ClearDealerValuePage()
        {
            this.nfAmount1.Enabled = false;
            this.nfAmount2.Enabled = false;
            this.nfAmount3.Enabled = false;
            this.nfAmount4.Enabled = false;
            this.nfAmount5.Enabled = false;
            this.nfAmount6.Enabled = false;
            this.nfAmount7.Enabled = false;
            this.nfAmount8.Enabled = false;
            this.nfAmount9.Enabled = false;
            this.nfAmount10.Enabled = false;
            this.nfAmount11.Enabled = false;
            this.nfAmount12.Enabled = false;
        }

        private void SetDealerValuePage(string year)
        {
            if (year == Convert.ToDateTime(this.BeginDate).Year.ToString())
            {
                int minMonth = 0;
                if (Convert.ToDateTime(this.BeginDate).Month <= DateTime.Now.Month && Convert.ToDateTime(this.BeginDate).Year == DateTime.Now.Year && !CheckSheBei.Equals("1"))
                {
                    minMonth = Convert.ToDateTime(this.BeginDate).Month + 1;
                }
                else
                {
                    minMonth = Convert.ToDateTime(this.BeginDate).Month;
                }

                for (int i = minMonth; i <= 12; i++)
                {
                    NumberField tempUnit = this.FindControl("nfAmount" + i.ToString()) as NumberField;
                  
                    if (year == Convert.ToDateTime(this.EndDate).Year.ToString() && Convert.ToDateTime(this.EndDate).Month < i)
                    {
                        tempUnit.Enabled = false;
                    }
                    else
                    {
                        tempUnit.Enabled = true;
                    }
                }
            }
            else
            {
                for (int i = 1; i <= 12; i++)
                {
                    NumberField tempUnit = this.FindControl("nfAmount" + i.ToString()) as NumberField;
                    if (year == Convert.ToDateTime(this.EndDate).Year.ToString() && Convert.ToDateTime(this.EndDate).Month < i)
                    {
                        tempUnit.Enabled = false;
                    }
                    else
                    {
                        tempUnit.Enabled = true;
                    }
                }
            }
        }
        #endregion

        #region 导出数据
        private void Excel(DataTable dt, string fileName)
        {
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=" + fileName);
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
    }
}
