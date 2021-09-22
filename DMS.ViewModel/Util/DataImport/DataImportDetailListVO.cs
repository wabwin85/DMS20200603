using DMS.ViewModel.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.ViewModel.Util.DataImport
{
    public class DataImportDetailListVO : BaseVO
    {
        public String DelegateBusiness;
        public String InstanceId;

        public DataTable RstResultList;
        public IList<KendoColumn> RstResultColumn;
    }
}
