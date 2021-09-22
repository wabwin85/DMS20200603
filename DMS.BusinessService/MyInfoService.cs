using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using Lafite.RoleModel.Security;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Specialized;
using DMS.Business.Excel;
using DMS.Business;
using DMS.ViewModel;
using DMS.Model;
using DMS.Business.Cache;
using Lafite.RoleModel.Service;

namespace DMS.BusinessService
{
    public class MyInfoService : ABaseQueryService
    {
        #region Ajax Method
        public MyInfoVO Init(MyInfoVO model)
        {
            try
            {

                IRoleModelContext context = RoleModelContext.Current;
                LoginUser user = context.User;

                model.LoginID = user.LoginId;
                model.UserName = user.FullName;
                model.Email1 = user.Email;
                model.Email2 = user.Email2;
                model.Phone = user.Phone;
                model.Address = user.Address;

                model.CustomField1 = user.Rev1;
                model.CustomField2 = user.Rev2;
                model.CustomField3 = user.Rev3;

                Guid? id = context.User.CorpId;
                if (id != null)
                {
                    model.HasCompany = true;
                    DealerMaster dealer = DealerCacheHelper.GetDealer(id.Value);

                    model.CPDealerID = dealer.Id.Value.ToString();
                    model.CPDealerChineseName = dealer.ChineseName;
                    model.CPDealerEnglishName = dealer.EnglishName;
                    model.CPDealerCertification = dealer.Certification;
                    model.CPDealerPhone = dealer.Phone;
                    model.CPDealerFax = dealer.Fax;
                    model.CPDealerAddress = dealer.Address;
                    model.CPDealerPostalCode = dealer.PostalCode;

                    DealerShipTo dealershipto = new PurchaseOrderBLL().GetDealerShipToByUser(new Guid(context.User.Id));
                    if (dealershipto == null)
                    {
                        model.IsNewOrder = true;
                    }
                    else
                    {
                        model.ORContactPerson = dealershipto.ContactPerson;
                        model.ORContact = dealershipto.Contact;
                        model.ORContactMobile = dealershipto.ContactMobile;
                        model.ORConsignee = dealershipto.Consignee;
                        model.ORConsigneePhone = dealershipto.ConsigneePhone;
                        model.OROrderEmail = dealershipto.Email;
                        model.ORReceiveSMS = dealershipto.Receivesms;
                        model.ORReceiveEmail = dealershipto.ReceiveEmail;
                        model.ORReceiveOrder = dealershipto.ReceiveOrder;
                        model.ORShipmentDealer = dealershipto.ShipToAddress;
                    }
                }
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public MyInfoVO Save(MyInfoVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                LoginUser user = context.User;

                user.LoginId = model.LoginID;
                user.FullName = model.UserName;
                user.Email = model.Email1;
                user.Email2 = model.Email2;
                //user.Phone = model.Phone;
                user.Address = model.Address;

                user.Rev1 = model.CustomField1;
                user.Rev2 = model.CustomField2;
                user.Rev3 = model.CustomField3;

                IUserBiz biz = new UserBiz();
                if (!string.IsNullOrEmpty(user.FullName) && !string.IsNullOrEmpty(user.Email)
                    && !string.IsNullOrEmpty(user.Phone) && !string.IsNullOrEmpty(user.Address))
                {
                    biz.UpdateUser(user);
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("姓名、电子邮箱、电话、地址必须填写");
                    return model;
                }

                if (model.HasCompany)
                {
                    PurchaseOrderBLL purchaseOrderBLL = new PurchaseOrderBLL();
                    DealerShipTo dealershipto = new PurchaseOrderBLL().GetDealerShipToByUser(new Guid(context.User.Id));
                    if (dealershipto == null)
                    {
                        dealershipto = new DealerShipTo();
                        dealershipto.Id = Guid.NewGuid();
                        dealershipto.DealerUserId = new Guid(context.User.Id);
                        dealershipto.DealerDmaId = context.User.CorpId.Value;
                        model.IsNewOrder = true;
                    }
                    dealershipto.ContactPerson = model.ORContactPerson;
                    dealershipto.Contact = model.ORContact;
                    dealershipto.ContactMobile = model.ORContactMobile;
                    dealershipto.Consignee = model.ORConsignee;
                    dealershipto.ConsigneePhone = model.ORConsigneePhone;
                    dealershipto.Email = model.OROrderEmail;
                    dealershipto.Receivesms = model.ORReceiveSMS;
                    dealershipto.ReceiveEmail = model.ORReceiveEmail;
                    dealershipto.ReceiveOrder = model.ORReceiveOrder;
                    dealershipto.ShipToAddress = model.ORShipmentDealer;
                    if (model.IsNewOrder)
                    {
                        purchaseOrderBLL.InsertDealerShipTo(dealershipto);
                    }
                    else
                    {
                        purchaseOrderBLL.UpdateDealerShipTo(dealershipto);
                    }
                }
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }


        #endregion
    }


}
