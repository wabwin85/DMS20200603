
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceDeliveryConfirmation
 * Created Time: 2013/7/12 14:48:25
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
    /// InterfaceDeliveryConfirmation的Dao
    /// </summary>
    public class InterfaceDeliveryConfirmationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceDeliveryConfirmationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceDeliveryConfirmation GetObject(Guid objKey)
        {
            InterfaceDeliveryConfirmation obj = this.ExecuteQueryForObject<InterfaceDeliveryConfirmation>("SelectInterfaceDeliveryConfirmation", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceDeliveryConfirmation> GetAll()
        {
            IList<InterfaceDeliveryConfirmation> list = this.ExecuteQueryForList<InterfaceDeliveryConfirmation>("SelectInterfaceDeliveryConfirmation", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceDeliveryConfirmation
        /// </summary>
        /// <returns>返回InterfaceDeliveryConfirmation集合</returns>
		public IList<InterfaceDeliveryConfirmation> SelectByFilter(InterfaceDeliveryConfirmation obj)
		{ 
			IList<InterfaceDeliveryConfirmation> list = this.ExecuteQueryForList<InterfaceDeliveryConfirmation>("SelectByFilterInterfaceDeliveryConfirmation", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceDeliveryConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceDeliveryConfirmation", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceDeliveryConfirmation", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceDeliveryConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceDeliveryConfirmation", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceDeliveryConfirmation obj)
        {
            this.ExecuteInsert("InsertInterfaceDeliveryConfirmation", obj);           
        }

        public void HandleDeliveryConfirmationData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_DeliveryConfirmation", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

    }
}