using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using DMS.Model.ViewModel;
using System.Collections;
using DMS.ViewModel.Util;

namespace DMS.BusinessService.Util.EmployeeFilter
{
    public abstract class AEmployeeFilter : ABaseService
    {
        public abstract IList<Hashtable> GetEmployeeList(FilterVO model);
    }
}
