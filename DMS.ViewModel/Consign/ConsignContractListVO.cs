using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
namespace DMS.ViewModel.Consign
{
    public class ConsignContractListVO : BaseQueryVO
    {
        public KeyValue QryBu;
        public String QryDealer;
        public String QryContractNo;
        public KeyValue QryStatus;
        public KeyValue QryIsAuto;
        public KeyValue QryDiscountRule;
        public String QryHasUpn;
        public DatePickerRange QryContractDate;

        public ArrayList RstResultList = null;

        public ArrayList LstBu = null;
        public ArrayList LstDealer = null;
        //public KeyValue LstStatus;
        public IList<KeyValuePair<string, string>> LstStatus { get; set; }

    }


   

}
