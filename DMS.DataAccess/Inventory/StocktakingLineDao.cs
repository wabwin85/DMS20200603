
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : StocktakingLine
 * Created Time: 2010-6-3 11:32:13
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
    /// StocktakingLine的Dao
    /// </summary>
    public class StocktakingLineDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public StocktakingLineDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public StocktakingLine GetObject(Guid objKey)
        {
            StocktakingLine obj = this.ExecuteQueryForObject<StocktakingLine>("SelectStocktakingLine", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<StocktakingLine> GetAll()
        {
            IList<StocktakingLine> list = this.ExecuteQueryForList<StocktakingLine>("SelectStocktakingLine", null);          
            return list;
        }


        /// <summary>
        /// 查询StocktakingLine
        /// </summary>
        /// <returns>返回StocktakingLine集合</returns>
		public IList<StocktakingLine> SelectByFilter(StocktakingLine obj)
		{ 
			IList<StocktakingLine> list = this.ExecuteQueryForList<StocktakingLine>("SelectByFilterStocktakingLine",obj);          
            return list;
		}

        public IList<StocktakingLine> SelectByFilter(Guid Id)
        {
            IList<StocktakingLine> list = this.ExecuteQueryForList<StocktakingLine>("SelectByFilterStocktakingLineBySthId", Id);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(StocktakingLine obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateStocktakingLine", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteStocktakingLine", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(StocktakingLine obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteStocktakingLine", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(StocktakingLine obj)
        {
            this.ExecuteInsert("InsertStocktakingLine", obj);           
        }

        //新增盘点单时批量插入库存数据
        public object InsertAddLineInfoByActualInv(Hashtable param)
        {
            return this.ExecuteInsert("InsertAddLineInfoByActualInv", param);
        }

        //根据Lot表Id，更新Line表中某一个产品的数量
        public int UpdateLineQuantityBySltId(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateLineQuantityBySltId", param);
            return cnt;
        }

        //获取盘点单中指定产品的信息
        public IList<StocktakingLine> SelectStocktakingLineByPmaId(Hashtable param)
        {
            IList<StocktakingLine> list = this.ExecuteQueryForList<StocktakingLine>("SelectStocktakingLineByPmaId", param);
            return list;
        }

        //根据Line表Id，更新Line表中某一个产品的数量
        public int UpdateLineQuantityByStlId(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateLineQuantityByStlId", param);
            return cnt;
        }

        //根据Header表Id，更新Line表中某一个产品的数量
        public int UpdateLineQuantityBySthId(Hashtable param)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateLineQuantityBySthId", param);
            return cnt;
        }
    }

}