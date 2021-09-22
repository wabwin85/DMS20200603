using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;
using DMS.Model.Consignment;


namespace DMS.DataAccess.Consignment
{
    public class ConsignCommonDao : BaseSqlMapDao
    {
        public ConsignCommonDao()
            : base()
        {
        }

        #region Select
        public DataSet SelectConsignCountList(Hashtable condition, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("Consignment.ConsignCommonMap.SelectConsignmentQuotaList", condition, start, limit,out totalCount);
            return ds;
        }
        public DataSet SelectUpnByDealerID(Hashtable condition)
        {
            DataSet ds = this.ExecuteQueryForDataSet("Consignment.ConsignCommonMap.SelectUpnByDealerID", condition);
            return ds;
        }
        #endregion

        #region Insert
        public void InsertConsignCountManage(ConsignCountManagePO ccmp )
        {           
            this.ExecuteInsert("Consignment.ConsignCommonMap.InsertConsignCountManage", ccmp);
        }
        #endregion

        #region Update
        public void UpdateConsignCountManage(ConsignCountManagePO ccmp)
        {
            this.ExecuteUpdate("Consignment.ConsignCommonMap.UpdateConsignCountManage", ccmp);

        }
        #endregion

        #region Delete
        public int DeleteConsignCountManage(Guid CQ_ID)
        {
            int cnt = (int)this.ExecuteDelete("Consignment.ConsignCommonMap.Delete", CQ_ID);
            return cnt;
        }
        #endregion

        #region Procdure

        public string ProcGetNextAutoNumber(String deptCode, Guid productLineId, String clientId, String settings)
        {
            string nextNum = "";

            Hashtable ht = new Hashtable();
            ht.Add("DeptCode", deptCode);
            ht.Add("ProductLineId", productLineId);
            ht.Add("ClientId", clientId);
            ht.Add("Settings", settings);
            ht.Add("NextNum", nextNum);

            base.ExecuteInsert("Consignment.ConsignCommonMap.ProcGetNextAutoNumber", ht);

            nextNum = ht["NextNum"].ToString();
            return nextNum;
        }

        public void ProcConsignPurchaseOrderCreate(string OrderType, string BillType, string SubCompanyId, string BrandId, string BillNo, string IsActiveImmediately,out string RtnVal, out string RtnMsg)
        {
            RtnVal = "";
            RtnMsg = "";
            Hashtable ht = new Hashtable();
            ht.Add("OrderType", OrderType);
            ht.Add("BillType", BillType);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("BillNo", BillNo);
            ht.Add("IsActiveImmediately", IsActiveImmediately);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            base.ExecuteInsert("Consignment.ConsignCommonMap.PurchaseOrderCreate", ht);
            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }

        public void ProcConsigntInvBuyOff(string BillType, string BillNo, string SubCompanyId, string BrandId, out string RtnVal, out string RtnMsg)
        {
            RtnVal = "";
            RtnMsg = "";
            Hashtable ht = new Hashtable();
            ht.Add("BillType",BillType);
            ht.Add("BillNo", BillNo);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("RtnVal", RtnVal);
            ht.Add("RtnMsg", RtnMsg);

            base.ExecuteInsert("Consignment.ConsignCommonMap.ConsignmentInvBuyOff", ht);
            RtnVal = ht["RtnVal"].ToString();
            RtnMsg = ht["RtnMsg"].ToString();
        }
        #endregion
    }
}
