using System;
using DMS.Model;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using DMS.Model.Data;

namespace DMS.Business
{
      public interface IBatchOrderInitBLL
      {

        int DeleteBatchOrderInit(Guid UserId);
        DataSet QueryBatchOrderInitErrorData(int start, int limit, out int totalRowCount);
        bool VerifyBatchOrderInitBLL(string ImportType, out string IsValid);

        bool ImportLP(DataTable dt, string fileName);

    }
}
