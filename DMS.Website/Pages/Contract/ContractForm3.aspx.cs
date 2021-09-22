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
using DMS.Business.Contract;

    public partial class ContractForm3 : BasePage
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
        private IContractAppointmentService _appointment = new ContractAppointmentService();
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
        //商业推介
        protected void Store_RefreshBusRefer(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable table = new Hashtable();
            table.Add("CmId", this.hdCmId.Value);
            DataSet ds = contractMasterBLL.QueryBusinessReferencesList(table);

            this.BusReferStore.DataSource = ds;
            this.BusReferStore.DataBind();
            this.hdParamBus.Value = ds.Tables[0].Rows.Count;
        }

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

        //公司拥有的全部实体的背景信息
        protected void Store_RefreshCorporateEntity(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable table = new Hashtable();
            table.Add("CmId", this.hdCmId.Value);
            DataSet ds = contractMasterBLL.QueryCorporateEntityList(table);

            this.CorporateEntityStore.DataSource = ds;
            this.CorporateEntityStore.DataBind();
        }

        //公职
        protected void Store_RefreshPublicOffice(object sender, StoreRefreshDataEventArgs e)
        {
            Hashtable table = new Hashtable();
            table.Add("CmId", this.hdCmId.Value);
            DataSet ds = contractMasterBLL.QueryPublicOfficeList(table);

            this.PublicOfficeStore.DataSource = ds;
            this.PublicOfficeStore.DataBind();
        }
        #endregion

        #region AjaxMethod

        #region 商业推介
        [AjaxMethod]
        public void ShowBusReferWindow()
        {
            //Init vlaue within this window control
            InitBusReferWindow(true);

            //Show Window
            this.windowBusRefer.Show();
        }

        [AjaxMethod]
        public string SaveBusRefer()
        {
            string massage = "";
            if (String.IsNullOrEmpty(this.tfWinBusReferName.Text))
            {
                massage += "请填写名称<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinBusReferAddress.Text) && regChinese.IsMatch(this.tfWinBusReferAddress.Text))
            {
                massage += "请填写英文地址<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinBusReferCountry.Text) && regChinese.IsMatch(this.tfWinBusReferCountry.Text))
            {
                massage += "请填写英文国家<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinBusReferContactPerson.Text) && regChinese.IsMatch(this.tfWinBusReferContactPerson.Text))
            {
                massage += "请填写联系人英文名称<br/>";
            }

            if (massage == "")
            {
                BusinessReferences busRefer = new BusinessReferences();

                //Create
                if (string.IsNullOrEmpty(this.hiddenWinBusReferDetailId.Text))
                {
                    busRefer.Id = Guid.NewGuid();
                    busRefer.CmId = new Guid(this.hdCmId.Value.ToString());
                    busRefer.Name = this.tfWinBusReferName.Text;
                    busRefer.Address = this.tfWinBusReferAddress.Text;
                    busRefer.Country = this.tfWinBusReferCountry.Text;
                    busRefer.ContactPerson = this.tfWinBusReferContactPerson.Text;
                    busRefer.Telephone = this.tfWinBusReferTelephone.Text;

                    busRefer.UpdateUser = null;
                    busRefer.UpdateDate = null;
                    busRefer.CreateUser = new Guid(_context.User.Id);
                    busRefer.CreateDate = DateTime.Now;

                    contractMasterBLL.SaveBusinessReferences(busRefer);
                    MaintainRenewalMark();
                }
                //Edit
                else
                {
                    busRefer.Id = new Guid(this.hiddenWinBusReferDetailId.Text);

                    busRefer.Name = this.tfWinBusReferName.Text;
                    busRefer.Address = this.tfWinBusReferAddress.Text;
                    busRefer.Country = this.tfWinBusReferCountry.Text;
                    busRefer.ContactPerson = this.tfWinBusReferContactPerson.Text;
                    busRefer.Telephone = this.tfWinBusReferTelephone.Text;

                    busRefer.UpdateUser = new Guid(_context.User.Id);
                    busRefer.UpdateDate = DateTime.Now;

                    contractMasterBLL.UpdateBusinessReferences(busRefer);
                    MaintainRenewalMark();
                }
                windowBusRefer.Hide();
                gpBusRefer.Reload();
            }
            else
            {
                massage = massage.Substring(0, massage.Length - 5);
            }
            return massage;
        }

        [AjaxMethod]
        public void DeleteBusReferItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                contractMasterBLL.DeleteBusinessReferences(new Guid(detailId));
                MaintainRenewalMark();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void EditBusReferItem(string detailId)
        {
            //Init vlaue within this window control
            InitBusReferWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadBusReferWindow(new Guid(detailId));

                //Set Value
                this.hiddenWinBusReferDetailId.Text = detailId;

                //Show Window
                this.windowBusRefer.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }
        #endregion

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
        public string SaveMedicalDevices()
        {
            string massage = "";
            if (!String.IsNullOrEmpty(this.tfWinMedicalDevicesName.Text) && regChinese.IsMatch(this.tfWinMedicalDevicesName.Text))
            {
                massage += "请使用英文填写名称<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinMedicalDevicesDescribe.Text) && regChinese.IsMatch(this.tfWinMedicalDevicesDescribe.Text))
            {
                massage += "请使用英文填写业务描述<br/>";
            }

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
                massage = massage.Substring(0, massage.Length - 5);
            }
            return massage;
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
        public string SaveBusLicense()
        {
            string massage = "";
            if (String.IsNullOrEmpty(this.tfWinBusLicenseCountry.Text))
            {
                massage += "请填写国家名称<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinBusLicenseCountry.Text) && regChinese.IsMatch(this.tfWinBusLicenseCountry.Text))
            {
                massage += "请使用英文填写国家名称<br/>";
            }
            if (String.IsNullOrEmpty(this.cbWinBusLicenseName.SelectedItem.Value))
            {
                massage += "请选择证照名称<br/>";
            }
            //if (!String.IsNullOrEmpty(this.tfWinBusLicenseName.Text) && regChinese.IsMatch(this.tfWinBusLicenseName.Text))
            //{
            //    massage += "请使用英文填写证照名称<br/>";
            //}
            if (!String.IsNullOrEmpty(this.tfWinBusLicenseAuthOrg.Text) && regChinese.IsMatch(this.tfWinBusLicenseAuthOrg.Text))
            {
                massage += "请使用英文填写授权单位<br/>";
            }
            if (String.IsNullOrEmpty(this.tfWinBusLicenseRegisterNumber.Text))
            {
                massage += "请填写证照编号<br/>";
            }

            if (massage.Equals(""))
            {
                BusinessLicense businessLicense = new BusinessLicense();
                //Create
                if (string.IsNullOrEmpty(this.hiddenWinBusLicenseDetailId.Text))
                {
                    businessLicense.Id = Guid.NewGuid();
                    businessLicense.CmId = new Guid(this.hdCmId.Value.ToString());

                    businessLicense.Country = this.tfWinBusLicenseCountry.Text;
                    businessLicense.Name = this.cbWinBusLicenseName.SelectedItem.Value;
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
                    businessLicense.Name = this.cbWinBusLicenseName.SelectedItem.Value;
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
                massage = massage.Substring(0, massage.Length - 5);
            }
            return massage;
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
        public string SaveSeniorCompany()
        {
            string massage="";
            if (String.IsNullOrEmpty(this.tfWinSeniorCompanyName.Text)) 
            {
                massage += "请填写公司负责人全名<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinSeniorCompanyName.Text) && regChinese.IsMatch(this.tfWinSeniorCompanyName.Text))
            {
                massage += "请使用英文填写全名<br/>";
            }
            if (String.IsNullOrEmpty(this.tfWinSeniorCompanyPosition.Text))
            {
                massage += "请填写职位名称<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinSeniorCompanyPosition.Text) && regChinese.IsMatch(this.tfWinSeniorCompanyPosition.Text))
            {
                massage += "请使用英文填写职位名称<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinSeniorCompanyBusinessAddress.Text) && regChinese.IsMatch(this.tfWinSeniorCompanyBusinessAddress.Text))
            {
                massage += "请使用英文填写办公地址<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinSeniorCompanyHomeAddress.Text) && regChinese.IsMatch(this.tfWinSeniorCompanyHomeAddress.Text))
            {
                massage += "请使用英文填写居住地<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinSeniorCompanyBirthplace.Text) && regChinese.IsMatch(this.tfWinSeniorCompanyBirthplace.Text))
            {
                massage += "请使用英文填写出生地点<br/>";
            }

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
                massage = massage.Substring(0, massage.Length - 5);
            }
            return massage;
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
        public string SaveCompanyStockholder()
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
            if (!String.IsNullOrEmpty(this.tfWinCompanyStockholderName.Text) && regChinese.IsMatch(this.tfWinCompanyStockholderName.Text))
            {
                massage += "请使用英文填写名称<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinCompanyStockholderBusinessAddress.Text) && regChinese.IsMatch(this.tfWinCompanyStockholderBusinessAddress.Text))
            {
                massage += "请使用英文填写办公地址<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinCompanyStockholderHomeAddress.Text) && regChinese.IsMatch(this.tfWinCompanyStockholderHomeAddress.Text))
            {
                massage += "请使用英文填写居住地址<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinCompanyStockholderBirthplace.Text) && regChinese.IsMatch(this.tfWinCompanyStockholderBirthplace.Text))
            {
                massage += "请使用英文填写出生地点<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinCompanyStockholderCountry.Text) && regChinese.IsMatch(this.tfWinCompanyStockholderCountry.Text))
            {
                massage += "请使用英文填写成立国家<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinCompanyStockholderRegister.Text) && regChinese.IsMatch(this.tfWinCompanyStockholderRegister.Text))
            {
                massage += "请使用英文填写登记号<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinCompanyStockholderPossessor.Text) && regChinese.IsMatch(this.tfWinCompanyStockholderPossessor.Text))
            {
                massage += "请使用英文填写拥有人名称<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinCompanyStockholderMiddleEntity.Text) && regChinese.IsMatch(this.tfWinCompanyStockholderMiddleEntity.Text))
            {
                massage += "请使用英文填写中间实体名称<br/>";
            }
             
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
                massage = massage.Substring(0, massage.Length - 5);
            }
            return massage;
            
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

        #region 公司拥有的全部实体的背景信息
        [AjaxMethod]
        public void ShowCorporateEntityWindow()
        {
            //Init vlaue within this window control
            InitCorporateEntityWindow(true);

            //Show Window
            this.windowCorporateEntity.Show();
        }

        [AjaxMethod]
        public string SaveCorporateEntity()
        {
            string massage = "";
            if (!String.IsNullOrEmpty(this.tfWinCorporateEntityName.Text) && regChinese.IsMatch(this.tfWinCorporateEntityName.Text))
            {
                massage += "请使用英文填写姓名<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinCorporateEntityCountry.Text) && regChinese.IsMatch(this.tfWinCorporateEntityCountry.Text))
            {
                massage += "请使用英文填写国家<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinCorporateEntityRegister.Text) && regChinese.IsMatch(this.tfWinCorporateEntityRegister.Text))
            {
                massage += "请使用英文填写登记号<br/>";
            }

            if (massage == "")
            {
                CorporateEntity corporateEntity = new CorporateEntity();
                //Create
                if (string.IsNullOrEmpty(this.hiddenWinCorporateEntityDetailId.Text))
                {
                    corporateEntity.Id = Guid.NewGuid();
                    corporateEntity.CmId = new Guid(this.hdCmId.Value.ToString());

                    corporateEntity.Name = this.tfWinCorporateEntityName.Text;
                    corporateEntity.Owership = Convert.ToInt32(this.tfWinCorporateEntityOwership.Text);
                    corporateEntity.Country = this.tfWinCorporateEntityCountry.Text;
                    corporateEntity.Register = this.tfWinCorporateEntityRegister.Text;

                    corporateEntity.UpdateUser = null;
                    corporateEntity.UpdateDate = null;
                    corporateEntity.CreateUser = new Guid(_context.User.Id);
                    corporateEntity.CreateDate = DateTime.Now;

                    contractMasterBLL.SaveCorporateEntity(corporateEntity);
                    MaintainRenewalMark();
                }
                //Edit
                else
                {
                    corporateEntity.Id = new Guid(this.hiddenWinCorporateEntityDetailId.Text);

                    corporateEntity.Name = this.tfWinCorporateEntityName.Text;
                    corporateEntity.Owership = Convert.ToInt32(this.tfWinCorporateEntityOwership.Text);
                    corporateEntity.Country = this.tfWinCorporateEntityCountry.Text;
                    corporateEntity.Register = this.tfWinCorporateEntityRegister.Text;

                    corporateEntity.UpdateUser = new Guid(_context.User.Id);
                    corporateEntity.UpdateDate = DateTime.Now;

                    contractMasterBLL.UpdateCorporateEntity(corporateEntity);
                    MaintainRenewalMark();
                }
                windowCorporateEntity.Hide();
                gpCorporateEntity.Reload();
            }
            else
            {
                massage = massage.Substring(0, massage.Length - 5);
            }
            return massage;
        }

        [AjaxMethod]
        public void DeleteCorporateEntityItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                contractMasterBLL.DeleteCorporateEntity(new Guid(detailId));
                MaintainRenewalMark();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void EditCorporateEntityItem(string detailId)
        {
            //Init vlaue within this window control
            InitCorporateEntityWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadCorporateEntityWindow(new Guid(detailId));

                //Set Value
                this.hiddenWinCorporateEntityDetailId.Text = detailId;

                //Show Window
                this.windowCorporateEntity.Show();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }
        #endregion

        #region 公职
        [AjaxMethod]
        public void ShowPublicOfficeWindow()
        {
            //Init vlaue within this window control
            InitPublicOfficeWindow(true);

            //Show Window
            this.windowPublicOffice.Show();
        }

        [AjaxMethod]
        public string SavePublicOffice()
        {
            string massage = "";
            if (!String.IsNullOrEmpty(this.tfWinPublicOfficeName.Text) && regChinese.IsMatch(this.tfWinPublicOfficeName.Text))
            {
                massage += "请使用英文填写名称<br/>";
            }
            if (!String.IsNullOrEmpty(this.tfWinPublicOfficeRelation.Text) && regChinese.IsMatch(this.tfWinPublicOfficeRelation.Text))
            {
                massage += "请使用英文填写政府隶属关系<br/>";
            }

            if (massage == "")
            {
                PublicOffice publicOffice = new PublicOffice();
                //Create
                if (string.IsNullOrEmpty(this.hiddenWinPublicOfficeDetailId.Text))
                {
                    publicOffice.Id = Guid.NewGuid();
                    publicOffice.CmId = new Guid(this.hdCmId.Value.ToString());

                    publicOffice.Name = this.tfWinPublicOfficeName.Text;
                    publicOffice.Relation = this.tfWinPublicOfficeRelation.Text;

                    publicOffice.UpdateUser = null;
                    publicOffice.UpdateDate = null;
                    publicOffice.CreateUser = new Guid(_context.User.Id);
                    publicOffice.CreateDate = DateTime.Now;

                    contractMasterBLL.SavePublicOffice(publicOffice);
                    MaintainRenewalMark();
                }
                //Edit
                else
                {
                    publicOffice.Id = new Guid(this.hiddenWinPublicOfficeDetailId.Text);

                    publicOffice.Name = this.tfWinPublicOfficeName.Text;
                    publicOffice.Relation = this.tfWinPublicOfficeRelation.Text;

                    publicOffice.UpdateUser = new Guid(_context.User.Id);
                    publicOffice.UpdateDate = DateTime.Now;

                    contractMasterBLL.UpdatePublicOffice(publicOffice);
                    MaintainRenewalMark();
                }
                windowPublicOffice.Hide();
                gpPublicOffice.Reload();
            }
            else
            {
                massage = massage.Substring(0, massage.Length - 5);
            }
            return massage;
        }

        [AjaxMethod]
        public void DeletePublicOfficeItem(string detailId)
        {
            if (!string.IsNullOrEmpty(detailId))
            {
                contractMasterBLL.DeletePublicOffice(new Guid(detailId));
                MaintainRenewalMark();
            }
            else
            {
                Ext.Msg.Alert("Message", "请重新选择！").Show();
            }
        }

        [AjaxMethod]
        public void EditPublicOfficeItem(string detailId)
        {
            //Init vlaue within this window control
            InitPublicOfficeWindow(true);

            if (!string.IsNullOrEmpty(detailId))
            {
                LoadPublicOfficeWindow(new Guid(detailId));

                //Set Value
                this.hiddenWinPublicOfficeDetailId.Text = detailId;

                //Show Window
                this.windowPublicOffice.Show();
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
                string massage="";
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
                DealeriafSign dtSign= contractMasterBLL.GetDealerIAFSign(sign.CmId);
                if (dtSign == null)
                {
                    contractMasterBLL.SaveDealerIAFSign(sign);
                }
                else 
                {
                    contractMasterBLL.UpdateDealerIAFSignFrom3(sign);
                }

              
                    Hashtable htCon = new Hashtable();
                    htCon.Add("CapId", this.hdContId.Value);
                    htCon.Add("CapCmId", this.hdCmId.Value );
                    _appointment.UpdateAppointmentCmidByConid(htCon);
                
                    htCon.Add("CreId", this.hdContId.Value);
                    htCon.Add("CreCmId", this.hdCmId.Value );
                    _Renewal.UpdateRenewalCmidByConid(htCon);

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
                    this.btnAddBusRefer.Enabled = false;
                    this.btnAddMedicalDevices.Enabled = false;
                    this.btnAddBusLicense.Enabled = false;
                    this.btnAddSeniorCompany.Enabled = false;
                    this.btnAddCompanyStockholder.Enabled = false;
                    this.btnAddCorporateEntity.Enabled = false;
                    this.btnAddPublicOffice.Enabled = false;


                    this.gpBusRefer.ColumnModel.Columns[5].Hidden = true;
                    this.gpMedicalDevices.ColumnModel.Columns[2].Hidden = true;
                    this.gpBusLicense.ColumnModel.Columns[5].Hidden = true;
                    this.gpSeniorCompany.ColumnModel.Columns[11].Hidden = true;
                    this.gpCompanyStockholder.ColumnModel.Columns[15].Hidden = true;
                    this.gpCorporateEntity.ColumnModel.Columns[4].Hidden = true;
                    this.gpPublicOffice.ColumnModel.Columns[2].Hidden = true;
                }
            }
            else 
            {
                //非经销商登录不可修改页面数据
                if (!IsDealer) 
                {
                    this.btnAddBusRefer.Enabled = false;
                    this.btnAddMedicalDevices.Enabled = false;
                    this.btnAddBusLicense.Enabled = false;
                    this.btnAddSeniorCompany.Enabled = false;
                    this.btnAddCompanyStockholder.Enabled = false;
                    this.btnAddCorporateEntity.Enabled = false;
                    this.btnAddPublicOffice.Enabled = false;

                    this.gpBusRefer.ColumnModel.Columns[5].Hidden = true;
                    this.gpMedicalDevices.ColumnModel.Columns[2].Hidden = true;
                    this.gpBusLicense.ColumnModel.Columns[5].Hidden = true;
                    this.gpSeniorCompany.ColumnModel.Columns[11].Hidden = true;
                    this.gpCompanyStockholder.ColumnModel.Columns[15].Hidden = true;
                    this.gpCorporateEntity.ColumnModel.Columns[4].Hidden = true;
                    this.gpPublicOffice.ColumnModel.Columns[2].Hidden = true;

                    this.btnSaveDraft.Hidden = true;
                }
            }
        }

        private bool PageCheck(ref string massage) 
        {
            if (this.tfDealerNameCn.Text.Equals(""))
            {
                massage += "请填写公司名称<br/>";
            }
            //else if (regChinese.IsMatch(this.tfDealerNameCn.Text)) 
            //{
            //    massage = "请填写英文公司名称<br/>";
            //}
            if (this.tfCharter.Text.Equals(""))
            {
                massage += "请填写营业执照注册证号码<br/>";
            }
            if (this.tfAddress.Text.Equals("")) 
            {
                massage += "请填写公司地址<br/>";
            }
            if (!this.tfAddress.Text.Equals("")&&regChinese.IsMatch(this.tfAddress.Text)) 
            {
                massage += "请填写英文地址<br/>";
            }
            if (this.tfTelephony.Text.Equals("")) 
            {
                massage += "请填写联系电话<br/>";
            }
            if (this.tfFax.Text.Equals(""))
            {
                massage += "请填写传真号码<br/>";
            }
            if (this.tfContactPerson.Text.Equals("")||(!this.tfContactPerson.Text.Equals("") && regChinese.IsMatch(this.tfContactPerson.Text)))
            {
                massage += "请填写主要联系人英文名称<br/>";
            }
            if (this.tfCountry.Text.Equals("")||(!this.tfCountry.Text.Equals("") && regChinese.IsMatch(this.tfCountry.Text)))
            {
                massage += "请填写英文国家名称，例如：China<br/>";
            }
            if (this.tfWebsite.Text.Equals(""))
            {
                massage += "请填写公司网站，如无，请填写N/A<br/>";
            }
            if (tfContactEmail.Text.Equals("")) 
            {
                massage += "请填写主要联系人邮箱地址<br/>";
            }

            if (radioPubliclyTradedYes.Checked && (tfExchange.Text.Equals("") || regChinese.IsMatch(this.tfExchange.Text))) 
            {
                massage += "请填写证交所英文名称<br/>";
            }
            else if (radioPubliclyTradedNo.Checked && tfExchange.Text.Equals("")) 
            {
                massage += "请在证交所名称栏填写N/A<br/>";
            }
            if (Convert.ToInt32(this.hdParamBus.Value.ToString()) <= 0)
            {
                massage += "请填写商业推介<br/>";
            }
            if (Convert.ToInt32(this.hdLicense.Value.ToString()) < 2)
            {
                massage += "请填写完整营业执照、经营许可证<br/>";
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
                if (tfSignUserName.Text.Equals("") || tfSignTital.Text.Equals("") || tfIdentity.Text.Equals("") ) 
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
        /// Init Control value and status of BusRefer Window
        /// </summary>
        /// <param name="canSubmit"></param>
        private void InitBusReferWindow(bool canSubmit)
        {
            this.tfWinBusReferName.Clear();
            this.tfWinBusReferAddress.Clear();
            this.tfWinBusReferCountry.Clear();
            this.tfWinBusReferContactPerson.Clear();
            this.tfWinBusReferTelephone.Clear();
            this.hiddenWinBusReferDetailId.Clear(); //Id

            if (canSubmit)
            {
                this.btnBusReferSubmit.Visible = true;

                this.tfWinBusReferName.ReadOnly = false;
                this.tfWinBusReferAddress.ReadOnly = false;
                this.tfWinBusReferCountry.ReadOnly = false;
                this.tfWinBusReferContactPerson.ReadOnly = false;
                this.tfWinBusReferTelephone.ReadOnly = false;
            }
            else
            {
                this.btnBusReferSubmit.Visible = false;

                this.tfWinBusReferName.ReadOnly = true;
                this.tfWinBusReferAddress.ReadOnly = true;
                this.tfWinBusReferCountry.ReadOnly = true;
                this.tfWinBusReferContactPerson.ReadOnly = true;
                this.tfWinBusReferTelephone.ReadOnly = true;
            }
        }

        private void LoadBusReferWindow(Guid detailId)
        {
            BusinessReferences businessReferences  = contractMasterBLL.GetBusinessReferencesById(detailId);

            this.tfWinBusReferName.Text = businessReferences.Name;
            this.tfWinBusReferAddress.Text = businessReferences.Address;
            this.tfWinBusReferCountry.Text = businessReferences.Country;
            this.tfWinBusReferContactPerson.Text = businessReferences.ContactPerson;
            this.tfWinBusReferTelephone.Text = businessReferences.Telephone;
        }

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
            this.tfWinBusLicenseCountry.Text = "China";
            this.cbWinBusLicenseName.SelectedItem.Value="";
            this.tfWinBusLicenseAuthOrg.Clear();
            this.tfWinBusLicenseRegisterDate.Clear();
            this.tfWinBusLicenseRegisterNumber.Clear();
            this.hiddenWinBusLicenseDetailId.Clear();   //Id

            if (canSubmit)
            {
                this.btnBusLicenseSubmit.Visible = true;

                this.tfWinBusLicenseCountry.ReadOnly = false;
                this.cbWinBusLicenseName.ReadOnly = false;
                this.tfWinBusLicenseAuthOrg.ReadOnly = false;
                this.tfWinBusLicenseRegisterDate.ReadOnly = false;
                this.tfWinBusLicenseRegisterNumber.ReadOnly = false;
            }
            else
            {
                this.btnBusLicenseSubmit.Visible = false;

                this.tfWinBusLicenseCountry.ReadOnly = true;
                this.cbWinBusLicenseName.ReadOnly = true;
                this.tfWinBusLicenseAuthOrg.ReadOnly = true;
                this.tfWinBusLicenseRegisterDate.ReadOnly = true;
                this.tfWinBusLicenseRegisterNumber.ReadOnly = true;
            }
        }

        private void LoadBusLicenseWindow(Guid detailId)
        {
            BusinessLicense businessLicense = contractMasterBLL.GetBusinessLicenseById(detailId);

            this.tfWinBusLicenseCountry.Text = businessLicense.Country;
            this.cbWinBusLicenseName.SelectedItem.Value = businessLicense.Name;
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
            this.tfWinSeniorCompanyBusinessAddress.Text = "N/A";
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

        /// <summary>
        /// Init Control value and status of CorporateEntity Window
        /// </summary>
        private void InitCorporateEntityWindow(bool canSubmit)
        {
            this.tfWinCorporateEntityName.Clear();
            this.tfWinCorporateEntityOwership.Clear();
            this.tfWinCorporateEntityCountry.Clear();
            this.tfWinCorporateEntityRegister.Clear();
            this.hiddenWinCorporateEntityDetailId.Clear();  //Id

            if (canSubmit)
            {
                this.btnCorporateEntitySubmit.Visible = true;

                this.tfWinCorporateEntityName.ReadOnly = false;
                this.tfWinCorporateEntityOwership.ReadOnly = false;
                this.tfWinCorporateEntityCountry.ReadOnly = false;
                this.tfWinCorporateEntityRegister.ReadOnly = false;
            }
            else
            {
                this.btnCorporateEntitySubmit.Visible = false;

                this.tfWinCorporateEntityName.ReadOnly = true;
                this.tfWinCorporateEntityOwership.ReadOnly = true;
                this.tfWinCorporateEntityCountry.ReadOnly = true;
                this.tfWinCorporateEntityRegister.ReadOnly = true;
            }
        }

        private void LoadCorporateEntityWindow(Guid detailId)
        {
            CorporateEntity corporateEntity = contractMasterBLL.GetCorporateEntityById(detailId);

            this.tfWinCorporateEntityName.Text = corporateEntity.Name;
            this.tfWinCorporateEntityOwership.Text = corporateEntity.Owership.HasValue ? corporateEntity.Owership.Value.ToString() : string.Empty;
            this.tfWinCorporateEntityCountry.Text = corporateEntity.Country;
            this.tfWinCorporateEntityRegister.Text = corporateEntity.Register;
        }

        /// <summary>
        /// Init Control value and status of PublicOffice Window
        /// </summary>
        private void InitPublicOfficeWindow(bool canSubmit)
        {
            this.tfWinPublicOfficeName.Clear();
            this.tfWinPublicOfficeRelation.Clear();
            this.hiddenWinPublicOfficeDetailId.Clear(); //Id

            if (canSubmit)
            {
                this.btnCorporateEntitySubmit.Visible = true;

                this.tfWinPublicOfficeName.ReadOnly = false;
                this.tfWinPublicOfficeRelation.ReadOnly = false;
            }
            else
            {
                this.btnCorporateEntitySubmit.Visible = false;

                this.tfWinPublicOfficeName.ReadOnly = true;
                this.tfWinPublicOfficeRelation.ReadOnly = true;
            }
        }

        private void LoadPublicOfficeWindow(Guid detailId)
        {
            PublicOffice publicOffice = contractMasterBLL.GetPublicOfficeById(detailId);

            this.tfWinPublicOfficeName.Text = publicOffice.Name;
            this.tfWinPublicOfficeRelation.Text = publicOffice.Relation;
        }
        #endregion

        #region Create IAF_Form_3 File

        protected void CreatePdf(object sender, EventArgs e)
        {
            bool checkPDFRenwal = true;
           
            Hashtable table = new Hashtable();
            table.Add("CmId", this.hdCmId.Value);
            conMast = _contract.GetContractMasterByCmID(table);

            if (this.hdParmetType.Value != null && this.hdParmetType.Value.ToString().Equals(ContractType.Renewal.ToString())) 
            {
                ContractRenewal cr = _Renewal.GetContractRenewalByID(new Guid(this.hdContId.Value.ToString()));
                if (cr != null && cr.CreFromIsUpdate != null)
                {
                    checkPDFRenwal = cr.CreFromIsUpdate.Value;
                }
                else 
                {
                    checkPDFRenwal = false;
                }
            }

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
                                            , "044902 Form 3 Third Party Disclosure Form Rev. D"
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

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("1.	     Company Information", PdfHelper.italicFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, Colspan = 2, BackgroundColor = PdfHelper.remarkBgColor }
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);

                //Company Name/Company ID#
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Company Name (referred to in this form as “Company”): ", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Company ID# / Charter #:", PdfHelper.youngFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(GetDealerName(conMast.CmDmaId) + "\r\n (" + conMast.CmDealerCnName + ")", PdfHelper.youngChineseFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmCharter, PdfHelper.iafAnswerFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Address/Country
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Address:", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Country:", PdfHelper.youngFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmAddress, PdfHelper.iafAnswerFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmCountry, PdfHelper.iafAnswerFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Tel/Fax
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Tel:", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Fax:", PdfHelper.youngFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmTelephony, PdfHelper.iafAnswerFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmFax, PdfHelper.iafAnswerFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                //Principal Contact/Website
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Principal Contact:", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Website:", PdfHelper.youngFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmContactPerson, PdfHelper.iafAnswerFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmWebsite, PdfHelper.iafAnswerFont))
                        , compayInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                PdfHelper.AddPdfTable(doc, compayInfoTable);

                PdfPTable compayTradedTable = new PdfPTable(6);
                compayTradedTable.SetWidths(new float[] { 50f, 5f, 7.5f, 5f, 7.5f, 25f });
                PdfHelper.InitPdfTableProperty(compayTradedTable);

                //Principal Contact E-mail/Website
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Principal Contact E-mail:", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Is the Company publicly traded?", PdfHelper.youngFont)) { Colspan = 4 }
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("If “yes,” on what exchange?", PdfHelper.youngFont))
                       , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);

                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmEmail, PdfHelper.iafAnswerFont))
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(conMast.CmPubliclyTraded)
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.iafAnswerFont))
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!conMast.CmPubliclyTraded)
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("No", PdfHelper.iafAnswerFont))
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
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(exchange, pdfFont.normalChineseFont))
                        , compayTradedTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                PdfHelper.AddPdfTable(doc, compayTradedTable);

                //Remarks
                PdfPTable cbTable = new PdfPTable(4);
                cbTable.SetWidths(new float[] { 5f, 30f, 35f, 30f });
                PdfHelper.InitPdfTableProperty(cbTable);

                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("For new Boston Scientific Third Parties, attach Company financial statements for the last two fiscal years.", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT, Colspan = 4 }
                        , cbTable, Rectangle.ALIGN_LEFT, null);
                PdfHelper.AddPdfCell(new PdfPCell(noSelectCell), cbTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);
                PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Check this box if you are a current Boston Scientific Third Party (Agent, Distributor or Dealer), your contract is being renewed, and none of the relevant information below (including principal owners, shareholders, directors, bank information, etc.) has changed since the previous Third Party Disclosure Form you completed.  In this case, certify that there have been no changes by signing below, and do not fill out the rest of this form.  If any of the relevant information has changed from the last submission, fill in only the information that has changed.", PdfHelper.youngFont)) { Colspan = 3 }
                        , cbTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, cbTable, null, null);

                PdfHelper.AddEmptyPdfCell(cbTable);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name: ", PdfHelper.youngFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                        , cbTable, Rectangle.ALIGN_LEFT, null, true, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Signature: ", PdfHelper.youngFont))
                        , cbTable, Rectangle.ALIGN_LEFT, null, true, false, false, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date: ", PdfHelper.youngFont))
                        , cbTable, Rectangle.ALIGN_LEFT, null, true, true, false, true);

                PdfHelper.AddEmptyPdfCell(cbTable);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { FixedHeight = PdfHelper.YOUNG_FIXED_HEIGHT }
                       , cbTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                        , cbTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                        , cbTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, cbTable, null, null);

                if (checkPDFRenwal)
                {
                    Chunk noteChunk = new Chunk("**IMPORTANT NOTE**: ", PdfHelper.noteFont);
                    Chunk descChunk = new Chunk("Sections 2 – 11 are ONLY for NEW Third Party contracts, or renewals where information has changed from a prior submission.  Please fill out ALL required sections completely.  Please write “N/A” or “None” in ALL sections not-applicable.", PdfHelper.italicFont);

                    Phrase notePhrase = new Phrase();
                    notePhrase.Add(noteChunk);
                    notePhrase.Add(descChunk);

                    Paragraph noteParagraph = new Paragraph();
                    noteParagraph.Add(notePhrase);

                    PdfHelper.AddPdfCell(new PdfPCell(noteParagraph) { Colspan = 4, BackgroundColor = PdfHelper.grayColor }, cbTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_TOP);

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, cbTable, null, null);
                }

                PdfHelper.AddPdfTable(doc, cbTable);

                #endregion


                if (checkPDFRenwal)
                {
                    #region 2.	Business References
                    Hashtable businessReferencesTable = new Hashtable();
                    businessReferencesTable.Add("CmId", this.hdCmId.Value);
                    DataSet businessReferencesDs = contractMasterBLL.QueryBusinessReferencesList(businessReferencesTable);

                    PdfPTable busReferTable = new PdfPTable(3);
                    busReferTable.SetWidths(new float[] { 20f, 40f, 40f });
                    PdfHelper.InitPdfTableProperty(busReferTable);

                    this.AddHeadTable(doc, 2, "Business References", "Please identify two business references with whom your Company works or has worked.");
            
                    //One
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Business Reference1", PdfHelper.iafAnswerFont)) { Rowspan = 6, BackgroundColor = PdfHelper.grayColor }
                            , busReferTable, null, Rectangle.ALIGN_MIDDLE, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name:", PdfHelper.youngFont)) { Colspan = 2 }
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, true, true, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, 1, "Name"), PdfHelper.youngChineseFont)) { Colspan = 2 }
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Address:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Country:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, 1, "Address"), PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, 1, "Country"), PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Contact Person:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Telephone:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, 1, "ContactPerson"), PdfHelper.youngChineseFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, 1, "Telephone"), PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    //Two
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Business Reference2", PdfHelper.iafAnswerFont)) { Rowspan = 6, BackgroundColor = PdfHelper.grayColor }
                            , busReferTable, null, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name:", PdfHelper.youngFont)) { Colspan = 2 }
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, 2, "Name"), PdfHelper.youngChineseFont)) { Colspan = 2 }
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Address:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Country:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, 2, "Address"), PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, 2, "Country"), PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Contact Person:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Telephone:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, 2, "ContactPerson"), PdfHelper.youngChineseFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, 2, "Telephone"), PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    for (int i = 2; i < businessReferencesDs.Tables[0].Rows.Count; i++)
                    {
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Business Reference" + (i + 1).ToString(), PdfHelper.iafAnswerFont)) { Rowspan = 6, BackgroundColor = PdfHelper.grayColor }
                            , busReferTable, null, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name:", PdfHelper.youngFont)) { Colspan = 2 }
                                , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, i + 1, "Name"), PdfHelper.youngChineseFont)) { Colspan = 2 }
                                , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Address:", PdfHelper.youngFont))
                                , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Country:", PdfHelper.youngFont))
                                , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, i + 1, "Address"), PdfHelper.iafAnswerFont))
                                , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, i + 1, "Country"), PdfHelper.iafAnswerFont))
                                , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Contact Person:", PdfHelper.youngFont))
                                , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Telephone:", PdfHelper.youngFont))
                                , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, i + 1, "ContactPerson"), PdfHelper.youngChineseFont))
                                , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessReferencesDs, i + 1, "Telephone"), PdfHelper.iafAnswerFont))
                                , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);
                    }

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, busReferTable, null, null);

                    PdfHelper.AddPdfTable(doc, busReferTable);
                    #endregion

                    #region 3. 	Medical Device or Pharmaceutical Companies
                    Hashtable pharmaceuticalTable = new Hashtable();
                    pharmaceuticalTable.Add("CmId", this.hdCmId.Value);
                    DataSet medicalDeviceDs = contractMasterBLL.QueryMedicalDevicesList(pharmaceuticalTable);

                    PdfPTable medicalDeviceTable = new PdfPTable(3);
                    medicalDeviceTable.SetWidths(new float[] { 20f, 40f, 40f });
                    PdfHelper.InitPdfTableProperty(medicalDeviceTable);

                    this.AddHeadTable(doc, 3, "Medical Device or Pharmaceutical Companies", "Please list names and descriptions of other medical device or pharmaceutical companies that you/your Company represents. If the answer is none, please state “None” in this Section.");


                    int medicalDeviceCount = medicalDeviceDs.Tables[0].Rows.Count > 2 ? medicalDeviceDs.Tables[0].Rows.Count * 2 : 4;
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Companies Represented", PdfHelper.iafAnswerFont)) { Rowspan = medicalDeviceCount, BackgroundColor = PdfHelper.grayColor }
                            , medicalDeviceTable, null, Rectangle.ALIGN_MIDDLE, true, false, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name:", PdfHelper.youngFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, true, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Description of Business:", PdfHelper.youngFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, true, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, 1, "Name"), PdfHelper.iafAnswerFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, 1, "Describe"), PdfHelper.iafAnswerFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name:", PdfHelper.youngFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Description of Business:", PdfHelper.youngFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, 2, "Name"), PdfHelper.iafAnswerFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, 2, "Describe"), PdfHelper.iafAnswerFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    for (int i = 2; i < medicalDeviceDs.Tables[0].Rows.Count; i++)
                    {
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name:", PdfHelper.youngFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Description of Business:", PdfHelper.youngFont))
                                , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, i + 1, "Name"), PdfHelper.iafAnswerFont))
                                , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(medicalDeviceDs, i + 1, "Describe"), PdfHelper.iafAnswerFont))
                                , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);
                    }

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, medicalDeviceTable, null, null);

                    PdfHelper.AddPdfTable(doc, medicalDeviceTable);
                    #endregion

                    #region 4.	Business Licenses, Permits or Registrations
                    Hashtable businesLicensestable = new Hashtable();
                    businesLicensestable.Add("CmId", this.hdCmId.Value);
                    DataSet businessLicensesDs = contractMasterBLL.QueryBusinessLicenseList(businesLicensestable);

                    PdfPTable lincensesTable = new PdfPTable(4);
                    lincensesTable.SetWidths(new float[] { 25f, 25f, 25f, 25f });
                    PdfHelper.InitPdfTableProperty(lincensesTable);

                    this.AddHeadTable(doc, 4, "Business Licenses, Permits or Registrations", "Please provide the following detail regarding any business licenses, permits or registrations held by your Company.");

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Country of issue", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , lincensesTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name of License, Permit or Registration", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , lincensesTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Licensing Authority", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , lincensesTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date of Registration and Registration Number", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , lincensesTable, null, null, true, true, true, true);

                    int businessLicensesCount = businessLicensesDs.Tables[0].Rows.Count > 2 ? businessLicensesDs.Tables[0].Rows.Count : 2;
                    for (int i = 1; i < businessLicensesCount + 1; i++)
                    {
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessLicensesDs, i, "Country"), PdfHelper.iafAnswerFont))
                                , lincensesTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessLicensesDs, i, "Name"), PdfHelper.iafAnswerFont))
                                , lincensesTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(businessLicensesDs, i, "AuthOrg"), PdfHelper.iafAnswerFont))
                                , lincensesTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetDataStringByString(this.GetStringByDataRow(businessLicensesDs, i, "RegisterDate"), null) + " " + this.GetStringByDataRow(businessLicensesDs, i, "RegisterNumber"), PdfHelper.iafAnswerFont))
                                , lincensesTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    }
                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, lincensesTable, null, null);

                    PdfHelper.AddPdfTable(doc, lincensesTable);
                    #endregion

                    #region 5. 	Background Information on Company Directors and Principal Officers
                    Hashtable companyDirectorsTable = new Hashtable();
                    companyDirectorsTable.Add("CmId", this.hdCmId.Value);
                    DataSet companyDirectorsDs = contractMasterBLL.QuerySeniorCompanyList(companyDirectorsTable);

                    PdfPTable bgInfoTable = new PdfPTable(4);
                    bgInfoTable.SetWidths(new float[] { 25f, 25f, 25f, 25f });
                    PdfHelper.InitPdfTableProperty(bgInfoTable);

                    this.AddHeadTable(doc, 5, "Background Information on Company Directors and Principal Officers", "Provide the following data for Directors and each principal officer (President, General Manager, Chief Financial Officer, etc.) of the Company.  If necessary, provide additional data on a separate sheet.");

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                            , bgInfoTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Director/Officer", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Director/Officer", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Director/Officer", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, null, null, true, true, true, true);

                    //Full Name
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Full Name (Family and Given):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Name"), PdfHelper.youngChineseFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Name"), PdfHelper.youngChineseFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Name"), PdfHelper.youngChineseFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Position / Title
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Position / Title:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Position"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Position"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Position"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Office Address(if different from Section 1):
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Office Address\r\n(if different from Section 1):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "BusinessAddress"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "BusinessAddress"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "BusinessAddress"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Telephone
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Telephone:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Telephone"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Telephone"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Telephone"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Fax
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Fax:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Fax"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Fax"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Fax"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Email
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Email:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Email"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Email"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Email"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Residential Address
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Residential Address:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "HomeAddress"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "HomeAddress"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "HomeAddress"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Passport #
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Passport #:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Pbumport"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Pbumport"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Pbumport"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //National Residential ID#:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("National Residential ID#:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "IdentityCard"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "IdentityCard"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "IdentityCard"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Date of Birth: 
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date of Birth: ", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Birthday").Equals("") ?"":this.GetStringByDataRow(companyDirectorsDs, 1, "Birthday").Equals("N/A") ? "N/A" :Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, 1, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Birthday").Equals("") ?"":this.GetStringByDataRow(companyDirectorsDs, 2, "Birthday").Equals("N/A") ? "N/A" : Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, 2, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Birthday").Equals("")?"":this.GetStringByDataRow(companyDirectorsDs, 3, "Birthday").Equals("N/A") ? "N/A" : Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, 3, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Place of Birth:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Place of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 1, "Birthplace"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 2, "Birthplace"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, 3, "Birthplace"), PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    #region For 循环

                    int companyDirectorsCount = companyDirectorsDs.Tables[0].Rows.Count / 3 > 0 ? companyDirectorsDs.Tables[0].Rows.Count / 3 : 0;
                    for (int i = 0; i < companyDirectorsCount; i++)
                    {
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                            , bgInfoTable, null, null, true, false, true, false);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Director/Officer", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, null, null, true, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Director/Officer", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, null, null, true, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Director/Officer", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, null, null, true, true, true, true);

                        //Full Name
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Full Name (Family and Given):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Name"), PdfHelper.youngChineseFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Name"), PdfHelper.youngChineseFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Name"), PdfHelper.youngChineseFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Position / Title
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Position / Title:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Position"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Position"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Position"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Office Address(if different from Section 1):
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Office Address\r\n(if different from Section 1):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "BusinessAddress"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "BusinessAddress"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "BusinessAddress"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Telephone
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Telephone:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Telephone"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Telephone"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Telephone"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Fax
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Fax:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Fax"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Fax"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Fax"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Email
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Email:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Email"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Email"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Email"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Residential Address
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Residential Address:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "HomeAddress"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "HomeAddress"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "HomeAddress"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Passport #
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Passport #:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Pbumport"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Pbumport"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Pbumport"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //National Residential ID#:
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("National Residential ID#:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "IdentityCard"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "IdentityCard"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "IdentityCard"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Date of Birth: 
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date of Birth: ", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Birthday").Equals("")?"":this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Birthday").Equals("N/A") ? "N/A" : Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Birthday").Equals("") ?"":this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Birthday").Equals("N/A") ? "N/A" : Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Birthday").Equals("") ?"":this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Birthday").Equals("N/A") ? "N/A" : Convert.ToDateTime(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Place of Birth:
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Place of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 1, "Birthplace"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 2, "Birthplace"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyDirectorsDs, (i + 1) * 3 + 3, "Birthplace"), PdfHelper.iafAnswerFont))
                                , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    }
                    #endregion

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, bgInfoTable, null, null);

                    PdfHelper.AddPdfTable(doc, bgInfoTable);
                    #endregion

                    #region 6.	Background Information on Company Owners and Shareholders
                    Hashtable companyOwnersTable = new Hashtable();
                    companyOwnersTable.Add("CmId", this.hdCmId.Value);
                    DataSet companyOwnersDs = contractMasterBLL.QueryCompanyStockholderList(companyOwnersTable);

                    PdfPTable shareholdersTable = new PdfPTable(4);
                    shareholdersTable.SetWidths(new float[] { 25f, 25f, 25f, 25f });
                    PdfHelper.InitPdfTableProperty(shareholdersTable);

                    this.AddHeadTable(doc, 6, "Background Information on Company Owners and Shareholders ", "Please provide the following data for all owners and shareholders of the Company – Ownership % should add to 100%.  If the Company is publicly traded, it is only necessary to provide this data for owners and shareholders with Company ownership of 5% or greater.   Where an owner or shareholder is another company, please list that company as well as the ultimate beneficial owner(s) of that company (i.e. natural persons) and any intermediate entities.  If necessary, provide additional data on a separate sheet.");

                    #region User Info
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                            , shareholdersTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Shareholder", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Shareholder", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Shareholder", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, null, null, true, true, true, true);

                    //Full Name
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Full Name (Family and Given):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Name"), PdfHelper.youngChineseFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Name"), PdfHelper.youngChineseFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Name"), PdfHelper.youngChineseFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Relationship / % Ownership
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Relationship / % Ownership:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    string Ownership1= this.GetStringByDataRow(companyOwnersDs, 1, "Ownership");
                    string Ownership2 = this.GetStringByDataRow(companyOwnersDs, 2, "Ownership");
                    string Ownership3 = this.GetStringByDataRow(companyOwnersDs, 3, "Ownership");
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(Ownership1.Equals("N/A") ? "N/A" : Ownership1.Equals("") ? "" : (Ownership1+"%"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(Ownership2.Equals("N/A") ? "N/A" : Ownership2.Equals("") ? "" : (Ownership2 + "%"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(Ownership3.Equals("N/A") ? "N/A" : Ownership3.Equals("") ? "" : (Ownership3 + "%"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Office Address:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Office Address:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "BusinessAddress"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "BusinessAddress"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "BusinessAddress"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Telephone:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Telephone:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Telephone"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Telephone"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Telephone"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Fax:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Fax:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Fax"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Fax"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Fax"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Email:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Email:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Email"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Email"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Email"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                    #endregion

                    #region NATURAL PERSON

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("IF SHAREHOLDER IS A NATURAL PERSON:", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor, Colspan = 4, BorderWidth = 1f, BorderWidthBottom = 0f, BorderColor = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Residential Address:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "HomeAddress"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "HomeAddress"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "HomeAddress"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0.6f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Passport #", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Pbumport"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Pbumport"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Pbumport"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("National Residential ID#:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "IdentityCard"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "IdentityCard"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "IdentityCard"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Date of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Birthday").Equals("")?"":this.GetStringByDataRow(companyOwnersDs, 1, "Birthday").Equals("N/A") ? "N/A" :this.GetStringByDataRow(companyOwnersDs, 1, "Birthday").Equals("")?"": Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, 1, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Birthday").Equals("")?"":this.GetStringByDataRow(companyOwnersDs, 2, "Birthday").Equals("N/A") ? "N/A" :this.GetStringByDataRow(companyOwnersDs, 2, "Birthday").Equals("")?"": Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, 2, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Birthday").Equals("")? "" : this.GetStringByDataRow(companyOwnersDs, 3, "Birthday").Equals("N/A") ? "N/A" :this.GetStringByDataRow(companyOwnersDs, 3, "Birthday").Equals("")?"": Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, 3, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Place of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 0f, BorderWidthLeft = 1f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Birthplace"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Birthplace"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Birthplace"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthBottom = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    #endregion

                    #region COMPANY
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("IF SHAREHOLDER IS A COMPANY:", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor, Colspan = 4, BorderWidth = 1f, BorderWidthBottom = 0f, BorderColor = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Country of Incorporation
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Country of Incorporation:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Country"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Country"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Country"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0.6f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Registry #
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Registry #:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Register"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Register"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Register"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Ultimate Beneficial Owner
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Ultimate Beneficial Owner:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "Possessor"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "Possessor"), PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "Possessor"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Intermediate Entities
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Intermediate Entities:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 1f, BorderWidthLeft = 1f, BorderColorLeft = PdfHelper.blueColor, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 1, "MiddleEntity"), PdfHelper.iafAnswerFont)) { BorderWidth = 0f, BorderWidthLeft = 0.6f, BorderWidthBottom = 1f, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 2, "MiddleEntity"), PdfHelper.iafAnswerFont)) { BorderWidth = 0f, BorderWidthLeft = 0.6f, BorderWidthBottom = 1f, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, 3, "MiddleEntity"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    #endregion

                    #region For 循环
                    int companyOwnersCount = companyOwnersDs.Tables[0].Rows.Count / 3 > 0 ? companyOwnersDs.Tables[0].Rows.Count / 3 : 0;
                    for (int i = 0; i < companyOwnersCount; i++)
                    {
                        #region User Info
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                                , shareholdersTable, null, null, true, false, true, false);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Shareholder", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                                , shareholdersTable, null, null, true, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Shareholder", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                                , shareholdersTable, null, null, true, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Shareholder", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                                , shareholdersTable, null, null, true, true, true, true);

                        //Full Name
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Full Name (Family and Given):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Name"), PdfHelper.youngChineseFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Name"), PdfHelper.youngChineseFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Name"), PdfHelper.youngChineseFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Relationship / % Ownership
                        string Ownershipfor1 = this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Ownership");
                        string Ownershipfor2 = this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Ownership");
                        string Ownershipfor3 = this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Ownership");
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Relationship / % Ownership:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(Ownershipfor1.Equals("N/A") ? "N/A" : Ownershipfor1.Equals("") ? "" : (Ownershipfor1 + "%"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(Ownershipfor2.Equals("N/A") ? "N/A" : Ownershipfor2.Equals("") ? "" : (Ownershipfor2 + "%"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(Ownershipfor3.Equals("N/A") ? "N/A" : Ownershipfor3.Equals("") ? "" : (Ownershipfor3 + "%"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Office Address:
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Office Address:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "BusinessAddress"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "BusinessAddress"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "BusinessAddress"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Telephone:
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Telephone:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Telephone"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Telephone"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Telephone"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Fax:
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Fax:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Fax"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Fax"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Fax"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                        //Email:
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Email:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Email"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Email"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Email"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                        #endregion

                        #region NATURAL PERSON

                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("IF SHAREHOLDER IS A NATURAL PERSON:", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor, Colspan = 4, BorderWidth = 1f, BorderWidthBottom = 0f, BorderColor = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Residential Address:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "HomeAddress"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "HomeAddress"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "HomeAddress"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0.6f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Passport #", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Pbumport"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Pbumport"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Pbumport"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("National Residential ID#:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "IdentityCard"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "IdentityCard"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "IdentityCard"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Date of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Birthday").Equals("")?"": this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Birthday").Equals("N/A") ? "N/A" :this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Birthday").Equals("")?"": Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Birthday").Equals("")?"":this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Birthday").Equals("N/A") ? "N/A" :this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Birthday").Equals("") ?"": Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Birthday").Equals("")?"":this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Birthday").Equals("N/A") ? "N/A" : this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Birthday").Equals("")?"":Convert.ToDateTime(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Birthday")).ToShortDateString(), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Place of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 0f, BorderWidthLeft = 1f, BorderColorLeft = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Birthplace"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Birthplace"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Birthplace"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthBottom = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                        #endregion

                        #region COMPANY
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("IF SHAREHOLDER IS A COMPANY:", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor, Colspan = 4, BorderWidth = 1f, BorderWidthBottom = 0f, BorderColor = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                        //Country of Incorporation
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Country of Incorporation:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Country"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Country"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Country"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0.6f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                        //Registry #
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Registry #:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Register"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Register"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Register"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                        //Ultimate Beneficial Owner
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Ultimate Beneficial Owner:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "Possessor"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "Possessor"), PdfHelper.iafAnswerFont))
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "Possessor"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                        //Intermediate Entities
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Intermediate Entities:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 1f, BorderWidthLeft = 1f, BorderColorLeft = PdfHelper.blueColor, BorderColorBottom = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 1, "MiddleEntity"), PdfHelper.iafAnswerFont)) { BorderWidth = 0f, BorderWidthLeft = 0.6f, BorderWidthBottom = 1f, BorderColorBottom = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 2, "MiddleEntity"), PdfHelper.iafAnswerFont)) { BorderWidth = 0f, BorderWidthLeft = 0.6f, BorderWidthBottom = 1f, BorderColorBottom = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph(this.GetStringByDataRow(companyOwnersDs, (i + 1) * 3 + 3, "MiddleEntity"), PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, BorderColorBottom = PdfHelper.blueColor }
                                , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                        #endregion
                    }
                    #endregion

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, shareholdersTable, null, null);

                    PdfHelper.AddPdfTable(doc, shareholdersTable);
                    #endregion

                    #region 7.	Background Information on All Entities Owned by the Company
                    Hashtable entityOwnerTable = new Hashtable();
                    entityOwnerTable.Add("CmId", this.hdCmId.Value);
                    DataSet entityOwnerDs = contractMasterBLL.QueryCorporateEntityList(entityOwnerTable);

                    PdfPTable entityOwnedTable = new PdfPTable(5);
                    entityOwnedTable.SetWidths(new float[] { 25f, 30f, 15f, 15f, 15f });
                    PdfHelper.InitPdfTableProperty(entityOwnedTable);

                    this.AddHeadTable(doc, 7, "Background Information on All Entities Owned by the Company", "Please provide the following data on all entities in which the Company holds an ownership interest (e.g. subsidiaries and joint ventures), including Country of Incorporation and Registry #, if applicable, and information regarding all joint venture partners and other interest holders.  If necessary, provide additional data on a separate sheet.  If the answer is none, please state “None” in this Section.");

                    int entityOwnerCount = entityOwnerDs.Tables[0].Rows.Count > 1 ? entityOwnerDs.Tables[0].Rows.Count : 1;

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Subsidiaries or \r\nJoint Ventures", PdfHelper.iafAnswerFont)) { BackgroundColor = PdfHelper.grayColor, Rowspan = entityOwnerCount + 1 }
                            , entityOwnedTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , entityOwnedTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("% Ownership", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , entityOwnedTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Country", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , entityOwnedTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Reg #", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , entityOwnedTable, null, null, true, true, true, true);

                    for (int i = 1; i < entityOwnerCount + 1; i++)
                    {
                        //User One
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow2(entityOwnerDs, i, "Name"), PdfHelper.iafAnswerFont))
                                , entityOwnedTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow2(entityOwnerDs, i, "Owership").Equals("None") ? "None" : this.GetStringByDataRow2(entityOwnerDs, i, "Owership").Equals("") ? "" : this.GetStringByDataRow2(entityOwnerDs, i, "Owership")+"%", PdfHelper.iafAnswerFont))
                                , entityOwnedTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow2(entityOwnerDs, i, "Country"), PdfHelper.iafAnswerFont))
                                , entityOwnedTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow2(entityOwnerDs, i, "Register"), PdfHelper.iafAnswerFont))
                                , entityOwnedTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    }

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 5 }, entityOwnedTable, null, null);

                    PdfHelper.AddPdfTable(doc, entityOwnedTable);
                    #endregion

                    #region 8.	Public Office
                    Hashtable officeTable = new Hashtable();
                    officeTable.Add("CmId", this.hdCmId.Value);
                    DataSet officeDs = contractMasterBLL.QueryPublicOfficeList(officeTable);

                    PdfPTable publicOfficeTable = new PdfPTable(3);
                    publicOfficeTable.SetWidths(new float[] { 25f, 37.5f, 37.5f });
                    PdfHelper.InitPdfTableProperty(publicOfficeTable);

                    int officeCount = officeDs.Tables[0].Rows.Count > 1 ? officeDs.Tables[0].Rows.Count : 1;

                    this.AddHeadTable(doc, 8, "Public Office", "Please identify whether any of the individuals named in the Sections above (or their immediate family members or business partners) are current or former government officials or candidates for political office, hold or have held public office, are or were employed by or affiliated with government entities, including state-owned or controlled hospitals or clinics, state-owned or controlled companies or charities,  political parties and public international organizations (e.g. World Bank and United Nations).  If the answer is none, please state “None” in this Section.");

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Government Official:", PdfHelper.iafAnswerFont)) { BackgroundColor = PdfHelper.grayColor, Rowspan = officeCount + 1 }
                            , publicOfficeTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , publicOfficeTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Government Affiliation", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , publicOfficeTable, null, null, true, true, true, true);

                    for (int i = 1; i < officeCount + 1; i++)
                    {
                        //User One
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow2(officeDs, i, "Name"), PdfHelper.iafAnswerFont))
                                , publicOfficeTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(this.GetStringByDataRow2(officeDs, i, "Relation"), PdfHelper.iafAnswerFont))
                                , publicOfficeTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    }

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE * 2, Colspan = 3 }, publicOfficeTable, null, null);

                    PdfHelper.AddPdfTable(doc, publicOfficeTable);
                    #endregion

                    #region 9.	Additional Information
                    PdfPTable additionalTable = new PdfPTable(5);
                    additionalTable.SetWidths(new float[] { 60f, 5f, 5f, 5f, 25f });
                    PdfHelper.InitPdfTableProperty(additionalTable);

                    this.AddHeadTable(doc, 9, "Additional Information", null);

                    //1
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Has the Company or any of its principal officers, directors or shareholders been involved in a civil or criminal action during the past five years (excluding minor traffic infractions and domestic settlements)?", PdfHelper.youngFont)) { Rowspan = 3 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(conMast.CmProperty1)
                            , additionalTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!conMast.CmProperty1)
                            , additionalTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("No", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, true, true, true, false);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("If “yes,” provide details:", PdfHelper.youngFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmDesc1 + " ", PdfHelper.iafAnswerFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //2
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Has the Company or any of its principal officers, directors or shareholders been involved in any governmental/ regulatory body investigation or administrative action, or had sanctions imposed on it, within the past five years?", PdfHelper.youngFont)) { Rowspan = 3 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(conMast.CmProperty2)
                            , additionalTable, null, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!conMast.CmProperty2)
                            , additionalTable, null, null, false, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("No", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("If “yes,” provide details:", PdfHelper.youngFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmDesc2 + " ", PdfHelper.iafAnswerFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //3
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Has the Company or any of its principal officers, directors or shareholders filed or been involved in any action related to bankruptcy, insolvency, or reorganization within the past five years?", PdfHelper.youngFont)) { Rowspan = 3 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(conMast.CmProperty3)
                            , additionalTable, null, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!conMast.CmProperty3)
                            , additionalTable, null, null, false, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("No", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("If “yes,” provide details:", PdfHelper.youngFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmDesc3, PdfHelper.iafAnswerFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);


                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 5 }, additionalTable, null, null);

                    PdfHelper.AddPdfTable(doc, additionalTable);
                    #endregion

                    #region 10.	Release of Information
                    PdfPTable releaseTable = new PdfPTable(1);
                    PdfHelper.InitPdfTableProperty(releaseTable);

                    this.AddHeadTable(doc, 10, "Release of Information", null);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                            , releaseTable, Rectangle.ALIGN_LEFT, null, true, false, false, false);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Notice is hereby given that in connection with your application to act as a Third Party, Boston Scientific may order due diligence verification reports and/or investigative due diligence reports seeking information on various matters, including without limitation company structure, ownership, business practices, banking records, credit, bankruptcy proceedings, criminal records, civil records, and general reputation and personal characteristics (including any of the aforementioned items as well as individual educational accomplishment, employment history, etc.).  We require you to sign the following release authorization.", PdfHelper.normalFont))
                            , releaseTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCell("Release Authorization:"
                            , PdfHelper.normalBoldFont, releaseTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("I hereby authorize, without reservation, any person, company, agency, educational or other organization to furnish the above-mentioned information.  I also authorize Boston Scientific or its agents to order due diligence verification reports and/or investigative due diligence reports from any agency for the purpose of ascertaining my character and creditworthiness.  I further acknowledge that a photographic copy or fax of this release authorization shall be as valid as the original.  I agree to release and hold harmless all persons and entities from any liability on account of such disclosures and from any liability arising from any errors in information provided.", PdfHelper.normalFont))
                            , releaseTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE }, releaseTable, null, null);

                    PdfHelper.AddPdfTable(doc, releaseTable);
                    #endregion

                    #region 11.	Signature
                    PdfPTable signatureTable = new PdfPTable(4);
                    signatureTable.SetWidths(new float[] { 15f, 45f, 20f, 20f });
                    PdfHelper.InitPdfTableProperty(signatureTable);

                    this.AddHeadTable(doc, 11, "Signature", "I have read and fully understand the above notice and release and affirm that all of the information provided herein is truthful and accurate and that I am authorized to execute this release on behalf of the company.");

                    if (companyOwnersDs.Tables[0].Rows.Count > 0) 
                    {
                        DataTable dt=companyOwnersDs.Tables[0];
                        for (int i = 0; i < dt.Rows.Count; i++) 
                        {
                            if (!dt.Rows[i]["HomeAddress"].ToString().Equals("") || !dt.Rows[i]["IdentityCard"].ToString().Equals("")) 
                            {
                                #region User One
                                //Company/Date
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Company:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(GetDealerName(conMast.CmDmaId) + "\r\n (" + conMast.CmDealerCnName + ")", PdfHelper.youngChineseFont))
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, true, false, true, false);
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(DateTime.Now.ToShortDateString(), PdfHelper.youngFont))
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, false);
                                //signature/National Identification
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("By (signature):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("National Identification #:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dt.Rows[i]["IdentityCard"].ToString(), PdfHelper.youngFont))
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);
                                //Date of Birth/Print Name
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Print Name:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dt.Rows[i]["Name"].ToString() == "" ? "" : dt.Rows[i]["Name"].ToString(), PdfHelper.youngFont))
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dt.Rows[i]["Birthday"].ToString() == "" ? "" : Convert.ToDateTime(dt.Rows[i]["Birthday"].ToString()).ToShortDateString(), PdfHelper.youngFont))
                                          , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                                //Position
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Position", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                        , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                                PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Shareholder", PdfHelper.youngFont)) {  Colspan=3}
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
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Company:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(GetDealerName(conMast.CmDmaId) + "\r\n (" + conMast.CmDealerCnName + ")", PdfHelper.youngChineseFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, false, true, false);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(DateTime.Now.ToShortDateString(), PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, false);
                            //signature/National Identification
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("By (signature):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("National Identification #:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dtSign.From3NationalId, PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);
                            //Date of Birth/Position

                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Print Name:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dtSign.From3User, PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dtSign.From3Birth.Value.ToShortDateString(), PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                            //Position
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Position", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                   , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(dtSign.From3Position, PdfHelper.youngFont)) { Colspan=3}
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                            PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, signatureTable, null, null);
                        }
                        #endregion
                    }

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Attachments:\r\nFinancial Statements as referenced in Section 1.", PdfHelper.youngFont)) { Colspan = 4 }, signatureTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfTable(doc, signatureTable);
                    #endregion

                }
                else 
                {
                    #region 2.	Business References
                   
                    PdfPTable busReferTable = new PdfPTable(3);
                    busReferTable.SetWidths(new float[] { 20f, 40f, 40f });
                    PdfHelper.InitPdfTableProperty(busReferTable);

                    this.AddHeadTable(doc, 2, "Business References", "Please identify two business references with whom your Company works or has worked.");

                    //One
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Business Reference1", PdfHelper.iafAnswerFont)) { Rowspan = 6, BackgroundColor = PdfHelper.grayColor }
                            , busReferTable, null, Rectangle.ALIGN_MIDDLE, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name:", PdfHelper.youngFont)) { Colspan = 2 }
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, true, true, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { Colspan = 2 }
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Address:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Country:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Contact Person:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Telephone:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    //Two
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Business Reference2", PdfHelper.iafAnswerFont)) { Rowspan = 6, BackgroundColor = PdfHelper.grayColor }
                            , busReferTable, null, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name:", PdfHelper.youngFont)) { Colspan = 2 }
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { Colspan = 2 }
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Address:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Country:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Contact Person:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Telephone:", PdfHelper.youngFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , busReferTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

               

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, busReferTable, null, null);

                    PdfHelper.AddPdfTable(doc, busReferTable);
                    #endregion

                    #region 3. 	Medical Device or Pharmaceutical Companies

                    PdfPTable medicalDeviceTable = new PdfPTable(3);
                    medicalDeviceTable.SetWidths(new float[] { 20f, 40f, 40f });
                    PdfHelper.InitPdfTableProperty(medicalDeviceTable);

                    this.AddHeadTable(doc, 3, "Medical Device or Pharmaceutical Companies", "Please list names and descriptions of other medical device or pharmaceutical companies that you/your Company represents. If the answer is none, please state “None” in this Section.");

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Companies Represented", PdfHelper.iafAnswerFont)) { Rowspan = 4, BackgroundColor = PdfHelper.grayColor }
                            , medicalDeviceTable, null, Rectangle.ALIGN_MIDDLE, true, false, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name:", PdfHelper.youngFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, true, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Description of Business:", PdfHelper.youngFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, true, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name:", PdfHelper.youngFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Description of Business:", PdfHelper.youngFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, false, true);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , medicalDeviceTable, Rectangle.ALIGN_LEFT, Rectangle.ALIGN_MIDDLE, false, true, true, true);
                  

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, medicalDeviceTable, null, null);

                    PdfHelper.AddPdfTable(doc, medicalDeviceTable);
                    #endregion

                    #region 4.	Business Licenses, Permits or Registrations
               
                    PdfPTable lincensesTable = new PdfPTable(4);
                    lincensesTable.SetWidths(new float[] { 25f, 25f, 25f, 25f });
                    PdfHelper.InitPdfTableProperty(lincensesTable);

                    this.AddHeadTable(doc, 4, "Business Licenses, Permits or Registrations", "Please provide the following detail regarding any business licenses, permits or registrations held by your Company.");

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Country of issue", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , lincensesTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name of License, Permit or Registration", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , lincensesTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Licensing Authority", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , lincensesTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date of Registration and Registration Number", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , lincensesTable, null, null, true, true, true, true);

                    int businessLicensesCount = 2;
                    for (int i = 1; i < businessLicensesCount + 1; i++)
                    {
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                                , lincensesTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                                , lincensesTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                                , lincensesTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                                , lincensesTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    }
                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, lincensesTable, null, null);

                    PdfHelper.AddPdfTable(doc, lincensesTable);
                    #endregion

                    #region 5. 	Background Information on Company Directors and Principal Officers

                    PdfPTable bgInfoTable = new PdfPTable(4);
                    bgInfoTable.SetWidths(new float[] { 25f, 25f, 25f, 25f });
                    PdfHelper.InitPdfTableProperty(bgInfoTable);

                    this.AddHeadTable(doc, 5, "Background Information on Company Directors and Principal Officers", "Provide the following data for Directors and each principal officer (President, General Manager, Chief Financial Officer, etc.) of the Company.  If necessary, provide additional data on a separate sheet.");

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                            , bgInfoTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Director/Officer", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Director/Officer", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Director/Officer", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, null, null, true, true, true, true);

                    //Full Name
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Full Name (Family and Given):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Position / Title
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Position / Title:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Office Address(if different from Section 1):
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Office Address\r\n(if different from Section 1):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Telephone
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Telephone:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Fax
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Fax:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Email
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Email:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Residential Address
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Residential Address:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Passport #
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Passport #:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //National Residential ID#:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("National Residential ID#:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Date of Birth: 
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date of Birth: ", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Place of Birth:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Place of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , bgInfoTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);


                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, bgInfoTable, null, null);

                    PdfHelper.AddPdfTable(doc, bgInfoTable);
                    #endregion

                    #region 6.	Background Information on Company Owners and Shareholders

                    PdfPTable shareholdersTable = new PdfPTable(4);
                    shareholdersTable.SetWidths(new float[] { 25f, 25f, 25f, 25f });
                    PdfHelper.InitPdfTableProperty(shareholdersTable);

                    this.AddHeadTable(doc, 6, "Background Information on Company Owners and Shareholders ", "Please provide the following data for all owners and shareholders of the Company – Ownership % should add to 100%.  If the Company is publicly traded, it is only necessary to provide this data for owners and shareholders with Company ownership of 5% or greater.   Where an owner or shareholder is another company, please list that company as well as the ultimate beneficial owner(s) of that company (i.e. natural persons) and any intermediate entities.  If necessary, provide additional data on a separate sheet.");

                    #region User Info
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                            , shareholdersTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Shareholder", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Shareholder", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Shareholder", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, null, null, true, true, true, true);

                    //Full Name
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Full Name (Family and Given):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Relationship / % Ownership
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Relationship / % Ownership:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Office Address:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Office Address:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Telephone:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Telephone:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Fax:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Fax:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //Email:
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Email:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                    #endregion

                    #region NATURAL PERSON

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("IF SHAREHOLDER IS A NATURAL PERSON:", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor, Colspan = 4, BorderWidth = 1f, BorderWidthBottom = 0f, BorderColor = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Residential Address:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0.6f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Passport #", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("National Residential ID#:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Date of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Place of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 0f, BorderWidthLeft = 1f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, false, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthBottom = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    #endregion

                    #region COMPANY
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("IF SHAREHOLDER IS A COMPANY:", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor, Colspan = 4, BorderWidth = 1f, BorderWidthBottom = 0f, BorderColor = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Country of Incorporation
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Country of Incorporation:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0.6f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Registry #
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Registry #:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Ultimate Beneficial Owner
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Ultimate Beneficial Owner:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthLeft = 1f, BorderWidthRight = 0f, BorderColorLeft = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);

                    //Intermediate Entities
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("Intermediate Entities:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor, BorderWidthTop = 0f, BorderWidthRight = 0f, BorderWidthBottom = 1f, BorderWidthLeft = 1f, BorderColorLeft = PdfHelper.blueColor, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { BorderWidth = 0f, BorderWidthLeft = 0.6f, BorderWidthBottom = 1f, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { BorderWidth = 0f, BorderWidthLeft = 0.6f, BorderWidthBottom = 1f, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    PdfHelper.AddPdfCellHasBorder(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont)) { BorderWidth = 0.6f, BorderWidthTop = 0f, BorderWidthBottom = 1f, BorderWidthRight = 1f, BorderColorRight = PdfHelper.blueColor, BorderColorBottom = PdfHelper.blueColor }
                            , shareholdersTable, Rectangle.ALIGN_LEFT, null);
                    #endregion

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, shareholdersTable, null, null);

                    PdfHelper.AddPdfTable(doc, shareholdersTable);
                    #endregion

                    #region 7.	Background Information on All Entities Owned by the Company

                    PdfPTable entityOwnedTable = new PdfPTable(5);
                    entityOwnedTable.SetWidths(new float[] { 25f, 30f, 15f, 15f, 15f });
                    PdfHelper.InitPdfTableProperty(entityOwnedTable);

                    this.AddHeadTable(doc, 7, "Background Information on All Entities Owned by the Company", "Please provide the following data on all entities in which the Company holds an ownership interest (e.g. subsidiaries and joint ventures), including Country of Incorporation and Registry #, if applicable, and information regarding all joint venture partners and other interest holders.  If necessary, provide additional data on a separate sheet.  If the answer is none, please state “None” in this Section.");

                    int entityOwnerCount = 1;

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Subsidiaries or \r\nJoint Ventures", PdfHelper.iafAnswerFont)) { BackgroundColor = PdfHelper.grayColor, Rowspan = entityOwnerCount + 1 }
                            , entityOwnedTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , entityOwnedTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("% Ownership", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , entityOwnedTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Country", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , entityOwnedTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Reg #", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , entityOwnedTable, null, null, true, true, true, true);

                    for (int i = 1; i < entityOwnerCount + 1; i++)
                    {
                        //User One
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                                , entityOwnedTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                                , entityOwnedTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                                , entityOwnedTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                                , entityOwnedTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    }

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 5 }, entityOwnedTable, null, null);

                    PdfHelper.AddPdfTable(doc, entityOwnedTable);
                    #endregion

                    #region 8.	Public Office

                    PdfPTable publicOfficeTable = new PdfPTable(3);
                    publicOfficeTable.SetWidths(new float[] { 25f, 37.5f, 37.5f });
                    PdfHelper.InitPdfTableProperty(publicOfficeTable);

                    int officeCount = 1;

                    this.AddHeadTable(doc, 8, "Public Office", "Please identify whether any of the individuals named in the Sections above (or their immediate family members or business partners) are current or former government officials or candidates for political office, hold or have held public office, are or were employed by or affiliated with government entities, including state-owned or controlled hospitals or clinics, state-owned or controlled companies or charities,  political parties and public international organizations (e.g. World Bank and United Nations).  If the answer is none, please state “None” in this Section.");

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Government Official:", PdfHelper.iafAnswerFont)) { BackgroundColor = PdfHelper.grayColor, Rowspan = officeCount + 1 }
                            , publicOfficeTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Name", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , publicOfficeTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Government Affiliation", PdfHelper.youngBoldFont)) { BackgroundColor = PdfHelper.grayColor }
                            , publicOfficeTable, null, null, true, true, true, true);

                    for (int i = 1; i < officeCount + 1; i++)
                    {
                        //User One
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                                , publicOfficeTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                        PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.iafAnswerFont))
                                , publicOfficeTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    }

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE * 2, Colspan = 3 }, publicOfficeTable, null, null);

                    PdfHelper.AddPdfTable(doc, publicOfficeTable);
                    #endregion

                    #region 9.	Additional Information
                    PdfPTable additionalTable = new PdfPTable(5);
                    additionalTable.SetWidths(new float[] { 60f, 5f, 5f, 5f, 25f });
                    PdfHelper.InitPdfTableProperty(additionalTable);

                    this.AddHeadTable(doc, 9, "Additional Information", null);

                    //1
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Has the Company or any of its principal officers, directors or shareholders been involved in a civil or criminal action during the past five years (excluding minor traffic infractions and domestic settlements)?", PdfHelper.youngFont)) { Rowspan = 3 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(conMast.CmProperty1)
                            , additionalTable, null, null, true, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!conMast.CmProperty1)
                            , additionalTable, null, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("No", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, true, true, true, false);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("If “yes,” provide details:", PdfHelper.youngFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmDesc1 + " ", PdfHelper.iafAnswerFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //2
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Has the Company or any of its principal officers, directors or shareholders been involved in any governmental/ regulatory body investigation or administrative action, or had sanctions imposed on it, within the past five years?", PdfHelper.youngFont)) { Rowspan = 3 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(conMast.CmProperty2)
                            , additionalTable, null, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!conMast.CmProperty2)
                            , additionalTable, null, null, false, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("No", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("If “yes,” provide details:", PdfHelper.youngFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmDesc2 + " ", PdfHelper.iafAnswerFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);

                    //3
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Has the Company or any of its principal officers, directors or shareholders filed or been involved in any action related to bankruptcy, insolvency, or reorganization within the past five years?", PdfHelper.youngFont)) { Rowspan = 3 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(conMast.CmProperty3)
                            , additionalTable, null, null, false, false, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Yes", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(this.AddCheckBox(!conMast.CmProperty3)
                            , additionalTable, null, null, false, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("No", PdfHelper.youngFont))
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("If “yes,” provide details:", PdfHelper.youngFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, false, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(conMast.CmDesc3, PdfHelper.iafAnswerFont)) { Colspan = 4 }
                            , additionalTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);


                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 5 }, additionalTable, null, null);

                    PdfHelper.AddPdfTable(doc, additionalTable);
                    #endregion

                    #region 10.	Release of Information
                    PdfPTable releaseTable = new PdfPTable(1);
                    PdfHelper.InitPdfTableProperty(releaseTable);

                    this.AddHeadTable(doc, 10, "Release of Information", null);

                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell()
                            , releaseTable, Rectangle.ALIGN_LEFT, null, true, false, false, false);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Notice is hereby given that in connection with your application to act as a Third Party, Boston Scientific may order due diligence verification reports and/or investigative due diligence reports seeking information on various matters, including without limitation company structure, ownership, business practices, banking records, credit, bankruptcy proceedings, criminal records, civil records, and general reputation and personal characteristics (including any of the aforementioned items as well as individual educational accomplishment, employment history, etc.).  We require you to sign the following release authorization.", PdfHelper.normalFont))
                            , releaseTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCell("Release Authorization:"
                            , PdfHelper.normalBoldFont, releaseTable, Rectangle.ALIGN_LEFT);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("I hereby authorize, without reservation, any person, company, agency, educational or other organization to furnish the above-mentioned information.  I also authorize Boston Scientific or its agents to order due diligence verification reports and/or investigative due diligence reports from any agency for the purpose of ascertaining my character and creditworthiness.  I further acknowledge that a photographic copy or fax of this release authorization shall be as valid as the original.  I agree to release and hold harmless all persons and entities from any liability on account of such disclosures and from any liability arising from any errors in information provided.", PdfHelper.normalFont))
                            , releaseTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE }, releaseTable, null, null);

                    PdfHelper.AddPdfTable(doc, releaseTable);
                    #endregion

                    #region 11.	Signature
                    PdfPTable signatureTable = new PdfPTable(4);
                    signatureTable.SetWidths(new float[] { 15f, 45f, 20f, 20f });
                    PdfHelper.InitPdfTableProperty(signatureTable);

                    this.AddHeadTable(doc, 11, "Signature", "I have read and fully understand the above notice and release and affirm that all of the information provided herein is truthful and accurate and that I am authorized to execute this release on behalf of the company.");

                    #region User One
                    Hashtable tableShareholder = new Hashtable();
                    tableShareholder.Add("CmId", this.hdCmId.Value);
                    DataTable dtShareholder = contractMasterBLL.QuerySeniorCompanyList(tableShareholder).Tables[0];
                    if (dtShareholder.Rows.Count > 0) 
                    {
                        for (int i = 0; i < dtShareholder.Rows.Count; i++) 
                        {
                            //Company/Date
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Company:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(GetDealerName(conMast.CmDmaId), PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, false, true, false);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph(DateTime.Now.ToShortDateString(), PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, false);
                            //signature/National Identification
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("By (signature):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("National Identification #:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);
                            //Date of Birth/Print Name
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Print Name:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                            //Position
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Position:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                            PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont)) { Colspan = 3 }
                                    , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);


                            PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, signatureTable, null, null);
                        }
                    }

                    //Company/Date
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Company:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                            , signatureTable, Rectangle.ALIGN_LEFT, null, true, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                            , signatureTable, Rectangle.ALIGN_LEFT, null, true, true, true, false);
                    //signature/National Identification
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("By (signature):", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                            , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("National Identification #:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                            , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);
                    //Date of Birth/Print Name
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Print Name:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                            , signatureTable, Rectangle.ALIGN_LEFT, null, false, false, true, false);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Date of Birth:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont))
                            , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                    //Position
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("Position:", PdfHelper.youngFont)) { BackgroundColor = PdfHelper.grayColor }
                            , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, true);
                    PdfHelper.AddPdfCellHasBorderNormal(new PdfPCell(new Paragraph("", PdfHelper.youngFont)) { Colspan = 3 }
                            , signatureTable, Rectangle.ALIGN_LEFT, null, false, true, true, false);

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, signatureTable, null, null);
                    #endregion
                

                    PdfHelper.AddPdfCell(new PdfPCell() { FixedHeight = PdfHelper.PDF_NEW_LINE, Colspan = 4 }, signatureTable, null, null);

                    PdfHelper.AddPdfCell(new PdfPCell(new Paragraph("Attachments:\r\nFinancial Statements as referenced in Section 1.", PdfHelper.youngFont)) { Colspan = 4 }, signatureTable, Rectangle.ALIGN_LEFT, null);

                    PdfHelper.AddPdfTable(doc, signatureTable);
                    #endregion
                }
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

            Chunk numberChunk = new Chunk(number.ToString() + ".     ", PdfHelper.italicFont);
            Chunk headChunk = new Chunk(headText, PdfHelper.italicFont);

            Phrase headPhrase = new Phrase();
            headPhrase.Add(headChunk);

            if (!string.IsNullOrEmpty(subHeadText))
            {
                Chunk subHeadChunk = new Chunk("\r\n" + subHeadText, PdfHelper.youngDescFont);
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

        private string GetStringByDataRow2(DataSet ds, int rowNumber, string column)
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
                    resultStr = "None";
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
