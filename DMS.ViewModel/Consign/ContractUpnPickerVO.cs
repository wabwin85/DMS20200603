using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Consign
{
    public class ContractUpnPickerVO : BaseQueryVO
    {
        public String QryContractId;
        public String QryFilter;

        public IList<Hashtable> RstResultList;
    }
}
