
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.Model 
 * ClassName   : AOPHospitalReference
 * Created Time: 2010-3-22 15:35:36
 *
 ****** Copyright (C) 2009/2010 - GrapeCity*****
 *
***********************************************/

using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using System.Data;
using DMS.Model;

namespace DMS.DataAccess
{
    /// <summary>
    /// AOPHospitalReference的Dao
    /// </summary>
    public class AOPHospitalReferenceDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public AOPHospitalReferenceDao()
            : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AOPHospitalReference GetObject(Guid objKey)
        {
            AOPHospitalReference obj = this.ExecuteQueryForObject<AOPHospitalReference>("SelectAOPHospitalReference", objKey);
            return obj;
        }


        /// <summary>
        /// 查询AOPHospitalReference
        /// </summary>
        /// <returns>返回AOPHospitalReference集合</returns>
        public IList<AOPHospitalReference> SelectByFilter(AOPHospitalReference obj)
        {
            IList<AOPHospitalReference> list = this.ExecuteQueryForList<AOPHospitalReference>("SelectByFilterAOPHospitalReference", obj);
            return list;
        }


        public DataSet GetAOPHospitalReferencesByFiller(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAOPHospitalReferencesByFiller", obj, start, limit, out totalCount);
            return ds;
        }


        ///// <summary>
        ///// 更新实体
        ///// </summary>
        ///// <param name="obj">实体</param>
        ///// <returns>更新数目</returns>
        //public int Update(AOPHospitalReference obj)
        //{
        //    int cnt = (int)this.ExecuteUpdate("UpdateAOPHospitalReference", obj);
        //    return cnt;
        //}


        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int Delete(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAOPHospitalReference", obj);
            return cnt;
        }
        /// <summary>
        /// 插入实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>主键</returns>
        public void Insert(AOPHospitalReference obj)
        {
            this.ExecuteInsert("InsertAOPHospitalReference", obj);
        }
        public void BatchInsert(IList<AOPHospitalReferenceImport> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("AOPHRI_ID", typeof(Guid));
            dt.Columns.Add("AOPHRI_SubCompanyId", typeof(Guid));
            dt.Columns.Add("AOPHRI_SubCompanyName");
            dt.Columns.Add("AOPHRI_BrandName");
            dt.Columns.Add("AOPHRI_BrandId", typeof(Guid));
            dt.Columns.Add("AOPHRI_ProductLineName");
            dt.Columns.Add("AOPHRI_Year");
            dt.Columns.Add("AOPHRI_HospitalName");
            dt.Columns.Add("AOPHRI_ProductLine_BUM_ID", typeof(Guid));
            dt.Columns.Add("AOPHRI_HospitalNbr");
            dt.Columns.Add("AOPHRI_Hospital_ID", typeof(Guid));
            dt.Columns.Add("AOPHRI_January");
            dt.Columns.Add("AOPHRI_February");
            dt.Columns.Add("AOPHRI_March");
            dt.Columns.Add("AOPHRI_April");
            dt.Columns.Add("AOPHRI_May");
            dt.Columns.Add("AOPHRI_June");
            dt.Columns.Add("AOPHRI_July");
            dt.Columns.Add("AOPHRI_August");
            dt.Columns.Add("AOPHRI_September");
            dt.Columns.Add("AOPHRI_October");
            dt.Columns.Add("AOPHRI_November");
            dt.Columns.Add("AOPHRI_December");
            dt.Columns.Add("AOPHRI_PCTName");
            dt.Columns.Add("AOPHRI_PCT_ID", typeof(Guid));
            dt.Columns.Add("AOPHRI_ErrMassage");
            dt.Columns.Add("AOPHRI_Update_User_ID", typeof(Guid));
            dt.Columns.Add("AOPHRI_Update_Date");           
            dt.Columns.Add("AOPHRI_DivisionID");
            dt.Columns.Add("AOPHRI_IsDelete");
            foreach (AOPHospitalReferenceImport data in list)
            {
                DataRow row = dt.NewRow();
                row["AOPHRI_ID"] = data.Id;
                row["AOPHRI_SubCompanyName"] = data.SubCompanyName;
                row["AOPHRI_BrandName"] = data.BrandName;
                row["AOPHRI_ProductLineName"] = data.ProductLineName;
                row["AOPHRI_Year"] = data.Year;
                row["AOPHRI_HospitalName"] = data.HospitalName;
                row["AOPHRI_HospitalNbr"] = data.HospitalNbr;
                row["AOPHRI_PCTName"] = data.PCTName;
                row["AOPHRI_January"] = data.January;
                row["AOPHRI_February"] = data.February;
                row["AOPHRI_March"] = data.March;
                row["AOPHRI_April"] = data.April;
                row["AOPHRI_May"] = data.May;
                row["AOPHRI_June"] = data.June;
                row["AOPHRI_July"] = data.July;
                row["AOPHRI_August"] = data.August;
                row["AOPHRI_September"] = data.September;
                row["AOPHRI_October"] = data.October;
                row["AOPHRI_November"] = data.November;
                row["AOPHRI_December"] = data.December;
                row["AOPHRI_ErrMassage"] = data.ErrMassage;
                row["AOPHRI_Update_User_ID"] = data.UpdateUserId;
                row["AOPHRI_Update_Date"] = data.UpdateDate;
                row["AOPHRI_IsDelete"] = data.IsDelete;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("AOPHospitalReferenceImport", dt);
        }
        public DataSet GetAOPHospitalReferencesImportErrorData(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAOPHospitalReferencesImportErrorData", obj, start, limit, out totalCount);
            return ds;
        }
        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="obj">实体</param>
        /// <returns>删除数目</returns>
        public int DeleteAOPHospitalReferencesImportByUser(String obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAOPHospitalReferencesImportByUser", obj);
            return cnt;
        }
        /// <summary>
        /// 调用存储过程
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        public string InitializeAopHospitalReferenceImport(string importType, Guid UserId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("UserId", UserId);
            ht.Add("ImportType", importType);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_AOPHospitalReferenceImportInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }
        public void GenerateHospitalMarketProperty()
        {
            this.ExecuteInsert("USP_GenerateHospitalMarketProperty", null);
        }
    }
}