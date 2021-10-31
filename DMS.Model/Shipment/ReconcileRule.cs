using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Model
{
    [Serializable]
    public class ReconcileRule: BaseModel
    {
        public Guid Id { get; set; }
        
        public string Rules { get; set; }

        public string UpdatedBy { get; set; }

        public DateTime? UpdateTime { get; set; }

        public bool DeleteFlag { get; set; }
    }
}
