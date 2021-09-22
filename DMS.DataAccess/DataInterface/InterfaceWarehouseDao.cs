
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceWarehouse
 * Created Time: 2013/8/27 14:33:29
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
    /// InterfaceWarehouse的Dao
    /// </summary>
    public class InterfaceWarehouseDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceWarehouseDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceWarehouse GetObject(Guid objKey)
        {
            InterfaceWarehouse obj = this.ExecuteQueryForObject<InterfaceWarehouse>("SelectInterfaceWarehouse", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceWarehouse> GetAll()
        {
            IList<InterfaceWarehouse> list = this.ExecuteQueryForList<InterfaceWarehouse>("SelectInterfaceWarehouse", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceWarehouse
        /// </summary>
        /// <returns>返回InterfaceWarehouse集合</returns>
		public IList<InterfaceWarehouse> SelectByFilter(InterfaceWarehouse obj)
		{ 
			IList<InterfaceWarehouse> list = this.ExecuteQueryForList<InterfaceWarehouse>("SelectByFilterInterfaceWarehouse", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceWarehouse obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceWarehouse", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceWarehouse", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceWarehouse obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceWarehouse", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceWarehouse obj)
        {
            this.ExecuteInsert("InsertInterfaceWarehouse", obj);           
        }

        public void AfterUpload(string BatchNbr, string ClientID,out string IsValid, out string RtnMsg)
        {
            RtnMsg = string.Empty;
            IsValid = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("IsValid", IsValid);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_ConsignmentWarehouse", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public IList<InterfaceWarehouse> SelectWarehouseByBatchNbrErrorOnly(string BatchNbr)
        {
            IList<InterfaceWarehouse> list = this.ExecuteQueryForList<InterfaceWarehouse>("SelectWarehouseByBatchNbrErrorOnly", BatchNbr);
            return list;
        }
    }
}