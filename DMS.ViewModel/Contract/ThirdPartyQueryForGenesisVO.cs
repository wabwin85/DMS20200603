using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Contract
{
    public class ThirdPartyQueryForGenesisVO : BaseQueryVO
    {
        //主页面
        public KeyValue QryDealer;
        public KeyValue QryApprovalStatus;
        public KeyValue QryIsAttach;
        public String QryHospitalName;
        public KeyValue QryIsHospital;
        public bool DisableSelect;

        public ArrayList RstResultList = null;
        public IList<Hashtable> LstDealer = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
