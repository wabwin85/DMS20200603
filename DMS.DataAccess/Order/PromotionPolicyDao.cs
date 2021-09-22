
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : PromotionPolicy
 * Created Time: 2014/11/24 17:27:44
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
using Lafite.RoleModel.Security;

namespace DMS.DataAccess
{
    /// <summary>
    /// PromotionPolicy的Dao
    /// </summary>
    public class PromotionPolicyDao : BaseSqlMapDao
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public PromotionPolicyDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PromotionPolicy GetObject(Guid objKey)
        {
            PromotionPolicy obj = this.ExecuteQueryForObject<PromotionPolicy>("SelectPromotionPolicy", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PromotionPolicy> GetAll()
        {
            IList<PromotionPolicy> list = this.ExecuteQueryForList<PromotionPolicy>("SelectPromotionPolicy", null);
            return list;
        }


        /// <summary>
        /// 查询PromotionPolicy
        /// </summary>
        /// <returns>返回PromotionPolicy集合</returns>
        public IList<PromotionPolicy> SelectByFilter(PromotionPolicy obj)
        {
            IList<PromotionPolicy> list = this.ExecuteQueryForList<PromotionPolicy>("SelectByFilterPromotionPolicy", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PromotionPolicy obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePromotionPolicy", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeletePromotionPolicy", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(PromotionPolicy obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeletePromotionPolicy", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PromotionPolicy obj)
        {
            this.ExecuteInsert("InsertPromotionPolicy", obj);
        }

        public DataSet QueryPromotionPolicy(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPromotionPolicy", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet ExportPromotionPolicy(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportPromotionPolicy", param);
            return ds;
        }

        public void SaveItem(decimal qty, string remark,string id)
        {
            Hashtable param = new Hashtable();
            param.Add("qty", qty);
            param.Add("remark", remark);
            param.Add("id", id);
            param.Add("AdjustUserId", this._context.User.Id);

            this.ExecuteInsert("GC_UpdatePromotionAdjustQty", param);
        }

        public DataSet QueryPromotionPolicyForT2(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPromotionPolicyForT2", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet ExportPromotionPolicyForT2(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportPromotionPolicyForT2", param);
            return ds;
        }

        public void SaveItemForT2(decimal qty, string remark, string id)
        {
            Hashtable param = new Hashtable();
            param.Add("qty", qty);
            param.Add("remark", remark);
            param.Add("id", id);
            param.Add("AdjustUserId", this._context.User.Id);

            this.ExecuteInsert("GC_UpdatePromotionAdjustQtyForT2", param);
        }

        public DataSet QueryPromotionPolicyT2(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPromotionPolicyT2", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet ExportPromotionPolicyT2(Hashtable param)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportPromotionPolicyT2", param);
            return ds;
        }
    }
}