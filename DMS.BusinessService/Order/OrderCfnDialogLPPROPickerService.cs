using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.ViewModel.Order;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Order
{
    public class OrderCfnDialogLPPROPickerService : ABaseQueryService
    {
        public OrderCfnDialogLPPROPickerVO Init(OrderCfnDialogLPPROPickerVO model)
        {
            try
            {
                ICfns business = new Cfns();
                DataTable dt = new DataTable();
                Hashtable obj = new Hashtable();
                obj.Add("DealerId", model.QryDealer);
                obj.Add("ProductLineId", model.QryProductLine);
                obj.Add("GivenType", "FreeGoods");

                DataSet ds = business.QueryPromotionProductLineType(obj);
                if (ds != null)
                {
                    dt = ds.Tables[0];
                    model.RstProProductTypeList = JsonHelper.DataTableToArrayList(dt);
                    if (dt.Rows.Count > 0)
                    {
                        model.QryLeftNum = dt.Rows[0]["LeftNum"].ToString();
                        model.QryDescription = dt.Rows[0]["Description"].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }
        public string Query(OrderCfnDialogLPPROPickerVO model)
        {
            try
            {
                //经销商下订单的时候可以看到所有的产品，但是只能选择授权范围内，且产品表中可下订的产品

                string[] strCriteria;
                int iCriteriaNbr;
                ICfns business = new Cfns();

                int totalCount = 0;

                Hashtable param = new Hashtable();

                //参数：产品线
                if (!string.IsNullOrEmpty(model.QryProductLine))
                {
                    param.Add("ProductLineId", model.QryProductLine);
                }

                //参数：CFN（UPN）
                if (!string.IsNullOrEmpty(model.QryCFN))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.QryCFN);
                    foreach (string strCFN in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strCFN))
                        {
                            iCriteriaNbr++;
                            //如果strCFN是以+开头的，代表是HIBC码，则去掉第一位和最后一位
                            if (strCFN.Substring(0, 1) == "+" && strCFN.Length > 2)
                            {
                                param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN.Substring(1, strCFN.Length - 2));
                            }
                            else
                            {
                                param.Add(string.Format("ProductCFN{0}", iCriteriaNbr), strCFN);
                            }
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("ProductCFN", "HasCFNCriteria");
                }

                //参数：经销商ID
                if (!string.IsNullOrEmpty(model.QryDealer))
                {
                    param.Add("DealerId", new Guid(model.QryDealer));
                }

                //参数（新增）：产品名称
                if (!string.IsNullOrEmpty(model.QryCFNName))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.QryCFNName);
                    foreach (string strCFNName in strCriteria)
                    {
                        if (!string.IsNullOrEmpty(strCFNName))
                        {
                            iCriteriaNbr++;
                            param.Add(string.Format("ProductCFNName{0}", iCriteriaNbr), strCFNName);
                        }
                    }
                    if (iCriteriaNbr > 0) param.Add("ProductCFNName", "HasCFNNameCriteria");
                }


                //参数（新增）：是否只显示可订产品
                if (model.DisplayCanOrder)
                {
                    param.Add("DisplayCanOrder", 1);
                }
                else
                {
                    param.Add("DisplayCanOrder", 0);
                }

                //参数(新增)：价格类型，根据订单类型
                if (!string.IsNullOrEmpty(model.hidPriceTypeId))
                {
                    //param.Add("PriceType", this.hidPriceTypeId.Text);
                    //Modified by SongWeiming on 2015-02-03 ,系统中的特殊价格政策或促销政策都是取经销商的价格
                    param.Add("PriceType", "Dealer");
                }
                //参数(新增)：清指定批号订单
                if (!string.IsNullOrEmpty(model.hidOrderType))
                {
                    if (model.hidOrderType.Equals("ClearBorrow") || model.hidOrderType.Equals("ClearBorrowManual"))
                    {
                        param.Add("IsClearBorrow", "True");
                    }
                }

                //参数：赠品分类ID
                param.Add("DLid", model.QryProProductType.Key);
                DataSet ds = null;

                int start = (model.Page - 1) * model.PageSize;
                string ProductLine = model.QryProductLine;
                //已不使用
                if (model.chkShare)
                {
                    ds = business.QueryCfnForPurchaseOrderByShare(param, start, model.PageSize, out totalCount);
                }
                else
                {
                    ds = business.QueryCfnForPurchaseOrderT2ByPRO(param, start, model.PageSize, out totalCount);
                }

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
    }
}
