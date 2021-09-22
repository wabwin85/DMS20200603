using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using System.Linq;
using System.Text;

namespace DMS.DataAccess
{
    public class AutoNumberDao : BaseSqlMapDao
    {
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public AutoNumberDao()
            : base()
        {
        }

        public string GetNextAutoNumber(Guid DMA_ID, string strSettings, string strBU, string SubCompanyId, string BrandId)
        {
            string strNextAutoNumber = "";
            Hashtable ht = new Hashtable();
            ht.Add("DealerId", DMA_ID);
            ht.Add("Settings", strSettings);
            ht.Add("BusinessUnit", strBU);
            ht.Add("NextAutoNbr", strNextAutoNumber);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            this.ExecuteInsert("GetNextAutoNumber", ht);
            strNextAutoNumber = ht["NextAutoNbr"].ToString();
            return strNextAutoNumber;
        }

        public string GetNextAutoNumberForPO(Guid DMA_ID, string strSettings, Guid prodLine, string orderType)
        {
            string strNextAutoNumber = "";
            Hashtable ht = new Hashtable();
            ht.Add("DealerId", DMA_ID);
            ht.Add("Settings", strSettings);
            ht.Add("ProdLine", prodLine);
            ht.Add("OrderType", orderType);
            ht.Add("NextAutoNbr", strNextAutoNumber);
            this.ExecuteInsert("GetNextAutoNumberForPO", ht);
            strNextAutoNumber = ht["NextAutoNbr"].ToString();
            return strNextAutoNumber;
        }
        public string GetNextAutoNumberForPO_PurchaseNew(Guid DMA_ID, string strSettings, Guid prodLine, string orderType, Guid SubCompanyId, Guid BrandId)
        {
            string strNextAutoNumber = "";
            Hashtable ht = new Hashtable();
            ht.Add("DealerId", DMA_ID);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            ht.Add("Settings", strSettings);
            ht.Add("ProdLine", prodLine);
            ht.Add("OrderType", orderType);
            ht.Add("NextAutoNbr", strNextAutoNumber);
            this.ExecuteInsert("GC_GetNextAutoNumberForPO_New", ht);
            strNextAutoNumber = ht["NextAutoNbr"].ToString();
            return strNextAutoNumber;
        }
        //added by bozhenfei on 20100609 @添加生成盘点单据号的方法
        public string GetNextAutoNumberForST(Guid DMA_ID, string strSettings)
        {
            string strNextAutoNumber = "";
            Hashtable ht = new Hashtable();
            ht.Add("DealerId", DMA_ID);
            ht.Add("Settings", strSettings);
            ht.Add("NextAutoNbr", strNextAutoNumber);
            this.ExecuteInsert("GetNextAutoNumberForST", ht);
            strNextAutoNumber = ht["NextAutoNbr"].ToString();
            return strNextAutoNumber;
        }

        //added by bozhenfei on 20110224 @生成接口批处理号
        public string GetNextAutoNumberForInt(string clientid, string strSettings)
        {
            string strNextAutoNumber = "";
            Hashtable ht = new Hashtable();
            ht.Add("ClientID", clientid);
            ht.Add("Settings", strSettings);
            ht.Add("NextAutoNbr", strNextAutoNumber);
            this.ExecuteInsert("GetNextAutoNumberForInt", ht);
            strNextAutoNumber = ht["NextAutoNbr"].ToString();
            return strNextAutoNumber;
        }

        public string GetNextAutoNumberForCode(string strSettings)
        {
            string strNextAutoNumber = "";
            Hashtable ht = new Hashtable();
            ht.Add("Settings", strSettings);
            ht.Add("NextAutoNbr", strNextAutoNumber);
            this.ExecuteInsert("GetNextAutoNumberForCode", ht);
            strNextAutoNumber = ht["NextAutoNbr"].ToString();
            return strNextAutoNumber;
        }
    }
}
