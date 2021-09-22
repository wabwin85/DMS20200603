using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Report
{
    public class DealerHistoryInvDetailVO : BaseQueryVO
    {
        //查询条件
        public KeyValue QryBrand;
        public KeyValue QryDealer;
        
        public KeyValue QryProductLine;
        public String InventDate;
        public DatePickerRange QryInventDate;
        public String QryCFN;
        public String QryLotNumber;
        public ArrayList LstBrand = null;
        public ArrayList LstDealer;
        public IList<KeyValue> LstProductline = null;
        public ArrayList RstResultList = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
