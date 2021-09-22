
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : ShipmentLot
 * Created Time: 2009-8-13 13:51:16
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
    /// ShipmentLot的Dao
    /// </summary>
    public class ShipmentLotDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ShipmentLotDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShipmentLot GetObject(Guid objKey)
        {
            ShipmentLot obj = this.ExecuteQueryForObject<ShipmentLot>("SelectShipmentLot", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShipmentLot> GetAll()
        {
            IList<ShipmentLot> list = this.ExecuteQueryForList<ShipmentLot>("SelectShipmentLot", null);          
            return list;
        }


        /// <summary>
        /// 查询ShipmentLot
        /// </summary>
        /// <returns>返回ShipmentLot集合</returns>
		public IList<ShipmentLot> SelectByFilter(ShipmentLot obj)
		{ 
			IList<ShipmentLot> list = this.ExecuteQueryForList<ShipmentLot>("SelectByFilterShipmentLot", obj);          
            return list;
		}

        public IList<ShipmentLot> SelectByHashtable(Hashtable obj)
        {
            IList<ShipmentLot> list = this.ExecuteQueryForList<ShipmentLot>("SelectShipmentLotByHashtable", obj);
            return list;
        }

        public IList<ShipmentLot> SelectByLotNumber(Hashtable obj)
        {
            IList<ShipmentLot> list = this.ExecuteQueryForList<ShipmentLot>("SelectShipmentLotByLotNumber", obj);
            return list;
        }

        public IList<ShipmentLot> SelectByLineId(Guid Id)
        {
            Hashtable param = new Hashtable();
            param.Add("SplId", Id);
            IList<ShipmentLot> list = this.ExecuteQueryForList<ShipmentLot>("SelectShipmentLotByHashtable", param);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShipmentLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShipmentLot", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentLot", id);            
            return cnt;
        }

        public int DeleteByHeaderId(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentLotByHeaderId", id);
            return cnt;
        }
		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShipmentLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShipmentLot", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShipmentLot obj)
        {
            this.ExecuteInsert("InsertShipmentLot", obj);           
        }

        public DataSet SelectByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentLotAll", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentLotAll", table);
            return ds;
        }

        public DataSet SelectSumByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSumByFilterShipmentLotAll", table);
            return ds;
        }


        public double SelectTotalShipmentLotQtyByLineId(Guid id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTotalShipmentLotQtyByLineId", id);
            return Convert.ToDouble(ds.Tables[0].Rows[0]["TotalQty"].ToString());
        }

        public IList<ShipmentLot> SelectShipmentLotByHeaderId(Guid Id)
        {
            IList<ShipmentLot> list = this.ExecuteQueryForList<ShipmentLot>("SelectShipmentLotByHeaderId", Id);
            return list;
        }

        public DataSet SelectByFilterForPrint(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentLotForPrint", table);
            return ds;
        }
        public DataSet SelectShipmentLotByChecked(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentLotByChecked", Id);
            return ds;
        }
        public DataSet SelectShipmentdistictLotid(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentdistictLotid", Id);
            return ds;
        }
        public DataSet SelectShipmentLotQty(string lotId,string sphId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("Lotid", lotId);
            ht.Add("Sphid", sphId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentLotQty", ht);
            return ds;
        }

        public DataSet QueryShipmentLotBySphId(Guid sphId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryShipmentLotBySphId", sphId);
            return ds;
        }
        public DataSet SelectShipmentLotQrCodeBYLineIdandLotId(Guid lotId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("LotId", lotId);
            // ht.Add("LineId", sphId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentLotQrCodeBYLineIdandLotId", ht);
            return ds;
        }
        public DataSet SelectLimitNumber(Guid DealerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectLimitNumber", DealerId);
            return ds;
        }

        public DataSet SelectShipmentLimitBUCount(Guid DealerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentLimitBUCount", DealerId);
            return ds;
        }

        public int DeleteErrorShipmentLotByHeaderId(Hashtable table)
        {
            int cnt = (int)this.ExecuteDelete("DeleteErrorShipmentLotByHeaderId", table);
            return cnt;
        }

        public void SaveUpdateLog(Hashtable obj)
        {
            this.ExecuteInsert("InsertShipmentAdjustOperLog", obj);
        }

        public DataSet SelectShipmentLotToUploadToBSC(string SPH_ID)
        {
            Hashtable ht = new Hashtable();
            ht.Add("SPH_ID", SPH_ID);
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentLotToUploadToBSC", ht);
            return ds;
        }

    }
}