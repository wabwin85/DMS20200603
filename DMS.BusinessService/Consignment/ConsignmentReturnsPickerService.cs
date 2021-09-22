using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.Model.Data;
using DMS.ViewModel.Consignment;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Consignment
{
    public class ConsignmentReturnsPickerService : ABaseQueryService
    {
        public IConsignmentApplyHeaderBLL Bll = new ConsignmentApplyHeaderBLL();
        public string Init(ConsignmentReturnsPickerVO model)
        {
            try
            {
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                Hashtable table = new Hashtable();
                table.Add("IAHDMAId", model.hidIahDmaId);
                table.Add("LOTDMAId", model.hidDealerId);
                table.Add("ProductLineId", model.hidProductLine);
                table.Add("CMID", model.hidCmId);
                DataSet ds = Bll.QueryInventoryAdjustHeaderList(table, start, model.PageSize, out totalCount);
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

        public ConsignmentReturnsPickerVO Query(ConsignmentReturnsPickerVO model)
        {
            try
            {
                string id = model.CfnSetId;//IAHId
                int totalCount = 0;
                //int start = (model.Page - 1) * model.PageSize;
                int start = 0;//原始js无法解析json分页类型
                model.PageSize = int.MaxValue;
                DataSet ds = Bll.QueryInventoryAdjustCfnList(id, start, model.PageSize, out totalCount);
                model.RstResultDetailList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                model.DataCount = totalCount;
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




    }
}
