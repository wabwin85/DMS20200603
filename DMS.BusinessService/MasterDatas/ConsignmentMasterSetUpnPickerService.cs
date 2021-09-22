using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.ViewModel.MasterDatas;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.MasterDatas
{
    public class ConsignmentMasterSetUpnPickerService : ABaseQueryService
    {
        public ICfns Basebll = new Cfns();
        public ICfnSetBLL CfnSetbl = new CfnSetBLL();
        public string Init(ConsignmentMasterSetUpnPickerVO model)
        {
            try
            {
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                string ProductLine = model.QryProductLine;
                DataSet ds = Basebll.QueryConsignmentCfnSetBy(ProductLine, start, model.PageSize, out totalCount);
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

        public ConsignmentMasterSetUpnPickerVO Query(ConsignmentMasterSetUpnPickerVO model)
        {
            try
            {
                string id = model.CfnSetId;
                int totalCount = 0;
                //int start = (model.Page - 1) * model.PageSize;
                int start = 0;//原始js无法解析json分页类型
                model.PageSize = int.MaxValue;
                DataSet ds = CfnSetbl.QueryConsignmenCfnSetDetailByCFNSID(id, start, model.PageSize, out totalCount);
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
