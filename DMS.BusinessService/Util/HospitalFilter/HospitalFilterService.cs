using DMS.BusinessService;
using DMS.ViewModel.Util;
using Spring.Context;
using Spring.Context.Support;
using System;
using System.Data;
using DMS.Common.Extention;
using DMS.Common.Common;

namespace DMS.BusinessService.Util.HospitalFilter
{
    public class HospitalFilterService : ABaseQueryService
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
                    IHospitalFilterFac fac = iac.GetObject(model.DelegateBusiness + "_Service") as IHospitalFilterFac;

                    model.RstResult = fac.CreateHospitalFilter().GetHospitalList(model);
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
