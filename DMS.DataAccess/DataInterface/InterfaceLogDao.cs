
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceLog
 * Created Time: 2013/7/12 14:48:25
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// InterfaceLog的Dao
    /// </summary>
    public class InterfaceLogDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceLogDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceLog GetObject(Guid objKey)
        {
            InterfaceLog obj = this.ExecuteQueryForObject<InterfaceLog>("SelectInterfaceLog", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceLog> GetAll()
        {
            IList<InterfaceLog> list = this.ExecuteQueryForList<InterfaceLog>("SelectInterfaceLog", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceLog
        /// </summary>
        /// <returns>返回InterfaceLog集合</returns>
		public IList<InterfaceLog> SelectByFilter(InterfaceLog obj)
		{ 
			IList<InterfaceLog> list = this.ExecuteQueryForList<InterfaceLog>("SelectByFilterInterfaceLog", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceLog", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceLog", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceLog", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceLog obj)
        {
            this.ExecuteInsert("InsertInterfaceLog", obj);
        }

        #region added by bozhenfei on 20130715
        /// <summary>
        /// 根据批号更新
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateByBatchNbr(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceLogByBatchNbr", ht);
            return cnt;
        }
        #endregion
        #region addby lijie on 20160818
        public DataSet SelectInterfaceDataByCondition(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return this.ExecuteQueryForDataSet("SelectInterfaceDataByCondition", table, start, limit, out totalRowCount);
        }
        public Hashtable SelectInterfaceLogById(Guid objKey)
        {
            Hashtable ds = this.ExecuteQueryForObject<Hashtable>("SelectInterfaceLogById", objKey);
            return ds;
        }
        public DataSet QueryInterfaceeDataByCondition(Hashtable table)
        {
            
           
            DataSet ds = this.ExecuteQueryForDataSet("QueryInterfaceeDataByCondition", table);
            return ds;
        }
        public void UpdateInterfaceData(string DataStr, Guid UserId, string Status, string DataType, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("DataType", DataType);
            ht.Add("InterfaceString", DataStr);
            ht.Add("Status", Status);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);
            this.ExecuteInsert("GC_InterfaceData_SetStatus", ht);
            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
        public DataSet SelectInterfaceDataType(string type)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInterfaceDataTypeByOrderby", type);
            return ds;
        }
        public DataSet GetLogExpor(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetLogExpor", ht);
            return ds;
        }
        #endregion

    }
}