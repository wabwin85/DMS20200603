
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : BulletinMain
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
    /// BulletinMain的Dao
    /// </summary>
    public class BulletinMainDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public BulletinMainDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public BulletinMain GetObject(Guid objKey)
        {
            BulletinMain obj = this.ExecuteQueryForObject<BulletinMain>("SelectBulletinMain", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<BulletinMain> GetAll()
        {
            IList<BulletinMain> list = this.ExecuteQueryForList<BulletinMain>("SelectBulletinMain", null);
            return list;
        }


        /// <summary>
        /// 查询BulletinMain
        /// </summary>
        /// <returns>返回BulletinMain集合</returns>
		public IList<BulletinMain> SelectByFilter(BulletinMain obj)
        {
            IList<BulletinMain> list = this.ExecuteQueryForList<BulletinMain>("SelectByFilterBulletinMain", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns> UpdateBulletinMainStatus
        public int Update(BulletinMain obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateBulletinMain", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteBulletinMain", objKey);
            return cnt;
        }


        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(BulletinMain obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteBulletinMain", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(BulletinMain obj)
        {
            this.ExecuteInsert("InsertBulletinMain", obj);
        }


        /**
         * added by songyuqi on 20100601
         **/
        public DataSet QuerySelectByFile(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("QuerySelectByFilterBulletinMain", obj, start, limit, out totalRowCount);
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns> 
        public int UpdateStatus(BulletinMain obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateBulletinMainStatus", obj);
            return cnt;
        }

        public DataSet QuerySelectByFileOfSearch(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("QuerySelectByFilterBulletinMainOfSearch", obj, start, limit, out totalRowCount);
        }

        public DataSet GetBulletinMainById(Hashtable table)
        {
            return base.ExecuteQueryForDataSet("QuerySelectBulletinMain", table);
        }

        public DataSet GetBulletinMainUsedBySynthesHome(Hashtable table)
        {
            return base.ExecuteQueryForDataSet("QuerySelectBulletinMainUsedBySynthesHome", table);
        }
        public DataSet QueryTopTenBulletinMainOnLogin(Hashtable obj)
        {
            return base.ExecuteQueryForDataSet("QueryTopTenBulletinMainOnLogin", obj);
        }
        public void update(BulletinMain obj)
        {
            this.ExecuteInsert("updateBulletinMain", obj);
        }
        public void Insertmain(Hashtable obj)
        {
            this.ExecuteInsert("InsertMain", obj);
        }

        public IList<Hashtable> SelectListForDashboard(bool IsDealer, Guid? DealerId)
        {
            Hashtable condition = new Hashtable();
            condition.Add("IsDealer", IsDealer);
            condition.Add("DealerId", DealerId);
            return base.ExecuteQueryForList<Hashtable>("DCM.BulletinMainMap.SelectListForDashboard", condition);
        }

        public Hashtable SelectInfoForDashboard(bool IsDealer, Guid? DealerId, Guid Id)
        {
            Hashtable condition = new Hashtable();
            condition.Add("IsDealer", IsDealer);
            condition.Add("DealerId", DealerId);
            condition.Add("Id", Id);
            return base.ExecuteQueryForObject<Hashtable>("DCM.BulletinMainMap.SelectInfoForDashboard", condition);
        }
    }
}