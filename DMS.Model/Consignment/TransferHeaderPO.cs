using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model.Consignment
{
    public class TransferHeaderPO
    {
        public Guid TH_ID { get; set; }
        public Guid? TH_DMA_ID_To { get; set; }
        public Guid? TH_DMA_ID_From { get; set; }
        public String TH_No { get; set; }
        public Guid? TH_ProductLine_BUM_ID { get; set; }
        public Guid? TH_CCH_ID { get; set; }
        public String TH_Status { get; set; }
        public Guid? TH_HospitalId { get; set; }
        public String TH_Remark { get; set; }
        public String TH_SalesAccount { get; set; }
        public Guid? TH_CreateUser { get; set; }
        public DateTime? TH_CreateDate { get; set; }
    }
}
