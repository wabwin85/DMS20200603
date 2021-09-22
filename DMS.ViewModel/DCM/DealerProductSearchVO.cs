using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.DCM
{
    public class DealerProductSearchVO : BaseQueryVO
    {
        //查询条件
        public KeyValue QryProductLine;
        public String QryCFN;
        public String hidCfnId;
        public String WinProductLot;
        public String WinProductLotNew;

        public IList<KeyValue> LstProductline = null;
        public ArrayList RstResultList = null;
        public ArrayList RstWinRegistration = null;
        public ArrayList RstWinRegistrationBylot = null;
        public ArrayList RstWinRegistrationNew = null;
        public ArrayList RstWinRegistrationBylotNew = null;

        //分页
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
    }
}
