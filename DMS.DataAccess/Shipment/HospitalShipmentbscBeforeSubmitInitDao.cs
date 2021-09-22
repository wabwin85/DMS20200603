
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : HospitalShipmentbscBeforeSubmitInit
 * Created Time: 2018/6/25 9:33:11
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
    /// HospitalShipmentbscBeforeSubmitInit的Dao
    /// </summary>
    public class HospitalShipmentbscBeforeSubmitInitDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public HospitalShipmentbscBeforeSubmitInitDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public HospitalShipmentbscBeforeSubmitInit GetObject(Guid objKey)
        {
            HospitalShipmentbscBeforeSubmitInit obj = this.ExecuteQueryForObject<HospitalShipmentbscBeforeSubmitInit>("SelectHospitalShipmentbscBeforeSubmitInit", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<HospitalShipmentbscBeforeSubmitInit> GetAll()
        {
            IList<HospitalShipmentbscBeforeSubmitInit> list = this.ExecuteQueryForList<HospitalShipmentbscBeforeSubmitInit>("SelectHospitalShipmentbscBeforeSubmitInit", null);
            return list;
        }


        /// <summary>
        /// 查询HospitalShipmentbscBeforeSubmitInit
        /// </summary>
        /// <returns>返回HospitalShipmentbscBeforeSubmitInit集合</returns>
		public IList<HospitalShipmentbscBeforeSubmitInit> SelectByFilter(HospitalShipmentbscBeforeSubmitInit obj)
        {
            IList<HospitalShipmentbscBeforeSubmitInit> list = this.ExecuteQueryForList<HospitalShipmentbscBeforeSubmitInit>("SelectByFilterHospitalShipmentbscBeforeSubmitInit", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(HospitalShipmentbscBeforeSubmitInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateHospitalShipmentbscBeforeSubmitInit", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("DeleteHospitalShipmentbscBeforeSubmitInit", objKey);
            return cnt;
        }




        /// <summary>
        /// 逻辑删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int FakeDelete(HospitalShipmentbscBeforeSubmitInit obj)
        {
            int cnt = (int)this.ExecuteUpdate("FakeDeleteHospitalShipmentbscBeforeSubmitInit", obj);
            return cnt;
        }

        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(HospitalShipmentbscBeforeSubmitInit obj)
        {
            this.ExecuteInsert("InsertHospitalShipmentbscBeforeSubmitInit", obj);
        }


        public DataSet GetObjectByCondition(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalShipmentbscBeforeSubmitInitByCondition", table);
            return ds;
        }

        public DataSet GetObjectSumInfoByCondition(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalShipmentSumBeforeSubmitInitByCondition", table);
            return ds;
        }

        public DataSet GetObjectForExportByCondition(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalShipmentbscBeforeSubmitInitForExport", table);
            return ds;
        }
        

    }
}