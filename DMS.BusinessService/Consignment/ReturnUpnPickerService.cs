using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.Consignment;
using DMS.ViewModel.Consignment;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Consignment
{
    public class ReturnUpnPickerService : ABaseQueryService
    {
        public ReturnUpnPickerVO Query(ReturnUpnPickerVO model)
        {
            try
            {
                ContractHeaderDao ContractHeader = new ContractHeaderDao();

                String cfnType = model.QryQueryType.Key.Equals("upn") ? "UPN" : "组套";

                if (cfnType == "UPN")
                {
                    model.RstResultList = JsonHelper.DataTableToArrayList(ContractHeader.QueryUPN(model.QryBu, model.QryDealer, model.QryFilter));
                }
                else
                {
                    model.RstResultListSet = JsonHelper.DataTableToArrayList(ContractHeader.QuerySet(model.QryBu, model.QryDealer, model.QryFilter));
                }

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
    }
}
