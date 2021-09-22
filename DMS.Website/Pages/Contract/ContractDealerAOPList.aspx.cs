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

    public partial class ContractDealerAOPList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        private IContractMasterBLL _contractMasterBLL = new ContractMasterBLL();
        private IContractCommonBLL _contractCommon = new ContractCommonBLL();

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
                  
                }
                SetInitialValue();
                SynchronousFormalDealerAOP();
            }
        }
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
        }

        public virtual void Store_RefreshFYCO(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dtYear = new DataTable();
            dtYear.Columns.Add("COP_Period");
            //所有财年
            COPs b = new COPs();
            DataTable dt = b.SelectCOP_FY().Tables[0];

            int Effective = Convert.ToInt32(this.HidEffectiveDate.Text.Substring(0, 4)) ;
            int Expiration = Convert.ToInt32(this.HidExpirationDate.Text.Substring(0, 4));
            for (int getYear = Effective; getYear <= Expiration; getYear++) 
            {
                for (int j = 0; j < dt.Rows.Count; j++) 
                {
                    if (dt.Rows[j]["COP_Period"].ToString().Equals(getYear.ToString())) 
                    {
                        dtYear.Rows.Add(getYear.ToString());
                    }
                }
            }
            YearStore.DataSource = dtYear;
            YearStore.DataBind();
        }
        public void AOPStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Guid? dmaId = null;
            Guid? prodLineId = null;
            string year = null;
            dmaId = new Guid(this.hidDealerID.Text.ToString());
            prodLineId = new Guid(this.hidProductLineId.Text.ToString());

            if (!string.IsNullOrEmpty(this.cbYear.SelectedItem.Value)) year = this.cbYear.SelectedItem.Value;
            int start = 0; int limit = this.PagingToolBar1.PageSize;
            if (e.Start > -1)
            {
                start = e.Start;
                limit = e.Limit;
            }
            Hashtable obj = new Hashtable();
            obj.Add("ContractId", this.hidContractID.Text.ToString());
            obj.Add("DealerDmaId", dmaId.Value);
            obj.Add("ProductLineBumId", prodLineId.Value);
            obj.Add("SubBuId", this.hidPartsContractId.Text.ToString());
            obj.Add("MarkType", this.hidIsEmerging.Text.ToString());
            obj.Add("Year", year);

            System.Data.DataSet dataSource = _contractMasterBLL.GetAopDealersByQuery(obj, start, limit, out totalCount);
            if (sender is Store)
            {
                Store store1 = (sender as Store);
                (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }
        protected void EditAop_Click(object sender, AjaxEventArgs e)
        {
            InitEditValue();
            Guid dealerDmaId = new Guid(this.hidDealerID.Text.ToString());

            string editData = e.ExtraParams["editData"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                this.InitEditControlState(sellist[0]["Year"].ToString());

                Guid productLineBumId = new Guid(sellist[0]["ProductLine_BUM_ID"]);
                this.txtClassification.Text = sellist[0]["CCName"];

                string year = sellist[0]["Year"];
                Hashtable obj = new Hashtable();
                obj.Add("ContractId", this.hidContractID.Text.ToString());
                obj.Add("Year", year);
                VAopDealer AopDealerTmp = _contractCommon.GetDealerAOPAndHospitalAOPAmountTemp(obj);

                this.txtYear.Text = year;
                this.hidtxtYear.Value = year;
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
                this.AOPEditorWindow.Show();
                e.Success = true;
            }

           
        }
        protected void SaveAOP_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                VAopDealer aopdealers = new VAopDealer();
                aopdealers.DealerDmaId = new Guid(this.hidDealerID.Text.ToString());
                aopdealers.ProductLineBumId = new Guid(this.hidProductLineId.Text.ToString());
                aopdealers.MarketType = this.hidIsEmerging.Text;
                aopdealers.Year = this.hidtxtYear.Text.ToString();
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

                bool mctl = _contractCommon.SaveAopDealerTemp(this.hidContractID.Text, this.hidPartsContractId.Text, aopdealers);
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
            DataTable dtProductLine = _contractMasterBLL.GetProductLineByDivisionID(obj).Tables[0];
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

            // 5.获取指标能够维护开始月份 a》Appointment：合同开始月份    b》Renewal：合同开始月份     c》Amendment：系统时间+14天与合同时间比较，取较大月份
            if (this.hidContractType.Text.Equals("Appointment"))
            {
               this.hidBeginYearMinMonth.Text = Convert.ToDateTime(this.HidEffectiveDate.Text).Month.ToString();
            }
            if (this.hidContractType.Text.Equals("Amendment"))
            {
                //Amendment
                this.hidBeginYearMinMonth.Text= (Convert.ToDateTime(this.HidEffectiveDate.Text).Month).ToString();
            }
            if (this.hidContractType.Text.Equals("Renewal"))
            {
                this.hidBeginYearMinMonth.Text = Convert.ToDateTime(this.HidEffectiveDate.Text).Month.ToString();
            }
            //4.获取合同分类修改类型
            this.CheckSheBei = _contractCommon.CheckSubBUType(this.hidPartsContractCode.Text);

        }
        private void InitEditControlState(string year)
        {
            int minMonth = Convert.ToInt32(this.hidBeginYearMinMonth.Value.ToString());
           
            if (year == this.hidMinYear.Text && year==DateTime.Now.Year.ToString())
            {
                if (this.hidContractType.Text.Equals("Amendment") && !this.CheckSheBei.Equals("1") && (minMonth<=DateTime.Now.Month))
                {
                    minMonth += 1;
                }
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

        private void InitEditValue()
        {
            this.txtClassification.Text = "";
            this.txtYear.Text = "";
            this.hidtxtYear.Value = "";

            for (int i = 1; i <= 12; i++)
            {
                TextField tempAmount = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                tempAmount.Value = "";
                tempAmount.Enabled = false;
            }
        }
        private void SynchronousFormalDealerAOP() 
        {
            Hashtable obj = new Hashtable();
            obj.Add("Con_Id", this.hidContractID.Text);
            obj.Add("Dma_Id", this.hidDealerID.Text.ToString());
            obj.Add("Plb_Id", this.hidProductLineId.Text.ToString());
            obj.Add("SubBu_Id", this.hidPartsContractId.Text.ToString());
            obj.Add("IsEmerging", this.hidIsEmerging.Value.ToString());
            obj.Add("YearString", this.hidYearString.Text);

            _contractMasterBLL.SynchronousFormalDealerAOPTemp(obj);
        }
        #endregion 

    }
}
