using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.ViewModel.Transfer;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Transfer
{
    public class TransferInfoReasonService
    {
        ITransferBLL business = new TransferBLL();
        public TransferInfoReasonVO Init(TransferInfoReasonVO model)
        {
            try
            {
                DataSet ds = business.SelectLimitReason(RoleModelContext.Current.User.CorpId.Value);
                if (ds != null)
                    model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
    }

}
