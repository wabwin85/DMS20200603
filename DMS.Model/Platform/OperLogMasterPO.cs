using System;

namespace DMS.Model.Platform
{
    public class OperLogMasterPO
    {
        public Guid LogId { get; set; }
        public Guid? MainId { get; set; }
        public String OperUser { get; set; }
        public String OperUserEN { get; set; }
        public DateTime? OperDate { get; set; }
        public String OperType { get; set; }
        public String OperNote { get; set; }
        public String OperRole { get; set; }
        public String DataSource { get; set; }
        public String UserAccount { get; set; }
        public String DataContent { get; set; }
    }
}
