using System.Collections;
using System.Data;

namespace DMS.Business
{
    public interface IEmbedDataBLL
    {
        DataSet QueryEmbedData(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet QueryEmbedData(Hashtable table);
    }
}