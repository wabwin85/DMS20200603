
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : AopDealerTemp
 * Created Time: 2014/1/7 11:29:42
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// AopDealerTemp的Dao
    /// </summary>
    public class AopDealerTempDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public AopDealerTempDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AopDealerTemp GetObject(Guid objKey)
        {
            AopDealerTemp obj = this.ExecuteQueryForObject<AopDealerTemp>("SelectAopDealerTemp", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<AopDealerTemp> GetAll()
        {
            IList<AopDealerTemp> list = this.ExecuteQueryForList<AopDealerTemp>("SelectAopDealerTemp", null);
            return list;
        }


        /// <summary>
        /// 查询AopDealerTemp
        /// </summary>
        /// <returns>返回AopDealerTemp集合</returns>
        public IList<AopDealerTemp> SelectByFilter(AopDealerTemp obj)
        {
            IList<AopDealerTemp> list = this.ExecuteQueryForList<AopDealerTemp>("SelectByFilterAopDealerTemp", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(AopDealerTemp obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAopDealerTemp", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAopDealerTemp", obj);
            return cnt;
        }

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(AopDealerTemp obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteAopDealerTemp", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AopDealerTemp obj)
        {
            this.ExecuteInsert("InsertAopDealerTemp", obj);
        }

        public DataSet GetYearAOPAll(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerTempByQuery", obj);
            return ds;
        }

        public DataSet GetAopDealerUnionHospitalQuery(Hashtable obj) 
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerUnionHospitalQuery", obj);
            return ds;
        }

        public DataSet GetAopDealerUnionHospitalHistoryQuery(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerUnionHospitalHistoryQuery", obj);
            return ds;
        }

        public DataSet GetAopDealerUnionHospitalUnitHistoryQuery(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerUnionHospitalUnitHistoryQuery", obj);
            return ds;
        }

        public DataSet GetAOPDealerTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerTempMap", obj);
            return ds;
        }

        public DataSet GetAopDealersByHosTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealersByHosTemp", obj);
            return ds;
        }

        public DataSet GetYearAOPAll(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerTempByQuery", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet ExportDealerAOP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportDealerAOPTempByQuery", obj);
            return ds;
        }

        public DataSet GetAopDealersByQueryByContractId(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealersByQueryByContractId", obj);
            return ds;
        }

        public DataSet GetFormalAopDealer(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFormalAopDealer", obj);
            return ds;
        }
        public DataSet GetFormalAopDealer(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFormalAopDealer", obj, start, limit, out totalCount);
            return ds;
        }


        public void InsertFromICDate(Hashtable obj)
        {
            this.ExecuteInsert("InsertAopDealerTempForICDate", obj);
        }

        public void InsertAopDealerTempByHospitalProduct(Hashtable obj)
        {
            this.ExecuteInsert("InsertAopDealerTempByHospitalProduct", obj);
        }

        public void InsertAopDealerTempByHospitalProductAmount(Hashtable obj)
        {
            this.ExecuteInsert("InsertAopDealerTempByHospitalProductAmount", obj);
        }

        public void InsertSynchronousHospitalAOP(Hashtable obj) 
        {
            this.ExecuteInsert("InsertSynchronousHospitalAOP", obj);
        }

        public DataSet CheckFormalDealerAOPTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckFormalDealerAOPTemp", obj);
            return ds;
        }

        public void SynchronousFormalDealerAOPTemp(Hashtable obj)
        {
            this.ExecuteQueryForDataSet("SynchronousFormalDealerAOPTemp", obj);
        }

        public DataSet GetAopDealerContrastLastYear(Guid obj,string SubCompanyId, string BrandId)
        {

            Hashtable ht = new Hashtable();
            ht.Add("value", obj);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerContrastLastYear", ht);
            return ds;
        }

        public void MerageDealerAopTemp(Hashtable obj)
        {
            this.ExecuteInsert("MerageDealerAopTemp", obj);
        }
    }
}
