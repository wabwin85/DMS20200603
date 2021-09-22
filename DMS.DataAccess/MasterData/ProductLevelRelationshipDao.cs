
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ProductLevelRelationship
 * Created Time: 2013/9/29 17:14:30
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
    /// ProductLevelRelationship的Dao
    /// </summary>
    public class ProductLevelRelationshipDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ProductLevelRelationshipDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ProductLevelRelationship GetObject(Guid objKey)
        {
            ProductLevelRelationship obj = this.ExecuteQueryForObject<ProductLevelRelationship>("SelectProductLevelRelationship", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ProductLevelRelationship> GetAll()
        {
            IList<ProductLevelRelationship> list = this.ExecuteQueryForList<ProductLevelRelationship>("SelectProductLevelRelationship", null);          
            return list;
        }


        /// <summary>
        /// 查询ProductLevelRelationship
        /// </summary>
        /// <returns>返回ProductLevelRelationship集合</returns>
		public IList<ProductLevelRelationship> SelectByFilter(ProductLevelRelationship obj)
		{ 
			IList<ProductLevelRelationship> list = this.ExecuteQueryForList<ProductLevelRelationship>("SelectByFilterProductLevelRelationship", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ProductLevelRelationship obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateProductLevelRelationship", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProductLevelRelationship", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ProductLevelRelationship obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteProductLevelRelationship", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ProductLevelRelationship obj)
        {
            this.ExecuteInsert("InsertProductLevelRelationship", obj);           
        }

        /// <summary>
        /// 获取产品层级
        /// </summary>
        /// <returns>产品层级</returns>
        public DataSet GetProductlevelRelation()
        {
            return this.ExecuteQueryForDataSet("SelectProductlevelRelation", null);
        }

    }
}