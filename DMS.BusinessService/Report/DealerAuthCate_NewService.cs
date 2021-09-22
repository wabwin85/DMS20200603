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
    public class DealerAuthCate_NewService : ABaseQueryService, IQueryExport
    {
        public DealerAuthCate_NewVO Init(DealerAuthCate_NewVO model)
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

        public DealerAuthCate_NewVO Query(DealerAuthCate_NewVO model)
        {
            try
            {
                DealerAuthCate_NewDao DealerAuthCate_New = new DealerAuthCate_NewDao();
                model.RstResultList = JsonHelper.DataTableToArrayList(DealerAuthCate_New.SelectDealerAuthCate(model.QryProductLine.Key,this.UserInfo.Id.ToString(), this.UserInfo.CorpId.ToString()));
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
            DealerAuthCate_NewDao DealerAuthCate_New = new DealerAuthCate_NewDao();

            String ProductLine = Parameters["ProductLine"].ToSafeString();

            DataSet[] result = new DataSet[1];
            result[0] = DealerAuthCate_New.ExportDealerAuthCate(ProductLine,this.UserInfo.Id.ToString(), this.UserInfo.CorpId.ToString());

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("DealerAuthCate_New");
            xlsExport.Export(ht, result, DownloadCookie);

        }
    }
}
