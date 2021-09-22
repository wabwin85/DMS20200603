using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.Consignment
{
    public class ConsignmentTerminationPO
    {
        public String CST_ID { get; set; }
        public String CST_CCH_ID { get; set; }
        public String CST_No { get; set; }
        public String CST_Status { get; set; }
        public String CST_Reason { get; set; }
        public String CST_Remark { get; set; }
        public String CST_CreateUser { get; set; }
        public String CST_CreateDate { get; set; }
    }
}
