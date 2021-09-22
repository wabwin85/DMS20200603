
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : AopicDealerHospitalTemp
 * Created Time: 2014/3/3 12:58:21
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
    /// AopicDealerHospitalTemp的Dao
    /// </summary>
    public class AopicDealerHospitalTempDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public AopicDealerHospitalTempDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AopicDealerHospitalTemp GetObject(Guid objKey)
        {
            AopicDealerHospitalTemp obj = this.ExecuteQueryForObject<AopicDealerHospitalTemp>("SelectAopicDealerHospitalTemp", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<AopicDealerHospitalTemp> GetAll()
        {
            IList<AopicDealerHospitalTemp> list = this.ExecuteQueryForList<AopicDealerHospitalTemp>("SelectAopicDealerHospitalTemp", null);
            return list;
        }


        /// <summary>
        /// 查询AopicDealerHospitalTemp
        /// </summary>
        /// <returns>返回AopicDealerHospitalTemp集合</returns>
        public IList<AopicDealerHospitalTemp> SelectByFilter(AopicDealerHospitalTemp obj)
        {
            IList<AopicDealerHospitalTemp> list = this.ExecuteQueryForList<AopicDealerHospitalTemp>("SelectByFilterAopicDealerHospitalTemp", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(AopicDealerHospitalTemp obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAopicDealerHospitalTemp", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAopicDealerHospitalTemp", obj);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(AopicDealerHospitalTemp obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteAopicDealerHospitalTemp", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AopicDealerHospitalTemp obj)
        {
            this.ExecuteInsert("InsertAopicDealerHospitalTemp", obj);
        }

        public DataSet GetHospitalYearAOPICAll(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopICDealerHospitalTempByQuery", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetYearAOPHospitalAllForIC(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopICDealerHospitalTempByQuery", obj);
            return ds;
        }

        public DataSet SetAOPHospitalForICInitialValue(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SetAOPHospitalForICInitialValue", obj);
            return ds;
        }

        public DataSet GetICAopHospitalByContractId(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectICAopHospitalByContractId", obj);
            return ds;
        }

        public DataSet GetICAopDealersHospitalByQuery(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectICAopDealersHospitalByQuery", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetICAopDealersHospitalUnitByQuery(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectICAopDealersHospitalUnitByQuery", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetAopProductHospitalAmount(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopProductHospitalAmount", obj);
            return ds;
        }

        public DataSet QueryHospitalProduct(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProduct", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet QueryHospitalProduct(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProduct", obj);
            return ds;
        }

        public DataSet QueryHospitalProductAOP(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAOP", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet QueryHospitalProductAOPAmendment(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAOPAmendment", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet QueryHospitalProductAOPAmendment(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAOPAmendment", obj);
            return ds;
        }

        public DataSet QueryHospitalProductAOP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAOP", obj);
            return ds;
        }

        public DataSet ExportHospitalProductAOP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportHospitalProductAOP", obj);
            return ds;
        }

        public DataSet QueryHospitalProductByDealerTotleAOP(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductByDealerTotleAOP", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet QueryHospitalProductByDealerTotleAOP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductByDealerTotleAOP", obj);
            return ds;
        }

        public DataSet QueryHospitalProductByDealerTotleAOP2(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductByDealerTotleAOP2", obj);
            return ds;
        }

        public DataSet GetHospitalProductMapping(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductMapping", obj);
            return ds;
        }

        public DataSet MaintainDealerHospitalProductAOP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("MaintainDealerHospitalProductAOP", obj);
            return ds;
        }

        public DataSet GetFormalAopHospitalProduct(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFormalAopHospitalProduct", obj);
            return ds;
        }
        public DataSet GetFormalAopHospitalProduct(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFormalAopHospitalProduct", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetFormalAopHospitalProductUnit(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFormalAopHospitalProductUnit", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet CheckHospitalProductMapping(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckHospitalProductMapping", obj);
            return ds;
        }

        public object SynchronousHospitalProductOrNextMapping(Hashtable obj)
        {
            return this.ExecuteQueryForDataSet("SynchronousHospitalOrNextProductMapping", obj);
        }

    }
}