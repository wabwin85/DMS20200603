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
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using System.Collections.Specialized;
using DMS.Business.Excel;
using DMS.Business;
using DMS.ViewModel.DealerTrain;
using DMS.Business.DealerTrain;
using DMS.Model;

namespace DMS.BusinessService.DealerTrain
{
    public class SalesUserManageService : ABaseQueryService, IDealerFilterFac
    {
        #region Ajax Method
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public SalesUserManageVO Init(SalesUserManageVO model)
        {
            try
            {

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(SalesUserManageVO model)
        {
            try
            {
                CommandoUserBLL _commandoUserBLL = new CommandoUserBLL();

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = _commandoUserBLL.GetDealerSalesList(model.QryDealer, model.QrySale, start, model.PageSize, out outCont);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = outCont;
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public SalesUserManageVO Save(SalesUserManageVO model)
        {
            IDealerMasters _dealerMastersBll = new DealerMasters();
            IWeChatBaseBLL _wechatBll = new WeChatBaseBLL();
            CommandoUserBLL _commandoUserBLL = new CommandoUserBLL();
            try
            {
                if (string.IsNullOrEmpty(model.AddDealerSalesID))
                {
                    BusinessWechatUser user = new BusinessWechatUser();
                    user.Id = Guid.NewGuid();
                    user.DealerId = new Guid(model.AddDealer.Key);
                    DealerMaster dm = _dealerMastersBll.GetDealerMaster(user.DealerId.Value);
                    if (dm != null)
                    {
                        user.DealerName = dm.ChineseName;
                        user.DealerType = dm.DealerType;
                    }
                    user.UserName = model.AddSalesName;
                    user.Phone = model.AddSalesPhone;
                    user.Post = "Sales";
                    user.Sex = model.AddSalesSex ? "1" : "0";
                    user.Email = model.AddSalesEmail;
                    user.Status = "Active";

                    if (CheckUserBind(user, "insert"))
                    {
                        Random rad = new Random();
                        user.Rv1 = rad.Next(1000, 10000).ToString();

                        _wechatBll.InsertUser(user);
                        //_commandoUserBLL.SendMail(user.Rv1, user.Email);
                        //_commandoUserBLL.SendMassage(user.Rv1, user.Phone);

                        Hashtable obj = new Hashtable();
                        obj.Add("DmaId", user.DealerId.Value.ToString());
                        obj.Add("UserId", user.Id.ToString());

                        _wechatBll.InsertUserProductLine(obj);

                        DMS.Model.DealerSales ds = new DMS.Model.DealerSales();
                        ds.DealerSalesId = user.Id;
                        ds.WeChatUserId = user.Id;
                        ds.CreateTime = DateTime.Now;
                        ds.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                        ds.UpdateTime = DateTime.Now;
                        ds.UpdateUser = new Guid(RoleModelContext.Current.User.Id);

                        _commandoUserBLL.AddDealerSalesInfo(ds);
                        model.IsSuccess = true;
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("该手机号已被注册！");
                    }
                }
                else
                {
                    BusinessWechatUser user = new BusinessWechatUser();
                    user.Id = new Guid(model.AddDealerSalesID);
                    user.UserName = model.AddSalesName;
                    user.Phone = model.AddSalesPhone;
                    user.Post = "Sales";
                    user.Sex = model.AddSalesSex ? "1" : "0";
                    user.Email = model.AddSalesEmail;
                    user.Status = "Active";

                    if (CheckUserBind(user, "update"))
                    {
                        _wechatBll.UpdateUser(user);
                        model.IsSuccess = true;
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("该手机号已被注册！");
                    }
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

        public SalesUserManageVO Delete(SalesUserManageVO model)
        {
            CommandoUserBLL _commandoUserBLL = new CommandoUserBLL();
            try
            {
                if (!string.IsNullOrEmpty(model.AddDealerSalesID))
                {
                    _commandoUserBLL.RemoveDealerSalesInfo(new Guid(model.AddDealerSalesID));
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除出错！");
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

        private bool CheckUserBind(BusinessWechatUser user, string OperatType)
        {
            IWeChatBaseBLL _wechatBll = new WeChatBaseBLL();
            Hashtable obj = new Hashtable();
            obj.Add("Phone", user.Phone);
            DataTable dt = _wechatBll.GetUser(obj).Tables[0];
            if (OperatType.Equals("insert"))
            {
                if (dt.Rows.Count > 0)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            else if (OperatType.Equals("update"))
            {
                if (dt.Rows.Count > 1)
                {
                    return false;
                }
                else if (dt.Rows.Count == 1)
                {
                    if (user.Id != new Guid(dt.Rows[0]["Id"].ToString()))
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
                else
                {
                    return true;
                }
            }

            return true;
        }
        public SalesUserManageVO ImportWechatUser(SalesUserManageVO model)
        {
            CommandoUserBLL _commandoUserBLL = new CommandoUserBLL();
            try
            {
                if (model.DealerSalesIDList.Count > 0)
                {
                    foreach (String dealerSalesId in model.DealerSalesIDList)
                    {
                        DMS.Model.DealerSales ds = new DMS.Model.DealerSales();
                        ds.DealerSalesId = new Guid(dealerSalesId);
                        ds.WeChatUserId = new Guid(dealerSalesId);
                        ds.CreateTime = DateTime.Now;
                        ds.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                        ds.UpdateTime = DateTime.Now;
                        ds.UpdateUser = new Guid(RoleModelContext.Current.User.Id);

                        _commandoUserBLL.AddDealerSalesInfo(ds);
                    }
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("导入出错！");
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
        #endregion
    }


}
