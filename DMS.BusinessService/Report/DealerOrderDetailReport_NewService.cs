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
using DMS.DataAccess.Report;
using System.Collections.Specialized;
using DMS.Business.Excel;
using System.Data;
using DMS.ViewModel.Report;
using DMS.Business;

namespace DMS.BusinessService.Report
{
    public class DealerOrderDetailReport_NewService : ABaseQueryService, IQueryExport
    {
        public DealerOrderDetailReport_NewVO Init(DealerOrderDetailReport_NewVO model)
        {
            try
            {
                QueryDao Bu = new QueryDao();
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

        public DealerOrderDetailReport_NewVO Query(DealerOrderDetailReport_NewVO model)
        {
            try
            {
                DealerOrderDetailReport_NewDao DealerOrderDetailReport_New = new DealerOrderDetailReport_NewDao();
                model.RstResultList = JsonHelper.DataTableToArrayList(DealerOrderDetailReport_New.SelectDealerOrderDetailReport(model.QryProductLine.Key, model.QryApplyDate.StartDate.ToString(), model.QryApplyDate.EndDate.ToString(), this.UserInfo.Id.ToString(), model.QryProductModel, this.UserInfo.CorpId.ToString()));
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
            DealerOrderDetailReport_NewDao DealerOrderDetailReport_New = new DealerOrderDetailReport_NewDao();

            String ProductLine = Parameters["ProductLine"].ToSafeString();
            String StartDate = Parameters["StartDate"].ToSafeString();
            String EndDate = Parameters["EndDate"].ToSafeString();
            String ProductModel = Parameters["ProductModel"].ToSafeString();

            DataSet[] result = new DataSet[1];
            result[0] = DealerOrderDetailReport_New.ExportDealerOrderDetailReport(ProductLine, StartDate, EndDate, this.UserInfo.Id.ToString(), ProductModel, this.UserInfo.CorpId.ToString());

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("DealerOrderDetailReport_New");
            xlsExport.Export(ht, result, DownloadCookie);

        }
    }
}
