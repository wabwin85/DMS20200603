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
    public class DealerSalesStatistics_NewService : ABaseQueryService, IQueryExport
    {
        public DealerSalesStatistics_NewVO Init(DealerSalesStatistics_NewVO model)
        {
            try
            {
                QueryDao Bu = new QueryDao();
                DealerMasterDao DealerMaster = new DealerMasterDao();
                Hashtable htbu = new Hashtable();
                htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                model.LstProductLine = JsonHelper.DataTableToArrayList(Bu.SelectBU(htbu).Tables[0]);
                model.LstDealer = JsonHelper.DataTableToArrayList(DealerMaster.SelectDealerMasterByIdentityType(this.UserInfo.CorpId.ToString(), this.UserInfo.IdentityType.ToString()).Tables[0]);
                model.QryInDueTime = new KeyValue();
                model.QryInDueTime.Value = "全部";
                model.IsDealer = IsDealer;
                //model.CanActiveDealer = true;

                //if (IsDealer)
                //{
                //    if (this.UserInfo.CorpType == "T1")
                //    {
                //        model.CanActiveDealer = false;
                //        model.QryDealer.Value = this.UserInfo.CorpId.ToString();
                //    }
                //    else if (this.UserInfo.CorpType == "LP" || this.UserInfo.CorpType == "LS")
                //    {
                //        model.LstDealer = JsonHelper.DataTableToArrayList(DealerMaster.SelectDealerMasterByIdentityType(this.UserInfo.CorpId.ToString(), this.UserInfo.IdentityType.ToString()).Tables[0]);
                //        model.QryDealer.Value = this.UserInfo.CorpId.ToString();

                //    }
                //    else if (this.UserInfo.CorpType == "T2")
                //    {
                //        model.CanActiveDealer = false;
                //        model.QryDealer.Value = this.UserInfo.CorpId.ToString();
                //    }
                //    else
                //    {
                //        model.LstDealer = JsonHelper.DataTableToArrayList(DealerMaster.SelectDealerMasterByIdentityType(this.UserInfo.CorpId.ToString(), this.UserInfo.IdentityType.ToString()).Tables[0]);

                //    }
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

        public DealerSalesStatistics_NewVO Query(DealerSalesStatistics_NewVO model)
        {
            try
            {
                DealerSalesStatistics_NewDao DealerSalesStatistics_New = new DealerSalesStatistics_NewDao();
                model.RstResultList = JsonHelper.DataTableToArrayList(DealerSalesStatistics_New.SelectDealerSalesStatistics(model.QryDealer.Key, model.QryProductLine.Key, model.QryStartDate.StartDate.ToString(), model.QryStartDate.EndDate.ToString(), model.QryEndDate.StartDate.ToString(), model.QryEndDate.EndDate.ToString(), model.QryInDueTime.Value, model.QryIsPurchased, this.UserInfo.IdentityType.ToString(), this.UserInfo.CorpId.ToString()));
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
            DealerSalesStatistics_NewDao DealerSalesStatistics_New = new DealerSalesStatistics_NewDao();

            String Dealer = Parameters["Dealer"].ToSafeString();
            String ProductLine = Parameters["ProductLine"].ToSafeString();
            String StartbeginTime = Parameters["StartbeginTime"].ToSafeString();
            String StartstopTime = Parameters["StartstopTime"].ToSafeString();
            String EndbeginTime = Parameters["EndbeginTime"].ToSafeString();
            String EndstopTime = Parameters["EndstopTime"].ToSafeString();
            String InDueTime = Parameters["InDueTime"].ToSafeString();
            bool? IsPurchased = Parameters["IsPurchased"].ToBool();

            DataSet[] result = new DataSet[1];
            result[0] = DealerSalesStatistics_New.ExportDealerSalesStatistics(Dealer, ProductLine, StartbeginTime, StartstopTime, EndbeginTime, EndstopTime, InDueTime, IsPurchased, this.UserInfo.IdentityType.ToString(), this.UserInfo.CorpId.ToString());

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("DealerSalesStatistics_New");
            xlsExport.Export(ht, result, DownloadCookie);

        }
    }
}
