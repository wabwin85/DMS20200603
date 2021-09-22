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
    public class DealerTransferReport_NewService : ABaseQueryService, IQueryExport
    {
        public DealerTransferReport_NewVO Init(DealerTransferReport_NewVO model)
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

        public DealerTransferReport_NewVO Query(DealerTransferReport_NewVO model)
        {
            try
            {

                Hashtable ht = new Hashtable();
                BaseService.AddCommonFilterCondition(ht);
                DealerTransferReport_NewDao DealerTransferReport_New = new DealerTransferReport_NewDao();
                model.RstResultList = JsonHelper.DataTableToArrayList(DealerTransferReport_New.SelectDealerTransferReport(model.QryProductLine.Key, model.QryApplyDate.StartDate.ToString(), model.QryApplyDate.EndDate.ToString(), this.UserInfo.Id.ToString(), model.QryProductModel, model.QryBatchNo, this.UserInfo.CorpId.ToString(), Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"])));
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
            DealerTransferReport_NewDao DealerTransferReport_New = new DealerTransferReport_NewDao();

            String ProductLine = Parameters["ProductLine"].ToSafeString();
            String StartDate = Parameters["StartDate"].ToSafeString();
            String EndDate = Parameters["EndDate"].ToSafeString();
            String Status = Parameters["Status"].ToSafeString();
            String ProductModel = Parameters["ProductModel"].ToSafeString();
            String BatchNo = Parameters["BatchNo"].ToSafeString();

            DataSet[] result = new DataSet[1];
            Hashtable table = new Hashtable();
            BaseService.AddCommonFilterCondition(table);
            result[0] = DealerTransferReport_New.ExportDealerTransferReport(ProductLine, StartDate, EndDate, this.UserInfo.Id.ToString(), ProductModel, BatchNo, this.UserInfo.CorpId.ToString(), Convert.ToString(table["SubCompanyId"]), Convert.ToString(table["BrandId"]));

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("DealerTransferReport_New");
            xlsExport.Export(ht, result, DownloadCookie);

        }
    }
}
