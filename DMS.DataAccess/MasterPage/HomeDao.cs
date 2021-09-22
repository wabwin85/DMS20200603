using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.MasterPage
{
    public class HomeDao : BaseSqlMapDao
    {
        public HomeDao()
            : base()
        {
        }

        public DataSet SelectAdminPageSumInfo(string yearCode)
        {
            Hashtable tb = new Hashtable();
            tb.Add("YearCode", yearCode);

            DataSet ds = this.ExecuteQueryForDataSet("MasterPage.AdminHome.SelectAdminPageSum", tb);
            return ds;
        }

        public IList<Hashtable> SelectYearList()
        {
            return this.ExecuteQueryForList<Hashtable>("MasterPage.AdminHome.SelectYearList", null);
        }
    }
}
