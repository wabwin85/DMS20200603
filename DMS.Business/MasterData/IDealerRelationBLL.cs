using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using DMS.DataAccess;
    using DMS.Model;
    using System.Collections;
    using DMS.Common;

    public interface IDealerRelationBLL
    {
        IList<DealerRelation> SelectByFilter(DealerRelation obj, int start, int limit, out int totalRowCount);

        DealerRelation GetObject(Guid objKey);

        bool Verify(DealerRelation obj);
        bool Delete(Guid id);
        bool Save(DealerRelation obj);
        bool Insert(DealerRelation obj);
    }
}
