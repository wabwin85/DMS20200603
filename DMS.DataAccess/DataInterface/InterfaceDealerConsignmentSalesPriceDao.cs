
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceDealerConsignmentSalesPrice
 * Created Time: 2014/5/30 11:10:02
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
    /// InterfaceDealerConsignmentSalesPrice的Dao
    /// </summary>
    public class InterfaceDealerConsignmentSalesPriceDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceDealerConsignmentSalesPriceDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceDealerConsignmentSalesPrice GetObject(Guid objKey)
        {
            InterfaceDealerConsignmentSalesPrice obj = this.ExecuteQueryForObject<InterfaceDealerConsignmentSalesPrice>("SelectInterfaceDealerConsignmentSalesPrice", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceDealerConsignmentSalesPrice> GetAll()
        {
            IList<InterfaceDealerConsignmentSalesPrice> list = this.ExecuteQueryForList<InterfaceDealerConsignmentSalesPrice>("SelectInterfaceDealerConsignmentSalesPrice", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceDealerConsignmentSalesPrice
        /// </summary>
        /// <returns>返回InterfaceDealerConsignmentSalesPrice集合</returns>
		public IList<InterfaceDealerConsignmentSalesPrice> SelectByFilter(InterfaceDealerConsignmentSalesPrice obj)
		{ 
			IList<InterfaceDealerConsignmentSalesPrice> list = this.ExecuteQueryForList<InterfaceDealerConsignmentSalesPrice>("SelectByFilterInterfaceDealerConsignmentSalesPrice", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceDealerConsignmentSalesPrice obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceDealerConsignmentSalesPrice", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceDealerConsignmentSalesPrice", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceDealerConsignmentSalesPrice obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceDealerConsignmentSalesPrice", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceDealerConsignmentSalesPrice obj)
        {
            this.ExecuteInsert("InsertInterfaceDealerConsignmentSalesPrice", obj);           
        }

        public void HandleDealerConsignmentSalesPriceData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            IsValid = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("IsValid", IsValid);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_DealerConsignmentSalesPrice", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public IList<InterfaceDealerConsignmentSalesPrice> SelectDataByBatchNbrErrorOnly(string batchNbr)
        {
            IList<InterfaceDealerConsignmentSalesPrice> list = this.ExecuteQueryForList<InterfaceDealerConsignmentSalesPrice>("SelectDataByBatchNbrErrorOnly", batchNbr);
            return list;
        }
    }
}