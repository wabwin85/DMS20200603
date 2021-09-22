
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ConsignmentApplyDetails
 * Created Time: 2015/11/13 15:23:44
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
    /// ConsignmentApplyDetails的Dao
    /// </summary>
    public class ConsignmentApplyDetailsDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public ConsignmentApplyDetailsDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ConsignmentApplyDetails GetObject(Guid objKey)
        {
            ConsignmentApplyDetails obj = this.ExecuteQueryForObject<ConsignmentApplyDetails>("SelectConsignmentApplyDetails", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ConsignmentApplyDetails> GetAll()
        {
            IList<ConsignmentApplyDetails> list = this.ExecuteQueryForList<ConsignmentApplyDetails>("SelectConsignmentApplyDetails", null);
            return list;
        }


        /// <summary>
        /// 查询ConsignmentApplyDetails
        /// </summary>
        /// <returns>返回ConsignmentApplyDetails集合</returns>
        public IList<ConsignmentApplyDetails> SelectByFilter(ConsignmentApplyDetails obj)
        {
            IList<ConsignmentApplyDetails> list = this.ExecuteQueryForList<ConsignmentApplyDetails>("SelectByFilterConsignmentApplyDetails", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ConsignmentApplyDetails obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateConsignmentApplyDetails", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteConsignmentApplyDetails", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ConsignmentApplyDetails obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteConsignmentApplyDetails", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ConsignmentApplyDetails obj)
        {
            this.ExecuteInsert("InsertConsignmentApplyDetails", obj);
        }
        /// <summary>
        /// 查询产品线下所有课定的产品
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>

        public DataSet SelectProlineCFNList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProlineCFNList", table, start, limit, out totalRowCount);
            return ds;
        }
        /// <summary>
        /// 添加产品
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="dealerId"></param>
        /// <param name="cfnString"></param>
        /// <param name="rtnVal"></param>
        /// <param name="rtnMsg"></param>
        public void AddSpeicalCfn(Guid headerId, Guid dealerId, string cfnString, string specialPriceId, string orderType, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("DealerId", dealerId);
            ht.Add("CfnString", cfnString);
            ht.Add("DealerType", "");
            ht.Add("OrderType", orderType);
            ht.Add("SpecialPriceId", specialPriceId);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_ConsignmenOrderBSC_AddCfn", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }
        public void AddConsignmentCfnset(Guid headerId, Guid dealerId, string cfnString, string PriceType, string SubCompanyId, string BrandId, out string rtnVal, out string rtnMsg)
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
            ht.Add("PriceType", PriceType);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);
            this.ExecuteInsert("GC_ConsignmentOrderBSC_AddCfnSet", ht);
            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }
        /// <summary>
        /// 查询订单产品明细
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet SelectConsignmentApplyProList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentApplyProList", table, start, limit, out totalRowCount);
            return ds;
        }
        public int DeleteHeaderConsignmentApplyDetails(Guid headerid)
        {
            int i = (int)this.ExecuteDelete("DeleteHeaderConsignmentApplyDetails", headerid);
            return i;
        }
        /// <summary>
        /// 查询产品线下的经销商
        /// </summary>
        /// <param name="ProductLineID"></param>
        /// <returns></returns>
        public DataSet SelectProductLineDma(string ProductLineID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductLineDma", ProductLineID);
            return ds;
        }
        /// <summary>
        /// 添加退货单产品
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="DealerId"></param>
        /// <param name="CfnString"></param>
        /// <param name="RtnVal"></param>
        /// <param name="RtnMsg"></param>
        public void AddConsignmenfnInventCfn(Guid headerId, string DealerId, string CfnString,string OrderType, string SubCompanyId, string BrandId, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;
            Hashtable table = new Hashtable();
            table.Add("PohId", headerId);
            table.Add("DealerId", DealerId);
            table.Add("SubCompanyId", SubCompanyId);
            table.Add("BrandId", BrandId);
            table.Add("OrderType", OrderType);
            table.Add("IsGetSpecialPrice", false);
            table.Add("CfnString", CfnString);
            table.Add("RtnVal", RtnVal);
            table.Add("RtnMsg", RtnMsg);
            this.ExecuteInsert("GC_ConsignmentOrderBSC_AddCfnInventory", table);
            RtnVal = table["RtnVal"].ToString();
            RtnMsg = table["RtnMsg"].ToString();
        }
        /// <summary>
        /// 查询产品总数量
        /// </summary>
        /// <param name="PhonId"></param>
        /// <returns></returns>
        public DataSet SelecConsignmentApplyDetailsCfnSum(string PhonId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelecConsignmentApplyDetailsCfnSum", PhonId);
            return ds;
        }

        public DataSet GC_GetApplyOrderHtml(Guid headerId, string mainKeyColumn, string mainTable
                                        , string detailKeyColumn, string detailTable
                                        , out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable table = new Hashtable();
            table.Add("KeyId", headerId);
            table.Add("MainKeyColumn", mainKeyColumn);
            table.Add("MainTableName", mainTable);
            table.Add("DetailKeyColumn", detailKeyColumn);
            table.Add("DetailTableName", detailTable);
            table.Add("RtnVal", rtnVal);
            table.Add("RtnMsg", rtnMsg);

            DataSet ds = this.ExecuteQueryForDataSet("SelectApplyOrderHtmlStr", table);
            return ds;
        }

        public DataSet GC_GetConsignmentDelayApplyOrderHtml(Guid headerId, string mainKeyColumn, string mainTable
                                        , string detailKeyColumn, string detailTable
                                        , out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable table = new Hashtable();
            table.Add("KeyId", headerId);
            table.Add("MainKeyColumn", mainKeyColumn);
            table.Add("MainTableName", mainTable);
            table.Add("DetailKeyColumn", detailKeyColumn);
            table.Add("DetailTableName", detailTable);
            table.Add("RtnVal", rtnVal);
            table.Add("RtnMsg", rtnMsg);

            DataSet ds = this.ExecuteQueryForDataSet("SelectDelayApplyOrderHtmlStr", table);
            return ds;
        }


        /// <summary>
        /// 查询订单产品明细
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet SelectConsignmentApplyProList(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentApplyProList", table);
            return ds;
        }

    }
}