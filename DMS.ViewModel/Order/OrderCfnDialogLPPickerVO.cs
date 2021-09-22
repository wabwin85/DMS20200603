using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Order
{
    public class OrderCfnDialogLPPickerVO : BaseQueryVO
    {
        public string QryProductLine;
        public string QryCFN;
        public string QryCFNName;
        public bool DisplayCanOrder = true;//是否显示可定产品
        public bool chkShare;
        public string QryDealer;
        public string InstanceId;
        public string hidPriceTypeId;
        public string hidOrderType;
        public string hidOrderTypeId;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public ArrayList RstResultDetailList = null;
    }
}
