using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    [Serializable]
    public class InvReconcileSummary: BaseModel
    {
        public Guid Id { get; set; }

        public Guid? RCE_SPH_ID { get; set; }

        public string FailMsg { get; set; }

        public string CompareStatus { get; set; }

        public bool? IsSystemCompare { get; set; }

        public DateTime? CompareTime { get; set; }

        public Guid? UpdateUser { get; set; }

        public DateTime? CreateTime { get; set; }

        public DateTime? UpdateTime { get; set; }

        public bool? IsDelete { get; set; }
    }
}
