using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using System.IO;
using DMS.Business.MasterData;

namespace DMS.Business
{
    public class ConsignmentDealerBLL : IConsignmentDealerBLL
    {
        public DataSet GetConsignmentDealer(Hashtable table)
        {
            using (ConsignmentDealerDao dao = new ConsignmentDealerDao())
            {
                DataSet ds = dao.SelectConsignmentDealerBy(table);

                return ds;
            }
        }
        public bool ChcekCfnSumbit(Guid CAH_ID, Guid DealerId, string ProductLineId, string CMID, out string rtnVal, out string rtnMsg, out string RtnRegMsg)
        {
            bool result = false;
            using (ConsignmentDealerDao dao = new ConsignmentDealerDao())
            {

                dao.ChcekCfnSumbit(CAH_ID, DealerId, ProductLineId, CMID, out  rtnVal, out  rtnMsg, out  RtnRegMsg);
            }
            return result;
        }
        public bool InsertDealer(string[] Constring, string CM_ID)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                ConsignmentDealerDao dao = new ConsignmentDealerDao();
                for (int i = 0; i < Constring.Length; i++)
                {



                    DataSet ds = dao.IsConsignmentDealerby(CM_ID,Constring[i]);
                    if (int.Parse(ds.Tables[0].Rows[0]["cnt"].ToString())==0)
                  {
                      dao.AddConsignmentDealerby(CM_ID, Constring[i]);
                  }
                }
                trans.Complete();
                result = true;
            }
            return result;
        }
        public bool DeleteDealer(Guid CdId)
        {
            bool result = false;
            using (ConsignmentDealerDao dao = new ConsignmentDealerDao())
            {
                dao.Delete(CdId);
                result = true;
            }
            return result;
        }
        public bool DelletePling(Guid id)
        {
            bool result = false;
            using (ConsignmentDealerDao dao = new ConsignmentDealerDao())
            {
                dao.DeleteConsignmentCfnby(id);
                result = true;
            }
            return result;
        }
        public DataSet GetConsignmentContractDealer(Hashtable table)
        {
            using (ConsignmentDealerDao dao = new ConsignmentDealerDao())
            {
                DataSet ds = dao.SelectConsignmentContractDealer(table);
                return ds;
            }
        }
    }
}
