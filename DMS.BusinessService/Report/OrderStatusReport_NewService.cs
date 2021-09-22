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
using DMS.Business;

namespace DMS.BusinessService.Report
{
    public class OrderStatusReport_NewService : ABaseQueryService, IQueryExport
    {
        public OrderStatusReport_NewVO Init(OrderStatusReport_NewVO model)
        {
            try
            {
                QueryDao Bu = new QueryDao();
                ShipmentHeaderDao ShipmentHeader = new ShipmentHeaderDao();
                Hashtable htbu = new Hashtable();
                htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                model.LstProductLine = JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);
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

        public OrderStatusReport_NewVO Query(OrderStatusReport_NewVO model)
        {
            try
            {
                OrderStatusReport_NewDao OrderStatusReport_New = new OrderStatusReport_NewDao();
                Hashtable table = new Hashtable();
                BaseService.AddCommonFilterCondition(table);
                model.RstResultList = JsonHelper.DataTableToArrayList(OrderStatusReport_New.SelectOrderStatusReport(model.QryProductLine.Key, model.QryApplyDate.StartDate.ToString(), model.QryApplyDate.EndDate.ToString(), model.QryIsInclude, this.UserInfo.Id.ToString(), this.UserInfo.CorpId.ToString(), Convert.ToString(table["SubCompanyId"]), Convert.ToString(table["BrandId"])));
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
            OrderStatusReport_NewDao OrderStatusReport_New = new OrderStatusReport_NewDao();

            String ProductLine = Parameters["ProductLine"].ToSafeString();
            String StartDate = Parameters["StartDate"].ToSafeString();
            String EndDate = Parameters["EndDate"].ToSafeString();
            bool? IsInclude = Parameters["IsInclude"].ToBool();

            DataSet[] result = new DataSet[1];
            Hashtable table = new Hashtable();
            BaseService.AddCommonFilterCondition(table);
            result[0] = OrderStatusReport_New.ExportOrderStatusReport(ProductLine, StartDate, EndDate, IsInclude, this.UserInfo.Id.ToString(), this.UserInfo.CorpId.ToString(), Convert.ToString(table["SubCompanyId"]), Convert.ToString(table["BrandId"]));

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("OrderStatusReport_New");
            xlsExport.Export(ht, result, DownloadCookie);

        }
    }
}
