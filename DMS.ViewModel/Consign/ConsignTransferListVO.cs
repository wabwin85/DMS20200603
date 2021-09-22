using DMS.ViewModel.Common;
using Lafite.RoleModel.Domain;
using System;
using System.Collections;
using System.Collections.Generic;

namespace DMS.ViewModel.Consign
{
    public class ConsignTransferListVO : BaseQueryVO
    {
        public KeyValue QryQueryType;
        public KeyValue QryBu;
        public String QryContractNo;
        public KeyValue QryStatus;
        public String QryDealer;
        public String QryUpn;

        public IList<Hashtable> RstResultList;

        public IList<KeyValue> LstQueryType;
        public IList<KeyValue> LstBu;
        public IList<KeyValuePair<String, String>> LstStatus;
    }
}
