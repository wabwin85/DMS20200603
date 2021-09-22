
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : AopDealerHospitaHistory
 * Created Time: 2014/4/4 22:15:07
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
    /// AopDealerHospitaHistory的Dao
    /// </summary>
    public class AopDealerHospitaHistoryDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public AopDealerHospitaHistoryDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AopDealerHospitaHistory GetObject(Guid objKey)
        {
            AopDealerHospitaHistory obj = this.ExecuteQueryForObject<AopDealerHospitaHistory>("SelectAopDealerHospitaHistory", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<AopDealerHospitaHistory> GetAll()
        {
            IList<AopDealerHospitaHistory> list = this.ExecuteQueryForList<AopDealerHospitaHistory>("SelectAopDealerHospitaHistory", null);          
            return list;
        }


        /// <summary>
        /// 查询AopDealerHospitaHistory
        /// </summary>
        /// <returns>返回AopDealerHospitaHistory集合</returns>
		public IList<AopDealerHospitaHistory> SelectByFilter(AopDealerHospitaHistory obj)
		{ 
			IList<AopDealerHospitaHistory> list = this.ExecuteQueryForList<AopDealerHospitaHistory>("SelectByFilterAopDealerHospitaHistory", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(AopDealerHospitaHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAopDealerHospitaHistory", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAopDealerHospitaHistory", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(AopDealerHospitaHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteAopDealerHospitaHistory", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AopDealerHospitaHistory obj)
        {
            this.ExecuteInsert("InsertAopDealerHospitaHistory", obj);           
        }

        public DataSet GetHistoryAopHospital(AopDealerHospitaHistory history, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHistoryAopHospital", history, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetHistoryAopHospital(AopDealerHospitaHistory history)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHistoryAopHospital", history);
            return ds;
        }
    }
}