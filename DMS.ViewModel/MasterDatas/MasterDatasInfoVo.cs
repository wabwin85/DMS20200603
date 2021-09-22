using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas
{
    public class MasterDatasInfoVo : BaseQueryVO
    {
        public String QryApplyDate { get; set; }//申请时间
        public bool IptIsFlag = true;
        public String Year;
        public bool messages;
    }
}
