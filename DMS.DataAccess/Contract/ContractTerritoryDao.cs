
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ContractTerritory
 * Created Time: 2013/12/16 15:53:45
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
    /// ContractTerritory的Dao
    /// </summary>
    public class ContractTerritoryDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public ContractTerritoryDao()
            : base()
        {
        }

        /// <summary>
        /// 根据合同ID得到实体
        /// </summary>
        /// <param name="ContractId">合同ID</param>
        /// <returns>实体</returns>
        public DataSet GetContractTerritoryByContractId(Guid ContractId,string SubCompanyId,string BrandId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("ContractId", ContractId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectTerritoryByContractId", ht);
            return ds;
        }

        public DataSet GetDistinctTerritoryByContractId(Guid ContractId, string SubCompanyId, string BrandId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("ContractId", ContractId);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectDistinctTerritoryByContractId", ht);
            return ds;
        }

        public DataSet GetExcelTerritoryByContractId(Guid ContractId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExcelTerritoryByContractId", ContractId);
            return ds;
        }

        public object DetachHospitalFromAuthorization(Guid datId, Guid hosId)
        {
            Hashtable table = new Hashtable();
            table.Add("DatId", datId);
            table.Add("HosId", hosId);
            return base.ExecuteDelete("DetachHospitalFromAuthorizationTemp", table);
        }

        public object AttachHospitalToAuthorization(Guid datId, Guid hosId, string hosRemark)
        {
            Hashtable table = new Hashtable();
            table.Add("DatId", datId);
            table.Add("HosId", hosId);
            table.Add("Remark", hosRemark);
            return base.ExecuteInsert("AttachHospitalToAuthorizationTemp", table);
        }

        public int AttachHospitalToAuthorization(Guid datId, string hosProvince, string hosCity, string hosDistrict, Guid productLineId, string hosRemark)
        {
            Hashtable table = new Hashtable();
            table.Add("DatId", datId);
            table.Add("HosCity", hosCity);
            table.Add("HosProvince", hosProvince);
            table.Add("HosDistrict", hosDistrict);
            table.Add("ProductLineId", productLineId);
            table.Add("Remark", hosRemark);   //备注填写科室

            return base.ExecuteUpdate("AttachHospitalToAuthorizationByPartsTemp", table);
        }

        public DataSet GetFormalAuthorizedHospital(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFormalAuthorizedHospital", obj);
            return ds;
        }

        public DataSet GetHospitalGrade(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalGrade", obj);
            return ds;
        }

        public DataSet GetHospitalDepartment(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalDepartment", obj);
            return ds;
        }

        public DataSet GetFormalTerritory(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFormalAuthorizedHospital", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet DeleteAuthorizationAOP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("DeleteAuthorizationAOP", obj);
            return ds;
        }

        public object SynchronousHospitalListTemp(Hashtable obj)
        {
            return base.ExecuteInsert("SynchronousHospitalListTemp", obj);
        }


        #region DCMS Update in 201606
        public string GetContractProperty_Last(Hashtable obj)
        {
            string retMassage = "";
            obj.Add("retMassage", retMassage);
            this.ExecuteInsert("GC_GetContractPropertyLast", obj);

            retMassage = obj["retMassage"].ToString();
            return retMassage;
        }

        public void AddContractProduct(Hashtable obj)
        {
            base.ExecuteInsert("InsertContractProduct", obj);
        }

        /// <summary>
        /// 更具条件获取可选产品分类
        /// </summary>
        public DataSet GetAuthorizationProductAll(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorizationProductAll", obj);
            return ds;
        }

        public DataSet GetAuthorizationProductSelected(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorizationProductSelected", obj);
            return ds;
        }

        public bool DeleteProductSelected(string dctId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProductSelected", dctId);
            return cnt > 0;
        }

        public DataSet QueryDcmsHospitalSelecedTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDCMSHospitalTempSelected", obj);
            return ds;
        }

        public object DeleteAuthorizationHospitalTemp(Guid Id)
        {
            Hashtable table = new Hashtable();
            table.Add("Id", Id);
            return base.ExecuteDelete("DeleteAuthorizationHospitalTemp", table);
        }

        public DataSet GetCopyProductCan(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDCMSCopyProductCan", obj);
            return ds;
        }

        public int CopyHospitalTempFromOtherAuth(Hashtable obj)
        {
            return base.ExecuteUpdate("CopyHospitalTempFromOtherAuth", obj);
        }

        public DataSet DepartProductTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDepartProductTemp", obj);
            return ds;
        }

        public DataSet QueryHospitalProductTemp(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductTemp", obj, start, limit, out totalCount);
            return ds;
        }

        public void HospitalDepartClear(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("HospitalDepartTempClear", obj);
        }


        public int UpdateHospitalDepartmentTemp(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateHospitalDepartmentTemp", obj);
            return cnt;
        }

        public DataSet ExcelHospitalProductTemp(Guid contractId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExcelHospitalProductTemp", contractId);
            return ds;
        }

        //授权医院批量上传
        public bool DeleteTempUploadHospitalByDatId(string dctId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTempUploadHospitalByDatId", dctId);
            return cnt > 0;
        }

        public DataSet QueryHospitalUpload(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDCMSHospitalUpload", obj, start, limit, out totalCount);
            return ds;
        }

        public void BatchHospitalTempInsert(IList<ContractTerritoryInsetTemp> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("DatId");
            dt.Columns.Add("HospitalCode");
            dt.Columns.Add("HospitalName");
            dt.Columns.Add("Depart");
            dt.Columns.Add("DepartRemark");
            dt.Columns.Add("ErrMsg");
            foreach (ContractTerritoryInsetTemp data in list)
            {
                DataRow row = dt.NewRow();
                row["DatId"] = data.DatId;
                row["HospitalCode"] = data.HospitalCode;
                row["HospitalName"] = data.HospitalName;
                row["Depart"] = data.Depart;
                row["DepartRemark"] = data.DepartRemark;
                row["ErrMsg"] = data.ErrMsg;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("dbo.ContractTerritoryInsetTemp", dt);
        }

        public string VerifyDCMSHospitalImport(string datId, string mktype)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("DatId", datId);
            ht.Add("MarketType", mktype);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_DCMS_HospitalInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public DataSet SubmintHospitalTempInitCheck(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDCMSHospitalUpload", obj);
            return ds;
        }

        public void SaveHospitalTempInit(Hashtable obj)
        {
            base.ExecuteInsert("SaveHospitalTempInit", obj);
        }
        #endregion
        public DataSet GetAuthorizationAreaProductSelected(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorizationAreaProductSelected", obj);
            return ds;
        }
        public void AddContractAreaProduct(Hashtable obj)
        {
            base.ExecuteInsert("InsertContractAreaProduct", obj);
        }
        public bool DeleteAreaProductSelected(string Id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAreaProductSelected", Id);
            return cnt > 0;
        }
        public DataSet GetAuthorizatonArea(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetAuthorizatonArea", obj);
            return ds;
        }
        public DataSet GetnArea(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetnArea", obj);
            return ds;
        }
        public void AddContractArea(Hashtable obj)
        {
            base.ExecuteInsert("AddContractArea", obj);

        }
        public bool DeleteAreaAreaSelected(string Id)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAreaAreaSelected", Id);
            return cnt > 0;
        }
        public DataSet GetCopHospit(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetAreaAreaCopHospit", obj);
            return ds;

        }
        public void CopeAuthorizatonAreaHospit(Hashtable obj)
        {
            base.ExecuteInsert("CopeAuthorizatonAreaHospit", obj);
        }
        public void RemoveAreaSelectedHospital(Hashtable obj)
        {
            base.ExecuteDelete("RemoveAreaSelectedHospital", obj);
        }
        public DataSet QueryPartAreaExcHospitalTemp(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryPartAreaExcHospitalTemp", obj, start, limit, out totalCount);
            return ds;
        }
        public void CopeAuthorizatonAreaArea(Hashtable obj)
        {
            base.ExecuteInsert("CopeAuthorizatonAreaArea", obj);
        }
        public void DeleteTerritoryAreaExcTempByDaId(string DaId)
        {
            base.ExecuteDelete("DeleteTerritoryAreaExcTempByDaId", DaId);
        }
        public DataSet GetDeleteProductQutery(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryDeletedProductTemp", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet GetDeleteHospitalQutery(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryDeleteHospitalTemp", obj, start, limit, out totalCount);
            return ds;
        }

        public DataSet CheckAuthorizationType(string contractId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("contractId", contractId);
            DataSet ds = this.ExecuteQueryForDataSet("CheckAuthorizationType", obj);
            return ds;
        }

        public DataSet TerritoryProductByContractId(Guid contractId, string subu)
        {
            Hashtable obj = new Hashtable();
            obj.Add("contractId", contractId.ToString());
            obj.Add("subu", subu);
            DataSet ds = this.ExecuteQueryForDataSet("SelectTerritoryProductByContractId", obj);
            return ds;
        }
    }
}