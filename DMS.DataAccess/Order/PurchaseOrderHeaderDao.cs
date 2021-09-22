
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : PurchaseOrderHeader
 * Created Time: 2011-2-10 13:23:49
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
    /// PurchaseOrderHeader的Dao
    /// </summary>
    public class PurchaseOrderHeaderDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public PurchaseOrderHeaderDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PurchaseOrderHeader GetObject(Guid objKey)
        {
            PurchaseOrderHeader obj = this.ExecuteQueryForObject<PurchaseOrderHeader>("SelectPurchaseOrderHeader", objKey);
            return obj;
        }
        public PurchaseOrderHeader GetObject(string OrderNo)
        {
            PurchaseOrderHeader obj = this.ExecuteQueryForObject<PurchaseOrderHeader>("SelectPurchaseOrderHeaderByNO", OrderNo);
            return obj;
        }

        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PurchaseOrderHeader> GetAll()
        {
            IList<PurchaseOrderHeader> list = this.ExecuteQueryForList<PurchaseOrderHeader>("SelectPurchaseOrderHeader", null);
            return list;
        }


        /// <summary>
        /// 查询PurchaseOrderHeader
        /// </summary>
        /// <returns>返回PurchaseOrderHeader集合</returns>
        public IList<PurchaseOrderHeader> SelectByFilter(PurchaseOrderHeader obj)
        {
            IList<PurchaseOrderHeader> list = this.ExecuteQueryForList<PurchaseOrderHeader>("SelectByFilterPurchaseOrderHeader", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PurchaseOrderHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderHeader", obj);
            return cnt;
        }


        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int UpdateClearBorrowPurchaseOrderStatus(Hashtable table)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateClearBorrowPurchaseOrderStatus", table);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeletePurchaseOrderHeader", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(PurchaseOrderHeader obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeletePurchaseOrderHeader", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PurchaseOrderHeader obj)
        {
            this.ExecuteInsert("InsertPurchaseOrderHeader", obj);
        }

        #region added by bozhenfei on 20110212
        /// <summary>
        /// 经销商订单查询
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPurchaseOrderHeaderByFilterForDealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPurchaseOrderHeaderByFilterForDealer", table, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// LP及一级经销商订单查询
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPurchaseOrderHeaderByFilterForLPDealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPurchaseOrderHeaderByFilterForLPDealer", table, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// LP及一级经销商订单日志导出
        /// </summary>
        /// <param name="table"></param>       
        /// <returns></returns>
        public DataSet ExportPurchaseOrderLogForLPDealer(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportPurchaseOrderLogForLPDealer_New", table);
            return ds;
        }

        /// <summary>
        /// LP及一级经销商订单发票导出
        /// </summary>
        /// <param name="table"></param>       
        /// <returns></returns>
        public DataSet ExportPurchaseOrderInvoiceForLPDealer(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportPurchaseOrderInvoiceForLPDealer_New", table);
            return ds;
        }

        /// <summary>
        /// LP及一级经销商订单日志导出（For 订单审核）
        /// </summary>
        /// <param name="table"></param>       
        /// <returns></returns>
        public DataSet ExportPurchaseOrderLogForLPDealerForAudit(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportPurchaseOrderLogForLPDealerForAudit", table);
            return ds;
        }

        /// <summary>
        /// LP及一级经销商订单明细导出
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet ExportPurchaseOrderDetailByFilterForLPDealer(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportPurchaseOrderDetailByFilterForLPDealer", table);
            return ds;
        }

        /// <summary>
        /// 二级经销商订单查询
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet ExportPurchaseOrderDetailByFilterForT2Dealer(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportPurchaseOrderDetailByFilterForT2Dealer", table);
            return ds;
        }

        /// <summary>
        /// 二级经销商订单明细导出
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPurchaseOrderHeaderByFilterForT2Dealer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPurchaseOrderHeaderByFilterForT2Dealer", table, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// BSC用户订单审核查询
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPurchaseOrderHeaderByFilterForAudit(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPurchaseOrderHeaderByFilterForAudit", table, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// BSC用户订单处理查询
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPurchaseOrderHeaderByFilterForMake(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPurchaseOrderHeaderByFilterForMake", table, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// 根据订单主键计算总订购数量和总金额
        /// </summary>
        /// <param name="dealerId"></param>
        /// <returns></returns>
        public DataSet SumPurchaseOrderByHeaderId(Guid headerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SumPurchaseOrderByHeaderId", headerId);
            return ds;
        }

        /// <summary>
        /// 临时订单修改为正式订单，并将原有订单状态修改为无效订单
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public void ActiveTemporaryOrder(Guid headerId, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_PurchaseOrderBSC_ActiveTemporaryOrder", ht);
            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();

        }

        /// <summary>
        /// 获取下单人员中文名称
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public DataSet GetSubmintUserByUserID(Guid userId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSubmintUserByUserID", userId);
            return ds;
        }

        /// <summary>
        /// 根据备注信息获取订单实体
        /// </summary>
        /// <returns>所有符合查询条件的实体</returns>
        public IList<PurchaseOrderHeader> GetClearBorrowPurchaseOrderHeader(Hashtable table)
        {
            IList<PurchaseOrderHeader> list = this.ExecuteQueryForList<PurchaseOrderHeader>("GetClearBorrowPurchaseOrderHeader", table);
            return list;
        }
        #endregion

        public DataSet SelectSalesByDealerAndProductLine(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSalesByDealerAndProductLine", table);
            return ds;
        }

        public DataSet SelectInterfaceOrderByBatchNo(string batchNo)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectInterfaceOrderByBatchNo", batchNo);
            return ds;
        }

        public int DeleteOrderPointByOrderHeaderId(Guid Id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteOrderPointByOrderHeaderId", Id);
            return cnt;
        }

        public void OrderPointCheck(Hashtable obj, out string rtnVal)
        {
            rtnVal = string.Empty;
            obj.Add("RetValue", rtnVal);
            this.ExecuteInsert("GC_OrderPointCheck", obj);
            rtnVal = obj["RetValue"].ToString();
        }

        public void PolicyFit(Guid prhid, string policyid, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("POH_ID", prhid);
            ht.Add("PolicyId", policyid);
            ht.Add("Result", rtnVal);
            ht.Add("RtnMsg", rtnVal);

            this.ExecuteInsert("GC_Proc_Interface_Imm_PolicyFit", ht);

            rtnVal = ht["Result"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }
        public DataSet SelectSAPWarehouseAddressByWhmId(string WhmId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSAPWarehouseAddressByWhmId", WhmId);
            return ds;
        }
        public void AddClearBorrowSubmitKbOrder(Guid PohId, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("POH_ID", PohId);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_PurchaseOrder_AfterClearBorrowSubmit", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public void AddClearBorrowConfirmKBOrder(Guid PohId, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("POH_ID", PohId);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            this.ExecuteInsert("GC_PurchaseOrder_AfterClearBorrowConfirm", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public DataSet GetCfnIsorderByUpn(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetCfnIsorderByUpn", ht);
            return ds;
        }
        public PurchaseOrderHeader GetOrderByOrderNo(string OrderNo)
        {
            PurchaseOrderHeader obj = this.ExecuteQueryForObject<PurchaseOrderHeader>("GetOrderByOrderNo", OrderNo);
            return obj;
        }
        public PurchaseOrderHeader GetOrderByOrderNoManual(string OrderNo)
        {
            PurchaseOrderHeader obj = this.ExecuteQueryForObject<PurchaseOrderHeader>("GetOrderByOrderNoManual", OrderNo);
            return obj;
        }
        public void InsertOrderOperationLog(Hashtable ht)
        {
            this.ExecuteInsert("InsertOrderOperationLog", ht);
        }
        public void RedInvoice_SumbitChecked(string PohId, string DealerId, string PlineId,string PointType,string OrderType, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", PohId);
            ht.Add("DealerId", DealerId);
            ht.Add("PlineId", PlineId);
            ht.Add("PointType", PointType);
            ht.Add("OrderType",OrderType);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMessing", RtnMsg);

            this.ExecuteInsert("GC_PRODealerRedInvoicesChecked", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMessing"].ToString();
        }
        public void PRODealerRedInvoice_Update(Guid PohId, string OrderSubType, Guid DealerId, Guid BUId, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("PohId", PohId);
            ht.Add("OrderSubType", OrderSubType);
            ht.Add("DealerId", DealerId);
            ht.Add("BUId", BUId);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);
            this.ExecuteInsert("GC_PRODealerRedInvoice_Update", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
        public void RedInvoice_RedInvoicesCheck(string PohId, string DealerId, string PlineId, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("PohId", PohId);
            ht.Add("DealerId", DealerId);
            ht.Add("PlineId", PlineId);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMessing", RtnMsg);
            this.ExecuteInsert("GC_Interface_RedInvoicesCheck", ht);

            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMessing"].ToString();

        }
        public DataSet SumPurchaseOrderByRedInvoicesHeaderId(string PohId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SumPurchaseOrderByRedInvoicesHeaderId", PohId);
            return ds;
        }
        public void DeleteOrderRedInvoicesByOrderHeaderId(string PohId)
        {
             this.ExecuteDelete("DeleteOrderRedInvoicesByOrderHeaderId", PohId);
            
        }
        public DataSet SelectDealerPaymentTypBYDmaId(string DmaId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerPaymentTypBYDmaId", DmaId);
            return ds;
        }
        public DataSet SelectDealerPermissions(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerPermissions", ht);
            return ds;
        }

        public DataSet PurchasingForecastReport(Hashtable table, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPurchasingForecastReport", table, start, limit, out totalCount);
            return ds;
               
        }
        public DataSet ExportPurchasingForecastReport(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExprotPurchasingForecastReport", obj);
            return ds;
        }
        public DataSet GetPurchaseOrderCarrierById(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPurchaseOrderCarrierById", obj);
            return ds;
        }
        public DataSet CheckBomOrderQty(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckBomOrderQty", obj);
            return ds;
        }
        public int UpdateOrderWmsSendflg(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateOrderWmsSendflg", obj);
            return cnt;
        }
        public DataSet GetPurchaseOrderWmsInfo()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPurchaseOrderWmsInfo", null);
            return ds;
        }
    }
}