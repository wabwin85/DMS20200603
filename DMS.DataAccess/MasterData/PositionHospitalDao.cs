
/**********************************************
 * NameSpace   : DMS.DataAccess 
 * ClassName   : DealerAuthorization
 * Created Time: 2009-7-17 9:34:44
 * Author      : Donson
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using Grapecity.DataAccess;
using System.Data;
using System.Data.Common;

namespace DMS.DataAccess
{
    /// <summary>
    /// DealerAuthorization的Dao
    /// </summary>
    public class PositionHospitalDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数

        /// </summary>
        public PositionHospitalDao()
            : base()
        {
        }

        public DataSet SelectOrgsForPositionHospital(string attributeId)
        {
            Hashtable table = new Hashtable();
            table.Add("attributeId", string.IsNullOrEmpty(attributeId) ? null : attributeId);

            return this.ExecuteQueryForDataSet("PositionHospital.SelectOrgsForPositionHospital", table);
        }
        public DataSet SelectHospitalPosition_ValidByFilter(string positionID, int start, int limit, out int rowCount)
        {
            Hashtable table = new Hashtable();
            table.Add("PositionID", string.IsNullOrEmpty(positionID) ? null : positionID);

            return this.ExecuteQueryForDataSet("PositionHospital.SelectHospitalPosition_Valid", table, start, limit,
                out rowCount, true);
        }

        public void InsertHospitalPosition(Hashtable obj)
        {
            this.ExecuteInsert("PositionHospital.InsertHospitalPosition", obj);
        }

        public void DeleteHospitalPosition(string id)
        {
            int cnt = (int)this.ExecuteDelete("PositionHospital.DeleteHospitalPosition", id);
        }

        public int UpdateHospitalPosition(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("PositionHospital.UpdateHospitalPosition", obj);
            return cnt;
        }
        public DataSet ExportHospitalPosition(string positionID)
        {
            Hashtable table = new Hashtable();
            table.Add("PositionID", string.IsNullOrEmpty(positionID) ? null : positionID);
            return this.ExecuteQueryForDataSet("ExportHospitalPosition", table);
        }
    }
}