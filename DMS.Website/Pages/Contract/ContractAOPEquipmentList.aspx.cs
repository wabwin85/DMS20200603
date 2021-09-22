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
    public partial class ContractAOPEquipmentList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IContractMasterBLL _contractMasterBLL = new ContractMasterBLL();

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
                SetProdLineIdValue();
                SynchronousFormalDealerHospitalAOP();
            }
        }

        #region Store

        public void AOPStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            try
            {
                int totalCount = 0;
                Guid? dmaId = null;
                String[] year = null;
                Guid?[] prodLineId = null;
                bool CheckYear = true;

                dmaId = new Guid(this.hidDealerID.Text.ToString());

                prodLineId = SetProdLineIdValue();

                int di = 0;
                int Effective = Convert.ToInt32(this.HidEffectiveDate.Text.Substring(0, 4));
                int Expiration = Convert.ToInt32(this.HidExpirationDate.Text.Substring(0, 4));
                year = new String[Expiration - Effective + 1];
                for (int getYear = Effective; getYear <= Expiration; getYear++)
                {
                    year[di] = getYear.ToString();
                    di = di + 1;
                }
                if (Effective > Expiration)
                {
                    CheckYear = false;
                }

                //year = this.HidYear.Text.ToString();
                int start = 0; int limit = this.PagingToolBar1.PageSize;
                if (e.Start > -1)
                {
                    start = e.Start;
                    limit = e.Limit;
                }

                System.Data.DataSet dataSource = _contractMasterBLL.GetAopDealersHospitalByQuery2(new Guid(this.hidContractID.Text.ToString()), dmaId, prodLineId, year, start, limit, out totalCount);

                if (sender is Store)
                {
                    if (CheckYear == true)
                    {
                        Store store1 = (sender as Store);
                        (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                        store1.DataSource = dataSource;
                        store1.DataBind();
                    }
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
                Guid? dmaId = null;
                String[] year = null;
                Guid?[] prodLineId = null;
                bool CheckYear = true;

                dmaId = new Guid(this.hidDealerID.Text.ToString());
                prodLineId = SetProdLineIdValue();

                int di = 0;
                int Effective = Convert.ToInt32(this.HidEffectiveDate.Text.Substring(0, 4));
                int Expiration = Convert.ToInt32(this.HidExpirationDate.Text.Substring(0, 4));
                year = new String[Expiration - Effective + 1];
                for (int getYear = Effective; getYear <= Expiration; getYear++)
                {
                    year[di] = getYear.ToString();
                    di = di + 1;
                }
                if (Effective > Expiration)
                {
                    CheckYear = false;
                }

                int start = 0; int limit = this.PagingToolBar1.PageSize;
                if (e.Start > -1)
                {
                    start = e.Start;
                    limit = e.Limit;
                }

                System.Data.DataSet dataSource = _contractMasterBLL.GetAopDealersHospitalByQuery2(new Guid(this.hidContractID.Text.ToString()), dmaId, prodLineId, year, start, limit, out totalCount);

                if (sender is Store)
                {
                    if (CheckYear == true)
                    {
                        Store store1 = (sender as Store);
                        store1.DataSource = dataSource;
                        store1.DataBind();
                    }
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
                Guid? dmaId = null;
                string year = null;
                dmaId = new Guid(this.hidDealerID.Text.ToString());
                System.Data.DataSet dataSource = null;

                if (this.hidContractType.Text.ToString().Equals("Amendment"))
                {
                    dataSource = _contractMasterBLL.GetAopDealerUnionHospitalHistoryQuery(new Guid(this.hidContractID.Text.ToString()), dmaId, null, year);
                }
                else 
                {
                    dataSource = _contractMasterBLL.GetAopDealerUnionHospitalQuery(new Guid(this.hidContractID.Text.ToString()), dmaId, null, year);
                }
                if (sender is Store)
                {
                    Store store1 = (sender as Store);
                    (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                    store1.DataSource = dataSource;
                    store1.DataBind();
                }

            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
        }

        #endregion

        protected void SaveAOP_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                VAopDealer aopdealers = new VAopDealer();
                aopdealers.DealerDmaId = new Guid(this.hidDealerID.Text.ToString());
                aopdealers.ProductLineBumId = new Guid(this.txtProdLine.Value.ToString());
                aopdealers.MarketType = this.hidIsEmerging.Text.Equals("") ? "0" : this.hidIsEmerging.Text;
                aopdealers.Year = this.txtHidYear.Value.ToString();
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
                
                string MinMonth = "0";
                if (!this.hidMinMonth.Value.ToString().Equals(""))
                {
                    MinMonth = this.hidMinMonth.Value.ToString();
                }
                double AOPValue = 0;
                double FormalValue = 0;
                for (int i = Convert.ToInt32(MinMonth); i <=12; i++)
                {
                    TextField temp = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                    TextField tempRe = this.FindControl("txtRe_" + i.ToString()) as TextField;
                    AOPValue += double.Parse(temp.Text);
                    FormalValue += double.Parse(tempRe.Text);
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

                        _contractMasterBLL.DeleteAopRemark(ar);
                        _contractMasterBLL.SaveAopRemark(ar);
                    }
                }
                else 
                {
                    AopRemark ar = new AopRemark();
                    ar.Id = Guid.NewGuid();
                    ar.Type = "Hospital";
                    ar.Contractid = new Guid(this.hidContractID.Text.ToString());
                    ar.HosId = new Guid(this.txtHospitalID.Text);
                    ar.Body = this.hospitaleRemark.Text;
                    _contractMasterBLL.DeleteAopRemark(ar);
                    if (!this.hospitaleRemark.Text.Equals(""))
                    {
                        _contractMasterBLL.SaveAopRemark(ar);
                    }
                }


                bool mctl = _contractMasterBLL.SaveAopHospital(new Guid(this.hidContractID.Text.ToString()), new Guid(this.txtHospitalID.Text), MinMonth, aopdealers);
                e.Success = true;
            }
            catch
            {
                e.Success = false;
            }
        }
        protected void EditAop_Click(object sender, AjaxEventArgs e)
        {
            this.hidAddMod.Text = "1";
            this.InitEditControlState(1, null);

            Guid dealerDmaId = new Guid(this.hidDealerID.Text.ToString());
            //Guid productLineBumId = new Guid(this.hidProdLineID.Text.ToString());
            Guid contractId = new Guid(this.hidContractID.Text.ToString());

            string editData = e.ExtraParams["editData"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                String[] year = new String[1];
                year[0] = sellist[0]["Year"];

                Guid?[] productLineBumId = new Guid?[1];
                productLineBumId[0] = new Guid(sellist[0]["ProductLine_BUM_ID"]);
                Guid hospitalid = new Guid(sellist[0]["Hospital_ID"]);
                string hospitalName = sellist[0]["Hospital_Name"];
                VAopDealer aopdealers = _contractMasterBLL.GetYearAopHospital(contractId, dealerDmaId, productLineBumId, year, hospitalid);
                this.txtHospitalID.Value = hospitalid.ToString();
                this.txtHospitalName.Text = hospitalName;
                this.txtProdLine.Value = aopdealers.ProductLineBumId.ToString();
                this.txtYear.Text = aopdealers.Year;
                this.txtHidYear.Value = aopdealers.Year;
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
                this.txtRe_1.Value = aopdealers.ReAmount1.ToString();
                this.txtRe_2.Value = aopdealers.ReAmount2.ToString();
                this.txtRe_3.Value = aopdealers.ReAmount3.ToString();
                this.txtRe_4.Value = aopdealers.ReAmount4.ToString();
                this.txtRe_5.Value = aopdealers.ReAmount5.ToString();
                this.txtRe_6.Value = aopdealers.ReAmount6.ToString();
                this.txtRe_7.Value = aopdealers.ReAmount7.ToString();
                this.txtRe_8.Value = aopdealers.ReAmount8.ToString();
                this.txtRe_9.Value = aopdealers.ReAmount9.ToString();
                this.txtRe_10.Value = aopdealers.ReAmount10.ToString();
                this.txtRe_11.Value = aopdealers.ReAmount11.ToString();
                this.txtRe_12.Value = aopdealers.ReAmount12.ToString();
                this.hospitaleRemark.Value = aopdealers.RmkBody.ToString();

                this.hidAddMod.Text = "0";
                SetGridSelect(Convert.ToInt32(sellist[0]["row_number"].ToString()));
                this.InitEditControlState(2, aopdealers.Year);
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

                productLineBumId[0] = new Guid(sellist[0]["ProductLine_BUM_ID"]);
                Guid hospitalid = new Guid(sellist[0]["Hospital_ID"]);
                string hospitalName = sellist[0]["Hospital_Name"];
                VAopDealer aopdealers = _contractMasterBLL.GetYearAopHospital(contractId, dealerDmaId, productLineBumId, year, hospitalid);
                this.txtHospitalID.Value = hospitalid.ToString();
                this.txtHospitalName.Text = hospitalName;
                this.txtProdLine.Value = aopdealers.ProductLineBumId.ToString();
                this.txtYear.Text = aopdealers.Year;
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
                this.txtRe_1.Value = aopdealers.ReAmount1.ToString();
                this.txtRe_2.Value = aopdealers.ReAmount2.ToString();
                this.txtRe_3.Value = aopdealers.ReAmount3.ToString();
                this.txtRe_4.Value = aopdealers.ReAmount4.ToString();
                this.txtRe_5.Value = aopdealers.ReAmount5.ToString();
                this.txtRe_6.Value = aopdealers.ReAmount6.ToString();
                this.txtRe_7.Value = aopdealers.ReAmount7.ToString();
                this.txtRe_8.Value = aopdealers.ReAmount8.ToString();
                this.txtRe_9.Value = aopdealers.ReAmount9.ToString();
                this.txtRe_10.Value = aopdealers.ReAmount10.ToString();
                this.txtRe_11.Value = aopdealers.ReAmount11.ToString();
                this.txtRe_12.Value = aopdealers.ReAmount12.ToString();
                this.hospitaleRemark.Value = aopdealers.RmkBody.ToString();

                e.Success = true;
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
                aopdealers.Amount1 = double.Parse(this.txtDAmount_1.Text);
                aopdealers.Amount2 = double.Parse(this.txtDAmount_2.Text);
                aopdealers.Amount3 = double.Parse(this.txtDAmount_3.Text);
                aopdealers.Amount4 = double.Parse(this.txtDAmount_4.Text);
                aopdealers.Amount5 = double.Parse(this.txtDAmount_5.Text);
                aopdealers.Amount6 = double.Parse(this.txtDAmount_6.Text);
                aopdealers.Amount7 = double.Parse(this.txtDAmount_7.Text);
                aopdealers.Amount8 = double.Parse(this.txtDAmount_8.Text);
                aopdealers.Amount9 = double.Parse(this.txtDAmount_9.Text);
                aopdealers.Amount10 = double.Parse(this.txtDAmount_10.Text);
                aopdealers.Amount11 = double.Parse(this.txtDAmount_11.Text);
                aopdealers.Amount12 = double.Parse(this.txtDAmount_12.Text);

                //bool mctl = _contractMasterBLL.SaveAopDealers(new Guid(this.hidContractID.Text.ToString()), aopdealers);
                //e.Success = true;
                double totalDealerAop = aopdealers.Amount1 + aopdealers.Amount2 + aopdealers.Amount3 + aopdealers.Amount4 + aopdealers.Amount5 + aopdealers.Amount6 + aopdealers.Amount7 + aopdealers.Amount8 + aopdealers.Amount9 + aopdealers.Amount10 + aopdealers.Amount11 + aopdealers.Amount12;

                AopRemark ar = new AopRemark();
                ar.Id = Guid.NewGuid();
                ar.Type = "Dealer";
                ar.Contractid = new Guid(this.hidContractID.Text.ToString());

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text.ToString());
                obj.Add("Year", this.hidDealerAopYear.Value.ToString());

                DataTable dt = _contractMasterBLL.GetAopDealersHospitalTempByQuery(obj).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    double hosAmounttotal = double.Parse(dt.Rows[0]["Amount_Y"].ToString());

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
                        }
                    }
                    else
                    {
                        e.ErrorMessage = "请先维护医院指标";
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
        protected void EditDealerAop_Click(object sender, AjaxEventArgs e)
        {
            this.InitEditControlState(1, null);
            this.InitEditValue();
            this.txtDealerAopRemark.Text = "";
            this.hidDealerAopRemarkId.Text = "";
            Guid dealerDmaId = new Guid(this.hidDealerID.Text.ToString());
            string editData = e.ExtraParams["editData"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                Guid productLineBumId = new Guid(sellist[0]["ProductLine_BUM_ID"]);
                string year = sellist[0]["Year"];
                VAopDealer aopdealers = null;

                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text.ToString());
                obj.Add("DealerDmaId", dealerDmaId);
                obj.Add("ProductLineBumId", productLineBumId);
                obj.Add("Year", year);
                obj.Add("IsEmerging", this.hidIsEmerging.Text);
                aopdealers = _contractMasterBLL.GetAopDealersByHosTemp(obj);


                //this.txtDealer.Value = aopdealers.DealerDmaId;
                this.hidDealerProdLineId.Value = aopdealers.ProductLineBumId;
                this.hidDealerAopYear.Value = aopdealers.Year;
                this.txtDealerAopYear.Text = aopdealers.Year;
                this.txtDAmount_1.Value = aopdealers.Amount1.ToString();
                this.txtDAmount_2.Value = aopdealers.Amount2.ToString();
                this.txtDAmount_3.Value = aopdealers.Amount3.ToString();
                this.txtDAmount_4.Value = aopdealers.Amount4.ToString();
                this.txtDAmount_5.Value = aopdealers.Amount5.ToString();
                this.txtDAmount_6.Value = aopdealers.Amount6.ToString();
                this.txtDAmount_7.Value = aopdealers.Amount7.ToString();
                this.txtDAmount_8.Value = aopdealers.Amount8.ToString();
                this.txtDAmount_9.Value = aopdealers.Amount9.ToString();
                this.txtDAmount_10.Value = aopdealers.Amount10.ToString();
                this.txtDAmount_11.Value = aopdealers.Amount11.ToString();
                this.txtDAmount_12.Value = aopdealers.Amount12.ToString();
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

                this.InitEditControlState(2, aopdealers.Year);
                this.WindowDealerAop.Show();
                e.Success = true;
            }
        }

        private void SynchronousFormalDealerHospitalAOP()
        {
            try
            {

                DataTable dtProductLine = null;

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

                    dtProductLine = _contractMasterBLL.GetProductLineByDivisionID(objterry).Tables[0];
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

                if (dtProductLine == null)
                {
                    Hashtable objPl = new Hashtable();
                    if (!String.IsNullOrEmpty(this.hidDivisionID.Value.ToString()))
                    {
                        objPl.Add("DivisionID", this.hidDivisionID.Value.ToString());
                    }
                    objPl.Add("IsEmerging", "0");
                    dtProductLine = _contractMasterBLL.GetProductLineByDivisionID(objPl).Tables[0];
                }
                if (dtProductLine.Rows.Count > 0)
                    this.hidProductLineId.Text = dtProductLine.Rows[0]["AttributeID"].ToString();

                string yearString = "";
                Hashtable obj = new Hashtable();
                obj.Add("DealerDmaId", this.hidDealerID.Text.ToString());
                obj.Add("ProductLineBumId", this.hidProductLineId.Text.ToString());
                obj.Add("ContractId", this.hidContractID.Text);
                obj.Add("ContractType", this.hidContractType.Text);
                obj.Add("BeginMonth", Convert.ToDateTime(this.HidEffectiveDate.Text).Month);
                obj.Add("MarketType", this.hidIsEmerging.Value.ToString().Equals("") ? "0" : this.hidIsEmerging.Value.ToString());
                obj.Add("RtnVal", "");
                obj.Add("RtnMsg", "");

                int Effective = Convert.ToInt32(this.HidEffectiveDate.Text.Substring(0, 4));
                int Expiration = Convert.ToInt32(this.HidExpirationDate.Text.Substring(0, 4));
                for (int getYear = Effective; getYear <= Expiration; getYear++)
                {
                    yearString += (getYear.ToString() + ",");
                }
                obj.Add("YearString", yearString);

                _contractMasterBLL.SynchronousFormalDealerHospiatlAOPTemp2(obj);
            }

            catch (Exception ex) { }
        }

        private void InitEditControlState(int state, string modYear)
        {
            switch (state)
            {
                case 1:
                    for (int i = 1; i <= 12; i++)
                    {
                        TextField tempAmount = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                        TextField tempReAmount = this.FindControl("txtDAmount_" + i.ToString()) as TextField;
                        tempAmount.Enabled = true;
                        tempReAmount.Enabled = true;
                    }
                    this.SaveButton.Enabled = true;
                    SaveAmountButton.Enabled = true;
                    break;
                case 2:
                    this.txtDealerAopYear.Enabled = true;
                    this.txtYear.Enabled = true;
                    int Year = Convert.ToInt32((modYear == null ? "0" : modYear));

                    if (this.hidContractType.Text.ToString().Equals("Appointment"))
                    {
                        #region Appointment
                        DateTime dtNewNow = Convert.ToDateTime(this.HidEffectiveDate.Text);
                        TextField tempAmount = null;
                        TextField tempReAmount = null;
                        for (int i = 1; i < 13; i++)
                        {
                            tempAmount = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                            tempReAmount = this.FindControl("txtDAmount_" + i.ToString()) as TextField;

                            if (Year > DateTime.Now.Year)
                            {
                                tempAmount.Enabled = true;
                                tempReAmount.Enabled = true;
                                this.hidMinMonth.Value = "1";
                                this.SaveButton.Enabled = true;
                                this.SaveAmountButton.Enabled = true;
                                break;
                            }
                            else
                            {
                                if (i < dtNewNow.Month)
                                {
                                    tempAmount.Enabled = false;
                                    tempReAmount.Enabled = false;
                                }
                                else
                                {
                                    tempAmount.Enabled = true;
                                    tempReAmount.Enabled = true;
                                    this.hidMinMonth.Value = i.ToString();
                                    break;
                                }
                            }
                        }
                        this.SaveButton.Enabled = true;
                        this.SaveAmountButton.Enabled = true;
                        #endregion
                    }
                    else if (this.hidContractType.Text.ToString().Equals("Amendment"))
                    {
                        #region Amendment
                        DateTime dtNewNow = Convert.ToDateTime(this.HidEffectiveDate.Text) > DateTime.Now.AddDays(15) ? Convert.ToDateTime(this.HidEffectiveDate.Text) : DateTime.Now.AddDays(15);
                        TextField tempAmount = null;
                        TextField tempReAmount = null;

                        for (int i = 1; i < 13; i++)
                        {
                            tempAmount = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                            tempReAmount = this.FindControl("txtDAmount_" + i.ToString()) as TextField;

                            if (Year > DateTime.Now.Year)
                            {
                                tempAmount.Enabled = true;
                                tempReAmount.Enabled = true;
                                this.hidMinMonth.Value = "1";
                                this.SaveButton.Enabled = true;
                                this.SaveAmountButton.Enabled = true;
                                break;
                            }
                            else if (Year == DateTime.Now.Year)
                            {
                                if (dtNewNow.Year > DateTime.Now.Year)
                                {
                                    tempAmount.Enabled = false;
                                    tempReAmount.Enabled = false;
                                    this.SaveButton.Enabled = false;
                                    this.SaveAmountButton.Enabled = false;
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
                                                tempAmount.Enabled = true;
                                                tempReAmount.Enabled = true;
                                                this.hidMinMonth.Value = i.ToString();
                                                break;
                                            }
                                            else
                                            {
                                                tempAmount.Enabled = false;
                                                tempReAmount.Enabled = false;
                                            }
                                        }
                                        else
                                        {
                                            //合同开始时间是控制时间
                                            if (i == Convert.ToDateTime(this.HidEffectiveDate.Text).Month)
                                            {
                                                tempAmount.Enabled = true;
                                                tempReAmount.Enabled = true;
                                                this.hidMinMonth.Value = i.ToString();
                                                break;
                                            }
                                            else
                                            {
                                                tempAmount.Enabled = false;
                                                tempReAmount.Enabled = false;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        tempAmount.Enabled = true;
                                        tempReAmount.Enabled = true;
                                        this.hidMinMonth.Value = i.ToString();

                                        this.SaveAmountButton.Enabled = true;

                                        this.SaveButton.Enabled = true;

                                        break;
                                    }
                                }
                            }
                            else
                            {
                                tempAmount.Enabled = false;
                                tempReAmount.Enabled = false;
                                this.hidMinMonth.Value = "13";
                                this.SaveAmountButton.Enabled = false;
                                this.SaveButton.Enabled = false;
                                break;
                            }
                        }
                        #endregion
                    }
                    else 
                    {
                        #region Renewal
                        this.hidMinMonth.Value = "1";
                        #endregion
                    }

                    break;
            }
        }

        private Guid?[] SetProdLineIdValue()
        {
            Guid?[] prodLineId = null;
            int row = 0;
            Hashtable obj = new Hashtable();
            if (!String.IsNullOrEmpty(this.hidDivisionID.Value.ToString()))
            {
                obj.Add("DivisionID", this.hidDivisionID.Value.ToString());
            }

            DataTable dtProductLine = _contractMasterBLL.GetProductLineByDivisionID(obj).Tables[0];

            DataTable dtNOEmerging = dtProductLine.Clone();
            DataRow[] drNOEmerging = dtProductLine.Select("AttributeID <> 'DD1B6ADF-3772-4E4A-B9CC-A2B900B5F935'");
            foreach (DataRow dtrow in drNOEmerging)
            {
                dtNOEmerging.Rows.Add(dtrow.ItemArray);
            }

            prodLineId = new Guid?[dtNOEmerging.Rows.Count];
            for (int i = 0; i < dtNOEmerging.Rows.Count; i++)
            {
                prodLineId[row] = new Guid(dtNOEmerging.Rows[i]["AttributeID"].ToString());
                row = row + 1;
            }
            return prodLineId;
        }

        private void InitEditValue()
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

        private void SetGridSelect(int i)
        {
            RowSelectionModel sm = this.txtGPHospitalUpdate.SelectionModel.Primary as RowSelectionModel;
            sm.SelectedRows.Clear();
            sm.SelectedRows.Add(new SelectedRow(i - 1));
            sm.UpdateSelection();
        }
    }
}
