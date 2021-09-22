
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TrainMaster
 * Created Time: 2015/7/20 12:25:49
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;

namespace DMS.DataAccess
{
    using System.Data;

    /// <summary>
    /// TrainMaster的Dao
    /// </summary>
    public class TrainMasterDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public TrainMasterDao(): base()
        {
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TrainMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTrainMaster", obj);            
            return cnt;
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTrainMaster", objKey);            
            return cnt;
        }		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(TrainMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteTrainMaster", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TrainMaster obj)
        {
            this.ExecuteInsert("InsertTrainMaster", obj);           
        }

        public DataSet SelectTrainMasterList(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTrainMasterList", obj, start, limit, out totalCount);
            return ds;
        }

        public TrainMaster SelectTrainMasterInfo(String trainId)
        {
            TrainMaster ds = this.ExecuteQueryForObject<TrainMaster>("SelectTrainMasterInfo", trainId);
            return ds;
        }

        public int UpdateTrainMasterStatus(TrainMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTrainMasterStatus", obj);
            return cnt;
        }

        public DataSet SelectProductLineAreaList(String productLineId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductLineAreaList", productLineId);
            return ds;
        }
    }
}