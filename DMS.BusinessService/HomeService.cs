using DMS.Common.Common;
using DMS.DataAccess.Lafite;
using DMS.ViewModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DMS.Common.Extention;
using DMS.Common;
using DMS.Model.Data;
using DMS.Business;
using Lafite.RoleModel.Provider;
using Lafite.RoleModel.Security;
using System.Web.Security;
using DMS.DataAccess.HCPPassport;
using DMS.ViewModel.Common;
using Lafite.RoleModel.Domain;

namespace DMS.BusinessService
{
    public class HomeService : ABaseService
    {
        #region Ajax Method

        public HomeVO Init(HomeVO model)
        {
            try
            {
                SiteMapDao siteMapDao = new SiteMapDao();
                WeChatBaseBLL wechatService = new WeChatBaseBLL();
                DealerMasters dealerMastersService = new DealerMasters();
                ShipmentBLL shipmentService = new ShipmentBLL();
                DealerContracts dealerContractsService = new DealerContracts();
                QueryInventoryBiz businessInventoryService = new QueryInventoryBiz();
                IdentityDao identityDao = new IdentityDao();
                DealerAccountDao dao = new DealerAccountDao();


                model.IptPhone = dao.SelectPhoneEmail(base.UserInfo.Id).Rows[0]["PHONE"].ToString();
                model.IptEmail = dao.SelectPhoneEmail(base.UserInfo.Id).Rows[0]["EMAIL1"].ToString();

                model.IptUserName = base.UserInfo.FullName;
                model.IptUserMobile = base.UserInfo.Phone;

                model.IptDealerName = !string.IsNullOrEmpty(base.UserInfo.CorpName) ? base.UserInfo.CorpName : base.UserInfo.FullName;
                model.IptAccount = base.UserInfo.LoginId;

                //if (base.IsDealer)
                //{
                if (!string.IsNullOrEmpty(base.UserInfo.Phone))
                {
                    model.LstDealerList = identityDao.SelectByMobile(base.UserInfo.Phone);
                }
                //}
                InitSubCompany(model);

                model.IsDealer = base.IsDealer;
                model.IsAdmin = !base.IsDealer && base.IsInRole("Administrators");

                IList<Hashtable> menuList = siteMapDao.SelectUserMenu(base.UserInfo.Id.ToSafeGuid());
                model.LstMenuList = new List<Hashtable>();
                foreach (Hashtable menu in menuList)
                {
                    if (menu.GetSafeIntValue("MenuLevel") == 1)
                    {
                        Hashtable newMenu = new Hashtable();
                        newMenu.Add("MIDX", menu.GetSafeIntValue("MenuId"));
                        newMenu.Add("PowerKey", menu.GetSafeStringValue("PowerKey"));
                        String menuStr = menu.GetSafeStringValue("MenuName");
                        if (menuStr.IndexOf("|") >= 0)
                        {
                            menuStr = menuStr.Substring(0, menuStr.IndexOf("|"));
                        }
                        newMenu.Add("Menu", menuStr);

                        IList<Hashtable> newMenuPages = new List<Hashtable>();
                        foreach (Hashtable page in menuList)
                        {
                            if (page.GetSafeIntValue("ParentMenu") == menu.GetSafeIntValue("MenuId"))
                            {
                                Hashtable newPage = new Hashtable();
                                newPage.Add("PIDX", page.GetSafeIntValue("MenuId"));
                                String pageStr = page.GetSafeStringValue("MenuName");
                                if (pageStr.IndexOf("|") >= 0)
                                {
                                    pageStr = pageStr.Substring(0, pageStr.IndexOf("|"));
                                }
                                newPage.Add("Page", pageStr);
                                newPage.Add("PageUrl", page.GetSafeStringValue("MenuUrl"));
                                newPage.Add("PowerKey", page.GetSafeStringValue("PowerKey"));
                                newPage.Add("ResourceKey", page.GetSafeStringValue("ResourceKey"));
                                newMenuPages.Add(newPage);
                            }
                        }
                        newMenu.Add("Pages", newMenuPages);
                        model.LstMenuList.Add(newMenu);
                    }
                }

                model.IsWechat = true;
                if (base.UserInfo.IdentityType.Equals(SR.Consts_System_Dealer_User)
                    && !base.UserInfo.CorpType.Equals(DealerType.HQ.ToString())
                    && base.UserInfo.LoginId.Length < 10)
                {
                    //不包含经销商支持账号99
                    //检查是否维护过该经销商微信信息
                    if (base.UserInfo.UserName.Contains("_") && base.UserInfo.UserName.Split('_')[1].ToString() != "99")
                    {
                        //非99结尾的账号都要校验微信维护
                        Hashtable condition = new Hashtable();
                        condition.Add("DealerId", base.UserInfo.CorpId.Value);
                        DataSet ds = wechatService.GetUser(condition);
                        if (ds.Tables[0].Rows.Count <= 0)
                        {
                            model.IsWechat = false;
                        }
                    }
                }

                if (base.IsDealer
                    && (base.UserInfo.CorpType.Equals(DealerType.T2.ToString())
                        || base.UserInfo.CorpType.Equals(DealerType.LP.ToString())
                        || base.UserInfo.CorpType.Equals(DealerType.LS.ToString())
                        || base.UserInfo.CorpType.Equals(DealerType.T1.ToString())))
                {
                    model.IsDisclosure = true;
                    {
                        Hashtable condition = new Hashtable();
                        condition.Add("dealerId", base.UserInfo.CorpId.Value);
                        condition.Add("insertDate", (DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString().PadLeft(2, '0')));
                        if (dealerMastersService.GetHomePageMessage(condition))
                        {
                            model.IsDisclosure = false;
                        }
                    }

                    model.IsNearEffect = true;
                    {
                        //判断是否包含CRM 授权
                        Hashtable condition = new Hashtable();
                        condition.Add("ActiveFlag", "1");
                        condition.Add("DealerId", base.UserInfo.CorpId.Value);
                        condition.Add("Division", "19");
                        DataSet ds = dealerContractsService.SelectByDealerDealerContractActiveFlag(condition);
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            Hashtable table = new Hashtable();
                            table.Add("DealerId", base.UserInfo.CorpId.Value);
                            table.Add("PageNum", 0);
                            table.Add("PageSize", 10000);
                            DataSet rst = businessInventoryService.SelectNearEffectInventoryDataSet(table);

                            model.RstNearEffect = JsonHelper.DataTableToArrayList(rst.Tables[1]);

                            model.IsNearEffect = false;
                        }
                    }
                }
                else
                {
                    model.IsDisclosure = true;
                    model.IsNearEffect = true;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public HomeVO ChangeDealer(HomeVO model)
        {
            try
            {
                HttpContext.Current.Session.Abandon();
                LoginUserExtension.FlushCache(base.UserInfo);
                FormsAuthentication.SetAuthCookie(model.IptAccount, false);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public HomeVO ChangeSubCompany(HomeVO model)
        {
            try
            {
                BaseService.CurrentSubCompany = new KeyValue(model.IptSubCompanyId, model.IptSubCompanyName);
                //InitBrand(model, true);
                BaseService.CurrentBrand = null;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public HomeVO ChangeBrand(HomeVO model)
        {
            try
            {
                BaseService.CurrentBrand = new KeyValue(model.IptBrandId, model.IptBrandName);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public HomeVO CheckShipment(HomeVO model)
        {
            try
            {
                ShipmentBLL shipmentService = new ShipmentBLL();

                shipmentService.ConfirmShipmenInit(model.IptShipmentNo);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public HomeVO ShipmentInitCheck(HomeVO model)
        {
            try
            {
                ShipmentBLL shipmentService = new ShipmentBLL();

                if (base.IsDealer
                    && (base.UserInfo.CorpType.Equals(DealerType.T2.ToString())
                        || base.UserInfo.CorpType.Equals(DealerType.LP.ToString())
                        || base.UserInfo.CorpType.Equals(DealerType.LS.ToString())
                        || base.UserInfo.CorpType.Equals(DealerType.T1.ToString())))
                {
                    model.IsShipment = true;
                    {
                        Hashtable condition = new Hashtable();
                        condition.Add("dealerId", base.UserInfo.CorpId.Value);
                        DataTable dt = shipmentService.GetShipmentInitNoConfirm(condition).Tables[0];
                        if (dt.Rows.Count > 0)
                        {
                            DataRow dr = dt.Rows[0];

                            model.IptShipmentMessage += "销售单批量导入编号：" + dr["InitNo"].ToString() + " 已完成系统校验。";
                            if (dr["InitStatus"].ToString().Equals("Completed"))
                            {
                                model.IptShipmentMessage += "请知晓!";
                            }
                            if (dr["InitStatus"].ToString().Equals("PartCompleted"))
                            {
                                model.IptShipmentMessage += "上传数据中<font size='2' color='red'>包含部分错误数据</font> ，请及时调整，并重新上传（仅针对错误数据）。";
                            }
                            if (dr["InitStatus"].ToString().Equals("Error"))
                            {
                                model.IptShipmentMessage += "上传数据中<font size='2' color='red'>包含错误数据</font> ，请及时调整，并重新上传。";
                            }

                            model.IptShipmentNo = dr["InitNo"].ToString();
                            model.IsShipment = false;
                            shipmentService.ConfirmShipmenInit(model.IptShipmentNo);
                        }
                    }
                }
                else
                {
                    model.IsShipment = true;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }



        public HomeVO Save(HomeVO model)
        {
            try
            {
                DealerAccountDao dao = new DealerAccountDao();

                dao.SaveHome(model.IptPhone, model.IptEmail);

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

        #region Private Function

        private void InitSubCompany(HomeVO model)
        {
            DataSet dsAuthSubCompany = GetAuthSubCompany();
            model.LstSubCompany = JsonHelper.DataTableToArrayList(dsAuthSubCompany.Tables[0]);
            if (model.LstSubCompany.Count < 1)
            {
                BaseService.CurrentSubCompany = null;
            }
            if (null == BaseService.CurrentSubCompany)
            {
                if (dsAuthSubCompany.Tables.Count > 0 && dsAuthSubCompany.Tables[0].Rows.Count > 0)
                {
                    var firstSubCompany = dsAuthSubCompany.Tables[0].Rows[0];
                    if (null != firstSubCompany)
                    {
                        BaseService.CurrentSubCompany = new KeyValue(firstSubCompany["Id"].ToString(),
                            firstSubCompany["ATTRIBUTE_NAME"].ToString());
                    }
                }
            }
            model.IptSubCompanyId = BaseService.CurrentSubCompany?.Key;
            model.IptSubCompanyName = BaseService.CurrentSubCompany?.Value;
            InitBrand(model);
        }

        private void InitBrand(HomeVO model, bool isSetNewSession = false)
        {
            if (null != BaseService.CurrentSubCompany)
            {
                DataSet dsAuthBrand = GetAuthBrand(new Guid(BaseService.CurrentSubCompany.Key));
                model.LstBrand = JsonHelper.DataTableToArrayList(dsAuthBrand.Tables[0]);
                if (model.LstBrand.Count < 1)
                {
                    BaseService.CurrentBrand = null;
                }
                if (null == BaseService.CurrentBrand || isSetNewSession)
                {
                    if (dsAuthBrand.Tables.Count > 0 && dsAuthBrand.Tables[0].Rows.Count > 0)
                    {
                        var firstBrand = dsAuthBrand.Tables[0].Rows[0];
                        if (null != firstBrand)
                        {
                            BaseService.CurrentBrand = new KeyValue(firstBrand["Id"].ToString(),
                                firstBrand["ATTRIBUTE_NAME"].ToString());
                        }
                        else
                        {
                            BaseService.CurrentBrand = null;
                        }
                    }
                }
                model.IptBrandId = BaseService.CurrentBrand?.Key;
                model.IptBrandName = BaseService.CurrentBrand?.Value;
            }
            else
            {
                BaseService.CurrentBrand = null;
            }
        }

        #endregion Private Function
    }
}
