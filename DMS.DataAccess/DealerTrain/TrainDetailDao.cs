
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TrainDetail
 * Created Time: 2015/7/20 12:29:59
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
    /// TrainDetail的Dao
    /// </summary>
    public class TrainDetailDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public TrainDetailDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TrainDetail GetObject(Guid objKey)
        {
            TrainDetail obj = this.ExecuteQueryForObject<TrainDetail>("SelectTrainDetail", objKey);           
            return obj;
        }

        /// <summary>
        /// 查询TrainDetail
        /// </summary>
        /// <returns>返回TrainDetail集合</returns>
        public IList<TrainDetail> SelectTrainDetailByCondtition(TrainDetail obj)
		{
            IList<TrainDetail> list = this.ExecuteQueryForList<TrainDetail>("SelectTrainDetailByCondtition", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TrainDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTrainDetail", obj);            
            return cnt;
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTrainDetail", objKey);            
            return cnt;
        }

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int DeleteByCondition(TrainDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("DeleteByCondition", obj);
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TrainDetail obj)
        {
            this.ExecuteInsert("InsertTrainDetail", obj);           
        }


        public DataSet SelectDealerTrainDetailList(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerTrainDetailList", obj, start, limit, out totalCount);
            return ds;
        }

    }
}