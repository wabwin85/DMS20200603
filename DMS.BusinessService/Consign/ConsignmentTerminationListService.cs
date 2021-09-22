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
using DMS.DataAccess.Consignment;
using DMS.Business;

namespace DMS.BusinessService.Consign
{
     public class ConsignmentTerminationListService : ABaseQueryService
    {

        public ConsignmentTerminationListVO Init(ConsignmentTerminationListVO model)
        {
            try
            {
                ConsignmentTerminationDao ContractHeader = new ConsignmentTerminationDao();
                model.InstanceId = Guid.NewGuid();
                model.LstStatus = DictionaryHelper.GetKeyValueList(SR.Consignment_ConsignmentTermination_Status);
                model.IsDealer = IsDealer;
                //model.LstStatus = JsonHelper.DataTableToArrayList(ContractHeader.QueryConsignContractType(SR.Consign_Contract_Type));
                //model.RstResultList = JsonHelper.DataTableToArrayList(ContractHeader.SelectConsignTerminationList(model.QryTerminationNo,model.QryStatus));
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ConsignmentTerminationListVO Query(ConsignmentTerminationListVO model)
        {
            try
            {
                ConsignmentTerminationDao ConsignmentTermination = new ConsignmentTerminationDao();

                if (IsDealer)
                {
                    model.RstResultList = JsonHelper.DataTableToArrayList(ConsignmentTermination.SelectConsignTerminationList(model.QryTerminationNo, model.QryStatus.Key, model.QryContractNo, RoleModelContext.Current.User.CorpId, BaseService.CurrentSubCompany?.Key, BaseService.CurrentBrand?.Key));
                }
                else
                {
                    model.RstResultList = JsonHelper.DataTableToArrayList(ConsignmentTermination.SelectConsignTerminationList(model.QryTerminationNo, model.QryStatus.Key, model.QryContractNo,null, BaseService.CurrentSubCompany?.Key, BaseService.CurrentBrand?.Key));
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
