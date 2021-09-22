using System;
using System.Collections.Generic;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using System.Data;
    using System.Collections;

    public interface IDealerQABLL
    {
        DataSet QuerySelectDealerQAByFilter(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QuerySelectDealerQAByFilterForDealer(Hashtable table, int start, int limit, out int totalRowCount);
        Dealerqa GetObject(Guid id);
        int GetConutByStatus(Hashtable table);

        bool InsertQuestionInfo(Dealerqa table, string hostUrl);
        bool InsertAnswer(Dealerqa table);
        bool DeleteItem(Guid id);

        DataSet QueryDealerQAOnLogin(Hashtable table);
        DataSet QueryDealerQAOnLoginForDealer(Hashtable table);

        IList<WaitProcessTask> QueryWaitForProcessByDealer(Hashtable table);
    }
}
