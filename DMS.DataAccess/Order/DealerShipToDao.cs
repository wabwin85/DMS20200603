
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerShipTo
 * Created Time: 2011-2-10 12:18:07
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
    /// <summary>
    /// DealerShipTo的Dao
    /// </summary>
    public class DealerShipToDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerShipToDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerShipTo GetObject(Guid objKey)
        {
            DealerShipTo obj = this.ExecuteQueryForObject<DealerShipTo>("SelectDealerShipTo", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerShipTo> GetAll()
        {
            IList<DealerShipTo> list = this.ExecuteQueryForList<DealerShipTo>("SelectDealerShipTo", null);          
            return list;
        }


        /// <summary>
        /// 查询DealerShipTo
        /// </summary>
        /// <returns>返回DealerShipTo集合</returns>
		public IList<DealerShipTo> SelectByFilter(DealerShipTo obj)
		{ 
			IList<DealerShipTo> list = this.ExecuteQueryForList<DealerShipTo>("SelectByFilterDealerShipTo", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerShipTo obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerShipToById", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerShipTo", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerShipTo obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerShipTo", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerShipTo obj)
        {
            this.ExecuteInsert("InsertDealerShipTo", obj);
        }

        #region added by bozhenfei on 20110216
        public DealerShipTo GetDealerShipToByUser(Guid userId)
        {
            Hashtable table = new Hashtable();
            table.Add("DealerUserId", userId);
            DealerShipTo obj = this.ExecuteQueryForObject<DealerShipTo>("QueryDealerShipToByFilter", table);
            return obj;
        }
        #endregion

        public DealerShipTo GetParentDealerEmailAddressByDmaId(Guid dmaId)
        {
            Hashtable table = new Hashtable();
            table.Add("DmaId", dmaId);
            DealerShipTo obj = this.ExecuteQueryForObject<DealerShipTo>("QueryParentDealerEmailAddress", table);
            return obj;
        }

        public DealerShipTo GetDealerEmailAddressByDmaId(Guid dmaId)
        {
            Hashtable table = new Hashtable();
            table.Add("DmaId", dmaId);
            DealerShipTo obj = this.ExecuteQueryForObject<DealerShipTo>("QueryDealerEmailAddress", table);
            return obj;
        }     
    }
}