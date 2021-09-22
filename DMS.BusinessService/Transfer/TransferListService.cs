using DMS.Business;
using DMS.Business.Excel;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model;
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
    public class TransferListService : ABaseQueryService, IQueryExport, IDealerFilterFac
    {
        #region Ajax Method
        private ITransferBLL business = new TransferBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();

        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter(); 
        }
        public TransferListVO Init(TransferListVO model)
        {
            try
            {
                IRoleModelContext _context = RoleModelContext.Current;
                model.InsertEnable = IsDealer;
                model.IsDealer = IsDealer;
                model.LstBu = base.GetProductLine();
                model.LstStatus = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_DealerTransfer_Status).ToArray());
                //借货单类型
                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_TransferOrder_Type);
                var list = from t in dicts where t.Key != TransferType.Transfer.ToString() select t;
                list = from t in list where t.Key != TransferType.TransferConsignment.ToString() select t;
                model.LstType = new ArrayList(list.ToList());
                model.LstDealer = new ArrayList(DealerList().ToList());
                //借入经销商
                if (IsDealer)
                {
                    if (_context.User.CorpType == DealerType.LP.ToString() || _context.User.CorpType == DealerType.LS.ToString())
                    {
                        model.InsertEnable = false;
                    }

                    model.QryDealerFrom = new KeyValue(base.UserInfo.CorpId.ToSafeString(), base.UserInfo.CorpName);
                    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_TRANSFER);

                    string InitDealerId = RoleModelContext.Current.User.CorpId.Value.ToString();
                    model.hidInitDealerId = InitDealerId;
                    Guid DealerFromId = Guid.Empty;
                    if (!string.IsNullOrEmpty(InitDealerId))
                    {
                        DealerFromId = new Guid(InitDealerId);
                    }
                    IList<DealerMaster> Todicts = new DealerMasters().QueryDealerMasterForTransferByDealerFromId(DealerFromId);
                    model.LstToDealer = new ArrayList(Todicts.ToList());
                }
                //控制查询按钮
                Permissions pers = RoleModelContext.Current.User.GetPermissions();
                model.ShowSerch = pers.IsPermissible(Business.TransferBLL.Action_TransferRent, PermissionType.Read);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(TransferListVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryBu.ToSafeString()))
                    if (model.QryBu.Value != "全部" && model.QryBu.Key != "")
                        param.Add("ProductLine", model.QryBu.Key);

                if (!string.IsNullOrEmpty(model.QryDealerFrom.ToSafeString()))
                    if (model.QryDealerFrom.Value != "全部" && model.QryDealerFrom.Key != "")
                    {
                        param.Add("FromDealerDmaId", model.QryDealerFrom.Key);
                    }
                if (!string.IsNullOrEmpty(model.QryDealerTo.ToSafeString()))
                    if (model.QryDealerTo.Value != "全部" && model.QryDealerTo.Key != "")
                    {
                        param.Add("ToDealerDmaId", model.QryDealerTo.Key);
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
                    transferType[0] = TransferType.Rent.ToString();
                    transferType[1] = TransferType.RentConsignment.ToString();
                    param.Add("Type", transferType);
                }
                if (!string.IsNullOrEmpty(model.QryLPUploadNo))
                {
                    param.Add("LPUploadNo", model.QryLPUploadNo);
                }

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryTransferRent(param, start, model.PageSize, out totalCount);
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
            }
            if (!string.IsNullOrEmpty(Parameters["DealerTo"].ToSafeString()))
            {
                param.Add("ToDealerDmaId", Parameters["DealerTo"].ToSafeString());
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
                transferType[0] = TransferType.Rent.ToString();
                transferType[1] = TransferType.RentConsignment.ToString();
                param.Add("Type", transferType);
            }
            if (!string.IsNullOrEmpty(Parameters["LPUploadNo"].ToSafeString()))
            {
                param.Add("LPUploadNo", Parameters["LPUploadNo"].ToSafeString());
            }

            DataSet ds = business.SelectByFilterTransferExport(param);
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("TransferList");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        #endregion

    }
}
