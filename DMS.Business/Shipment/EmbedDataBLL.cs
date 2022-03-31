using DMS.DataAccess;
using Lafite.RoleModel.Security;
using System.Collections;
using System.Data;

namespace DMS.Business
{
    public class EmbedDataBLL : IEmbedDataBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        public DataSet QueryEmbedData(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = new DataSet();

            EmbedDataDao dao = new EmbedDataDao();
            ds = dao.QueryEmbedDataInfo(table, start, limit, out totalRowCount);

            return ds;
        }

        public DataSet QueryEmbedData(Hashtable table)
        {
            DataSet ds = new DataSet();
            EmbedDataDao dao = new EmbedDataDao();
            ds = dao.QueryEmbedDataInfo(table);

            return ds;
        }
    }
}