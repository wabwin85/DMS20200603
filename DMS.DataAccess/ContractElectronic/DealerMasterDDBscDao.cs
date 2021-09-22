

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// ExportUploadDetail的Dao
    /// </summary>
    public class DealerMasterDDBscDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerMasterDDBscDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerMasterDD GetObject(Guid objKey)
        {
            DealerMasterDD obj = this.ExecuteQueryForObject<DealerMasterDD>("SelectDealerMasterDDByID", objKey);           
            return obj;
        }

        public DealerMasterDD GetObjectByContractID(Guid ContractID)
        {
            DealerMasterDD obj = this.ExecuteQueryForObject<DealerMasterDD>("SelectDealerMasterDDByContractID", ContractID);
            return obj;
        }
        public DealerMasterDD GetObjectByDealerID(Guid DealerID)
        {
            DealerMasterDD obj = this.ExecuteQueryForObject<DealerMasterDD>("SelectDealerMasterDDByDealerID", DealerID);
            return obj;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerMasterDD obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerMasterDD", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerMasterDD", objKey);            
            return cnt;
        }


	
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerMasterDD obj)
        {
            this.ExecuteInsert("InsertDealerMasterDD", obj);           
        }
        
    }
}