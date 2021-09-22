
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerProductPriceHistory
 * Created Time: 2013/7/18 11:30:16
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
    /// DealerProductPriceHistory的Dao
    /// </summary>
    public class DealerProductPriceHistoryDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerProductPriceHistoryDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerProductPriceHistory GetObject(Guid objKey)
        {
            DealerProductPriceHistory obj = this.ExecuteQueryForObject<DealerProductPriceHistory>("SelectDealerProductPriceHistory", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerProductPriceHistory> GetAll()
        {
            IList<DealerProductPriceHistory> list = this.ExecuteQueryForList<DealerProductPriceHistory>("SelectDealerProductPriceHistory", null);          
            return list;
        }


        /// <summary>
        /// 查询DealerProductPriceHistory
        /// </summary>
        /// <returns>返回DealerProductPriceHistory集合</returns>
		public IList<DealerProductPriceHistory> SelectByFilter(DealerProductPriceHistory obj)
		{ 
			IList<DealerProductPriceHistory> list = this.ExecuteQueryForList<DealerProductPriceHistory>("SelectByFilterDealerProductPriceHistory", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerProductPriceHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerProductPriceHistory", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerProductPriceHistory", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(DealerProductPriceHistory obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteDealerProductPriceHistory", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerProductPriceHistory obj)
        {
            this.ExecuteInsert("InsertDealerProductPriceHistory", obj);           
        }

        public DealerProductPriceHistory SelectByFilterPMADMA(Hashtable table)
        {
            DataSet _dealer = null;
            string _dealerType = "";
            if (table["DmaId"] != null)
            {
                _dealer = this.ExecuteQueryForDataSet("CheckDealerTypeById", table["DmaId"].ToString());
            }
            if (_dealer != null)
            {
                _dealerType = _dealer.Tables[0].Rows[0]["Taxpayer"].ToString();
            }

            DealerProductPriceHistory obj = new DealerProductPriceHistory();

            if (_dealerType == "直销医院")
            {
                obj = this.ExecuteQueryForObject<DealerProductPriceHistory>("SelectByFilterPMADMATaxpayer", table);
            }
            else
            {
                obj = this.ExecuteQueryForObject<DealerProductPriceHistory>("SelectByFilterPMADMA", table);
            }
            return obj;
        }

        //Added By Song Yuqi Begin
        public DealerProductPriceHistory SelectByFilterPmaDmaLtm(Hashtable table)
        {
            DealerProductPriceHistory obj = this.ExecuteQueryForObject<DealerProductPriceHistory>("SelectByFilterPmaDmaLtm", table);
            return obj;
        }
        //Added By Song Yuqi End
    }
}