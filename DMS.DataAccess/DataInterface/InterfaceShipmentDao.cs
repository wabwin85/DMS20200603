
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InterfaceShipment
 * Created Time: 2013/7/12 14:48:26
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
    /// InterfaceShipment的Dao
    /// </summary>
    public class InterfaceShipmentDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public InterfaceShipmentDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InterfaceShipment GetObject(Guid objKey)
        {
            InterfaceShipment obj = this.ExecuteQueryForObject<InterfaceShipment>("SelectInterfaceShipment", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InterfaceShipment> GetAll()
        {
            IList<InterfaceShipment> list = this.ExecuteQueryForList<InterfaceShipment>("SelectInterfaceShipment", null);
            return list;
        }


        /// <summary>
        /// 查询InterfaceShipment
        /// </summary>
        /// <returns>返回InterfaceShipment集合</returns>
		public IList<InterfaceShipment> SelectByFilter(InterfaceShipment obj)
        {
            IList<InterfaceShipment> list = this.ExecuteQueryForList<InterfaceShipment>("SelectByFilterInterfaceShipment", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InterfaceShipment obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInterfaceShipment", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInterfaceShipment", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InterfaceShipment obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInterfaceShipment", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InterfaceShipment obj)
        {
            this.ExecuteInsert("InsertInterfaceShipment", obj);
        }
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Hashtable obj)
        {
            this.ExecuteInsert("InsertInterfaceOrderStatus", obj);
        }
        public void HandleOrderStatusData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            IsValid = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("IsValid", IsValid);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_OrderStatus", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
        public void HandleShipmentData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            IsValid = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("IsValid", IsValid);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_Shipment", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
        public void HandleShipmentDataVR(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            IsValid = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("IsValid", IsValid);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_ShipmentVR", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public void HandleShipmentT2NormalData(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            IsValid = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("SubCompanyId", "");
            ht.Add("BrandId", "");
            ht.Add("IsValid", IsValid);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_ShipmentT2Normal", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public void HandleShipmentT2ConsignmentData(string BatchNbr, string ClientID, string SubCompanyId, string BrandId, out string IsValid, out string RtnMsg)
        {
            IsValid = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("ClientID", ClientID);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsValid", IsValid);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_Interface_ShipmentT2Consignment", ht);

            IsValid = ht["IsValid"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
    }
}