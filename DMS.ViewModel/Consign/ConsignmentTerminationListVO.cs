using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.Consign
{
    public class ConsignmentTerminationListVO : BaseQueryVO
    {
        public KeyValue QryStatus;

        public String QryTerminationNo;

        public String QryContractNo;

        public Guid InstanceId;

        public ArrayList RstResultList = null;

        public IList<KeyValuePair<string, string>> LstStatus { get; set; }
    }
}
