
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceTransferForls
 * Created Time: 2019/1/15 13:43:27
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
    /// InterfaceTransferForls的Dao
    /// </summary>
    public class InterfaceTransferForlsDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public InterfaceTransferForlsDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceTransferForls GetObject(Guid objKey)
        {
            InterfaceTransferForls obj = this.ExecuteQueryForObject<InterfaceTransferForls>("SelectInterfaceTransferForls", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceTransferForls> GetAll()
        {
            IList<InterfaceTransferForls> list = this.ExecuteQueryForList<InterfaceTransferForls>("SelectInterfaceTransferForls", null);
            return list;
        }


        /// <summary>
        /// 查询InterfaceTransferForls
        /// </summary>
        /// <returns>返回InterfaceTransferForls集合</returns>
		public IList<InterfaceTransferForls> SelectByFilter(InterfaceTransferForls obj)
        {
            IList<InterfaceTransferForls> list = this.ExecuteQueryForList<InterfaceTransferForls>("SelectByFilterInterfaceTransferForls", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceTransferForls obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceTransferForls", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceTransferForls", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceTransferForls obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceTransferForls", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceTransferForls obj)
        {
            this.ExecuteInsert("InsertInterfaceTransferForls", obj);
        }

        public IList<InterfaceTransferForls> SelectTransferForLsByBatchNbrErrorOnly(string batchNbr)
        {
            IList<InterfaceTransferForls> list = this.ExecuteQueryForList<InterfaceTransferForls>("SelectTransferForLsByBatchNbrErrorOnly", batchNbr);
            return list;
        }
    }
}