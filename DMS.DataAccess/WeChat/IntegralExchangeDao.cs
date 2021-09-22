
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : IntegralExchange
 * Created Time: 2014/10/11 16:42:11
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
    /// IntegralExchange的Dao
    /// </summary>
    public class IntegralExchangeDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public IntegralExchangeDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public IntegralExchange GetObject(Guid objKey)
        {
            IntegralExchange obj = this.ExecuteQueryForObject<IntegralExchange>("SelectIntegralExchange", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<IntegralExchange> GetAll()
        {
            IList<IntegralExchange> list = this.ExecuteQueryForList<IntegralExchange>("SelectIntegralExchange", null);          
            return list;
        }


        /// <summary>
        /// 查询IntegralExchange
        /// </summary>
        /// <returns>返回IntegralExchange集合</returns>
		public IList<IntegralExchange> SelectByFilter(IntegralExchange obj)
		{ 
			IList<IntegralExchange> list = this.ExecuteQueryForList<IntegralExchange>("SelectByFilterIntegralExchange", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(IntegralExchange obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateIntegralExchange", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteIntegralExchange", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(IntegralExchange obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteIntegralExchange", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(IntegralExchange obj)
        {
            this.ExecuteInsert("InsertIntegralExchange", obj);           
        }

        public DataSet QuerySelectGiftsByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("QuerySelectGiftsByFilter", obj, start, limit, out totalRowCount);
        }

        public DataSet GetGiftByMainId(string number, int start, int limit, out int totalCount)
        {
            return base.ExecuteQueryForDataSet("GetGiftByMainId", number, start, limit, out totalCount);
        }

        public void UpdateRedeemGiftStatus(Hashtable param)
        {
            this.ExecuteUpdate("UpdateRedeemGiftStatus", param); 
        }

        public void UpdateRejectStatus(Hashtable param)
        {
            this.ExecuteUpdate("UpdateRejectStatus", param); 
        }

        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public DataSet GetAllIntegralExchange()
        {
            DataSet list = this.ExecuteQueryForDataSet("SelectallIntegralExchange", null);
            return list;
        }


        public DataSet GetAllApprovedIntegralExchange()
        {
            DataSet list = this.ExecuteQueryForDataSet("selectAllApprovedIntegralExchange", null);
            return list;
        }

        public void InsertIntegralExchangeToDms(string txtId, string txtUserId, string txtStatus, string txtGiftId, 
            string txtExchangenumber, string txtDocumentnumber, string txtDeliverNumber, string txtReturnIntegral, string txtTypes, string txtData, string txtGiftName)
        {
            Hashtable ht = new Hashtable();
            ht.Add("Id", txtId);
            ht.Add("UserId", txtUserId);
            ht.Add("Status", txtStatus);
            ht.Add("GiftId", txtGiftId);
            ht.Add("Exchangenumber", txtExchangenumber);
            ht.Add("Documentnumber", txtDocumentnumber);
            ht.Add("DeliverNumber",txtDeliverNumber);
            ht.Add("ReturnIntegral",txtReturnIntegral);
            ht.Add("Types",txtTypes);
            ht.Add("Data", txtData);
            ht.Add("GiftName", txtGiftName);
          
            try
            {
                this.ExecuteInsert("InsertIntegralExchangeToDms", ht);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}