
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : PurchaseOrderInit
 * Created Time: 2011-6-17 16:47:42
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
    /// DealerPriceInit的Dao
    /// </summary>
    public class DealerComplainDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public DealerComplainDao()
            : base()
        {
        }

        public String GC_DealerComplain_Save(Hashtable dealerComplainInfo)
        {
            this.ExecuteUpdate("GC_DealerComplain_Save", dealerComplainInfo);
            String result = (String)dealerComplainInfo["Result"];//这里才是最后的返回值 
            return result;
        }

        public DataSet SelectDealerComplainByHashtable(Hashtable condition, int start, int limit, out int totalRowCount)
        {
            return this.ExecuteQueryForDataSet("SelectDealerComplainByHashtable", condition, start, limit, out totalRowCount);
        }

        public DataSet GC_DealerComplain_Info(Hashtable dealerComplainInfo)
        {
            return this.ExecuteQueryForDataSet("GC_DealerComplain_Info", dealerComplainInfo);
        }

        public DataSet GC_DealerComplain_Info_SpecialDateFormat(Hashtable dealerComplainInfo)
        {
            return this.ExecuteQueryForDataSet("GC_DealerComplain_Info_SpecialDateFormat", dealerComplainInfo);
        }

        public DataSet SelectDealerComplainUPN(Hashtable condition)
        {
            return this.ExecuteQueryForDataSet("SelectDealerComplainUPN", condition);
        }

        public void UpdateDealerComplainCancel(Hashtable condition)
        {
            this.ExecuteUpdate("UpdateDealerComplainCancel", condition);
        }

        public void UpdateDealerComplainConfirm(Hashtable condition)
        {
            this.ExecuteInsert("UpdateDealerComplainConfirm", condition);
        }

        public void UpdateBSCCarrierNumber(Hashtable condition)
        {
            this.ExecuteInsert("UpdateBSCCarrierNumber", condition);  
            //this.ExecuteUpdate("UpdateCarrierNumber", condition);
        }

        public void CheckUPNAndDate(Hashtable condition, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            condition.Add("RtnVal", rtnVal);
            condition.Add("RtnMsg", rtnMsg);
            this.ExecuteInsert("GC_DealerComplain_CheckUPNAndDate", condition);            
            rtnVal = condition["RtnVal"].ToString();
            rtnMsg = condition["RtnMsg"].ToString();
        }       

        public void UpdateDealerComplainConfirmCRM(Hashtable condition)
        {
            this.ExecuteInsert("UpdateDealerComplainConfirmCRM", condition);
        }

        public void UpdateCRMCarrierNumber(Hashtable condition)
        {
            this.ExecuteInsert("UpdateCRMCarrierNumber", condition);
            
        }

        public void CheckUPNAndDateCRM(Hashtable condition, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            condition.Add("RtnVal", rtnVal);
            condition.Add("RtnMsg", rtnMsg);
            this.ExecuteInsert("GC_DealerComplain_CheckUPNAndDateCRM", condition);
            rtnVal = condition["RtnVal"].ToString();
            rtnMsg = condition["RtnMsg"].ToString();
        }

        public void UpdateBSCRevoke(Hashtable condition)
        {
            this.ExecuteInsert("UpdateBSCRevoke", condition);           
        }

        public void UpdateCRMRevoke(Hashtable condition)
        {
            this.ExecuteInsert("UpdateCRMRevoke", condition);
        }

        public DataSet DealerComplainExport(Hashtable condition)
        {
            return this.ExecuteQueryForDataSet("DealerComplainExport", condition);
        }
        public int UpdateDealerComplainStatus(Hashtable condition)
        {
            return this.ExecuteUpdate("UpdateDealerComplainStatus", condition);
        }
        public int UpdateDealerComplainStatusCRM(Hashtable condition)
        {
            return this.ExecuteUpdate("UpdateDealerComplainStatusCRM", condition);
        }
        public int UpdateDealerComplainCourierCNF(Hashtable condition)
        {
            return this.ExecuteUpdate("UpdateDealerComplainCourierCNF", condition);
        }
        public int UpdateDealerComplainCourierCRM(Hashtable condition)
        {
            return this.ExecuteUpdate("UpdateDealerComplainCourierCRM", condition);
        }
        public int UpdateDealerComplainIANCNF(Hashtable condition)
        {
            return this.ExecuteUpdate("UpdateDealerComplainIANCNF", condition);
        }
        public int UpdateDealerComplainIANCRM(Hashtable condition)
        {
            return this.ExecuteUpdate("UpdateDealerComplainIANCRM", condition);
        }
        #region Added By Song Yuqi For 经销商投诉退换货 On 2017-08-23
        public String GC_DealerComplain_SaveForNew(Hashtable dealerComplainInfo)
        {
            this.ExecuteUpdate("GC_DealerComplain_SaveForNew", dealerComplainInfo);
            String result = (String)dealerComplainInfo["Result"];//这里才是最后的返回值 
            return result;
        }

        public String GC_DealerComplainForReturn_Save(Hashtable dealerComplainInfo)
        {
            this.ExecuteUpdate("GC_DealerComplainForReturn_Save", dealerComplainInfo);
            String result = (String)dealerComplainInfo["Result"];//这里才是最后的返回值 
            return result;
        }
        

        /// <summary>
        /// 波科人员下拉框数据源
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        public DataSet SelectBscSrForComplain(Hashtable table)
        {
            return this.ExecuteQueryForDataSet("SelectBscSrForComplain", table);
        }

        public void UpdateDealerComplainStatusByFilter(Hashtable table)
        {
            this.ExecuteQueryForDataSet("UpdateDealerComplainStatusByFilter", table);
        }

        public DataTable QueryDealerComplainBscInfo(Guid complainId)
        {
            return this.ExecuteQueryForDataSet("QueryDealerComplainBscInfo", complainId).Tables[0];
        }

        public int SaveDealerComplainBsc(Hashtable condition)
        {
            return this.ExecuteUpdate("SaveDealerComplainBsc", condition);
        }

        public void CheckUPNAndDateCNFForEkp(Hashtable table, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            table.Add("RtnVal", rtnVal);
            table.Add("RtnMsg", rtnMsg);
            this.ExecuteInsert("GC_DealerComplain_CheckUPNAndDateCNF_ForEkp", table);
            rtnVal = table["RtnVal"].ToString();
            rtnMsg = table["RtnMsg"].ToString();
        }

        public void CheckUPNAndDateCRMForEkp(Hashtable table, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            table.Add("RtnVal", rtnVal);
            table.Add("RtnMsg", rtnMsg);
            this.ExecuteInsert("GC_DealerComplain_CheckUPNAndDateCRM_ForEkp", table);
            rtnVal = table["RtnVal"].ToString();
            rtnMsg = table["RtnMsg"].ToString();
        }

        public void SendComplainMailToBSCSales(Hashtable table)
        {
            this.ExecuteInsert("GC_SalesComplain_SendMail", table);
        }
        #endregion
    }
}