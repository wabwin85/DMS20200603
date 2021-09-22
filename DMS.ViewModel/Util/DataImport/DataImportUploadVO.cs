using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

namespace DMS.ViewModel.Util.DataImport
{
    public class DataImportUploadVO : BaseVO
    {
        public bool KeepFile;

        public NameValueCollection Parameters;
        public String UploadFile;

        public bool CheckResult;

        public Hashtable Results;
    }
}
