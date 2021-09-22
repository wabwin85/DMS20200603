/**********************************************
 *
 * NameSpace   : DMS.DataAccess 
 * ClassName   : Hospital
 * Created Time: 2009-7 
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.DataAccess
{
    using DMS.Model;
    using System.Data;

    public class HospitalDao : BaseSqlMapDao
    {

        #region CRUD
        public Hospital GetHospital(Guid hosId)
        {
            return base.ExecuteQueryForObject<Hospital>("SelectHospital", hosId);
        }

        public IList<Hospital> SelectByFilter(Hospital hospital)
        {
            return base.ExecuteQueryForList<Hospital>("SelectHospitalList", hospital);
        }

        public IList<Hospital> SelectByFilter(Hospital hospital, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForList<Hospital>("SelectHospitalList", hospital, start, limit, out totalRowCount);
        }

        public DataSet SelectByFilter_DataSet(Hospital hospital, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("SelectHospitalList_DataSet", hospital, start, limit, out totalRowCount);
        }
        public object Insert(Hospital hospital)
        {
            return base.ExecuteInsert("InsertHospital", hospital);
        }

        public void InsertProductLineHospital()
        {
            base.ExecuteInsert("InsertProductLineHospital", null);
        }

        public int Update(Hospital hospital)
        {
            return base.ExecuteUpdate("UpdateHospital", hospital);
        }

        public object Delete(Guid hospitalId)
        {
            return base.ExecuteDelete("DeleteHospital", hospitalId);
        }

        public int FakeDelete(Hospital hospital)
        {
            return base.ExecuteUpdate("FakeDeleteHospital", hospital);
        }
        #endregion

        #region TSR和医院

        public IList<Hospital> SelectBySales(Hashtable table)
        {
            return base.ExecuteQueryForList<Hospital>("SelectHospitalListOfSales", table);
        }


        public IList<Hospital> SelectBySales(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForList<Hospital>("SelectHospitalListOfSales", table, start, limit, out totalRowCount);
        }

        public object AttachHospitalToSales(Guid lineId, Guid saleId, Guid hosId)
        {
            Hashtable table = new Hashtable();
            table.Add("SaleId", saleId);
            table.Add("HosId", hosId);
            table.Add("ProductLineId", lineId);

            return base.ExecuteInsert("AttachHospitalToSales", table);
        }

        public int AttachHospitalToSales(Guid saleId, string hosProvince, string hosCity, string hosDistrict, Guid productLineId)
        {
            Hashtable table = new Hashtable();
            table.Add("SaleId", saleId);
            table.Add("HosCity", hosCity);
            table.Add("HosProvince", hosProvince);
            table.Add("HosDistrict", hosDistrict);
            table.Add("ProductLineId", productLineId);

            return base.ExecuteUpdate("AttachHospitalToSalesByParts", table);
        }

        public object DetachHospitalFromSales(Guid lineId, Guid saleId, Guid hosId)
        {
            Hashtable table = new Hashtable();
            table.Add("SaleId", saleId);
            table.Add("HosId", hosId);
            table.Add("ProductLineId", lineId);

            return base.ExecuteDelete("DetachHospitalFromSales", table);
        }

        #endregion

        #region 医院授权
        public IList<Hospital> SelectByAuthorization(Hashtable table)
        {
            return base.ExecuteQueryForList<Hospital>("SelectHospitalListOfAuthorization", table);
        }


        public IList<Hospital> SelectByAuthorization(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForList<Hospital>("SelectHospitalListOfAuthorization", table, start, limit, out totalRowCount);
        }

        public DataSet SelectByAuthorizationTemp(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //return base.ExecuteQueryForList<Hospital>("SelectHospitalListOfAuthorizationTemp", table, start, limit, out totalRowCount);
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalListOfAuthorizationTemp", table, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet SelectByAuthorizationTemp(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalListOfAuthorizationTemp", table);
            return ds;
        }

        #endregion

        #region 经销商被授权的医院

        public IList<Hospital> SelectHospitalListOfDealerAuthorized(Hashtable table)
        {
            return base.ExecuteQueryForList<Hospital>("SelectHospitalListOfDealerAuthorized", table);
        }

        public IList<Hospital> SelectHospitalListOfDealerAuthorized(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForList<Hospital>("SelectHospitalListOfDealerAuthorized", table, start, limit, out totalRowCount);
        }
        #endregion

        #region 产品线与医院
        /// <summary>
        /// Selects the by product line.
        /// </summary>
        /// <param name="table">The table.</param>
        /// <returns></returns>
        public IList<Hospital> SelectByProductLine(Hashtable table)
        {
            return base.ExecuteQueryForList<Hospital>("SelectHospitalListOfProductLine", table);
        }

        /// <summary>
        /// Selects the by product line.
        /// </summary>
        /// <param name="table">The table.</param>
        /// <param name="start">The start.</param>
        /// <param name="limit">The limit.</param>
        /// <param name="totalRowCount">The total row count.</param>
        /// <returns></returns>
        public IList<Hospital> SelectByProductLine(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForList<Hospital>("SelectHospitalListOfProductLine", table, start, limit, out totalRowCount);
        }

        public DataSet SelectByProductLine_DataSet(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForDataSet("SelectHospitalListOfProductLine_DataSet", table, start, limit, out totalRowCount);
        }
        

        //DCMS区分新兴市场
        public DataSet SelectByProductLineDCMS(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectByProductLineDCMS", table, start, limit, out totalRowCount);
            return ds;
        }


        public object AttachHospitalToProductLine(Guid lineId, Guid hosId)
        {
            Hashtable table = new Hashtable();
            table.Add("ProductLineId", lineId);
            table.Add("HosId", hosId);
            return base.ExecuteInsert("AttachHospitalToProductLine", table);
        }

        public object DetachHospitalFromProductLine(Guid lineId, Guid hosId)
        {
            Hashtable table = new Hashtable();
            table.Add("ProductLineId", lineId);
            table.Add("HosId", hosId);
            return base.ExecuteDelete("DetachHospitalFromProductLine", table);
        }

        #endregion

        public IList<LpHospitalData> QueryLPHospitalInfo(string batchNbr)
        {

            IList<LpHospitalData> list = this.ExecuteQueryForList<LpHospitalData>("QueryLPHospitalInfo", batchNbr);
            return list;
        }

        #region 医院接口信息
        public DataSet GetAllHospitals()
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetAllHospitals", null);
            return ds;
        }
        
        public DataSet GetInHospitalSales(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetInHospitalSales", table);
            return ds;
        }

        #endregion


        public IList<Hospital> SelectNotDeleteHospitalByCode(String Code, Guid hosId)
        {
            Hashtable table = new Hashtable();
            table.Add("KeyAccount", Code);
            table.Add("HosId", hosId);
            return base.ExecuteQueryForList<Hospital>("SelectNotDeleteHospitalByCode", table);
        }

        public IList<Hospital> SelectNotDeleteHospitalByName(String Name, Guid hosId)
        {
            Hashtable table = new Hashtable();
            table.Add("HosName", Name);
            table.Add("HosId", hosId);
            return base.ExecuteQueryForList<Hospital>("SelectNotDeleteHospitalByName", table);
        }

        //added by huyong on 2016-02-21
        public IList<Hospital> SelectHospitalByAuthorization(Hashtable table)
        {
            IList<Hospital> list = this.ExecuteQueryForList<Hospital>("SelectHospitalByAuthorization", table);
            return list;
        }

        public DataSet SelectHospitalByAuthorization(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalByAuthorization", table, start, limit, out totalRowCount);
            return ds;
        }

        //Added	 By Song Yuqi On 2016-06-21
        public IList<Hospital> QueryAuthorizationHospitalList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            return base.ExecuteQueryForList<Hospital>("QueryAuthorizationHospitalList", table, start, limit, out totalRowCount);
        }
        public DataSet GetAuthorizationHospitalList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetAuthorizationHospitalList", table, start, limit, out totalRowCount);
            return ds;
        }
        //T1
        public DataSet GetAuthorizationHospitalListT1(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetAuthorizationHospitalListT1", table, start, limit, out totalRowCount);
            return ds;
        }


        public IList<Hashtable> SelectFilterListDealerAuth(Guid productLine, Guid dealerId, DateTime shipmentDate, String filter)
        {
            Hashtable condition = new Hashtable();
            condition.Add("ProductLine", productLine);
            condition.Add("DealerId", dealerId);
            condition.Add("ShipmentDate", shipmentDate);
            if (!string.IsNullOrEmpty(filter.Trim()))
            {
                condition.Add("Filter", filter);
            }
            return this.ExecuteQueryForList<Hashtable>("Hospital.SelectFilterListDealerAuth", condition);
        }

        public int recordsOfSameHospitalKeyAccount(string KeyAccount)
        {
            return QueryForCount("SelectHospitalKeyAccount", KeyAccount);
        }
    }
}
