
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceConfirmation
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
    /// InterfaceConfirmation的Dao
    /// </summary>
    public class InterfaceConfirmationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceConfirmationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceConfirmation GetObject(Guid objKey)
        {
            InterfaceConfirmation obj = this.ExecuteQueryForObject<InterfaceConfirmation>("SelectInterfaceConfirmation", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceConfirmation> GetAll()
        {
            IList<InterfaceConfirmation> list = this.ExecuteQueryForList<InterfaceConfirmation>("SelectInterfaceConfirmation", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceConfirmation
        /// </summary>
        /// <returns>返回InterfaceConfirmation集合</returns>
		public IList<InterfaceConfirmation> SelectByFilter(InterfaceConfirmation obj)
		{ 
			IList<InterfaceConfirmation> list = this.ExecuteQueryForList<InterfaceConfirmation>("SelectByFilterInterfaceConfirmation", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceConfirmation", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceConfirmation", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceConfirmation", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceConfirmation obj)
        {
            this.ExecuteInsert("InsertInterfaceConfirmation", obj);           
        }

        public void HandleT2OrderConfirmationData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_ConfirmationLP", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
    }
}