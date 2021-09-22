using DMS.ViewModel.Common;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.MasterDatas
{
    public class MasterDatasListVo:BaseQueryVO
    {
        public String QryApplyDate { get; set; }
       // public DatePickerRange QryApplyDate;//申请时间
        public ArrayList RstResultList;
    }
}
