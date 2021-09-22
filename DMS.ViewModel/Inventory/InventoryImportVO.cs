using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Inventory
{
    public class InventoryImportVO : BaseQueryVO
    {
        //主页面
        public KeyValue QryDealer;
        public String QryImportDate;
        public String DealerType;
        public String QryInvCount;
        public String QryInvQty;

        public IList<Hashtable> LstDealerName = null;
        public ArrayList RstResultList = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
