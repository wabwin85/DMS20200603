using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Consignment
{
    public class ConsignmentReturnsPickerVO : BaseQueryVO
    {
        public string hidProductLine;
        public string hidCmId;
        public string hidDealerId;
        public String hidIahDmaId;


        public string InstanceId;
        public string CfnSetId;
        public string Param;
        public int Page = 0;
        public int PageSize = 0;
        public int DataCount = 0;
        public ArrayList RstResultList = null;
        public ArrayList RstResultDetailList = null;
    }
}
