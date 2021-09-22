
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ThirdPartyDisclosureList
 * Created Time: 2017/10/27 15:02:11
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
    /// ThirdPartyDisclosureList的Dao
    /// </summary>
    public class ThirdPartyDisclosureListDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ThirdPartyDisclosureListDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DataSet  GetObject(Guid objKey)
        {
             DataSet ds = this.ExecuteQueryForDataSet("GetThirdPartyDisclosureListById", objKey);           
             return ds;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ThirdPartyDisclosureList> GetAll()
        {
            IList<ThirdPartyDisclosureList> list = this.ExecuteQueryForList<ThirdPartyDisclosureList>("SelectThirdPartyDisclosureList", null);          
            return list;
        }


        /// <summary>
        /// 查询ThirdPartyDisclosureList
        /// </summary>
        /// <returns>返回ThirdPartyDisclosureList集合</returns>
		public IList<ThirdPartyDisclosureList> SelectByFilter(ThirdPartyDisclosureList obj)
		{ 
			IList<ThirdPartyDisclosureList> list = this.ExecuteQueryForList<ThirdPartyDisclosureList>("SelectByFilterThirdPartyDisclosureList", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ThirdPartyDisclosureList obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateThirdPartyDisclosureList", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteThirdPartyDisclosureList", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ThirdPartyDisclosureList obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteThirdPartyDisclosureList", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ThirdPartyDisclosureList obj)
        {
            this.ExecuteInsert("InsertThirdPartyDisclosureList", obj);           
        }

        public DataSet DealerAuthorizationHospital(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DealerAuthorizationHospital", obj, start, limit, out totalRowCount);
            return ds;

        }
        public DataSet SelectThirdPartyDisclosureList(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartyDisclosureList", obj, start, limit, out totalRowCount);
            return ds;

        }

        public int UpdateThirdPartyDisclosureList(ThirdPartyDisclosureList obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateThirdPartyDisclosureList", obj);
            return cnt;
        }
        public int ApprovalThirdPartyDisclosureList(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("ApprovalThirdPartyDisclosureList", param);
            return cnt;
        }

        public DataSet ThirdPartyDisclosureListByBU(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ThirdPartyDisclosureListByBU", obj);
            return ds;

        }
        public int RefuseThirdPartyDisclosureList(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("RefuseThirdPartyDisclosureList", param);
            return cnt;
        }

        public DataSet SelectThirdPartyDisclosureList(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartyDisclosureList", obj);
            return ds;

        }
        public DataSet GetThirdPartyDisclosureListBuType(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetThirdPartyDisclosureListBuType", obj);
            return ds;
        }

        public DataSet SelectThirdPartyDisclosureListHospitBU(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartyDisclosureListHospitBU", obj);
            return ds;
        }

        public int UpdateThirdPartyDisclosureListend(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateThirdPartyDisclosureListend", param);
            return cnt;
        }

        public void InsertThirdPartyDisclosureListLp(ThirdPartyDisclosureList obj)
        {
            this.ExecuteInsert("InsertThirdPartyDisclosureListLp", obj);
        }

        public DataSet SelectThirdPartyDisclosureListType(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartyDisclosureListType", obj, start, limit, out totalRowCount);
            return ds;
        }
        
        public DataSet SelectThirdPartylist(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectThirdPartylist", obj);
            return ds;
        }
        public DataSet ThirdPartylist(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ThirdPartylist", obj, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet ThirdPartylist(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ThirdPartylist", obj);
            return ds;

        }
        public int updateThirdPartyList(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("updateThirdPartyList", param);
            return cnt;
        }
        public int updateendThirdPartyList(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("updateendThirdPartyList", param);
            return cnt;
        }

        public int endThirdPartyList(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("endThirdPartyList", obj);
            return cnt;
        }

        public DataSet Authorinformation(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("Authorinformation", obj);
            return ds;
        }

        public DataSet ThirdPartyDisclosureListALL(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ThirdPartyDisclosureListALL", obj);
            return ds;
        }

        public DataSet ExportThirdPartylist(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportThirdPartylist", obj);
            return ds;

        }
        public int TerminationThirdPartyList(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("TerminationThirdPartyList", obj);
            return cnt;
        }
    }
}