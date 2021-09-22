
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.MasterDatas
{
    public class CfnSetListVO : BaseQueryVO
    {
        public KeyValue QryBu;
        public String QryCFN = String.Empty;
        public String QryCFNSetName = String.Empty;
        public String QryCFNSetUPN = String.Empty;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public List<string> DeleteSeleteID = new List<string>();
        public IList<KeyValue> ListBu = null;
    }
}
