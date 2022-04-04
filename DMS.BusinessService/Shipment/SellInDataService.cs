using DMS.Business.Excel;
using DMS.Business.Shipment;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.ViewModel.Shipment.Extense;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Shipment
{
    public class SellInDataService:ABaseQueryService, IDealerFilterFac, IQueryExport
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            ISellInDataBLL business = new SellInDataBLL();
            Hashtable ht = new Hashtable();
            if (!string.IsNullOrEmpty(Parameters["SubCompany"].ToSafeString()))
            {
                ht.Add("SubCompany", Parameters["SubCompany"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Brand"].ToSafeString()))
            {
                ht.Add("Brand", Parameters["Brand"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["AccountingYear"].ToSafeString()))
            {
                ht.Add("AccountingYear", Parameters["AccountingYear"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["AccountingMonth"].ToSafeString()))
            {
                ht.Add("AccountingMonth", Parameters["AccountingMonth"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["AccountingQuarter"].ToSafeString()))
            {
                ht.Add("AccountingQuarter", Parameters["AccountingQuarter"].ToSafeString());
            }
            DataSet ds = business.QuerySellInData(ht);
            DataSet dsExport = new DataSet("商采数据");
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataTable dtData = dt.Copy();

                if (null != dtData)
                {
                    Dictionary<string, string> dict = new Dictionary<string, string>
                        {
                            {"SubCompany", "分子公司"},
                            {"Brand", "品牌"},
                            {"AccountingYear", "核算年份"},
                            {"AccountingQuarter", "核算季度"},
                            {"AccountingMonth", "核算月份（记帐期间）"},
                            {"Channel", "渠道/经销商层级"},
                            {"SalesIdentity", "销售凭证"},
                            {"SalesIdentityRow","销售凭证行项目"},
                             {"OrderType","订单类型"} ,
                             {"ActualDiscount","实际折扣"},
                             {"CompanyCode","公司代码"},
                             {"CompanyName","公司名称"},
                             {"IsRelated","关联方"},
                             {"RevenueType","收入类型"},
                            {"BorderType","国内外"},
                            {"ProductLine","产品线"},
                            {"ProductProvince","产品线&省份"},
                            {"InvoiceDate","出具发票日期"},
                            {"SoldPartyDealerCode","售达方DMS Code"},
                            {"SoldPartySAPCode","售达方"},
                            {"SoldPartyName","售达方名称"},
                            {"BillingType","开票类型"},
                            {"Province","省份"},
                            {"ExchangeRate","汇率"},
                            {"MaterialCode","物料"},
                            {"MaterialName","物料名称"},
                            {"UPN","规格型号"},
                            {"OutInvoiceNum","已出发票数量"},
                            {"InvoiceNetAmount","开票金额（净价）"},
                            {"InvoiceRate","开票税额"},
                            {"RebateAmount","返利金额"},
                            {"RebateNetAmount","返利金额（净价）"},
                            {"RebateRate","返利税额"},
                            {"BusiPurNoRebateAmount","商采金额（不含返利）"},
                            {"InvoiceAmount","开票总额"},
                            {"LocalCurrencyAmount","本币金额"},
                            {"KLocalCurrencyAmount","本币金额(K)"},
                            {"DeliveryDate","发货日期"},
                            {"OrderCreateDate","订单创建日期"},
                            {"ProductLineAndSoldParty","产品线&售达方"},
                            {"ActualLegalEntity","实控方"},
                            {"IsNeedRecovery","是否需要还原"},
                            {"RecoveryComment","还原备注"},
                            {"BusinessCaliber","商务口径收入"},
                            {"ClosedAccount","关账收入"},
                            {"Comment","备注"},
                            {"ProductGeneration","产品代次"},
                            {"StandardPrice","标准价"},
                            {"Region","区域"},
                            {"IsLocked","状态" }

                    };

                    CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);
                    dsExport.Tables.Add(dtData);
                }

                ExportFile(dsExport, DownloadCookie);
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

        public SellInDataModelVO Init(SellInDataModelVO model)
        {
            return model;
        }



        public string Query(SellInDataModelVO model)
        {
            try
            {
                Hashtable ht = new Hashtable();
                int totalCount = 0;
                if (model.SelAccountYear != null && model.SelAccountYear.Key != "" && model.SelAccountYear.Key != "全部")
                {
                    ht.Add("AccountingYear", model.SelAccountYear.Key);
                }
                if (null != model.SelAccountMonth && model.SelAccountMonth.Key != "" && model.SelAccountMonth.Key != "全部")
                {
                    ht.Add("AccountingMonth", model.SelAccountMonth.Key);
                }
                if (null != model.SelSubCompany && model.SelSubCompany.Key != "" && model.SelSubCompany.Key != "全部")
                {
                    ht.Add("SubCompany", model.SelSubCompany.Key);
                }
                else
                {
                    ht.Add("SubCompany", model.SubCompanyName);
                }
                 
                if (null != model.SelQuarter && model.SelQuarter.Key != "" && model.SelQuarter.Key != "全部")
                {
                    ht.Add("AccountingQuarter", model.SelQuarter.Key);
                }
                int start = (model.Page - 1) * model.PageSize;
                ht.Add("start", start);
                ht.Add("limit", model.PageSize);

                ISellInDataBLL business = new SellInDataBLL();
                DataSet ds = business.QuerySellInData(ht, start, model.PageSize, out totalCount);
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
