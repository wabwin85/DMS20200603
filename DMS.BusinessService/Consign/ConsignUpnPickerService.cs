using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Collections.Specialized;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Consign;
using DMS.ViewModel.Common;
using DMS.DataAccess;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;

namespace DMS.BusinessService.Consign
{
    public class ConsignUpnPickerService : ABaseQueryService
    {
       

        public ConsignUpnPickerVO Query(ConsignUpnPickerVO model)
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
                    model.RstResultListSet = JsonHelper.DataTableToArrayList(ContractHeader.QuerySet(model.QryBu, model.QryDealer,model.QryFilter));
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
