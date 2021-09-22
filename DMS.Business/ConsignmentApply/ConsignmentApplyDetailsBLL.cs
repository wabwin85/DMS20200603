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
    public class ConsignmentApplyDetailsBLL : IConsignmentApplyDetailsBLL
    {
        public DataSet GetProlineCFNList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                DataSet ds = dao.SelectProlineCFNList(table, start, limit, out totalRowCount);
                return ds;
            }
        }
        public bool AddSpecialCfn(Guid headerId, Guid dealerId, string cfnString, string specialPriceId, string orderType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                dao.AddSpeicalCfn(headerId, dealerId, cfnString, specialPriceId, orderType, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }
        public bool AddCfnSet(Guid headerId, Guid dealerId, string cfnString, string PriceType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                dao.AddConsignmentCfnset(headerId, dealerId, cfnString, PriceType, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }
        public bool AddConsignmenfnInventCfn(Guid headerId, string dealerId, string cfnString, string OrderType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                dao.AddConsignmenfnInventCfn(headerId, dealerId, cfnString, OrderType, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out rtnVal, out rtnMsg);
                result = true;
            }
            return result;

        }



        public DataSet SelectConsignmentApplyProList(Guid id, int start, int limit, out int totalRowCount)
        {
            Hashtable table = new Hashtable();
            table.Add("CAH_ID", id);

            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                DataSet ds = dao.SelectConsignmentApplyProList(table, start, limit, out totalRowCount);
                return ds;
            }
        }
        public ConsignmentApplyDetails GetConsignmentApplyDetailsSing(Guid id)
        {
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                ConsignmentApplyDetails dt = dao.GetObject(id);
                return dt;
            }
        }
        public bool UpdateConsignmentApplyDetails(ConsignmentApplyDetails det)
        {
            bool result = false;
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                dao.Update(det);
                result = true;

            }
            return result;
        }
        public bool DeleteCfn(Guid id)
        {
            bool result = false;
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                int i = dao.Delete(id);
                result = true;
            }
            return result;
        }
        public bool HeaderDtcfn(Guid id)
        {
            bool result = false;
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                int i = dao.DeleteHeaderConsignmentApplyDetails(id);
                result = true;
            }
            return result;
        }
        public DataSet SelectProductLineDma(string ProductLineID)
        {
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                DataSet ds = dao.SelectProductLineDma(ProductLineID);
                return ds;
            }

        }
        public DataSet SelecConsignmentApplyDetailsCfnSum(string PhonId)
        {
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                DataSet ds = dao.SelecConsignmentApplyDetailsCfnSum(PhonId);
                return ds;
            }
        }
    }
}
