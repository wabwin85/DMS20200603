using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class PartsClsfcListVO : BaseQueryVO
    {
        //产品线
        public KeyValue QryProductLine;
        public string ParentID;
        public string ProductCatagoryPctId;
        public IList<KeyValue> LstProductLine = null;
        public ArrayList LstPartsClassification = null;
        
        public ArrayList LstContainProducts = null;
        public string PartsCls_ChangeRecords_Created;
        public string PartsCls_ChangeRecords_Deleted;
        

        //产品
        public KeyValue WinProductLine;
        public String WinProductModel;
        public KeyValue WinIsContain;
        public ArrayList RstProductInfo = null;

        //Tree
        public String hidSelectNodeId;
        public String ChangeNodeId;
        public String PartName;
        public String PartENName;
        public String PartDes;
        public String ProductLineId;
        public String ParentCode;
        public String Code;
        public String ClsNode;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
