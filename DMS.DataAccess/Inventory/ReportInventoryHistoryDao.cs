
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ReportInventoryHistory
 * Created Time: 2013/8/27 14:27:28
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
    /// ReportInventoryHistory的Dao
    /// </summary>
    public class ReportInventoryHistoryDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public ReportInventoryHistoryDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ReportInventoryHistory GetObject(Guid objKey)
        {
            ReportInventoryHistory obj = this.ExecuteQueryForObject<ReportInventoryHistory>("SelectReportInventoryHistory", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ReportInventoryHistory> GetAll()
        {
            IList<ReportInventoryHistory> list = this.ExecuteQueryForList<ReportInventoryHistory>("SelectReportInventoryHistory", null);
            return list;
        }


        /// <summary>
        /// 查询ReportInventoryHistory
        /// </summary>
        /// <returns>返回ReportInventoryHistory集合</returns>
        public IList<ReportInventoryHistory> SelectByFilter(ReportInventoryHistory obj)
        {
            IList<ReportInventoryHistory> list = this.ExecuteQueryForList<ReportInventoryHistory>("SelectByFilterReportInventoryHistory", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ReportInventoryHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateReportInventoryHistory", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteReportInventoryHistory", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ReportInventoryHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteReportInventoryHistory", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ReportInventoryHistory obj)
        {
            this.ExecuteInsert("InsertReportInventoryHistory", obj);
        }


        public int UpdateForShipment(Hashtable table)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateReportInventoryHistoryForShipment", table);
            return cnt;
        }

        public int UpdateForUpload(Hashtable table)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateReportInventoryHistoryForUpload", table);
            return cnt;
        }
    }
}