
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ProBuPointRatio
 * Created Time: 2016/6/6 11:01:40
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
    /// ProBuPointRatio的Dao
    /// </summary>
    public class ProBuPointRatioDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ProBuPointRatioDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ProBuPointRatio GetObject(int objKey)
        {
            ProBuPointRatio obj = this.ExecuteQueryForObject<ProBuPointRatio>("SelectProBuPointRatio", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ProBuPointRatio> GetAll()
        {
            IList<ProBuPointRatio> list = this.ExecuteQueryForList<ProBuPointRatio>("SelectProBuPointRatio", null);          
            return list;
        }


        /// <summary>
        /// 查询ProBuPointRatio
        /// </summary>
        /// <returns>返回ProBuPointRatio集合</returns>
		public IList<ProBuPointRatio> SelectByFilter(ProBuPointRatio obj)
		{ 
			IList<ProBuPointRatio> list = this.ExecuteQueryForList<ProBuPointRatio>("SelectByFilterProBuPointRatio", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ProBuPointRatio obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateProBuPointRatio", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(int objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProBuPointRatio", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ProBuPointRatio obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteProBuPointRatio", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ProBuPointRatio obj)
        {
            this.ExecuteInsert("InsertProBuPointRatio", obj);           
        }

        public DataSet Query_ProPointRatio(Hashtable obj, int start, int limit, out int totalCount)
        {

            DataSet ds = this.ExecuteQueryForDataSet("QueryPointRatioByBuDmaId", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet SelectDealerByproductline(string Id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerByproductline", Id);
            return ds;
        }
    }
}