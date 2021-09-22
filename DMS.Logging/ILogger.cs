using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Logging
{
    public interface ILogger
    {
        void WriteLog(LogEntry log);
    }
}
