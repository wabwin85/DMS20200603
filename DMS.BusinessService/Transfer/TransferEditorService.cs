using DMS.Business;
using DMS.Business.Excel;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Transfer;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Transfer
{
    public class TransferEditorService : ABaseQueryService, IQueryExport, IDealerFilterFac
    {
        #region Ajax Method
        private ITransferBLL business = new TransferBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();

        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter(); 
        }
        public TransferEditorVO Init(TransferEditorVO model)
        {
            try
            {
                IRoleModelContext _context = RoleModelContext.Current;
                model.InsertEnable = _context.IsInRole("Administrators") || _context.IsInRole("经销商短期寄售管理员");
                InventoryAdjustHeaderDao ContractHeader = new InventoryAdjustHeaderDao();
                model.IsDealer = IsDealer;
                if (IsDealer)
                {
                    model.hidInitDealerId = RoleModelContext.Current.User.CorpId.Value.ToString();
                    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_RENT);
                }
                model.LstDealer = new ArrayList(DealerList().ToList());
                model.LstBu = base.GetProductLine();
                model.LstStatus = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Status).ToArray());
                //类型,20191109, TransferConsignment,排除寄售移库
                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Type);
                var list = from t in dicts where t.Key != TransferType.Rent.ToString() select t;
                list = from t in list where t.Key != TransferType.RentConsignment.ToString() && t.Key != TransferType.TransferConsignment.ToString() select t;
                model.LstType = new ArrayList(list.ToList());
                //控制查询按钮
                Permissions pers = RoleModelContext.Current.User.GetPermissions();
                model.ShowSerch = pers.IsPermissible(Business.TransferBLL.Action_TransferApply, PermissionType.Read);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(TransferEditorVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryBu.ToSafeString()))
                    if (model.QryBu.Value != "全部" && model.QryBu.Key != "")

                        param.Add("ProductLine", model.QryBu.Key);

                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()))
                    if (model.QryDealer.Value != "全部" && model.QryDealer.Key != "")
                    {
                        param.Add("FromDealerDmaId", model.QryDealer.Key);
                        param.Add("QueryType", "LPHQ");
                    }

                if (!string.IsNullOrEmpty(model.QryApplyDate.StartDate.ToSafeString()))
                {
                    param.Add("TransferDateStart", Convert.ToDateTime(model.QryApplyDate.StartDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryApplyDate.EndDate.ToSafeString()))
                {
                    param.Add("TransferDateEnd", Convert.ToDateTime(model.QryApplyDate.EndDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryTransferNumber.ToSafeString()))
                {
                    param.Add("TransferNumber", model.QryTransferNumber);
                }
                if (!string.IsNullOrEmpty(model.QryTransferStatus.ToSafeString()))
                    if (model.QryTransferStatus.Value != "全部" && model.QryTransferStatus.Key != "")
                        param.Add("Status", model.QryTransferStatus.Key);

                if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                {
                    param.Add("Cfn", model.QryCFN);
                }
                //if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                //{
                //    param.Add("Upn", model.QryCFN);
                //}
                if (!string.IsNullOrEmpty(model.QryLotNumber.ToSafeString()))
                {
                    param.Add("LotNumber", model.QryLotNumber);
                }
                //不选则查询除了Rent外的2种类型
                string[] transferType = new string[2];
                if (!string.IsNullOrEmpty(model.QryTransferType.Key))
                {
                    transferType[0] = model.QryTransferType.Key;
                    param.Add("Type", transferType);
                }
                else
                {
                    transferType[0] = TransferType.Transfer.ToString();
                    transferType[1] = TransferType.TransferConsignment.ToString();
                    param.Add("Type", transferType);
                }

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryTransfer(param, start, model.PageSize, out totalCount);
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
            if (!string.IsNullOrEmpty(Parameters["Dealer"].ToSafeString()))
            {
                param.Add("FromDealerDmaId", Parameters["Dealer"].ToSafeString());
                param.Add("QueryType", "LPHQ");
            }
            if (!string.IsNullOrEmpty(Parameters["TransferDateStart"].ToSafeString()))
            {
                param.Add("TransferDateStart", Parameters["TransferDateStart"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["TransferDateEnd"].ToSafeString()))
            {
                param.Add("TransferDateEnd", Parameters["TransferDateEnd"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["TransferNumber"].ToSafeString()))
            {
                param.Add("TransferNumber", Parameters["TransferNumber"].ToSafeString());
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
            //不选则查询除了Rent外的2种类型
            string[] transferType = new string[2];
            if (!string.IsNullOrEmpty(Parameters["TransferType"].ToSafeString()))
            {
                transferType[0] = Parameters["TransferType"].ToSafeString();
                param.Add("Type", transferType);
            }
            else
            {
                transferType[0] = TransferType.Transfer.ToString();
                transferType[1] = TransferType.TransferConsignment.ToString();
                param.Add("Type", transferType);
            }

            DataSet ds = business.SelectByFilterTransferForExport(param);
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("TransferEditor");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        #endregion
    }
}
