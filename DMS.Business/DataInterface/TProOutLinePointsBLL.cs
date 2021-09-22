using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using DMS.DataAccess;
using Grapecity.DataAccess.Transaction;
using System.Collections;
using DMS.Model.Data;
using System.Data;

namespace DMS.Business.DataInterface
{
   public class TProOutLinePointsBLL
    {
       public void ImportInterfaceT_PRO_OutLinePoints(IList<TProOutLinePoints> list)
       {
           using (TransactionScope trans = new TransactionScope())
           {
               foreach (TProOutLinePoints item in list)
               {
                   using (TProOutLinePointsDao dao = new TProOutLinePointsDao())
                   {
                       dao.Insert(item);
                   }
               }
               trans.Complete();
           }
       }
       public void HandleInterfaceOutLinePointsData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
       {
           using (TProOutLinePointsDao dao = new TProOutLinePointsDao())
           {
               dao.HandleInterfaceOutLinePointsData(BatchNbr,ClientID,out RtnVal,out RtnMsg);
           }
       }
       public IList<TProOutLinePoints> SelectInterfacePROOutLinePointsonByBatchNbrErrorOnly(string BatchNbr)
       {
           using (TProOutLinePointsDao dao = new TProOutLinePointsDao())
           {
             return  dao.SelectInterfacePROOutLinePointsonByBatchNbrErrorOnly(BatchNbr);
           }
       }
       public DataSet QueryDMSCalculatedPoints(string clientID)
       {
           using (TProOutLinePointsDao dao = new TProOutLinePointsDao())
           {
               return dao.QueryDMSCalculatedPoints(clientID);
           }
       }
    }
}
