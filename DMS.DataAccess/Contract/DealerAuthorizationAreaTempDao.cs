
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : BPM.DataAccess 
 * ClassName   : DealerAuthorizationAreaTemp
 * Created Time: 2015-5-20 16:12:48
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
    /// DealerAuthorizationAreaTemp的Dao
    /// </summary>
    public class DealerAuthorizationAreaTempDao : BaseSqlMapDao
    {
	
        /// <summary>
        /// 默认构造函数
        /// </summary>
		public DealerAuthorizationAreaTempDao(): base()
        {
        }

        public DataSet QueryAuthorizationAreaTempList(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorizationAreaTempList", obj);
            return ds;
        }

        public DataSet SysFormalAuthorizationAreaToTemp(Hashtable obj)
        {
            DataSet ds =  this.ExecuteQueryForDataSet("SysFormalAuthorizationAreaToTemp", obj);
            return ds;
        }

        public DataSet ModifyPartsAuthorizationAreaTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ModifyPartsAuthorizationAreaTemp", obj);
            return ds;
        }

        public DataSet QueryPartsAuthorizedAreaTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPartsAuthorizedAreaTemp", obj);
            return ds;
        }

        public void SubmintAreaTemp(Hashtable obj)
        {
            this.ExecuteInsert("SubmintAreaTemp", obj);
        }
       
        public int DeleteAreaTemp(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAreaTemp", obj);
            return cnt;
        }

        public DataSet GetPartAreaExcHospitalTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPartAreaExcHospitalTemp", obj);
            return ds;
        }

        public object RemoveAreaHospitalTemp(string contractId, Guid hosId)
        {
            Hashtable table = new Hashtable();
            table.Add("ContractId", contractId);
            table.Add("HosId", hosId);
            return base.ExecuteDelete("RemoveAreaHospitalTemp", table);
        }

        public DataSet GetProvincesForArea(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProvincesForArea", obj);
            return ds;
        }

        public DataSet GetProvincesForAreaSelected(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProvincesForAreaSelected", obj);
            return ds;
        }

        public DataSet GetProductForAreaSelected(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductForAreaSelected", obj);
            return ds;
        }

        public object AttachHospitalToAuthorizationArea(Guid datId, Guid hosId, string hosRemark)
        {
            Hashtable table = new Hashtable();
            table.Add("DatId", datId);
            table.Add("HosId", hosId);
            table.Add("Remark", hosRemark);
            return base.ExecuteInsert("AttachHospitalToAuthorizationAreaTemp", table);
        }

        public DataSet GetProvincesForAreaSelectedOld(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProvincesForAreaSelectedOld", obj);
            return ds;
        }

        public DataSet GetProvincesForAreaSelectedFormal(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProvincesForAreaSelectedFormal", obj);
            return ds;
        }

        public DataSet GetPartAreaExcHospitalOld(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPartAreaExcHospitalOld", obj);
            return ds;
        }

        public DataSet GetPartAreaExcHospitalFormal(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPartAreaExcHospitalFormal", obj);
            return ds;
        }
        public object DeleteHospitByDaidHspit(string Daid, Guid hosId)
        {
            Hashtable table = new Hashtable();
            table.Add("DaID", Daid);
            table.Add("HosId", hosId);
            return base.ExecuteDelete("DeleteHospitByDaidHspit", table);
        }
    }
}