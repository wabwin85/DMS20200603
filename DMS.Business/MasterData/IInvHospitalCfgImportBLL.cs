using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace DMS.Business.MasterData
{
    public interface IInvHospitalCfgImportBLL
    {
        DataSet QueryErrorData(int start, int limit, out int totalCount);
    }
}
