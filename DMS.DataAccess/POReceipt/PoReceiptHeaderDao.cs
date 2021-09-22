
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : PoReceiptHeader
 * Created Time: 2009-7-22 10:57:41
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
using DMS.Model.Data;

namespace DMS.DataAccess
{
    /// <summary>
    /// PoReceiptHeader的Dao
    /// </summary>
    public class PoReceiptHeaderDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public PoReceiptHeaderDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PoReceiptHeader GetObject(Guid objKey)
        {
            PoReceiptHeader obj = this.ExecuteQueryForObject<PoReceiptHeader>("SelectPoReceiptHeader", objKey);           
            return obj;
        }

        public PoReceiptHeader SelectByTransferNumber(string TransferNumber)
        {
            Hashtable param = new Hashtable();
            param.Add("TransferNumber", TransferNumber);
            param.Add("Type", ReceiptType.Rent.ToString());
            PoReceiptHeader obj = this.ExecuteQueryForObject<PoReceiptHeader>("SelectPoReceiptHeaderByTransferNumber", param);
            return obj;
        }

        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PoReceiptHeader> GetAll()
        {
            IList<PoReceiptHeader> list = this.ExecuteQueryForList<PoReceiptHeader>("SelectPoReceiptHeader", null);          
            return list;
        }


        /// <summary>
        /// 查询PoReceiptHeader
        /// </summary>
        /// <returns>返回PoReceiptHeader集合</returns>
		public IList<PoReceiptHeader> SelectByFilter(PoReceiptHeader obj)
		{ 
			IList<PoReceiptHeader> list = this.ExecuteQueryForList<PoReceiptHeader>("SelectByFilterPoReceiptHeader", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PoReceiptHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePoReceiptHeader", obj);            
            return cnt;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateByAutoNbr(string AutoNbr)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePOReceiptHeaderByAutoNbr", AutoNbr);
            return cnt;
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(PoReceiptHeader obj)
        {
            int cnt = (int)this.ExecuteDelete("DeletePoReceiptHeader", obj);            
            return cnt;
        }


		
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PoReceiptHeader obj)
        {
            this.ExecuteInsert("InsertPoReceiptHeader", obj);           
        }

        /// <summary>
        /// 查询PoReceiptHeader
        /// </summary>
        /// <returns>返回PoReceiptHeader集合</returns>
        public DataSet SelectByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterPoReceiptHeaderAll", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterPoReceiptHeaderAll", table);
            return ds;
        }

        public DataSet GetPoReceiptProductLine(Guid dealerId, string SubCompanyId, string BrandId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("value", dealerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            DataSet ds = this.ExecuteQueryForDataSet("GetPoReceiptProductLine", ht);
            return ds;
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PoReceiptHeader GetObjectAddWarehouse(Guid objKey)
        {
            PoReceiptHeader obj = this.ExecuteQueryForObject<PoReceiptHeader>("SelectPoReceiptHeaderAddWareHouse", objKey);
            return obj;
        }

        /// <summary>
        /// 查询需要导出的数据
        /// </summary>
        /// <returns>返回PoReceiptHeader集合</returns>
        public DataSet SelectByFilterForExport(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterPoReceiptHeaderForExport",table);
            return ds;
        }

        /// <summary>
        /// 调用数据库存储过程，取消发货单
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public void CancelPOReceiptByHeaderId(Guid headerId,Guid userId, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PRHId", headerId);
            ht.Add("UserId", userId);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("CancelPOReceiptByHeaderId", ht);
            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        #region Added By Song Yuqi On 20140320 
        /// <summary>
        /// 通过LotMasterId获得对应的订单号
        /// </summary>
        /// <returns>返回PoReceiptHeader集合</returns>
        public DataSet SelectByFilterForPurchseOrder(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterPoReceiptHeaderForPurchaseOrderNbr", table);
            return ds;
        }
        #endregion
       //add lijie 20160511
        public DataSet SelectInterfaceShipmentBYBatchNbr(string BatchNbr, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInterfaceShipmentBYBatchNbr", BatchNbr, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet DistinctInterfaceShipmentBYBatchNbr(string BatchNbr)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DistinctInterfaceShipmentBYBatchNbr", BatchNbr);
            return ds;
        }
        public DataSet SelectInterfaceShipmentBYBatchNbrQtyUnprice(string BatchNbr)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInterfaceShipmentBYBatchNbrQtyUnprice", BatchNbr);
            return ds;
        }
        public DataSet SelectPoreCeExistsDma(string BatchNbr, string DmaId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("BatchNbr", BatchNbr);
            ht.Add("DmaId", DmaId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectPoreCeExistsDma", ht);
            return ds;
        }
        public PoReceiptHeader GetPoReceiptHeaderByOrderNo(string OrderNo)
        {
            PoReceiptHeader obj = this.ExecuteQueryForObject<PoReceiptHeader>("GetPoReceiptHeaderByOrderNo", OrderNo);
            return obj;
        }

        public int DeletePoReceipt(string ProOrderNo)
        {
            int cnt = (int)this.ExecuteDelete("DeletePoReceiptAll", ProOrderNo);
            return cnt;
        }
        public int DeleteDeliveryNoteBSCSLC(string ProOrderNo)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDeliveryNoteBSCSLC", ProOrderNo);
            return cnt;
        }

        public DataSet GetPOReceiptHeader_SAPNoQR(string ProOrderNo)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetPOReceiptHeader_SAPNoQR", ProOrderNo);
            return ds;
        }
        public int UpdatePOReceiptHeader_SAPNoQR(string ProOrderNo)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePOReceiptHeader_SAPNoQR", ProOrderNo);
            return cnt;
        }
        public DataSet GetDeliveryNoteBSCSLC(string ProOrderNo)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetDeliveryNoteBSCSLC", ProOrderNo);
            return ds;
        }

        public DataSet QueryPoReceipt(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            //table.Add("OwnerIdentityType", this._context.User.IdentityType);
            //table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            //table.Add("OwnerId", new Guid(this._context.User.Id));

            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);
            }
        }


    }
}