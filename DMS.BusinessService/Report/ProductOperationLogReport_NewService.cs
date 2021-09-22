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
    public class ProductOperationLogReport_NewService : ABaseQueryService, IQueryExport
    {
        public ProductOperationLogReport_NewVO Init(ProductOperationLogReport_NewVO model)
        {
            try
            {
                QueryDao Bu = new QueryDao();
                Hashtable htbu = new Hashtable();
                htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                model.LstProductLine = JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);
                model.IsDealer = IsDealer;

                DateTime dt = DateTime.Now.AddMonths(-3);  //当前时间
                model.QryOperDate = new ViewModel.Common.DatePickerRange(dt.ToString("yyyy-MM-dd"),"");
                //DateTime startWeek = dt.AddDays(1 - Convert.ToInt32(dt.DayOfWeek.ToString("d")));  //本周周一

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ProductOperationLogReport_NewVO Query(ProductOperationLogReport_NewVO model)
        {
            try
            {
                ProductOperationLogReport_NewDao ProductOperationLogReport_New = new ProductOperationLogReport_NewDao();
                Hashtable param = new Hashtable();
                BaseService.AddCommonFilterCondition(param);
                model.RstResultList = JsonHelper.DataTableToArrayList(ProductOperationLogReport_New.SelectProductOperationLogReport(model.QryProductLine.Key, Convert.ToString(param["SubCompanyId"]), Convert.ToString(param["BrandId"]), this.UserInfo.CorpId.ToString(), model.QryProductModel, model.QryBatchNo, model.QryOperDate.StartDate.ToString(), model.QryOperDate.EndDate.ToString()));
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
            ProductOperationLogReport_NewDao ProductOperationLogReport_New = new ProductOperationLogReport_NewDao();

            String ProductLine = Parameters["ProductLine"].ToSafeString();
            String ProductModel = Parameters["ProductModel"].ToSafeString();
            String BatchNo = Parameters["BatchNo"].ToSafeString();
            String StartDate = Parameters["StartDate"].ToSafeString();
            String EndDate = Parameters["EndDate"].ToSafeString();

            DataSet[] result = new DataSet[1];
            Hashtable param = new Hashtable();
            BaseService.AddCommonFilterCondition(param);
            result[0] = ProductOperationLogReport_New.ExportProductOperationLogReport(ProductLine, this.UserInfo.CorpId.ToString(), ProductModel, BatchNo, StartDate, EndDate,Convert.ToString(param["SubCompanyId"]), Convert.ToString(param["BrandId"]));

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("ProductOperationLogReport_New");
            xlsExport.Export(ht, result, DownloadCookie);

        }
    }
}
