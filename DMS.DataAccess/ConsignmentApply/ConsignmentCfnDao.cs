
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ConsignmentCfn
 * Created Time: 2015/11/13 16:24:55
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
    /// ConsignmentCfn的Dao
    /// </summary>
    public class ConsignmentCfnDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ConsignmentCfnDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ConsignmentCfn GetObject(Guid objKey)
        {
            ConsignmentCfn obj = this.ExecuteQueryForObject<ConsignmentCfn>("SelectConsignmentCfn", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ConsignmentCfn> GetAll()
        {
            IList<ConsignmentCfn> list = this.ExecuteQueryForList<ConsignmentCfn>("SelectConsignmentCfn", null);          
            return list;
        }


        /// <summary>
        /// 查询ConsignmentCfn
        /// </summary>
        /// <returns>返回ConsignmentCfn集合</returns>
		public IList<ConsignmentCfn> SelectByFilter(ConsignmentCfn obj)
		{ 
			IList<ConsignmentCfn> list = this.ExecuteQueryForList<ConsignmentCfn>("SelectByFilterConsignmentCfn", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ConsignmentCfn obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateConsignmentCfn", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteConsignmentCfn", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ConsignmentCfn obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteConsignmentCfn", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ConsignmentCfn obj)
        {
            this.ExecuteInsert("InsertConsignmentCfn", obj);           
        }

        public int DeleteByCMID(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteConsignmentCfnByCMID", objKey);
            return cnt;
        }

        public DataSet QueryConsignmentCfnByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryConsignmentCfnByFilter", obj, start, limit, out totalRowCount);
            return ds;
        }

        public void AddCfn(Guid headerId, Guid dealerId, string cfnString, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("DealerId", dealerId);
            ht.Add("CfnString", cfnString);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_ConsignmenOrderBSC_AddCfn", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        public void AddMasterCfn(Guid headerId, Guid productlineId, string cfnString, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("PohId", headerId);
            ht.Add("ProductLineId", productlineId);
            ht.Add("CfnString", cfnString);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);

            this.ExecuteInsert("GC_ConsignmentMaster_AddCfn", ht);

            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }
        public void AddMasterCfnSet(Guid headerId,string cfnString,string PriceType, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("CMId", headerId);
            ht.Add("CfnString", cfnString);
            ht.Add("PriceType", "");
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);
            this.ExecuteInsert("GC_ConsignmentMaster_AddCfnSet", ht);
            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }

        public void PoReceipt(string ShipmentNbr,Guid WhmId, Guid UserId, out string rtnVal, out string rtnMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            Hashtable ht = new Hashtable();
            //ht.Add("CMId", headerId);
            ht.Add("ShipmentNbr", ShipmentNbr);
            ht.Add("WhmId", WhmId);
            ht.Add("UserId", UserId);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);
            this.ExecuteInsert("GC_Maunal_Receipt_ByShipmentNbr", ht);
            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
        }
    }
}