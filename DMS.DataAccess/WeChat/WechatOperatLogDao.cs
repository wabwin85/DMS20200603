
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : WechatOperatLog
 * Created Time: 2014/10/22 11:32:53
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
    /// WechatOperatLog的Dao
    /// </summary>
    public class WechatOperatLogDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public WechatOperatLogDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public WechatOperatLog GetObject(Guid objKey)
        {
            WechatOperatLog obj = this.ExecuteQueryForObject<WechatOperatLog>("SelectWechatOperatLog", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<WechatOperatLog> GetAll()
        {
            IList<WechatOperatLog> list = this.ExecuteQueryForList<WechatOperatLog>("SelectWechatOperatLog", null);
            return list;
        }


        /// <summary>
        /// 查询WechatOperatLog
        /// </summary>
        /// <returns>返回WechatOperatLog集合</returns>
        public IList<WechatOperatLog> SelectByFilter(WechatOperatLog obj)
        {
            IList<WechatOperatLog> list = this.ExecuteQueryForList<WechatOperatLog>("SelectByFilterWechatOperatLog", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(WechatOperatLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateWechatOperatLog", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteWechatOperatLog", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(WechatOperatLog obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteWechatOperatLog", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(WechatOperatLog obj)
        {
            this.ExecuteInsert("InsertWechatOperatLog", obj);
        }


        public DataSet ExportUsageInfo(Hashtable table)
        {
            DataSet data = this.ExecuteQueryForDataSet("ExportUsageInfo", table);
            return data;
        }

        public DataSet ExportRegisterInfo()
        {
            DataSet data = this.ExecuteQueryForDataSet("ExportRegisterInfo", null);
            return data;
        }

        public void DeleteAllWechatOperatLog()
        {
            this.ExecuteDelete("DeleteWechatOperatLogTable", null);
        }

        public void InsertWechatLog(string Id, string BwuId, string OperatTime, string OperatMenu, string Rv1)
        {
            Hashtable ht = new Hashtable();
            ht.Add("Id", Id);
            ht.Add("BwuId", BwuId);
            ht.Add("OperatTime", OperatTime);
            ht.Add("OperatMenu", OperatMenu);
            ht.Add("Rv1", Rv1);

            try
            {
                this.ExecuteInsert("InsertWechatLog", ht);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}