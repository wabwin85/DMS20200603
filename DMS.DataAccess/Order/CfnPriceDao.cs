
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : CfnPrice
 * Created Time: 2011-2-10 12:04:50
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
    /// CfnPrice的Dao
    /// </summary>
    public class CfnPriceDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public CfnPriceDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public CfnPrice GetObject(Guid objKey)
        {
            //TODO,该方法无调用，调用时添加分子公司和品牌
            CfnPrice obj = this.ExecuteQueryForObject<CfnPrice>("SelectCfnPrice", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<CfnPrice> GetAll()
        {
            //TODO,该方法无调用，调用时添加分子公司和品牌
            IList<CfnPrice> list = this.ExecuteQueryForList<CfnPrice>("SelectCfnPrice", null);          
            return list;
        }


        /// <summary>
        /// 查询CfnPrice
        /// </summary>
        /// <returns>返回CfnPrice集合</returns>
		public IList<CfnPrice> SelectByFilter(CfnPrice obj)
		{ 
			IList<CfnPrice> list = this.ExecuteQueryForList<CfnPrice>("SelectByFilterCfnPrice", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(CfnPrice obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateCfnPrice", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteCfnPrice", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(CfnPrice obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteCfnPrice", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(CfnPrice obj)
        {
            this.ExecuteInsert("InsertCfnPrice", obj);           
        }

        public DataSet QueryDealerPrice(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerPrice", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet ExportDealerPrice(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportDealerPrice", obj);
            return ds;
        }
        public DataSet QueryDealerPrice2(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerPriceQuery", obj, start, limit, out totalRowCount,true);
            return ds;
        }

        public DataSet ExportDealerPriceQuery(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportDealerPriceQuery", obj);
            return ds;
        }
    }
}