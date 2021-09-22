
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : InventoryAdjustLot
 * Created Time: 2009-8-5 16:19:41
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
    /// InventoryAdjustLot的Dao
    /// </summary>
    public class InventoryAdjustLotDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数

        /// </summary>
        public InventoryAdjustLotDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryAdjustLot GetObject(Guid objKey)
        {
            InventoryAdjustLot obj = this.ExecuteQueryForObject<InventoryAdjustLot>("SelectInventoryAdjustLot", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryAdjustLot> GetAll()
        {
            IList<InventoryAdjustLot> list = this.ExecuteQueryForList<InventoryAdjustLot>("SelectInventoryAdjustLot", null);
            return list;
        }

        public IList<InventoryAdjustLot> SelectInventoryAdjustLotByAdjustId(Guid id)
        {
            IList<InventoryAdjustLot> list = this.ExecuteQueryForList<InventoryAdjustLot>("SelectInventoryAdjustLotByAdjustId", id);
            return list;
        }
        /// <summary>
        /// 查询InventoryAdjustLot
        /// </summary>
        /// <returns>返回InventoryAdjustLot集合</returns>
        public IList<InventoryAdjustLot> SelectByFilter(InventoryAdjustLot obj)
        {
            IList<InventoryAdjustLot> list = this.ExecuteQueryForList<InventoryAdjustLot>("SelectByFilterInventoryAdjustLot", obj);
            return list;
        }

        public DataSet SelectByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustLotAll", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustLotAll", table);
            return ds;
        }

        public IList<InventoryAdjustLot> SelectByHashtable(Hashtable obj)
        {
            IList<InventoryAdjustLot> list = this.ExecuteQueryForList<InventoryAdjustLot>("SelectInventoryAdjustLotByHashtable", obj);
            return list;
        }

        public IList<InventoryAdjustLot> SelectByHashtable(Guid id)
        {
            Hashtable param = new Hashtable();
            param.Add("IadId", id);
            IList<InventoryAdjustLot> list = this.ExecuteQueryForList<InventoryAdjustLot>("SelectInventoryAdjustLotByHashtable", param);
            return list;
        }
        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryAdjustLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryAdjustLot", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryAdjustLot", id);
            return cnt;
        }

        public int DeleteByAdjustId(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryAdjustLotByAdjustId", id);
            return cnt;
        }


        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryAdjustLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryAdjustLot", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryAdjustLot obj)
        {
            this.ExecuteInsert("InsertInventoryAdjustLot", obj);
        }

        public double SelectTotalInventoryAdjustLotQtyByLineId(Guid id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTotalInventoryAdjustLotQtyByLineId", id);
            return Convert.ToDouble(ds.Tables[0].Rows[0]["TotalQty"].ToString());
        }
        public DataSet SelectTotalInventoryAdjustLot(Guid id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTotalInventoryAdjustLot", id);
            return ds;
        }

        public DataSet SelectByFilterInventoryAdjustLotCTOS(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustLotCTOS", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByFilterInventoryAdjustLotTransfer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustLotTransfer", table, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet SelectInventoryAdjustLotChecked(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryAdjustLotChecked", Id);
            return ds;
        }

        public IList<InventoryAdjustLot> SelectInventoryAdjustLotSumQtyByAdjustId(Guid id)
        {
            IList<InventoryAdjustLot> list = this.ExecuteQueryForList<InventoryAdjustLot>("SelectInventoryAdjustLoSumQtytByAdjustId", id);
            return list;
        }

        public DataSet SelectLotQrCodeChecked(Guid Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectLotQrCodeChecked", Id);
            return ds;
        }

        public DataSet QueryQrCodeIsDouble(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectIsDoubleByQrCode", ht);
            return ds;
        }
        public DataSet SelectInverntoryRutrnQrCode(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInverntoryRutrnQrCode", ht);
            return ds;
        }
        public DataSet SelectInverntorRuturSumQty(string HeadId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("AdjustId", HeadId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustLotAll", ht);
            return ds;
        }
        public DataSet SelectInvernLotRuturnTransferQty(string HeadId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("AdjustId", HeadId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustLotTransfer", ht);
            return ds;

        }
        public DataSet SelectInventoryAdjustLotBYIdQrCode(string HeadId, string QrCode)
        {
            Hashtable ht = new Hashtable();
            ht.Add("HeadId", HeadId);
            ht.Add("QrCode", QrCode);
            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryAdjustLotBYIdQrCode", ht);
            return ds;
        }
        public DataSet SelectInventoryAdjustLot(string HeadId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("AdjustId", HeadId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterInventoryAdjustLotAll", ht);
            return ds;
        }
        public DataSet SelectInventoryAdjustLotQrCodeBYDmIdHeadId(string HeadId, string DmaId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DmaId", DmaId);
            ht.Add("HeadId", HeadId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryAdjustLotQrCodeBYDmIdHeadId", ht);
            return ds;
        }

        //Added By Song Yuqi On 2016-06-06 
        public DataSet CheckInventoryProductAuthInfo(Hashtable talbe)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckInventoryProductAuthInfo", talbe);
            return ds;
        }

        public DataSet QueryInterfaceDealerReturnConfirmBybatchNumber(string batchNumber, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryInterfaceDealerReturnConfirmBybatchNumber", batchNumber, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet SelectExistsDMAParent(string batchNumber, string DmaId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("batchNumber", batchNumber);
            ht.Add("DmaId", DmaId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectExistsDMAParent", ht);
            return ds;
        }

        public DataSet SelectInventoryAdjustPrhIDBYHeadId(string headerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInventoryAdjustPrhIDBYHeadId", headerId);
            return ds;
        }
        public DataSet SelectExistsCFnbyLotIdWhmIdLot(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectExistsCFnbyLotIdWhmIdLot", ht);
            return ds;
        }
        public void InventoryAdjust_CheckSubmit(string IahId, string AdjustType, out string RtnMessing, out string IsValid)
        {
            RtnMessing = string.Empty;
            IsValid = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("IAHID", IahId);
            ht.Add("AdjustType", AdjustType);
            ht.Add("RtnRegMsg", RtnMessing);
            ht.Add("IsValid", IsValid);
            this.ExecuteInsert("GC_InventoryAdjust_CheckSubmit", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMessing = ht["RtnRegMsg"].ToString();
        }

        public DataSet ExistsPOReceiptHeaderIsUpn(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExistsPOReceiptHeaderIsUpn", ht);
            return ds;
        }

        public DataSet ExistsConsignmentIsUpn(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExistsConsignmentIsUpn", ht);
            return ds;
        }
        public DataSet GetInventoryDtBYIahId(string IahId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetInventoryDtBYIahId", IahId);
            return ds;
        }
        public DataSet SelectAdjustRenturn_Reason(Hashtable ht)
        {

            DataSet ds = this.ExecuteQueryForDataSet("SelectAdjustRenturn_Reason", ht);
            return ds;
        }
        public DataSet SelectReturnProductQtyorPrice(string IahId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectReturnProductQtyorPrice", IahId);
            return ds;
        }
        public Hashtable SelectReturnCfnPrice(Hashtable ht)
        {
            Hashtable ds = this.ExecuteQueryForObject("SelectReturnCfnPrice", ht) as Hashtable;
            return ds;
        }
        public DataSet SelectReturnCfnPriceForT1AndLP(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectReturnCfnPriceForT1AndLP", ht);
            return ds;
        }
        public DataSet SelectProdectById(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProdectById", Id);
            return ds;
        }
        public DataSet SelectAdjustRenturnApplyTypebyHeadid(string iahId)
        {
            Hashtable ht = new Hashtable()
            ;
            ht.Add("IahId", iahId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectAdjustRenturnApplyTypebyHeadid", ht);
            return ds;
        }
        public DataSet GetProductLineByDmaId(string DmaId)
        {

            DataSet ds = this.ExecuteQueryForDataSet("GetProductLineByDmaId", DmaId);
            return ds;
        }
        public IList<InventoryAdjustLot> SelectRetrunInventoryAdjustLotByAdjustId(Guid id)
        {
            IList<InventoryAdjustLot> list = this.ExecuteQueryForList<InventoryAdjustLot>("SelectRetrunInventoryAdjustLotByAdjustId", id);
            return list;
        }
    }
}