using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.Model.Data;
using DMS.ViewModel.Order;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Order
{
    public class OrderCfnSetDialogLPPickerService : ABaseQueryService
    {
        private ICfnSetBLL business = new CfnSetBLL();
        /// <summary>
        /// 查询
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public string SerarchQuery(OrderCfnSetDialogLPPickerVO model)
        {
            try
            {
                string id = model.CfnSetId;
                int totalCount = 0;

                //如果订单类型是成套设备订单，则可以选择成套产品
                if (!string.IsNullOrEmpty(model.hidOrderTypeId) && (model.hidOrderTypeId.Equals(PurchaseOrderType.BOM.ToString())))
                {
                    Hashtable param = new Hashtable();

                    if (!string.IsNullOrEmpty(model.QryDealer))
                    {
                        param.Add("DealerId", new Guid(model.QryDealer));
                    }
                    if (!string.IsNullOrEmpty(model.QryProductLine))
                    {
                        param.Add("ProductLineId", model.QryProductLine);
                    }
                    //参数(新增)：价格类型，根据订单类型
                    if (!string.IsNullOrEmpty(model.hidPriceTypeId))
                    {
                        param.Add("PriceType", model.hidPriceTypeId);
                    }
                    if (!string.IsNullOrEmpty(model.QryProtectName))
                    {
                        param.Add("ProtectName", model.QryProtectName);
                    }

                    if (!string.IsNullOrEmpty(model.QryUpn))
                    {
                        param.Add("ProtectCode", model.QryUpn);

                    }

                    int start = (model.Page - 1) * model.PageSize;
                    DataSet ds = business.QueryCfnSetForPurchaseOrderByAuth(param, start, model.PageSize, out totalCount);
                    model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                    model.DataCount = totalCount;
                }
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
        /// <summary>
        /// 明细
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderCfnSetDialogLPPickerVO Query(OrderCfnSetDialogLPPickerVO model)
        {
            try
            {
                string id = model.CfnSetId;
                int totalCount = 0;
                //int start = (model.Page - 1) * model.PageSize;
                int start = 0;//原始js无法解析json分页类型
                model.PageSize = int.MaxValue;
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryDealer))
                {
                    param.Add("DealerId", new Guid(model.QryDealer));
                }
                if (!string.IsNullOrEmpty(model.QryProductLine))
                {
                    param.Add("ProductLineId", model.QryProductLine);
                }
                if (!string.IsNullOrEmpty(id))
                {
                    param.Add("CfnSetId", id);
                }
                //参数(新增)：价格类型，根据订单类型
                if (!string.IsNullOrEmpty(model.hidPriceTypeId))
                {
                    param.Add("PriceType", model.hidPriceTypeId);
                }

                DataSet ds = business.QueryCFNSetDetailForPurchaseOrderByAuth(param, start, model.PageSize, out totalCount);
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
        public OrderCfnSetDialogLPPickerVO DoAddCfnSet(OrderCfnSetDialogLPPickerVO model)
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
