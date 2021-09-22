
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ShipmentAdjustLot
 * Created Time: 2016-03-29 16:26:33
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
    /// ShipmentAdjustLot的Dao
    /// </summary>
    public class ShipmentAdjustLotDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ShipmentAdjustLotDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShipmentAdjustLot GetObject(Guid objKey)
        {
            ShipmentAdjustLot obj = this.ExecuteQueryForObject<ShipmentAdjustLot>("SelectShipmentAdjustLot", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShipmentAdjustLot> GetAll()
        {
            IList<ShipmentAdjustLot> list = this.ExecuteQueryForList<ShipmentAdjustLot>("SelectShipmentAdjustLot", null);          
            return list;
        }


        /// <summary>
        /// 查询ShipmentAdjustLot
        /// </summary>
        /// <returns>返回ShipmentAdjustLot集合</returns>
		public IList<ShipmentAdjustLot> SelectByFilter(ShipmentAdjustLot obj)
		{ 
			IList<ShipmentAdjustLot> list = this.ExecuteQueryForList<ShipmentAdjustLot>("SelectByFilterShipmentAdjustLot", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShipmentAdjustLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShipmentAdjustLot", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentAdjustLot", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShipmentAdjustLot obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShipmentAdjustLot", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShipmentAdjustLot obj)
        {
            this.ExecuteInsert("InsertShipmentAdjustLot", obj);           
        }

        
        public DataSet QueryShipmentLotByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryShipmentLotByFilter", table);
            return ds;
        }

        public DataSet QueryShipmentAdjustLotForShipmentBySphId(Guid sphId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryShipmentAdjustLotForShipmentBySphId", sphId);
            return ds;
        }

        public DataSet QueryShipmentAdjustLotForInventoryBySphId(Guid sphId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryShipmentAdjustLotForInventoryBySphId", sphId);
            return ds;
        }

        /// <summary>
        /// 添加销售调整数据
        /// </summary>
        /// <param name="SphId"></param>
        /// <param name="DealerId"></param>
        /// <param name="HosId"></param>
        /// <param name="LotIdString"></param>
        /// <param name="AddType"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public void AddShipmentAdjustItem(Guid SphId, Guid DealerId, Guid HosId, string LotIdString, string AddType, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("SphId", SphId);
            ht.Add("DealerId", DealerId);
            ht.Add("HosId", HosId);
            ht.Add("LotIdString", LotIdString);
            ht.Add("AddType", AddType);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_ShipmentAdjust_AddCfn", ht);

            rtnVal = ht["RtnVal"] != null ? ht["RtnVal"].ToString() : "";
            rtnMsg = ht["RtnMsg"] != null ? ht["RtnMsg"].ToString() : "";
        }

        public int DeleteShipmentAdjustLotBySphId(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentAdjustLotBySphId", objKey);            
            return cnt;
        }

        public void AddShipmentAdjustToShipmentLot(Guid SphId, Guid DealerId, Guid HosId, string ShipmentDate, string Reason,string OpsUser, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("SphId", SphId);
            ht.Add("DealerId", DealerId);
            ht.Add("HosId", HosId);
            ht.Add("ShipmentDate", ShipmentDate);
            ht.Add("Reason", Reason);
            ht.Add("OpsUser", OpsUser);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_ShipmentAdjust_AddShipmentLot", ht);

            rtnVal = ht["RtnVal"] != null ? ht["RtnVal"].ToString() : "";
            rtnMsg = ht["RtnMsg"] != null ? ht["RtnMsg"].ToString() : "";
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int DeleteShipmentLotByFilter(Hashtable table)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentLotByFilter", table);
            return cnt;
        }
        public int GetCalendarDateSix()
        {
            Hashtable ht = new Hashtable();
            DataSet ds = this.ExecuteQueryForDataSet("SelectCalendarDateSix",ht);
            int cnt = int.Parse(ds.Tables[0].Rows[0]["Cnt"].ToString());
            return cnt;
        }

    }
}