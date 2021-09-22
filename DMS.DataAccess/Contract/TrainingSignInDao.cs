
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TrainingSignIn
 * Created Time: 2013/12/10 16:21:45
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
    /// TrainingSignIn的Dao
    /// </summary>
    public class TrainingSignInDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public TrainingSignInDao(): base()
        {
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TrainingSignIn obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTrainingSignIn", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTrainingSignIn", objKey);            
            return cnt;
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TrainingSignIn GetObject(Guid objKey)
        {
            TrainingSignIn obj = this.ExecuteQueryForObject<TrainingSignIn>("SelectTrainingSignIn", objKey);
            return obj;
        }
 
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TrainingSignIn obj)
        {
            this.ExecuteInsert("InsertTrainingSignIn", obj);           
        }

        public DataSet SelectTrainingSignInByContId(Guid obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTrainingSignInByContId", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectTrainingSignInByContId(Guid obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTrainingSignInByContId", obj);
            return ds;
        }
    }
}