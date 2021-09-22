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

    public partial class ContractDealerHospitalAOPList : BasePage
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
                return this.hidSubBuCode.Text;
            }
            set
            {
                this.hidSubBuCode.Text = value.ToString();
            }
        }

        public string SubBUId
        {
            get
            {
                return this.hidPartsContractId.Text;
            }
            set
            {
                this.hidPartsContractId.Text = value.ToString();
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
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.PageType = "Amount";
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
                    this.SubBU = this.Request.QueryString["PartsContractCode"];//合同分类Code

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

        #region Store
        public void AOPStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                int totalCount = 0;
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractId.Text);
                obj.Add("DealerDmaId", this.hidDealerId.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                obj.Add("BeginDate", this.hidEffectiveDate.Text);
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
                DataTable dt = _contractCommon.QueryHospitalProductAmountTemp(obj, start, limit, out totalCount).Tables[0];
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
                obj.Add("ContractId", this.hidContractId.Text);
                obj.Add("DealerDmaId", this.hidDealerId.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                obj.Add("BeginDate", this.hidEffectiveDate.Text);

                DataTable dt = _contractCommon.QueryHospitalProductAmountTemp(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarEdit.PageSize : e.Limit), out totalCount).Tables[0];
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
        public void AOPHospitalStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                int totalCount = 0;
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("DealerDmaId", this.DealerId);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                if (!string.IsNullOrEmpty(this.txtHospital.Text))
                {
                    obj.Add("HospitalName", this.txtHospital.Text);
                }

                DataTable dt = _contractCommon.QueryHospitalIndexTemp(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
                (this.AOPHospitalStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                AOPHospitalStore.DataSource = dt;
                AOPHospitalStore.DataBind();
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }
        public void AOPProductStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                int totalCount = 0;
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("DealerDmaId", this.DealerId);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                if (!string.IsNullOrEmpty(this.tfProdutName.Text))
                {
                    obj.Add("ProductName", this.tfProdutName.Text);
                }

                DataTable dt = _contractCommon.QueryProductIndexTemp(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarProduct.PageSize : e.Limit), out totalCount).Tables[0];
                (this.AOPProductStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                AOPProductStore.DataSource = dt;
                AOPProductStore.DataBind();
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
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
        public void AOPDealerStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                int totalCount = 0;
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("DealerDmaId", this.DealerId);
                obj.Add("ProductLineBumId", this.ProductLineId);

                DataTable dt = _contractCommon.QueryAopDealerUnionHospitalAmount(obj).Tables[0];
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

        #endregion

        #region 按钮事件
        //Button 修改
        protected void EditAop_Click(object sender, AjaxEventArgs e)
        {
            this.txtGPHospitalUpdate.Reload();
            Guid dealerDmaId = new Guid(this.hidDealerId.Text.ToString());
            Guid contractId = new Guid(this.hidContractId.Text.ToString());

            string editData = e.ExtraParams["editData"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                String[] year = new String[1];
                year[0] = sellist[0]["Year"];
                Guid?[] productLineBumId = new Guid?[1];
                productLineBumId[0] = new Guid(sellist[0]["ProductLineId"]);
                this.InitEditValue("Unit");
                if (!this.PageOperationType.ToLower().Equals("query"))
                {
                    this.InitEditControlState(sellist[0]["Year"].ToString(), "Unit");
                }
                Guid hospitalid = new Guid(sellist[0]["HospitalId"]);
                string hospitalName = sellist[0]["HospitalName"];
                string Productification = sellist[0]["ProductId"];
                this.txtClassificationName.Text = sellist[0]["ProductName"];
                this.hidClassification.Value = Productification;

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractId.Text);
                obj.Add("DealerDmaId", this.hidDealerId.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                obj.Add("HospitalId", hospitalid);
                obj.Add("ProductId", Productification);
                obj.Add("Year", year[0].ToString());

                DataTable dt = _contractCommon.GetHospitalProductAmountTemp(obj).Tables[0];

                if (dt.Rows.Count > 0)
                {
                    this.txtHospitalID.Value = hospitalid.ToString();
                    this.txtHospitalName.Text = hospitalName;
                    this.hidProdLineID.Value = productLineBumId[0].ToString();
                    this.txtYear.Text = year[0].ToString();
                    this.hidentxtYear.Value = year[0].ToString();

                    this.txtUnit_1.Value = dt.Rows[0]["Amount1"].ToString();
                    this.txtUnit_2.Value = dt.Rows[0]["Amount2"].ToString();
                    this.txtUnit_3.Value = dt.Rows[0]["Amount3"].ToString();
                    this.txtUnit_4.Value = dt.Rows[0]["Amount4"].ToString();
                    this.txtUnit_5.Value = dt.Rows[0]["Amount5"].ToString();
                    this.txtUnit_6.Value = dt.Rows[0]["Amount6"].ToString();
                    this.txtUnit_7.Value = dt.Rows[0]["Amount7"].ToString();
                    this.txtUnit_8.Value = dt.Rows[0]["Amount8"].ToString();
                    this.txtUnit_9.Value = dt.Rows[0]["Amount9"].ToString();
                    this.txtUnit_10.Value = dt.Rows[0]["Amount10"].ToString();
                    this.txtUnit_11.Value = dt.Rows[0]["Amount11"].ToString();
                    this.txtUnit_12.Value = dt.Rows[0]["Amount12"].ToString();

                    this.txtFormalUnit_1.Value = dt.Rows[0]["RefAmount1"].ToString();
                    this.txtFormalUnit_2.Value = dt.Rows[0]["RefAmount2"].ToString();
                    this.txtFormalUnit_3.Value = dt.Rows[0]["RefAmount3"].ToString();
                    this.txtFormalUnit_4.Value = dt.Rows[0]["RefAmount4"].ToString();
                    this.txtFormalUnit_5.Value = dt.Rows[0]["RefAmount5"].ToString();
                    this.txtFormalUnit_6.Value = dt.Rows[0]["RefAmount6"].ToString();
                    this.txtFormalUnit_7.Value = dt.Rows[0]["RefAmount7"].ToString();
                    this.txtFormalUnit_8.Value = dt.Rows[0]["RefAmount8"].ToString();
                    this.txtFormalUnit_9.Value = dt.Rows[0]["RefAmount9"].ToString();
                    this.txtFormalUnit_10.Value = dt.Rows[0]["RefAmount10"].ToString();
                    this.txtFormalUnit_11.Value = dt.Rows[0]["RefAmount11"].ToString();
                    this.txtFormalUnit_12.Value = dt.Rows[0]["RefAmount12"].ToString();
                    this.hospitaleRemark.Text = dt.Rows[0]["RmkBody"].ToString();
                }
                this.AOPHospitalWindow.Show();
                e.Success = true;
            }
        }
        protected void RowSelect(object sender, AjaxEventArgs e)
        {
            Guid dealerDmaId = new Guid(this.hidDealerId.Text.ToString());
            Guid contractId = new Guid(this.hidContractId.Text.ToString());
            string editData = e.ExtraParams["HospitalAOPEditer"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                String[] year = new String[1];
                year[0] = sellist[0]["Year"];

                Guid?[] productLineBumId = new Guid?[1];
                productLineBumId[0] = new Guid(sellist[0]["ProductLineId"]);
                this.InitEditValue("Unit");
                if (!this.PageOperationType.ToLower().Equals("query"))
                {
                    this.InitEditControlState(sellist[0]["Year"].ToString(), "Unit");
                }
                Guid hospitalid = new Guid(sellist[0]["HospitalId"]);
                string hospitalName = sellist[0]["HospitalName"];
                string Productification = sellist[0]["ProductId"];
                this.txtClassificationName.Text = sellist[0]["ProductName"];
                this.hidClassification.Value = Productification;

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractId.Text);
                obj.Add("DealerDmaId", this.hidDealerId.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                obj.Add("HospitalId", hospitalid);
                obj.Add("ProductId", Productification);
                obj.Add("BeginDate", this.hidEffectiveDate.Text);
                obj.Add("Year", year[0].ToString());

                DataTable dt = _contractCommon.QueryHospitalProductAmountTemp(obj).Tables[0];

                if (dt.Rows.Count > 0)
                {
                    this.txtHospitalID.Value = hospitalid.ToString();
                    this.txtHospitalName.Text = hospitalName;
                    this.hidProdLineID.Value = productLineBumId[0].ToString();
                    this.txtYear.Text = year[0].ToString();
                    this.hidentxtYear.Value = year[0].ToString();

                    this.txtUnit_1.Value = dt.Rows[0]["Amount1"].ToString();
                    this.txtUnit_2.Value = dt.Rows[0]["Amount2"].ToString();
                    this.txtUnit_3.Value = dt.Rows[0]["Amount3"].ToString();
                    this.txtUnit_4.Value = dt.Rows[0]["Amount4"].ToString();
                    this.txtUnit_5.Value = dt.Rows[0]["Amount5"].ToString();
                    this.txtUnit_6.Value = dt.Rows[0]["Amount6"].ToString();
                    this.txtUnit_7.Value = dt.Rows[0]["Amount7"].ToString();
                    this.txtUnit_8.Value = dt.Rows[0]["Amount8"].ToString();
                    this.txtUnit_9.Value = dt.Rows[0]["Amount9"].ToString();
                    this.txtUnit_10.Value = dt.Rows[0]["Amount10"].ToString();
                    this.txtUnit_11.Value = dt.Rows[0]["Amount11"].ToString();
                    this.txtUnit_12.Value = dt.Rows[0]["Amount12"].ToString();

                    this.txtFormalUnit_1.Value = dt.Rows[0]["RefAmount1"].ToString();
                    this.txtFormalUnit_2.Value = dt.Rows[0]["RefAmount2"].ToString();
                    this.txtFormalUnit_3.Value = dt.Rows[0]["RefAmount3"].ToString();
                    this.txtFormalUnit_4.Value = dt.Rows[0]["RefAmount4"].ToString();
                    this.txtFormalUnit_5.Value = dt.Rows[0]["RefAmount5"].ToString();
                    this.txtFormalUnit_6.Value = dt.Rows[0]["RefAmount6"].ToString();
                    this.txtFormalUnit_7.Value = dt.Rows[0]["RefAmount7"].ToString();
                    this.txtFormalUnit_8.Value = dt.Rows[0]["RefAmount8"].ToString();
                    this.txtFormalUnit_9.Value = dt.Rows[0]["RefAmount9"].ToString();
                    this.txtFormalUnit_10.Value = dt.Rows[0]["RefAmount10"].ToString();
                    this.txtFormalUnit_11.Value = dt.Rows[0]["RefAmount11"].ToString();
                    this.txtFormalUnit_12.Value = dt.Rows[0]["RefAmount12"].ToString();
                    this.hospitaleRemark.Text = dt.Rows[0]["RmkBody"].ToString();
                }
                e.Success = true;
            }
        }

        protected void EditDealerAop_Click(object sender, AjaxEventArgs e)
        {
            this.AOPDealerWindow.Show();
            Guid dealerDmaId = new Guid(this.hidDealerId.Text.ToString());
            this.InitEditValue("Amount");
            string editData = e.ExtraParams["editData"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {

                string year = sellist[0]["AOPD_Year"];
                if (!this.PageOperationType.ToLower().Equals("query"))
                {
                    this.InitEditControlState(year, "Amount");
                }
                this.hidUpdateDealerYear.Text = year;

                SetDealerPageValueInit(year);
                e.Success = true;
            }
        }

        //Button 保存
        protected void SaveAOP_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                VAopDealerHospitalTemp aopdealers = new VAopDealerHospitalTemp();
                aopdealers.DealerDmaId = new Guid(this.hidDealerId.Text.ToString());
                aopdealers.ProductLineBumId = new Guid(this.hidProdLineID.Text.ToString());
                aopdealers.PctId = new Guid(this.hidClassification.Text.ToString());
                aopdealers.HospitalId = new Guid(this.txtHospitalID.Text);
                aopdealers.MarketType = this.hidIsEmerging.Text.Equals("") ? "0" : this.hidIsEmerging.Text;
                aopdealers.CcId = new Guid(this.hidPartsContractId.Text);

                double AOPValue = 0;
                double FormalValue = 0;
                for (int i = 1; i <= 12; i++)
                {
                    if ((this.hidMinYear.Text == this.hidentxtYear.Text && i >= Convert.ToInt32(this.hidBeginYearMinMonth.Text)) || (this.hidMinYear.Text != this.hidentxtYear.Text))
                    {
                        TextField tempUnit = this.FindControl("txtUnit_" + i.ToString()) as TextField;
                        TextField tempFormalUnit = this.FindControl("txtFormalUnit_" + i.ToString()) as TextField;
                        AOPValue += double.Parse(tempUnit.Text);
                        FormalValue += double.Parse(tempFormalUnit.Text);
                    }
                }

                if (Math.Round(AOPValue, 3) != Math.Round(FormalValue, 3) && FormalValue != 0)
                {
                    if (this.hospitaleRemark.Text.Equals(""))
                    {
                        e.ErrorMessage = "实际指标不等于标准指标，请填写原因";
                        e.Success = false;
                        return;
                    }
                    else
                    {
                        //Save Remark
                        AopRemark ar = new AopRemark();
                        ar.Id = Guid.NewGuid();
                        ar.Type = "Hospital";
                        ar.Contractid = new Guid(this.hidContractId.Text.ToString());
                        ar.HosId = new Guid(this.txtHospitalID.Text);
                        ar.Body = this.hospitaleRemark.Text;
                        ar.Rv1 = this.hidClassification.Text.ToString();

                        _contractMasterBll.DeleteAopRemark(ar);
                        _contractMasterBll.SaveAopRemark(ar);
                    }
                }

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
                if (this.hidMinYear.Text.Equals(this.hidentxtYear.Value.ToString()))
                {
                    if (!this.hidBeginYearMinMonth.Value.ToString().Equals(""))
                    {
                        MinMonth = Convert.ToInt32(this.hidBeginYearMinMonth.Value.ToString());
                    }
                }
                bool mctl = _contractCommon.SaveHospitalProductAOPAmount(new Guid(this.hidContractId.Text.ToString()), this.hidSubBuCode.Text, aopdealers, MinMonth);
                e.Success = true;
            }
            catch
            {
                e.Success = false;
            }
        }
        protected void SaveAOPDealer_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                VAopDealer aopdealers = new VAopDealer();
                aopdealers.DealerDmaId = new Guid(this.hidDealerId.Text.ToString());


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


                double totalDealerAop = Math.Round(aopdealers.Amount1 + aopdealers.Amount2 + aopdealers.Amount3 + aopdealers.Amount4 + aopdealers.Amount5 + aopdealers.Amount6 + aopdealers.Amount7 + aopdealers.Amount8 + aopdealers.Amount9 + aopdealers.Amount10 + aopdealers.Amount11 + aopdealers.Amount12, 2);

                AopRemark ar = new AopRemark();
                ar.Type = "Dealer";
                ar.Contractid = new Guid(this.hidContractId.Text.ToString());

                double hosAmounttotal = Math.Round(double.Parse(this.hidReReAmountTL.Text.Equals("") ? "0" : this.hidReReAmountTL.Text), 2);


                if (((totalDealerAop - hosAmounttotal) >= 0 && ((hosAmounttotal == 0 || ((totalDealerAop - hosAmounttotal) / hosAmounttotal) < 0.1) || this.SubBuType.Equals("0")))
                    || !this.txtDealerAopRemark.Text.Equals("")
                    )
                {
                    bool mctl = _contractCommon.SaveAopDealerTemp(this.hidContractId.Text, this.hidPartsContractId.Text, aopdealers);
                    _contractMasterBll.DeleteAopRemark(ar);
                    ar.Body = this.txtDealerAopRemark.Text;
                    ar.Id = Guid.NewGuid();
                    _contractMasterBll.SaveAopRemark(ar);

                    DealerPageInit();
                    e.Success = true;
                }
                else
                {
                    if (this.SubBuType.Equals("0"))
                    {
                        e.ErrorMessage = "请填写经销商指标小于医院指标原因";
                    }
                    else
                    {
                        e.ErrorMessage = "请填写经销商指标小于医院指标或大于医院指标10%原因";
                    }
                    e.Success = false;
                }

            }
            catch (Exception ex)
            {
                e.Success = false;
            }
        }

        protected void ExportHospitalExcel(object sender, EventArgs e)
        {
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.hidContractId.Text);
            DataTable dt = _contractMasterBll.ExportAopDealersHospitalByQuery(obj).Tables[0];
            Excel(dt, "DealerHospitalProductAOP.xls");
        }
        #endregion

        #region AjaxMethod
        [AjaxMethod]
        public string ResetAOP()
        {
            string error = "";
            try
            {
                Hashtable syHosObj = new Hashtable();
                syHosObj.Add("ContractId", this.hidContractId.Text);
                syHosObj.Add("DealerId", this.hidDealerId.Text.ToString());
                syHosObj.Add("ProductLineId", this.hidProductLineId.Text.ToString());
                syHosObj.Add("YearString", this.hidYearString.Text);
                syHosObj.Add("IsEmerging", this.hidIsEmerging.Value.ToString());
                syHosObj.Add("ContractType", this.hidContractType.Text);
                syHosObj.Add("BeginYearMinMonth", this.hidBeginYearMinMonth.Text);
                syHosObj.Add("PartsContractCode", this.hidSubBuCode.Text);
                syHosObj.Add("RtnVal", "");
                syHosObj.Add("RtnMsg", "");

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractId.Text);
                obj.Add("DealerId", this.hidDealerId.Text);
                obj.Add("ProductLineId", this.hidProductLineId.Text);
                obj.Add("ContractType", this.hidContractType.Value.ToString());
                obj.Add("MarketType", this.hidIsEmerging.Text);
                obj.Add("YearString", this.hidYearString.Value.ToString());
                obj.Add("BeginYearMinMonth", this.hidBeginYearMinMonth.Text);
                obj.Add("AOPType", "Amount");
                obj.Add("PartsContractCode", this.hidSubBuCode.Text);
                obj.Add("IsAmountSy", "");
                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");

                _contractCommon.ResetAopAmount(syHosObj, obj, this.hidContractId.Text);

            }
            catch (Exception ex)
            {
                error = ex.ToString();
            }

            return error;
        }

        [AjaxMethod]
        public void ChangePageDealerAOP()
        {
            DealerPageInit();
            InitEditValue("Amount");
            if (!this.PageOperationType.ToLower().Equals("query"))
            {
                InitEditControlState(this.cbDelaerAopYear.SelectedItem.Value.ToString(), "Amount");
            }
        }

        #endregion

        #region 经销商指标维护页面数据清理
        private void DealerPageInit()
        {
            string yearDealerAOP = (string.IsNullOrEmpty(this.cbDelaerAopYear.SelectedItem.Value) ? "" : this.cbDelaerAopYear.SelectedItem.Value.ToString());

            this.hidUpdateDealerYear.Text = yearDealerAOP;
            SetDealerPageValueInit(yearDealerAOP);
        }

        private void SetDealerPageValueInit(string yearDealerAOP)
        {
            Hashtable obj = new Hashtable();
            if (yearDealerAOP != "")
            {
                obj.Add("AopYear", yearDealerAOP);
            }
            obj.Add("ContractId", this.hidContractId.Text);
            DataTable dtAop = _contractCommon.GetDealerTempIndex(obj).Tables[0];
            DataTable dtHospitalAop = _contractCommon.GetHospitalTempIndexSum(obj).Tables[0];
            ClaerDealerPageValue();
            SetDealerPageValue(dtAop);
            SetHospitalPageValue(dtHospitalAop);

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

        private void ClaerDealerPageValue()
        {
            this.txtReAmount1.Text = "";
            this.txtReAmount2.Text = "";
            this.txtReAmount3.Text = "";
            this.txtReAmount4.Text = "";
            this.txtReAmount5.Text = "";
            this.txtReAmount6.Text = "";
            this.txtReAmount7.Text = "";
            this.txtReAmount8.Text = "";
            this.txtReAmount9.Text = "";
            this.txtReAmount10.Text = "";
            this.txtReAmount11.Text = "";
            this.txtReAmount12.Text = "";
            this.txtReAmountQ1.Text = "";
            this.txtReAmountQ2.Text = "";
            this.txtReAmountQ3.Text = "";
            this.txtReAmountQ4.Text = "";
            this.txtReAmountTL.Text = "";
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
        private void SetDealerPageValue(DataTable tabAop)
        {
            if (tabAop.Rows.Count > 0)
            {
                DataRow drAop = tabAop.Rows[0];
                //this.txtHisAmount1.Text = drAop["HisAmount1"].ToString();
                //this.txtHisAmount2.Text = drAop["HisAmount2"].ToString();
                //this.txtHisAmount3.Text = drAop["HisAmount3"].ToString();
                //this.txtHisAmount4.Text = drAop["HisAmount4"].ToString();
                //this.txtHisAmount5.Text = drAop["HisAmount5"].ToString();
                //this.txtHisAmount6.Text = drAop["HisAmount6"].ToString();
                //this.txtHisAmount7.Text = drAop["HisAmount7"].ToString();
                //this.txtHisAmount8.Text = drAop["HisAmount8"].ToString();
                //this.txtHisAmount9.Text = drAop["HisAmount9"].ToString();
                //this.txtHisAmount10.Text = drAop["HisAmount10"].ToString();
                //this.txtHisAmount11.Text = drAop["HisAmount11"].ToString();
                //this.txtHisAmount12.Text = drAop["HisAmount12"].ToString();
                //this.txtHisAmountQ1.Text = drAop["HisQ1"].ToString();
                //this.txtHisAmountQ2.Text = drAop["HisQ2"].ToString();
                //this.txtHisAmountQ3.Text = drAop["HisQ3"].ToString();
                //this.txtHisAmountQ4.Text = drAop["HisQ4"].ToString();
                //this.txtHisAmountTL.Text = drAop["HisAmountY"].ToString();

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
        private void SetHospitalPageValue(DataTable tabAop)
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
        private void ClaerDealerPageState()
        {

        }
        private void SetDealerPageState()
        {

        }
        #endregion

        #region Function
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
        private void SetInitialValue()
        {
            // 1. 获取产品线ID
            this.ProductLineId = GetProductLineId(this.Request.QueryString["DivisionID"].ToString());
            // 2. 获取合同年份跨度
            int Effective = Convert.ToDateTime(this.BeginDate).Year;
            int Expiration = Convert.ToDateTime(this.EndDate).Year;
            this.hidMinYear.Text = Effective.ToString();
            string year = null;

            for (int getYear = Effective; getYear <= Expiration; getYear++)
            {
                year += (getYear.ToString() + ',');
            }
            this.hidYearString.Text = year;

            //4.获取合同分类ID
            this.SubBUId = PartsContractId(this.SubBU);

            // 5.获取指标能够维护开始月份 a》Appointment：合同开始月份    b》Renewal：合同开始月份     c》Amendment：系统时间+14天与合同时间比较，取较大月份
            this.hidBeginYearMinMonth.Text = Convert.ToDateTime(this.BeginDate).Month.ToString();

        }

        private void PageInit()
        {
            //获取上个合同指标数据
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.ContractId);
            obj.Add("DealerId", this.DealerId);
            obj.Add("ProductLineId", this.ProductLineId);
            obj.Add("SubBU", this.SubBU);
            obj.Add("BeginDate", this.BeginDate);
            obj.Add("EndDate", this.EndDate);
            obj.Add("PropertyType", "1");
            obj.Add("ContractType", this.ContractType);
            this.LastContractId = _contractMasterBll.GetContractProperty_Last(obj);
        }
        private void PagePermissions()
        {
            if (this.PageOperationType.ToLower() == "query")
            {
                this.btnInputRule.Hidden = true;
                this.SaveUnitButton.Hidden = true;
                this.SaveDealerButton.Hidden = true;

                this.GridPanelAOPStore.ColumnModel.Columns[1].Header = "查看";
                this.GridDealerAop.ColumnModel.Columns[1].Header = "查看";
            }
        }

        private void SynchronousFormalAOPToTemp()
        {
            Guid conId = new Guid(this.hidContractId.Text);
            DataTable dtCheck = _contractMasterBll.QueryAuthorizationTempListForDataSet(conId).Tables[0];
            if (dtCheck.Rows.Count == 0 && this.hidContractType.Text.Equals("Appointment"))
            {
                Ext.MessageBox.Alert("错误", "请先维护经销商授权！").Show();
                return;
            }
            else if (dtCheck.Rows.Count == 0 && !this.hidContractType.Text.Equals("Appointment"))
            {
                //获取上个合同授权数据
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.ContractId);
                obj.Add("DealerId", this.DealerId);
                obj.Add("ProductLineId", this.ProductLineId);
                obj.Add("SubBU", this.SubBU);
                obj.Add("BeginDate", DBNull.Value);
                obj.Add("EndDate", DBNull.Value);
                obj.Add("PropertyType", "0");
                obj.Add("ContractType", this.ContractType);
                _contractMasterBll.GetContractProperty_Last(obj);
            }
            PageInit();
            SynchronousDealerAopTemp();
        }
        private void SynchronousDealerAopTemp()
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractId.Text);
                obj.Add("LastContractId", this.LastContractId);
                obj.Add("DealerId", this.hidDealerId.Text);
                obj.Add("ProductLineId", this.hidProductLineId.Text);
                obj.Add("SubBU", this.SubBU);
                obj.Add("MarketType", this.hidIsEmerging.Text);
                obj.Add("YearString", this.hidYearString.Value.ToString());
                obj.Add("BeginDate", this.BeginDate);
                obj.Add("EndDate", this.EndDate);
                obj.Add("AOPType", "Amount");
                obj.Add("SyType", "2");
                obj.Add("ContractType", this.ContractType);
                _contractCommon.DealerAOPMerge(obj);
            }
            catch (Exception ex)
            {

            }
        }
        private void InitEditControlState(string year, string type)
        {
            int minMonth = Convert.ToInt32(this.hidBeginYearMinMonth.Value.ToString());
            if (type.Equals("Unit"))
            {
                if (year == this.hidMinYear.Text)
                {
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
            if (type.Equals("Amount"))
            {
                if (year == this.hidMinYear.Text)
                {
                    for (int i = minMonth; i <= 12; i++)
                    {
                        NumberField temptf = this.FindControl("nfAmount" + i.ToString()) as NumberField;

                        if (year == Convert.ToDateTime(this.EndDate).Year.ToString() && Convert.ToDateTime(this.EndDate).Month < i)
                        {
                            temptf.Enabled = false;
                        }
                        else
                        {
                            temptf.Enabled = true;
                        }
                    }
                }
                else
                {
                    for (int i = 1; i <= 12; i++)
                    {
                        NumberField temptf = this.FindControl("nfAmount" + i.ToString()) as NumberField;

                        if (year == Convert.ToDateTime(this.EndDate).Year.ToString() && Convert.ToDateTime(this.EndDate).Month < i)
                        {
                            temptf.Enabled = false;
                        }
                        else
                        {
                            temptf.Enabled = true;
                        }
                    }
                }
            }

        }
        private void InitEditValue(string Type)
        {
            if (Type.Equals("Unit"))
            {
                for (int i = 1; i <= 12; i++)
                {
                    TextField tempUnit = this.FindControl("txtUnit_" + i.ToString()) as TextField;
                    tempUnit.Enabled = false;
                }
            }
            else if (Type.Equals("Amount"))
            {
                for (int i = 1; i <= 12; i++)
                {
                    NumberField tempAmount = this.FindControl("nfAmount" + i.ToString()) as NumberField;
                    tempAmount.Enabled = false;
                }
            }

        }

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
