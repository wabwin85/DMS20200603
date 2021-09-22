using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Order
{
    public class OrderCfnDialogT2PROPickerVO : BaseQueryVO
    {
        public string QryProductLine;
        public KeyValue QryProProductType;
        public string QryCFN;
        public string QryLeftNum;
        public bool DisplayCanOrder = true;//是否显示可定产品
        public bool chkShare;
        public string QryDealer;
        public string InstanceId;
        public string QryCFNName;
        public string QryDescription;
        public string hidPriceTypeId;
        public string hidOrderType;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstProProductTypeList = null;
        public ArrayList RstResultList = null;
        public ArrayList RstResultDetailList = null;
    }
}
