
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : PurchaseOrderDetail
 * Created Time: 2011-2-10 13:21:18
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
    /// PurchaseOrderDetail的Dao
    /// </summary>
    public class PurchaseOrderDetailDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public PurchaseOrderDetailDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public PurchaseOrderDetail GetObject(Guid objKey)
        {
            PurchaseOrderDetail obj = this.ExecuteQueryForObject<PurchaseOrderDetail>("SelectPurchaseOrderDetail", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<PurchaseOrderDetail> GetAll()
        {
            IList<PurchaseOrderDetail> list = this.ExecuteQueryForList<PurchaseOrderDetail>("SelectPurchaseOrderDetail", null);
            return list;
        }


        /// <summary>
        /// 查询PurchaseOrderDetail
        /// </summary>
        /// <returns>返回PurchaseOrderDetail集合</returns>
        public IList<PurchaseOrderDetail> SelectByFilter(PurchaseOrderDetail obj)
        {
            IList<PurchaseOrderDetail> list = this.ExecuteQueryForList<PurchaseOrderDetail>("SelectByFilterPurchaseOrderDetail", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(PurchaseOrderDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderDetail", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeletePurchaseOrderDetail", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(PurchaseOrderDetail obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeletePurchaseOrderDetail", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(PurchaseOrderDetail obj)
        {
            this.ExecuteInsert("InsertPurchaseOrderDetail", obj);
        }

        #region added by bozhenfei on 20110214
        /// <summary>
        /// 根据订单表头主键查询明细行
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPurchaseOrderDetailByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPurchaseOrderDetailByFilter", table, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// 根据订单表头主键查询发货信息明细行
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPoReceiptOrderDetailByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPoReceiptOrderDetailByFilter", table, start, limit, out totalRowCount);
            return ds;
        }
        /// <summary>
        /// 根据订单表头主键查询明细行中是否已包含相同的lot号
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public int QueryLotNumberCount(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryLotNumberCount", ht);
            return Convert.ToInt16(ds.Tables[0].Rows[0]["num"].ToString());
        }

        /// <summary>
        /// 根据订单表头主键查询明细行中是否已包含相同的产品价格lot号
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public int QueryLotPriceCount(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryLotPriceCount", ht);
            return Convert.ToInt16(ds.Tables[0].Rows[0]["num"].ToString());
        }


        /// <summary>
        /// 根据订单表头主键查询明细行(For LP & T1)
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryLPPurchaseOrderDetailByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryLPPurchaseOrderDetailByFilter", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet QueryLPPurchaseOrderDetailByFilter(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryLPPurchaseOrderDetailByFilter", table);
            return ds;
        }

        /// <summary>
        /// 根据订单表头主键删除明细
        /// </summary>
        /// <param name="PohId"></param>
        /// <returns></returns>
        public int DeletePurchaseOrderDetailByHeaderId(Guid headerId)
        {
            int cnt = (int)this.ExecuteDelete("DeletePurchaseOrderDetailByHeaderId", headerId);
            return cnt;
        }

        /// <summary>
        /// 根据订单表头主键得到明细行
        /// </summary>
        /// <param name="headerId"></param>
        /// <returns></returns>
        public IList<PurchaseOrderDetail> SelectByHeaderId(Guid headerId)
        {
            IList<PurchaseOrderDetail> list = this.ExecuteQueryForList<PurchaseOrderDetail>("SelectPurchaseOrderDetailByHeaderId", headerId);
            return list;
        }

        /// <summary>
        /// 添加产品
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="cfnString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public void AddCfn(Guid headerId, Guid dealerId, string cfnString, string ordertype, string SubCompanyId,string BrandId,out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

           
            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("DealerId", dealerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsGetSpecialPrice", false);
            ht.Add("CfnString", cfnString);
            ht.Add("OrderType", ordertype);
            ht.Add("DealerType", "");
            ht.Add("SpecialPriceId", "");
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_PurchaseOrderBSC_AddCfn", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        /// <summary>
        /// 添特殊价格产品
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="cfnString"></param>
        /// <param name="specialPriceId"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public void AddSpeicalCfn(Guid headerId, Guid dealerId, string cfnString, string specialPriceId, string orderType, string SubCompanyId, string BrandId, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("DealerId", dealerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsGetSpecialPrice", false);
            ht.Add("CfnString", cfnString);
            ht.Add("DealerType", "");
            ht.Add("OrderType", orderType);
            ht.Add("SpecialPriceId", specialPriceId);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_PurchaseOrderBSC_AddCfn", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        /// <summary>
        /// 添加成套产品
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="cfnString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public void AddCfnSet(Guid headerId, Guid dealerId, string SubCompanyId, string BrandId, string cfnString, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("DealerId", dealerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("CfnString", cfnString);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_PurchaseOrder_AddCfnSet", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        /// <summary>
        /// 添加成套产品(BSC)
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="cfnString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public void AddBSCCfnSet(Guid headerId, Guid dealerId, string cfnString, string priceType, string SubCompanyId, string BrandId, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("DealerId", dealerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("IsGetSpecialPrice", false);
            ht.Add("CfnString", cfnString);
            ht.Add("PriceType", priceType);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);


            this.ExecuteInsert("GC_PurchaseOrderBSC_AddCfnSet", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }


        public void AddSpecialCfnPromotion(Guid headerId, Guid dealerId, string cfnString ,string cfnCheckString, string specialPriceId, string orderType,out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("DealerId", dealerId);
            ht.Add("CfnString", cfnString);
            ht.Add("CfnCheckString", cfnCheckString);
            ht.Add("DealerType", "");
            ht.Add("OrderType", orderType);
            ht.Add("SpecialPriceId", specialPriceId);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_PurchaseOrderBSCPRO_AddCfn", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        /// <summary>
        /// 提交前检查明细行
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        /// <param name="rtnRegMsg"></param>
        //public void CheckSubmit(Guid headerId, Guid dealerId, out string rtnVal, out string rtnMsg, out string rtnRegMsg, out string errorMsg)
        //{
        //    rtnVal = string.Empty;
        //    rtnMsg = string.Empty;
        //    rtnRegMsg = string.Empty;
        //    errorMsg = string.Empty;

        //    Hashtable ht = new Hashtable();
        //    ht.Add("PohId", headerId);
        //    ht.Add("DealerId", dealerId);
        //    ht.Add("RtnVal", rtnVal);
        //    ht.Add("RtnMsg", rtnMsg);
        //    ht.Add("RtnRegMsg", rtnRegMsg);
        //    ht.Add("ErrorMsg", errorMsg);

        //    this.ExecuteInsert("GC_PurchaseOrder_CheckSubmit", ht);

        //    rtnVal = ht["RtnVal"].ToString();
        //    rtnMsg = ht["RtnMsg"].ToString();
        //    rtnRegMsg = ht["RtnRegMsg"].ToString();
        //    errorMsg = ht["ErrorMsg"].ToString();
        //}
        public void CheckSubmit(Guid headerId, Guid dealerId, out string rtnVal, out string rtnMsg, out string rtnRegMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            rtnRegMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);            
            ht.Add("DealerId", dealerId);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);
            ht.Add("RtnRegMsg", rtnRegMsg);

            this.ExecuteInsert("GC_PurchaseOrder_CheckSubmit", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
            rtnRegMsg = ht["RtnRegMsg"].ToString();
        }

        public void CheckSubmit(Guid headerId, Guid dealerId,string SubCompanyId, string BrandId, String promotionPolicyID, String priceType, String orderType, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("DealerId", dealerId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("PromotionPolicyID", promotionPolicyID);
            ht.Add("PriceType", priceType);
            ht.Add("OrderType", orderType);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_PurchaseOrderBSC_BeforeSubmit", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        public void CheckSubmitSpecial(Guid headerId, Guid dealerId, Guid specialPriceId, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("DealerId", dealerId);
            ht.Add("SpecialPriceId", specialPriceId);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_PurchaseOrderBSC_BeforeSubmitSpecial", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }
        /// <summary>
        /// 复制订单
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="userId"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public void Copy(Guid headerId, Guid dealerId, Guid userId, String priceType, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("DealerId", dealerId);
            ht.Add("UserId", userId);
            ht.Add("PriceType", priceType);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_PurchaseOrder_Copy", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        /// <summary>
        /// 因修改订单而复制临时类型订单
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="userId"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public void CopyForTemporary(Guid headerId, Guid instanceId, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("InstanceId", instanceId);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_PurchaseOrder_CopyForTemporary", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }


        /// <summary>
        /// 锁定订单
        /// </summary>
        /// <param name="dealerId"></param>
        /// <param name="userId"></param>
        /// <param name="listString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public void Lock(Guid userId, string listString, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("ListString", listString);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_PurchaseOrder_Lock", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        /// <summary>
        /// 解锁订单
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="listString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public void Unlock(Guid userId, string listString, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("ListString", listString);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_PurchaseOrder_Unlock", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        /// <summary>
        /// 手工生成订单接口
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="listString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        /// <param name="batchNbr"></param>
        public void MakeManual(Guid userId, string listString, out string rtnVal, out string rtnMsg, out string batchNbr)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            batchNbr = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", userId);
            ht.Add("ListString", listString);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);
            ht.Add("BatchNbr", batchNbr);

            this.ExecuteInsert("GC_PurchaseOrder_MakeManual", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
            batchNbr = ht["BatchNbr"].ToString();
        }

        public DataSet SelectPurchaseOrderDetailByHeaderIdForMail(Guid headerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPurchaseOrderDetailByHeaderIdForMail", headerId);
            return ds;
        }

        public DataSet SelectPurchaseOrderDetailByHeaderIdForOrderComplete(Guid headerId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPurchaseOrderDetailByHeaderIdForOrderComplete", headerId);
            return ds;
        }

        //订单关闭时更新订单明细（订购数量，金额）       
        public int UpdatePurchaseOrderDetailForOrderComplete(String pohId)
        {
            int cnt = (int)this.ExecuteUpdate("UpdatePurchaseOrderDetailForOrderComplete", pohId);
            return cnt;
        }

        //判断清指定批号订单是否修改过金额
        public DataSet CheckUpdatePrice(Guid headerId)
        {
            //TODO，目前无调用，调用添加分子公司品牌
            DataSet ds = this.ExecuteQueryForDataSet("CheckUpdatePrice", headerId);
            return ds;
        }
        #endregion

        public void PRODealerLargessUpdate(Hashtable obj)
        {
            this.ExecuteInsert("GC_PRODealerLargess_Update", obj);
        }

        public void OrderPointSubmint(Hashtable obj) 
        {
            this.ExecuteInsert("GC_PointOrderSubmint", obj);
        }

        public void OrderPointRevok(Hashtable obj)
        {
            this.ExecuteInsert("GC_PointOrderRevoke", obj);
        }

        public DataSet GetNoticeCfnListByStringForEmail(string obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetNoticeCfnListByStringForEmail", obj);
            return ds;
        }
    }
}