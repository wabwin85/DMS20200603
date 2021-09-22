
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : DeliveryNote
 * Created Time: 2009-8-12 2:37:56 PM
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
    /// DeliveryNote的Dao
    /// </summary>
    public class DeliveryNoteDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数

        /// </summary>
		public DeliveryNoteDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DeliveryNote GetObject(Guid objKey)
        {
            DeliveryNote obj = this.ExecuteQueryForObject<DeliveryNote>("SelectDeliveryNote", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DeliveryNote> GetAll()
        {
            IList<DeliveryNote> list = this.ExecuteQueryForList<DeliveryNote>("SelectDeliveryNote", null);          
            return list;
        }

        /// <summary>
        /// 获得没有经销商的数据。需要显示给相关部门在系统中增加有关经销商。

        /// </summary>
        /// <returns></returns>
        public IList<DeliveryNote> GetDeliveryNoteWithoutDealer()
        {
            IList<DeliveryNote> list = this.ExecuteQueryForList<DeliveryNote>("SelectDeliveryNoteHaveNoDealer", null);
            return list;
        }

        /// <summary>
        /// 获得没有CFN的物料。显示给经销商和相关部门。

        /// </summary>
        /// <returns></returns>
        public IList<DeliveryNote> GetDeliveryNoteWithoutCFN()
        {
            IList<DeliveryNote> list = this.ExecuteQueryForList<DeliveryNote>("SelectDeliveryNoteHaveNoCFN", null);
            return list;
        }


        /// <summary>
        /// 获得没有授权的采购收货单。

        /// </summary>
        /// <returns></returns>
        public DataSet GetUnauthorizationPOReceipt()
        {
            DataSet UnauthorizationPOR = new DataSet();
            //UnauthorizationPOR = n
            return UnauthorizationPOR;
        }

        /// <summary>
        /// 处理已经导入的DN
        /// </summary>
        /// <param name="a"></param>
        public void ImportPOReceipt()
        {
            this.ExecuteInsert("GC_ImportPOReceipt","");
        }

        /// <summary>
        /// 查询DeliveryNote
        /// </summary>
        /// <returns>返回DeliveryNote集合</returns>
		public IList<DeliveryNote> SelectByFilter(DeliveryNote obj)
		{ 
			IList<DeliveryNote> list = this.ExecuteQueryForList<DeliveryNote>("SelectByFilterDeliveryNote", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DeliveryNote obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDeliveryNote", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDeliveryNote", id);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DeliveryNote obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDeliveryNote", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DeliveryNote obj)
        {
            this.ExecuteInsert("InsertDeliveryNote", obj);           
        }

        public DataSet SelectByHashtable(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDeliveryNoteByHashtable", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByHashtable(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDeliveryNoteByHashtable", table);
            return ds;
        }

        public IList<DeliveryNote> SelectDeliveryNoteByBatchNbrErrorOnly(string batchNbr)
        {
            IList<DeliveryNote> list = this.ExecuteQueryForList<DeliveryNote>("SelectDeliveryNoteByBatchNbrErrorOnly", batchNbr);
            return list;
        }
        public DataSet SelectDeliveryNoteByBatchNbr(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDeliveryNoteByBatchNbr", table, start, limit, out totalRowCount);
            return ds;
        }
        public IList<OrderStatusData> SelectOrderStatusNoteByBatchNbrErrorOnly(string batchNbr)
        {
            IList<OrderStatusData> list = this.ExecuteQueryForList<OrderStatusData>("SelectOrderStatusNoteByBatchNbrErrorOnly", batchNbr);
            return list;
        }

        public DataSet SelectOrderStatusNoteByBatchNbrToCompleted(string batchNbr)
        {
            return this.ExecuteQueryForDataSet("SelectOrderStatusNoteByBatchNbrToCompleted", batchNbr);
        }
    }
}