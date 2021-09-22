using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Contract
{
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using DMS.Business;
    using Microsoft.Practices.Unity;
    using DMS.Model;
    using System.Collections;
    using System.Data;
    using DMS.Model.Data;
    using System.IO;
    using DMS.Common;
    using iTextSharp.text.pdf;
    using iTextSharp.text;
    using System.Reflection;
    using System.Text.RegularExpressions;
    public partial class ContractForm3Equipment  : BasePage
    {
        #region Definition
        IRoleModelContext _context = RoleModelContext.Current;
        private IContractMasterBLL _contractMasterBLL = null;
        [Dependency]
        public IContractMasterBLL contractMasterBLL
        {
            get { return _contractMasterBLL; }
            set { _contractMasterBLL = value; }
        }

        private IAttachmentBLL _attachmentBLL = null;
        [Dependency]
        public IAttachmentBLL attachmentBLL
        {
            get { return _attachmentBLL; }
            set { _attachmentBLL = value; }
        }

        private IContractMaster _contract = new DMS.Business.ContractMaster();
        private IContractRenewalService _Renewal = new DMS.Business.ContractRenewalService();
        private ContractMasterDM conMast = null;

        private Regex regChinese = new Regex("[\u4e00-\u9fa5]");
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (Request.QueryString["CmId"] != null && Request.QueryString["CmStatus"] != null && Request.QueryString["DealerId"] != null && Request.QueryString["ContStatus"] != null && Request.QueryString["DealerCnName"] != null)
                {
                    this.hdCmId.Value = Request.QueryString["CmId"];
                    this.hdCmStatus.Value = Request.QueryString["CmStatus"];
                    this.hdDealerId.Value = Request.QueryString["DealerId"];
                    this.hdContStatus.Value = Request.QueryString["ContStatus"];
                    this.hdDealerCnName.Value = Request.QueryString["DealerCnName"];
                    this.hdParmetType.Value = Request.QueryString["ParmetType"];
                    this.hdContId.Value = Request.QueryString["ContId"];
                    if (Session["conMast"] != null)
                    {
                        conMast = Session["conMast"] as ContractMasterDM;
                    }
                    BindMainData();
                    PagePermissions();
                }
                if (!RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation))
                {
                    btnCreatePdf.Enabled = false;
                }
            }
        }

        #region Page Event

        //医疗器械或制药公司
        protected void Store_RefreshMedicalDevices(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable table = new Hashtable();
            table.Add("CmId", this.hdCmId.Value);
            DataSet ds = contractMasterBLL.QueryMedicalDevicesList(table);

            this.MedicalDevicesStore.DataSource = ds;
            this.MedicalDevicesStore.DataBind();
        }

        //营业执照、许可或登记情况
        protected void Store_RefreshBusinessLicense(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable table = new Hashtable();
            table.Add("CmId", this.hdCmId.Value);
            DataSet ds = contractMasterBLL.QueryBusinessLicenseList(table);

            this.BusinessLicenseStore.DataSource = ds;
            this.BusinessLicenseStore.DataBind();
            this.hdLicense.Value = ds.Tables[0].Rows.Count;
        }

        //公司董事及主要高层人员的背景信息
        protected void Store_RefreshSeniorCompany(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable table = new Hashtable();
            table.Add("CmId", this.hdCmId.Value);
            DataSet ds = contractMasterBLL.QuerySeniorCompanyList(table);

            this.SeniorCompanyStore.DataSource = ds;
            this.SeniorCompanyStore.DataBind();
            this.hdSeniorCompany.Value = ds.Tables[0].Rows.Count;
        }

        //公司所有人及股东的背景信息
        protected void Store_RefreshCompanyStockholder(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable table = new Hashtable();
            table.Add("CmId", this.hdCmId.Value);
            DataSet ds = contractMasterBLL.QueryCompanyStockholderList(table);

            this.CompanyStockholderStore.DataSource = ds;
            this.CompanyStockholderStore.DataBind();

            this.hdCompany.Value = ds.Tables[0].Rows.Count;
            decimal toPosition = 0;
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                toPosition += Convert.ToDecimal(ds.Tables[0].Rows[i]["Ownership"]);
                if (!ds.Tables[0].Rows[i]["Country"].ToString().Equals("") || !ds.Tables[0].Rows[i]["Register"].ToString().Equals("") || !ds.Tables[0].Rows[i]["Possessor"].ToString().Equals(""))
                {
                    hdSignTp.Value = "1";
                }
            }
            this.hdCompanyValue.Value = toPosition;
        }
        #endregion

        #region AjaxMethod

        #region 医疗器械或制药公司
        [AjaxMethod]
        public void ShowMedicalDevicesWindow()
        {
            //Init vlaue within this window control
            InitMedicalDevicesWindow(true);

            //Show Window
            this.windowMedicalDevices.Show();
        }

        [AjaxMethod]
        public void SaveMedicalDevices()
        {
            string massage = "";
            try
            {
                if (massage.Equals(""))
                {
                    MedicalDevices medicalDevices = new MedicalDevices();
                    //Create
                    if (string.IsNullOrEmpty(this.hiddenWinMedicalDevicesDetailId.Text))
                    {
                        medicalDevices.Id = Guid.NewGuid();
                        medicalDevices.CmId = new Guid(this.hdCmId.Value.ToString());
                        medicalDevices.Name = this.tfWinMedicalDevicesName.Text;
                        medicalDevices.Describe = this.tfWinMedicalDevicesDescribe.Text;

                        medicalDevices.UpdateUser = null;
                        medicalDevices.UpdateDate = null;
                        medicalDevices.CreateUser = new Guid(_context.User.Id);
                        medicalDevices.CreateDate = DateTime.Now;

                        contractMasterBLL.SaveMedicalDevices(medicalDevices);
                        MaintainRenewalMark();
                    }
                    //Edit
                    else
                    {
                        medicalDevices.Id = new Guid(this.hiddenWinMedicalDevicesDetailId.Text);

                        medicalDevices.Name = this.tfWinMedicalDevicesName.Text;
                        medicalDevices.Describe = this.tfWinMedicalDevicesDescribe.Text;
                        medicalDevices.UpdateUser = new Guid(_context.User.Id);
                        medicalDevices.UpdateDate = DateTime.Now;

                        contractMasterBLL.UpdateMedicalDevices(medicalDevices);
                    }
                    windowMedicalDevices.Hide();
                    gpMedicalDevices.Reload();
                }
                else
                {
                    throw new Exception(massage);
                }
            }
            catch
            {
                massage = massage.Substring(0, massage.Length - 5);
                Ext.Msg.Alert("Error", massage).Show();
            }
        }

        [AjaxMethod]
        public void DeleteMedicalDevicesItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                contractMasterBLL.DeleteMedicalDevices(new Guid(detailId));
                MaintainRenewalMark();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void EditMedicalDevicesItem(string detailId)
        {
            //Init vlaue within this window control
            InitMedicalDevicesWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadMedicalDevicesWindow(new Guid(detailId));

                //Set Value
                this.hiddenWinMedicalDevicesDetailId.Text = detailId;

                //Show Window
                this.windowMedicalDevices.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }

        }
        #endregion

        #region 营业执照、许可或登记情况
        [AjaxMethod]
        public void ShowBusLicenseWindow()
        {
            //Init vlaue within this window control
            InitBusLicenseWindow(true);

            //Show Window
            this.windowBusLicense.Show();
        }

        [AjaxMethod]
        public void SaveBusLicense()
        {
            string massage = "";
            if (String.IsNullOrEmpty(this.tfWinBusLicenseCountry.Text))
            {
                massage += "请填写国家名称<br/>";
            }
            
            if (String.IsNullOrEmpty(this.tfWinBusLicenseName.Text))
            {
                massage += "请填写证照名称<br/>";
            }
            if (String.IsNullOrEmpty(this.tfWinBusLicenseRegisterNumber.Text))
            {
                massage += "请填写证照编号<br/>";
            }
            try
            {
                if (massage.Equals(""))
                {
                    BusinessLicense businessLicense = new BusinessLicense();
                    //Create
                    if (string.IsNullOrEmpty(this.hiddenWinBusLicenseDetailId.Text))
                    {
                        businessLicense.Id = Guid.NewGuid();
                        businessLicense.CmId = new Guid(this.hdCmId.Value.ToString());

                        businessLicense.Country = this.tfWinBusLicenseCountry.Text;
                        businessLicense.Name = this.tfWinBusLicenseName.Text;
                        businessLicense.AuthOrg = this.tfWinBusLicenseAuthOrg.Text;
                        businessLicense.RegisterDate = this.tfWinBusLicenseRegisterDate.SelectedDate;
                        businessLicense.RegisterNumber = this.tfWinBusLicenseRegisterNumber.Text;

                        businessLicense.UpdateUser = null;
                        businessLicense.UpdateDate = null;
                        businessLicense.CreateUser = new Guid(_context.User.Id);
                        businessLicense.CreateDate = DateTime.Now;

                        contractMasterBLL.SaveBusinessLicense(businessLicense);
                        MaintainRenewalMark();
                    }
                    //Edit
                    else
                    {
                        businessLicense.Id = new Guid(this.hiddenWinBusLicenseDetailId.Text);

                        businessLicense.Country = this.tfWinBusLicenseCountry.Text;
                        businessLicense.Name = this.tfWinBusLicenseName.Text;
                        businessLicense.AuthOrg = this.tfWinBusLicenseAuthOrg.Text;
                        businessLicense.RegisterDate = this.tfWinBusLicenseRegisterDate.SelectedDate;
                        businessLicense.RegisterNumber = this.tfWinBusLicenseRegisterNumber.Text;

                        businessLicense.UpdateUser = new Guid(_context.User.Id);
                        businessLicense.UpdateDate = DateTime.Now;

                        contractMasterBLL.UpdateBusinessLicense(businessLicense);
                        MaintainRenewalMark();
                    }

                    windowBusLicense.Hide();
                    gpBusLicense.Reload();
                }
                else
                {
                    throw new Exception(massage);
                }
            }
            catch
            {
                massage = massage.Substring(0, massage.Length - 5);
                Ext.Msg.Alert("Error", massage).Show();
            }
        }

        [AjaxMethod]
        public void DeleteBusLicenseItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                contractMasterBLL.DeleteBusinessLicense(new Guid(detailId));
                MaintainRenewalMark();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void EditBusLicenseItem(string detailId)
        {
            //Init vlaue within this window control
            InitBusLicenseWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadBusLicenseWindow(new Guid(detailId));

                //Set Value
                this.hiddenWinBusLicenseDetailId.Text = detailId;

                //Show Window
                this.windowBusLicense.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }
        #endregion

        #region 公司董事及主要高层人员的背景信息
        [AjaxMethod]
        public void ShowSeniorCompanyWindow()
        {
            //Init vlaue within this window control
            InitSeniorCompanyWindow(true);

            //Show Window
            this.windowSeniorCompany.Show();
        }

        [AjaxMethod]
        public void SaveSeniorCompany()
        {
            string massage = "";
            if (String.IsNullOrEmpty(this.tfWinSeniorCompanyName.Text))
            {
                massage += "请填写公司负责人全名<br/>";
            }
           
            if (String.IsNullOrEmpty(this.tfWinSeniorCompanyPosition.Text))
            {
                massage += "请填写职位名称<br/>";
            }
            try
            {
                if (massage == "")
                {
                    SeniorCompany seniorCompany = new SeniorCompany();
                    //Create
                    if (string.IsNullOrEmpty(this.hiddenWinSeniorCompanyDetailId.Text))
                    {
                        seniorCompany.Id = Guid.NewGuid();
                        seniorCompany.CmId = new Guid(this.hdCmId.Value.ToString());

                        seniorCompany.Name = this.tfWinSeniorCompanyName.Text;
                        seniorCompany.Position = this.tfWinSeniorCompanyPosition.Text;
                        seniorCompany.BusinessAddress = this.tfWinSeniorCompanyBusinessAddress.Text;
                        seniorCompany.Telephone = this.tfWinSeniorCompanyTelephone.Text;
                        seniorCompany.Fax = this.tfWinSeniorCompanyFax.Text;
                        seniorCompany.Email = this.tfWinSeniorCompanyEmail.Text;
                        seniorCompany.HomeAddress = this.tfWinSeniorCompanyHomeAddress.Text;
                        seniorCompany.Pbumport = this.tfWinSeniorCompanyPbumport.Text;
                        seniorCompany.IdentityCard = this.tfWinSeniorCompanyIdentityCard.Text;
                        seniorCompany.Birthday = this.tfWinSeniorCompanyBirthday.SelectedDate;
                        seniorCompany.Birthplace = this.tfWinSeniorCompanyBirthplace.Text;

                        seniorCompany.UpdateUser = null;
                        seniorCompany.UpdateDate = null;
                        seniorCompany.CreateUser = new Guid(_context.User.Id);
                        seniorCompany.CreateDate = DateTime.Now;

                        contractMasterBLL.SaveSeniorCompany(seniorCompany);
                        MaintainRenewalMark();
                    }
                    //Edit
                    else
                    {
                        seniorCompany.Id = new Guid(this.hiddenWinSeniorCompanyDetailId.Text);

                        seniorCompany.Name = this.tfWinSeniorCompanyName.Text;
                        seniorCompany.Position = this.tfWinSeniorCompanyPosition.Text;
                        seniorCompany.BusinessAddress = this.tfWinSeniorCompanyBusinessAddress.Text;
                        seniorCompany.Telephone = this.tfWinSeniorCompanyTelephone.Text;
                        seniorCompany.Fax = this.tfWinSeniorCompanyFax.Text;
                        seniorCompany.Email = this.tfWinSeniorCompanyEmail.Text;
                        seniorCompany.HomeAddress = this.tfWinSeniorCompanyHomeAddress.Text;
                        seniorCompany.Pbumport = this.tfWinSeniorCompanyPbumport.Text;
                        seniorCompany.IdentityCard = this.tfWinSeniorCompanyIdentityCard.Text;
                        seniorCompany.Birthday = this.tfWinSeniorCompanyBirthday.SelectedDate;
                        seniorCompany.Birthplace = this.tfWinSeniorCompanyBirthplace.Text;

                        seniorCompany.UpdateUser = new Guid(_context.User.Id);
                        seniorCompany.UpdateDate = DateTime.Now;

                        contractMasterBLL.UpdateSeniorCompany(seniorCompany);
                        MaintainRenewalMark();
                    }
                    windowSeniorCompany.Hide();
                    gpSeniorCompany.Reload();
                }
                else
                {
                    throw new Exception(massage);
                }
            }
            catch
            {
                massage = massage.Substring(0, massage.Length - 5);
                Ext.Msg.Alert("Error", massage).Show();
            }
        }

        [AjaxMethod]
        public void DeleteSeniorCompanyItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                contractMasterBLL.DeleteSeniorCompany(new Guid(detailId));
                MaintainRenewalMark();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void EditSeniorCompanyItem(string detailId)
        {
            //Init vlaue within this window control
            InitSeniorCompanyWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadSeniorCompanyWindow(new Guid(detailId));

                //Set Value
                this.hiddenWinSeniorCompanyDetailId.Text = detailId;

                //Show Window
                this.windowSeniorCompany.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }
        #endregion

        #region 公司所有人及股东的背景信息
        [AjaxMethod]
        public void ShowCompanyStockholderWindow()
        {
            //Init vlaue within this window control
            InitCompanyStockholderWindow(true);

            //Show Window
            this.windowCompanyStockholder.Show();
        }

        [AjaxMethod]
        public void SaveCompanyStockholder()
        {
            string massage = "";
            if (String.IsNullOrEmpty(this.tfWinCompanyStockholderName.Text))
            {
                massage += "请填写名称<br/>";
            }
            if (String.IsNullOrEmpty(this.tfWinCompanyStockholderOwnership.Text))
            {
                massage += "请填写所有权<br/>";
            }
            try
            {
                if (massage == "")
                {
                    CompanyStockholder companyStockholder = new CompanyStockholder();
                    //Create
                    if (string.IsNullOrEmpty(this.hiddenWinCompanyStockholderDetailId.Text))
                    {
                        companyStockholder.Id = Guid.NewGuid();
                        companyStockholder.CmId = new Guid(this.hdCmId.Value.ToString());

                        companyStockholder.Name = this.tfWinCompanyStockholderName.Text;
                        companyStockholder.Ownership = Convert.ToInt32(this.tfWinCompanyStockholderOwnership.Text);
                        companyStockholder.BusinessAddress = this.tfWinCompanyStockholderBusinessAddress.Text;
                        companyStockholder.Telephone = this.tfWinCompanyStockholderTelephone.Text;
                        companyStockholder.Fax = this.tfWinCompanyStockholderFax.Text;
                        companyStockholder.Email = this.tfWinCompanyStockholderEmail.Text;
                        companyStockholder.HomeAddress = this.tfWinCompanyStockholderHomeAddress.Text;
                        companyStockholder.Pbumport = this.tfWinCompanyStockholderPbumport.Text;
                        companyStockholder.IdentityCard = this.tfWinCompanyStockholderIdentityCard.Text;
                        companyStockholder.Birthday = this.dfWinCompanyStockholderBirthday.SelectedDate;
                        companyStockholder.Birthplace = this.tfWinCompanyStockholderBirthplace.Text;
                        companyStockholder.Country = this.tfWinCompanyStockholderCountry.Text;
                        companyStockholder.Register = this.tfWinCompanyStockholderRegister.Text;
                        companyStockholder.Possessor = this.tfWinCompanyStockholderPossessor.Text;
                        companyStockholder.MiddleEntity = this.tfWinCompanyStockholderMiddleEntity.Text;

                        companyStockholder.UpdateUser = null;
                        companyStockholder.UpdateDate = null;
                        companyStockholder.CreateUser = new Guid(_context.User.Id);
                        companyStockholder.CreateDate = DateTime.Now;

                        contractMasterBLL.SaveCompanyStockholder(companyStockholder);
                        MaintainRenewalMark();
                    }
                    //Edit
                    else
                    {
                        companyStockholder.Id = new Guid(this.hiddenWinCompanyStockholderDetailId.Text);

                        companyStockholder.Name = this.tfWinCompanyStockholderName.Text;
                        companyStockholder.Ownership = Convert.ToInt32(this.tfWinCompanyStockholderOwnership.Text);
                        companyStockholder.BusinessAddress = this.tfWinCompanyStockholderBusinessAddress.Text;
                        companyStockholder.Telephone = this.tfWinCompanyStockholderTelephone.Text;
                        companyStockholder.Fax = this.tfWinCompanyStockholderFax.Text;
                        companyStockholder.Email = this.tfWinCompanyStockholderEmail.Text;
                        companyStockholder.HomeAddress = this.tfWinCompanyStockholderHomeAddress.Text;
                        companyStockholder.Pbumport = this.tfWinCompanyStockholderPbumport.Text;
                        companyStockholder.IdentityCard = this.tfWinCompanyStockholderIdentityCard.Text;
                        companyStockholder.Birthday = this.dfWinCompanyStockholderBirthday.SelectedDate;
                        companyStockholder.Birthplace = this.tfWinCompanyStockholderBirthplace.Text;
                        companyStockholder.Country = this.tfWinCompanyStockholderCountry.Text;
                        companyStockholder.Register = this.tfWinCompanyStockholderRegister.Text;
                        companyStockholder.Possessor = this.tfWinCompanyStockholderPossessor.Text;
                        companyStockholder.MiddleEntity = this.tfWinCompanyStockholderMiddleEntity.Text;

                        companyStockholder.UpdateUser = new Guid(_context.User.Id);
                        companyStockholder.UpdateDate = DateTime.Now;

                        contractMasterBLL.UpdateCompanyStockholder(companyStockholder);
                        MaintainRenewalMark();
                    }
                    windowCompanyStockholder.Hide();
                    gpCompanyStockholder.Reload();
                    gpPanelSign.Reload();
                }
                else
                {
                    throw new Exception(massage);
                }
            }
            catch
            {
                massage = massage.Substring(0, massage.Length - 5);
                Ext.Msg.Alert("Error", massage).Show();
            }

        }

        [AjaxMethod]
        public void DeleteCompanyStockholderItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                contractMasterBLL.DeleteCompanyStockholder(new Guid(detailId));
                MaintainRenewalMark();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void EditCompanyStockholderItem(string detailId)
        {
            //Init vlaue within this window control
            InitCompanyStockholderWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadCompanyStockholderWindow(new Guid(detailId));

                //Set Value
                this.hiddenWinCompanyStockholderDetailId.Text = detailId;

                //Show Window
                this.windowCompanyStockholder.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }
        #endregion

        #region Form3
        [AjaxMethod]
        public void SaveDraft()
        {
            try
            {
                string massage = "";
                if (!PageCheck(ref  massage))
                {
                    Ext.Msg.Alert("Error", massage).Show();
                }
                else
                {
                    SaveDate(ContractMastreStatus.Draft.ToString());
                    Ext.Msg.Alert("Success", "保存草稿成功").Show();
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }

        [AjaxMethod]
        public void SaveSubmit()
        {
            try
            {
                string massage = "";
                if (!PageCheck(ref  massage))
                {
                    Ext.Msg.Alert("Error", massage).Show();
                }
                else
                {
                    SaveDate(ContractMastreStatus.Submit.ToString());
                    Ext.Msg.Alert("Success", "提交成功").Show();
                }
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", ex.ToString()).Show();
            }
        }

        public void SaveDate(string cmStatus)
        {
            try
            {
                ContractMasterDM contract = new ContractMasterDM();
                contract.CmId = new Guid(this.hdCmId.Value.ToString());
                contract.CmDealerCnName = hdDealerCnName.Value.ToString();
                contract.CmAddress = tfAddress.Text;
                contract.CmTelephony = tfTelephony.Text;
                contract.CmContactPerson = tfContactPerson.Text;
                contract.CmEmail = tfContactEmail.Text;
                contract.CmCharter = tfCharter.Text;
                contract.CmCountry = tfCountry.Text;
                contract.CmFax = tfFax.Text;
                contract.CmWebsite = tfWebsite.Text;

                if (radioPubliclyTradedYes.Checked)
                {
                    contract.CmPubliclyTraded = true;
                    contract.CmExchange = this.tfExchange.Text;
                }
                else if (radioPubliclyTradedNo.Checked)
                {
                    contract.CmPubliclyTraded = false;
                    contract.CmDesc1 = "";
                }
                else
                {
                    contract.CmPubliclyTraded = null;
                    contract.CmDesc1 = "";
                }

                if (radioProperty1Yes.Checked)
                {
                    contract.CmProperty1 = true;
                    contract.CmDesc1 = this.tfDesc1.Text;
                }
                else if (radioProperty1No.Checked)
                {
                    contract.CmProperty1 = false;
                    contract.CmDesc1 = "";
                }
                else
                {
                    contract.CmProperty1 = null;
                    contract.CmDesc1 = "";
                }

                if (radioProperty2Yes.Checked)
                {
                    contract.CmProperty2 = true;
                    contract.CmDesc2 = this.tfDesc2.Text;
                }
                else if (radioProperty2No.Checked)
                {
                    contract.CmProperty2 = false;
                    contract.CmDesc2 = "";
                }
                else
                {
                    contract.CmProperty2 = null;
                    contract.CmDesc2 = "";
                }

                if (radioProperty3Yes.Checked)
                {
                    contract.CmProperty3 = true;
                    contract.CmDesc3 = this.tfDesc3.Text;
                }
                else if (radioProperty3No.Checked)
                {
                    contract.CmProperty3 = false;
                    contract.CmDesc3 = "";
                }
                else
                {
                    contract.CmProperty3 = null;
                    contract.CmDesc3 = "";
                }

                contract.CmStatus = cmStatus;
                contract.CmDmaId = new Guid(this.hdDealerId.Value.ToString());//new Guid(RoleModelContext.Current.User.CorpId.Value.ToString());
                contract.CmFrom3BankName = this.tfBankName.Text;
                contract.CmFrom3BankSwift = this.tfBankSwift.Text;
                contract.CmFrom3BankCountry = this.tfBankCountry.Text;
                contract.CmFrom3BankAddress = this.tfBankAddress.Text;
                contract.CmFrom3BankAccount = this.tfBankAccount.Text;

                if (Session["PageOperationType"] != null && (string)Session["PageOperationType"] == PageOperationType.EDIT.ToString())
                {
                    _contract.UpdateContractFrom3(contract);
                }
                else if (Session["PageOperationType"] != null && (string)Session["PageOperationType"] == PageOperationType.INSERT.ToString())
                {
                    _contract.InsertContractFrom3(contract);
                    Session["PageOperationType"] = PageOperationType.EDIT.ToString();
                }
                Session["From3"] = true;
                DealeriafSign sign = new DealeriafSign();
                sign.CmId = new Guid(this.hdCmId.Value.ToString());
                sign.From3Company = this.lbThirdParty.Text;
                sign.From3User = this.tfSignUserName.Text;
                sign.From3NationalId = this.tfIdentity.Text;
                sign.From3Birth = this.dfDate.SelectedDate;
                sign.From3Position = this.tfSignTital.Text;
                DealeriafSign dtSign = contractMasterBLL.GetDealerIAFSign(sign.CmId);
                if (dtSign == null)
                {
                    contractMasterBLL.SaveDealerIAFSign(sign);
                }
                else
                {
                    contractMasterBLL.UpdateDealerIAFSignFrom3(sign);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void BindMainData()
        {
            if (conMast != null)
            {
                if (String.IsNullOrEmpty(conMast.CmDealerCnName))
                {
                    tfDealerNameCn.Text = this.hdDealerCnName.Value.ToString();
                }
                else
                {
                    tfDealerNameCn.Text = conMast.CmDealerCnName;
                }

                tfAddress.Text = conMast.CmAddress;
                tfTelephony.Text = conMast.CmTelephony;
                tfContactPerson.Text = conMast.CmContactPerson;
                tfContactEmail.Text = conMast.CmEmail;
                tfCharter.Text = conMast.CmCharter;
                tfCountry.Text = conMast.CmCountry;
                tfFax.Text = conMast.CmFax;
                tfWebsite.Text = conMast.CmWebsite;
                if (conMast.CmPubliclyTraded != null)
                {
                    if ((bool)conMast.CmPubliclyTraded)
                    {
                        radioPubliclyTradedYes.Checked = true;
                        //this.tfExchange.Enabled = true;
                        this.tfExchange.Text = conMast.CmExchange;
                    }
                    else
                    {
                        radioPubliclyTradedNo.Checked = true;
                        //this.tfExchange.Enabled = false;
                    }
                }
                if (conMast.CmProperty1 != null)
                {
                    if ((bool)conMast.CmProperty1)
                    {
                        radioProperty1Yes.Checked = true;
                        this.tfDesc1.Enabled = true;
                        tfDesc1.Text = conMast.CmDesc1;
                    }
                    else
                    {
                        radioProperty1No.Checked = true;
                        //this.tfDesc1.Enabled = false;
                    }
                }

                if (conMast.CmProperty2 != null)
                {
                    if ((bool)conMast.CmProperty2)
                    {
                        radioProperty2Yes.Checked = true;
                        this.tfDesc2.Enabled = true;
                        tfDesc2.Text = conMast.CmDesc2;
                    }
                    else
                    {
                        radioProperty2No.Checked = true;
                        //this.tfDesc2.Enabled = false;
                    }
                }

                if (conMast.CmProperty3 != null)
                {
                    if ((bool)conMast.CmProperty3)
                    {
                        radioProperty3Yes.Checked = true;
                        this.tfDesc3.Enabled = true;
                        tfDesc3.Text = conMast.CmDesc3;
                    }
                    else
                    {
                        radioProperty3No.Checked = true;
                        //this.tfDesc3.Enabled = false;
                    }
                }
                this.tfBankAccount.Value = conMast.CmFrom3BankAccount;
                this.tfBankAddress.Value = conMast.CmFrom3BankAddress;
                this.tfBankCountry.Value = conMast.CmFrom3BankCountry;
                this.tfBankName.Value = conMast.CmFrom3BankName;
                this.tfBankSwift.Value = conMast.CmFrom3BankSwift;
            }
            else
            {
                tfDealerNameCn.Text = this.hdDealerCnName.Value.ToString();
            }
            IDealerMasters bll = new DealerMasters();
            DealerMaster dm = new DealerMaster();
            dm.Id = new Guid(this.hdDealerId.Value.ToString());
            IList<DealerMaster> listDm = bll.QueryForDealerMaster(dm);
            if (listDm.Count > 0)
            {
                DealerMaster getDealerMaster = listDm[0];
                this.hdDealerEnName.Text = getDealerMaster.EnglishName;
                tfDealerNameCn.Text += this.hdDealerEnName.Text;
            }
            this.lbThirdParty.Text = tfDealerNameCn.Text;
            DealeriafSign sign = _contractMasterBLL.GetDealerIAFSign(new Guid(this.hdCmId.Value.ToString()));
            if (sign != null)
            {
                tfSignUserName.Value = sign.From3User;
                tfIdentity.Value = sign.From3NationalId;
                tfSignTital.Value = sign.From3Position;
                if (sign.From3Birth != null)
                {
                    dfDate.SelectedDate = sign.From3Birth.Value;
                }
            }
        }

        private void PagePermissions()
        {
            if (Session["PageOperationType"] == null)
            {
                //合同主表数据未维护，并且登录人并不是“一级经销商”或者“设备经销商”，只能查看空页面
                this.btnSaveDraft.Hidden = true;
            }
            if (this.hdCmStatus.Value.ToString().Equals(ContractMastreStatus.Submit.ToString()))
            {
                this.btnSaveDraft.Hidden = true;
                if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ChannelOperation)
                    && !this.hdContStatus.Value.Equals(ContractStatus.Completed.ToString())
                    && !this.hdContStatus.Value.Equals(ContractStatus.COSubmitPDF.ToString())
                    && !this.hdContStatus.Value.Equals(ContractStatus.Reject.ToString())
                    )
                {
                    this.btnSubmit.Hidden = false;
                }
                else
                {
                    this.btnAddMedicalDevices.Enabled = false;
                    this.btnAddBusLicense.Enabled = false;
                    this.btnAddSeniorCompany.Enabled = false;
                    this.btnAddCompanyStockholder.Enabled = false;
               
                    this.gpMedicalDevices.ColumnModel.Columns[2].Hidden = true;
                    this.gpBusLicense.ColumnModel.Columns[5].Hidden = true;
                    this.gpSeniorCompany.ColumnModel.Columns[11].Hidden = true;
                    this.gpCompanyStockholder.ColumnModel.Columns[15].Hidden = true;
                }
            }
            else
            {
                //非经销商登录不可修改页面数据
                if (!IsDealer)
                {
                    this.btnAddMedicalDevices.Enabled = false;
                    this.btnAddBusLicense.Enabled = false;
                    this.btnAddSeniorCompany.Enabled = false;
                    this.btnAddCompanyStockholder.Enabled = false;
                
                    this.gpMedicalDevices.ColumnModel.Columns[2].Hidden = true;
                    this.gpBusLicense.ColumnModel.Columns[5].Hidden = true;
                    this.gpSeniorCompany.ColumnModel.Columns[11].Hidden = true;
                    this.gpCompanyStockholder.ColumnModel.Columns[15].Hidden = true;

                    this.btnSaveDraft.Hidden = true;
                }
            }
        }

        private bool PageCheck(ref string massage)
        {
            if (this.tfDealerNameCn.Text.Equals(""))
            {
                massage = "请填写公司名称<br/>";
            }
          
            if (Convert.ToInt32(this.hdLicense.Value.ToString()) <= 0)
            {
                massage += "请填写营业执照、许可或登记情况<br/>";
            }
            if (Convert.ToInt32(this.hdSeniorCompany.Value.ToString()) <= 0)
            {
                massage += "请填写公司董事及主要高层人员背景信息<br/>";
            }

            if (Convert.ToInt32(this.hdCompany.Value.ToString()) <= 0)
            {
                massage += "请填写公司所有人及股东背景信息<br/>";
            }
            else if (Convert.ToDecimal(this.hdCompanyValue.Value.ToString()) != 100)
            {
                massage += "股东所有权比例总和不为100%<br/>";
            }
            if (hdSignTp.Value.ToString().Equals("1"))
            {
                if (tfSignUserName.Text.Equals("") || tfSignTital.Text.Equals("") || tfIdentity.Text.Equals(""))
                {
                    massage += "股东含公司必须指派信息确认人，并在第11点信息下填完整“确认人”信息<br/>";
                }
            }
            if (massage.Equals(""))
            {
                return true;
            }
            else
            {
                massage = massage.Substring(0, massage.Length - 5);
                return false;
            }
        }

        private void MaintainRenewalMark()
        {
            if (this.hdParmetType.Value != null && this.hdParmetType.Value.ToString().Equals(ContractType.Renewal.ToString()))
            {
                Hashtable obj = new Hashtable();
                obj.Add("Mark", "1");
                obj.Add("CreId", this.hdContId.Value);
                _Renewal.UpdateRenewalFromMark(obj);
            }
        }
        private string GetDealerName(Guid dealerid)
        {
            string dealerName = "";
            if (dealerid != null && dealerid != Guid.Empty)
            {
                IDealerMasters bll = new DealerMasters();
                DealerMaster dm = new DealerMaster();
                dm.Id = dealerid;
                IList<DealerMaster> listDm = bll.QueryForDealerMaster(dm);
                if (listDm.Count > 0)
                {
                    DealerMaster getDealerMaster = listDm[0];
                    dealerName = String.IsNullOrEmpty(getDealerMaster.EnglishName) ? getDealerMaster.ChineseName : getDealerMaster.EnglishName;
                }
            }
            return dealerName;
        }

        #endregion

        #endregion

        #region Init

        /// <summary>
        /// Init Control value and status of MedicalDevices Window
        /// </summary>
        /// <param name="canSubmit"></param>
        private void InitMedicalDevicesWindow(bool canSubmit)
        {
            this.tfWinMedicalDevicesName.Clear();
            this.tfWinMedicalDevicesDescribe.Clear();
            this.hiddenWinMedicalDevicesDetailId.Clear();   //Id

            if (canSubmit)
            {
                this.btnMedicalDevicesSubmit.Visible = true;

                this.tfWinMedicalDevicesName.ReadOnly = false;
                this.tfWinMedicalDevicesDescribe.ReadOnly = false;
            }
            else
            {
                this.btnMedicalDevicesSubmit.Visible = false;

                this.tfWinMedicalDevicesName.ReadOnly = true;
                this.tfWinMedicalDevicesDescribe.ReadOnly = true;
            }
        }

        private void LoadMedicalDevicesWindow(Guid detailId)
        {
            MedicalDevices medicalDevices = contractMasterBLL.GetMedicalDevicesById(detailId);

            this.tfWinMedicalDevicesName.Text = medicalDevices.Name;
            this.tfWinMedicalDevicesDescribe.Text = medicalDevices.Describe;
        }

        /// <summary>
        /// Init Control value and status of BusLicense Window
        /// </summary>
        private void InitBusLicenseWindow(bool canSubmit)
        {
            this.tfWinBusLicenseCountry.Clear();
            this.tfWinBusLicenseName.Clear();
            this.tfWinBusLicenseAuthOrg.Clear();
            this.tfWinBusLicenseRegisterDate.Clear();
            this.tfWinBusLicenseRegisterNumber.Clear();
            this.hiddenWinBusLicenseDetailId.Clear();   //Id

            if (canSubmit)
            {
                this.btnBusLicenseSubmit.Visible = true;

                this.tfWinBusLicenseCountry.ReadOnly = false;
                this.tfWinBusLicenseName.ReadOnly = false;
                this.tfWinBusLicenseAuthOrg.ReadOnly = false;
                this.tfWinBusLicenseRegisterDate.ReadOnly = false;
                this.tfWinBusLicenseRegisterNumber.ReadOnly = false;
            }
            else
            {
                this.btnBusLicenseSubmit.Visible = false;

                this.tfWinBusLicenseCountry.ReadOnly = true;
                this.tfWinBusLicenseName.ReadOnly = true;
                this.tfWinBusLicenseAuthOrg.ReadOnly = true;
                this.tfWinBusLicenseRegisterDate.ReadOnly = true;
                this.tfWinBusLicenseRegisterNumber.ReadOnly = true;
            }
        }

        private void LoadBusLicenseWindow(Guid detailId)
        {
            BusinessLicense businessLicense = contractMasterBLL.GetBusinessLicenseById(detailId);

            this.tfWinBusLicenseCountry.Text = businessLicense.Country;
            this.tfWinBusLicenseName.Text = businessLicense.Name;
            this.tfWinBusLicenseAuthOrg.Text = businessLicense.AuthOrg;
            this.tfWinBusLicenseRegisterDate.SelectedDate = businessLicense.RegisterDate.HasValue ? businessLicense.RegisterDate.Value : new DateTime();
            this.tfWinBusLicenseRegisterNumber.Text = businessLicense.RegisterNumber;
        }

        /// <summary>
        /// Init Control value and status of SeniorCompany Window
        /// </summary>
        private void InitSeniorCompanyWindow(bool canSubmit)
        {
            this.tfWinSeniorCompanyName.Clear();
            this.tfWinSeniorCompanyPosition.Clear();
            this.tfWinSeniorCompanyBusinessAddress.Clear();
            this.tfWinSeniorCompanyTelephone.Clear();
            this.tfWinSeniorCompanyFax.Clear();
            this.tfWinSeniorCompanyEmail.Clear();
            this.tfWinSeniorCompanyHomeAddress.Clear();
            this.tfWinSeniorCompanyPbumport.Clear();
            this.tfWinSeniorCompanyIdentityCard.Clear();
            this.tfWinSeniorCompanyBirthday.Clear();
            this.tfWinSeniorCompanyBirthplace.Clear();
            this.hiddenWinSeniorCompanyDetailId.Clear();    //Id

            if (canSubmit)
            {
                this.btnSeniorCompanySubmit.Visible = true;

                this.tfWinSeniorCompanyName.ReadOnly = false;
                this.tfWinSeniorCompanyPosition.ReadOnly = false;
                this.tfWinSeniorCompanyBusinessAddress.ReadOnly = false;
                this.tfWinSeniorCompanyTelephone.ReadOnly = false;
                this.tfWinSeniorCompanyFax.ReadOnly = false;
                this.tfWinSeniorCompanyEmail.ReadOnly = false;
                this.tfWinSeniorCompanyHomeAddress.ReadOnly = false;
                this.tfWinSeniorCompanyPbumport.ReadOnly = false;
                this.tfWinSeniorCompanyIdentityCard.ReadOnly = false;
                this.tfWinSeniorCompanyBirthday.ReadOnly = false;
                this.tfWinSeniorCompanyBirthplace.ReadOnly = false;
            }
            else
            {
                this.btnSeniorCompanySubmit.Visible = false;

                this.tfWinSeniorCompanyName.ReadOnly = true;
                this.tfWinSeniorCompanyPosition.ReadOnly = true;
                this.tfWinSeniorCompanyBusinessAddress.ReadOnly = true;
                this.tfWinSeniorCompanyTelephone.ReadOnly = true;
                this.tfWinSeniorCompanyFax.ReadOnly = true;
                this.tfWinSeniorCompanyEmail.ReadOnly = true;
                this.tfWinSeniorCompanyHomeAddress.ReadOnly = true;
                this.tfWinSeniorCompanyPbumport.ReadOnly = true;
                this.tfWinSeniorCompanyIdentityCard.ReadOnly = true;
                this.tfWinSeniorCompanyBirthday.ReadOnly = true;
                this.tfWinSeniorCompanyBirthplace.ReadOnly = true;
            }
        }

        private void LoadSeniorCompanyWindow(Guid detailId)
        {
            SeniorCompany seniorCompany = contractMasterBLL.GetSeniorCompanyById(detailId);

            this.tfWinSeniorCompanyName.Text = seniorCompany.Name;
            this.tfWinSeniorCompanyPosition.Text = seniorCompany.Position;
            this.tfWinSeniorCompanyBusinessAddress.Text = seniorCompany.BusinessAddress;
            this.tfWinSeniorCompanyTelephone.Text = seniorCompany.Telephone;
            this.tfWinSeniorCompanyFax.Text = seniorCompany.Fax;
            this.tfWinSeniorCompanyEmail.Text = seniorCompany.Email;
            this.tfWinSeniorCompanyHomeAddress.Text = seniorCompany.HomeAddress;
            this.tfWinSeniorCompanyPbumport.Text = seniorCompany.Pbumport;
            this.tfWinSeniorCompanyIdentityCard.Text = seniorCompany.IdentityCard;
            this.tfWinSeniorCompanyBirthday.SelectedDate = seniorCompany.Birthday.HasValue ? seniorCompany.Birthday.Value : new DateTime();
            this.tfWinSeniorCompanyBirthplace.Text = seniorCompany.Birthplace;
        }

        /// <summary>
        /// Init Control value and status of CompanyStockholder Window
        /// </summary>
        private void InitCompanyStockholderWindow(bool canSubmit)
        {
            this.tfWinCompanyStockholderName.Clear();
            this.tfWinCompanyStockholderOwnership.Clear();
            this.tfWinCompanyStockholderBusinessAddress.Clear();
            this.tfWinCompanyStockholderTelephone.Clear();
            this.tfWinCompanyStockholderFax.Clear();
            this.tfWinCompanyStockholderEmail.Clear();
            this.tfWinCompanyStockholderHomeAddress.Clear();
            this.tfWinCompanyStockholderPbumport.Clear();
            this.tfWinCompanyStockholderIdentityCard.Clear();
            this.dfWinCompanyStockholderBirthday.Clear();
            this.tfWinCompanyStockholderBirthplace.Clear();
            this.tfWinCompanyStockholderCountry.Clear();
            this.tfWinCompanyStockholderRegister.Clear();
            this.tfWinCompanyStockholderPossessor.Clear();
            this.tfWinCompanyStockholderMiddleEntity.Clear();
            this.hiddenWinCompanyStockholderDetailId.Clear();   //Id

            if (canSubmit)
            {
                this.btnCompanyStockholderSubmit.Visible = true;

                this.tfWinCompanyStockholderName.ReadOnly = false;
                this.tfWinCompanyStockholderOwnership.ReadOnly = false;
                this.tfWinCompanyStockholderBusinessAddress.ReadOnly = false;
                this.tfWinCompanyStockholderTelephone.ReadOnly = false;
                this.tfWinCompanyStockholderFax.ReadOnly = false;
                this.tfWinCompanyStockholderEmail.ReadOnly = false;
                this.tfWinCompanyStockholderHomeAddress.ReadOnly = false;
                this.tfWinCompanyStockholderPbumport.ReadOnly = false;
                this.tfWinCompanyStockholderIdentityCard.ReadOnly = false;
                this.dfWinCompanyStockholderBirthday.ReadOnly = false;
                this.tfWinCompanyStockholderBirthplace.ReadOnly = false;
                this.tfWinCompanyStockholderCountry.ReadOnly = false;
                this.tfWinCompanyStockholderRegister.ReadOnly = false;
                this.tfWinCompanyStockholderPossessor.ReadOnly = false;
                this.tfWinCompanyStockholderMiddleEntity.ReadOnly = false;
            }
            else
            {
                this.btnCompanyStockholderSubmit.Visible = false;

                this.tfWinCompanyStockholderName.ReadOnly = true;
                this.tfWinCompanyStockholderOwnership.ReadOnly = true;
                this.tfWinCompanyStockholderBusinessAddress.ReadOnly = true;
                this.tfWinCompanyStockholderTelephone.ReadOnly = true;
                this.tfWinCompanyStockholderFax.ReadOnly = true;
                this.tfWinCompanyStockholderEmail.ReadOnly = true;
                this.tfWinCompanyStockholderHomeAddress.ReadOnly = true;
                this.tfWinCompanyStockholderPbumport.ReadOnly = true;
                this.tfWinCompanyStockholderIdentityCard.ReadOnly = true;
                this.dfWinCompanyStockholderBirthday.ReadOnly = true;
                this.tfWinCompanyStockholderBirthplace.ReadOnly = true;
                this.tfWinCompanyStockholderCountry.ReadOnly = true;
                this.tfWinCompanyStockholderRegister.ReadOnly = true;
                this.tfWinCompanyStockholderPossessor.ReadOnly = true;
                this.tfWinCompanyStockholderMiddleEntity.ReadOnly = true;
            }
        }

        private void LoadCompanyStockholderWindow(Guid detailId)
        {
            CompanyStockholder companyStockholder = contractMasterBLL.GetCompanyStockholderById(detailId);

            this.tfWinCompanyStockholderName.Text = companyStockholder.Name;
            this.tfWinCompanyStockholderOwnership.Text = companyStockholder.Ownership.HasValue ? companyStockholder.Ownership.Value.ToString() : string.Empty;
            this.tfWinCompanyStockholderBusinessAddress.Text = companyStockholder.BusinessAddress;
            this.tfWinCompanyStockholderTelephone.Text = companyStockholder.Telephone;
            this.tfWinCompanyStockholderFax.Text = companyStockholder.Fax;
            this.tfWinCompanyStockholderEmail.Text = companyStockholder.Email;
            this.tfWinCompanyStockholderHomeAddress.Text = companyStockholder.HomeAddress;
            this.tfWinCompanyStockholderPbumport.Text = companyStockholder.Pbumport;
            this.tfWinCompanyStockholderIdentityCard.Text = companyStockholder.IdentityCard;
            this.dfWinCompanyStockholderBirthday.SelectedDate = companyStockholder.Birthday.HasValue ? companyStockholder.Birthday.Value : new DateTime();
            this.tfWinCompanyStockholderBirthplace.Text = companyStockholder.Birthplace;
            this.tfWinCompanyStockholderCountry.Text = companyStockholder.Country;
            this.tfWinCompanyStockholderRegister.Text = companyStockholder.Register;
            this.tfWinCompanyStockholderPossessor.Text = companyStockholder.Possessor;
            this.tfWinCompanyStockholderMiddleEntity.Text = companyStockholder.MiddleEntity;
        }
      
        #endregion

        #region Create IAF_Form_3 File

        protected void CreatePdf(object sender, EventArgs e)
        {
            Hashtable table = new Hashtable();
            table.Add("CmId", this.hdCmId.Value);
            conMast = _contract.GetContractMasterByCmID(table);

            string fileName = DateTime.Now.ToFileTime().ToString() + ".pdf";
            string targetPath = Server.MapPath(PdfHelper.FILE_PATH + fileName);

            Document doc = new Document(iTextSharp.text.PageSize.A4, 36, 36, 55, 50);
            try
            {
                //注册中文字库
                PdfHelper.RegisterChineseFont();
                PdfHelper pdfFont = new PdfHelper();

                PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(targetPath, FileMode.Create));
                //设置脚注，页码
                PdfPageEvent pdfPage = new PdfPageEvent("Form 3\r\nThird Party Disclosure Form"
                                            , "Form 3 Third Party Disclosure Form Rev. AB"
                                            , true);
                writer.PageEvent = pdfPage;

                doc.Open();

                #region Public Element
                PdfPCell noSelectCell = PdfHelper.GetNoSelectImageCell();
                PdfPCell SelectCell = PdfHelper.GetYesSelectImageCell();
                #endregion

                #region 1.	Company Information
                PdfPTable compayInfoTable = new PdfPTable(2);
                compayInfoTable.SetWidths(new float[] { 50f, 50f });
                PdfHelper.InitPdfTableProperty(compayInfoTable);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("1.	     公司信息", PdfHelper.italicFontBasc)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, Colspan = 2, BackgroundColor = PdfHelper.remarkBgColor }
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);

                //Company Name/Company ID#
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("公司名称（本表简称“公司”）: ", PdfHelper.youngFontBasc)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("公司ID#/许可证#:", PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(GetDealerName(conMast.CmDmaId) + "\r\n (" + conMast.CmDealerCnName + ")", PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmCharter, PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Address/Country
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("地址:", PdfHelper.youngFontBasc)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("国家:", PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmAddress, PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmCountry, PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Tel/Fax
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("电话:", PdfHelper.youngFontBasc)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("传真:", PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmTelephony, PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmFax, PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Principal Contact/Website
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("主要联系人:", PdfHelper.youngFontBasc)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("网址:", PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmContactPerson, PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmWebsite, PdfHelper.youngFontBasc))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                PdfHelper.AddPdfTable(doc, compayInfoTable);

                PdfPTable compayTradedTable = new PdfPTable(6);
                compayTradedTable.SetWidths(new float[] { 50f, 5f, 7.5f, 5f, 7.5f, 25f });
                PdfHelper.InitPdfTableProperty(compayTradedTable);

                //Principal Contact E-mail/Website
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("主要联系人电子邮件:", PdfHelper.youngFontBasc)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("公司是否上市?", PdfHelper.youngFontBasc)) { Colspan = 4 }
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("若“是”，在哪个证交所?", PdfHelper.youngFontBasc))
                       , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmEmail, PdfHelper.youngFontBasc))
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(conMast.CmPubliclyTraded)
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("是", PdfHelper.youngFontBasc))
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!conMast.CmPubliclyTraded)
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("否", PdfHelper.youngFontBasc))
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                string exchange = "";
                if (conMast.CmPubliclyTraded != null && !conMast.CmPubliclyTraded.Value)
                {
                    exchange = "N/A";
                }
                else
                {
                    exchange = conMast.CmExchange;
                }
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(exchange, PdfHelper.youngFontBasc))
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                PdfHelper.AddPdfTable(doc, compayTradedTable);

                //Remarks
                PdfPTable cbTable = new PdfPTable(4);
                cbTable.SetWidths(new float[] { 5f, 30f, 35f, 30f });
                PdfHelper.InitPdfTableProperty(cbTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph(" ", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, Colspan = 4 }
                        , cbTable, Rectangle.ALIGN_LEFT, null);

                Chunk noteChunk = new Chunk(" 注意: ", PdfHelper.youngFontBasc);
                Chunk descChunk = new Chunk(" 请完整填写全部内容，在不适用部分请填写“无”。", PdfHelper.youngFontBasc);

                Phrase notePhrase = new Phrase();
                notePhrase.Add(noteChunk);
                notePhrase.Add(descChunk);

                Paragraph noteParagraph = new Paragraph();
                noteParagraph.Add(notePhrase);

                PdfHelper.AddPdfCell(new PdfPCell(noteParagraph) { Colspan = 4, BackgroundColor = PdfHelper.grayColor }, cbTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, cbTable, null, null);
                

                PdfHelper.AddPdfTable(doc, cbTable);

                #endregion
             

                #region 2. 	Medical Device or Pharmaceutical Companies
                Hashtable pharmaceuticalTable = new Hashtable();
                pharmaceuticalTable.Add("CmId", this.hdCmId.Value);
                DataSet medicalDeviceDs = contractMasterBLL.QueryMedicalDevicesList(pharmaceuticalTable);

                PdfPTable medicalDeviceTable = new PdfPTable(3);
                medicalDeviceTable.SetWidths(new float[] { 20f, 40f, 40f });
                PdfHelper.InitPdfTableProperty(medicalDeviceTable);

                this.AddHeadTable(doc, 2, "医疗器械或制药公司", "请列出您／贵公司代理的其它医疗器械或制药公司的名称及描述。若没有，请在此填“无”。");


                int medicalDeviceCount = medicalDeviceDs.Tables[0].Rows.Count > 2 ? medicalDeviceDs.Tables[0].Rows.Count * 2 : 4;
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("所代表公司", PdfHelper.youngBoldFontBasc)) { Rowspan = medicalDeviceCount, BackgroundColor = PdfHelper.grayColor }
                        , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, true, false, true, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("名称:", PdfHelper.youngFontBasc))
                        , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, true, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("业务描述:", PdfHelper.youngFontBasc))
                        , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, true, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, 1, "Name"), PdfHelper.youngFontBasc))
                        , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, 1, "Describe"), PdfHelper.youngFontBasc))
                        , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("名称:", PdfHelper.youngFontBasc))
                        , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("业务描述:", PdfHelper.youngFontBasc))
                        , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, 2, "Name"), PdfHelper.youngFontBasc))
                        , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, 2, "Describe"), PdfHelper.youngFontBasc))
                        , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                for (int i = 2; i < medicalDeviceDs.Tables[0].Rows.Count; i++)
                {
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("名称:", PdfHelper.youngFontBasc))
                        , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("业务描述:", PdfHelper.youngFontBasc))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, i + 1, "Name"), PdfHelper.youngFontBasc))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, i + 1, "Describe"), PdfHelper.youngFontBasc))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);
                }

                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, medicalDeviceTable, null, null);

                PdfHelper.AddPdfTable(doc, medicalDeviceTable);
                #endregion

                #region 3.	Business Licenses, Permits or Registrations
                Hashtable businesLicensestable = new Hashtable();
                businesLicensestable.Add("CmId", this.hdCmId.Value);
                DataSet businessLicensesDs = contractMasterBLL.QueryBusinessLicenseList(businesLicensestable);

                PdfPTable lincensesTable = new PdfPTable(4);
                lincensesTable.SetWidths(new float[] { 25f, 25f, 25f, 25f });
                PdfHelper.InitPdfTableProperty(lincensesTable);

                this.AddHeadTable(doc, 3, "营业执照、许可或登记情况", "请提供与贵公司持有的任何营业执照、许可或登记有关的下列详细信息。");

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("签发国家", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , lincensesTable, null, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("执照、许可或登记的名称", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , lincensesTable, null, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("授权单位", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , lincensesTable, null, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("登记日期及登记编号", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , lincensesTable, null, null, true, true, true, true);

                int businessLicensesCount = businessLicensesDs.Tables[0].Rows.Count > 2 ? businessLicensesDs.Tables[0].Rows.Count : 2;
                for (int i = 1; i < businessLicensesCount + 1; i++)
                {
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessLicensesDs, i, "Country"), PdfHelper.youngFontBasc))
                            , lincensesTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessLicensesDs, i, "Name"), PdfHelper.youngFontBasc))
                            , lincensesTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessLicensesDs, i, "AuthOrg"), PdfHelper.youngFontBasc))
                            , lincensesTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetDataStringByString(this.GetStringByDataRow(businessLicensesDs, i, "RegisterDate"), null) + " " + this.GetStringByDataRow(businessLicensesDs, i, "RegisterNumber"), PdfHelper.youngFontBasc))
                            , lincensesTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                }
                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, lincensesTable, null, null);

                PdfHelper.AddPdfTable(doc, lincensesTable);
                #endregion

                #region 4. 	Background Information on Company Directors and Principal Officers
                Hashtable companyDirectorsTable = new Hashtable();
                companyDirectorsTable.Add("CmId", this.hdCmId.Value);
                DataSet companyDirectorsDs = contractMasterBLL.QuerySeniorCompanyList(companyDirectorsTable);

                PdfPTable bgInfoTable = new PdfPTable(4);
                bgInfoTable.SetWidths(new float[] { 25f, 25f, 25f, 25f });
                PdfHelper.InitPdfTableProperty(bgInfoTable);

                this.AddHeadTable(doc, 4, "公司董事及主要高层人员的背景信息", "请提供有关贵公司的董事及各主要高层人员（董事长、总经理、首席财务官等）的下列资料。若有必要，请另附一页，提供额外的资料。");

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                        , bgInfoTable, null, null, true, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("董事/高层人员", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, null, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("董事/高层人员", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, null, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("董事/高层人员", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, null, null, true, true, true, true);

                //Full Name
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("全名（姓及名）:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Name"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Name"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Name"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Position / Title
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("职位/职务:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Position"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Position"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Position"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Office Address(if different from Section 1):
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("办公地址\r\n（若与第1节不同）:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "BusinessAddress"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "BusinessAddress"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "BusinessAddress"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Telephone
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("电话:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Telephone"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Telephone"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Telephone"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Fax
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("传真:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Fax"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Fax"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Fax"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Email
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("电子邮件:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Email"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Email"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Email"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Residential Address
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("居住地址:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "HomeAddress"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "HomeAddress"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "HomeAddress"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Passport #
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("护照 #:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Pbumport"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Pbumport"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Pbumport"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //National Residential ID#:
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("国家居民 ID#:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "IdentityCard"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "IdentityCard"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "IdentityCard"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Date of Birth: 
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("出生日期: ", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Birthday").Equals("")?"":this.GetStringByDataRow(companyDirectorsDs, 1, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyDirectorsDs, 1, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, 1, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Birthday").Equals("")?"": this.GetStringByDataRow(companyDirectorsDs, 2, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyDirectorsDs, 2, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, 2, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Birthday").Equals("")?"":this.GetStringByDataRow(companyDirectorsDs, 3, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyDirectorsDs, 3, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, 3, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Place of Birth:
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("出生地点:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Birthplace"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Birthplace"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Birthplace"), PdfHelper.youngFontBasc))
                        , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                #region For 循环

                int companyDirectorsCount = companyDirectorsDs.Tables[0].Rows.Count / 3 > 0 ? companyDirectorsDs.Tables[0].Rows.Count / 3 : 0;
                for (int i = 0; i < companyDirectorsCount; i++)
                {
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                        , bgInfoTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("董事/高层人员", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("董事/高层人员", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("董事/高层人员", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, null, null, true, true, true, true);

                    //Full Name
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("全名（姓及名）:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Name"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Name"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Name"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Position / Title
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("职位/职务:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Position"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Position"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Position"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Office Address(if different from Section 1):
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("办公地址\r\n（若与第1节不同）:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "BusinessAddress"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "BusinessAddress"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "BusinessAddress"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Telephone
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("电话:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Telephone"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Telephone"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Telephone"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Fax
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("传真:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Fax"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Fax"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Fax"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Email
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("电子邮件:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Email"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Email"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Email"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Residential Address
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("居住地址:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "HomeAddress"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "HomeAddress"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "HomeAddress"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Passport #
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("护照 #:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Pbumport"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Pbumport"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Pbumport"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //National Residential ID#:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("国家居民 ID#:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "IdentityCard"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "IdentityCard"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "IdentityCard"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Date of Birth: 
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("出生日期: ", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Birthday").Equals("")?"":this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Birthday").Equals("")?"":this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Birthday").Equals("")?"": this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Place of Birth:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("出生地点:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Birthplace"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Birthplace"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Birthplace"), PdfHelper.youngFontBasc))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                }
                #endregion

                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, bgInfoTable, null, null);

                PdfHelper.AddPdfTable(doc, bgInfoTable);
                #endregion

                #region 5.	Background Information on Company Owners and Shareholders
                Hashtable companyOwnersTable = new Hashtable();
                companyOwnersTable.Add("CmId", this.hdCmId.Value);
                DataSet companyOwnersDs = contractMasterBLL.QueryCompanyStockholderList(companyOwnersTable);

                PdfPTable shareholdersTable = new PdfPTable(4);
                shareholdersTable.SetWidths(new float[] { 25f, 25f, 25f, 25f });
                PdfHelper.InitPdfTableProperty(shareholdersTable);

                this.AddHeadTable(doc, 5, "公司所有人及股东的背景信息 ", "请提供所有贵公司所有人及股东的下列资料。若为上市公司，只需提供公司所有权占5%及以上的所有人和股东的资料。若所有人或股东为其他公司，请列出该公司及其最终实益拥有人（即自然人）及任何中间实体。若有必要，请另附一页，提供额外的资料。");

                #region User Info
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                        , shareholdersTable, null, null, true, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("股东", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , shareholdersTable, null, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("股东", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , shareholdersTable, null, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("股东", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , shareholdersTable, null, null, true, true, true, true);

                //Full Name
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("全名（姓及名）:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Name"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Name"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Name"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Relationship / % Ownership
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("关系/所有权%:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Ownership"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Ownership"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Ownership"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Office Address:
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("办公地址:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "BusinessAddress"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "BusinessAddress"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "BusinessAddress"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Telephone:
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("电话:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Telephone"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Telephone"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Telephone"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Fax:
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("传真:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Fax"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Fax"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Fax"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Email:
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("电子邮件:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Email"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Email"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Email"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                #endregion

                #region NATURAL PERSON

                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("若股东为自然人:", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor, Colspan = 4, BorderWidth = 1f, BorderWidthBottom = 0f, BorderColor = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("居住地址:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "HomeAddress"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "HomeAddress"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "HomeAddress"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0.6f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("护照#", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Pbumport"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Pbumport"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Pbumport"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("国家居民 ID#:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "IdentityCard"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "IdentityCard"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "IdentityCard"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("出生日期:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Birthday").Equals("")?"":this.GetStringByDataRow(companyOwnersDs, 1, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyOwnersDs, 1, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, 1, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Birthday").Equals("")?"":this.GetStringByDataRow(companyOwnersDs, 2, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyOwnersDs, 2, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, 2, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Birthday").Equals("")?"":this.GetStringByDataRow(companyOwnersDs, 3, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyOwnersDs, 3, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, 3, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("出生地点:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 0f, BorderWidthLeft = 1f, BorderColorLeft = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Birthplace"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Birthplace"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Birthplace"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthBottom = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                #endregion

                #region COMPANY
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("若股东为公司:", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor, Colspan = 4, BorderWidth = 1f, BorderWidthBottom = 0f, BorderColor = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                //Country of Incorporation
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("成立国家:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Country"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Country"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Country"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0.6f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                //Registry #
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("登记#:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Register"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Register"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Register"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                //Ultimate Beneficial Owner
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("最终实益拥有人:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Possessor"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Possessor"), PdfHelper.youngFontBasc))
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Possessor"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                //Intermediate Entities
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("中间实体:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 1f, BorderWidthLeft = 1f, BorderColorLeft = PdfHelper.blueColor, BorderColorBottom = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "MiddleEntity"), PdfHelper.youngFontBasc)) { BorderWidth = 0f, BorderWidthLeft = 0.6f, BorderWidthBottom = 1f, BorderColorBottom = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "MiddleEntity"), PdfHelper.youngFontBasc)) { BorderWidth = 0f, BorderWidthLeft = 0.6f, BorderWidthBottom = 1f, BorderColorBottom = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "MiddleEntity"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, BorderColorBottom = PdfHelper.blueColor }
                        , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                #endregion

                #region For 循环
                int companyOwnersCount = companyOwnersDs.Tables[0].Rows.Count / 3 > 0 ? companyOwnersDs.Tables[0].Rows.Count / 3 : 0;
                for (int i = 0; i < companyOwnersCount; i++)
                {
                    #region User Info
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                            , shareholdersTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("股东", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("股东", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("股东", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, null, null, true, true, true, true);

                    //Full Name
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("全名（姓及名）:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Name"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Name"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Name"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Relationship / % Ownership
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("关系/所有权%:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Ownership"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Ownership"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Ownership"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Office Address:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("办公地址:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "BusinessAddress"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "BusinessAddress"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "BusinessAddress"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Telephone:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("电话:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Telephone"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Telephone"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Telephone"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Fax:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("传真:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Fax"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Fax"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Fax"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Email:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("电子邮件:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Email"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Email"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Email"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                    #endregion

                    #region NATURAL PERSON

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("若股东为自然人:", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor, Colspan = 4, BorderWidth = 1f, BorderWidthBottom = 0f, BorderColor = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("居住地址:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "HomeAddress"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "HomeAddress"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "HomeAddress"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0.6f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("护照 #", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Pbumport"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Pbumport"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Pbumport"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("国家居民 ID#:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "IdentityCard"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "IdentityCard"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "IdentityCard"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("出生日期:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Birthday").Equals("")?"":this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Birthday").Equals("")?"": this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Birthday").Equals("")?"":this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Birthday").Equals("") ? "" : Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Birthday")).ToShortDateString(), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("出生地点:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 0f, BorderWidthLeft = 1f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Birthplace"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Birthplace"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Birthplace"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthBottom = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    #endregion

                    #region COMPANY
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("若股东为公司:", PdfHelper.youngBoldFontBasc)) { BackgroundColor = PdfHelper.grayColor, Colspan = 4, BorderWidth = 1f, BorderWidthBottom = 0f, BorderColor = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Country of Incorporation
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("成立国家:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Country"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Country"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Country"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0.6f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Registry #
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("登记 #:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Register"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Register"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Register"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Ultimate Beneficial Owner
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("最终实益拥有人:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Possessor"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Possessor"), PdfHelper.youngFontBasc))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Possessor"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Intermediate Entities
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("中间实体:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor, BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 1f, BorderWidthLeft = 1f, BorderColorLeft = PdfHelper.blueColor, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "MiddleEntity"), PdfHelper.youngFontBasc)) { BorderWidth = 0f, BorderWidthLeft = 0.6f, BorderWidthBottom = 1f, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "MiddleEntity"), PdfHelper.youngFontBasc)) { BorderWidth = 0f, BorderWidthLeft = 0.6f, BorderWidthBottom = 1f, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "MiddleEntity"), PdfHelper.youngFontBasc)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    #endregion
                }
                #endregion

                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, shareholdersTable, null, null);

                PdfHelper.AddPdfTable(doc, shareholdersTable);
                #endregion


                #region 6. 	Bank Account

                PdfPTable bankAccountTable = new PdfPTable(3);
                bankAccountTable.SetWidths(new float[] { 20f, 40f, 40f });
                PdfHelper.InitPdfTableProperty(bankAccountTable);

                this.AddHeadTable(doc, 6, "请提供银行账户的详细信息", null);
              
                //One
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("银行账户", PdfHelper.youngBoldFontBasc)) { Rowspan = 6, BackgroundColor = PdfHelper.grayColor }
                        , bankAccountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("银行名称:", PdfHelper.youngFontBasc)) { Colspan = 2 }
                        , bankAccountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, true, true, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmFrom3BankName, PdfHelper.youngFontBasc)) { Colspan = 2 }
                        , bankAccountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("地址:", PdfHelper.youngFontBasc))
                        , bankAccountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("国家:", PdfHelper.youngFontBasc))
                        , bankAccountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmFrom3BankAddress, PdfHelper.youngFontBasc))
                        , bankAccountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmFrom3BankCountry, PdfHelper.youngFontBasc))
                        , bankAccountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("账号:", PdfHelper.youngFontBasc))
                        , bankAccountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("电汇 – Swift #:", PdfHelper.youngFontBasc))
                        , bankAccountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmFrom3BankAccount, PdfHelper.youngFontBasc))
                        , bankAccountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmFrom3BankSwift, PdfHelper.youngFontBasc))
                        , bankAccountTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);



                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, bankAccountTable, null, null);

                PdfHelper.AddPdfTable(doc, bankAccountTable);
              
                #endregion

                #region 7.	Additional Information
                PdfPTable additionalTable = new PdfPTable(5);
                additionalTable.SetWidths(new float[] { 60f, 5f, 5f, 5f, 25f });
                PdfHelper.InitPdfTableProperty(additionalTable);

                this.AddHeadTable(doc, 7, "其他信息", null);

                //1
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("在过去五年中，公司或任一主要的高层人员、董事或股东是否涉及民事或刑事案件（轻微交通违规行为及家庭纠纷除外）?", PdfHelper.youngFontBasc)) { Rowspan = 3 }
                        , additionalTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(conMast.CmProperty1)
                        , additionalTable, null, null, true, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("是", PdfHelper.youngFontBasc))
                        , additionalTable, Rectangle.ALIGN_LEFT, null, true, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!conMast.CmProperty1)
                        , additionalTable, null, null, true, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("否", PdfHelper.youngFontBasc))
                        , additionalTable, Rectangle.ALIGN_LEFT, null, true, true, true, false);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("若“是”，请提供详情:", PdfHelper.youngFontBasc)) { Colspan = 4 }
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmDesc1 + " ", PdfHelper.youngFontBasc)) { Colspan = 4 }
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //2
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("在过去五年中，公司或任一主要的高层人员、董事或股东是否涉及任何政府/监管机构的调查或行政案件或受到制裁?", PdfHelper.youngFontBasc)) { Rowspan = 3 }
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(conMast.CmProperty2)
                        , additionalTable, null, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("是", PdfHelper.youngFontBasc))
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!conMast.CmProperty2)
                        , additionalTable, null, null, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("否", PdfHelper.youngFontBasc))
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("若“是”，请提供详情:", PdfHelper.youngFontBasc)) { Colspan = 4 }
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmDesc2 + " ", PdfHelper.youngFontBasc)) { Colspan = 4 }
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //3
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("在过去五年中，公司或任一主要的高层人员、董事或股东是否申请或涉及任何与破产、无力偿债或重组相关的案件?", PdfHelper.youngFontBasc)) { Rowspan = 3 }
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(conMast.CmProperty3)
                        , additionalTable, null, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("是", PdfHelper.youngFontBasc))
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!conMast.CmProperty3)
                        , additionalTable, null, null, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("否", PdfHelper.youngFontBasc))
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("若“是”，请提供详情:", PdfHelper.youngFontBasc)) { Colspan = 4 }
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmDesc3, PdfHelper.youngFontBasc)) { Colspan = 4 }
                        , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);


                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 5 }, additionalTable, null, null);

                PdfHelper.AddPdfTable(doc, additionalTable);
                #endregion

                #region 8.	Release of Information
                PdfPTable releaseTable = new PdfPTable(1);
                PdfHelper.InitPdfTableProperty(releaseTable);

                this.AddHeadTable(doc, 8, "信息发布", null);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                        , releaseTable, Rectangle.ALIGN_LEFT, null, true, false, false, false);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("兹以通知，在您申请成为经销商时，蓝威可能会购买尽职调查验证报告及/或调查性的尽职调查报告，以获取有关各种事项的信息，包括但不限于公司结构、所有权、商务实践、银行记录、资信状况、破产程序、刑事记录、民事记录、一般声誉及个人品质（包括前述任何项目，以及个人的教育程度、从业历史等）。吾等需要您对以下的发布授权签字。", PdfHelper.youngFontBasc))
                        , releaseTable, Rectangle.ALIGN_LEFT, null);

                PdfHelper.AddPdfCell("发布授权:"
                        , PdfHelper.youngBoldFontBasc, releaseTable, Rectangle.ALIGN_LEFT);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("本人特此毫无保留地授权任何人员、公司、机构、教育或其他组织提供上述信息。与此同时，本人授权蓝威或其代理人从任何机构购买尽职调查验证报告及/或调查性的尽职调查报告，以查明本人的个人品质和资信状况。本人进一步承认，本次发布授权的摄影副本或传真件与正本具有相同等效力。本人同意免除所有人员及实体由此类披露引起的任何责任，以及因提供信息错误而引起的任何责任并使其免受损害。", PdfHelper.youngFontBasc))
                        , releaseTable, Rectangle.ALIGN_LEFT, null);

                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE }, releaseTable, null, null);

                PdfHelper.AddPdfTable(doc, releaseTable);
                #endregion

                #region 9.	Signature
                PdfPTable signatureTable = new PdfPTable(4);
                signatureTable.SetWidths(new float[] { 15f, 45f, 20f, 20f });
                PdfHelper.InitPdfTableProperty(signatureTable);

                this.AddHeadTable(doc, 9, "签名", "本人已详读并充分明白上述通知及发布信息，并确认在此提供的全部信息真实准确，本人经授权代表公司执行本发布。");

              

                if (companyOwnersDs.Tables[0].Rows.Count > 0)
                {
                    DataTable dt = companyOwnersDs.Tables[0];
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (!dt.Rows[i]["HomeAddress"].ToString().Equals("") || !dt.Rows[i]["IdentityCard"].ToString().Equals(""))
                        {
                            #region User One
                            //Company/Date
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("公司:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(GetDealerName(conMast.CmDmaId) + "\r\n (" + conMast.CmDealerCnName + ")", PdfHelper.youngChineseFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, false, true, false);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("日期:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(DateTime.Now.ToShortDateString(), PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, false);
                            //signature/National Identification
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("由（签名）:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("国家居民身份证 #:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dt.Rows[i]["IdentityCard"].ToString(), PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);
                            //Date of Birth/Position
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("出生日期:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dt.Rows[i]["Birthday"].ToString() == "" ? "" : Convert.ToDateTime(dt.Rows[i]["Birthday"].ToString()).ToShortDateString(), PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("职位", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("股东", PdfHelper.youngFontBasc))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                            PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, signatureTable, null, null);
                            #endregion
                        }
                    }
                }
                if (hdSignTp.Value.Equals("1"))
                {
                    #region 股东为公司

                    DealeriafSign dtSign = contractMasterBLL.GetDealerIAFSign(new Guid(this.hdCmId.Value.ToString()));
                    if (dtSign != null)
                    {
                        //Company/Date
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("公司:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(GetDealerName(conMast.CmDmaId) + "\r\n (" + conMast.CmDealerCnName + ")", PdfHelper.youngChineseFont))
                                , signatureTable, Rectangle.ALIGN_LEFT, null, true, false, true, false);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("日期:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(DateTime.Now.ToShortDateString(), PdfHelper.youngFont))
                                , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, false);
                        //signature/National Identification
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("由（签名）:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                                , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("国家居民身份证 #:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dtSign.From3NationalId, PdfHelper.youngFont))
                                , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);
                        //Date of Birth/Position
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("出生日期:", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dtSign.From3Birth.Value.ToShortDateString(), PdfHelper.youngFont))
                                , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("职位", PdfHelper.youngFontBasc)) { BackgroundColor = PdfHelper.grayColor }
                                , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dtSign.From3Position, PdfHelper.youngFontBasc))
                                , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                        PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, signatureTable, null, null);
                    }
                    #endregion
                }

                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, signatureTable, null, null);
                

                PdfHelper.AddPdfTable(doc, signatureTable);
                #endregion

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                //return string.Empty;
            }
            finally
            {
                doc.Close();
            }

            DownloadFileForDCMS(fileName, "IAF_Form_3.pdf", "DCMS");
        }

        private PdfPCell AddCheckBox(string key, string value)
        {
            #region Public Element
            PdfPCell noSelectCell = PdfHelper.GetNoSelectImageCell();
            PdfPCell SelectCell = PdfHelper.GetYesSelectImageCell();
            #endregion

            if (!string.IsNullOrEmpty(key) && value.ToUpper().Equals(key.ToUpper()))
            {
                //选中
                return SelectCell;
            }
            else
            {
                //未选中
                return noSelectCell;
            }
        }

        private PdfPCell AddCheckBox(bool? check)
        {
            #region Public Element
            PdfPCell noSelectCell = PdfHelper.GetNoSelectImageCell();
            PdfPCell SelectCell = PdfHelper.GetYesSelectImageCell();
            #endregion

            if (check != null)
            {
                if (check.Value)
                {
                    //选中
                    return SelectCell;
                }
                else
                {
                    //未选中
                    return noSelectCell;
                }
            }
            else
            {
                //未选中
                return noSelectCell;
            }
        }

        private void AddHeadTable(Document doc, int number, string headText, string subHeadText)
        {
            PdfPTable headTable = new PdfPTable(2);
            headTable.SetWidths(new float[] { 5f, 95f });
            PdfHelper.InitPdfTableProperty(headTable);

            Chunk numberChunk = new Chunk(number.ToString() + ".     ", PdfHelper.italicFontBasc);
            Chunk headChunk = new Chunk(headText, PdfHelper.italicFontBasc);

            Phrase headPhrase = new Phrase();
            headPhrase.Add(headChunk);

            if (!string.IsNullOrEmpty(subHeadText))
            {
                Chunk subHeadChunk = new Chunk("\r\n" + subHeadText, PdfHelper.youngDescFontBasc);
                headPhrase.Add(subHeadChunk);
            }

            Phrase nbrPhrase = new Phrase();
            nbrPhrase.Add(numberChunk);

            Paragraph headParagraph = new Paragraph();
            headParagraph.Add(headPhrase);

            Paragraph nbrParagraph = new Paragraph();
            nbrParagraph.Add(nbrPhrase);

            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(nbrParagraph) { BackgroundColor = PdfHelper.remarkBgColor }
                        , headTable, Rectangle.ALIGN_LEFT, null, true, false, false, true);
            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(headParagraph) { BackgroundColor = PdfHelper.remarkBgColor }
                        , headTable, Rectangle.ALIGN_LEFT, null, true, true, false, false);

            doc.Add(headTable);
        }

        private string GetChooseString(string radioValue)
        {
            string reslutStr = string.Empty;

            switch (radioValue)
            {
                case "0": reslutStr = "No"; break;
                case "1": reslutStr = "Yes"; break;
                case "2": reslutStr = "N/A"; break;
                default: break;
            }

            return reslutStr;
        }

        private string GetStringByDataRow(DataSet ds, int rowNumber, string column)
        {
            string resultStr = string.Empty;
            if (ds.Tables != null && ds.Tables.Count > 0)
            {
                if (rowNumber <= ds.Tables[0].Rows.Count)
                {
                    if (ds.Tables[0].Rows[rowNumber - 1][column] != null)
                    {
                        resultStr = ds.Tables[0].Rows[rowNumber - 1][column].ToString();
                    }
                }
                else
                {
                    resultStr = "N/A";
                }
            }

            return resultStr;
        }

        private string GetDataStringByString(string dateStr, string format)
        {
            DateTime dt;
            if (DateTime.TryParse(dateStr, out dt))
            {
                if (string.IsNullOrEmpty(format))
                    format = "yyyy-MM-dd";

                return dt.ToString(format);
            }
            else
            {
                return string.Empty;
            }

        }

        protected void DownloadFileForDCMS(string filename, string downname, string documentName)
        {
            string savename = downname;

            try
            {
                filename = AppDomain.CurrentDomain.BaseDirectory.ToString() + "Upload\\UploadFile\\" + documentName + "\\" + filename;

                Response.Clear();
                Response.Buffer = true;

                //以字符流的形式下载文件 
                System.IO.FileStream fs = new System.IO.FileStream(filename, System.IO.FileMode.Open);
                byte[] bytes = new byte[(int)fs.Length];
                fs.Read(bytes, 0, bytes.Length);
                fs.Close();
                Response.ContentType = "application/octet-stream";
                //通知浏览器下载文件而不是打开 
                Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(savename, System.Text.Encoding.UTF8));
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {

            }

        }
        #endregion
    }
}
