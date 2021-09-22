using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class DealerAttachDetailVO : BaseQueryVO
    {
        public KeyValue WinFileType;

        public ArrayList RstAttachList = null;
        public ArrayList LstFileType = null;
        
        public String HidDealerId;
        public String SelectAttachId;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
