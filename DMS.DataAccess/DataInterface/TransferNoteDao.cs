
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : TransferNote
 * Created Time: 2013/9/2 17:01:26
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
    /// TransferNote的Dao
    /// </summary>
    public class TransferNoteDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public TransferNoteDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TransferNote GetObject(Guid objKey)
        {
            TransferNote obj = this.ExecuteQueryForObject<TransferNote>("SelectTransferNote", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<TransferNote> GetAll()
        {
            IList<TransferNote> list = this.ExecuteQueryForList<TransferNote>("SelectTransferNote", null);          
            return list;
        }


        /// <summary>
        /// 查询TransferNote
        /// </summary>
        /// <returns>返回TransferNote集合</returns>
		public IList<TransferNote> SelectByFilter(TransferNote obj)
		{ 
			IList<TransferNote> list = this.ExecuteQueryForList<TransferNote>("SelectByFilterTransferNote", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TransferNote obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTransferNote", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTransferNote", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(TransferNote obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteTransferNote", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TransferNote obj)
        {
            this.ExecuteInsert("InsertTransferNote", obj);           
        }

        public IList<TransferNote> SelectTransferNoteByBatchNbrErrorOnly(string batchNbr)
        {
            IList<TransferNote> list = this.ExecuteQueryForList<TransferNote>("SelectTransferNoteByBatchNbrErrorOnly", batchNbr);
            return list;
        }
    }
}