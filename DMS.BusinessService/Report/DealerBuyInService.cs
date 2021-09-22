using DMS.Business;
using DMS.Business.Excel;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Specialized;
using System.Data;
using DMS.ViewModel.Report;
using DMS.ViewModel.Common;
using System.Collections.Generic;
using System.Linq;
using DMS.DataAccess;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Model;

namespace DMS.BusinessService.Report
{
    public class DealerBuyInService : ABaseQueryService,IQueryExport, IDealerFilterFac
    {
        #region Ajax Method
        ReportDao rptDao = new ReportDao();
        IRoleModelContext context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public DealerBuyInVO Init(DealerBuyInVO model)
        {
            try
            {
                List<object> listDealerType = new List<object>
                        {
                            new {Key = "LP", Value = "LP"},
                            new {Key = "T1", Value = "T1"},
                            new {Key = "T2", Value = "T2"}
                        };
                model.LstDealerType = new ArrayList(listDealerType);
                if (null != BaseService.CurrentSubCompany)
                {
                    DealerMasterDao dealerMasterDao = new DealerMasterDao();
                    DataSet dsAuthBrand = GetAuthBrand(new Guid(BaseService.CurrentSubCompany.Key));
                    model.LstBrand = JsonHelper.DataTableToArrayList(dsAuthBrand.Tables[0]);
                    model.DealerListType = "4";//默认4
                    
                    if (IsDealer)
                    {
                        KeyValue kvDealer = new KeyValue();
                        DealerMaster dealer = dealerMasterDao.GetObject(RoleModelContext.Current.User.CorpId.ToSafeGuid());
                        kvDealer.Key = RoleModelContext.Current.User.CorpId.ToSafeString();
                        kvDealer.Value = dealer.ChineseShortName;
                        model.QryDealer = kvDealer;
                        model.DealerListType = "6";
                    }
                }
                else
                {
                    model.LstBrand = null;
                }
                model.LstProductline = base.GetProductLine();
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
        public DealerBuyInVO ChangeBrand(DealerBuyInVO model)
        {
            try
            {
                ProductLineBLL bllProductLine = new ProductLineBLL();
                IList<KeyValue> productlines = base.GetProductLine(false);
                var lstAuthProductLine = bllProductLine.SelectViewProductLine(BaseService.CurrentSubCompany?.Key, model.QryBrand?.Key,
                null);
                model.LstProductline =
                    productlines.Where(
                        item => lstAuthProductLine.Any(p => p.Id.Equals(item.Key, StringComparison.OrdinalIgnoreCase))).ToList();
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
        public string Query(DealerBuyInVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (model.QryBrand.ToSafeString() != "" && model.QryBrand.Key.ToSafeString() != "")
                {
                    param.Add("Brand", model.QryBrand.Key.ToSafeString());
                }
                if (model.QryProductLine.ToSafeString() != "" && model.QryProductLine.Key.ToSafeString() != "")
                {
                    param.Add("ProductLine", model.QryProductLine.Key.ToSafeString());
                }
                if(model.QryOrderDate!=null && !string.IsNullOrEmpty(model.QryOrderDate.StartDate))
                {
                    param.Add("OrderDateStart", model.QryOrderDate.StartDate);
                }
                if (model.QryOrderDate != null && !string.IsNullOrEmpty(model.QryOrderDate.EndDate))
                {
                    param.Add("OrderDateEnd", model.QryOrderDate.EndDate);
                }
                if (model.QryShipmentDate != null && !string.IsNullOrEmpty(model.QryShipmentDate.StartDate))
                {
                    param.Add("ShipmentDateStart", model.QryShipmentDate.StartDate);
                }
                if (model.QryShipmentDate != null && !string.IsNullOrEmpty(model.QryShipmentDate.EndDate))
                {
                    param.Add("ShipmentDateEnd", model.QryShipmentDate.EndDate);
                }
                if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                {
                    param.Add("CFN", model.QryCFN.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryLotNumber.ToSafeString()))
                {
                    param.Add("LotNumber", model.QryLotNumber.ToSafeString());
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                if (model.QryDealer.ToSafeString() != "" && model.QryDealer.Key.ToSafeString() != "")
                {
                    param.Add("Dealer", model.QryDealer.Key.ToSafeString());
                }
                if (model.QryDealerType.ToSafeString() != "" && model.QryDealerType.Key.ToSafeString() != "")
                {
                    param.Add("DealerType", model.QryDealerType.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryDeliveryNo.ToSafeString()))
                {
                    param.Add("DeliveryNo", model.QryDeliveryNo.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryOrderNo.ToSafeString()))
                {
                    param.Add("OrderNo", model.QryOrderNo.ToSafeString());
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = rptDao.DealerBuyInReport(param, start, model.PageSize, out totalCount); 
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

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            if (Parameters["ExportType"].ToSafeString() == "ExportDealerBuyIn")
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(Parameters["QryBrand"].ToSafeString()))
                {
                    param.Add("Brand", Parameters["QryBrand"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryProductLine"].ToSafeString()))
                {
                    param.Add("ProductLine", Parameters["QryProductLine"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryOrderDateStart"].ToSafeString()))
                {
                    param.Add("OrderDateStart", Parameters["QryOrderDateStart"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryOrderDateEnd"].ToSafeString()))
                {
                    param.Add("OrderDateEnd", Parameters["QryOrderDateEnd"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryShipmentDateStart"].ToSafeString()))
                {
                    param.Add("ShipmentDateStart", Parameters["QryShipmentDateStart"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryShipmentDateEnd"].ToSafeString()))
                {
                    param.Add("ShipmentDateEnd", Parameters["QryShipmentDateEnd"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryCFN"].ToSafeString()))
                {
                    param.Add("CFN", Parameters["QryCFN"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryLotNumber"].ToSafeString()))
                {
                    param.Add("LotNumber", Parameters["QryLotNumber"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryDealer"].ToSafeString()))
                {
                    param.Add("Dealer", Parameters["QryDealer"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryDealerType"].ToSafeString()))
                {
                    param.Add("DealerType", Parameters["QryDealerType"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryDeliveryNo"].ToSafeString()))
                {
                    param.Add("DeliveryNo", Parameters["QryDeliveryNo"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryOrderNo"].ToSafeString()))
                {
                    param.Add("OrderNo", Parameters["QryOrderNo"].ToSafeString());
                }
                if (context.User.Id != null)
                {
                    param.Add("UserId", context.User.Id);
                }
                param.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                int totalCount = 0;
                DataSet ds = rptDao.DealerBuyInReport(param, 0, int.MaxValue, out totalCount);
                //删除多余列               
                ds.Tables[0].Columns.Remove("UPN"); 
                ds.Tables[0].Columns.Remove("row_number");
                ds.Tables[0].Columns.Remove("CFN_Property1");
                //重命名列名
                ds.Tables[0].Columns["SubCompanyName"].ColumnName = "分子公司";
                ds.Tables[0].Columns["BrandName"].ColumnName = "品牌";
                ds.Tables[0].Columns["DMA_ChineseName"].ColumnName = "经销商名称";
                ds.Tables[0].Columns["DMA_EnglishName"].ColumnName = "经销商英文名称";
                ds.Tables[0].Columns["DMA_SAP_Code"].ColumnName = "ERPCode";
                ds.Tables[0].Columns["PRH_PurchaseOrderNbr"].ColumnName = "原始订单号";
                ds.Tables[0].Columns["OrderType"].ColumnName = "订单类型";
                ds.Tables[0].Columns["POH_SubmitDate"].ColumnName = "订单提交日期";
                ds.Tables[0].Columns["PRH_SAPShipmentID"].ColumnName = "发货单号";
                ds.Tables[0].Columns["PRH_TypeName"].ColumnName = "收货类型";
                ds.Tables[0].Columns["IDENTITY_NAME"].ColumnName = "操作人";
                ds.Tables[0].Columns["PRH_PONumber"].ColumnName = "收货单单号";
                ds.Tables[0].Columns["PRH_SAPShipmentDate"].ColumnName = "发货日期";
                ds.Tables[0].Columns["Year"].ColumnName = "年度";
                ds.Tables[0].Columns["Month"].ColumnName = "月度";
                ds.Tables[0].Columns["ProductLineName"].ColumnName = "产品线";
                //ds.Tables[0].Columns["CFN_Property1"].ColumnName = "产品等级";
                ds.Tables[0].Columns["CFN_CustomerFaceNbr"].ColumnName = "产品编号";
                ds.Tables[0].Columns["CFN_ChineseName"].ColumnName = "产品中文名";
                ds.Tables[0].Columns["CFN_EnglishName"].ColumnName = "产品英文名";
                ds.Tables[0].Columns["LTM_LotNumber"].ColumnName = "产品批号";
                ds.Tables[0].Columns["QRCode"].ColumnName = "二维码";
                ds.Tables[0].Columns["LTM_ExpiredDate"].ColumnName = "产品有效期";
                ds.Tables[0].Columns["PRL_ReceiptQty"].ColumnName = "发货数量";
                ds.Tables[0].Columns["Price"].ColumnName = "价格";
                ds.Tables[0].Columns["Amount"].ColumnName = "金额";
                ds.Tables[0].Columns["InvoiceList"].ColumnName = "系统发票号";
                ds.Tables[0].Columns["InvoiceAmount"].ColumnName = "系统发票金额";
                ds.Tables[0].Columns["PRH_StatusName"].ColumnName = "是否接收";
                ds.Tables[0].Columns["RFU_CurRegNo"].ColumnName = "注册证编号-1";
                ds.Tables[0].Columns["RFU_CurManuName"].ColumnName = "生产企业(注册证-1)";
                ds.Tables[0].Columns["RFU_LastRegNo"].ColumnName = "注册证编号-2";
                ds.Tables[0].Columns["RFU_LastManuName"].ColumnName = "生产企业(注册证-2)";
                ds.Tables[0].Columns["CFN_Level1Code"].ColumnName = "Level1 Code";
                ds.Tables[0].Columns["CFN_Level1Desc"].ColumnName = "Level1 Desc";
                ds.Tables[0].Columns["CFN_Level2Code"].ColumnName = "Level2 Code";
                ds.Tables[0].Columns["CFN_Level2Desc"].ColumnName = "Level2 Desc";
                ds.Tables[0].Columns["CFN_Level3Code"].ColumnName = "Level3 Code";
                ds.Tables[0].Columns["CFN_Level3Desc"].ColumnName = "Level3 Desc";
                ds.Tables[0].Columns["CFN_Level4Code"].ColumnName = "Level4 Code";
                ds.Tables[0].Columns["CFN_Level4Desc"].ColumnName = "Level4 Desc";
                ds.Tables[0].Columns["CFN_Level5Code"].ColumnName = "Level5 Code";
                ds.Tables[0].Columns["CFN_Level5Desc"].ColumnName = "Level5 Desc";
                ExportFile(ds, DownloadCookie);
            }

        }

        protected void ExportFile(DataSet ds, string Cookie)
        {
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("ExportFile");
            xlsExport.Export(ht, result, Cookie);
        }



        #endregion
    }
}
