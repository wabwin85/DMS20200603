using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.Business.Shipment
{
    public interface ISellInDataBLL
    {
        DataSet QuerySellInData(Hashtable table, int start, int limit, out int totalRowCount);

        DataSet QuerySellInData(Hashtable table);
    }
}
