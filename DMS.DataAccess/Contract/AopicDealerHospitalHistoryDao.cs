
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : AopicDealerHospitalHistory
 * Created Time: 2014/4/4 22:18:02
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
    /// AopicDealerHospitalHistory的Dao
    /// </summary>
    public class AopicDealerHospitalHistoryDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public AopicDealerHospitalHistoryDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AopicDealerHospitalHistory GetObject(Guid objKey)
        {
            AopicDealerHospitalHistory obj = this.ExecuteQueryForObject<AopicDealerHospitalHistory>("SelectAopicDealerHospitalHistory", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<AopicDealerHospitalHistory> GetAll()
        {
            IList<AopicDealerHospitalHistory> list = this.ExecuteQueryForList<AopicDealerHospitalHistory>("SelectAopicDealerHospitalHistory", null);          
            return list;
        }


        /// <summary>
        /// 查询AopicDealerHospitalHistory
        /// </summary>
        /// <returns>返回AopicDealerHospitalHistory集合</returns>
		public IList<AopicDealerHospitalHistory> SelectByFilter(AopicDealerHospitalHistory obj)
		{ 
			IList<AopicDealerHospitalHistory> list = this.ExecuteQueryForList<AopicDealerHospitalHistory>("SelectByFilterAopicDealerHospitalHistory", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(AopicDealerHospitalHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAopicDealerHospitalHistory", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAopicDealerHospitalHistory", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(AopicDealerHospitalHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteAopicDealerHospitalHistory", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AopicDealerHospitalHistory obj)
        {
            this.ExecuteInsert("InsertAopicDealerHospitalHistory", obj);           
        }

        public DataSet GetHistoryAopHospitalProduct(AopicDealerHospitalHistory history, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHistoryAopHospitalProduct", history, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetHistoryAopHospitalProduct(AopicDealerHospitalHistory history)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHistoryAopHospitalProduct", history);
            return ds;
        }
    }
}