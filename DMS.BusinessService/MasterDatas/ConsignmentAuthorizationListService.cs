using DMS.Business;
using DMS.Business.Cache;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.DataAccess.Consignment;
using DMS.DataAccess.ContractElectronic;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.MasterDatas;
using Lafite.RoleModel.Domain;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.MasterDatas
{
    public class ConsignmentAuthorizationListService : ABaseQueryService
    {
        #region Ajax Method
        public IConsignmentMasterBLL AuthorizationBLL = new ConsignmentMasterBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        public ConsignmentAuthorizationListVO Init(ConsignmentAuthorizationListVO model)
        {
            try
            {
                InventoryAdjustHeaderDao ContractHeader = new InventoryAdjustHeaderDao();
                model.SearchEnabled= _context.IsInRole("Administrators") || _context.IsInRole("经销商短期寄售管理员");
                model.InsertEnabled = _context.IsInRole("Administrators") || _context.IsInRole("经销商短期寄售管理员");
                model.IsDealer = IsDealer;
                IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
                //如果是普通用户则检查过滤该用户是否能够看到该Dealer
                if (_context.User.IdentityType == IdentityType.User.ToString())
                {
                    var query = from p in dataSource
                                where p.ActiveFlag == true
                                select p;
                    dataSource = query.ToList<DealerMaster>();
                }
                model.LstDealer = new ArrayList(dataSource.ToList());

                model.LstBu = base.GetProductLine();
                IList<DictionaryDomain> dicts = DictionaryHelper.GetAllKeyValueList(SR.Consts_AdjustQty_Status);
                IList<DictionaryDomain> list = dicts.Where(item => item.DictKey != AdjustStatus.Reject.ToString() && item.DictKey != AdjustStatus.Submitted.ToString() && item.DictKey != AdjustStatus.Accept.ToString()).ToList();
                model.LstStatus = DictionaryHelper.GetKeyValueListByParams(list);


                DataTable dt = AuthorizationBLL.GetConsignmentMasterAll("Submit").Tables[0];
                model.LstConsignmentRules = JsonHelper.DataTableToArrayList(dt);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(ConsignmentAuthorizationListVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryBu.ToSafeString()))
                    if (model.QryBu.Value != "全部" && model.QryBu.Key != "")
                        param.Add("ProductLine", model.QryBu.Key.ToSafeString());
                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()))
                    if (model.QryDealer.Value != "全部" && model.QryDealer.Key != "")
                        param.Add("DealreId", model.QryDealer.Key);
                if (!string.IsNullOrEmpty(model.LstConsignmentRules.ToSafeString()))
                    if (model.QryConsignmentRules.Value != "全部" && model.QryConsignmentRules.Key != "")
                        param.Add("CmId", model.QryConsignmentRules.Key);
                if (!string.IsNullOrEmpty(model.QryStatus.ToSafeString()))
                    if (model.QryStatus.Value != "全部" && model.QryStatus.Key != "")
                        param.Add("IsActive", model.QryStatus.Key);
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = AuthorizationBLL.QuqerConsignmentAuthorizationby(param, start, model.PageSize, out totalCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
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

        public ConsignmentAuthorizationListVO LayoutInit(ConsignmentAuthorizationListVO model)
        {
            try
            {
                InventoryAdjustHeaderDao ContractHeader = new InventoryAdjustHeaderDao();
                if (IsDealer)
                {
                    Hashtable tb = new Hashtable();
                    tb.Add("OwnerCorpId", UserInfo.CorpId.ToSafeString());
                    model.WLstDealer = JsonHelper.DataTableToArrayList(ContractHeader.QueryDealer(tb));
                }
                else
                {
                    model.WLstDealer = JsonHelper.DataTableToArrayList(ContractHeader.QueryDealer(new Hashtable()));
                }
                IList<DictionaryDomain> dicts = DictionaryHelper.GetAllKeyValueList(SR.Consts_AdjustQty_Status);
                IList<DictionaryDomain> list = dicts.Where(item => item.DictKey != AdjustStatus.Reject.ToString() && item.DictKey != AdjustStatus.Submitted.ToString() && item.DictKey != AdjustStatus.Accept.ToString()).ToList();
                model.WLstStatus = DictionaryHelper.GetKeyValueListByParams(list);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        //新增，根据经销商获取产品线
        public ConsignmentAuthorizationListVO LayoutInitProductBind(ConsignmentAuthorizationListVO model)
        {
            DataSet ds = AuthorizationBLL.GetDelareProductLineby(model.WQryDealer.Key);
            model.WLstBu = JsonHelper.DataTableToArrayList(ds.Tables[0]);
            return model;
        }
        //新增，根据经销商获取短期寄售名称
        public ConsignmentAuthorizationListVO LayoutInitChoiceConsignmenBind(ConsignmentAuthorizationListVO model)
        {
            DataSet ds = AuthorizationBLL.GetProductLineConsignmenby(model.WQryBu.Key, model.WQryDealer.Key);
            model.WLstConsignmentRules = JsonHelper.DataTableToArrayList(ds.Tables[0]);
            return model;
        }
        public ConsignmentAuthorizationListVO PreviewQuery(ConsignmentAuthorizationListVO model)
        {
            try
            {
                Hashtable param = new Hashtable();

                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId.ToString()) ? Guid.Empty : new Guid(model.InstanceId.ToString());
                DataSet ds = AuthorizationBLL.SelecConsignmentAuthorizationby(InstanceId.ToString());
                if (ds != null)
                {
                    if (ds.Tables.Count > 0)
                    {
                        model.WRstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                        model.IsSuccess = true;
                    }
                }
                InventoryAdjustHeaderDao ContractHeader = new InventoryAdjustHeaderDao();
                if (IsDealer)
                {
                    Hashtable tb = new Hashtable();
                    tb.Add("OwnerCorpId", UserInfo.CorpId.ToSafeString());
                    model.WLstDealer = JsonHelper.DataTableToArrayList(ContractHeader.QueryDealer(tb));
                }
                else
                {
                    model.WLstDealer = JsonHelper.DataTableToArrayList(ContractHeader.QueryDealer(new Hashtable()));
                }
                IList<DictionaryDomain> dicts = DictionaryHelper.GetAllKeyValueList(SR.Consts_AdjustQty_Status);
                IList<DictionaryDomain> list = dicts.Where(item => item.DictKey != AdjustStatus.Reject.ToString() && item.DictKey != AdjustStatus.Submitted.ToString() && item.DictKey != AdjustStatus.Accept.ToString()).ToList();
                model.WLstStatus = DictionaryHelper.GetKeyValueListByParams(list);

                DataSet dsProductLine = AuthorizationBLL.GetDelareProductLineby(ds.Tables[0].Rows[0]["CA_DMA_ID"].ToString());
                model.WLstBu = JsonHelper.DataTableToArrayList(dsProductLine.Tables[0]);
                DataTable dt = AuthorizationBLL.GetProductLineConsignmenby(ds.Tables[0].Rows[0]["CA_ProductLine_Id"].ToString(), ds.Tables[0].Rows[0]["CA_DMA_ID"].ToString()).Tables[0];
                model.WLstConsignmentRules = JsonHelper.DataTableToArrayList(dt);
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
        /// <summary>
        ///提交
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentAuthorizationListVO Sumbit(ConsignmentAuthorizationListVO model)
        {
            bool bl = false;

            ConsignmentMaster Cmast = new ConsignmentMaster();
            Cmast = AuthorizationBLL.GetConsignmentMasterKey(new Guid(model.WQryConsignmentRules.Key));
            Guid InstanceId = new Guid(model.InstanceId);
            DateTime dtStartDate = DateTime.Parse(model.WQryBeginDate);
            DateTime dtEndDate = DateTime.Parse(model.WQryEndDate);
            if (InstanceId == Guid.Empty)
            {
                Hashtable ht = new Hashtable();
                ht.Add("DMAID", model.WQryDealer.Key);
                ht.Add("ProductLineId", model.WQryBu.Key);
                ht.Add("CMID", model.WQryConsignmentRules.Key);
                ht.Add("IsActive", true);
                ht.Add("StartDate", dtStartDate);
                ht.Add("EndDate", dtEndDate);
                ht.Add("Remark", "");
                ht.Add("UserId", RoleModelContext.Current.User.Id);
                ht.Add("CMStartDate", Cmast.StartDate);
                ht.Add("CMEndDate", Cmast.EndDate);
                if ((dtStartDate >= Cmast.StartDate && dtStartDate <= Cmast.EndDate) && (dtEndDate >= Cmast.StartDate && dtEndDate <= Cmast.EndDate))
                {
                    DataSet Cds = AuthorizationBLL.SelecConsignmentAuthorizationCount(ht);
                    if (int.Parse(Cds.Tables[0].Rows[0]["Cnt"].ToString()) == 0)
                    {
                        bl = AuthorizationBLL.InsertConsignmentAuthorizationby(ht);
                        model.IsSuccess = true;
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("该产品线和经销商已经授权");
                        return model;
                    }
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("开始时间和结束时间必须在寄售规则时间内");
                    return model;
                }

            }
            else
            {
                if ((dtStartDate >= Cmast.StartDate && dtStartDate <= Cmast.EndDate) && (dtEndDate >= Cmast.StartDate && dtEndDate <= Cmast.EndDate))
                {
                    Hashtable tb = new Hashtable();
                    tb.Add("StartDate", dtStartDate);
                    tb.Add("EndDate", dtEndDate);
                    tb.Add("CAID", InstanceId);
                    bl = AuthorizationBLL.UpdateConsignmentAuthorizationby(tb);
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("开始时间和结束时间必须在寄售规则时间内");
                    return model;
                }
            }
            return model;
        }
        /// <summary>
        /// 终止
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentAuthorizationListVO Stop(ConsignmentAuthorizationListVO model)
        {
            bool bl = false;
            bl = AuthorizationBLL.Updatstopby(model.InstanceId);
            if (bl)
            {
                model.IsSuccess = true;
            }
            return model;
        }

        /// <summary>
        /// 恢复
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentAuthorizationListVO recovery(ConsignmentAuthorizationListVO model)
        {

            bool bl = false;
            bl = AuthorizationBLL.Updatrecoveryby(model.InstanceId);
            if (bl)
            {
                model.IsSuccess = true;
            }
            return model;
        }

    }
}

