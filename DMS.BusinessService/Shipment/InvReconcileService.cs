using System;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text; 
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.Shipment.Extense;
using DMS.Model;
using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using Lafite.RoleModel.Security;
using System.Globalization;
using DMS.DataAccess;
using Grapecity.DataAccess.Transaction;
using System.Collections.Specialized;
using DMS.Business.Excel;
using DMS.Common.Extention;

namespace DMS.BusinessService.Shipment
{ 
    public class InvReconcileService: ABaseQueryService,IDealerFilterFac, IQueryExport
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }

        public InvReconcileSummaryVO Init(InvReconcileSummaryVO model)
        {
            try
            {
                model.LstProductLine = base.GetProductLine().ToList(); 
            }
            catch(Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(InvReconcileSummaryVO model)
        {
            try
            {
                Hashtable ht = new Hashtable();
                int totalCount = 0;
                if (null != model.Dealer && !string.IsNullOrEmpty(model.Dealer.Key))
                    ht.Add("DealerId", model.Dealer.Key);
                if (null != model.QryProductLine && !string.IsNullOrEmpty(model.QryProductLine.Key))
                    ht.Add("ProductLineId", model.QryProductLine.Key);
                if (!string.IsNullOrEmpty(model.QryOrderNumber))
                    ht.Add("OrderNumber", model.QryOrderNumber);
                if (null != model.QryReconcileDate && !string.IsNullOrEmpty(model.QryReconcileDate.StartDate))
                    ht.Add("RecileStartDate", model.QryReconcileDate.StartDate);
                if (null != model.QryReconcileDate && !string.IsNullOrEmpty(model.QryReconcileDate.EndDate))
                    ht.Add("RecileEndDate", model.QryReconcileDate.EndDate);
                if (!string.IsNullOrEmpty(model.QryHospital))
                    ht.Add("HospitalName", model.QryHospital);
                if (model.CompareInfo!=null &&!string.IsNullOrEmpty(model.CompareInfo.Key))
                    ht.Add("CompareInfo", model.CompareInfo.Value);
                int start = (model.Page - 1) * model.PageSize;
                ht.Add("start", start);
                ht.Add("limit", model.PageSize);
                IInvReconcileBLL business = new InvReconcileBLL();
                DataSet ds = business.QueryInvReconcile(ht, start, model.PageSize, out totalCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch(Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result); 
        }

        public InvReconcileSummaryVO QueryProductDetail(InvReconcileSummaryVO model)
        {
            try
            {
                if(model.Ids != null)
                {
                    //Hashtable ht = new Hashtable();
                    //int totalCount = 0;
                    //int start = (model.Page - 1) * model.PageSize;
                    if(!string.IsNullOrEmpty(model.Ids))
                    {
                        //ht.Add("SPH_IDs",model.Ids);
                    }
                    else
                    {
                        //ht.Add("SPH_IDs", "'00000000-0000-0000-0000-000000000000'");
                        model.Ids = "'00000000-0000-0000-0000-000000000000'";
                    }
                    //ht.Add("start", start);
                    //ht.Add("limit", model.PageSize);
                    IInvReconcileBLL business = new InvReconcileBLL();
                    DataSet ds = business.QueryProductDetail(model.Ids);
                    model.RstProductDetail = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                    //model.DataCount = totalCount;
                    model.IsSuccess = true;
                }
            }
            catch(Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InvReconcileSummaryVO QueryInvoiceDetail(InvReconcileSummaryVO model)
        {
            try
            {
                if (model.Ids != null)
                {
                    //Hashtable ht = new Hashtable();
                    //int totalCount = 0;
                    //int start = (model.Page - 1) * model.PageSize;
                    if (!string.IsNullOrEmpty(model.Ids))
                    {
                        //ht.Add("SPH_IDs", model.Ids);
                        
                    }
                    else
                    {
                        //ht.Add("SPH_IDs", "'00000000-0000-0000-0000-000000000000'");
                        model.Ids = "'00000000-0000-0000-0000-000000000000'";
                    } 
                    IInvReconcileBLL business = new InvReconcileBLL();
                    DataSet ds = business.QueryInvoiceDetail(model.Ids);
                    model.RstInvoiceDetail = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                    //model.DataCount = totalCount;
                    model.IsSuccess = true;
                }
            }
            catch(Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InvReconcileSummaryVO QueryProductInvoiceDetail(InvReconcileSummaryVO model)
        {
            try
            {
                if (model.Ids != null)
                {
                    Hashtable ht = new Hashtable();
                    int totalCount = 0;
                    int start = (model.Page - 1) * model.PageSize;
                    if (!string.IsNullOrEmpty(model.Ids ))
                    {
                        ht.Add("SPH_IDs", model.Ids);
                    }
                    else
                    {
                        ht.Add("SPH_IDs", "'00000000-0000-0000-0000-000000000000'");
                    }
                    ht.Add("start", start);
                    ht.Add("limit", model.PageSize);
                    IInvReconcileBLL business = new InvReconcileBLL();
                    DataSet ds = business.QueryProductInvoiceDetail(ht, start, model.PageSize, out totalCount);
                    model.RstProductInvoiceDetail = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                    model.DataCount = totalCount;
                    model.IsSuccess = true;
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

        public InvReconcileSummaryVO CompareInvReconcile(InvReconcileSummaryVO model)
        {
            try
            {
                //数据导入到临时表中
                if (model.IsSystemCompare == true)
                {
                    bool tag = InsertRecordsToTemp(model);
                    if (!tag)
                        throw new Exception("导入数据出错");
                    IsExistInvRecDetailData(model);
                    model.IsSuccess = true;
                }
                else
                {
                    IInvReconcileBLL business = new InvReconcileBLL();
                    business.UpdateInvRecDetail(model.DetailIds);
                    string ids = model.Ids;
                    string[] idArray = ids.Split(',');
                    if(idArray.Length>0)
                    {
                        for(int i = 0; i<idArray.Length;i++)
                        {
                            string id = idArray[i];
                            DataTable dt = business.QueryProductDetail(id).Tables[0];
                            if(dt.Rows.Count>0)
                            {
                                string recStatus = "";
                                for(int j=0;j< dt.Rows.Count;j++)
                                {
                                    string tempstatus = dt.Rows[j]["CompareStatus"].ToString();
                                    if (!recStatus.Contains(tempstatus))
                                        recStatus += tempstatus; 
                                }

                                Hashtable ht = new Hashtable();
                                if(recStatus.Contains("对账成功") && !(recStatus.Contains("对账失败") || recStatus.Contains("未对账")))
                                {
                                    ht.Add("CompareStatus", "已对账");
                                    ht.Add("CompareUser", _context.User.Id);
                                    ht.Add("IsSystemCompare", false);
                                    ht.Add("Ids", model.Ids);
                                    business.UpdateInvRecSummary(ht);
                                    model.IsSuccess = true;
                                }
                                else if (recStatus.Contains("对账成功") && (recStatus.Contains("对账失败") || recStatus.Contains("未对账")))
                                {
                                    ht.Add("CompareStatus", "部分对账成功");
                                    ht.Add("CompareUser", _context.User.Id);
                                    ht.Add("IsSystemCompare", false);
                                    ht.Add("Ids", model.Ids);
                                    business.UpdateInvRecSummary(ht);
                                    model.IsSuccess = true;
                                }
                                else if (recStatus.Contains("对账失败"))
                                {
                                    ht.Add("CompareStatus", "对账失败");
                                    ht.Add("CompareUser", _context.User.Id);
                                    ht.Add("IsSystemCompare", false);
                                    ht.Add("Ids", model.Ids);
                                    business.UpdateInvRecSummary(ht);
                                    model.IsSuccess = true;
                                }
                                else
                                {
                                    ht.Add("CompareStatus", "未对账");
                                    ht.Add("CompareUser", _context.User.Id);
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
            catch(Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
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

        private void IsExistInvRecDetailData(InvReconcileSummaryVO model)
        {
            Guid _userId = new Guid(_context.User.Id);
            IInvReconcileBLL business = new InvReconcileBLL(); 
            DataSet dsTemp = business.QueryInvRecDetailTempByUser(_userId); 
            if (dsTemp.Tables[0].Rows.Count > 0)
            { 
                DataTable dtTemp = dsTemp.Tables[0];
                foreach(DataRow dr in dtTemp.Rows)
                {
                    SaveCompareDataInTempTable(dr, model);
                }

            }
            //DataSet dsDetail = business.QueryInvRecDetail();

        }

        private void SaveCompareDataInTempTable(DataRow drTemp, InvReconcileSummaryVO model)
        {
            string compareStatus = string.Empty;
            IInvReconcileBLL business = new InvReconcileBLL();
            decimal tempQuantity = drTemp["TotalNumber"]== DBNull.Value?0: decimal.Parse(drTemp["TotalNumber"].ToString(), CultureInfo.InvariantCulture);
            //找出发票明细中的quantity
            DataSet dsRule = GetRuleBySubCompany(model);
            Hashtable ht = new Hashtable();
            if (dsRule.Tables[0].Rows.Count > 0)
            {
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
            ht.Add("SPH_ID", drTemp["SPH_ID"].ToString());
            ht.Add("OrderNumber", drTemp["OrderNumber"].ToString());
            ht.Add("CFN", drTemp["CFN"].ToString());
            ht.Add("HospitalName", drTemp["HospitalName"].ToString());
            ht.Add("ProductLineId",drTemp["ProductLineId"].ToString());
            ht.Add("BrandName",model.BrandName);
            ht.Add("SubCompanyName",model.SubCompanyName);
            DataSet dsDetail = business.QueryInvRecDetail(ht);
            if (dsDetail.Tables[0].Rows.Count > 0) // already exist
            {
                decimal invoiceTotal;
                DataTable dtInvQuantity = business.QueryInvTotalNumber(ht).Tables[0];
                decimal.TryParse(dtInvQuantity.Rows[0]["Quantity"].ToString(), out invoiceTotal);
                if (tempQuantity == invoiceTotal && invoiceTotal != 0)
                {
                    compareStatus = "已对账";
                }
                else
                {
                    compareStatus = "对账失败";
                }
                string RtnVal = "", RtnMsg = "";
                business.ExeUpdateCompareStatus(new Guid(drTemp["SPH_ID"].ToString()),drTemp["OrderNumber"].ToString(),
                    drTemp["CFN"].ToString(), new Guid(_context.User.Id) , compareStatus,  out RtnVal, out RtnMsg, true);
            }
            else
            {
                decimal invoiceTotal;

                DataTable dtInvQuantity = business.QueryInvTotalNumber(ht).Tables[0];
                decimal.TryParse(dtInvQuantity.Rows[0]["Quantity"].ToString(), out invoiceTotal);
                if(tempQuantity <= invoiceTotal && invoiceTotal != 0)
                {
                    compareStatus = "已对账";
                }
                else
                {
                    compareStatus = "对账失败";
                }
                string RtnVal = "", RtnMsg ="";
                business.ExeSaveCompareStatus(new Guid(drTemp["SPH_ID"].ToString()), drTemp["OrderNumber"].ToString(), drTemp["CFN"].ToString(), new Guid(_context.User.Id), compareStatus, out RtnVal, out RtnMsg);
                
            }
        }

        private bool InsertRecordsToTemp(InvReconcileSummaryVO model)
        {
            bool tag = false;
            if(!string.IsNullOrEmpty( model.Ids))
            {
                IInvReconcileBLL business = new InvReconcileBLL();
                //删除临时表中自己的相关数据
                int cnt = business.DeleteInvRecDetailTemp();
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
                        dtTemp.Columns.Add("IsDelete",typeof(bool));
                        dtTemp.Columns.Add("CompareStatus"); 
                        foreach (DataRow dr in dt.Rows)
                        {
                            DataRow drTemp = dtTemp.NewRow();
                            drTemp["SPH_ID"] = dr["Id"];
                            drTemp["CFN_ID"] = dr["CFN_ID"];
                            drTemp["CFN"] = dr["CFN"];
                            drTemp["OrderNumber"] = dr["OrderNumber"];
                            drTemp["CompareUser"] = _context.User.Id;
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


        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            Hashtable param = new Hashtable(); 
            if (!string.IsNullOrEmpty(Parameters["Dealer"].ToSafeString()))
            {
                param.Add("DealerId", Parameters["Dealer"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryProductLine"].ToSafeString()))
            {
                param.Add("ProductLineId", Parameters["QryProductLine"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryOrderNumber"].ToSafeString()))
            {
                param.Add("OrderNumber", Parameters["QryOrderNumber"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["ShipmentDateStart"].ToSafeString()))
            {
                param.Add("RecileStartDate", Parameters["ShipmentDateStart"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["ShipmentDateEnd"].ToSafeString()))
            {
                param.Add("RecileEndDate", Parameters["ShipmentDateEnd"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["HospitalName"].ToSafeString()))
            {
                param.Add("HospitalName", Parameters["HospitalName"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["CompareInfo"].ToSafeString()))
            {
                param.Add("CompareInfo", Parameters["CompareInfo"].ToSafeString());
            } 
            IInvReconcileBLL business = new InvReconcileBLL();
            DataSet dsQuery = business.QueryInvReconcile(param);
            DataTable dt = dsQuery.Tables[0].Copy();
            DataSet ds = new DataSet("报量对账销售单表");
            DataTable dtData = dt;

            dtData.TableName = "报量对账销售单表";
            if (null != dtData)
            {
                #region 调整列的顺序,并重命名列名

                Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"DealerName", "经销商名称"},
                            {"ProductLine", "产品线"},
                            {"SubCompanyName", "分子公司"},
                            {"BrandName", "品牌"},
                            {"OrderNumber", "销售单号"},
                            {"HospitalName", "销售医院"},
                            {"TotalQty", "总数量"},
                            {"InvQty", "发票数量"},
                            {"CompareStatus", "对账情况"},
                            {"CompareInfo", "是否对账"},
                            {"UpdateTime", "最新对账日期"} 
                        };

                CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);

                #endregion 调整列的顺序,并重命名列名
                ds.Tables.Add(dtData); 
            }
            ExportFile(ds, DownloadCookie); 
        }

        protected void ExportFile(DataSet ds, string Cookie)
        {
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("ExportFile");
            xlsExport.Export(ht, result, Cookie);
        }
    }
}
