using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Controls
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using DMS.Website.Common;
    using DMS.Common;
    using DMS.Business;
    using Lafite.RoleModel.Security;
    using System.Data;
    using System.Collections;
    using Microsoft.Practices.Unity;

    public partial class DealerMasterEditor : BaseUserControl
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        private IDealerMasters _dealers = new DealerMasters();
        private IAttachmentBLL _attachmentBLL = new AttachmentBLL();
        private ICOPs _cops = new COPs();
        private IAopDealerBLL _aop = new AopDealerBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.LastUpdateUser.Text = _context.User.Id;

                //Add By SongWeiming on 2015-09-14 For Dealer License Application and Approval
                this.SaveButton.Visible = false;
                //this.CancelButton.Visible = !IsDealer;
                

                if (IsDealer)
                {
                    //如果是经销商用户，则不可编辑，且保存、取消按钮不可间                   
                    this.ChineseName.Disabled = true;
                    this.EnglishName.Disabled = true;
                    this.DealerNbr.Disabled = true;
                    this.Province.Disabled = true;
                    this.District.Disabled = true;
                    this.DealerType.Disabled = true;
                    this.SNDealer.Disabled = true;
                    this.FirstContractDate.Disabled = true;
                    this.SystemStartDate.Disabled = true;
                    this.ActiveFlag.Disabled = true;
                    this.ChineseShortName.Disabled = true;
                    this.EnglishShortName.Disabled = true;
                    this.SapCode.Disabled = true;
                    this.City.Disabled = true;
                    this.CompanyType.Disabled = true;
                    this.Taxpayer.Disabled = true;
                    this.SalesMode.Disabled = true;
                    this.DealerAuthentication.Disabled = true;
                    this.Certification.Disabled = true;

                    this.RegisteredAddress.Disabled = true;
                    this.Address.Disabled = true;
                    this.ShipToAddress.Disabled = true;
                    this.PostalCode.Disabled = true;
                    this.Phone.Disabled = true;
                    this.Fax.Disabled = true;
                    this.ContactPerson.Disabled = true;
                    this.Email.Disabled = true;
                    this.GeneralManager.Disabled = true;
                    this.LegalRep.Disabled = true;
                    this.RegisteredCapital.Disabled = true;
                    this.BankAccount.Disabled = true;
                    this.Bank.Disabled = true;
                    this.TaxNo.Disabled = true;
                    this.License.Disabled = true;
                    this.LicenseLimit.Disabled = true;
                    this.EstablishDate.Disabled = true;
                    this.Finance.Disabled = true;
                    this.FinancePhone.Disabled = true;
                    this.FinanceEmail.Disabled = true;
                    this.Payment.Disabled = true;
                }
                else
                {
                    this.ChineseName.Disabled = false;
                    this.EnglishName.Disabled = false;
                    this.DealerNbr.Disabled = false;
                    this.Province.Disabled = false;
                    this.District.Disabled = false;
                    this.DealerType.Disabled = false;
                    this.SNDealer.Disabled = false;
                    this.FirstContractDate.Disabled = false;
                    this.SystemStartDate.Disabled = false;
                    this.ActiveFlag.Disabled = false;
                    this.ChineseShortName.Disabled = false;
                    this.EnglishShortName.Disabled = false;
                    this.SapCode.Disabled = false;
                    this.City.Disabled = false;
                    this.CompanyType.Disabled = false;
                    this.Taxpayer.Disabled = false;
                    this.SalesMode.Disabled = false;
                    this.DealerAuthentication.Disabled = false;
                    this.Certification.Disabled = false;

                    this.RegisteredAddress.Disabled = false;
                    this.Address.Disabled = false;
                    this.ShipToAddress.Disabled = false;
                    this.PostalCode.Disabled = false;
                    this.Phone.Disabled = false;
                    this.Fax.Disabled = false;
                    this.ContactPerson.Disabled = false;
                    this.Email.Disabled = false;
                    this.GeneralManager.Disabled = false;
                    this.LegalRep.Disabled = false;
                    this.RegisteredCapital.Disabled = false;
                    this.BankAccount.Disabled = false;
                    this.Bank.Disabled = false;
                    this.TaxNo.Disabled = false;
                    this.License.Disabled = false;
                    this.LicenseLimit.Disabled = false;
                    this.EstablishDate.Disabled = false;
                    this.Finance.Disabled = false;
                    this.FinancePhone.Disabled = false;
                    this.FinanceEmail.Disabled = false;
                    this.Payment.Disabled = false;
                }

            }

        }

        public void CreateDealerMaster()
        {
            this.Id1.Text = this.NewGuid();

        }

        protected void Payment_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            PaymentBLL bll = new PaymentBLL();
            IList<Payment> query = bll.getPaymentALL();

            if (sender is Store)
            {
                Store PaymentStore = (sender as Store);

                PaymentStore.DataSource = query;
                PaymentStore.DataBind();
            }

        }

        protected void DealerTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
            if (sender is Store)
            {
                Store DealerTypeStore = (sender as Store);

                DealerTypeStore.DataSource = dictsCompanyType;
                DealerTypeStore.DataBind();
            }

        }

        protected void Store_RefreshCities(object sender, StoreRefreshDataEventArgs e)
        {
            e.Parameters["parentId"] = this.Province.SelectedItem.Value;

            base.Store_RefreshTerritorys(sender, e);
        }

        protected void Store_RefreshDistricts(object sender, StoreRefreshDataEventArgs e)
        {
            e.Parameters["parentId"] = this.City.SelectedItem.Value;

            base.Store_RefreshTerritorys(sender, e);
        }

        //附件
        protected void Store_RefreshAttachmentType(object sender, StoreRefreshDataEventArgs e)
        {
            string Type = "";
            if (this.DealerType.SelectedItem.Value.Equals("T1"))
            {
                Type = SR.Const_ContractAnnex_Type_T1.ToString();
            }
            if (this.DealerType.SelectedItem.Value.Equals("T2"))
            {
                Type = SR.Const_ContractAnnex_Type_T2.ToString();
            }
            if (this.DealerType.SelectedItem.Value.Equals("LP"))
            {
                Type = SR.Const_ContractAnnex_Type_LP.ToString();
            }
            IDictionary<string, string> contractStatus = DictionaryHelper.GetDictionary(Type);
            AttachmentType.DataSource = contractStatus;
            AttachmentType.DataBind();
        }

        protected void Store_RefreshAttachment(object sender, StoreRefreshDataEventArgs e)
        {
            string Type = "";
            if (this.hidDma_Type.Value.Equals("T1"))
            {
                Type = SR.Const_ContractAnnex_Type_T1.ToString();
            }
            if (this.hidDma_Type.Value.Equals("T2"))
            {
                Type = SR.Const_ContractAnnex_Type_T2.ToString();
            }
            if (this.hidDma_Type.Value.Equals("LP"))
            {
                Type = SR.Const_ContractAnnex_Type_LP.ToString();
            }

            int totalCount = 0;
            Guid DealerID = new Guid(this.hidDma_id.Text.Equals("") ? Guid.Empty.ToString() : this.hidDma_id.Text);
            Hashtable tb = new Hashtable();
            tb.Add("DealerID", DealerID);
            tb.Add("ParType", Type);
            if (!this.tfAnnexName.Text.Equals(""))
            {
                tb.Add("AnnexName", this.tfAnnexName.Text);
            }
            if (!this.cbAttachmentType.SelectedItem.Value.Equals(""))
            {
                tb.Add("AttachmentType", this.cbAttachmentType.SelectedItem.Value);
            }


            DataTable dt = _attachmentBLL.GetAttachmentContract(tb, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            (this.AttachmentStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            AttachmentStore.DataSource = dt;
            AttachmentStore.DataBind();
        }
        //产品线
        protected void Store_ProductLine(object sender, StoreRefreshDataEventArgs e)
        {
            Guid DealerID = new Guid(this.hidDma_id.Text.Equals("") ? Guid.Empty.ToString() : this.hidDma_id.Text);
            //IDictionary<string, string> contractStatus = DictionaryHelper.GetDictionary(Type);
            DataTable dt = _dealers.GetDealerProductLine(DealerID).Tables[0];
            ProductLineStore.DataSource = dt;
            ProductLineStore.DataBind();
        }

        protected void Store_YearStore(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dt = _cops.SelectCOP_FY().Tables[0];

            YearStore.DataSource = dt;
            YearStore.DataBind();
        }

        protected void Store_ExportType(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Value");
            dt.Columns.Add("Name");
            dt.Rows.Add("1", "导出授权");
            dt.Rows.Add("2", "导出指标");
            dt.Rows.Add("3", "批量导出授权");
            dt.Rows.Add("4", "批量导出指标");

            ExportTypeStore.DataSource = dt;
            ExportTypeStore.DataBind();
        }

        protected void Store_AllProductLine(object sender, StoreRefreshDataEventArgs e)
        {
            IList<Lafite.RoleModel.Domain.AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);
            AllProductLineStore.DataSource = dataSet;
            AllProductLineStore.DataBind();
        }

        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = _dealers.ExportDealerMaster(new Guid(this.hidDma_id.Text)).Tables[0];//dt是从后台生成的要导出的datatable
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

        protected void ExportAuthorizationExcel(object sender, EventArgs e)
        {
            Hashtable obj = new Hashtable();
            if (this.cbExportType.SelectedItem.Value.Equals("1"))
            {
                obj.Add("DealerId", this.hidDma_id.Text);
            }
            if (this.cbExportType.SelectedItem.Value.Equals("1") && !this.cbProductLine.SelectedItem.Value.Equals(""))
            {
                obj.Add("ProductLineId", this.cbProductLine.SelectedItem.Value);
            }
            if (this.cbExportType.SelectedItem.Value.Equals("3") && !this.cbAllProduct.SelectedItem.Value.Equals(""))
            {
                obj.Add("ProductLineId", this.cbAllProduct.SelectedItem.Value);
            }


            DataTable dt = _dealers.ExportDealerAuthorization(obj).Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=Authorization.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }

        protected void ExportAOPExcel(object sender, EventArgs e)
        {
            Hashtable obj = new Hashtable();
            if (this.cbExportType.SelectedItem.Value.Equals("2"))
            {
                obj.Add("DealerId", this.hidDma_id.Text);
            }

            if (this.cbExportType.SelectedItem.Value.Equals("2") && !this.cbProductLine.SelectedItem.Value.Equals(""))
            {
                obj.Add("ProductLineId", this.cbProductLine.SelectedItem.Value);
            }
            if (this.cbExportType.SelectedItem.Value.Equals("4") && !this.cbAllProduct.SelectedItem.Value.Equals(""))
            {
                obj.Add("ProductLineId", this.cbAllProduct.SelectedItem.Value);
            }

            if (!this.cbYear.SelectedItem.Value.Equals(""))
            {
                obj.Add("Year", this.cbYear.SelectedItem.Value);
            }
            DataTable dt = _aop.ExportAop(obj).Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=Aop.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }
        protected void ExportHospitalAOPExcel(object sender, EventArgs e)
        {
            Hashtable obj = new Hashtable();
            if (this.cbExportType.SelectedItem.Value.Equals("2"))
            {
                obj.Add("DealerId", this.hidDma_id.Text);
            }

            if (this.cbExportType.SelectedItem.Value.Equals("2") && !this.cbProductLine.SelectedItem.Value.Equals(""))
            {
                obj.Add("ProductLineId", this.cbProductLine.SelectedItem.Value);
            }
            if (this.cbExportType.SelectedItem.Value.Equals("4") && !this.cbAllProduct.SelectedItem.Value.Equals(""))
            {
                obj.Add("ProductLineId", this.cbAllProduct.SelectedItem.Value);
            }

            if (!this.cbYear.SelectedItem.Value.Equals(""))
            {
                obj.Add("Year", this.cbYear.SelectedItem.Value);
            }
            DataTable dt = _aop.ExportHospitalAop(obj).Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=HospitalAop.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }

        protected void ExportProductAOPExcel(object sender, EventArgs e)
        {
            Hashtable obj = new Hashtable();
            if (this.cbExportType.SelectedItem.Value.Equals("2"))
            {
                obj.Add("DealerId", this.hidDma_id.Text);
            }

            if (this.cbExportType.SelectedItem.Value.Equals("2") && !this.cbProductLine.SelectedItem.Value.Equals(""))
            {
                obj.Add("ProductLineId", this.cbProductLine.SelectedItem.Value);
            }
            if (this.cbExportType.SelectedItem.Value.Equals("4") && !this.cbAllProduct.SelectedItem.Value.Equals(""))
            {
                obj.Add("ProductLineId", this.cbAllProduct.SelectedItem.Value);
            }

            if (!this.cbYear.SelectedItem.Value.Equals(""))
            {
                obj.Add("Year", this.cbYear.SelectedItem.Value);
            }
            DataTable dt = _aop.ExportHospitalProductAop(obj).Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=ProductAop.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }

        #region Combo box data resource
        //protected internal virtual Store CreateHospitalLevelStore(Coolite.Ext.Web.ComboBox comboBox)
        //{
        //    string storeName = "CompanyTypeStore";

        //    Store myStore = ComboBoxStoreHelper.CreateDictionaryStore(this.Parent.Page.Form, storeName);
        //    myStore.RefreshData += Store_HospitalLevel;

        //    if (comboBox != null)
        //        comboBox.StoreID = storeName;

        //    IDictionary<string, string> dataSet = DictionaryHelper.GetDictionary(SR.Consts_Company_Type);

        //    myStore.DataSource = dataSet;
        //    myStore.DataBind();

        //    return myStore;
        //}

        ///// <summary>
        ///// 医院级别，Medtro自定义

        ///// </summary>
        ///// <param name="sender"></param>
        ///// <param name="e"></param>
        //protected internal virtual void Store_HospitalLevel(object sender, StoreRefreshDataEventArgs e)
        //{
        //    IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Company_Type);

        //    if (sender is Store)
        //    {
        //        Store store1 = (sender as Store);

        //        store1.DataSource = dicts;
        //        store1.DataBind();
        //    }
        //}


        #endregion

        //protected override void OnInit(EventArgs e)
        //{
        //    base.OnInit(e);

        //    Store storeLevel = this.PageBase.CreateHospitalLevelStore(null);

        //    //this.CreateHospitalLevelStore(this.);
        //    storeHolder.Controls.Add(storeLevel);
        //    this.cboCompanyGrade.StoreID = storeLevel.ID;
        //}

    }
}