using System;
using DMS.Common.Common;
using DMS.Common;
using System.Data;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Business.DealerTrain;
using DMS.ViewModel.MasterDatas;
using DMS.DataAccess.ContractElectronic;
using System.Collections;
using DMS.Business;
using DMS.DataAccess;
using DMS.ViewModel.POreceipt;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using DMS.Business.DataInterface;

namespace DMS.BusinessService.POReceipt
{
    public class POReceiptDeliveryImportService : ABaseQueryService
    {
        #region Ajax Method
        private IRoleModelContext _context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public POReceiptDeliveryImportVO Init(POReceiptDeliveryImportVO model)
        {
            try
            {
                AutoNumberBLL autoNbr = new AutoNumberBLL();
                model.AutoNbr = autoNbr.GetNextAutoNumberForInt("BP", DataInterfaceType.BSCDeliveryUploader);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        public string Query(POReceiptDeliveryImportVO model)
        {
            try
            {
                DeliveryNoteDao business = new DeliveryNoteDao();

                Hashtable ht = new Hashtable();
                ht.Add("AutoNbr", model.OldAutoNbr);
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.SelectDeliveryNoteByBatchNbr(ht,start, model.PageSize, out outCont);
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
        
        #endregion
    }


}
