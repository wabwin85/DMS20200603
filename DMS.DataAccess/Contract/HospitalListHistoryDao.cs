
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : HospitalListHistory
 * Created Time: 2014/4/4 23:33:46
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
    /// HospitalListHistory的Dao
    /// </summary>
    public class HospitalListHistoryDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public HospitalListHistoryDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public HospitalListHistory GetObject(Guid objKey)
        {
            HospitalListHistory obj = this.ExecuteQueryForObject<HospitalListHistory>("SelectHospitalListHistory", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<HospitalListHistory> GetAll()
        {
            IList<HospitalListHistory> list = this.ExecuteQueryForList<HospitalListHistory>("SelectHospitalListHistory", null);          
            return list;
        }


        /// <summary>
        /// 查询HospitalListHistory
        /// </summary>
        /// <returns>返回HospitalListHistory集合</returns>
		public IList<HospitalListHistory> SelectByFilter(HospitalListHistory obj)
		{ 
			IList<HospitalListHistory> list = this.ExecuteQueryForList<HospitalListHistory>("SelectByFilterHospitalListHistory", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(HospitalListHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateHospitalListHistory", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteHospitalListHistory", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(HospitalListHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteHospitalListHistory", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(HospitalListHistory obj)
        {
            this.ExecuteInsert("InsertHospitalListHistory", obj);           
        }

        public DataSet GetHistoryAuthorizedHospital(HospitalListHistory history, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHistoryAuthorizedHospital", history, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetHistoryAuthorizedHospital(HospitalListHistory history)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHistoryAuthorizedHospital", history);
            return ds;
        }

        public DataSet GetHistoryContracteHospital(HospitalListHistory history, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHistoryContracteHospital", history, start, limit, out totalCount);
            return ds;
        }
    }
}