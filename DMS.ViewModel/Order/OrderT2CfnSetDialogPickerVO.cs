using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Order
{
    public class OrderT2CfnSetDialogPickerVO:BaseQueryVO
    {

        public string QryProtectName;
        public string QryUpn;
        public string hidOrderTypeId;
        public string hidPriceTypeId;
        public String QryDealer;
        public String QryProductLine;


        public string InstanceId;
        public string CfnSetId;
        public string Param;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public ArrayList RstResultDetailList = null;
    }
}
