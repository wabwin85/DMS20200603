
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceqrDealerTransaction
 * Created Time: 2016/1/17 10:57:01
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
    /// InterfaceqrDealerTransaction的Dao
    /// </summary>
    public class InterfaceqrDealerTransactionDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceqrDealerTransactionDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceqrDealerTransaction GetObject(Guid objKey)
        {
            InterfaceqrDealerTransaction obj = this.ExecuteQueryForObject<InterfaceqrDealerTransaction>("SelectInterfaceqrDealerTransaction", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceqrDealerTransaction> GetAll()
        {
            IList<InterfaceqrDealerTransaction> list = this.ExecuteQueryForList<InterfaceqrDealerTransaction>("SelectInterfaceqrDealerTransaction", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceqrDealerTransaction
        /// </summary>
        /// <returns>返回InterfaceqrDealerTransaction集合</returns>
		public IList<InterfaceqrDealerTransaction> SelectByFilter(InterfaceqrDealerTransaction obj)
		{ 
			IList<InterfaceqrDealerTransaction> list = this.ExecuteQueryForList<InterfaceqrDealerTransaction>("SelectByFilterInterfaceqrDealerTransaction", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceqrDealerTransaction obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceqrDealerTransaction", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceqrDealerTransaction", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceqrDealerTransaction obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceqrDealerTransaction", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceqrDealerTransaction obj)
        {
            this.ExecuteInsert("InsertInterfaceqrDealerTransaction", obj);           
        }

        //增加二维码主数据接口（校验接口数据），Add By SongWeiming on 2015-12-10
        public void HandleQRDealerTransaction(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            IsValid = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("IsValid", IsValid);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_QRDealerTransaction", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        //获取二维码接口中的错误信息，Add By SongWeiming on 2015-12-10
        public IList<InterfaceqrDealerTransaction> SelectInterfaceQRDealerTransactionByBatchNbrErrorOnly(string batchNbr)
        {
            IList<InterfaceqrDealerTransaction> list = this.ExecuteQueryForList<InterfaceqrDealerTransaction>("SelectInterfaceQRDealerTransactionByBatchNbrErrorOnly", batchNbr);
            return list;
        }

    }
}