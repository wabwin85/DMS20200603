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

    public partial class ContractAOPListV2 : BasePage
    {
        private IContractMasterBLL _contractMasterBll = new ContractMasterBLL();
        private IContractCommonBLL _contractCommon = new ContractCommonBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
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
                    this.hidContractID.Text = this.Request.QueryString["InstanceID"];
                    this.hidDivisionID.Text = this.Request.QueryString["DivisionID"];
                    this.hidDealerID.Text = this.Request.QueryString["TempDealerID"];
                    this.HidEffectiveDate.Text = this.Request.QueryString["EffectiveDate"];
                    this.HidExpirationDate.Text = this.Request.QueryString["ExpirationDate"];
                    this.hidContractType.Text = this.Request.QueryString["ContractType"].ToString();
                    this.hidPartsContractCode.Text = this.Request.QueryString["PartsContractCode"];//合同分类Code

                    if (this.Request.QueryString["IsEmerging"] != null)
                    {
                        this.hidIsEmerging.Text = this.Request.QueryString["IsEmerging"].ToString();
                    }
                    else
                    {
                        this.hidIsEmerging.Text = "0";
                    }

                    SetInitialValue();
                    SynchronousFormalAOPToTemp();
                    BuildTreePrice(this.PriceTree.Root);
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
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerDmaId", this.hidDealerID.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);

                int start = 0; int limit = this.PagingToolBarAOP.PageSize;
                if (e.Start > -1)
                {
                    start = e.Start;
                    limit = e.Limit;
                }
                DataTable dt = _contractCommon.QueryHospitalProductAOPTemp(obj, start, limit, out totalCount).Tables[0];
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
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerDmaId", this.hidDealerID.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);

                DataTable dt = _contractCommon.QueryHospitalProductAOPTemp(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarEdit.PageSize : e.Limit), out totalCount).Tables[0];
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
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerDmaId", this.hidDealerID.Text);
                obj.Add("ProductLineBumId", this.hidProductLineId.Text);

                DataTable dt = _contractMasterBll.QueryHospitalProductByDealerTotleAOP2(obj).Tables[0];
                AOPDealerStore.DataSource = dt;
                AOPDealerStore.DataBind();
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }
        #endregion

        //Button 修改
        protected void EditAop_Click(object sender, AjaxEventArgs e)
        {
            this.txtGPHospitalUpdate.Reload();
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

                this.InitEditValue("Unit");
                this.InitEditControlState(sellist[0]["Year"].ToString(), "Unit");


                Guid hospitalid = new Guid(sellist[0]["HospitalId"]);
                string hospitalName = sellist[0]["HospitalName"];
                string Productification = sellist[0]["ProductId"];
                this.txtClassificationName.Text = sellist[0]["ProductName"];
                this.hidClassification.Value = Productification;

                VAopICDealerHospital aopdealers = _contractMasterBll.GetYearAopHospitalForIC(contractId, dealerDmaId, productLineBumId, year, hospitalid, Productification);
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

                SetGridSelect(Convert.ToInt32(sellist[0]["row_number"].ToString()));
                this.AOPHospitalWindow.Show();
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

                VAopICDealerHospital aopdealers = _contractMasterBll.GetYearAopHospitalForIC(contractId, dealerDmaId, productLineBumId, year, hospitalid, Productification);
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
                e.Success = true;
            }
        }
        protected void EditDealerAop_Click(object sender, AjaxEventArgs e)
        {

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
                this.InitEditValue("Amount");
                this.InitEditControlState(year, "Amount");


                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text.ToString());
                obj.Add("Year", year);
                VAopDealer AopDealerTmp = _contractCommon.QueryDealerAOPAndHospitalAOPUnitTemp(obj);

                this.hidDealerProdLineId.Value = productLineBumId.ToString();
                this.hidDealerAopYear.Value = AopDealerTmp.Year.ToString();
                this.txtDealerAopYear.Text = AopDealerTmp.Year.ToString();
                this.txtAmount_1.Value = AopDealerTmp.Amount1.ToString();
                this.txtAmount_2.Value = AopDealerTmp.Amount2.ToString();
                this.txtAmount_3.Value = AopDealerTmp.Amount3.ToString();
                this.txtAmount_4.Value = AopDealerTmp.Amount4.ToString();
                this.txtAmount_5.Value = AopDealerTmp.Amount5.ToString();
                this.txtAmount_6.Value = AopDealerTmp.Amount6.ToString();
                this.txtAmount_7.Value = AopDealerTmp.Amount7.ToString();
                this.txtAmount_8.Value = AopDealerTmp.Amount8.ToString();
                this.txtAmount_9.Value = AopDealerTmp.Amount9.ToString();
                this.txtAmount_10.Value = AopDealerTmp.Amount10.ToString();
                this.txtAmount_11.Value = AopDealerTmp.Amount11.ToString();
                this.txtAmount_12.Value = AopDealerTmp.Amount12.ToString();
                this.txtDealerAopRemark.Text = AopDealerTmp.RmkBody.ToString();
                this.hidDealerAopRemarkId.Text = AopDealerTmp.RmkId == null ? "" : AopDealerTmp.RmkId.Value.ToString();

                this.txtReHosAmount_1.Value = AopDealerTmp.ReAmount1.ToString();
                this.txtReHosAmount_2.Value = AopDealerTmp.ReAmount2.ToString();
                this.txtReHosAmount_3.Value = AopDealerTmp.ReAmount3.ToString();
                this.txtReHosAmount_4.Value = AopDealerTmp.ReAmount4.ToString();
                this.txtReHosAmount_5.Value = AopDealerTmp.ReAmount5.ToString();
                this.txtReHosAmount_6.Value = AopDealerTmp.ReAmount6.ToString();
                this.txtReHosAmount_7.Value = AopDealerTmp.ReAmount7.ToString();
                this.txtReHosAmount_8.Value = AopDealerTmp.ReAmount8.ToString();
                this.txtReHosAmount_9.Value = AopDealerTmp.ReAmount9.ToString();
                this.txtReHosAmount_10.Value = AopDealerTmp.ReAmount10.ToString();
                this.txtReHosAmount_11.Value = AopDealerTmp.ReAmount11.ToString();
                this.txtReHosAmount_12.Value = AopDealerTmp.ReAmount12.ToString();

                this.WindowDealerAop.Show();
                e.Success = true;
            }
        }

        //Button 保存
        [AjaxMethod]
        public string SaveProductPrice(string PriceIdString)
        {
            string massage = "";
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("DealerId", this.hidDealerID.Text);
                obj.Add("ProductLineId", this.hidProductLineId.Text);
                obj.Add("ContractType", this.hidContractType.Value.ToString());
                obj.Add("MarketType", this.hidIsEmerging.Text);
                obj.Add("YearString", this.hidYearString.Value.ToString());
                obj.Add("BeginYearMinMonth", this.hidBeginYearMinMonth.Text);
                obj.Add("AOPType", "Unit");
                obj.Add("PartsContractCode", this.hidPartsContractCode.Text);
                obj.Add("IsAmountSy", "");

                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");

                Hashtable objCK = new Hashtable();
                objCK.Add("ContractId", this.hidContractID.Text);
                objCK.Add("ProductLineBumId", this.hidProductLineId.Text);
                objCK.Add("priceidString", PriceIdString);
                DataTable dt = _contractMasterBll.CheckAuthorProductPrice(objCK).Tables[0];

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
                    _contractMasterBll.SubmintHospitalProductPrice(objCK);

                    _contractCommon.MaintainDealerAOPByHospitalAOP(obj);
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

                if (Math.Round(AOPValue, 3) < Math.Round(FormalValue, 3))
                {
                    if (this.hospitaleRemark.Text.Equals(""))
                    {
                        e.ErrorMessage = "实际指标小于标准指标，请填写原因";
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

                        _contractMasterBll.DeleteAopRemark(ar);
                        _contractMasterBll.SaveAopRemark(ar);
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

                int MinMonth = 1;
                if (this.hidMinYear.Text.Equals(this.txtYear.Text.ToString()))
                {
                    if (!this.hidBeginYearMinMonth.Value.ToString().Equals(""))
                    {
                        MinMonth = Convert.ToInt32(this.hidBeginYearMinMonth.Value.ToString());
                    }
                }
                bool mctl = _contractCommon.SaveHospitalProductAOPUnit(new Guid(this.hidContractID.Text.ToString()), this.hidPartsContractCode.Text, aopdealers, MinMonth);
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

                double totalDealerAop = aopdealers.Amount1 + aopdealers.Amount2 + aopdealers.Amount3 + aopdealers.Amount4 + aopdealers.Amount5 + aopdealers.Amount6 + aopdealers.Amount7 + aopdealers.Amount8 + aopdealers.Amount9 + aopdealers.Amount10 + aopdealers.Amount11 + aopdealers.Amount12;

                AopRemark ar = new AopRemark();
                ar.Type = "Dealer";
                ar.Contractid = new Guid(this.hidContractID.Text.ToString());

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text.ToString());
                obj.Add("Year", this.hidDealerAopYear.Value.ToString());

                double hosAmounttotal = double.Parse(this.txtReHosAmount_1.Text) + double.Parse(this.txtReHosAmount_2.Text) + double.Parse(this.txtReHosAmount_3.Text)
                                        + double.Parse(this.txtReHosAmount_4.Text) + double.Parse(this.txtReHosAmount_5.Text) + double.Parse(this.txtReHosAmount_6.Text)
                                        + double.Parse(this.txtReHosAmount_7.Text) + double.Parse(this.txtReHosAmount_8.Text) + double.Parse(this.txtReHosAmount_9.Text)
                                        + double.Parse(this.txtReHosAmount_10.Text) + double.Parse(this.txtReHosAmount_11.Text) + double.Parse(this.txtReHosAmount_12.Text);

                if (hosAmounttotal > 0)
                {
                    if ((System.Math.Abs(totalDealerAop - hosAmounttotal) < 0.01) || (
                            (
                                (totalDealerAop - hosAmounttotal >= 0
                                    && ((totalDealerAop - hosAmounttotal) / hosAmounttotal < 0.2))
                            )

                      || !this.txtDealerAopRemark.Text.Equals("")))
                    {
                        bool mctl = _contractCommon.SaveAopDealerTemp(this.hidContractID.Text, this.hidPartsContractId.Text, aopdealers);
                        _contractMasterBll.DeleteAopRemark(ar);
                        ar.Body = this.txtDealerAopRemark.Text;
                        ar.Id = Guid.NewGuid();
                        _contractMasterBll.SaveAopRemark(ar);

                        e.Success = true;
                    }
                    else
                    {
                        e.ErrorMessage = "请填写经销商指标小于医院指标或大于医院指标20%原因";
                        e.Success = false;
                    }
                }
                else
                {
                    e.ErrorMessage = "请先维护医院指标";
                    e.Success = false;
                }
            }
            catch (Exception ex)
            {
                e.Success = false;
            }
        }



        #region Function
        private string ProductLineId(string divisionID)
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
            Hashtable obj = new Hashtable();
            obj.Add("PartsContractCode", PartsContractCode);
            obj.Add("ProductYear", Convert.ToDateTime(this.HidEffectiveDate.Text).Year.ToString());
            ClassificationContract pcc = _contractCommon.GetPartContractIdByCCCode(obj)[0];
            if (pcc != null)
            {
                partsContractId = pcc.Id.ToString();
            }
            return partsContractId;
        }
        private void SetInitialValue()
        {
            // 1. 获取产品线ID
            this.hidProductLineId.Text = ProductLineId(this.Request.QueryString["DivisionID"].ToString());
            // 2. 获取合同年份跨度
            int Effective = Convert.ToDateTime(this.HidEffectiveDate.Text).Year;
            int Expiration = Convert.ToDateTime(this.HidExpirationDate.Text).Year;
            this.hidMinYear.Text = Effective.ToString();
            string year = null;

            for (int getYear = Effective; getYear <= Expiration; getYear++)
            {
                year += (getYear.ToString() + ',');
            }
            this.hidYearString.Text = year;
            // 3.获取合同起始年份上一年
            //this.hidMinYear.Text = (Effective - 1).ToString();

            //4.获取合同分类ID
            this.hidPartsContractId.Text = PartsContractId(this.hidPartsContractCode.Text);

            this.hidBeginYearMinMonth.Text = Convert.ToDateTime(this.HidEffectiveDate.Text).Month.ToString();
        }
        private void SynchronousFormalAOPToTemp()
        {
            Guid conId = new Guid(this.hidContractID.Text);
            DataTable dtCheck = _contractMasterBll.QueryAuthorizationTempListForDataSet(conId).Tables[0];
            if (dtCheck.Rows.Count == 0 && this.hidContractType.Text.Equals("Appointment"))
            {
                Ext.MessageBox.Alert("错误", "请先维护经销商授权！").Show();
                return;
            }
            else if (dtCheck.Rows.Count == 0 && !this.hidContractType.Text.Equals("Appointment"))
            {
                //同步正式表授权
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Value.ToString());
                obj.Add("DealerId", this.hidDealerID.Value.ToString());
                obj.Add("ProductLineId", this.hidProductLineId.Value.ToString());
                obj.Add("PartsContractCode", this.hidPartsContractCode.Value.ToString());
                obj.Add("MarketType", this.hidIsEmerging.Value.ToString());
                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");
                _contractCommon.SysFormalAuthorizationToTemp(obj);
            }

            Hashtable syObj = new Hashtable();
            syObj.Add("ContractId", this.hidContractID.Text);
            syObj.Add("DealerId", this.hidDealerID.Text.ToString());
            syObj.Add("ProductLineId", this.hidProductLineId.Text.ToString());
            syObj.Add("YearString", this.hidYearString.Text);
            syObj.Add("IsEmerging", this.hidIsEmerging.Value.ToString());
            syObj.Add("ContractType", this.hidContractType.Text);
            syObj.Add("BeginYearMinMonth", this.hidBeginYearMinMonth.Text);
            syObj.Add("PartsContractCode", this.hidPartsContractCode.Value.ToString());
            syObj.Add("RtnVal", "");
            syObj.Add("RtnMsg", "");
            _contractCommon.SynchronousAOPToTempUnit(syObj);

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
                        tempUnit.Enabled = true;
                    }
                }
                else
                {
                    for (int i = 1; i <= 12; i++)
                    {
                        TextField tempUnit = this.FindControl("txtUnit_" + i.ToString()) as TextField;
                        tempUnit.Enabled = true;
                    }
                }
            }
            if (type.Equals("Amount"))
            {
                if (year == this.hidMinYear.Text)
                {
                    for (int i = minMonth; i <= 12; i++)
                    {
                        TextField temptf = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                        temptf.Enabled = true;
                    }
                }
                else
                {
                    for (int i = 1; i <= 12; i++)
                    {
                        TextField temptf = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                        temptf.Enabled = true;
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
                    TextField tempFormalUnit = this.FindControl("txtFormalUnit_" + i.ToString()) as TextField;
                    tempUnit.Value = "";
                    tempUnit.Enabled = false;
                    tempFormalUnit.Value = "";
                }
            }
            else if (Type.Equals("Amount"))
            {
                for (int i = 1; i <= 12; i++)
                {
                    TextField tempAmount = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                    tempAmount.Value = "";
                    tempAmount.Enabled = false;

                }
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

        #region 构建产品分类Price
        [AjaxMethod]
        public string RefreshLines()
        {
            Coolite.Ext.Web.TreeNodeCollection nodes = this.BuildTreePrice(null);
            return nodes.ToJson();
        }

        private Coolite.Ext.Web.TreeNodeCollection BuildTreePrice(Coolite.Ext.Web.TreeNodeCollection nodes)
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

                DataTable dtProduct = _contractCommon.GetClassificationQuotaTempByContractId(this.hidContractID.Text).Tables[0];

                DataTable dtPrice = _contractCommon.GetQuotaPriceTempByContractId(this.hidContractID.Text).Tables[0];
                dtPrice.PrimaryKey = new DataColumn[] { dtPrice.Columns[0] };

                int Effective = Convert.ToDateTime(this.HidEffectiveDate.Text).Year;
                int Expiration = Convert.ToDateTime(this.HidExpirationDate.Text).Year;
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("YearString", Expiration.ToString());
                DataTable dtAllProductPrice = _contractCommon.GetAllQuotaPriceForTemp(obj).Tables[0];

                Coolite.Ext.Web.TreeNode rootNodeYear = new Coolite.Ext.Web.TreeNode();
                rootNodeYear.Text = Expiration.ToString();
                rootNodeYear.NodeID = this.hidProductLineId.Text;
                rootNodeYear.Icon = Icon.NoteAdd;
                rootNodeYear.Expanded = true;
                rootNodeYear.Checked = ThreeStateBool.Undefined;
                rootNode.Nodes.Add(rootNodeYear);

                foreach (DataRow dr in dtProduct.Rows)
                {
                    Coolite.Ext.Web.TreeNode node = new Coolite.Ext.Web.TreeNode();
                    node.Icon = Coolite.Ext.Web.Icon.NoteAdd;

                    if (dtAllProductPrice.Rows.Count > 0)
                    {
                        DataRow[] drArry = dtAllProductPrice.Select("PctId='" + dr["PctId"].ToString() + "' and Year='" + Expiration.ToString() + "'");
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
                    rootNodeYear.Nodes.Add(node);
                }


            }
            catch (Exception ex)
            {

            }
            return nodes;
        }

        #endregion
    }
}
