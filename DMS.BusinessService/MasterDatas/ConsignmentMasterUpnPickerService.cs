using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.ViewModel.MasterDatas;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.MasterDatas
{
    public class ConsignmentMasterUpnPickerService : ABaseQueryService
    {
        IRoleModelContext _context = RoleModelContext.Current;
        public string Query(ConsignmentMasterUpnPickerVO model)
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
                if (!string.IsNullOrEmpty(model.QryCFNCode))
                {
                    iCriteriaNbr = 0;
                    strCriteria = oneRecord(model.QryCFNCode);
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
                param.Add("PriceType", "Dealer");
                //价格获取参数 20191030
                param.Add("DealerId", _context.User.CorpId);

                DataSet ds = null;
                //根据传入的是否特殊价格订单的选择项来确定获取哪些信息
                //if (this.chkShare.Checked)
                //{
                //    //共享产品，当前不使用
                //    ds = business.QueryCfnForPurchaseOrderByShare(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
                //}
                //  else
                // {
                int start = (model.Page - 1) * model.PageSize;
                string ProductLine = model.QryProductLine;
                ds = business.QueryCfnForConsignmentMaster(param, start, model.PageSize, out totalCount);
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
