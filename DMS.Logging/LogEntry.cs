using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Logging
{
    [Serializable]
    public class LogEntry
    {
        public long LogId { get; set; }
        public string UserId { get; set; }
        public string Category { get; set; }
        public string EventId { get; set; }
        public DateTime EventTime { get; set; }
        public string EventMessage { get; set; }
    }
}
