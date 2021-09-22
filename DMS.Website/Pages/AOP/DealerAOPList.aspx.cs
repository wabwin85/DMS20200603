using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.AOP
{
    using DMS.Model;
    using DMS.Business;
    using DMS.Business.Cache;
    using DMS.Common;
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;

    using Microsoft.Practices.Unity;
    using DMS.Model.Data;

    public partial class DealerAOPList : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        //private IDealerContracts _dealerContractBiz = Global.ApplicationContainer.Resolve<IDealerContracts>();
        private IAopDealerBLL _aopDealerBLL = null;//Global.SessionContainer.Resolve<IHospitals>();

        [Dependency]
        public IAopDealerBLL AopDealerBLL
        {
            get { return _aopDealerBLL; }
            set { _aopDealerBLL = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.dealerData.Value = DealerCacheHelper.GetJsonArray();
                this.prodLineData.Value = OrganizationCacheHelper.GetJsonArray(SR.Organization_ProductLine);
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.AopDealerBLL.Action_DealerAop, PermissionType.Read);
                this.btnDelete.Visible = pers.IsPermissible(Business.AopDealerBLL.Action_DealerAop, PermissionType.Delete);
                this.btnInsert.Visible = pers.IsPermissible(Business.AopDealerBLL.Action_DealerAop, PermissionType.Write);
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            Store myStore = this.CreateProductLinesStore(this.Form, this.cbProLine);
        }

        protected void SaveAOP_Click(object sender, AjaxEventArgs e)
        {
            try
            {
                VAopDealer aopdealers = new VAopDealer();
                aopdealers.DealerDmaId = new Guid(this.txtDealer.SelectedItem.Value);
                aopdealers.ProductLineBumId = new Guid(this.txtProdLine.SelectedItem.Value);
                aopdealers.Year = this.txtYear.SelectedItem.Value;
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
                if (this.hidAddMod.Text == "1")
                {
                    VAopDealer tempAopdealers = AopDealerBLL.GetYearAopDealers(aopdealers.DealerDmaId, aopdealers.ProductLineBumId, aopdealers.Year);
                    if (tempAopdealers != null)
                    {
                        e.ErrorMessage = GetLocalResourceObject("SaveAOP_Click.ErrorMessage").ToString();
                        e.Success = false;
                        return;
                    }
                }
                bool mctl = AopDealerBLL.SaveAopDealers(aopdealers);
                e.Success = true;
            }
            catch
            {
                e.Success = false;
            }
        }

        protected void DeleteAOP_Click(object sender, AjaxEventArgs e)
        {
            string delData = e.ExtraParams["delData"];
            SelectedEventArgs delArgs = new SelectedEventArgs(delData);
            IDictionary<string, string>[] sellist = delArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                Guid dmaId = new Guid(sellist[0]["Dealer_DMA_ID"]);
                Guid prodLineId = new Guid(sellist[0]["ProductLine_BUM_ID"]);
                string year = sellist[0]["Year"];
                bool isdeleted = AopDealerBLL.RemoveAopDealers(dmaId, prodLineId, year);
                e.Success = isdeleted;
            }
        }


        protected void EditAop_Click(object sender, AjaxEventArgs e)
        {
            string editData = e.ExtraParams["editData"];
            SelectedEventArgs editArgs = new SelectedEventArgs(editData);
            IDictionary<string, string>[] sellist = editArgs.ToDictionarys();
            if (sellist != null && sellist.Length > 0)
            {
                Guid dealerDmaId = new Guid(sellist[0]["Dealer_DMA_ID"]);
                Guid productLineBumId = new Guid(sellist[0]["ProductLine_BUM_ID"]);
                string year = sellist[0]["Year"];
                VAopDealer aopdealers = AopDealerBLL.GetYearAopDealers(dealerDmaId, productLineBumId, year);
                this.txtDealer.Value = aopdealers.DealerDmaId;
                this.txtProdLine.Value = aopdealers.ProductLineBumId;
                this.txtYear.Value = aopdealers.Year;
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
                this.hidAddMod.Text = "0";
                this.InitEditControlState(2, aopdealers.Year);
                this.AOPEditorWindow.Show();
                e.Success = true;
            }
        }

        protected void NewAop_Click(object sender, AjaxEventArgs e)
        {
            this.txtDealer.Value = "";
            this.txtProdLine.Value = "";
            this.txtYear.Value = "";
            for (int i = 1; i <= 12; i++)
            {
                TextField tempAmount = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                tempAmount.Text = "";
            }
            this.hidAddMod.Text = "1";
            this.InitEditControlState(1, null);
            this.AOPEditorWindow.Show();
        }


        #region Store

        public void Store_ProductLine(object sender, StoreRefreshDataEventArgs e)
        {
            object datasource = null;
            string DealerId = txtDealer.SelectedItem.Value;
            if (!string.IsNullOrEmpty(DealerId))
            {
                IDealerContracts dealers = new DealerContracts();

                //Edited By Song Yuqi On 2016-05-24 Begin
                DealerAuthorization param = new DealerAuthorization();
                param.DmaId = new Guid(DealerId);
                param.Type = DealerAuthorizationType.Normal.ToString();

                IList<DealerAuthorization> auths = dealers.GetAuthorizationListByDealer(param);
                //Edited By Song Yuqi On 2016-05-24 End

                IList<Lafite.RoleModel.Domain.AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);

                var lines = from p in dataSet
                            where auths.FirstOrDefault<DealerAuthorization>(c => c.ProductLineBumId.Value == new Guid(p.Id)) != null
                            select p;


                datasource = lines.ToList<Lafite.RoleModel.Domain.AttributeDomain>();
                WinProductLineStore.DataSource = datasource;
                WinProductLineStore.DataBind();
            }
        }

        public override void Store_DealerList(object sender, StoreRefreshDataEventArgs e)
        {
            IRoleModelContext context = RoleModelContext.Current;


            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();


            //如果是普通用户则检查过滤该用户是否能够看到该Dealer
            if (context.User.IdentityType == IdentityType.User.ToString())
            {

                var query = from p in dataSource
                            where p.ActiveFlag == true
                            select p;

                dataSource = query.ToList<DealerMaster>();

            }

            if (sender is Store)
            {
                Store store1 = (sender as Store);

                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }

        public void AOPStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Guid? dmaId = null;
            Guid? prodLineId = null;
            string year = null;
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value)) dmaId = new Guid(this.cbDealer.SelectedItem.Value);
            if (!string.IsNullOrEmpty(this.cbProLine.SelectedItem.Value)) prodLineId = new Guid(this.cbProLine.SelectedItem.Value);
            if (!string.IsNullOrEmpty(this.cbYear.SelectedItem.Value)) year = this.cbYear.SelectedItem.Value;
            int start = 0; int limit = this.PagingToolBar1.PageSize;
            if (e.Start > -1)
            {
                start = e.Start;
                limit = e.Limit;
            }
            System.Data.DataSet dataSource = AopDealerBLL.GetAopDealersByQuery(dmaId, prodLineId, year, start, limit, out totalCount);

            if (sender is Store)
            {
                Store store1 = (sender as Store);
                (store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
                store1.DataSource = dataSource;
                store1.DataBind();
            }
        }

        #endregion
        /// <summary>
        /// state 1新增、2修改
        /// </summary>
        /// <param name="state"></param>
        /// <param name="modYear"></param>
        private void InitEditControlState(int state, string modYear)
        {
            switch (state)
            {
                case 1:
                    this.txtDealer.Enabled = true;
                    this.txtProdLine.Enabled = true;
                    this.txtYear.Enabled = true;
                    for (int i = 1; i <= 12; i++)
                    {
                        TextField tempAmount = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                        tempAmount.Enabled = true;
                    }
                    this.SaveButton.Enabled = true;
                    break;
                case 2:
                    this.txtDealer.Enabled = false;
                    this.txtProdLine.Enabled = false;
                    this.txtYear.Enabled = false;
                    int monthNum = this.GetMonthNumber(modYear);
                    for (int i = 1; i < monthNum; i++)
                    {
                        TextField tempAmount = this.FindControl("txtAmount_" + i.ToString()) as TextField;
                        tempAmount.Enabled = false;
                    }
                    if (monthNum == 13) { this.SaveButton.Enabled = false; }
                    else
                    {
                        this.SaveButton.Enabled = true;
                    };
                    break;
            }
        }

        private int GetMonthNumber(string modYear)
        {
            COPs b = new COPs();
            string year = b.SelectCOP_CurrentFY();
            if (modYear.CompareTo(year) < 0) return 13;
            string month = b.SelectCOP_CurrentFM();
            switch (month)
            {
                case "01":
                    return 1;
                case "02":
                    return 2;
                case "03":
                    return 3;
                case "04":
                    return 4;
                case "05":
                    return 5;
                case "06":
                    return 6;
                case "07":
                    return 7;
                case "08":
                    return 8;
                case "09":
                    return 9;
                case "10":
                    return 10;
                case "11":
                    return 11;
                case "12":
                    return 12;
                default:
                    return 0;
            }
        }

    }
}
