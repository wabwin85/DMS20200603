using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;

namespace DMS.Business.MasterData
{
    public interface IInvHospitalBLL
    {
        DataSet QueryInvHospitalCfg(Hashtable table, int start, int limit, out int totalRowCount);

        bool Delete(string ids);

        DataSet QueryInvHospitalCfgExport(Hashtable table);
    }
}
