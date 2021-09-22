
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerCommonSetting
 * Created Time: 2013/7/19 10:23:36
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
    /// DealerCommonSetting的Dao
    /// </summary>
    public class DealerCommonSettingDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerCommonSettingDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerCommonSetting GetObject(Guid objKey)
        {
            DealerCommonSetting obj = this.ExecuteQueryForObject<DealerCommonSetting>("SelectDealerCommonSetting", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerCommonSetting> GetAll()
        {
            IList<DealerCommonSetting> list = this.ExecuteQueryForList<DealerCommonSetting>("SelectDealerCommonSetting", null);          
            return list;
        }


        /// <summary>
        /// 查询DealerCommonSetting
        /// </summary>
        /// <returns>返回DealerCommonSetting集合</returns>
		public IList<DealerCommonSetting> SelectByFilter(DealerCommonSetting obj)
		{ 
			IList<DealerCommonSetting> list = this.ExecuteQueryForList<DealerCommonSetting>("SelectByFilterDealerCommonSetting", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerCommonSetting obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerCommonSetting", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerCommonSetting", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerCommonSetting obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerCommonSetting", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerCommonSetting obj)
        {
            this.ExecuteInsert("InsertDealerCommonSetting", obj);           
        }

        public DealerCommonSetting SelectDealerCommonSettingbyDMA(Guid id)
        {
            DealerCommonSetting obj = this.ExecuteQueryForObject<DealerCommonSetting>("SelectDealerCommonSettingbyDMA", id);
            return obj;
        }

    }
}