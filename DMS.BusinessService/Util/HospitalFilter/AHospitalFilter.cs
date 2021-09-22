using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using DMS.Model.ViewModel;
using System.Collections;
using DMS.ViewModel.Util;

namespace DMS.BusinessService.Util.HospitalFilter
{
    public abstract class AHospitalFilter : ABaseService
    {
        public abstract IList<Hashtable> GetHospitalList(FilterVO model);
    }
}
