﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using DMS.Model.ViewModel;
using System.Collections;
using DMS.ViewModel.Util;

namespace DMS.BusinessService.Util.DealerFilter
{
    public abstract class ADealerFilter : ABaseService
    {
        public abstract IList<Hashtable> GetDealerList(FilterVO model);
        public abstract ArrayList GetDealerList(DealerScreenFilterVO model);
    }
}
