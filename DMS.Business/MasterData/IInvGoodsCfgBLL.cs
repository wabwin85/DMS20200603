using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;

namespace DMS.Business.MasterData
{
    public interface IInvGoodsCfgBLL
    {
        DataSet QueryInvGoodsCfg(Hashtable table, int start, int limit, out int totalRowCount);

        bool Delete(Guid id);

        DataSet QueryInvGoodsCfgForExport(Hashtable table);
    }
}
