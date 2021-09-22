using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.Model;
namespace DMS.Business
{
    public interface IConsignmentApplyDetailsBLL
    {
        DataSet GetProlineCFNList(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet SelectConsignmentApplyProList(Guid id, int start, int limit, out int totalRowCount);
        ConsignmentApplyDetails GetConsignmentApplyDetailsSing(Guid id);
        bool UpdateConsignmentApplyDetails(ConsignmentApplyDetails det);
        bool DeleteCfn(Guid id);
        bool HeaderDtcfn(Guid id);
        DataSet SelectProductLineDma(string ProductLineID);
        DataSet SelecConsignmentApplyDetailsCfnSum(string PhonId);
     
    }
}
