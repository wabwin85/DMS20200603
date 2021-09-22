using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;

namespace DMS.ViewModel.MasterDatas
{
    public class TerritoryListVO : BaseQueryVO
    {               
        public String QryProvinceName;
        public String QryCityName;
        public String QryCountyName;


        public ArrayList RstResultList = null;        


        //public ArrayList LstUserID = null;

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
