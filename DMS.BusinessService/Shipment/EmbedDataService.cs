using DMS.Business;
using DMS.Business.Excel;
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
    public class EmbedDataService : ABaseQueryService, IDealerFilterFac, IQueryExport
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            IEmbedDataBLL business = new EmbedDataBLL();
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
            if(!string.IsNullOrEmpty(Parameters["AccountingMonth"].ToSafeString()))
            {
                ht.Add("AccountingMonth", Parameters["AccountingMonth"].ToSafeString());
            }
            DataSet ds = business.QueryEmbedData(ht);
            DataSet dsExport = new DataSet("植入数据");
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
                            {"AccountingMonth", "核算月份"},
                            {"DealerCode", "DMS经销商编号"},
                            {"DealerName", "经销商名称"},
                            {"LegalEntity","实控方"},
                             {"SalesEntity","销售方名称（发票卖方）"} ,
                             {"Hos_Level","医院等级"},
                             {"Hos_Type","医院类型"},
                             {"Hos_Code","DMS医院编号"},
                             {"Hos_Name","医院名称（发票买方）"},
                             {"NewOpenMonth","新开月份"},
                             {"NewOpenProduct","新开产品"},
                             {"Region","区域"},
                             {"Province","省份"},
                             {"City","城市"},
                             {"CityLevel","城市等级"},
                             {"RegionOwner","区域总监"},
                             {"SalesRepresentative","销售代表"},
                             {"PMA_UPN","规格型号"},
                             {"CFN_Name","商品名称"},
                             {"ProductLine","产品线"},
                             {"ShipmentNbr","出库单号"},
                             {"UsedDate","出库/用量日期"},
                             {"InvoiceNumber","发票号码"}, 
                              {"InvoiceDate","发票日期"},
                              {"InvoiceUploadDate","发票上传日期"},
                              {"Status","状态"},
                             {"IsValidate","是否校验"},
                             {"Unit","单位"},
                             {"Quantity","数量"},
                            {"InvoicePrice","发票单价（不含税)"},
                            {"InvoiceRate","税率"},
                            {"AssessUnitPrice","考核单价（未税）"},
                            {"AssessPrice","考核金额（未税）"},
                            {"Remark","备注"},
                            {"IsLocked","数据状态" }
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

        public EmbedDataModelVO Init(EmbedDataModelVO model)
        {
            return model;
        }

        public string Query(EmbedDataModelVO model)
        {
            try
            {
                Hashtable ht = new Hashtable();
                int totalCount = 0;
                if(model.SelAccountYear != null && model.SelAccountYear.Key != "" && model.SelAccountYear.Key != "全部")
                {
                    ht.Add("AccountingYear",model.SelAccountYear.Key);
                }
                if(null != model.SelAccountMonth && model.SelAccountMonth.Key != "" && model.SelAccountMonth.Key != "全部")
                {
                    ht.Add("AccountingMonth", model.SelAccountMonth.Key);
                }
                if (null != model.SelSubCompany&& model.SelSubCompany.Key != "" && model.SelSubCompany.Key != "全部")
                {
                    ht.Add("SubCompany",model.SelSubCompany.Key);
                }
                else
                {
                    ht.Add("SubCompany", model.SubCompanyName);
                }
                int start = (model.Page - 1) * model.PageSize;
                ht.Add("start", start);
                ht.Add("limit", model.PageSize);

                IEmbedDataBLL business = new EmbedDataBLL();
                DataSet ds = business.QueryEmbedData(ht, start, model.PageSize, out totalCount);
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
    }
}
