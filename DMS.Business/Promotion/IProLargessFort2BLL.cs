using System;
using System.Collections.Generic;
using System.Data;
using System.Collections;
using DMS.Model;

namespace DMS.Business
{
    public interface IProLargessFort2BLL
    {
        int DeleteLargessForT2Init(Guid UserId);
        bool ImportLargessForT2(DataTable dt, string fileName);
        bool VerifyLargessForT2InitBLL(string ImportType, out string IsValid);
        DataSet QueryLargessForT2ErrorData(int start, int limit, out int totalRowCount);
        DataSet LargessForT2InitSumString();
    }
}
