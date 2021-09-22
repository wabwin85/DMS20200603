
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceTransferFort2
 * Created Time: 2016/12/10 10:54:57
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
    /// InterfaceTransferFort2的Dao
    /// </summary>
    public class InterfaceTransferFort2Dao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceTransferFort2Dao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceTransferFort2 GetObject(Guid objKey)
        {
            InterfaceTransferFort2 obj = this.ExecuteQueryForObject<InterfaceTransferFort2>("SelectInterfaceTransferFort2", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceTransferFort2> GetAll()
        {
            IList<InterfaceTransferFort2> list = this.ExecuteQueryForList<InterfaceTransferFort2>("SelectInterfaceTransferFort2", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceTransferFort2
        /// </summary>
        /// <returns>返回InterfaceTransferFort2集合</returns>
		public IList<InterfaceTransferFort2> SelectByFilter(InterfaceTransferFort2 obj)
		{ 
			IList<InterfaceTransferFort2> list = this.ExecuteQueryForList<InterfaceTransferFort2>("SelectByFilterInterfaceTransferFort2", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceTransferFort2 obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceTransferFort2", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceTransferFort2", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceTransferFort2 obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceTransferFort2", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceTransferFort2 obj)
        {
            this.ExecuteInsert("InsertInterfaceTransferFort2", obj);           
        }

        public void HandleTransferDataForT2(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_InventoryTransferForT2", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
    }
}