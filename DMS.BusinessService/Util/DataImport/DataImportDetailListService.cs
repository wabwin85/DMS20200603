using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web.Security;
using System.Web;
using System.Reflection;
using Spring.Context.Support;
using Spring.Context;
using DMS.ViewModel.Util.DataImport;
using DMS.Common.Extention;
using DMS.Common.Common;

namespace DMS.BusinessService.Util.DataImport
{
    public class DataImportDetailListService : ABaseService
    {
        #region Ajax Method

        public DataImportDetailListVO Init(DataImportDetailListVO model)
        {
            try
            {
                if (model.DelegateBusiness.IsNullOrEmpty() || model.InstanceId.IsNullOrEmpty())
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("Empty of DelegateBusiness");
                }
                else
                {
                    IApplicationContext iac = ContextRegistry.GetContext();
                    IDataImportFac check = iac.GetObject(model.DelegateBusiness + "_Service") as IDataImportFac;

                    model = check.CreateDataImport().QueryDetailList(model);

                    model.IsSuccess = true;
                }
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

        #region Internal Function

        #endregion
    }
}
