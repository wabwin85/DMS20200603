
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ThirdPartyDisclosure
 * Created Time: 2014/9/16 16:18:24
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
    /// ThirdPartyDisclosure的Dao
    /// </summary>
    public class ThirdPartyDisclosureDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ThirdPartyDisclosureDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DataSet GetObject(Guid objKey)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartyDisclosure", objKey);
            return ds;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ThirdPartyDisclosure> GetAll()
        {
            IList<ThirdPartyDisclosure> list = this.ExecuteQueryForList<ThirdPartyDisclosure>("SelectThirdPartyDisclosure", null);          
            return list;
        }


        /// <summary>
        /// 查询ThirdPartyDisclosure
        /// </summary>
        /// <returns>返回ThirdPartyDisclosure集合</returns>
		public IList<ThirdPartyDisclosure> SelectByFilter(ThirdPartyDisclosure obj)
		{ 
			IList<ThirdPartyDisclosure> list = this.ExecuteQueryForList<ThirdPartyDisclosure>("SelectByFilterThirdPartyDisclosure", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ThirdPartyDisclosure obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateThirdPartyDisclosure", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteThirdPartyDisclosure", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ThirdPartyDisclosure obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteThirdPartyDisclosure", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ThirdPartyDisclosure obj)
        {
            this.ExecuteInsert("InsertThirdPartyDisclosure", obj);           
        }

        public DataSet GetThirdPartyDisclosureQuery(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartyDisclosureQuery", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetThirdPartyDisclosureQuery(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartyDisclosureQuery", obj);
            return ds;
        }

        public DataSet GetThirdPartyDisclosureQueryNoPL(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartyDisclosureQueryNoPL", obj);
            return ds;
        }
        

        public int DeleteThirdPartyDisclosureByAuthorized(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteThirdPartyDisclosureByAuthorized", obj);
            return cnt;
        }

        public DataSet SynchronousHospitalToThirdParty(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SynchronousHospitalToThirdParty", obj);
            return ds;
        }

        public void SetHospitalNoDisclosure(Hashtable param)
        {
            this.ExecuteUpdate("UpdateHospitalNoDisclosure", param);
        }

        public int  ApprovalThirdParty(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("ApprovalThirdParty", param);
            return cnt;
        }

        public DataSet GetThirdPartyBuType(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartyBuType", obj);
            return ds;
        }
        public DataSet QueryThirdPartyDisclosure(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryThirdPartyDisclosure", obj, start, limit, out totalRowCount);
            return ds;
        }
       
        public DataSet ExportThirdPartyDisclosure(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportThirdPartyDisclosure", obj);
            return ds;
        }
        public DataSet SelectThirdPartyDisclosureHospitBU(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartyDisclosureHospitBU", obj);
            return ds;
        }
        public void InsertContractLog(Hashtable obj)
        {
           this.ExecuteInsert("InsertContractLog", obj);
        }
        public DataSet ThirdPartyDisclosureHospitBU(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ThirdPartyDisclosureHospitBU", obj);
            return ds;

        }
    }
}