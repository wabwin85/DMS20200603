
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : AopDealerHospitalTemp
 * Created Time: 2014/1/7 15:44:21
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
    /// AopDealerHospitalTemp的Dao
    /// </summary>
    public class AopDealerHospitalTempDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public AopDealerHospitalTempDao(): base()
        {
        }
		
        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AopDealerHospitalTemp GetObject(Guid objKey)
        {
            AopDealerHospitalTemp obj = this.ExecuteQueryForObject<AopDealerHospitalTemp>("SelectAopDealerHospitalTemp", objKey);           
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<AopDealerHospitalTemp> GetAll()
        {
            IList<AopDealerHospitalTemp> list = this.ExecuteQueryForList<AopDealerHospitalTemp>("SelectAopDealerHospitalTemp", null);          
            return list;
        }


        /// <summary>
        /// 查询AopDealerHospitalTemp
        /// </summary>
        /// <returns>返回AopDealerHospitalTemp集合</returns>
		public IList<AopDealerHospitalTemp> SelectByFilter(AopDealerHospitalTemp obj)
		{ 
			IList<AopDealerHospitalTemp> list = this.ExecuteQueryForList<AopDealerHospitalTemp>("SelectByFilterAopDealerHospitalTemp", obj);          
            return list;
		}

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(AopDealerHospitalTemp obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAopDealerHospitalTemp", obj);            
            return cnt;
        }



        public int Delete(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAopDealerHospitalTemp", obj);
            return cnt;
        }


		

        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(AopDealerHospitalTemp obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteAopDealerHospitalTemp", obj);            
            return cnt;
        }
	
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AopDealerHospitalTemp obj)
        {
            this.ExecuteInsert("InsertAopDealerHospitalTemp", obj);           
        }


        public DataSet GetHospitalYearAOPAll(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerHospitalTempByQuery", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetAopDealersHospitalByQuery2(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerHospitalTempByQuery2", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetAopDealersHospitalTempByQuery(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealersHospitalTempByQuery", obj);
            return ds;
        }

        public DataSet GetYearAOPHospitalAll(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerHospitalTempByQuery", obj);
            return ds;
        }

        public DataSet GetAopDealersHospitalByQueryByContractId(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealersHospitalByQueryByContractId", obj);
            return ds;
        }

        public DataSet ExportAopDealersHospitalByQuery(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportAopDealersHospitalByQuery", obj);
            return ds;
        }

        public DataSet GetAopDealersHospitalByQueryByContractId(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealersHospitalByQueryByContractId", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet GetFormalAopHospital(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFormalAopHospital", obj);
            return ds;
        }

        public DataSet GetFormalAopHospital(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFormalAopHospital", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet CheckFormalDealerHospitalAOPTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("CheckFormalDealerHospitalAOPTemp", obj);
            return ds;
        }

        public object SynchronousFormalDealerHospitalAOPTemp(Hashtable obj)
        {
            return base.ExecuteInsert("SynchronousFormalDealerHospitalAOPTemp", obj);
        }

        public object SynchronousFormalDealerHospitalAOPTemp2(Hashtable obj)
        {
            return this.ExecuteQueryForDataSet("MaintainDealerHospitalAOP", obj);
        }
    }
}