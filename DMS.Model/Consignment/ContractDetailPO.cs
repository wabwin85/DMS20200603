using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.Consignment
{
    public class ContractDetailPO
    {
        public Guid CCH_ID { get; set; }

        public Guid CCD_CCH_ID { get; set; }
        public String CCD_CfnShortNumber { get; set; }
        public String CCD_CfnType { get; set; }
        public String CCD_Remark { get; set; }
       
    }
}
