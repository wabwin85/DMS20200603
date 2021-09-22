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
using DMS.DataAccess.ContractElectronic;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using DMS.ViewModel;
using DMS.Common.Extention;
using DMS.Model.Consignment;
using DMS.DataAccess.Consignment;

namespace DMS.BusinessService.Consign
{
    public class ConsignCommonService : ABaseService
    {
        public SimpleVO QueryConsingContract(SimpleVO model)
        {
            try
            {
                ContractHeaderDao contractHeaderDao = new ContractHeaderDao();

                ContractHeaderPO result = contractHeaderDao.SelectById(model.QryString.ToSafeGuid());
                Hashtable rtn = new Hashtable();
                rtn.Add("ContractId", result.CCH_ID.ToSafeString());
                rtn.Add("ContractName", result.CCH_Name);
                rtn.Add("ContractNo", result.CCH_No);
                rtn.Add("ConsignDay", result.CCH_ConsignmentDay.Value.ToIntString());
                rtn.Add("DelayTimes", result.CCH_DelayNumber.Value.ToIntString());
                rtn.Add("ContractDate", result.CCH_BeginDate.Value.To_yyyy_MM_dd() + " - " + result.CCH_EndDate.Value.To_yyyy_MM_dd());
                rtn.Add("Kb", result.CCH_IsKB);
                rtn.Add("FixedMoney", result.CCH_IsFixedMoney);
                rtn.Add("FixedQuantity", result.CCH_IsFixedQty);
                rtn.Add("UseDiscount", result.CCH_IsUseDiscount);
                rtn.Add("Remark", result.CCH_Remark);

                model.RstResult = rtn;
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
