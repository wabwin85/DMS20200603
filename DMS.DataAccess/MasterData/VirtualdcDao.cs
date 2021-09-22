
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : Virtualdc
 * Created Time: 2013/7/22 14:32:14
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
    /// Virtualdc的Dao
    /// </summary>
    public class VirtualdcDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public VirtualdcDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Virtualdc GetObject(Guid objKey)
        {
            Virtualdc obj = this.ExecuteQueryForObject<Virtualdc>("SelectVirtualdc", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Virtualdc> GetAll()
        {
            IList<Virtualdc> list = this.ExecuteQueryForList<Virtualdc>("SelectVirtualdc", null);          
            return list;
        }


        /// <summary>
        /// 查询Virtualdc
        /// </summary>
        /// <returns>返回Virtualdc集合</returns>
		public IList<Virtualdc> SelectByFilter(Virtualdc obj)
		{ 
			IList<Virtualdc> list = this.ExecuteQueryForList<Virtualdc>("SelectByFilterVirtualdc", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Virtualdc obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateVirtualdc", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteVirtualdc", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Virtualdc obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteVirtualdc", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Virtualdc obj)
        {
            this.ExecuteInsert("InsertVirtualdc", obj);           
        }


        /// <summary>
        /// 通过hashtable查询Warehouse
        /// </summary>
        /// <returns>返回Virtualdc集合</returns>
        public IList<Virtualdc> QueryForPlant(Hashtable obj)
        {
            IList<Virtualdc> list = this.ExecuteQueryForList<Virtualdc>("QueryForPlant", obj);
            return list;
        }

    }
}