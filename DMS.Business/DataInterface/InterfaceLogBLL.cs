using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using Grapecity.DataAccess.Transaction;
using DMS.DataAccess;
using DMS.Model.DataInterface;
using System.Collections;
using System.Data;

namespace DMS.Business.DataInterface
{
   public class InterfaceLogBLL
    {
       public DataSet QueryInterfaceLog(Hashtable table, int start, int limit, out int totalRowCount)
       {
           using (InterfaceLogDao dao = new InterfaceLogDao())
           {
               return dao.SelectInterfaceDataByCondition(table, start, limit, out totalRowCount);
           }
       }
       public Hashtable GetInterfaceLogById(Guid id)
       {
           using (InterfaceLogDao dao = new InterfaceLogDao())
           {
               return dao.SelectInterfaceLogById(id);
           }
       }
       public DataSet GetLogExpor(Hashtable ht)
       {
           using (InterfaceLogDao dao = new InterfaceLogDao())
           {
               return dao.GetLogExpor(ht);
           }
       }
    }
}
