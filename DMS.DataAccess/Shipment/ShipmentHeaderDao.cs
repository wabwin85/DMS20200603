
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : ShipmentHeader
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
    /// ShipmentHeader的Dao
    /// </summary>
    public class ShipmentHeaderDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数

        /// </summary>
        public ShipmentHeaderDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShipmentHeader GetObject(Guid objKey)
        {
            ShipmentHeader obj = this.ExecuteQueryForObject<ShipmentHeader>("SelectShipmentHeader", objKey);
            return obj;
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShipmentHeader GetObjectByShipmentNbr(string Nbr)
        {
            ShipmentHeader obj = this.ExecuteQueryForObject<ShipmentHeader>("SelectShipmentHeaderByNbr", Nbr);
            return obj;
        }

        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ShipmentHeader> GetAll()
        {
            IList<ShipmentHeader> list = this.ExecuteQueryForList<ShipmentHeader>("SelectShipmentHeader", null);
            return list;
        }


        /// <summary>
        /// 查询ShipmentHeader
        /// </summary>
        /// <returns>返回ShipmentHeader集合</returns>
        public IList<ShipmentHeader> SelectByFilter(ShipmentHeader obj)
        {
            IList<ShipmentHeader> list = this.ExecuteQueryForList<ShipmentHeader>("SelectByFilterShipmentHeader", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ShipmentHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShipmentHeader", obj);
            return cnt;
        }




        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteShipmentHeader", id);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ShipmentHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteShipmentHeader", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ShipmentHeader obj)
        {
            this.ExecuteInsert("InsertShipmentHeader", obj);
        }

        public DataSet SelectByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentHeaderAll", table, start, limit, out totalRowCount, true);
            return ds;
        }

        public ShipmentHeader SelectShipmentHeaderByLotId(Guid objKey)
        {
            ShipmentHeader obj = this.ExecuteQueryForObject<ShipmentHeader>("SelectShipmentHeaderByLotId", objKey);
            return obj;
        }

        public double SelectShipmentTotalAmountByHeaderId(Guid headerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentTotalAmountByHeaderId", headerId);
            return Convert.ToDouble(ds.Tables[0].Rows[0]["TotalAmount"].ToString()); ;
        }

        public double SelectShipmentTotalQtyByHeaderId(Guid headerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentTotalQtyByHeaderId", headerId);
            return Convert.ToDouble(ds.Tables[0].Rows[0]["TotalQty"].ToString()); ;
        }

        public int UpdateInvoiceNo(ShipmentHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateShipmentHeaderInvoiceNo", obj);
            return cnt;
        }

        public DataSet SelectByFilterForLP(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentHeaderForLP", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByFilterForHQ(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentHeaderForHQ", table, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ShipmentHeader GetObjectForPrinting(Guid objKey)
        {
            ShipmentHeader obj = this.ExecuteQueryForObject<ShipmentHeader>("SelectShipmentHeaderForPrinting", objKey);
            return obj;
        }


        /// <summary>
        /// 是否为待审核的单据
        /// </summary>
        /// <param name="nbr"></param>
        /// <returns></returns>
        public bool GetSubmittedOrder(Guid nbr)
        {

            ShipmentHeader obj = this.ExecuteQueryForObject<ShipmentHeader>("GetSubmittedOrder", nbr);
            return obj == null ? false : true;
        }

        public void ConsigmentForOrder(string ShipmentNbr, string ShipmentType, string SubCompanyId, string BrandId, out string RtnVal, out string RtnMsg)
        {
            RtnMsg = string.Empty;
            RtnVal = string.Empty;
            Hashtable table = new Hashtable();
            table.Add("ShipmentNbr", ShipmentNbr);
            table.Add("ShipmentType", ShipmentType);
            table.Add("SubCompanyId", SubCompanyId);
            table.Add("BrandId", BrandId);
            table.Add("RtnVal", RtnVal);
            table.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_PurchaseOrder_AfterShipment", table);

            RtnMsg = table["RtnMsg"].ToString();
            RtnVal = table["RtnVal"].ToString();
        }

        public void T2ConsigmentForOrder(string ShipmentNbr, string ShipmentType, string SubCompanyId, string BrandId, out string RtnVal, out string RtnMsg)
        {
            RtnMsg = string.Empty;
            RtnVal = string.Empty;
            Hashtable table = new Hashtable();
            table.Add("ShipmentNbr", ShipmentNbr);
            table.Add("ShipmentType", ShipmentType);
            table.Add("SubCompanyId", SubCompanyId);
            table.Add("BrandId", BrandId);
            table.Add("RtnVal", RtnVal);
            table.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_PurchaseOrder_AfterShipmentImport", table);

            RtnMsg = table["RtnMsg"].ToString();
            RtnVal = table["RtnVal"].ToString();
        }

        public IDictionary<string, string> SelectShipmentOrderStatus()
        {
            IList<ShipmentHeader> list = this.ExecuteQueryForList<ShipmentHeader>("SelectShipmentOrderStatus", null);
            IDictionary<string, string> dicts = new Dictionary<string, string>();
            foreach (var item in list)
            {
                dicts.Add(item.OrderStaus, item.StatusName);
            }
            return dicts;
        }

        public DataSet SelectShipmentOrderStatus_ByDealerSalesReportStatus()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentOrderStatusByDealerSalesReportStatus", null);
            return ds;
        }
        #region Added By Song Yuqi
        public double SelectConsignmentShipmentTotalAmountByHeaderId(Guid headerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentShipmentTotalAmountByHeaderId", headerId);
            return Convert.ToDouble(ds.Tables[0].Rows[0]["TotalAmount"].ToString()); ;
        }

        public double SelectConsignmentShipmentTotalQtyByHeaderId(Guid headerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentShipmentTotalQtyByHeaderId", headerId);
            return Convert.ToDouble(ds.Tables[0].Rows[0]["TotalQty"].ToString()); ;
        }

        public void SumbitConsignment(Guid ShipmentHeadId, Guid HospitalId, Guid ProductLineId, out string RtnVal, out string RtnMsg)
        {
            RtnMsg = string.Empty;
            RtnVal = string.Empty;
            Hashtable table = new Hashtable();
            table.Add("ShipmentHeadId", ShipmentHeadId);
            table.Add("HospitalId", HospitalId);
            table.Add("ProductLineId", ProductLineId);
            table.Add("RtnVal", RtnVal);
            table.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_ShipmentSubmit_Before", table);

            RtnMsg = table["RtnMsg"].ToString();
            RtnVal = table["RtnVal"].ToString();
        }

        /// <summary>
        /// 判断当前用户是否是管理员角色
        /// </summary>
        /// <param name="nbr"></param>
        /// <returns></returns>
        public bool SelectAdminRole(Guid Id)
        {

            ShipmentHeader obj = this.ExecuteQueryForObject<ShipmentHeader>("SelectAdminRole", Id);
            return obj == null ? false : true;
        }

        public bool SelectAdminRoleAction(Guid id)
        {
            ShipmentHeader obj = this.ExecuteQueryForObject<ShipmentHeader>("SelectAdminRoleAction", id);
            return obj == null ? false : true;
        }

        #endregion

        /// <summary>
        /// 获取经销商分产品线的合同日期
        /// </summary>
        /// <param name="nbr"></param>
        /// <returns></returns>
        public DataSet GetContractDate(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetContractDate", table);
            return ds;
        }


        //经销商提交医院销售数据前数据校验 Add by Songweiming on 2015-08-27
        //Edited By Song Yuqi On 2016-06-17
        public void CheckSubmit(Guid sphId, string shipmentDate, Guid shipmentUser,Guid dealerId, Guid productLineId, Guid hospitalId, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("SphId", sphId);
            ht.Add("ShipmentDate", shipmentDate);

            ht.Add("DealerId", dealerId);
            ht.Add("ProductLineId", productLineId);
            ht.Add("HospitalId", hospitalId);

            ht.Add("ShipmentUser", shipmentUser);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_HospitalShipmentBSC_BeforeSubmit", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        public DataSet CheckNeedUploadAttachment(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckNeedUploadAttachment", table);
            return ds;
        }

        public DataSet SelectShipmentLog(string sphId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentLog", sphId);
            return ds;
        }

        public void GenClearBorrow(string sphId, string SubCompanyId, string BrandId, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("SphId", sphId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);


            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);
            this.ExecuteInsert("GC_PurchaseOrder_AutoGenConsignmentClearBorrow", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        public DataSet ExportShipmentByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterShipmentHeaderForExport", table);
            return ds;
        }

        /// <summary>
        /// Added By Song Yuqi On 2017-05-02 
        /// 根据发票号查询符合条件的销售单数量
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        public int QueryShipmentUploadFileByInvoiceNo(Hashtable table)
        {
            return this.QueryForCount("QueryShipmentUploadFileByInvoiceNo", table);
        }

        /// <summary>
        /// Added By Song Yuqi On 2017-05-02 
        /// 关联发票号新增附件
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        public void InsertAttachmentForShipmentUploadFile(Hashtable table)
        {
            this.ExecuteInsert("InsertAttachmentForShipmentUploadFile", table);
        }

        public void FakeDeleteAttachmentByMainIdAndFileName(Hashtable table)
        {
            this.ExecuteUpdate("FakeDeleteAttachmentByMainIdAndFileName", table); 
        }


        public DataSet ExportShipmentAttachment(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportShipmentAttachment", obj);
            return ds;
        }
        public DataSet ShipmentAttachmentDownload(string id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ShipmentAttachmentDownload", id);
            return ds;
        }

        public DataSet SelectShipmentHeaderToUploadToBSC(int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectShipmentHeaderToUploadToBSC", null, start, limit,
                out totalRowCount, true);
            return ds;
        }
    }
}