
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : TransferLot
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
    /// TransferLot的Dao
    /// </summary>
    public class TransferLotDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数

        /// </summary>
        public TransferLotDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public TransferLot GetObject(Guid objKey)
        {
            TransferLot obj = this.ExecuteQueryForObject<TransferLot>("SelectTransferLot", objKey);
            return obj;
        }

        /// <summary>
        /// 根据移库单号得到移库单中数量不足的批次列表

        /// </summary>
        /// <param name="objKey"></param>
        /// <returns>空或者批次记录列表</returns>
        public IList<TransferLot> SelectShortLotsInATransferOrder(Guid objKey)
        {
            IList<TransferLot> obj = this.ExecuteQueryForList<TransferLot>("SelectShortLotsInATransferOrder", objKey);
            return obj;
        }



        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<TransferLot> GetAll()
        {
            IList<TransferLot> list = this.ExecuteQueryForList<TransferLot>("SelectTransferLot", null);
            return list;
        }


        /// <summary>
        /// 查询TransferLot
        /// </summary>
        /// <returns>返回TransferLot集合</returns>
        public IList<TransferLot> SelectByFilter(TransferLot obj)
        {
            IList<TransferLot> list = this.ExecuteQueryForList<TransferLot>("SelectByFilterTransferLot", obj);
            return list;
        }

        public IList<TransferLot> SelectByFilter(Hashtable obj)
        {
            IList<TransferLot> list = this.ExecuteQueryForList<TransferLot>("SelectByFilterHashtable", obj);
            return list;
        }


        public IList<TransferLot> SelectById(Guid id)
        {
            IList<TransferLot> list = this.ExecuteQueryForList<TransferLot>("SelectTransferLotById", id);
            return list;
        }

        public IList<TransferLot> SelectByLineId(Guid id)
        {
            IList<TransferLot> list = this.ExecuteQueryForList<TransferLot>("SelectTransferLotByLineId", id);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(TransferLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTransferLot", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTransferLot", id);
            return cnt;
        }

        public int DeleteById(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTransferLotById", id);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(TransferLot obj)
        {
            this.ExecuteInsert("InsertTransferLot", obj);
        }

        public DataSet SelectByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterTransferLotAll", table, start, limit, out totalRowCount);
            return ds;
        }
        /// <summary>
        /// 获得移库单的相关信息
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet SelectLotByFilterHasFromToWarehouse(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterTransferLotFromTo", table, start, limit, out totalRowCount);
            return ds;
        }

        public double SelectTotalTransferLotQtyByLineId(Guid id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTotalTransferLotQtyByLineId", id);
            return Convert.ToDouble(ds.Tables[0].Rows[0]["TotalQty"].ToString());
        }

        //added by songyuqi on 20100610
        public DataSet SelectLotByFilterHasFromToWarehouse(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterTransferLotFromToPrint", table);
            return ds;
        }

        //Added By Song Yuqi On 20160426
        /// <summary>
        /// 获得移库单的相关信息(不分页)
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet SelectTransferLotByFilter(Guid headerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTransferLotByFilter", headerId);
            return ds;
        }

        //Added By Song Yuqi On 2016-06-12
        public DataSet CheckTransferProductAuthInfo(Hashtable talbe)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckTransferProductAuthInfo", talbe);
            return ds;
        }

    }
}