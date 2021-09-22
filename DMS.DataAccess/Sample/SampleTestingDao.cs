
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : SampleTesting
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
    /// SampleTesting的Dao
    /// </summary>
    public class SampleTestingDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public SampleTestingDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public SampleTesting GetObject(Guid objKey)
        {
            SampleTesting obj = this.ExecuteQueryForObject<SampleTesting>("SelectSampleTesting", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<SampleTesting> GetAll()
        {
            IList<SampleTesting> list = this.ExecuteQueryForList<SampleTesting>("SelectSampleTesting", null);          
            return list;
        }


        /// <summary>
        /// 查询SampleTesting
        /// </summary>
        /// <returns>返回SampleTesting集合</returns>
		public IList<SampleTesting> SelectByFilter(SampleTesting obj)
		{ 
			IList<SampleTesting> list = this.ExecuteQueryForList<SampleTesting>("SelectByFilterSampleTesting", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(SampleTesting obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateSampleTesting", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteSampleTesting", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(SampleTesting obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteSampleTesting", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(SampleTesting obj)
        {
            this.ExecuteInsert("InsertSampleTesting", obj);           
        }
        //lijie add 2016-03-07
        public IList<SampleTesting> SelectSampleTestingList(Guid HeadId)
        {
            IList<SampleTesting> list = this.ExecuteQueryForList<SampleTesting>("SelectSampleTestingList", HeadId);
            return list;
        }

    }
}