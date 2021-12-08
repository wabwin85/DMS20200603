using DMS.Business;
using DMS.DataAccess;
using DMS.ViewModel.Shipment.Extense;
using Grapecity.DataAccess.Transaction;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Shipment
{
    public class InvReconcileTaskService
    {
        private void IsExistInvRecDetailData(InvReconcileSummaryVO model)
        { 
            IInvReconcileBLL business = new InvReconcileBLL();
            DataSet dsTemp = business.QueryInvRecDetailTempByUser(new Guid( "c763e69b-616f-4246-8480-9df40126057c"));
            if (dsTemp.Tables[0].Rows.Count > 0)
            {
                DataTable dtTemp = dsTemp.Tables[0];
                foreach (DataRow dr in dtTemp.Rows)
                {
                    SaveCompareDataInTempTable(dr, model);
                }

            }

        }

        private DataSet GetRuleBySubCompany(InvReconcileSummaryVO model)
        {
            ReconcileRuleDao dao = new ReconcileRuleDao();
            int totalCount = 0;
            string subCompanyId = BaseService.CurrentSubCompany?.Key;
            if (subCompanyId == null)
                subCompanyId = "dc65a961-b92e-4639-9b82-abf701162396";
            Hashtable param = new Hashtable();
            param.Add("SubCompanyId", subCompanyId);
            int start = (model.Page - 1) * model.PageSize;
            param.Add("start", start);
            param.Add("limit", model.PageSize);
            DataSet ds = dao.SelectReconcileRuleBySubCompany(param, start, model.PageSize, out totalCount);
            return ds;
        }

        private DataSet GetRuleBySubCompanyName(string subCompanyName)
        {
            ReconcileRuleDao dao = new ReconcileRuleDao(); 
            Hashtable param = new Hashtable();
            param.Add("SubCompanyName", subCompanyName); 
            DataSet ds = dao.SelectReconcileRuleBySubCompany(param);
            return ds;
        }

        private void SaveCompareDataInTempTable(DataRow drTemp, InvReconcileSummaryVO model)
        {
            string compareStatus = string.Empty;
            string compareInfos = string.Empty;
            IInvReconcileBLL business = new InvReconcileBLL();
            decimal tempQuantity = drTemp["TotalNumber"] == DBNull.Value ? 0 : decimal.Parse(drTemp["TotalNumber"].ToString(), CultureInfo.InvariantCulture);
            //找出发票明细中的quantity
            DataSet dsRule = GetRuleBySubCompanyName(model.SubCompanyName);
            Hashtable ht = new Hashtable();
            if (dsRule.Tables[0].Rows.Count > 0)
            {
                ht.Add("SPH_ID", drTemp["SPH_ID"].ToString());
                ht.Add("OrderNumber", drTemp["OrderNumber"].ToString());
                ht.Add("CFN", drTemp["CFN"].ToString());
                ht.Add("HospitalName", drTemp["HospitalName"].ToString());
                ht.Add("ProductLineId", drTemp["ProductLineId"].ToString());
                ht.Add("BrandName", model.BrandName);
                ht.Add("SubCompanyName", model.SubCompanyName);

                string rules = dsRule.Tables[0].Rows[0]["Rules"].ToString();
                string[] arr = rules.Split(',');
                if (arr[0] == "1")
                    ht.Add("ProductRule", "产品型号");
                else
                    ht.Add("ProductRule", string.Empty);
                if (arr[1] == "1")
                    ht.Add("InvoiceRule", "发票日期");
                else
                    ht.Add("InvoiceRule", string.Empty);
                if (arr[2] == "1")
                    ht.Add("HosRule", "销售医院");
                else
                    ht.Add("HosRule", string.Empty);
            }
            else
            {
                throw new Exception("规则没有查到");
            }
            DataSet dsDetail = business.QueryInvRecDetail(ht);


            if (dsDetail.Tables[0].Rows.Count > 0) // already exist
            {
                string RtnVal = "", RtnMsg = "";
                if (ht["ProductRule"].ToString() == "产品型号")
                {
                    DataTable dtInvCheck = business.QueryCheckInv(ht).Tables[0];
                    if (dtInvCheck.Rows.Count == 0)
                    {
                        compareStatus = "型号无法匹配";
                        compareInfos = "无法关联发票型号";
                        business.ExeUpdateCompareStatus(new Guid(drTemp["SPH_ID"].ToString()), drTemp["OrderNumber"].ToString(),
                    drTemp["CFN"].ToString(), new Guid(drTemp["ProductLineId"].ToString()), new Guid("c763e69b-616f-4246-8480-9df40126057c"), compareStatus, compareInfos, out RtnVal, out RtnMsg, true);
                        return;
                    }
                }
                if (ht["InvoiceRule"].ToString() == "发票日期")
                {
                    DataTable dtInvCheck = business.QueryCheckInv(ht).Tables[0];
                    if (dtInvCheck.Rows.Count > 0)
                    {
                        bool tag = false;
                        for (int i = 0; i < dtInvCheck.Rows.Count; i++)
                        {
                            int invoiceDateDiff = Convert.ToInt32(dtInvCheck.Rows[i]["InvoiceDateDiff"]);
                            if (invoiceDateDiff == 0)
                            {
                                tag = true;
                                break;
                            }
                        }
                        if (!tag)
                        {
                            compareStatus = compareInfos = "发票日期无法匹配";
                            business.ExeUpdateCompareStatus(new Guid(drTemp["SPH_ID"].ToString()), drTemp["OrderNumber"].ToString(),
                    drTemp["CFN"].ToString(), new Guid(drTemp["ProductLineId"].ToString()), new Guid("c763e69b-616f-4246-8480-9df40126057c"), compareStatus, compareInfos, out RtnVal, out RtnMsg, true);

                            return;
                        }
                    }
                }
                if (ht["HosRule"].ToString() == "销售医院")
                {
                    DataTable dtInvCheck = business.QueryCheckInv(ht).Tables[0];
                    if (dtInvCheck.Rows.Count > 0)
                    {
                        bool tag = false;
                        for (int i = 0; i < dtInvCheck.Rows.Count; i++)
                        {
                            string hospitalName = dtInvCheck.Rows[i]["InvoiceTitle"].ToString();
                            if (hospitalName == ht["HospitalName"].ToString())
                            {
                                tag = true;
                                break;
                            }
                        }
                        if (!tag)
                        {
                            compareInfos = compareStatus = "医院无法匹配";
                            business.ExeUpdateCompareStatus(new Guid(drTemp["SPH_ID"].ToString()), drTemp["OrderNumber"].ToString(),
                     drTemp["CFN"].ToString(), new Guid(drTemp["ProductLineId"].ToString()), new Guid("c763e69b-616f-4246-8480-9df40126057c"), compareStatus, compareInfos, out RtnVal, out RtnMsg, true);
                            return;
                        }
                    }
                }

                decimal invoiceTotal;
                DataTable dtInvQuantity = business.QueryInvTotalNumber(ht).Tables[0];
                decimal.TryParse(dtInvQuantity.Rows[0]["Quantity"].ToString(), out invoiceTotal);
                if (tempQuantity == invoiceTotal && invoiceTotal != 0)
                {
                    compareInfos = compareStatus = "已对账";

                }
                else
                {
                    if (invoiceTotal == 0 && tempQuantity != invoiceTotal)
                    {
                        compareInfos = "无对应发票";
                    }
                    else if (tempQuantity > invoiceTotal)
                    {
                        decimal quantity = tempQuantity - invoiceTotal;
                        compareInfos = $"销售出库单数量少{quantity}个";
                    }
                    else
                    {
                        decimal quantity = invoiceTotal - tempQuantity;
                        compareInfos = $"销售出库单数量多{quantity}";
                    }
                    compareStatus = "数量无法匹配";
                }
                business.ExeUpdateCompareStatus(new Guid(drTemp["SPH_ID"].ToString()), drTemp["OrderNumber"].ToString(),
                    drTemp["CFN"].ToString(), new Guid(drTemp["ProductLineId"].ToString()), new Guid("c763e69b-616f-4246-8480-9df40126057c"), compareStatus, compareInfos, out RtnVal, out RtnMsg, true);
            }
            else
            {
                string RtnVal = "", RtnMsg = "";
                if (ht["ProductRule"].ToString() == "产品型号")
                {
                    DataTable dtInvCheck = business.QueryCheckInv(ht).Tables[0];
                    if (dtInvCheck.Rows.Count == 0)
                    {
                        compareInfos = "无法关联发票型号";
                        compareStatus = "型号无法匹配";
                        business.ExeSaveCompareStatus(new Guid(drTemp["SPH_ID"].ToString()), drTemp["OrderNumber"].ToString(), drTemp["CFN"].ToString(), new Guid("c763e69b-616f-4246-8480-9df40126057c"), compareStatus, compareInfos, out RtnVal, out RtnMsg);
                        return;
                    }
                }
                if (ht["InvoiceRule"].ToString() == "发票日期")
                {
                    //htCheck.Add("InvoiceRule", "产品型号");
                    DataTable dtInvCheck = business.QueryCheckInv(ht).Tables[0];
                    if (dtInvCheck.Rows.Count > 0)
                    {
                        bool tag = false;
                        for (int i = 0; i < dtInvCheck.Rows.Count; i++)
                        {
                            int invoiceDateDiff = Convert.ToInt32(dtInvCheck.Rows[i]["InvoiceDateDiff"]);
                            if (invoiceDateDiff == 0)
                            {
                                tag = true;
                                break;
                            }
                        }
                        if (!tag)
                        {
                            compareInfos = compareStatus = "发票日期无法匹配";
                            business.ExeSaveCompareStatus(new Guid(drTemp["SPH_ID"].ToString()), drTemp["OrderNumber"].ToString(), drTemp["CFN"].ToString(), new Guid("c763e69b-616f-4246-8480-9df40126057c"), compareStatus, compareInfos, out RtnVal, out RtnMsg);
                            return;
                        }
                    }
                }
                if (ht["HosRule"].ToString() == "销售医院")
                {
                    //htCheck.Add("HosRule", "销售医院");
                    DataTable dtInvCheck = business.QueryCheckInv(ht).Tables[0];
                    if (dtInvCheck.Rows.Count > 0)
                    {
                        bool tag = false;
                        for (int i = 0; i < dtInvCheck.Rows.Count; i++)
                        {
                            string hospitalName = dtInvCheck.Rows[i]["InvoiceTitle"].ToString();
                            if (hospitalName == ht["HospitalName"].ToString())
                            {
                                tag = true;
                                break;
                            }
                        }
                        if (!tag)
                        {
                            compareInfos = compareStatus = "医院无法匹配";
                            business.ExeSaveCompareStatus(new Guid(drTemp["SPH_ID"].ToString()), drTemp["OrderNumber"].ToString(), drTemp["CFN"].ToString(), new Guid("c763e69b-616f-4246-8480-9df40126057c"), compareStatus, compareInfos, out RtnVal, out RtnMsg);
                            return;
                        }
                    }
                }

                decimal invoiceTotal;

                DataTable dtInvQuantity = business.QueryInvTotalNumber(ht).Tables[0];
                decimal.TryParse(dtInvQuantity.Rows[0]["Quantity"].ToString(), out invoiceTotal);

                if (tempQuantity == invoiceTotal && invoiceTotal != 0)
                {
                    compareInfos = compareStatus = "已对账";
                }
                else
                {
                    if (invoiceTotal == 0 && tempQuantity != invoiceTotal)
                    {
                        compareInfos = "无对应发票";
                    }

                    else if (tempQuantity > invoiceTotal)
                    {
                        decimal quantity = tempQuantity - invoiceTotal;
                        compareInfos = $"销售出库单数量少{quantity}个";
                    }
                    else
                    {
                        decimal quantity = invoiceTotal - tempQuantity;
                        compareInfos = $"销售出库单数量多{quantity}";
                    }
                    compareStatus = "数量无法匹配";
                }

                business.ExeSaveCompareStatus(new Guid(drTemp["SPH_ID"].ToString()), drTemp["OrderNumber"].ToString(), drTemp["CFN"].ToString(), new Guid("c763e69b-616f-4246-8480-9df40126057c"), compareStatus, compareInfos, out RtnVal, out RtnMsg);

            }
        }

        private bool InsertRecordsToTemp(InvReconcileSummaryVO model)
        {
            bool tag = false;
            if (!string.IsNullOrEmpty(model.Ids))
            {
                IInvReconcileBLL business = new InvReconcileBLL();
                //删除临时表中自己的相关数据
                int cnt = business.DeleteInvRecDetailTemp(new Guid("c763e69b-616f-4246-8480-9df40126057c"));
                //查出所有的产品主数据相关的信息

                DataSet ds = business.QueryProductDetail(model.Ids);
                //model.RstProductDetail = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                //List<InvReconcileDetailTemp> lstTemp = new List<InvReconcileDetailTemp>();
                using (TransactionScope trans = new TransactionScope())
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        DataTable dt = ds.Tables[0];
                        DataTable dtTemp = new DataTable();
                        dtTemp.Columns.Add("SPH_ID", typeof(Guid));
                        dtTemp.Columns.Add("CFN_ID", typeof(Guid));
                        dtTemp.Columns.Add("CFN", typeof(string));
                        dtTemp.Columns.Add("OrderNumber");
                        dtTemp.Columns.Add("CompareUser", typeof(Guid));
                        dtTemp.Columns.Add("DMA_ID", typeof(Guid));
                        dtTemp.Columns.Add("DMA_Name");
                        dtTemp.Columns.Add("HospitalName");
                        dtTemp.Columns.Add("Hospital_ID", typeof(Guid));
                        dtTemp.Columns.Add("ProductLineId", typeof(Guid));
                        dtTemp.Columns.Add("TotalNumber", typeof(decimal));
                        dtTemp.Columns.Add("IsDelete", typeof(bool));
                        dtTemp.Columns.Add("CompareStatus");
                        foreach (DataRow dr in dt.Rows)
                        {
                            DataRow drTemp = dtTemp.NewRow();
                            drTemp["SPH_ID"] = dr["Id"];
                            drTemp["CFN_ID"] = dr["CFN_ID"];
                            drTemp["CFN"] = dr["CFN"];
                            drTemp["OrderNumber"] = dr["OrderNumber"];
                            drTemp["CompareUser"] = new Guid("c763e69b-616f-4246-8480-9df40126057c");
                            drTemp["DMA_ID"] = dr["DealerId"];
                            drTemp["DMA_Name"] = dr["DealerName"];
                            drTemp["HospitalName"] = dr["HospitalName"];
                            drTemp["Hospital_ID"] = dr["Hos_ID"];
                            drTemp["ProductLineId"] = dr["ProductLineId"];
                            drTemp["TotalNumber"] = dr["ShipmentQty"];
                            drTemp["CompareStatus"] = "";
                            drTemp["IsDelete"] = false;
                            dtTemp.Rows.Add(drTemp);
                        }
                        tag = business.BatchInsertData(dtTemp);
                        trans.Complete();
                    }
                }

            }
            return tag;
        }

        public InvReconcileSummaryVO CompareInvReconcile(InvReconcileSummaryVO model)
        {
            try
            {
                //数据导入到临时表中
                if (model.IsSystemCompare == true)
                {
                    bool tag = InsertRecordsToTemp(model);
                    if (!tag)
                        throw new Exception("比对数据出错");
                    IsExistInvRecDetailData(model);
                    model.IsSuccess = true;
                }
                else
                {
                    IInvReconcileBLL business = new InvReconcileBLL();
                    business.UpdateInvRecDetail(model.DetailIds);
                    string ids = model.Ids;
                    string[] idArray = ids.Split(',');
                    if (idArray.Length > 0)
                    {
                        for (int i = 0; i < idArray.Length; i++)
                        {
                            string id = idArray[i];
                            DataTable dt = business.QueryProductDetail(id).Tables[0];
                            if (dt.Rows.Count > 0)
                            {
                                string recStatus = "";
                                for (int j = 0; j < dt.Rows.Count; j++)
                                {
                                    string tempstatus = dt.Rows[j]["CompareStatus"].ToString();
                                    if (!recStatus.Contains(tempstatus))
                                        recStatus += tempstatus;
                                }

                                Hashtable ht = new Hashtable();
                                if (recStatus.Contains("已对账") && !(recStatus.Contains("无法匹配")))
                                {
                                    ht.Add("CompareStatus", "已对账");
                                    ht.Add("CompareUser", "c763e69b-616f-4246-8480-9df40126057c");
                                    ht.Add("IsSystemCompare", false);
                                    ht.Add("Ids", model.Ids);
                                    business.UpdateInvRecSummary(ht);
                                    model.IsSuccess = true;
                                } 
                                else if (recStatus.Contains("无法匹配"))
                                {
                                    ht.Add("CompareStatus", "对账失败");
                                    ht.Add("CompareUser", "c763e69b-616f-4246-8480-9df40126057c");
                                    ht.Add("IsSystemCompare", false);
                                    ht.Add("Ids", model.Ids);
                                    business.UpdateInvRecSummary(ht);
                                    model.IsSuccess = true;
                                }
                                else
                                {
                                    ht.Add("CompareStatus", "未对账");
                                    ht.Add("CompareUser", "c763e69b-616f-4246-8480-9df40126057c");
                                    ht.Add("IsSystemCompare", false);
                                    ht.Add("Ids", model.Ids);
                                    business.UpdateInvRecSummary(ht);
                                    model.IsSuccess = true;
                                }
                            }
                        }
                    }

                }

            }
            catch (Exception ex)
            { 

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public void CompareInvTask()
        {
            try
            {
                IInvReconcileBLL business = new InvReconcileBLL();
                DataSet dsQuery = business.QueryTaskInvReconcile();
                List<InvReconcileSummaryVO> models = new List<InvReconcileSummaryVO>();
                if (null != dsQuery && dsQuery.Tables[0]?.Rows.Count > 0)
                {
                    DataTable dt = dsQuery.Tables[0];
                    int rownumber = 1, tag = 1;
                    InvReconcileSummaryVO model = new InvReconcileSummaryVO();
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        rownumber = int.Parse(dt.Rows[i]["rownumber"].ToString());
                        if (rownumber == tag)
                        {
                            string subCompanyName = dsQuery.Tables[0].Rows[i]["SubCompanyName"].ToString();
                            string brandName = dsQuery.Tables[0].Rows[i]["BrandName"].ToString();
                            string sph_id = dsQuery.Tables[0].Rows[i]["Id"].ToString();
                            if (string.IsNullOrEmpty(model.SubCompanyName))
                                model.SubCompanyName = subCompanyName;
                            if (string.IsNullOrEmpty(model.BrandName))
                                model.BrandName = brandName;
                            if (rownumber != 1)
                                model.Ids = model.Ids + "," + $"'{sph_id}'";
                            else
                                model.Ids = $"'{sph_id}'";
                             tag++;
                        }
                        else
                        {
                            tag = 1; 
                            models.Add(model);
                            model = new InvReconcileSummaryVO();
                            i--;
                        }
                        if(i == dt.Rows.Count -1)
                        {
                            models.Add(model);
                        }
                    }
                }
                if (models.Count > 0)
                {
                    foreach (var model in models)
                    {
                        System.Threading.Thread.Sleep(100);
                        CompareInvReconcile(model);
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }
    }
}
