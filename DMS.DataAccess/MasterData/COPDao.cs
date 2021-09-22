
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : COP
 * Created Time: 2009-7-9 11:31:09
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace DMS.DataAccess
{

    using DMS.Model;
    /// <summary>
    /// COP的Dao
    /// </summary>
    public class COPDao : BaseSqlMapDao
    {


        public DataSet SelectCOP_FY()
        {
            return base.ExecuteQueryForDataSet("SelectCOP_FY", null);
        }

        public DataSet SelectCOP_FQ()
        {
            return base.ExecuteQueryForDataSet("SelectCOP_FQ", null);
        }

        public DataSet SelectCOP_FM()
        {
            return base.ExecuteQueryForDataSet("SelectCOP_FM", null);
        }

        public DataSet SelectCOP_CurrentFY()
        {
            return base.ExecuteQueryForDataSet("SelectCOP_CurrentFY", null);
        }

        public DataSet SelectCOP_CurrentFQ()
        {
            return base.ExecuteQueryForDataSet("SelectCOP_CurrentFQ", null);
        }

        public DataSet SelectCOP_CurrentFM()
        {
            return base.ExecuteQueryForDataSet("SelectCOP_CurrentFM", null);
        }

    }
}
