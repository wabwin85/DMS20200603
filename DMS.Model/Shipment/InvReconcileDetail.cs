using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    [Serializable]
    public class InvReconcileDetail: BaseModel
    {
        public Guid Id { get; set; }

        public Guid? RCE_INV_ID { get; set; }
        public Guid? SPH_ID { get; set; }

        public Guid? CFN_ID { get; set; }

        public string CFN { get; set; }

        public string OrderNumber { get; set; } 

        public Guid? CompareUser { get; set; }

        public Guid? DMA_ID { get; set; }
        public string DMA_Name { get; set; }
        public Guid? Hospital_ID { get; set; }
        public string HospitalName { get; set; }
        public decimal TotalNumber { get; set; }
        public string CompareStatus { get; set; }

        public DateTime? CompareDate { get; set; }

        public Guid? ProductLineId { get; set; }

        public bool? IsDelete { get; set; }
    }
}
