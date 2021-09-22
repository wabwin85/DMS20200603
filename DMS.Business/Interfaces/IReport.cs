using System;
using System.Collections.Generic;
using DMS.Model;
using System.Data;
using System.Collections;

namespace DMS.Business
{
    public interface IReport
    {
        DataSet QueryDealerTransferReport(Hashtable table);

        DataSet QueryDealerTransferOutReport(Hashtable table);

        DataSet QueryDealerTransferInReport(Hashtable table);
    }
}
