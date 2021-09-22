
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ConsignmentMaster
 * Created Time: 2015/11/13 16:16:55
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
using DMS.Model.Consignment;

namespace DMS.DataAccess
{
    /// <summary>
    /// ConsignmentMaster的Dao
    /// </summary>
    public class ConsignmentMasterDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ConsignmentMasterDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ConsignmentMaster GetObject(Guid objKey)
        {
            ConsignmentMaster obj = this.ExecuteQueryForObject<ConsignmentMaster>("SelectConsignmentMaster", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ConsignmentMaster> GetAll()
        {
            IList<ConsignmentMaster> list = this.ExecuteQueryForList<ConsignmentMaster>("SelectConsignmentMaster", null);          
            return list;
        }


        /// <summary>
        /// 查询ConsignmentMaster
        /// </summary>
        /// <returns>返回ConsignmentMaster集合</returns>
		public IList<ConsignmentMaster> SelectByFilter(ConsignmentMaster obj)
		{ 
			IList<ConsignmentMaster> list = this.ExecuteQueryForList<ConsignmentMaster>("SelectByFilterConsignmentMaster", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ConsignmentMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateConsignmentMaster", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteConsignmentMaster", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ConsignmentMaster obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteConsignmentMaster", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ConsignmentMaster obj)
        {
            this.ExecuteInsert("InsertConsignmentMaster", obj);           
        }


        public DataSet SelectConsignmentMasterByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentMasterByFilter", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectConsignmentMasterById(Guid obj, string SubCompanyId, string BrandId, int start, int limit, out int totalRowCount)
        {
            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("value", obj);
            ConsignContract.Add("SubCompanyId", SubCompanyId);
            ConsignContract.Add("BrandId", BrandId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentMasterById", obj, start, limit, out totalRowCount);
            return ds;
        }

        public void RevokeOrder(Guid obj)
        {
            this.ExecuteUpdate("RevokeOrder", obj);
        }
        public DataSet SelectConsignmentMasterByealer(string CmId, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentMasterByealer", CmId, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet QeryConsignmentMasterDealerSearch(Hashtable ht, int start, int limit, out int totalRowCount)
        {
          DataSet ds = this.ExecuteQueryForDataSet("QeryConsignmentMasterDealerSearch", ht, start, limit, out totalRowCount);
            return ds;
        }
     
        public void GC_ConsignmentMaster_CheckSubmit(Guid CM_ID, string ProductLineId,string name, out string rtnVal, out string rtnMsg, out string RtnRegMsg)
        {
            rtnVal=string.Empty;
            rtnMsg=string.Empty;
            RtnRegMsg=string.Empty;
            Hashtable ht = new Hashtable();
            ht.Add("CM_ID", CM_ID);
            ht.Add("ProductLineId", ProductLineId);
            ht.Add("NAme", name);
            ht.Add("RtnVal", rtnVal);
            ht.Add("RtnMsg", rtnMsg);
            ht.Add("RtnRegMsg", RtnRegMsg);
            this.ExecuteInsert("GC_ConsignmentMaster_CheckSubmit", ht);
            rtnVal = ht["RtnVal"].ToString();
            rtnMsg = ht["RtnMsg"].ToString();
            RtnRegMsg = ht["RtnRegMsg"].ToString();
        }
        public DataSet QuqerConsignmentAuthorizationby(Hashtable ht, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QuqerConsignmentAuthorizationby", ht, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet SelectConsignmentMasterAllby(string states)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectConsignmentMasterAllby", states);
            return ds;
        }
        public DataSet GetDelareProductLineby(string DmaId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDelareProductLineby", DmaId);
            return ds;
        }
        public DataSet GetProductLineConsignmenby(string ProductLineId,string DMAID)
        {
            Hashtable ht = new Hashtable();
            ht.Add("ProductLineId", ProductLineId);
            ht.Add("DMAID", DMAID);
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductLineConsignmenby", ht);
            return ds;
        }
        public void InsertConsignmentAuthorizationby(Hashtable ht)
        {
            this.ExecuteInsert("InsertConsignmentAuthorizationby", ht);           
        }
        public void UpdateConsignmentAuthorizationby(Hashtable ht)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateConsignmentAuthorizationby", ht);
          
        }
        public DataSet SelecConsignmentAuthorizationby(string CAID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelecConsignmentAuthorizationby", CAID);
            return ds;
        }
        public void Updatstopby(string CAID)
        {
            int cnt = (int)this.ExecuteUpdate("Updatstopby", CAID);
        }
        public void Updatrecoveryby(string CAID)
        {
            int cnt = (int)this.ExecuteUpdate("Updatrecoveryby", CAID);
        }
        public DataSet SelecConsignmentdatetimeby(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelecConsignmentdatetimeby", ht);
            return ds;
        }
        public void DeleteConsignmentDealerby(string CMID)
        {
            int cnt = (int)this.ExecuteUpdate("DeleteConsignmentDealerby", CMID);
        }
        public DataSet SelecConsignmentAuthorizationCount(Hashtable tb)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelecConsignmentAuthorizationCount", tb);
            return ds;
        }
    }
}