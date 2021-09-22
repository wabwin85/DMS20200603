using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.AOP
{
    public class HospitalAOPSearchVO : BaseQueryVO
    {
        //查询条件
        public KeyValue QryProductLine;
        public KeyValue QryDealer;
        public KeyValue QrySubProduct;
        public KeyValue QryQtSubProduct;
        public String QryYear;
        public bool DisableDealer;

        public IList<KeyValue> LstProductline = null;
        public IList<Hashtable> LstDealer = null;
        public ArrayList LstSubProduct = null;
        public ArrayList LstQtSubProduct = null;
        public ArrayList RstResultList = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
