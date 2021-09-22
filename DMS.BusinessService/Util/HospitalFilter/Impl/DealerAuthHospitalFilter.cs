using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model.ViewModel;
using DMS.ViewModel.Util;
using DMS.DataAccess;
using DMS.Common.Extention;

namespace DMS.BusinessService.Util.HospitalFilter.Impl
{
    public class DealerAuthHospitalFilter : AHospitalFilter
    {
        public override IList<Hashtable> GetHospitalList(FilterVO model)
        {
            if (!model.QryString.IsNullOrEmpty())
            {
                HospitalDao hospitalDao = new HospitalDao();

                return hospitalDao.SelectFilterListDealerAuth(model.Parameters.GetSafeGuidValue("ProductLine"),
                                                              model.Parameters.GetSafeGuidValue("DealerId"),
                                                              DateTime.Now,
                                                              model.QryString);
            }
            else
            {
                return new List<Hashtable>();
            }
        }
    }
}
