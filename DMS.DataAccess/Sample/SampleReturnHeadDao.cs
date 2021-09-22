
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SampleReturnHead
 * Created Time: 2016/3/4 13:50:30
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
    /// SampleReturnHead的Dao
    /// </summary>
    public class SampleReturnHeadDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public SampleReturnHeadDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public SampleReturnHead GetObject(Guid objKey)
        {
            SampleReturnHead obj = this.ExecuteQueryForObject<SampleReturnHead>("SelectSampleReturnHead", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<SampleReturnHead> GetAll()
        {
            IList<SampleReturnHead> list = this.ExecuteQueryForList<SampleReturnHead>("SelectSampleReturnHead", null);          
            return list;
        }


        /// <summary>
        /// 查询SampleReturnHead
        /// </summary>
        /// <returns>返回SampleReturnHead集合</returns>
		public IList<SampleReturnHead> SelectByFilter(SampleReturnHead obj)
		{ 
			IList<SampleReturnHead> list = this.ExecuteQueryForList<SampleReturnHead>("SelectByFilterSampleReturnHead", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(SampleReturnHead obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateSampleReturnHead", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSampleReturnHead", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(SampleReturnHead obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteSampleReturnHead", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SampleReturnHead obj)
        {
            this.ExecuteInsert("InsertSampleReturnHead", obj);           
        }

         //ADD
        public DataSet SelectSampleReturnList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSampleReturnList", table, start, limit, out totalRowCount);
            return ds;
        }

        public SampleReturnHead SelectSampleReturnHeadByReturnNo(String returnNo)
        {
            SampleReturnHead obj = this.ExecuteQueryForObject<SampleReturnHead>("SelectSampleReturnHeadByReturnNo", returnNo);
            return obj;
        }

        public String FuncGetSampleReturnHtml(Guid returnId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("FuncGetSampleReturnHtml", returnId);
            return ds.Tables[0].Rows[0]["SampleReturnHtml"].ToString();
        }
    }
}