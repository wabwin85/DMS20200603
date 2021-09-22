using System;
using System.Collections.Specialized;

namespace DMS.BusinessService
{
    public interface IQueryExport
    {
        void Export(NameValueCollection Parameters, String DownloadCookie);
    }
}
