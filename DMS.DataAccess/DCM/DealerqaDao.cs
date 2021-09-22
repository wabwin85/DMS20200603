
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : Dealerqa
 * Created Time: 2010-6-12 13:50:57
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
    /// Dealerqa的Dao
    /// </summary>
    public class DealerqaDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerqaDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public Dealerqa GetObject(Guid objKey)
        {
            Dealerqa obj = this.ExecuteQueryForObject<Dealerqa>("SelectDealerqa", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<Dealerqa> GetAll()
        {
            IList<Dealerqa> list = this.ExecuteQueryForList<Dealerqa>("SelectDealerqa", null);          
            return list;
        }


        /// <summary>
        /// 查询Dealerqa
        /// </summary>
        /// <returns>返回Dealerqa集合</returns>
		public IList<Dealerqa> SelectByFilter(Dealerqa obj)
		{ 
			IList<Dealerqa> list = this.ExecuteQueryForList<Dealerqa>("SelectByFilterDealerqa", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(Dealerqa obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerqa", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerqa", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(Dealerqa obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerqa", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(Dealerqa obj)
        {
            this.ExecuteInsert("InsertDealerqa", obj);           
        }

        //added by songyuqi on 20100613
        public DataSet QuerySelectByFileForDealer(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("QuerySelectByFilterDealerqaForDealer", obj, start, limit, out totalRowCount);
        }

        public DataSet QuerySelectByFile(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("QuerySelectByFilterDealerqa", obj, start, limit, out totalRowCount);
        }

        public int UpdateAnswer(Dealerqa obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerqaAnswer", obj);
            return cnt;
        }

        public void InsertQuestion(Dealerqa obj)
        {
            this.ExecuteInsert("InsertDealerqaQuestion", obj);
        }

        public int GetConutByStatus(Hashtable table)
        {
            DataSet ds = base.ExecuteQueryForDataSet("QuerySelectByFilterDealerqaCount", table);

            return Convert.ToInt16(ds.Tables[0].Rows[0]["num"].ToString());
        }

        public DataSet QueryDealerQAOnLogin(Hashtable table)
        {
            return base.ExecuteQueryForDataSet("QueryDealerQAOnLogin", table);
        }

        public DataSet QueryDealerQAOnLoginForDealer(Hashtable table)
        {
            return base.ExecuteQueryForDataSet("QueryDealerQAOnLoginForDealer", table);
        }

        public IList<WaitProcessTask> QueryWaitForProcessByDealer(Hashtable table)
        {
            IList<WaitProcessTask> obj = base.ExecuteQueryForList<WaitProcessTask>("GC_WaitForProcessTaskByDealer", table);

            return obj;
        }
    }
}