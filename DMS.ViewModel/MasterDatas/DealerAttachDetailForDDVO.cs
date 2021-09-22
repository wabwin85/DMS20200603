using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class DealerAttachDetailForDDVO : BaseQueryVO
    {
        public KeyValue WinFileType;

        public ArrayList RstAttachList = null;
        public ArrayList LstFileType = null;
        
        public String HidDealerId;
        public String HidDealerType;
        public String SelectAttachId;
        public String QryDDReportName;
        public DatePickerRange QryDDStartDate=null;
        public DatePickerRange QryDDEndDate=null;
        public String WinIptDDReportName;
        public String WinIptDDStartDate;
        public String WinIptDDEndDate;
        public bool WinIptIsHaveRedFlag;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
