
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : IssuesList
 * Created Time: 2010-6-7 13:11:35
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
    /// IssuesList的Dao
    /// </summary>
    public class IssuesListDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public IssuesListDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public IssuesList GetObject(Guid objKey)
        {
            IssuesList obj = this.ExecuteQueryForObject<IssuesList>("SelectIssuesList", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<IssuesList> GetAll()
        {
            IList<IssuesList> list = this.ExecuteQueryForList<IssuesList>("SelectIssuesList", null);          
            return list;
        }


        /// <summary>
        /// 查询IssuesList
        /// </summary>
        /// <returns>返回IssuesList集合</returns>
		public IList<IssuesList> SelectByFilter(IssuesList obj)
		{ 
			IList<IssuesList> list = this.ExecuteQueryForList<IssuesList>("SelectByFilterIssuesList", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(IssuesList obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateIssuesList", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteIssuesList", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(IssuesList obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteIssuesList", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(IssuesList obj)
        {
            this.ExecuteInsert("InsertIssuesList", obj);           
        }


        /**
         * added by songyuqi on 20100607
         * */

        /// <summary>
        /// 查询IssuesList带分页
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>返回查询得到的集合</returns>
        public DataSet QuerySelectByFile(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("QuerySelectByFilterIssuesList", obj, start, limit, out totalRowCount);
        }

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Guid id)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteIssuesList", id);
            return cnt;
        }

        /// <summary>
        /// 验证该序号是否已存在
        /// </summary>
        /// <param name="obj">序号</param>
        /// <returns>得到实体</returns>
        public IssuesList VerifySortNo(string SortNo)
        {
            return this.ExecuteQueryForObject<IssuesList>("SelectByFilterIssuesListBySortNo", SortNo);
        }

        /// <summary>
        /// 得到数据中SortNo的最大值
        /// </summary>
        /// <returns>SortNo的最大值</returns>
        public int getMaxSortNo()
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByFilterIssuesListMaxSortNo", null);

            //object temp = ds.Tables[0].Rows[0]["MaxSortNo"];

            if (ds.Tables[0].Rows[0]["MaxSortNo"].ToString() == "")
                return 0;
            else
                return Convert.ToInt16(ds.Tables[0].Rows[0]["MaxSortNo"].ToString());
        }

        public DataSet QueryTopTenIssuesListOnLogin(Hashtable obj)
        {
            return base.ExecuteQueryForDataSet("QueryTopTenIssuesListOnLogin", obj);
        }
    }
}