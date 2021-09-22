using DMS.Business;
using DMS.Business.Excel;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Inventory;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Inventory
{
    public class InventoryReturnService : ABaseQueryService, IQueryExport, IDealerFilterFac
    {
        #region Ajax Method
        private IInventoryAdjustBLL business = new InventoryAdjustBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public InventoryReturnVO Init(InventoryReturnVO model)
        {
            try
            {
                model.InsertVisible = IsDealer;
                model.InsertConsignment = IsDealer;
                model.IsDealer = IsDealer;
                model.LstBu = base.GetProductLine();
                List<object> listDealerType = new List<object>
                        {
                            new {Key = "LP", Value = "LP"},
                            new {Key = "T1", Value = "T1"},
                            new {Key = "T2", Value = "T2"}
                        };
                model.LstDealerType = new ArrayList(listDealerType);
                if (IsDealer)
                {
                    if (_context.User.CorpType == DealerType.HQ.ToString())
                    {
                        model.InsertVisible = false;
                    }
                    //Added By Song Yuqi On 20140321 Begin
                    //只有二级经销商可以显示寄售退货按钮
                    model.InsertConsignment = true;
                    //this.btnImportConsignment.Visible = true;
                    model.InsertBorrow = false;
                    if (_context.User.CorpType != DealerType.T2.ToString())
                    {
                        model.InsertConsignment = false;
                        //this.btnImportConsignment.Visible = false;
                        //T1和LP显示短期寄售退货按钮
                        model.InsertBorrow = true;
                    }
                    //Added By Song Yuqi On 20140321 End
                    //this.cbDealer.Disabled = true;
                    //this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ADJUST);


                    //经销商选择
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        model.LstDealer = new ArrayList(DealerList().ToList());
                        model.DealerDisabled = true;
                        model.DealerId = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        model.LstDealer = new ArrayList(DealerListByFilter(true).ToList());
                        model.DealerDisabled = false;
                        model.DealerId = RoleModelContext.Current.User.CorpId.Value.ToString();
                        model.DealerListType = "3";
                    }
                    else
                    {
                        model.LstDealer = new ArrayList(DealerList().ToList());
                        model.DealerDisabled = false;
                        model.DealerId = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                }
                else
                {
                    if (_context.User.IdentityType == IdentityType.User.ToString())
                    {
                        model.InsertVisible = true;
                        model.InsertBorrow = true;
                        model.InsertConsignment = true;
                    }
                    model.LstDealer = new ArrayList(DealerList().ToList());
                    model.DealerDisabled = false;
                }
                if (_context.IsInRole("渠道管理员") || _context.IsInRole("Administrators"))
                {
                    model.BtnResultShow = true;
                }
                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                model.SearchVisible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Read);
                model.ExportVisible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryReturn, PermissionType.Read);
                //类型
                model.LstAdjustStatus = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_AdjustQty_Status).ToArray());
                //退货单类型
                List<object> list = new List<object>
                {
                    new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                    new {Value = "换货", Key = "Exchange"}

                };
                if (_context.User.CorpType == DealerType.LP.ToString() || _context.User.CorpType == DealerType.LS.ToString() || _context.User.CorpType == DealerType.T1.ToString())
                {
                    list.Add(new { Value = "转移给其他经销商", Key = "Transfer" });
                }
                list.Add(new { Value = "质量退换货", Key = "ZLReturn" });
                model.LstReturnType = new ArrayList(list.ToList());


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(InventoryReturnVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryBu.ToSafeString()))
                    if (model.QryBu.Value != "全部" && model.QryBu.Key != "")
                        param.Add("ProductLine", model.QryBu.Key.ToSafeString());
                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()))
                    if (model.QryDealer.Value != "全部" && model.QryDealer.Key != "")
                        param.Add("DealerId", model.QryDealer.Key);
                if (!string.IsNullOrEmpty(model.QryDealerType.ToSafeString()))
                    if (model.QryDealerType.Value != "全部" && model.QryDealerType.Key != "")
                        param.Add("DealerType", model.QryDealerType.Key);
                if (!string.IsNullOrEmpty(model.QryReturnType.ToSafeString()))
                    if (model.QryReturnType.Value != "全部" && model.QryReturnType.Key != "")
                        param.Add("Type", model.QryReturnType.Key);
                if (!string.IsNullOrEmpty(model.QryApplyDate.StartDate))
                    param.Add("CreateDateStart", model.QryApplyDate.StartDate);
                if (!string.IsNullOrEmpty(model.QryApplyDate.EndDate.ToSafeString()))
                    param.Add("CreateDateEnd", model.QryApplyDate.EndDate);
                if (!string.IsNullOrEmpty(model.QryAdjustNumber.ToSafeString()))
                    param.Add("AdjustNumber", model.QryAdjustNumber);
                if (!string.IsNullOrEmpty(model.QryAdjustStatus.ToSafeString()))
                    if (model.QryAdjustStatus.Value != "全部" && model.QryAdjustStatus.Key != "")
                        param.Add("Status", model.QryAdjustStatus.Key);
                if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                    param.Add("Cfn", model.QryCFN);
                //if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                //    param.Add("Upn", model.QryCFN);
                if (!string.IsNullOrEmpty(model.QryLotNumber.ToSafeString()))
                    param.Add("LotNumber", model.QryLotNumber);
                if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
                {
                    param.Add("LPId", RoleModelContext.Current.User.CorpId);
                }

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryInventoryAdjustHeaderReturn(param, start, model.PageSize, out totalCount);
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
            return JsonHelper.Serialize(result);
        }

        #endregion
        #region 下载
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["ProductLine"].ToSafeString()))
            {
                param.Add("ProductLine", Parameters["ProductLine"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["DealerId"].ToSafeString()))
            {
                param.Add("DealerId", Parameters["DealerId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["DealerType"].ToSafeString()))
            {
                param.Add("DealerType", Parameters["DealerType"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Type"].ToSafeString()))
            {
                param.Add("Type", Parameters["Type"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["CreateDateStart"].ToSafeString()))
            {
                param.Add("CreateDateStart", Parameters["CreateDateStart"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["CreateDateEnd"].ToSafeString()))
            {
                param.Add("CreateDateEnd", Parameters["CreateDateEnd"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["AdjustNumber"].ToSafeString()))
            {
                param.Add("AdjustNumber", Parameters["AdjustNumber"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Status"].ToSafeString()))
            {
                param.Add("Status", Parameters["Status"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Cfn"].ToSafeString()))
            {
                param.Add("Cfn", Parameters["Cfn"].ToSafeString());
            }
            //if (!string.IsNullOrEmpty(Parameters["Upn"].ToSafeString()))
            //{
            //    param.Add("Upn", Parameters["Upn"].ToSafeString());
            //}
            if (!string.IsNullOrEmpty(Parameters["LotNumber"].ToSafeString()))
            {
                param.Add("LotNumber", Parameters["LotNumber"].ToSafeString());
            }
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }

            DataSet ds = business.QueryInventoryReturnForExport(param);
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("InventoryReturn");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        #endregion
    }
}
