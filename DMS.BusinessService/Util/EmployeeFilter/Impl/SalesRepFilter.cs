using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model.ViewModel;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.ViewModel.Util;
using DMS.DataAccess.Interface;

namespace DMS.BusinessService.Util.EmployeeFilter.Impl
{
    public class SalesRepFilter : AEmployeeFilter
    {
        public override IList<Hashtable> GetEmployeeList(FilterVO model)
        {
            if (!model.QryString.IsNullOrEmpty())
            {
                TIQvSalesRepDao salesRepDao = new TIQvSalesRepDao();

                return salesRepDao.SelectSalesByHospital(model.Parameters.GetSafeStringValue("ProductLine"), model.Parameters.GetSafeStringValue("HospitalID"),
                                                      model.QryString);
            }
            else
            {
                return new List<Hashtable>();
            }
        }
    }
}
