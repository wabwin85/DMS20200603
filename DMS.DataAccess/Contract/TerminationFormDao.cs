
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TerminationForm
 * Created Time: 2013/12/19 10:52:41
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
    /// TerminationForm的Dao
    /// </summary>
    public class TerminationFormDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public TerminationFormDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TerminationForm GetObject(Guid objKey)
        {
            TerminationForm obj = this.ExecuteQueryForObject<TerminationForm>("SelectTerminationForm", objKey);           
            return obj;
        }

        public TerminationForm GetTerminationFormByObj(Hashtable obj)
        {
            TerminationForm from = this.ExecuteQueryForObject<TerminationForm>("SelectTerminationFormById", obj);
            return from;
        }
        public DataSet GetTermination(string ContractNo)
        {
            DataSet dt = this.ExecuteQueryForDataSet("GetTermination", ContractNo);
            return dt;
        }
        public DataSet GetTerminationall(string ContractNo)
        {
            DataSet dt = this.ExecuteQueryForDataSet("GetTerminationall", ContractNo);
            return dt;
        }

        public void insertTerminationMainTemp(Hashtable obj)
        {
           this.ExecuteInsert("insertTerminationMainTemp", obj);
           
        }
        public void insertTerminationStatusTemp(Hashtable obj)
        {
           this.ExecuteInsert("insertTerminationStatusTemp", obj);
          
        }
        public void insertTerminationEndFormTemp(Hashtable obj)
        {
           this.ExecuteInsert("insertTerminationEndFormTemp", obj);
           
        }
        public void insertTerminationHandoverTemp(Hashtable obj)
        {
            this.ExecuteInsert("insertTerminationHandoverTemp", obj);
         
        }
        public void insertTerminationNCMTemp(Hashtable obj)
        {
           this.ExecuteInsert("insertTerminationNCMTemp", obj);
            
        }

        public DataSet GetUpdatelog(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTerminationUpdatelog", table, start, limit, out totalRowCount);
            return ds;
        }
    }
}