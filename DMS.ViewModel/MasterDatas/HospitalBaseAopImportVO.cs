
using System;
using System.Collections.Generic;
using System.Collections;
using DMS.ViewModel.Common;

namespace DMS.ViewModel.MasterDatas
{
    public class HospitalBaseAopImportVO : BaseQueryVO
    {

        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
    }
}
