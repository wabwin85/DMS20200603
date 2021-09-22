
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : MailDeliveryAddress
 * Created Time: 2013/10/11 11:21:28
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
    /// MailDeliveryAddress的Dao
    /// </summary>
    public class MailDeliveryAddressDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public MailDeliveryAddressDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public MailDeliveryAddress GetObject(Guid objKey)
        {
            MailDeliveryAddress obj = this.ExecuteQueryForObject<MailDeliveryAddress>("SelectMailDeliveryAddress", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<MailDeliveryAddress> GetAll()
        {
            IList<MailDeliveryAddress> list = this.ExecuteQueryForList<MailDeliveryAddress>("SelectMailDeliveryAddress", null);          
            return list;
        }


        /// <summary>
        /// 查询MailDeliveryAddress
        /// </summary>
        /// <returns>返回MailDeliveryAddress集合</returns>
		public IList<MailDeliveryAddress> SelectByFilter(MailDeliveryAddress obj)
		{ 
			IList<MailDeliveryAddress> list = this.ExecuteQueryForList<MailDeliveryAddress>("SelectByFilterMailDeliveryAddress", obj);          
            return list;
		}

        public IList<MailDeliveryAddress> QueryDCMSMailAddressByConditions(Hashtable obj)
        {
            IList<MailDeliveryAddress> list = this.ExecuteQueryForList<MailDeliveryAddress>("SelectDCMSMailAddressByConditions", obj);
            return list;
        }

        public IList<MailDeliveryAddress> QueryDCMSLPMailAddressByConditions(Hashtable obj)
        {
            IList<MailDeliveryAddress> list = this.ExecuteQueryForList<MailDeliveryAddress>("SelectDCMSLPMailAddressByConditions", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(MailDeliveryAddress obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateMailDeliveryAddress", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteMailDeliveryAddress", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(MailDeliveryAddress obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteMailDeliveryAddress", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(MailDeliveryAddress obj)
        {
            this.ExecuteInsert("InsertMailDeliveryAddress", obj);           
        }



        public IList<MailDeliveryAddress> QueryOrderMailAddressByConditions(Hashtable table)
        {
            IList<MailDeliveryAddress> list = this.ExecuteQueryForList<MailDeliveryAddress>("QueryOrderMailAddressByConditions", table);
            return list;
        }


        /// <summary>
        /// 查询MailDeliveryAddressByCondition
        /// </summary>
        /// <returns>返回MailDeliveryAddress集合</returns>
        public IList<MailDeliveryAddress> SelectMailDeliveryAddressByCondition(MailDeliveryAddress obj)
        {
            IList<MailDeliveryAddress> list = this.ExecuteQueryForList<MailDeliveryAddress>("SelectMailDeliveryAddressByCondition", obj);
            return list;
        }

    }
}