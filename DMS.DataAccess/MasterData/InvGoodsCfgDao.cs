using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess.MasterData
{
    public class InvGoodsCfgDao: BaseSqlMapDao
    {
        public IList<InvGoodsConfig> GetAll()
        {
            IList<InvGoodsConfig> list = this.ExecuteQueryForList<InvGoodsConfig>("SelectInvGoodsConfig", null);
            return list;
        }

        public DataSet SelectByFilter(Hashtable obj,int start,int limit, out int totalRowCount)
        {
            DataSet ds = base.ExecuteQueryForDataSet("SelectByFilterInvGoodsConfig", obj,start,limit,out totalRowCount);
            return ds;
        }

        public int Delete(Guid Id)
        {
            //int cnt = 0;
            int cnt = (int)this.ExecuteDelete("DeleteInvGoodsConfig", Id);
            return cnt;
        }

        public DataSet SelectByFilterForExport(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInvGoodsConfig", table);
            return ds;
        }
    }
}
