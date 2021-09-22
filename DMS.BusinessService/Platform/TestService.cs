using DMS.BusinessService.Util.DataImport;
using DMS.BusinessService.Util.DataImport.Impl;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Platform
{
    public class TestService : ABaseBusinessService, IDataImportFac
    {
        public ADataImport CreateDataImport()
        {
            return new DataImportTest();
        }
    }
}
