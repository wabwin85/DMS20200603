using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas
{
    public class ConsignmentMasterUpnPickerVO : BaseQueryVO
    {
        public string QryProductLine;
        public string QryCFNCode;
        public string QryCFNName;
        public bool DisplayCanOrder=true;//是否显示可定产品

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public ArrayList RstResultDetailList = null;

        public string InstanceId;
        public string DealerParams;
    }
}
