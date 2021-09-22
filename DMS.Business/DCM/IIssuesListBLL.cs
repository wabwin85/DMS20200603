using System;
using System.Collections.Generic;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using System.Data;
    using System.Collections;

    public interface IIssuesListBLL
    {
        DataSet QuerySelectIssuesList(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QueryTopTenIssuesListOnLogin(Hashtable table);
        IssuesList GetObject(Guid id);
        int getMaxSortNo();
        bool VerifySortNo(string SortNo);

        bool DeleteIssues(Guid id);
        bool SaveIssues(IssuesList issues);
    }
}
