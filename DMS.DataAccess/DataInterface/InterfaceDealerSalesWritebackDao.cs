
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceDealerSalesWriteback
 * Created Time: 2014/3/19 12:09:32
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
    /// InterfaceDealerSalesWriteback的Dao
    /// </summary>
    public class InterfaceDealerSalesWritebackDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceDealerSalesWritebackDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceDealerSalesWriteback GetObject(Guid objKey)
        {
            InterfaceDealerSalesWriteback obj = this.ExecuteQueryForObject<InterfaceDealerSalesWriteback>("SelectInterfaceDealerSalesWriteback", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceDealerSalesWriteback> GetAll()
        {
            IList<InterfaceDealerSalesWriteback> list = this.ExecuteQueryForList<InterfaceDealerSalesWriteback>("SelectInterfaceDealerSalesWriteback", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceDealerSalesWriteback
        /// </summary>
        /// <returns>返回InterfaceDealerSalesWriteback集合</returns>
		public IList<InterfaceDealerSalesWriteback> SelectByFilter(InterfaceDealerSalesWriteback obj)
		{ 
			IList<InterfaceDealerSalesWriteback> list = this.ExecuteQueryForList<InterfaceDealerSalesWriteback>("SelectByFilterInterfaceDealerSalesWriteback", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceDealerSalesWriteback obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceDealerSalesWriteback", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceDealerSalesWriteback", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceDealerSalesWriteback obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceDealerSalesWriteback", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceDealerSalesWriteback obj)
        {
            this.ExecuteInsert("InsertInterfaceDealerSalesWriteback", obj);           
        }

        public void AfterUpload(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            RtnMsg = string.Empty;
            IsValid = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("IsValid", IsValid);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_DealerSalesWriteback", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public IList<InterfaceDealerSalesWriteback> SelectDealerSalesWritebackByBatchNbrErrorOnly(string BatchNbr)
        {
            IList<InterfaceDealerSalesWriteback> list = this.ExecuteQueryForList<InterfaceDealerSalesWriteback>("SelectDealerSalesWritebackByBatchNbrErrorOnly", BatchNbr);
            return list;
        }

        public IList<InterfaceDealerSalesWriteback> SelectDealerSalesWritebackByBatchNbr(string BatchNbr)
        {
            IList<InterfaceDealerSalesWriteback> list = this.ExecuteQueryForList<InterfaceDealerSalesWriteback>("SelectDealerSalesWritebackByBatchNbr", BatchNbr);
            return list;
        }
    }
}