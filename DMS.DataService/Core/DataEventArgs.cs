using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DMS.DataService.Core
{
    public class DataEventArgs : EventArgs
    {
        public bool Success { get; set; }
        public string BatchNbr { get; set; }
        public string Message { get; set; }
        public string ReturnXml { get; set; }

        public DataEventArgs(string batchNbr)
        {
            Success = false;
            BatchNbr = batchNbr;
            Message = null;
            ReturnXml = null;
        }

        public DataEventArgs(string batchNbr, string xml)
        {
            Success = false;
            BatchNbr = batchNbr;
            Message = null;
            ReturnXml = xml;
        }
    }
}
