using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.ViewModel.POReceipt;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.SessionState;

namespace DMS.BusinessService.POReceipt
{
    public class POReceiPtImportService : IRequiresSessionState
    {
        private IPOReceipt business = new DMS.Business.POReceipt();

        private IRoleModelContext _context = RoleModelContext.Current;
        public POReceiPtImportVO Init(POReceiPtImportVO model)
        {
            try
            {
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        public string Query(POReceiPtImportVO model)
        {
            try
            {
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.SelectInterfaceShipmentBYBatchNbr(model.batchNumber, start, model.PageSize, out outCont);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = outCont;
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

    }
}
