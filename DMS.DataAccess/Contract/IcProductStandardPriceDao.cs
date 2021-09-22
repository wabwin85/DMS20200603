
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : IcProductStandardPrice
 * Created Time: 2014/3/10 15:50:27
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
    /// IcProductStandardPrice的Dao
    /// </summary>
    public class IcProductStandardPriceDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public IcProductStandardPriceDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public IcProductStandardPrice GetObject(Guid objKey)
        {
            IcProductStandardPrice obj = this.ExecuteQueryForObject<IcProductStandardPrice>("SelectIcProductStandardPrice", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<IcProductStandardPrice> GetAll()
        {
            IList<IcProductStandardPrice> list = this.ExecuteQueryForList<IcProductStandardPrice>("SelectIcProductStandardPrice", null);          
            return list;
        }


        /// <summary>
        /// 查询IcProductStandardPrice
        /// </summary>
        /// <returns>返回IcProductStandardPrice集合</returns>
		public IList<IcProductStandardPrice> SelectByFilter(IcProductStandardPrice obj)
		{ 
			IList<IcProductStandardPrice> list = this.ExecuteQueryForList<IcProductStandardPrice>("SelectByFilterIcProductStandardPrice", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(IcProductStandardPrice obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateIcProductStandardPrice", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteIcProductStandardPrice", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(IcProductStandardPrice obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteIcProductStandardPrice", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(IcProductStandardPrice obj)
        {
            this.ExecuteInsert("InsertIcProductStandardPrice", obj);           
        }

        public IList<IcProductStandardPrice> GetHospitalProductByProductLineId(Hashtable obj)
        {
            IList<IcProductStandardPrice> list = this.ExecuteQueryForList<IcProductStandardPrice>("SelectHospitalProductByProductLineId", obj);
            return list;
        }
    }
}