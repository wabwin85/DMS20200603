using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using DMS.ViewModel.Report;
using DMS.DataAccess.Report;
using System.Collections.Specialized;
using DMS.Business.Excel;
using System.Data;
using DMS.ViewModel.Common;
using DMS.Business;

namespace DMS.BusinessService.Report
{
    public class OrderSalesSummaryInMonthReport_NewService : ABaseQueryService, IQueryExport
    {
        public OrderSalesSummaryInMonthReport_NewVO Init(OrderSalesSummaryInMonthReport_NewVO model)
        {
            try
            {
                QueryDao Bu = new QueryDao();
                Hashtable htbu = new Hashtable();
                htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                model.LstProductLine = JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);
                model.QryYear = new KeyValue();
                model.QryYear.Value = DateTime.Now.Year.ToSafeString();
                model.IsDealer = IsDealer;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public OrderSalesSummaryInMonthReport_NewVO Query(OrderSalesSummaryInMonthReport_NewVO model)
        {
            try
            {
                OrderSalesSummaryInMonthReport_NewDao OrderSalesSummaryInMonthReport_New = new OrderSalesSummaryInMonthReport_NewDao();
                model.RstResultList = JsonHelper.DataTableToArrayList(OrderSalesSummaryInMonthReport_New.SelectOrderSalesSummaryInMonthReport(model.QryProductLine.Key, model.QryYear.Key.ToString(), this.UserInfo.CorpId.ToString()));
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

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            OrderSalesSummaryInMonthReport_NewDao OrderSalesSummaryInMonthReport_New = new OrderSalesSummaryInMonthReport_NewDao();

            String ProductLine = Parameters["ProductLine"].ToSafeString();
            String Year = Parameters["Year"].ToSafeString();

            DataSet[] result = new DataSet[1];
            result[0] = OrderSalesSummaryInMonthReport_New.ExportOrderSalesSummaryInMonthReport(ProductLine, Year, this.UserInfo.CorpId.ToString());

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("OrderSalesSummaryInMonthReport_New");
            xlsExport.Export(ht, result, DownloadCookie);

        }
    }
}
