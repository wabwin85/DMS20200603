
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ProductClassification
 * Created Time: 2014/8/6 16:15:40
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
    /// ProductClassification的Dao
    /// </summary>
    public class ProductClassificationDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public ProductClassificationDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ProductClassification GetObject(Guid objKey)
        {
            ProductClassification obj = this.ExecuteQueryForObject<ProductClassification>("SelectProductClassification", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ProductClassification> GetAll()
        {
            IList<ProductClassification> list = this.ExecuteQueryForList<ProductClassification>("SelectProductClassification", null);          
            return list;
        }


        /// <summary>
        /// 查询ProductClassification
        /// </summary>
        /// <returns>返回ProductClassification集合</returns>
		public IList<ProductClassification> SelectByFilter(ProductClassification obj)
		{ 
			IList<ProductClassification> list = this.ExecuteQueryForList<ProductClassification>("SelectByFilterProductClassification", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(ProductClassification obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateProductClassification", obj);            
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProductClassification", objKey);            
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(ProductClassification obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteProductClassification", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(ProductClassification obj)
        {
            this.ExecuteInsert("InsertProductClassification", obj);           
        }

        public IList<ProductClassification> GetProductClassificationByProductLineId(Hashtable obj)
        {
            IList<ProductClassification> list = this.ExecuteQueryForList<ProductClassification>("SelectProductClassificationByProductLineId", obj);
            return list;
        }

        public DataSet GetContractProductClassification(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectContractProductClassification", obj);
            return ds;
        }
        public DataSet GetContractProductClassificationPrice(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectContractProductClassificationPrice", obj);
            return ds;
        }

        public DataSet GetProductClassificationPrice(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductClassificationPrice", obj);
            return ds;
        }

        public int DeleteHospitalProductMapping(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("DeleteHospitalProductMapping", obj);
            return cnt;
        }

        public void SubmintDealerHospitalProductMapping(Hashtable obj)
        {
            this.ExecuteInsert("SubmintDealerHospitalProductMapping", obj);      
        }

        public DataSet CheckAuthorProductPrice(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckAuthorProductPrice", obj);
            return ds;
        }

        public int UpdateNullHospitalProductPrice(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateNullHospitalProductPrice", obj);
            return cnt;
        }

        public int SubmintHospitalProductPrice(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("SubmintHospitalProductPrice", obj);
            return cnt;
        }
    }
}