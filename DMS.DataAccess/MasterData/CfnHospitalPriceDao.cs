
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : CfnHospitalPrice
 * Created Time: 2010-5-12 9:51:54
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
    /// CfnHospitalPrice的Dao
    /// </summary>
    public class CfnHospitalPriceDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public CfnHospitalPriceDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public CfnHospitalPrice GetObject(Guid objKey)
        {
            CfnHospitalPrice obj = this.ExecuteQueryForObject<CfnHospitalPrice>("SelectCfnHospitalPrice", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<CfnHospitalPrice> GetAll()
        {
            IList<CfnHospitalPrice> list = this.ExecuteQueryForList<CfnHospitalPrice>("SelectCfnHospitalPrice", null);          
            return list;
        }


        /// <summary>
        /// 查询CfnHospitalPrice
        /// </summary>
        /// <returns>返回CfnHospitalPrice集合</returns>
		public IList<CfnHospitalPrice> SelectByFilter(CfnHospitalPrice obj)
		{ 
			IList<CfnHospitalPrice> list = this.ExecuteQueryForList<CfnHospitalPrice>("SelectByFilterCfnHospitalPrice", obj);          
            return list;
		}

        /// <summary>
        /// 查询CfnHospitalPrice分页
        /// </summary>
        /// <returns>返回CfnHospitalPrice集合</returns>
        public IList<CfnHospitalPrice> SelectByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForList<CfnHospitalPrice>("SelectByFilterCfnHospitalPrice", obj, start, limit, out totalRowCount);
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(CfnHospitalPrice obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCfnHospitalPrice", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCfnHospitalPrice", objKey);            
            return cnt;
        }

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(CfnHospitalPrice obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteCfnHospitalPrice", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(CfnHospitalPrice obj)
        {
            this.ExecuteInsert("InsertCfnHospitalPrice", obj);           
        }


    }
}