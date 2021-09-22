
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceDealerReturnConfirm
 * Created Time: 2014/3/25 16:50:15
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
    /// InterfaceDealerReturnConfirm的Dao
    /// </summary>
    public class InterfaceDealerReturnConfirmDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public InterfaceDealerReturnConfirmDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceDealerReturnConfirm GetObject(Guid objKey)
        {
            InterfaceDealerReturnConfirm obj = this.ExecuteQueryForObject<InterfaceDealerReturnConfirm>("SelectInterfaceDealerReturnConfirm", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceDealerReturnConfirm> GetAll()
        {
            IList<InterfaceDealerReturnConfirm> list = this.ExecuteQueryForList<InterfaceDealerReturnConfirm>("SelectInterfaceDealerReturnConfirm", null);          
            return list;
        }


        /// <summary>
        /// 查询InterfaceDealerReturnConfirm
        /// </summary>
        /// <returns>返回InterfaceDealerReturnConfirm集合</returns>
		public IList<InterfaceDealerReturnConfirm> SelectByFilter(InterfaceDealerReturnConfirm obj)
		{ 
			IList<InterfaceDealerReturnConfirm> list = this.ExecuteQueryForList<InterfaceDealerReturnConfirm>("SelectByFilterInterfaceDealerReturnConfirm", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceDealerReturnConfirm obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceDealerReturnConfirm", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceDealerReturnConfirm", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceDealerReturnConfirm obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceDealerReturnConfirm", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceDealerReturnConfirm obj)
        {
            this.ExecuteInsert("InsertInterfaceDealerReturnConfirm", obj);           
        }

        public void HandleDealerReturnConfirmData(string BatchNbr, string ClientID, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_DealerReturnConfirm", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public IList<InterfaceDealerReturnConfirm> SelectDealerReturnConfirmByBatchNbrErrorOnly(string BatchNbr)
        {
            IList<InterfaceDealerReturnConfirm> list = this.ExecuteQueryForList<InterfaceDealerReturnConfirm>("SelectDealerReturnConfirmByBatchNbrErrorOnly", BatchNbr);
            return list;
        }
    }
}