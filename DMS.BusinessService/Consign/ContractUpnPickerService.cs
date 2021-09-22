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
    public class ContractUpnPickerService : ABaseQueryService
    {
        public ContractUpnPickerVO Query(ContractUpnPickerVO model)
        {
            try
            {
                ContractDetailDao contractDetailDao = new ContractDetailDao();

                model.RstResultList = contractDetailDao.SelectContractUpnList(model.QryContractId.ToSafeGuid(), base.UserInfo.CorpId.Value, model.QryFilter, BaseService.CurrentSubCompany?.Key, BaseService.CurrentBrand?.Key);
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
