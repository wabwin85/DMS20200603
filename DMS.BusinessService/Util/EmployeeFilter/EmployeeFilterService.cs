using DMS.BusinessService;
using DMS.ViewModel.Util;
using Spring.Context;
using Spring.Context.Support;
using System;
using System.Data;
using DMS.Common.Extention;
using DMS.Common.Common;

namespace DMS.BusinessService.Util.EmployeeFilter
{
    public class EmployeeFilterService : ABaseQueryService
    {
        public FilterVO Filter(FilterVO model)
        {
            try
            {
                if (model.DelegateBusiness.IsNullOrEmpty())
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("Empty of DelegateBusiness");
                }
                else
                {
                    IApplicationContext iac = ContextRegistry.GetContext();
                    IEmployeeFilterFac fac = iac.GetObject(model.DelegateBusiness + "_Service") as IEmployeeFilterFac;

                    model.RstResult = fac.CreateEmployeeFilter().GetEmployeeList(model);
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
    }
}
