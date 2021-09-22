
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : BPM.DataAccess 
 * ClassName   : Interfacet2DeliveryConfirmation
 * Created Time: 2016/12/8 19:05:20
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// Interfacet2DeliveryConfirmation的Dao
    /// </summary>
    public class Interfacet2DeliveryConfirmationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public Interfacet2DeliveryConfirmationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Interfacet2DeliveryConfirmation GetObject(Guid objKey)
        {
            Interfacet2DeliveryConfirmation obj = this.ExecuteQueryForObject<Interfacet2DeliveryConfirmation>("SelectInterfacet2DeliveryConfirmation", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Interfacet2DeliveryConfirmation> GetAll()
        {
            IList<Interfacet2DeliveryConfirmation> list = this.ExecuteQueryForList<Interfacet2DeliveryConfirmation>("SelectInterfacet2DeliveryConfirmation", null);          
            return list;
        }


        /// <summary>
        /// 查询Interfacet2DeliveryConfirmation
        /// </summary>
        /// <returns>返回Interfacet2DeliveryConfirmation集合</returns>
		public IList<Interfacet2DeliveryConfirmation> SelectByFilter(Interfacet2DeliveryConfirmation obj)
		{ 
			IList<Interfacet2DeliveryConfirmation> list = this.ExecuteQueryForList<Interfacet2DeliveryConfirmation>("SelectByFilterInterfacet2DeliveryConfirmation", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Interfacet2DeliveryConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfacet2DeliveryConfirmation", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfacet2DeliveryConfirmation", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Interfacet2DeliveryConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfacet2DeliveryConfirmation", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Interfacet2DeliveryConfirmation obj)
        {
            this.ExecuteInsert("InsertInterfacet2DeliveryConfirmation", obj);           
        }

        public void HandleT2DeliveryConfirmationData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_T2DeliveryConfirmation", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
    }
}