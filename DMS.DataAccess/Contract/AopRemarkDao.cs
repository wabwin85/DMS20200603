
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : AopRemark
 * Created Time: 2014/7/20 13:51:31
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
    /// AopRemark的Dao
    /// </summary>
    public class AopRemarkDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public AopRemarkDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AopRemark GetObject(Guid objKey)
        {
            AopRemark obj = this.ExecuteQueryForObject<AopRemark>("SelectAopRemark", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<AopRemark> GetAll()
        {
            IList<AopRemark> list = this.ExecuteQueryForList<AopRemark>("SelectAopRemark", null);          
            return list;
        }


        /// <summary>
        /// 查询AopRemark
        /// </summary>
        /// <returns>返回AopRemark集合</returns>
		public IList<AopRemark> SelectByFilter(AopRemark obj)
		{ 
			IList<AopRemark> list = this.ExecuteQueryForList<AopRemark>("SelectByFilterAopRemark", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(AopRemark obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAopRemark", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAopRemark", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(AopRemark obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteAopRemark", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AopRemark obj)
        {
            this.ExecuteInsert("InsertAopRemark", obj);           
        }

        public int DeleteAopRemark(AopRemark ar)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAopRemarkByCondition", ar);
            return cnt;
        }

    }
}