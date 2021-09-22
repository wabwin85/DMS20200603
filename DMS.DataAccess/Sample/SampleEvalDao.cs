
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SampleEval
 * Created Time: 2016/3/8 17:09:23
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
    /// SampleEval的Dao
    /// </summary>
    public class SampleEvalDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public SampleEvalDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public SampleEval GetObject(Guid objKey)
        {
            SampleEval obj = this.ExecuteQueryForObject<SampleEval>("SelectSampleEval", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<SampleEval> GetAll()
        {
            IList<SampleEval> list = this.ExecuteQueryForList<SampleEval>("SelectSampleEval", null);          
            return list;
        }


        /// <summary>
        /// 查询SampleEval
        /// </summary>
        /// <returns>返回SampleEval集合</returns>
		public IList<SampleEval> SelectByFilter(SampleEval obj)
		{ 
			IList<SampleEval> list = this.ExecuteQueryForList<SampleEval>("SelectByFilterSampleEval", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(SampleEval obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateSampleEval", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSampleEval", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(SampleEval obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteSampleEval", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SampleEval obj)
        {
            this.ExecuteInsert("InsertSampleEval", obj);           
        }

        public DataSet GetSampleEvalListByCondition(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetSampleEvalListByCondition", ht);
            return ds;
        }
    }
}