using System;
using System.Collections.Generic;
using System.Collections;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using System.Data;
    using System.Collections;

    public interface IRegistrationInitBLL
    {
        bool Import(DataSet ds);
        bool Verify(out string IsValid);

        DataSet QueryErrorData(int start, int limit, out int totalRowCount);
    }
}
