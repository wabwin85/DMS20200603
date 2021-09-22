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

namespace DMS.BusinessService.Report
{
    public class HospitalReport_NewService : ABaseQueryService, IQueryExport
    {
        public HospitalReport_NewVO Init(HospitalReport_NewVO model)
        {
            try
            {
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

        public HospitalReport_NewVO Query(HospitalReport_NewVO model)
        {
            try
            {
                HospitalReport_NewDao HospitalReport_New = new HospitalReport_NewDao();
                model.RstResultList = JsonHelper.DataTableToArrayList(HospitalReport_New.SelectHospitalReport());
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
            HospitalReport_NewDao HospitalReport_New = new HospitalReport_NewDao();

            DataSet[] result = new DataSet[1];
            result[0] = HospitalReport_New.ExportHospitalReport();

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("HospitalReport_New");
            xlsExport.Export(ht, result, DownloadCookie);

        }
    }
}
