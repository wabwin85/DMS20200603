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
    public class DealerSalesReport_NewService : ABaseQueryService, IQueryExport
    {
        public DealerSalesReport_NewVO Init(DealerSalesReport_NewVO model)
        {
            try
            {
                QueryDao Bu = new QueryDao();
                ShipmentHeaderDao ShipmentHeader = new ShipmentHeaderDao();
                Hashtable htbu = new Hashtable();
                htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                model.LstProductLine = JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);
                model.LstStatus = JsonHelper.DataTableToArrayList(ShipmentHeader.SelectShipmentOrderStatus_ByDealerSalesReportStatus().Tables[0]);
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

        public DealerSalesReport_NewVO Query(DealerSalesReport_NewVO model)
        {
            try
            {
                DealerSalesReport_NewDao DealerSalesReport_New = new DealerSalesReport_NewDao();
                model.RstResultList = JsonHelper.DataTableToArrayList(DealerSalesReport_New.SelectDealerSalesReport(model.QryProductLine.Key, model.QryApplyDate.StartDate.ToString(), model.QryApplyDate.EndDate.ToString(), model.QryStatus.Key, this.UserInfo.Id.ToString(), model.QryProductModel, model.QryBatchNo, this.UserInfo.CorpId.ToString()));
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
            DealerSalesReport_NewDao DealerSalesReport_New = new DealerSalesReport_NewDao();

            String ProductLine = Parameters["ProductLine"].ToSafeString();
            String StartDate = Parameters["StartDate"].ToSafeString();
            String EndDate = Parameters["EndDate"].ToSafeString();
            String Status = Parameters["Status"].ToSafeString();
            String ProductModel = Parameters["ProductModel"].ToSafeString();
            String BatchNo = Parameters["BatchNo"].ToSafeString();

            DataSet[] result = new DataSet[1];
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            result[0] = DealerSalesReport_New.ExportDealerSalesReport(ProductLine, StartDate, EndDate, Status, this.UserInfo.Id.ToString(), ProductModel, BatchNo, this.UserInfo.CorpId.ToString(), Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));

            Hashtable table = new Hashtable();
            XlsExport xlsExport = new XlsExport("DealerSalesReport_New");
            xlsExport.Export(table, result, DownloadCookie);

        }
    }
}
