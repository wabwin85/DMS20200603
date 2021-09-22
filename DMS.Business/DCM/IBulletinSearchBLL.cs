using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Coolite.Ext.Web;
using DMS.Model.Data;

namespace DMS.Business
{
    public interface IBulletinSearchBLL
    {
        DataSet QuerySelectMainByFilter(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet QueryTopTenBulletinMainOnLogin(Hashtable table);

        DataSet GetBulletinMainById(Hashtable table);

        DataSet GetBulletinMainUsedBySynthesHome(Hashtable table);

        bool UpdateRead(Hashtable table);

        bool UpdateConfirm(Hashtable table);

    }
}
