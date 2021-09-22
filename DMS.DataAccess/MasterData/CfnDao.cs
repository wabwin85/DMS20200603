

/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : Cfn
 * Created Time: 2009-7-9 11:31:09
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.DataAccess
{

    using DMS.Model;
    using System.Data;
    using System.Collections;
    /// <summary>
    /// Cfn的Dao
    /// </summary>
    public class CfnDao : BaseSqlMapDao
    {
        public Cfn GetCfn(Guid Id)
        {
            return base.ExecuteQueryForObject<Cfn>("SelectCfn", Id);
        }

        public Cfn GetCfnByUpn(string upn)
        {
            return base.ExecuteQueryForObject<Cfn>("SelectCfnByUpn", upn);
        }

        public IList<Cfn> SelectByFilter(Cfn cfn)
        {
            return base.ExecuteQueryForList<Cfn>("SelectCfnList", cfn);
        }

        public IList<Cfn> SelectByFilter(Cfn cfn, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForList<Cfn>("SelectCfnList", cfn, start, limit, out totalRowCount);
        }

        public IList<Cfn> SelectByFilterIsContain(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForList<Cfn>("SelectCfnListContain", obj, start, limit, out totalRowCount);
        }
        public IList<Cfn> SelectByFilterNoSet(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForList<Cfn>("SelectByFilterNoSet", obj, start, limit, out totalRowCount);
        }
        public IList<Cfn> SelectByCustomerFaceNbr(Cfn cfn)
        {
            return base.ExecuteQueryForList<Cfn>("SelectByCustomerFaceNbr", cfn);
        }

        public object Insert(Cfn cfn)
        {
            return base.ExecuteInsert("InsertCfn", cfn);
        }

        public int Update(Cfn cfn)
        {
            return base.ExecuteUpdate("UpdateCfn", cfn);
        }

        public int UpdateCatagory(Cfn cfn)
        {
            return base.ExecuteUpdate("UpdateCatagory", cfn);
        }

        public object Delete(Guid Id)
        {
            return base.ExecuteDelete("DeleteCfn", Id);
        }

        public int FakeDelete(Cfn cfn)
        {
            return base.ExecuteUpdate("FakeDeleteCfn", cfn);
        }

        #region added by bozhenfei on 20110216
        /// <summary>
        /// 根据经销商和产品线，根据经销商授权查询可订购产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnForPurchaseOrderByAuth(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryCfnForPurchaseOrderByAuth", table, start, limit, out totalRowCount, true);
            return ds;
        }


        /// <summary>
        /// 根据经销商和产品线以及促销政策，查询可订购产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnForPurchaseOrderByPromotion(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryCfnForPurchaseOrderByPromotion", table, start, limit, out totalRowCount);
            return ds;
        }


        public DataSet GetPromotionTypeById(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPromotionTypeById", Id);
            return ds;
        }

        /// <summary>
        /// 根据经销商和产品线，根据二级经销商授权查询可订购产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnForPurchaseOrderT2ByAuth(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryCfnForPurchaseOrderT2ByAuth", table, start, limit, out totalRowCount, true);
            return ds;
        }

        /// <summary>
        /// 根据经销商、产品线、特殊价格政策编号，查询可订购产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnForPurchaseOrderBySpecialPrice(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryCfnForPurchaseOrderBySpecialPrice", table, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// 根据经销商和产品线查询共享产品
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryCfnForPurchaseOrderByShare(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryCfnForPurchaseOrderByShare", table, start, limit, out totalRowCount);
            return ds;
        }
        #endregion

        /**
         *added by songyuqi on 20100608 
         **/

        public DataSet SelectCFNForDealerShare(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("SelectCFNForDealerShare", table, start, limit, out totalRowCount);
        }

        public DataSet SelectCFNForDealerNotShare(Hashtable table, int start, int limit, out int totalRowCount)
        {
            if (table.Contains("DMA_ID"))
            {
                return base.ExecuteQueryForDataSet("SelectCFNForDealerNotShare", table, start, limit, out totalRowCount);
            }

            else
            {
                return base.ExecuteQueryForDataSet("SelectCFNForAdmin", table, start, limit, out totalRowCount);
            }
        }


        //产品信息接口
        public DataSet P_GetAllCRMProduction()
        {
            return this.ExecuteQueryForDataSet("P_GetAllCRMProduction", null);
        }


        //Added By Song Yuqi On 2013-11-28 For WeChat Begin
        public DataSet GetAllProductTypeByFilter(Hashtable table)
        {
            return base.ExecuteQueryForDataSet("GetAllProductTypeByFilter", table);
        }
        //Added By Song Yuqi On 2013-11-28 For WeChat End

        public DataSet P_GetAllCFN()
        {
            return this.ExecuteQueryForDataSet("P_GetAllCFN", null);
        }

        //Added By Song Yuqi On 2015-05-27 For Qr Begin
        public IList<Cfn> QueryCfnByFilter(Hashtable table)
        {
            return base.ExecuteQueryForList<Cfn>("QueryCfnByFilter", table);
        }
        //Added By Song Yuqi On 2015-05-27 For Qr End

        //Add By Hua Kaichun
        public DataSet SelectCFNRegistration(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("SelectCFNRegistration", table, start, limit, out totalRowCount);
        }

        public DataSet QueryCfnForPurchaseOrderByPRO(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("SelectCfnForPurchaseOrderByPRO", table, start, limit, out totalRowCount);
        }

        public DataSet QueryPromotionProductLineType(Hashtable table)
        {
            return base.ExecuteQueryForDataSet("SelectPromotionProductLineType", table);
        }
        /// <summary>
        /// 短期寄售通过产品线查询组套产品
        /// </summary>
        /// <param name="ProductLineId"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryConsignmentCfnSetBy(string ProductLineId, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("QueryConsignmentCfnSetBy", ProductLineId, start, limit, out totalRowCount);
        }

        public DataSet QueryCfnForConsignmentMaster(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCfnForConsignmentMaster", table, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet SelectCFNRegistrationByUpn(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCFNRegistrationByUpn", ht);
            return ds;
        }
        public DataSet QueryCfnForPurchaseOrderT2ByPRO(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //DataSet ds = this.ExecuteQueryForDataSet("QueryCfnForPurchaseOrderT2ByPRO", table, start, limit, out totalRowCount);
            table["start"] = start;
            table["limit"] = limit + start;
            DataSet res = this.ExecuteQueryForDataSet("QueryCfnForPurchaseOrderT2ByPRO", table);
            if (res.Tables[0].Rows.Count > 0 && DBNull.Value != res.Tables[0].Rows[0][0])
            {
                totalRowCount = int.Parse(res.Tables[0].Rows[0][0].ToString());
            }
            else
            {
                totalRowCount = 0;
            }
            DataSet ds = new DataSet();
            ds.Tables.Add(res.Tables[1].Copy());
            //DataSet ds = this.ExecuteQueryForDataSet("GC_PurchaseOrderBSCPRO_AddCfn", table);
            //totalRowCount = ds.Tables[0].Rows.Count;
            return ds;
        }
        public DataSet SelectCFNRegistrationBylot(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectCFNRegistrationBylot", table, start, limit, out totalRowCount);
            return ds;

        }

        //added by huyong on 2019-08-29
        public Cfn SelectByPMAID(string upn)
        {
            return base.ExecuteQueryForObject<Cfn>("SelectByPMAID", upn);
        }

    }
}
