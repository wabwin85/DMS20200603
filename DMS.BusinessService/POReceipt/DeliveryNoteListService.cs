using DMS.Business;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.ViewModel.Common;
using DMS.ViewModel.POReceipt;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.POReceipt
{
    public class DeliveryNoteListService : ABaseQueryService, IDealerFilterFac
    {
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public DeliveryNoteListVO Init(DeliveryNoteListVO model)
        {
            try
            {
                InventoryAdjustHeaderDao ContractHeader = new InventoryAdjustHeaderDao();
                //if (IsDealer)
                //{
                //    Hashtable tb = new Hashtable();
                //    tb.Add("OwnerCorpId", UserInfo.CorpId.ToSafeString());
                //    model.LstDealer = JsonHelper.DataTableToArrayList(ContractHeader.QueryDealer(tb));
                //}
                //else
                //{
                //    model.LstDealer = JsonHelper.DataTableToArrayList(ContractHeader.QueryDealer(new Hashtable()));
                //}
                model.LstDealer = new ArrayList(DealerList().ToList());
                model.IsDealer = IsDealer;
                ArrayList arr = new ArrayList();
                List<KeyValue> type = new List<KeyValue>();
                type.Add(new KeyValue("1", "经销商不存在"));
                type.Add(new KeyValue("1", "产品型号不存在"));
                type.Add(new KeyValue("1", "产品线未关联"));
                type.Add(new KeyValue("1", "未做授权"));
                type.Add(new KeyValue("1", "与经销商开帐日不匹配"));
                arr.AddRange(type);
                model.LstQType = arr;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(DeliveryNoteListVO model)
        {
            try
            {
                IDeliveryNotes business = new DeliveryNotes();

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryType.ToSafeString()))
                    if (model.QryType.Value != "全部" && model.QryType.Key != "")
                        param.Add("Type", model.QryType.Value.ToSafeString());
                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()))
                    if (model.QryDealer.Value != "全部" && model.QryDealer.Key != "")
                        param.Add("DealerId", model.QryDealer.Key);
                if (!string.IsNullOrEmpty(model.QrySapCode.ToSafeString()))
                    param.Add("SapCode", model.QrySapCode);
                if (!string.IsNullOrEmpty(model.QryDeliveryNoteNbr.ToSafeString()))
                    param.Add("DeliveryNoteNbr", model.QryDeliveryNoteNbr);
                if (!string.IsNullOrEmpty(model.QryPONbr.ToSafeString()))
                    param.Add("PoNbr", model.QryPONbr);
                if (!string.IsNullOrEmpty(model.QryPOreceiptDate.StartDate.ToSafeString()))
                    param.Add("ShipmentDateStart", model.QryPOreceiptDate.StartDate);
                if (!string.IsNullOrEmpty(model.QryPOreceiptDate.EndDate.ToSafeString()))
                    param.Add("ShipmentDateEnd", model.QryPOreceiptDate.EndDate);

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryDeliveryNote(param, start, model.PageSize, out totalCount);
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
            var result = new { success = model.IsSuccess, data = data, ExecuteMessage = model.ExecuteMessage };
            return JsonConvert.SerializeObject(result);
        }
    }
}
