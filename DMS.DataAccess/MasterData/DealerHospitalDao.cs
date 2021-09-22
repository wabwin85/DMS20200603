
/**********************************************
 *
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerHospital
 * Created Time: 2009-7-17 9:34:45
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// DealerHospital的Dao
    /// </summary>
    public class DealerHospitalDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数

        /// </summary>
        public DealerHospitalDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public DealerHospital GetObject(Guid? objKey)
        {
            DealerHospital obj = this.ExecuteQueryForObject<DealerHospital>("SelectDealerHospital", objKey);
            return obj;
        }


        /// <summary>
        /// 得到所实体
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<DealerHospital> GetAll()
        {
            IList<DealerHospital> list = this.ExecuteQueryForList<DealerHospital>("SelectDealerHospital", null);
            return list;
        }


        /// <summary>
        /// 查询DealerHospital
        /// </summary>
        /// <returns>返回DealerHospital集合</returns>
        public IList<DealerHospital> SelectByFilter(DealerHospital obj)
        {
            IList<DealerHospital> list = this.ExecuteQueryForList<DealerHospital>("SelectByFilterDealerHospital", obj);
            return list;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>更新数目</returns>
        public int Update(DealerHospital obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateDealerHospital", obj);
            return cnt;
        }



        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(DealerHospital obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerHospital", obj);
            return cnt;
        }



        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(DealerHospital obj)
        {
            this.ExecuteInsert("InsertDealerHospital", obj);
        }


        //Edited By Song Yuqi On 2016-06-21
        public object AttachHospitalToAuthorization(Guid datId, Guid hosId, string hosRemark, DateTime startDate, DateTime endDate)
        {
            Hashtable table = new Hashtable();
            table.Add("DatId", datId);
            table.Add("HosId", hosId);
            table.Add("Remark", hosRemark);
            table.Add("StartDate", startDate);
            table.Add("EndDate", endDate);
            return base.ExecuteInsert("AttachHospitalToAuthorization", table);
        }

        //Edited By Song Yuqi On 2016-06-21
        public int AttachHospitalToAuthorization(Guid datId, string hosProvince, string hosCity, string hosDistrict, Guid productLineId, string hosRemark, DateTime? startDate, DateTime? endDate)
        {
            Hashtable table = new Hashtable();
            table.Add("DatId", datId);
            table.Add("HosCity", hosCity);
            table.Add("HosProvince", hosProvince);
            table.Add("HosDistrict", hosDistrict);
            table.Add("ProductLineId", productLineId);
            table.Add("Remark", hosRemark);   //备注填写科室

            if (startDate.HasValue)
            {
                table.Add("StartDate", startDate.Value);
            }
            if (endDate.HasValue)
            {
                table.Add("EndDate", endDate.Value);
            }

            return base.ExecuteUpdate("AttachHospitalToAuthorizationByParts", table);
        }

        public object DetachHospitalFromAuthorization(Guid datId, Guid hosId)
        {
            Hashtable table = new Hashtable();
            table.Add("DatId", datId);
            table.Add("HosId", hosId);
            return base.ExecuteDelete("DetachHospitalFromAuthorization", table);
        }

        //Edited By Song Yuqi On 2016-06-21
        public int AttachHospitalAuthFromOtherAuth(Guid datId, Guid fromDatId, DateTime startDate, DateTime endDate)
        {
            Hashtable table = new Hashtable();
            table.Add("DatId", datId);
            table.Add("FromDatID", fromDatId);
            table.Add("StartDate", startDate);
            table.Add("EndDate", endDate);

            return base.ExecuteUpdate("AttachHospitalAuthFromOtherAuth", table);
        }



    }
}