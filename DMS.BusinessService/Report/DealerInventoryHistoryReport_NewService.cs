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
    public class DealerInventoryHistoryReport_NewService : ABaseQueryService, IQueryExport
    {
        public DealerInventoryHistoryReport_NewVO Init(DealerInventoryHistoryReport_NewVO model)
        {
            try
            {
                DealerMasterDao DealerMaster = new DealerMasterDao();
                model.LstDealer = JsonHelper.DataTableToArrayList(DealerMaster.SelectDealerMasterByIdentityType(this.UserInfo.CorpId.ToString(), this.UserInfo.IdentityType.ToString()).Tables[0]);
                model.IsDealer = IsDealer;
                //model.CanActiveDealer = true;

                //if (IsDealer)
                //{
                //    if (this.UserInfo.CorpType != "HQ" && this.UserInfo.CorpType != "LP" && this.UserInfo.CorpType != "LS")
                //    {
                //        model.CanActiveDealer = false;
                //    }
                //    model.QryDealer.Value = this.UserInfo.CorpId.ToString();
                //}

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public DealerInventoryHistoryReport_NewVO Query(DealerInventoryHistoryReport_NewVO model)
        {
            try
            {
                DealerInventoryHistoryReport_NewDao DealerInventoryHistoryReport_New = new DealerInventoryHistoryReport_NewDao();
                Hashtable table = new Hashtable();
                BaseService.AddCommonFilterCondition(table);
                model.RstResultList = JsonHelper.DataTableToArrayList(DealerInventoryHistoryReport_New.SelectDealerInventoryHistoryReport(this.IsDealer, model.QryDealer.Key, model.QryApplyDate.StartDate.ToString(), model.QryApplyDate.EndDate.ToString(), string.IsNullOrEmpty(this.UserInfo.CorpType) ? "" : this.UserInfo.CorpType.ToString(), this.UserInfo.Id.ToString(), string.IsNullOrEmpty(this.UserInfo.CorpId.ToString()) ? "" : this.UserInfo.CorpId.ToString(), Convert.ToString(table["SubCompanyId"]), Convert.ToString(table["BrandId"])));
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
            DealerInventoryHistoryReport_NewDao DealerInventoryHistoryReport_New = new DealerInventoryHistoryReport_NewDao();

            String Dealer = Parameters["Dealer"].ToSafeString();
            String StartDate = Parameters["StartDate"].ToSafeString();
            String EndDate = Parameters["EndDate"].ToSafeString();

            DataSet[] result = new DataSet[1];
            Hashtable table = new Hashtable();
            BaseService.AddCommonFilterCondition(table);
            result[0] = DealerInventoryHistoryReport_New.ExportDealerInventoryHistoryReport(this.IsDealer, Dealer, StartDate, EndDate, string.IsNullOrEmpty(this.UserInfo.CorpType) ? "" : this.UserInfo.CorpType.ToString(), this.UserInfo.Id.ToString(), string.IsNullOrEmpty(this.UserInfo.CorpId.ToString()) ? "" : this.UserInfo.CorpId.ToString(), Convert.ToString(table["SubCompanyId"]), Convert.ToString(table["BrandId"]));

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("DealerInventoryHistoryReport_New");
            xlsExport.Export(ht, result, DownloadCookie);

        }
    }
}
