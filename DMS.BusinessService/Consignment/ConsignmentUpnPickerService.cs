using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.Consignment;
using DMS.ViewModel.Consignment;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Consignment
{
    public class ConsignmentUpnPickerService : ABaseQueryService
    {
        public ICfns Basebll = new Cfns();
        public ICfnSetBLL CfnSetbl = new CfnSetBLL();
        public string Init(ConsignmentUpnPickerVO model)
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

        public ConsignmentUpnPickerVO Query(ConsignmentUpnPickerVO model)
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

        /// <summary>
        /// 添加功能
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentUpnPickerVO DoAddCfnSet(ConsignmentUpnPickerVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                Guid HeaderId = new Guid(model.InstanceId);
                Guid DealerId = new Guid(model.QryDealer);
                string parms = model.Param.Substring(0, model.Param.Length - 1);
                (new ConsignmentApplyDetailsBLL()).AddCfnSet(HeaderId, DealerId, parms, "", out rtnVal, out rtnMsg);
                //this.hidRtnVal.Text = rtnVal;
                //this.hidRtnMsg.Text = rtnMsg.Replace("$$", "<BR/>");
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
