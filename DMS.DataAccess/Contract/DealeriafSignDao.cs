
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealeriafSign
 * Created Time: 2014/6/13 14:02:20
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
    /// DealeriafSign的Dao
    /// </summary>
    public class DealeriafSignDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealeriafSignDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealeriafSign GetObject(Guid objKey)
        {
            DealeriafSign obj = this.ExecuteQueryForObject<DealeriafSign>("SelectDealeriafSign", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealeriafSign> GetAll()
        {
            IList<DealeriafSign> list = this.ExecuteQueryForList<DealeriafSign>("SelectDealeriafSign", null);          
            return list;
        }


        /// <summary>
        /// 查询DealeriafSign
        /// </summary>
        /// <returns>返回DealeriafSign集合</returns>
		public IList<DealeriafSign> SelectByFilter(DealeriafSign obj)
		{ 
			IList<DealeriafSign> list = this.ExecuteQueryForList<DealeriafSign>("SelectByFilterDealeriafSign", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealeriafSign obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealeriafSign", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealeriafSign", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealeriafSign obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealeriafSign", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealeriafSign obj)
        {
            this.ExecuteInsert("InsertDealeriafSign", obj);           
        }

        public int UpdateDealerIAFSignFrom3(DealeriafSign obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerIAFSign3", obj);
            return cnt;
        }

        public int UpdateDealerIAFSignFrom5(DealeriafSign obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerIAFSign5", obj);
            return cnt;
        }

        public int UpdateDealerIAFSignFrom6(DealeriafSign obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerIAFSign6", obj);
            return cnt;
        }

        public int UpdateThirdPartyFrom(DealeriafSign obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateThirdParty", obj);
            return cnt;
        }
    }
}