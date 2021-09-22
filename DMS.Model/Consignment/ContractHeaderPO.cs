using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.Consignment
{
    public class ContractHeaderPO
    {
        public Guid CCH_ID { get; set; }
        public Guid? CCH_DMA_ID { get; set; }
        public String CCH_No { get; set; }
        public Guid? CCH_ProductLine_BUM_ID { get; set; }
        public String CCH_Status { get; set; }
        public int? CCH_ConsignmentDay { get; set; }
        public int? CCH_DelayNumber { get; set; }
        public DateTime? CCH_BeginDate { get; set; }
        public DateTime? CCH_EndDate { get; set; }
        public bool? CCH_IsFixedMoney { get; set; }
        public bool? CCH_IsFixedQty { get; set; }
        public bool? CCH_IsKB { get; set; }
        public bool? CCH_IsUseDiscount { get; set; }
        public String CCH_Remark { get; set; }
        public Guid? CCH_CreateUser { get; set; }
        public DateTime? CCH_CreateDate { get; set; }
        public String CCH_Name { get; set; }



    }
}
