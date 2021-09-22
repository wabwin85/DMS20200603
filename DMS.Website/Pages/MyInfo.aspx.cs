using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages
{
    using Lafite.RoleModel.Service;
    using Lafite.RoleModel.Security;
    using Coolite.Ext.Web;
    using DMS.Business.Cache;
    using DMS.Model;
    using DMS.Business;
    using DMS.Website.Common;
    using System.Text.RegularExpressions;

    public partial class MyInfo : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.GetPersonalInfo();
                this.GetDealerInfo();
                this.GetOrderInfo();
            }
        }

        private void GetPersonalInfo()
        {
            IRoleModelContext context = RoleModelContext.Current;
            LoginUser user = context.User;

            this.txtLoginId.Text = user.LoginId;
            this.txtFullName.Text = user.FullName;
            this.txtEmail.Text = user.Email;
            this.txtEmail1.Text = user.Email2;
            this.txtPhone.Text = user.Phone;
            this.txtAddress.Text = user.Address;

            this.txtCustomField1.Text = user.Rev1;
            this.txtCustomField2.Text = user.Rev2;
            this.txtCustomField3.Text = user.Rev3;
        }

        private void GetDealerInfo()
        {
            IRoleModelContext context = RoleModelContext.Current;
            LoginUser user = context.User;

            Guid? id = context.User.CorpId;
            if (id != null)
            {
                plCorporation.Visible = true;

                DealerMaster dealer = DealerCacheHelper.GetDealer(id.Value);

                this.txtDealerId.Text = dealer.Id.Value.ToString();
                this.txtDealerChineseName.Text = dealer.ChineseName;
                this.txtDealerEnglishName.Text = dealer.EnglishName;
                this.txtDealerCertification.Text = dealer.Certification;
                this.txtDealerPhone.Text = dealer.Phone;
                this.txtDealerFax.Text = dealer.Fax;
                this.txtDealerAddress.Text = dealer.Address;
                this.txtDealerPostalCode.Text = dealer.PostalCode;
            }
            else
            {
                plCorporation.Visible = false;
            }
        }

        private void GetOrderInfo()
        {
            PurchaseOrderBLL purchaseOrderBLL = new PurchaseOrderBLL();

            IRoleModelContext context = RoleModelContext.Current;

            Guid? id = context.User.CorpId;
            if (id != null)
            {
                plOrder.Visible = true;
                DealerShipTo dealershipto = purchaseOrderBLL.GetDealerShipToByUser(new Guid(context.User.Id));
                if (dealershipto == null)
                {
                    this.hidIsNew.Text = "True";
                }
                else
                {
                    this.hidIsNew.Text = "False";
                    this.txtContactPerson.Text = dealershipto.ContactPerson;
                    this.txtContact.Text = dealershipto.Contact;
                    this.txtContactMobile.Text = dealershipto.ContactMobile;
                    this.txtConsignee.Text = dealershipto.Consignee;
                    this.txtConsigneePhone.Text = dealershipto.ConsigneePhone;
                    this.txtOrderEmail.Text = dealershipto.Email;
                    this.chkReceiveSMS.Checked = dealershipto.Receivesms;
                    this.chkReceiveEmail.Checked = dealershipto.ReceiveEmail;
                    this.chkReceiveOrder.Checked = dealershipto.ReceiveOrder;
                    this.txtShipmentDealer.Text = dealershipto.ShipToAddress;
                }
            }
            else
            {
                plOrder.Visible = false;
            }
        }

        [AjaxMethod]
        public void SavePerson()
        {
            IRoleModelContext context = RoleModelContext.Current;
            LoginUser user = context.User;

            user.FullName = this.txtFullName.Text.Trim();
            user.Email = this.txtEmail.Text.Trim();
            user.Email2 = this.txtEmail1.Text.Trim();
            user.Phone = this.txtPhone.Text.Trim();
            user.Address = this.txtAddress.Text;
            user.Rev1 = this.txtCustomField1.Text.Trim();
            user.Rev2 = this.txtCustomField2.Text.Trim();
            user.Rev3 = this.txtCustomField3.Text.Trim();

            string emailPattern = @"^[a-z]([a-z0-9]*[-_]?[a-z0-9]+)*@([a-z0-9]*[-_]?[a-z0-9]+)+[\.][a-z]{2,3}([\.][a-z]{2})?$";
            Regex reg = new Regex(emailPattern, RegexOptions.IgnoreCase);
            
            IUserBiz biz = new UserBiz();
            if (!string.IsNullOrEmpty(user.FullName) && !string.IsNullOrEmpty(user.Email)
                && !string.IsNullOrEmpty(user.Phone) && !string.IsNullOrEmpty(user.Address))
                //&& reg.Match(user.Email).Success)
            {
                biz.UpdateUser(user);
            }
            else
            {
                throw new Exception();
            }

            Guid? id = context.User.CorpId;
            if (id != null)
            {
                PurchaseOrderBLL purchaseOrderBLL = new PurchaseOrderBLL();
                DealerShipTo dealershipto = new DealerShipTo();
                dealershipto.Id = Guid.NewGuid();
                dealershipto.DealerUserId = new Guid(context.User.Id);
                dealershipto.DealerDmaId = context.User.CorpId.Value;
                dealershipto.ContactPerson = this.txtContactPerson.Text;
                dealershipto.Contact = this.txtContact.Text;
                dealershipto.ContactMobile = this.txtContactMobile.Text;
                dealershipto.Consignee = this.txtConsignee.Text;
                dealershipto.ConsigneePhone = this.txtConsigneePhone.Text;
                dealershipto.Email = this.txtOrderEmail.Text;
                dealershipto.Receivesms = this.chkReceiveSMS.Checked;
                dealershipto.ReceiveEmail = this.chkReceiveEmail.Checked;
                dealershipto.ReceiveOrder = this.chkReceiveOrder.Checked;
                dealershipto.ShipToAddress = this.txtShipmentDealer.Text;

                if (this.hidIsNew.Text == "True")
                {
                    purchaseOrderBLL.InsertDealerShipTo(dealershipto);
                    this.hidIsNew.Text = "False";
                }
                else
                {
                    purchaseOrderBLL.UpdateDealerShipTo(dealershipto);
                }
            }
        }

        protected void SaveDealer(object sender, AjaxEventArgs e)
        {
            //IRoleModelContext context = RoleModelContext.Current;
            //LoginUser user = context.User;

            //Guid? id = context.User.CorpId;
            //if (id != null)
            //{
            //    IDealerMasters dealers = new DealerMasters();
            //    DealerMaster dealer = DealerCacheHelper.GetDealer(id.Value);
            //    //..... waiting to add
            //}
        }

    }
}
