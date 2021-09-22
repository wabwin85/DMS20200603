using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Util.DataImport
{
    public class DataImportErrorListVO : BaseVO
    {
        public String DelegateBusiness;

        public Hashtable Parameters;

        public DataTable RstResultList;
    }
}
