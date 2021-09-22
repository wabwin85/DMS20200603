
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceAdjustConfirmation
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
    /// InterfaceAdjustConfirmation的Dao
    /// </summary>
    public class InterfaceAdjustConfirmationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceAdjustConfirmationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceAdjustConfirmation GetObject(Guid objKey)
        {
            InterfaceAdjustConfirmation obj = this.ExecuteQueryForObject<InterfaceAdjustConfirmation>("SelectInterfaceAdjustConfirmation", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceAdjustConfirmation> GetAll()
        {
            IList<InterfaceAdjustConfirmation> list = this.ExecuteQueryForList<InterfaceAdjustConfirmation>("SelectInterfaceAdjustConfirmation", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceAdjustConfirmation
        /// </summary>
        /// <returns>返回InterfaceAdjustConfirmation集合</returns>
		public IList<InterfaceAdjustConfirmation> SelectByFilter(InterfaceAdjustConfirmation obj)
		{ 
			IList<InterfaceAdjustConfirmation> list = this.ExecuteQueryForList<InterfaceAdjustConfirmation>("SelectByFilterInterfaceAdjustConfirmation", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceAdjustConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceAdjustConfirmation", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceAdjustConfirmation", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceAdjustConfirmation obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceAdjustConfirmation", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceAdjustConfirmation obj)
        {
            this.ExecuteInsert("InsertInterfaceAdjustConfirmation", obj);           
        }

        public void HandleAdjustConfirmationData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_AdjustConfirmation", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
    }
}