
/**********************************************
 *
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerContract
 * Created Time: 2009-7-17 9:34:44
 * Author      : Donson
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
    /// DealerContract的Dao
    /// </summary>
    public class DealerContractDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerContractDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerContract GetObject(Guid objKey)
        {
            DealerContract obj = this.ExecuteQueryForObject<DealerContract>("SelectDealerContract", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerContract> GetAll()
        {
            IList<DealerContract> list = this.ExecuteQueryForList<DealerContract>("SelectDealerContract", null);          
            return list;
        }


        /// <summary>
        /// 查询DealerContract
        /// </summary>
        /// <returns>返回DealerContract集合</returns>
		public IList<DealerContract> SelectByFilter(DealerContract obj)
		{ 
			IList<DealerContract> list = this.ExecuteQueryForList<DealerContract>("SelectByFilterDealerContract", obj);          
            return list;
		}

        /// <summary>
        /// 查询DealerContract
        /// </summary>
        /// <returns>返回DealerContract集合</returns>
        public IList<DealerContract> SelectByFilter(DealerContract obj, int start , int limit , out int rowCount)
        {
            IList<DealerContract> list = this.ExecuteQueryForList<DealerContract>("SelectByFilterDealerContract", obj, start, limit, out rowCount);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerContract obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerContract", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerContract", obj);            
            return cnt;
        }


		
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerContract obj)
        {
            this.ExecuteInsert("InsertDealerContract", obj);           
        }

        //added by songyuqi on 20100901
        public int VerifyDealerIsUniqueness(Guid dealerID)
        {
            IList<DealerContract> list = this.ExecuteQueryForList<DealerContract>("SelectByDealerDealerContract", dealerID);
            return list.Count;
        }
        public DataSet SelectByDealerDealerContractActiveFlag(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByDealerDealerContractActiveFlag", obj);
            return ds;
        }
    }
}