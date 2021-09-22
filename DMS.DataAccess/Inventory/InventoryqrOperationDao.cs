
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : InventoryqrOperation
 * Created Time: 2015/12/31 15:11:37
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
    /// InventoryqrOperation的Dao
    /// </summary>
    public class InventoryqrOperationDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public InventoryqrOperationDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public InventoryqrOperation GetObject(Guid objKey)
        {
            InventoryqrOperation obj = this.ExecuteQueryForObject<InventoryqrOperation>("SelectInventoryqrOperation", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<InventoryqrOperation> GetAll()
        {
            IList<InventoryqrOperation> list = this.ExecuteQueryForList<InventoryqrOperation>("SelectInventoryqrOperation", null);
            return list;
        }


        /// <summary>
        /// 查询InventoryqrOperation
        /// </summary>
        /// <returns>返回InventoryqrOperation集合</returns>
        public IList<InventoryqrOperation> SelectByFilter(InventoryqrOperation obj)
        {
            IList<InventoryqrOperation> list = this.ExecuteQueryForList<InventoryqrOperation>("SelectByFilterInventoryqrOperation", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(InventoryqrOperation obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryqrOperation", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryqrOperation", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(InventoryqrOperation obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteInventoryqrOperation", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(InventoryqrOperation obj)
        {
            this.ExecuteInsert("InsertInventoryqrOperation", obj);
        }


        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateInventoryqrOperationForShipmentEdit(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryqrOperationForShipmentEdit", obj);
            return cnt;
        }

        public void SubmitShipment(Guid userId, Guid dealerId, string SubCompanyId, string BrandId, Guid productLineId, Guid hospitalId, DateTime shipmentDate, string headXmlString, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("DealerId", dealerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("ProductLineId", productLineId);
            ht.Add("HospitalId", hospitalId);
            ht.Add("ShipmentDate", shipmentDate.ToString("yyyy-MM-dd"));
            ht.Add("HeadXmlString", headXmlString);

            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_InventoryQr_Submit_Shipment", ht);

            rtnVal = ht["RtnVal"] != null ? ht["RtnVal"].ToString() : "";
            rtnMsg = ht["RtnMsg"] != null ? ht["RtnMsg"].ToString() : "";
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateInventoryqrOperationForTransferEdit(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryqrOperationForTransferEdit", obj);
            return cnt;
        }

        public int UpdateInventoryqrOfToWarahouseIdByFilter(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateInventoryqrOfToWarahouseIdByFilter", obj);
            return cnt;
        }

        public void SubmitTransfer(Guid userId, Guid dealerId, Guid productLineId, string transferType,string SubCompanyId, string BrandId, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("DealerId", dealerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("ProductLineId", productLineId);
            ht.Add("TransferType", transferType);

            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_InventoryQr_Submit_Transfer", ht);

            rtnVal = ht["RtnVal"] != null ? ht["RtnVal"].ToString() : "";
            rtnMsg = ht["RtnMsg"] != null ? ht["RtnMsg"].ToString() : "";
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int DeleteInventoryqrOperationByFilter(Hashtable table)
        {
            int cnt = (int)this.ExecuteDelete("DeleteInventoryqrOperationByFilter", table);
            return cnt;
        }
    }
}