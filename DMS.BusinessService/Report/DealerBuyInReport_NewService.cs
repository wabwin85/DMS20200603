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
    public class DealerBuyInReport_NewService : ABaseQueryService, IQueryExport
    {
        public DealerBuyInReport_NewVO Init(DealerBuyInReport_NewVO model)
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

        public DealerBuyInReport_NewVO Query(DealerBuyInReport_NewVO model)
        {
            try
            {
                DealerBuyInReport_NewDao DealerBuyInReport_New = new DealerBuyInReport_NewDao();
                Hashtable table = new Hashtable();
                BaseService.AddCommonFilterCondition(table);
                model.RstResultList = JsonHelper.DataTableToArrayList(DealerBuyInReport_New.SelectDealerBuyInReport(model.QryProductLine.Key, model.QryApplyDate.StartDate.ToString(), model.QryApplyDate.EndDate.ToString(), model.QrySubmitDate.StartDate.ToString(), model.QrySubmitDate.EndDate.ToString(), this.UserInfo.Id.ToString(), model.QryProductModel, model.QryBatchNo, this.UserInfo.CorpId.ToString(), Convert.ToString(table["SubCompanyId"]), Convert.ToString(table["BrandId"])));
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
            DealerBuyInReport_NewDao DealerBuyInReport_New = new DealerBuyInReport_NewDao();

            String ProductLine = Parameters["ProductLine"].ToSafeString();
            String StartDate = Parameters["StartDate"].ToSafeString();
            String EndDate = Parameters["EndDate"].ToSafeString();
            String SubmitStartDate = Parameters["SubmitStartDate"].ToSafeString();
            String SubmitEndDate = Parameters["SubmitEndDate"].ToSafeString();
            String ProductModel = Parameters["ProductModel"].ToSafeString();
            String BatchNo = Parameters["BatchNo"].ToSafeString();

            DataSet[] result = new DataSet[1];
            Hashtable table = new Hashtable();
            BaseService.AddCommonFilterCondition(table);
            result[0] = DealerBuyInReport_New.ExportDealerBuyInReport(ProductLine, StartDate, EndDate, SubmitStartDate, SubmitEndDate, this.UserInfo.Id.ToString(), ProductModel, BatchNo, this.UserInfo.CorpId.ToString(), Convert.ToString(table["SubCompanyId"]), Convert.ToString(table["BrandId"]));

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("DealerBuyInReport_New");
            xlsExport.Export(ht, result, DownloadCookie);

        }
    }
}
