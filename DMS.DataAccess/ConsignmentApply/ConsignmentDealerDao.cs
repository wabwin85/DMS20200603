
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ConsignmentDealer
 * Created Time: 2015/11/13 16:16:29
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
    /// ConsignmentDealer的Dao
    /// </summary>
    public class ConsignmentDealerDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ConsignmentDealerDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ConsignmentDealer GetObject(Guid objKey)
        {
            ConsignmentDealer obj = this.ExecuteQueryForObject<ConsignmentDealer>("SelectConsignmentDealer", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ConsignmentDealer> GetAll()
        {
            IList<ConsignmentDealer> list = this.ExecuteQueryForList<ConsignmentDealer>("SelectConsignmentDealer", null);          
            return list;
        }


        /// <summary>
        /// 查询ConsignmentDealer
        /// </summary>
        /// <returns>返回ConsignmentDealer集合</returns>
		public IList<ConsignmentDealer> SelectByFilter(ConsignmentDealer obj)
		{ 
			IList<ConsignmentDealer> list = this.ExecuteQueryForList<ConsignmentDealer>("SelectByFilterConsignmentDealer", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ConsignmentDealer obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateConsignmentDealer", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteConsignmentDealer", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ConsignmentDealer obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteConsignmentDealer", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ConsignmentDealer obj)
        {
            this.ExecuteInsert("InsertConsignmentDealer", obj);           
        }

        /// <summary>
        /// 获取经销商的规则
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>

        public DataSet SelectConsignmentDealerBy(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentDealerBy", table);
            return ds;
        }
        public void ChcekCfnSumbit(Guid CAH_ID, Guid DealerId, string ProductLineId,string CMID, out string rtnVal, out string rtnMsg, out string RtnRegMsg)
        {
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            RtnRegMsg = string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("CAH_ID", CAH_ID);
            ht.Add("DealerId", DealerId);
            ht.Add("ProductLineId", ProductLineId);
            ht.Add("CMID", CMID);
            ht.Add("rtnVal", rtnVal);
            ht.Add("rtnMsg", rtnMsg);
            ht.Add("RtnRegMsg", RtnRegMsg);

            this.ExecuteInsert("GC_ConsignmentApplyOrder_CheckSubmit", ht);

            rtnVal = ht["RtnVal"] != null ? ht["RtnVal"].ToString() : "";
            rtnMsg = ht["RtnMsg"] != null ? ht["RtnMsg"].ToString() : "";
            RtnRegMsg = ht["RtnRegMsg"] != null ? ht["RtnRegMsg"].ToString() : "";
        }
        public void AddConsignmentDealerby(string CMID, string DelareId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("CMID", CMID);
            ht.Add("DealerId", DelareId);
            this.ExecuteInsert("AddConsignmentDealerby", ht);           
        }
        public DataSet IsConsignmentDealerby(string CMID, string DMAID)
        {
            Hashtable ht = new Hashtable();
            ht.Add("CMID", CMID);
            ht.Add("DMAID", DMAID);
            DataSet ds = this.ExecuteQueryForDataSet("IsConsignmentDealerby", ht);
            return ds;
        }
        public void DeleteConsignmentCfnby(Guid id)
        {
            this.ExecuteUpdate("DeleteConsignmentCfnby", id); 
        }

        public DataSet SelectConsignmentContractDealer(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentContractDealer", table);
            return ds;
        }
    }
}