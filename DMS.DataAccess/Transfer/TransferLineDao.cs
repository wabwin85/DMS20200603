
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : TransferLine
 * Created Time: 2009-7-27 14:45:49
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// TransferLine的Dao
    /// </summary>
    public class TransferLineDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public TransferLineDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TransferLine GetObject(Guid objKey)
        {
            TransferLine obj = this.ExecuteQueryForObject<TransferLine>("SelectTransferLine", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<TransferLine> GetAll()
        {
            IList<TransferLine> list = this.ExecuteQueryForList<TransferLine>("SelectTransferLine", null);          
            return list;
        }


        /// <summary>
        /// 查询TransferLine
        /// </summary>
        /// <returns>返回TransferLine集合</returns>
		public IList<TransferLine> SelectByFilter(TransferLine obj)
		{ 
			IList<TransferLine> list = this.ExecuteQueryForList<TransferLine>("SelectByFilterTransferLine", obj);          
            return list;
		}

        public IList<TransferLine> SelectByFilter(Hashtable obj)
        {
            IList<TransferLine> list = this.ExecuteQueryForList<TransferLine>("SelectByFilter", obj);
            return list;
        }

        public IList<TransferLine> SelectById(Guid id )
        {
            IList<TransferLine> list = this.ExecuteQueryForList<TransferLine>("SelectTransferLineById", id);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TransferLine obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTransferLine", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTransferLine", id);            
            return cnt;
        }

        public int DeleteById(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTransferLineById", id);
            return cnt;
        }
		
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TransferLine obj)
        {
            this.ExecuteInsert("InsertTransferLine", obj);           
        }

        public DataSet CheckDealerContractByPmaIdForTransfer(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckDealerContractByPmaIdForTransfer", table);
            return ds;
        }
    }
}