using System;
using System.Collections.Generic;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using DMS.Model;
    using System.Data;
    using System.Collections;

    public interface IBulletinManageBLL
    {
        DataSet QuerySelectMainByFilter(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet QuerySelectDetailByFilter(Hashtable table, int start, int limit, out int totalRowCount);

        BulletinMain GetObjectById(Guid MainID);

        bool DeleteDraft(Guid MainId);
        bool CancelledItem(Guid MainId);

        IList<BulletinDetail> QuerySelectDetailByFilter(Hashtable table);

        bool SaveBulletinSet(ChangeRecords<BulletinDetail> data, BulletinMain main);
        bool SaveBulletinSet(BulletinMain main, IList<BulletinDetail> list);

        bool deatil(Guid id);

        bool Updatemain(BulletinMain main);
        void insertmain(Hashtable obj);
        void InsertDetail(IList<BulletinDetail> list);

    }
}
