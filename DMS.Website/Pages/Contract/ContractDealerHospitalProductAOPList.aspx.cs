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
    public partial class ContractDealerHospitalProductAOPList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IContractMasterBLL _contractMasterBLL = new ContractMasterBLL();
        private DataTable _dtHasAuther;
        private DataTable dtHasAuther
        {
            get
            {
                if (_dtHasAuther == null)
                {
                    _dtHasAuther = new DataTable();
                }
                return _dtHasAuther;
            }
            set
            {
                _dtHasAuther = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.prodLineData.Value = OrganizationCacheHelper.GetJsonArray(SR.Organization_ProductLine);

                if (this.Request.QueryString["InstanceID"] != null && this.Request.QueryString["DivisionID"] != null && this.Request.QueryString["TempDealerID"] != null
                    && this.Request.QueryString["EffectiveDate"] != null && this.Request.QueryString["ExpirationDate"] != null)
                {
                    this.hidContractID.Text = this.Request.QueryString["InstanceID"];
                    this.hidDivisionID.Text = this.Request.QueryString["DivisionID"];
                    this.hidDealerID.Text = this.Request.QueryString["TempDealerID"];
                    this.HidEffectiveDate.Text = this.Request.QueryString["EffectiveDate"];
                    this.HidExpirationDate.Text = this.Request.QueryString["ExpirationDate"];

                    if (this.Request.QueryString["IsChange"] != null)
                    {
                        this.hidIsChange.Text = this.Request.QueryString["IsChange"].ToString();
                    }
                    if (this.Request.QueryString["IsEmerging"] != null)
                    {
                        this.hidIsEmerging.Text = this.Request.QueryString["IsEmerging"].ToString();
                    }
                    if (this.Request.QueryString["ContractType"] != null)
                    {
                        this.hidContractType.Text = this.Request.QueryString["ContractType"].ToString();
                    }
                }

                Guid empty = Guid.Empty;
                if (this.hidContractID.Text.Equals(""))
                {
                    this.hidContractID.Text = empty.ToString();
                }
                if (this.hidDivisionID.Text.Equals(""))
                {
                    this.hidDivisionID.Text = "0";
                }
                if (this.hidDealerID.Text.Equals(""))
                {
                    this.hidDealerID.Text = empty.ToString();
                }
                if (this.HidEffectiveDate.Text.Equals(""))
                {
                    this.HidEffectiveDate.Text = "1900-01-01";
                }
                if (this.HidExpirationDate.Text.Equals(""))
                {
                    this.HidExpirationDate.Text = "1900-01-01";
                }

                SetInitialValue();
                SynchronousFormalDealerHospitalProductAOP();
                BuildMenuTree(this.menuTree.Root);

                Coolite.Ext.Web.TreeNode rootNode = new Coolite.Ext.Web.TreeNode();
                rootNode.Text = "产品分类";
                rootNode.NodeID = this.hidProductLineId.Text;
                rootNode.Icon = Icon.FolderHome;
                rootNode.Expanded = true;
                rootNode.Checked = ThreeStateBool.Undefined;
                TreeProduct.Root.Add(rootNode);
                //menuTree.Root.Add(rootNode);

            }
        }

        #region Store
        public void AuthorizationStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerDmaId", this.hidDealerID.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                DataTable dt = _contractMasterBLL.QueryHospitalProduct(obj).Tables[0];

                DataTable dtCheck = dt.Clone();
                DataRow[] drCheck = dt.Select("Product is null ");
                foreach (DataRow row in drCheck)
                {
                    dtCheck.Rows.Add(row.ItemArray);
                }
                if (dtCheck.Rows.Count > 0)
                {
                    hidCheckHospitalProudct.Value = "0";
                }
                else
                {
                    hidCheckHospitalProudct.Value = "1";
                }

                if (sender is Store)
                {
                    Store store1 = (sender as Store);
                    store1.DataSource = dt;
                    store1.DataBind();
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }
        public void AOPStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                int totalCount = 0;
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerDmaId", this.hidDealerID.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);

                int start = 0; int limit = this.PagingToolBarAOP.PageSize;
                if (e.Start > -1)
                {
                    start = e.Start;
                    limit = e.Limit;
                }
                DataTable dt = _contractMasterBLL.QueryHospitalProductAOP(obj, start, limit, out totalCount).Tables[0];
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
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerDmaId", this.hidDealerID.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);

                DataTable dt = _contractMasterBLL.QueryHospitalProductAOP(obj).Tables[0];
                if (sender is Store)
                {
                    Store store1 = (sender as Store);
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
            try
            {
                int totalCount = 0;
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerDmaId", this.hidDealerID.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);

                DataTable dt = _contractMasterBLL.QueryHospitalProductByDealerTotleAOP2(obj).Tables[0];

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

        #region 修改初始化页面
        [AjaxMethod]
        public void EditAuthProduct(string hosId, string hosName)
        {
            Guid dealerDmaId = new Guid(this.hidDealerID.Text.ToString());
            Guid contractId = new Guid(this.hidContractID.Text.ToString());

            this.hidAuthor_HospitalId.Value = hosId;
            this.blAuthor_HospitalName.Text = hosName;
        }


        protected void EditAop_Click(object sender, AjaxEventArgs e)
        {
            this.InitEditControlState(1, null, "Unit");
            this.InitEditValue("Unit");
            Guid dealerDmaId = new Guid(this.hidDealerID.Text.ToString());
            Guid contractId = new Guid(this.hidContractID.Text.ToString());

            string editData = e.ExtraParams["editData"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                String[] year = new String[1];
                year[0] = sellist[0]["Year"];

                Guid?[] productLineBumId = new Guid?[1];
                productLineBumId[0] = new Guid(sellist[0]["ProductLineId"]);

                Guid hospitalid = new Guid(sellist[0]["HospitalId"]);
                string hospitalName = sellist[0]["HospitalName"];
                string Productification = sellist[0]["ProductId"];
                this.txtClassificationName.Text = sellist[0]["ProductName"];
                this.hidClassification.Value = Productification;

                VAopICDealerHospital aopdealers = _contractMasterBLL.GetYearAopHospitalForIC(contractId, dealerDmaId, productLineBumId, year, hospitalid, Productification);
                this.txtHospitalID.Value = hospitalid.ToString();
                this.txtHospitalName.Text = hospitalName;
                this.hidProdLineID.Value = aopdealers.ProductLineId;
                this.txtYear.Text = aopdealers.Year;
                this.hidentxtYear.Value = aopdealers.Year;
                this.txtUnit_1.Value = aopdealers.Unit1.ToString();
                this.txtUnit_2.Value = aopdealers.Unit2.ToString();
                this.txtUnit_3.Value = aopdealers.Unit3.ToString();
                this.txtUnit_4.Value = aopdealers.Unit4.ToString();
                this.txtUnit_5.Value = aopdealers.Unit5.ToString();
                this.txtUnit_6.Value = aopdealers.Unit6.ToString();
                this.txtUnit_7.Value = aopdealers.Unit7.ToString();
                this.txtUnit_8.Value = aopdealers.Unit8.ToString();
                this.txtUnit_9.Value = aopdealers.Unit9.ToString();
                this.txtUnit_10.Value = aopdealers.Unit10.ToString();
                this.txtUnit_11.Value = aopdealers.Unit11.ToString();
                this.txtUnit_12.Value = aopdealers.Unit12.ToString();

                this.txtFormalUnit_1.Value = aopdealers.ReferenceUnit_1.ToString();
                this.txtFormalUnit_2.Value = aopdealers.ReferenceUnit_2.ToString();
                this.txtFormalUnit_3.Value = aopdealers.ReferenceUnit_3.ToString();
                this.txtFormalUnit_4.Value = aopdealers.ReferenceUnit_4.ToString();
                this.txtFormalUnit_5.Value = aopdealers.ReferenceUnit_5.ToString();
                this.txtFormalUnit_6.Value = aopdealers.ReferenceUnit_6.ToString();
                this.txtFormalUnit_7.Value = aopdealers.ReferenceUnit_7.ToString();
                this.txtFormalUnit_8.Value = aopdealers.ReferenceUnit_8.ToString();
                this.txtFormalUnit_9.Value = aopdealers.ReferenceUnit_9.ToString();
                this.txtFormalUnit_10.Value = aopdealers.ReferenceUnit_10.ToString();
                this.txtFormalUnit_11.Value = aopdealers.ReferenceUnit_11.ToString();
                this.txtFormalUnit_12.Value = aopdealers.ReferenceUnit_12.ToString();

                this.hospitaleRemark.Text = aopdealers.Remark.ToString();
                this.InitEditControlState(2, aopdealers.Year, "Unit");
                SetGridSelect(Convert.ToInt32(sellist[0]["row_number"].ToString()));
                this.AOPEditorWindow.Show();
                e.Success = true;
            }
        }

        protected void RowSelect(object sender, AjaxEventArgs e)
        {
            Guid dealerDmaId = new Guid(this.hidDealerID.Text.ToString());
            Guid contractId = new Guid(this.hidContractID.Text.ToString());
            string editData = e.ExtraParams["HospitalAOPEditer"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                String[] year = new String[1];
                year[0] = sellist[0]["Year"];

                Guid?[] productLineBumId = new Guid?[1];
                productLineBumId[0] = new Guid(sellist[0]["ProductLineId"]);

                Guid hospitalid = new Guid(sellist[0]["HospitalId"]);
                string hospitalName = sellist[0]["HospitalName"];
                string Productification = sellist[0]["ProductId"];
                this.txtClassificationName.Text = sellist[0]["ProductName"];
                this.hidClassification.Value = Productification;

                VAopICDealerHospital aopdealers = _contractMasterBLL.GetYearAopHospitalForIC(contractId, dealerDmaId, productLineBumId, year, hospitalid, Productification);
                this.txtHospitalID.Value = hospitalid.ToString();
                this.txtHospitalName.Text = hospitalName;
                this.hidProdLineID.Value = aopdealers.ProductLineId;
                this.txtYear.Text = aopdealers.Year;
                this.hidentxtYear.Value = aopdealers.Year;
                this.txtUnit_1.Value = aopdealers.Unit1.ToString();
                this.txtUnit_2.Value = aopdealers.Unit2.ToString();
                this.txtUnit_3.Value = aopdealers.Unit3.ToString();
                this.txtUnit_4.Value = aopdealers.Unit4.ToString();
                this.txtUnit_5.Value = aopdealers.Unit5.ToString();
                this.txtUnit_6.Value = aopdealers.Unit6.ToString();
                this.txtUnit_7.Value = aopdealers.Unit7.ToString();
                this.txtUnit_8.Value = aopdealers.Unit8.ToString();
                this.txtUnit_9.Value = aopdealers.Unit9.ToString();
                this.txtUnit_10.Value = aopdealers.Unit10.ToString();
                this.txtUnit_11.Value = aopdealers.Unit11.ToString();
                this.txtUnit_12.Value = aopdealers.Unit12.ToString();

                this.txtFormalUnit_1.Value = aopdealers.ReferenceUnit_1.ToString();
                this.txtFormalUnit_2.Value = aopdealers.ReferenceUnit_2.ToString();
                this.txtFormalUnit_3.Value = aopdealers.ReferenceUnit_3.ToString();
                this.txtFormalUnit_4.Value = aopdealers.ReferenceUnit_4.ToString();
                this.txtFormalUnit_5.Value = aopdealers.ReferenceUnit_5.ToString();
                this.txtFormalUnit_6.Value = aopdealers.ReferenceUnit_6.ToString();
                this.txtFormalUnit_7.Value = aopdealers.ReferenceUnit_7.ToString();
                this.txtFormalUnit_8.Value = aopdealers.ReferenceUnit_8.ToString();
                this.txtFormalUnit_9.Value = aopdealers.ReferenceUnit_9.ToString();
                this.txtFormalUnit_10.Value = aopdealers.ReferenceUnit_10.ToString();
                this.txtFormalUnit_11.Value = aopdealers.ReferenceUnit_11.ToString();
                this.txtFormalUnit_12.Value = aopdealers.ReferenceUnit_12.ToString();

                this.hospitaleRemark.Text = aopdealers.Remark.ToString();
                //this.InitEditControlState(2, aopdealers.Year, "Unit");
                //this.AOPEditorWindow.Show();
                e.Success = true;
            }
        }

        protected void EditDealerAop_Click(object sender, AjaxEventArgs e)
        {
            this.InitEditControlState(1, null, "Amount");
            this.InitEditValue("Amount");
            this.txtDealerAopRemark.Text = "";
            this.hidDealerAopRemarkId.Text = "";
            Guid dealerDmaId = new Guid(this.hidDealerID.Text.ToString());
            string editData = e.ExtraParams["editData"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                Guid productLineBumId = new Guid(sellist[0]["AOPD_ProductLine_BUM_ID"]);
                string year = sellist[0]["AOPD_Year"];
                VAopDealer aopdealers = null;
                if (this.hidContractType.Text.ToString().Equals("Amendment"))
                {
                    Hashtable obj = new Hashtable();
                    obj.Add("ContractId", this.hidContractID.Text.ToString());
                    obj.Add("DealerDmaId", dealerDmaId);
                    obj.Add("ProductLineBumId", productLineBumId);
                    obj.Add("Year", year);
                    obj.Add("IsEmerging", this.hidIsEmerging.Text);
                    aopdealers = _contractMasterBLL.GetAopDealersTemp(obj);
                }
                else
                {
                    aopdealers = _contractMasterBLL.GetYearAopDealers(new Guid(this.hidContractID.Text.ToString()), dealerDmaId, productLineBumId, year);
                }

                //this.txtDealer.Value = aopdealers.DealerDmaId;
                this.hidDealerProdLineId.Value = aopdealers.ProductLineBumId;
                this.hidDealerAopYear.Value = aopdealers.Year;
                this.txtDealerAopYear.Text = aopdealers.Year;
                this.txtAmount_1.Value = aopdealers.Amount1.ToString();
                this.txtAmount_2.Value = aopdealers.Amount2.ToString();
                this.txtAmount_3.Value = aopdealers.Amount3.ToString();
                this.txtAmount_4.Value = aopdealers.Amount4.ToString();
                this.txtAmount_5.Value = aopdealers.Amount5.ToString();
                this.txtAmount_6.Value = aopdealers.Amount6.ToString();
                this.txtAmount_7.Value = aopdealers.Amount7.ToString();
                this.txtAmount_8.Value = aopdealers.Amount8.ToString();
                this.txtAmount_9.Value = aopdealers.Amount9.ToString();
                this.txtAmount_10.Value = aopdealers.Amount10.ToString();
                this.txtAmount_11.Value = aopdealers.Amount11.ToString();
                this.txtAmount_12.Value = aopdealers.Amount12.ToString();
                this.txtDealerAopRemark.Text = aopdealers.RmkBody;
                this.hidDealerAopRemarkId.Text = aopdealers.RmkId == null ? "" : aopdealers.RmkId.Value.ToString();

                this.txtReHosAmount_1.Value = aopdealers.ReAmount1.ToString();
                this.txtReHosAmount_2.Value = aopdealers.ReAmount2.ToString();
                this.txtReHosAmount_3.Value = aopdealers.ReAmount3.ToString();
                this.txtReHosAmount_4.Value = aopdealers.ReAmount4.ToString();
                this.txtReHosAmount_5.Value = aopdealers.ReAmount5.ToString();
                this.txtReHosAmount_6.Value = aopdealers.ReAmount6.ToString();
                this.txtReHosAmount_7.Value = aopdealers.ReAmount7.ToString();
                this.txtReHosAmount_8.Value = aopdealers.ReAmount8.ToString();
                this.txtReHosAmount_9.Value = aopdealers.ReAmount9.ToString();
                this.txtReHosAmount_10.Value = aopdealers.ReAmount10.ToString();
                this.txtReHosAmount_11.Value = aopdealers.ReAmount11.ToString();
                this.txtReHosAmount_12.Value = aopdealers.ReAmount12.ToString();

                this.InitEditControlState(2, aopdealers.Year, "Amount");
                this.WindowDealerAop.Show();
                e.Success = true;
            }
        }
        #endregion

        #region 保存修改数据
        [AjaxMethod]
        public string SaveAuthorProduct(string productIdString)
        {
            string massage = "";
            try
            {
                //删除原有授全产品分类  //维护当前产品分类
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerDmaId", this.hidDealerID.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                obj.Add("HosId", this.hidAuthor_HospitalId.Value.ToString());
                obj.Add("ProductString", productIdString);
                obj.Add("YearString", this.hidYearString.Value.ToString());
                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");

                _contractMasterBLL.SubmintDealerHospitalProductMapping(obj);
            }
            catch (Exception ex)
            {
                massage = ex.Message;
                Coolite.Ext.Web.ScriptManager.AjaxSuccess = false;
                Coolite.Ext.Web.ScriptManager.AjaxErrorMessage = ex.Message;
            }
            return massage;
        }

        [AjaxMethod]
        public string SaveProductPrice(string PriceIdString)
        {
            string massage = "";
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerDmaId", this.hidDealerID.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                obj.Add("ContractType", this.hidContractType.Value.ToString());
                obj.Add("YearString", this.hidYearString.Value.ToString());
                obj.Add("MarketType", this.hidIsEmerging.Text);
                obj.Add("priceidString", PriceIdString);
                obj.Add("BeginMonth", Convert.ToDateTime(this.HidEffectiveDate.Text).Month);
                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");

                Hashtable objCK = new Hashtable();
                objCK.Add("ContractId", this.hidContractID.Text);
                objCK.Add("ProductLineBumId", this.hidProductLineId.Text);
                objCK.Add("priceidString", PriceIdString);
                DataTable dt = _contractMasterBLL.CheckAuthorProductPrice(objCK).Tables[0];

                if (dt.Rows[0][0].ToString().Equals("1"))
                {
                    massage = "同一产品分类只能选择一种价格";
                }
                else if (dt.Rows[0][0].ToString().Equals("2"))
                {
                    massage = "每一产品分类都必须选择一类价格";
                }
                else
                {
                    //维护产品价格
                    _contractMasterBLL.SubmintHospitalProductPrice(obj);

                    _contractMasterBLL.MaintainDealerHospitalProductAOP(obj);
                }
            }
            catch (Exception ex)
            {
                massage = ex.Message;
                Coolite.Ext.Web.ScriptManager.AjaxSuccess = false;
                Coolite.Ext.Web.ScriptManager.AjaxErrorMessage = ex.Message;
            }
            return massage;
        }

        protected void SaveAOP_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                VAopICDealerHospital aopdealers = new VAopICDealerHospital();
                aopdealers.DmaId = new Guid(this.hidDealerID.Text.ToString());
                aopdealers.ProductLineId = new Guid(this.hidProdLineID.Text.ToString());
                aopdealers.PctId = new Guid(this.hidClassification.Text.ToString());
                aopdealers.HospitalId = new Guid(this.txtHospitalID.Text);
                aopdealers.MarketType = this.hidIsEmerging.Text.Equals("") ? "0" : this.hidIsEmerging.Text;

                double AOPValue = 0;
                double FormalValue = 0;
                for (int i = 1; i <= 12; i++)
                {
                    TextField tempUnit = this.FindControl("txtUnit_" + i.ToString()) as TextField;
                    TextField tempFormalUnit = this.FindControl("txtFormalUnit_" + i.ToString()) as TextField;
                    AOPValue += double.Parse(tempUnit.Text);
                    FormalValue += double.Parse(tempFormalUnit.Text);
                }

                if (AOPValue != FormalValue)
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
                        ar.Contractid = new Guid(this.hidContractID.Text.ToString());
                        ar.HosId = new Guid(this.txtHospitalID.Text);
                        ar.Body = this.hospitaleRemark.Text;
                        ar.Rv1 = this.hidClassification.Text.ToString();

                        _contractMasterBLL.DeleteAopRemark(ar);
                        _contractMasterBLL.SaveAopRemark(ar);
                    }
                }

                aopdealers.Year = this.hidentxtYear.Value.ToString();
                aopdealers.Unit1 = double.Parse(this.txtUnit_1.Text);
                aopdealers.Unit2 = double.Parse(this.txtUnit_2.Text);
                aopdealers.Unit3 = double.Parse(this.txtUnit_3.Text);
                aopdealers.Unit4 = double.Parse(this.txtUnit_4.Text);
                aopdealers.Unit5 = double.Parse(this.txtUnit_5.Text);
                aopdealers.Unit6 = double.Parse(this.txtUnit_6.Text);
                aopdealers.Unit7 = double.Parse(this.txtUnit_7.Text);
                aopdealers.Unit8 = double.Parse(this.txtUnit_8.Text);
                aopdealers.Unit9 = double.Parse(this.txtUnit_9.Text);
                aopdealers.Unit10 = double.Parse(this.txtUnit_10.Text);
                aopdealers.Unit11 = double.Parse(this.txtUnit_11.Text);
                aopdealers.Unit12 = double.Parse(this.txtUnit_12.Text);

                bool mctl = _contractMasterBLL.SaveAopHospitalForIC(new Guid(this.hidContractID.Text.ToString()), aopdealers);
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
                aopdealers.DealerDmaId = new Guid(this.hidDealerID.Text.ToString());
                aopdealers.ProductLineBumId = new Guid(this.hidDealerProdLineId.Text.ToString());
                aopdealers.MarketType = this.hidIsEmerging.Text.Equals("") ? "0" : this.hidIsEmerging.Text;
                aopdealers.Year = this.hidDealerAopYear.Value.ToString();
                aopdealers.Amount1 = double.Parse(this.txtAmount_1.Text);
                aopdealers.Amount2 = double.Parse(this.txtAmount_2.Text);
                aopdealers.Amount3 = double.Parse(this.txtAmount_3.Text);
                aopdealers.Amount4 = double.Parse(this.txtAmount_4.Text);
                aopdealers.Amount5 = double.Parse(this.txtAmount_5.Text);
                aopdealers.Amount6 = double.Parse(this.txtAmount_6.Text);
                aopdealers.Amount7 = double.Parse(this.txtAmount_7.Text);
                aopdealers.Amount8 = double.Parse(this.txtAmount_8.Text);
                aopdealers.Amount9 = double.Parse(this.txtAmount_9.Text);
                aopdealers.Amount10 = double.Parse(this.txtAmount_10.Text);
                aopdealers.Amount11 = double.Parse(this.txtAmount_11.Text);
                aopdealers.Amount12 = double.Parse(this.txtAmount_12.Text);

                //bool mctl = _contractMasterBLL.SaveAopDealers(new Guid(this.hidContractID.Text.ToString()), aopdealers);
                //e.Success = true;
                double totalDealerAop = aopdealers.Amount1 + aopdealers.Amount2 + aopdealers.Amount3 + aopdealers.Amount4 + aopdealers.Amount5 + aopdealers.Amount6 + aopdealers.Amount7 + aopdealers.Amount8 + aopdealers.Amount9 + aopdealers.Amount10 + aopdealers.Amount11 + aopdealers.Amount12;

                AopRemark ar = new AopRemark();
                ar.Type = "Dealer";
                ar.Contractid = new Guid(this.hidContractID.Text.ToString());

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text.ToString());
                obj.Add("Year", this.hidDealerAopYear.Value.ToString());

                DataTable dt = _contractMasterBLL.GetAopProductHospitalAmount(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    double hosAmounttotal = double.Parse(dt.Rows[0]["RefTotal"].ToString());

                    if (hosAmounttotal > 0)
                    {
                        if (((totalDealerAop - hosAmounttotal) >= 0 && (hosAmounttotal == 0 || ((totalDealerAop - hosAmounttotal) / hosAmounttotal) < 0.2)) || !this.txtDealerAopRemark.Text.Equals(""))
                        {
                            bool mctl = _contractMasterBLL.SaveAopDealers(new Guid(this.hidContractID.Text.ToString()), aopdealers);
                            _contractMasterBLL.DeleteAopRemark(ar);

                            ar.Body = this.txtDealerAopRemark.Text;
                            ar.Id = Guid.NewGuid();
                            _contractMasterBLL.SaveAopRemark(ar);

                            e.Success = true;
                        }
                        else
                        {
                            e.ErrorMessage = "请填写经销商指标小于医院指标或大于医院指标20%原因";
                            e.Success = false;
                            //retrunMsg = "经销商指标不能小于医院指标并且不能大于医院指标的20%";
                        }
                    }
                    else
                    {
                        e.ErrorMessage = "请先维护医院指标";
                        e.Success = false;
                        //retrunMsg = "请先维护医院指标";
                    }
                }
                else
                {
                    e.ErrorMessage = "请先维护医院指标";
                    e.Success = false;
                    //retrunMsg = "请先维护医院指标";
                }

            }
            catch (Exception ex)
            {
                //retrunMsg = ex.ToString();
                e.Success = false;
            }
            //return retrunMsg;
        }
        #endregion

        #region 页面控件权限设定

        /// <summary>
        /// 设定参数值
        /// </summary>
        private void SetInitialValue()
        {
            Hashtable obj = new Hashtable();
            if (!String.IsNullOrEmpty(this.hidDivisionID.Value.ToString()))
            {
                obj.Add("DivisionID", this.hidDivisionID.Value.ToString());
            }
            obj.Add("IsEmerging", "0");

            DataTable dtProductLine = _contractMasterBLL.GetProductLineByDivisionID(obj).Tables[0];

            this.hidProductLineId.Text = dtProductLine.Rows[0]["AttributeID"].ToString();

            int Effective = Convert.ToInt32(this.HidEffectiveDate.Text.Substring(0, 4));
            int Expiration = Convert.ToInt32(this.HidExpirationDate.Text.Substring(0, 4));

            string year = null;
            for (int getYear = Effective; getYear <= Expiration; getYear++)
            {
                year += (getYear.ToString() + ',');
            }
            this.hidYearString.Text = year;
            this.hidMinYear.Text = (Effective - 1).ToString();
        }

        #endregion

        #region 构建产品分类Price
        [AjaxMethod]
        public string RefreshLines()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = this.BuildMenuTree(null);
            return nodes.ToJson();
        }

        private Coolite.Ext.Web.TreeNodeCollection BuildMenuTree(Coolite.Ext.Web.TreeNodeCollection nodes)
        {

            if (nodes == null)
            {
                nodes = new Coolite.Ext.Web.TreeNodeCollection();
            }

            try
            {
                Coolite.Ext.Web.TreeNode rootNode = new Coolite.Ext.Web.TreeNode();
                rootNode.Text = "产品分类价格";
                rootNode.NodeID = this.hidProductLineId.Text;
                rootNode.Icon = Icon.FolderHome;
                rootNode.Expanded = true;
                rootNode.Checked = ThreeStateBool.Undefined;
                nodes.Add(rootNode);

                Hashtable objpr = new Hashtable();
                objpr.Add("ContractId", this.hidContractID.Text);
                DataTable dtProduct = _contractMasterBLL.GetContractProductClassification(objpr).Tables[0];

                DataTable dtPrice = _contractMasterBLL.GetContractProductClassificationPrice(objpr).Tables[0];
                dtPrice.PrimaryKey = new DataColumn[] { dtPrice.Columns[0] };

                int Effective = Convert.ToInt32(this.HidEffectiveDate.Text.Substring(0, 4));
                Hashtable obj = new Hashtable();
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                obj.Add("Active", "1");
                obj.Add("Year", Effective);
                DataTable dtProductPrice = _contractMasterBLL.GetProductClassificationPrice(obj).Tables[0];

                foreach (DataRow dr in dtProduct.Rows)
                {
                    Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();
                    node.Icon = Coolite.Ext.Web.Icon.NoteAdd;

                    if (dtProductPrice.Rows.Count > 0)
                    {
                        DataRow[] drArry = dtProductPrice.Select("PctId='" + dr["PctId"].ToString() + "'");
                        if (drArry.Length > 1)
                        {
                            node.NodeID = dr["PctId"].ToString();
                            node.Text = dr["PctNamecn"].ToString();
                            node.Expanded = true;
                            foreach (DataRow drp in drArry)
                            {
                                Coolite.Ext.Web.TreeNode nodeChild = new Coolite.Ext.Web.TreeNode();
                                nodeChild.NodeID = drp["PcpId"].ToString();
                                nodeChild.Text = drp["Namecn"].ToString() + "(" + drp["Price"].ToString() + ":" + drp["Remark"].ToString() + ")";
                                nodeChild.Icon = Coolite.Ext.Web.Icon.NoteAdd;
                                nodeChild.Expanded = false;

                                DataRow[] drPrc = dtPrice.Select("PcpId='" + drp["PcpId"].ToString() + "'");
                                if (drPrc.Length > 0)
                                {
                                    nodeChild.Checked = ThreeStateBool.True;
                                }
                                else
                                {
                                    nodeChild.Checked = ThreeStateBool.False;
                                }


                                node.Nodes.Add(nodeChild);
                            }
                        }
                        else if (drArry.Length == 1)
                        {
                            node.NodeID = drArry[0]["PcpId"].ToString();
                            if (!drArry[0]["Price"].ToString().Equals(""))
                            {
                                node.Text = dr["PctNamecn"].ToString() + "(" + drArry[0]["Price"].ToString() + ")";
                            }
                            else
                            {
                                node.Text = dr["PctNamecn"].ToString();
                            }

                            node.Expanded = false;
                            node.Checked = ThreeStateBool.True;
                        }
                    }
                    rootNode.Nodes.Add(node);
                }
            }
            catch (Exception ex)
            {

            }
            return nodes;
        }

        #endregion

        #region 构建产品分类Product
        [AjaxMethod]
        public string RefreshLinesProduct()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = this.BuildMenuTreeProduct(null);
            return nodes.ToJson();
        }

        private Coolite.Ext.Web.TreeNodeCollection BuildMenuTreeProduct(Coolite.Ext.Web.TreeNodeCollection nodes)
        {

            if (nodes == null)
            {
                nodes = new Coolite.Ext.Web.TreeNodeCollection();
            }

            try
            {
                Coolite.Ext.Web.TreeNode rootNode = new Coolite.Ext.Web.TreeNode();
                rootNode.Text = "产品分类";
                rootNode.NodeID = this.hidProductLineId.Text;
                rootNode.Icon = Icon.FolderHome;
                rootNode.Expanded = true;
                rootNode.Checked = ThreeStateBool.Undefined;
                nodes.Add(rootNode);

                Hashtable obj = new Hashtable();
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                obj.Add("Active", "1");

                IList<ProductClassification> ListproductStandard = _contractMasterBLL.GetProductClassificationByProductLineId(obj);

                Hashtable obj1 = new Hashtable();
                obj1.Add("ContractId", this.hidContractID.Text);
                obj1.Add("DealerDmaId", this.hidDealerID.Text);
                obj1.Add("ProductLineBumId", this.hidProductLineId.Text);
                obj1.Add("HosId", this.hidAuthor_HospitalId.Value.ToString());
                dtHasAuther = _contractMasterBLL.GetHospitalProductMapping(obj1).Tables[0];

                foreach (ProductClassification productStandard in ListproductStandard)
                {
                    Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();
                    node.NodeID = productStandard.Id.ToString();
                    node.Text = productStandard.Namecn;
                    node.Icon = Coolite.Ext.Web.Icon.NoteAdd;
                    node.Expanded = false;
                    if (dtHasAuther.Rows.Count > 0)
                    {
                        DataRow[] drArry = dtHasAuther.Select("PctId='" + productStandard.Id.ToString() + "'");
                        if (drArry.Length > 0)
                        {
                            node.Checked = ThreeStateBool.True;
                        }
                        else
                        {
                            node.Checked = ThreeStateBool.False;
                        }
                    }
                    else
                    {
                        node.Checked = ThreeStateBool.False;
                    }
                    rootNode.Nodes.Add(node);

                }
            }
            catch (Exception ex)
            {

            }
            return nodes;

        }
        #endregion

        #region 构建产品分类Product2
        [AjaxMethod]
        public string RefreshLinesProduct2()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = this.BuildMenuTreeProduct2(null);
            return nodes.ToJson();
        }

        private Coolite.Ext.Web.TreeNodeCollection BuildMenuTreeProduct2(Coolite.Ext.Web.TreeNodeCollection nodes)
        {

            if (nodes == null)
            {
                nodes = new Coolite.Ext.Web.TreeNodeCollection();
            }

            try
            {
                Coolite.Ext.Web.TreeNode rootNode = new Coolite.Ext.Web.TreeNode();
                rootNode.Text = "产品分类";
                rootNode.NodeID = this.hidProductLineId.Text;
                rootNode.Icon = Icon.FolderHome;
                rootNode.Expanded = true;
                rootNode.Checked = ThreeStateBool.Undefined;
                nodes.Add(rootNode);

                Hashtable obj = new Hashtable();
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);
                obj.Add("Active", "1");

                IList<ProductClassification> ListproductStandard = _contractMasterBLL.GetProductClassificationByProductLineId(obj);

                foreach (ProductClassification productStandard in ListproductStandard)
                {
                    Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();
                    node.NodeID = productStandard.Id.ToString();
                    node.Text = productStandard.Namecn;
                    node.Icon = Coolite.Ext.Web.Icon.NoteAdd;
                    node.Expanded = false;
                    if (productStandard.Rv3 != null && productStandard.Rv3.ToString().Equals("1"))
                    {
                        node.Checked = ThreeStateBool.False;
                    }
                    else 
                    {
                        node.Checked = ThreeStateBool.True;
                    }
                    rootNode.Nodes.Add(node);
                }
            }
            catch (Exception ex)
            {

            }
            return nodes;

        }
        #endregion

        #region Amendmen同步正式表
        private void SynchronousFormalDealerHospitalProductAOP()
        {
            if (this.hidIsChange.Value != null && this.hidIsChange.Value.ToString().Equals("1"))
            {
                //确认授权是否维护
                DataSet ds = _contractMasterBLL.QueryAuthorizationTempListForDataSet(new Guid(this.hidContractID.Text));
                if (ds.Tables[0].Rows.Count == 0)
                {
                    Hashtable objterry = new Hashtable();

                    if (!String.IsNullOrEmpty(this.hidDivisionID.Value.ToString()))
                    {
                        objterry.Add("DivisionID", this.hidDivisionID.Value.ToString());
                    }
                    objterry.Add("IsEmerging", "0");

                    DataTable dtProductLine = _contractMasterBLL.GetProductLineByDivisionID(objterry).Tables[0];
                    for (int i = 0; i < dtProductLine.Rows.Count; i++)
                    {
                        DealerAuthorization temp = new DealerAuthorization();
                        temp.PmaId = new Guid(dtProductLine.Rows[i]["AttributeID"].ToString());
                        temp.Id = Guid.NewGuid();
                        temp.DclId = new Guid(this.hidContractID.Text);
                        temp.DmaId = new Guid(this.hidDealerID.Text);
                        temp.ProductLineBumId = new Guid(dtProductLine.Rows[i]["AttributeID"].ToString());
                        temp.AuthorizationType = "0";
                        _contractMasterBLL.SaveAuthorizationTemp(temp);
                        //this.hiddenId.Value = temp.Id.ToString();
                        //this.hiddenProductLine.Value = temp.PmaId.ToString();
                        if (this.hidIsChange.Value != null && this.hidIsChange.Value.ToString().Equals("1"))
                        {
                            Hashtable formal = new Hashtable();
                            formal.Add("Dma_Id", temp.DmaId);
                            formal.Add("Plb_Id", temp.ProductLineBumId);
                            formal.Add("Dat_Id", temp.Id);
                            formal.Add("IsEmerging", this.hidIsEmerging.Value.ToString().Equals("") ? "0" : this.hidIsEmerging.Value.ToString());

                            _contractMasterBLL.SynchronousHospitalListTemp(formal);
                        }
                    }
                }

                Hashtable obj = new Hashtable();
                obj.Add("Dma_Id", this.hidDealerID.Text.ToString());
                obj.Add("Plb_Id", this.hidProductLineId.Text.ToString());
                obj.Add("Con_Id", this.hidContractID.Text);
                obj.Add("YearString", this.hidYearString.Text);
                obj.Add("minYear", this.hidMinYear.Text);
                obj.Add("IsEmerging", this.hidIsEmerging.Value.ToString().Equals("") ? "0" : this.hidIsEmerging.Value.ToString());


                _contractMasterBLL.SynchronousFormalDealerHospiatlProductAOPTemp(new Guid(this.hidContractID.Text), obj);
            }
        }
        #endregion

        #region 修改指标Init
        private void InitEditControlState(int state, string modYear, string type)
        {
            switch (state)
            {
                case 1:
                    if (type == "Amount")
                    {
                        this.txtDealerAopYear.Enabled = true;
                    }
                    if (type == "Unit")
                    {
                        this.txtYear.Enabled = true;
                    }
                    for (int i = 1; i <= 12; i++)
                    {
                        if (type == "Amount")
                        {
                            TextField tempAmount = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                            tempAmount.Enabled = true;
                        }
                        if (type == "Unit")
                        {
                            TextField tempUnit = this.FindControl("txtUnit_" + i.ToString()) as TextField;
                            tempUnit.Enabled = true;
                        }
                    }
                    if (type == "Amount")
                    {
                        this.SaveAmountButton.Enabled = true;
                    }
                    if (type == "Unit")
                    {
                        this.SaveUnitButton.Enabled = true;
                    }

                    break;
                case 2:
                    if (type == "Amount")
                    {
                        this.txtDealerAopYear.Enabled = true;
                    }
                    if (type == "Unit")
                    {
                        this.txtYear.Enabled = true;
                    }
                    int Year = Convert.ToInt32((modYear == null ? "0" : modYear));

                    if (this.hidContractType.Text.ToString().Equals("Appointment"))
                    {
                        #region Appointment
                        DateTime dtNewNow = Convert.ToDateTime(this.HidEffectiveDate.Text);
                        TextField temptf = null;
                        for (int i = 1; i < 13; i++)
                        {
                            if (type == "Amount")
                            {
                                temptf = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                            }
                            if (type == "Unit")
                            {
                                temptf = this.FindControl("txtUnit_" + i.ToString()) as TextField;
                            }

                            if (Year > DateTime.Now.Year)
                            {
                                temptf.Enabled = true;
                                this.hidMinMonth.Value = "1";

                                if (type == "Amount")
                                {
                                    this.SaveAmountButton.Enabled = true;
                                }
                                if (type == "Unit")
                                {
                                    this.SaveUnitButton.Enabled = true;
                                }
                                break;
                            }
                            else 
                            {
                                if (i < dtNewNow.Month)
                                {
                                    temptf.Enabled = false;
                                }
                                else 
                                {
                                    temptf.Enabled = true;
                                    this.hidMinMonth.Value = i.ToString();
                                    break;
                                }
                            }
                        }
                        if (type == "Amount")
                        {
                            this.SaveAmountButton.Enabled = true;
                        }
                        if (type == "Unit")
                        {
                            this.SaveUnitButton.Enabled = true;
                        }
                        #endregion
                    }
                    else if (this.hidContractType.Text.ToString().Equals("Amendment"))
                    {
                        #region Amendment
                        DateTime dtNewNow = Convert.ToDateTime(this.HidEffectiveDate.Text) > DateTime.Now.AddDays(15) ? Convert.ToDateTime(this.HidEffectiveDate.Text) : DateTime.Now.AddDays(15);

                        for (int i = 1; i < 13; i++)
                        {
                            TextField temptf = null;
                            if (type == "Amount")
                            {
                                temptf = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                            }
                            if (type == "Unit")
                            {
                                temptf = this.FindControl("txtUnit_" + i.ToString()) as TextField;
                            }

                            if (Year > DateTime.Now.Year)
                            {
                                temptf.Enabled = true;
                                this.hidMinMonth.Value = "1";

                                if (type == "Amount")
                                {
                                    this.SaveAmountButton.Enabled = true;
                                }
                                if (type == "Unit")
                                {
                                    this.SaveUnitButton.Enabled = true;
                                }
                                break;
                            }
                            else if (Year == DateTime.Now.Year)
                            {
                                if (dtNewNow.Year > DateTime.Now.Year)
                                {
                                    temptf.Enabled = false;
                                    if (type == "Amount")
                                    {
                                        this.SaveAmountButton.Enabled = false;
                                    }
                                    if (type == "Unit")
                                    {
                                        this.SaveUnitButton.Enabled = false;
                                    }
                                }
                                else
                                {
                                    if (i < dtNewNow.Month)
                                    {
                                        // i >= 判断开始时间
                                        if (DateTime.Now.AddDays(15) > Convert.ToDateTime(this.HidEffectiveDate.Text))
                                        {
                                            //表示系统时间是控制时间
                                            if (i == DateTime.Now.AddDays(15).Month)
                                            {
                                                temptf.Enabled = true;
                                                this.hidMinMonth.Value = i.ToString();
                                                break;
                                            }
                                            else
                                            {
                                                temptf.Enabled = false;
                                            }
                                        }
                                        else
                                        {
                                            //合同开始时间是控制时间
                                            if (i == Convert.ToDateTime(this.HidEffectiveDate.Text).Month)
                                            {
                                                temptf.Enabled = true;
                                                this.hidMinMonth.Value = i.ToString();
                                                break;
                                            }
                                            else
                                            {
                                                temptf.Enabled = false;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        temptf.Enabled = true;
                                        this.hidMinMonth.Value = i.ToString();
                                        if (type == "Amount")
                                        {
                                            this.SaveAmountButton.Enabled = true;
                                        }
                                        if (type == "Unit")
                                        {
                                            this.SaveUnitButton.Enabled = true;
                                        }
                                        break;
                                    }
                                }
                            }
                            else
                            {
                                temptf.Enabled = false;
                                this.hidMinMonth.Value = "13";
                                if (type == "Amount")
                                {
                                    this.SaveAmountButton.Enabled = false;
                                }
                                if (type == "Unit")
                                {
                                    this.SaveUnitButton.Enabled = false;
                                }
                                break;
                            }
                        }
                        #endregion
                    }
                    else if (this.hidContractType.Text.ToString().Equals("Renewal"))
                    {
                        #region Renewal
                        this.hidMinMonth.Value = "1";
                        #endregion
                    }
                    break;
            }
        }

        private void InitEditValue(string Type)
        {
            if (Type.Equals("Unit"))
            {
                this.txtFormalUnit_1.Value = "";
                this.txtFormalUnit_2.Value = "";
                this.txtFormalUnit_3.Value = "";
                this.txtFormalUnit_4.Value = "";
                this.txtFormalUnit_5.Value = "";
                this.txtFormalUnit_6.Value = "";
                this.txtFormalUnit_7.Value = "";
                this.txtFormalUnit_8.Value = "";
                this.txtFormalUnit_9.Value = "";
                this.txtFormalUnit_10.Value = "";
                this.txtFormalUnit_11.Value = "";
                this.txtFormalUnit_12.Value = "";
            }
            else if (Type.Equals("Amount"))
            {
                this.txtAmount_1.Value = "";
                this.txtAmount_2.Value = "";
                this.txtAmount_3.Value = "";
                this.txtAmount_4.Value = "";
                this.txtAmount_5.Value = "";
                this.txtAmount_6.Value = "";
                this.txtAmount_7.Value = "";
                this.txtAmount_8.Value = "";
                this.txtAmount_9.Value = "";
                this.txtAmount_10.Value = "";
                this.txtAmount_11.Value = "";
                this.txtAmount_12.Value = "";
            }

        }

        private void SetGridSelect(int i)
        {
            RowSelectionModel sm = this.txtGPHospitalUpdate.SelectionModel.Primary as RowSelectionModel;
            sm.SelectedRows.Clear();
            sm.SelectedRows.Add(new SelectedRow(i - 1));
            sm.UpdateSelection();
        }

        #endregion

    }
}
