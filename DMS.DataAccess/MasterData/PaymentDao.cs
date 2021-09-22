
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : Payment
 * Created Time: 2010-5-7 14:15:32
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
    /// Payment的Dao
    /// </summary>
    public class PaymentDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public PaymentDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Payment GetObject(Guid objKey)
        {
            Payment obj = this.ExecuteQueryForObject<Payment>("SelectPayment", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Payment> GetAll()
        {
            IList<Payment> list = this.ExecuteQueryForList<Payment>("SelectPayment", null);          
            return list;
        }


        /// <summary>
        /// 查询Payment
        /// </summary>
        /// <returns>返回Payment集合</returns>
		public IList<Payment> SelectByFilter(Payment obj)
		{ 
			IList<Payment> list = this.ExecuteQueryForList<Payment>("SelectByFilterPayment", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Payment obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePayment", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeletePayment", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Payment obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeletePayment", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Payment obj)
        {
            this.ExecuteInsert("InsertPayment", obj);           
        }


    }
}