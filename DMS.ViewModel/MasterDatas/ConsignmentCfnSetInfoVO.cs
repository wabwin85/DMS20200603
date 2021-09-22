using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas
{
    public class ConsignmentCfnSetInfoVO : BaseQueryVO
    {

        public String InstanceId;

        public String IptCFNSetChineseName;

        public String IptCFNSetEnglishName;

        public KeyValue IptBu = new KeyValue();

        public IList<KeyValue> LstBu = null;

        public ArrayList RstDetailList = null;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

    }
    public struct ConsignmentCfnSetDetailVO
    {
        public string CustomerFaceNbr;
        public string ChineseName;
        public string EnglishName;
        public int DefaultQuantity;
        public string CfnsId;
        public string CfnId;
    }
}
