
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : BulletinDetail
 * Created Time: 2010-5-26 12:53:19
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
    /// BulletinDetail的Dao
    /// </summary>
    public class BulletinDetailDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public BulletinDetailDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public BulletinDetail GetObject(Guid objKey)
        {
            BulletinDetail obj = this.ExecuteQueryForObject<BulletinDetail>("SelectBulletinDetail", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<BulletinDetail> GetAll()
        {
            IList<BulletinDetail> list = this.ExecuteQueryForList<BulletinDetail>("SelectBulletinDetail", null);          
            return list;
        }


        /// <summary>
        /// 查询BulletinDetail
        /// </summary>
        /// <returns>返回BulletinDetail集合</returns>
		public IList<BulletinDetail> SelectByFilter(BulletinDetail obj)
		{ 
			IList<BulletinDetail> list = this.ExecuteQueryForList<BulletinDetail>("SelectByFilterBulletinDetail", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(BulletinDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateBulletinDetail", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteBulletinDetail", objKey);            
            return cnt;
        }

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(BulletinDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteBulletinDetail", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(BulletinDetail obj)
        {
            this.ExecuteInsert("InsertBulletinDetail", obj);           
        }


        /** 
         * added by songyuqi on 20100601
         * **/

        /// <summary>
        /// 查询BulletinDetail带分页
        /// </summary>
        /// <returns>返回BulletinDetail集合</returns>
        public DataSet QuerySelectByFile(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("QuerySelectByFilterBulletinDetailSession", obj, start, limit, out totalRowCount);
        }

        /// <summary>
        /// 查询BulletinDetail不带分页
        /// </summary>
        /// <returns>返回BulletinDetail集合</returns>
        public IList<BulletinDetail> QuerySelectByFile(Hashtable obj)
        {
            return base.ExecuteQueryForList<BulletinDetail>("QuerySelectByFilterBulletinDetail", obj);
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns> 
        public int DeleteByMainId(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteBulletinDetailByMainId", objKey);
            return cnt;
        }

        public int UpdateRead(Hashtable table)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateBulletinDetailRead", table);
            return cnt;
        }

        public int UpdateConfirm(Hashtable table)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateBulletinDetailConfirm", table);
            return cnt;
        }
        public int Deletet(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteBulletinDetailBydealerId", objKey);
            return cnt;
        }
    }
}