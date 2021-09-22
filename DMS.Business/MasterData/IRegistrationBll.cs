using System;
using System.Collections.Generic;
using System.Collections;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using System.Data;
    using System.Collections;

    public interface IRegistrationBll
    {
        DataSet SelectDetailByFilter(Guid obj, int start, int limit, out int totalRowCount);
        RegistrationMain SelectMainByFilter(Guid obj);

        DataSet SelectMainByFilter(Hashtable obj, int start, int limit, out int totalRowCount);
    }
}
