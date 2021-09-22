using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.MasterPage
{
    public class DealerSpecialUPNDao : BaseSqlMapDao
    {

        public DealerSpecialUPNDao()
            : base()
        {
        }

        public DataTable SelectDealerSpecialUPNList(string DealerID,string DealerType)
        {
            Hashtable tb = new Hashtable();
            tb.Add("DMA_ID", DealerID);
            tb.Add("DealerType", DealerType);
            DataTable ds = this.ExecuteQueryForDataSet("MasterPage.DealerSpecialUPN.SelectDealerSpecialUPNList", tb).Tables[0];
            return ds;
        }

        public DataTable SelectDealerSpecialUPNInfo(string Id)
        {
            Hashtable tb = new Hashtable();
            tb.Add("Id", Id);

            DataTable ds = this.ExecuteQueryForDataSet("MasterPage.DealerSpecialUPN.SelectDealerSpecialUPNInfo", tb).Tables[0];
            return ds;
        }
        public DataTable SelectDealerSpecialUPNQuery(string Id, string QryFilter, string Bu)
        {
            Hashtable tb = new Hashtable();
            tb.Add("Id", Id);
            tb.Add("Filter", QryFilter);
            tb.Add("Bu", Bu);

            DataTable ds = this.ExecuteQueryForDataSet("MasterPage.DealerSpecialUPN.SelectDealerSpecialUPNQuery", tb).Tables[0];
            return ds;
        }


        public DataTable DealerSpecialUPNPicker(string Id,string QryFilter,string Bu)
        {
            Hashtable tb = new Hashtable();
            tb.Add("Id", Id);
            tb.Add("Filter", QryFilter);
            tb.Add("Bu", Bu);
            DataTable ds = this.ExecuteQueryForDataSet("MasterPage.DealerSpecialUPN.DealerSpecialUPNPicker", tb).Tables[0];
            return ds;
        }


        public int Delete(string Id,string CFNID)
        {
            Hashtable tb = new Hashtable();
            tb.Add("Id", Id);
            tb.Add("CFN_ID", CFNID);
            int cnt = (int)this.ExecuteDelete("MasterPage.DealerSpecialUPN.Delete", tb);
            return cnt;
        }

        public void Insert(string DMA_ID, ArrayList CFN_ID,string CreateUser,DateTime CreateDate)
        {

            for (int i = 0; i < CFN_ID.Count; i++)
            {
                Hashtable tb = new Hashtable();
                tb.Add("DMA_ID", DMA_ID);
                tb.Add("CFN_ID", CFN_ID[i]);
                tb.Add("CreateUser", CreateUser);
                tb.Add("CreateDate", CreateDate);

                this.ExecuteInsert("MasterPage.DealerSpecialUPN.Insert", tb);
            }
        }


        public DataTable DealerType(string Type)
        {
            Hashtable tb = new Hashtable();
            tb.Add("DICT_TYPE", Type);
          
            DataTable ds = this.ExecuteQueryForDataSet("MasterPage.DealerSpecialUPN.DealerType", tb).Tables[0];
            return ds;
        }

    }
}
