
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerOrderSetting
 * Created Time: 2011-2-10 12:08:48
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
    /// DealerOrderSetting的Dao
    /// </summary>
    public class DealerOrderSettingDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerOrderSettingDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerOrderSetting GetObject(Guid objKey)
        {
            DealerOrderSetting obj = this.ExecuteQueryForObject<DealerOrderSetting>("SelectDealerOrderSetting", objKey);           
            return obj;
        }

        /// <summary>
        /// 根据DMAID得到实体
        /// </summary>
        /// <param name="dmaid"></param>
        /// <returns></returns>
        public DealerOrderSetting GetObjectByDmaId(Guid dealerId)
        {
            DealerOrderSetting obj = this.ExecuteQueryForObject<DealerOrderSetting>("SelectByDmaIdDealerOrderSetting", dealerId);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerOrderSetting> GetAll()
        {
            IList<DealerOrderSetting> list = this.ExecuteQueryForList<DealerOrderSetting>("SelectDealerOrderSetting", null);          
            return list;
        }


        /// <summary>
        /// 查询DealerOrderSetting
        /// </summary>
        /// <returns>返回DealerOrderSetting集合</returns>
		public IList<DealerOrderSetting> SelectByFilter(DealerOrderSetting obj)
		{ 
			IList<DealerOrderSetting> list = this.ExecuteQueryForList<DealerOrderSetting>("SelectByFilterDealerOrderSetting", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerOrderSetting obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerOrderSetting", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerOrderSetting", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerOrderSetting obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerOrderSetting", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerOrderSetting obj)
        {
            this.ExecuteInsert("InsertDealerOrderSetting", obj);           
        }


    }
}