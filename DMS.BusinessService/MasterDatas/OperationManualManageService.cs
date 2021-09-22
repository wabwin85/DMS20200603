using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.MasterDatas;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using System.Linq;
using System.Collections.Generic;
using System.Data;
using DMS.Business.Excel;
using System.Collections.Specialized;
using Newtonsoft.Json;
using DMS.Model;
using DMS.Business;
using DMS.DataAccess.Platform;

namespace DMS.BusinessService.MasterDatas
{
    public class OperationManualManageService : ABaseQueryService
    {
        #region AjaxMethod
        SystemManualDao dao = new SystemManualDao();
        public OperationManualManageVO Init(OperationManualManageVO model)
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

        public OperationManualManageVO Query(OperationManualManageVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryManualName))
                    param.Add("ManualName", model.QryManualName.ToSafeString());
                
                IList<Hashtable> query = null;
                
                query = dao.SelectListByType(param);
                model.RstResultList = query;
                
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            
            return model;
        }

        public OperationManualManageVO DeleteData(OperationManualManageVO model)
        {
            try
            {
                for (int i = 0; i < model.LstManualID.Count; i++)
                {
                    Hashtable ht = new Hashtable();
                    ht.Add("ManualId", model.LstManualID[i].ToSafeString());
                    
                    dao.FakeDelete(ht);
                }
                model.ExecuteMessage.Add("Success");
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        #endregion
    }
}
