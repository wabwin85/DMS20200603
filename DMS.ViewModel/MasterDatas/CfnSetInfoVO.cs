using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas
{
    public class CfnSetInfoVO : BaseQueryVO
    {

        public String InstanceId;
        public bool isCanEditUPN = true;
        public String IptCFNSetChineseName;

        public String IptCFNSetEnglishName;
        public String IptCFNSetUOM;
        public String IptCFNSetUPN;
        public bool IptCFNSetCanOrder;
        public bool IptCFNSetTool;
        public bool IptCFNSetImpant;
        public bool IptCFNSetShare;
        public String IptCFNSetCINO;
        public String IptCFNSetPT7;
        public String IptCFNSetPT8;
        public String IptCFNSetDescription;

        public KeyValue IptBu=new KeyValue();

        public IList<KeyValue> LstBu = null;

        public ArrayList RstDetailList = null;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;

    }
    public struct CfnSetDetailVO
    {
        public string CustomerFaceNbr;
        public string ChineseName;
        public string EnglishName;
        public int DefaultQuantity;      
        public string CfnsId;
        public string CfnId;
    }
}
