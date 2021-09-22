using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Contract
{
    public class ContractMainVO : BaseQueryVO
    {
        //查询条件
        public KeyValue QryDealer;
        public KeyValue QryDealerType;
        public bool DisableSelect;

        public IList<Hashtable> LstDealer = null;
        public ArrayList LstDealerType = null;
        public ArrayList RstResultList = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
