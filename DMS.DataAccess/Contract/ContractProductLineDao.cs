
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ContractProductLine
 * Created Time: 2013/12/15 17:43:13
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using DMS.Model;
	
namespace DMS.DataAccess
{
    /// <summary>
    /// ContractProductLine的Dao
    /// </summary>
    public class ContractProductLineDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ContractProductLineDao(): base()
        {
        }

        public DataSet GetProductLineByDivisionID( Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductLineByDivisionID", obj);
            return ds;
        }

        public DataSet GetDivision(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDivision", obj);
            return ds;
        }



      


    }
}