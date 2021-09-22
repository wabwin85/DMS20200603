using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;

namespace DMS.DataAccess
{
    public class ContractCommonDao : BaseSqlMapDao
    {
          /// <summary>
        /// 默认构造函数
        /// </summary>
        public ContractCommonDao(): base()
        {
        }

        public IList<ClassificationContract> GetPartContractIdByCCCode(Hashtable obj)
        {
            IList<ClassificationContract> list = this.ExecuteQueryForList<ClassificationContract>("SelectPartContractIdByCCCode", obj);
            return list;
        }

        public DataSet GetSubBUbyCode(string subBUCode)
        {
            Hashtable obj = new Hashtable();
            obj.Add("Code", subBUCode);
            DataSet ds = this.ExecuteQueryForDataSet("SelectPartContractIdByProductId", obj);
            return ds;
        }

        public DataSet GetPartContractIdByProductId(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPartContractIdByProductId", obj);
            return ds;
        }

        /// <summary>
        /// 获取指点合同分类下的产品分类
        /// </summary>
        /// <returns>所有实体</returns>
        public IList<ClassificationAuthorization> GetPartsAuthorization(string partsContractId)
        {
            IList<ClassificationAuthorization> list = this.ExecuteQueryForList<ClassificationAuthorization>("SelectClassificationAuthorizationByParentCode", partsContractId);
            return list;
        }

        public DataSet GetPartsAuthorizedTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPartsAuthorizedTemp", obj);
            return ds;
        }

        public DataSet GetPartAuthorizationHospitalTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPartAuthorizationHospitalTemp", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet GetPartAuthorizationHospitalTempNoBR(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPartAuthorizationHospitalTempNoBR", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet GetPartAuthorizationHospitalTempP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectPartAuthorizationHospitalTempP", obj);
            return ds;
        }

        public object RemoveAuthorizationTemp(string contractId, Guid hosId)
        {
            Hashtable table = new Hashtable();
            table.Add("ContractId", contractId);
            table.Add("HosId", hosId);
            return base.ExecuteDelete("RemoveAuthorizationTemp", table);
        }

        public DataSet ModifyPartsAuthorizationTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ModifyPartsAuthorizationTemp", obj);
            return ds;
        }

        public DataSet SysFormalAuthorizationToTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SysFormalAuthorizationToTemp", obj);
            return ds;
        }

        public int UpdateContractTerritoryDepartment(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateContractTerritoryDepartment", obj);
            return cnt;
        }


        public DataSet SynchronousAOPToTempUnit(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SynchronousAOPToTempUnit", obj);
            return ds;
        }

        public DataSet SynchronousAOPToTempAmount(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SynchronousAOPToTempAmount", obj);
            return ds;
        }

        public DataSet GetClassificationQuotaTempByContractId(string ContractId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectClassificationQuotaTempByContractId", ContractId);
            return ds;
        }

        public DataSet GetQuotaPriceTempByContractId(string ContractId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectQuotaPriceTempByContractId", ContractId);
            return ds;
        }

        public DataSet GetAllQuotaPriceForTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAllQuotaPriceForTemp", obj);
            return ds;
        }

        public DataSet MaintainDealerAOPByHospitalAOP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("MaintainDealerAOPByHospitalAOP", obj);
            return ds;
        }

        public DataSet QueryHospitalProductAOPTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAOPTemp", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet QueryHospitalProductAOPTemp2(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAOPTemp2", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet QueryHospitalProductAOPTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAOPTemp", obj);
            return ds;
        }

        public DataSet QueryDealerAOPAndHospitalAOPUnitTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerAOPAndHospitalAOPUnitTemp", obj);
            return ds;
        }

        public DataSet GetDealerAOPAndHospitalAOPAmountTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerAOPAndHospitalAOPAmountTemp", obj);
            return ds;
        }

        public DataSet QueryHospitalProductAmountTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAmountTemp", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet QueryHospitalProductAmountTemp(Hashtable obj) 
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAmountTemp", obj);
            return ds;
        }

        public DataSet QueryHospitalProductAmountTemp2(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAmountTemp2", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet QueryHospitalProductAmountAmendmentTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAmountAmendmentTemp", obj, start, limit, out totalRowCount);
            return ds;
        }


        public DataSet GetHospitalProductAmountTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAmountTempDetail", obj);
            return ds;
        }

        public DataSet QueryAopDealerUnionHospitalAmount(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAopDealerUnionHospitalAmount", obj);
            return ds;
        }

        public DataSet QueryClassificationQuotaByQuery(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectClassificationQuotaByQuery", obj);
            return ds;
        }

        public DataSet QueryAuthorizationClassificationQuotaByQuery(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorizationClassificationQuotaByQuery", obj);
            return ds;
        }

        public int DeleteHospitalAmountTempAop(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAopDealerHospitalTemp", obj);
            return cnt;
        }

        public int DeleteDealerTempAop(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteAopDealerTemp", obj);
            return cnt;
        }

        #region add new dcms Project on 20160629
        public DataSet GetDealerTempIndex(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerTempIndex", obj);
            return ds;
        }

        public DataSet GetHospitalTempIndexSum(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalTempIndexSum", obj);
            return ds;
        }

        public DataSet GetDealerIndexTempYears(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerIndexTempYears", obj);
            return ds;
        }

        public DataSet QueryHospitalIndexTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalIndexTemp", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet QueryProductIndexTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductIndexTemp", obj, start, limit, out totalRowCount);
            return ds;
        }

        /// <summary>
        /// 批量医院指标数据
        /// </summary>
        /// <param name="list"></param>
        public void BatchHospitalProductAOPInsert(IList<HospitalProductaopInputTemp> list)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ContractId");
            dt.Columns.Add("Year");
            dt.Columns.Add("HospitalCode");
            dt.Columns.Add("HospitalName");
            dt.Columns.Add("ProductCode");
            dt.Columns.Add("ProductName");
            dt.Columns.Add("M1");
            dt.Columns.Add("M2");
            dt.Columns.Add("M3");
            dt.Columns.Add("M4");
            dt.Columns.Add("M5");
            dt.Columns.Add("M6");
            dt.Columns.Add("M7");
            dt.Columns.Add("M8");
            dt.Columns.Add("M9");
            dt.Columns.Add("M10");
            dt.Columns.Add("M11");
            dt.Columns.Add("M12");
            dt.Columns.Add("ErrMassage");
            foreach (HospitalProductaopInputTemp data in list)
            {
                DataRow row = dt.NewRow();
                row["ContractId"] = data.Contractid;
                row["Year"] = data.Year;
                row["HospitalCode"] = data.HospitalCode;
                row["HospitalName"] = data.HospitalName;
                row["ProductCode"] = data.ProductCode;
                row["ProductName"] = data.ProductName;
                row["M1"] = data.M1;
                row["M2"] = data.M2;
                row["M3"] = data.M3;
                row["M4"] = data.M4;
                row["M5"] = data.M5;
                row["M6"] = data.M6;
                row["M7"] = data.M7;
                row["M8"] = data.M8;
                row["M9"] = data.M9;
                row["M10"] = data.M10;
                row["M11"] = data.M11;
                row["M12"] = data.M12;
                row["ErrMassage"] = data.ErrMassage;
                dt.Rows.Add(row);
            }
            this.ExecuteBatchInsert("HospitalProductAOPInputTemp", dt);
        }

        public string VerifyHospitalProductImport(string contractId, DateTime beginDate)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("ContractId", contractId);
            ht.Add("BEGINDATE", beginDate);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_HospitalProductAOPInit", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }

        public DataSet QueryHospitalIndexImputError(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalIndexImputError", obj, start, limit, out totalRowCount);
            return ds;
        }

        public string HospitalProductAOPInputSubmint(string contractId)
        {
            string IsValid = string.Empty;

            Hashtable ht = new Hashtable();
            ht.Add("ContractId", contractId);
            ht.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_HospitalProductAOPInitSubmint", ht);

            IsValid = ht["IsValid"].ToString();

            return IsValid;
        }


        public int DeleteProductHospitalInitById(string contractId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProductHospitalInitById", contractId);
            return cnt;
        }

        public DataSet QueryHospitalIndexUnitTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalIndexUnitTemp", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet QueryProductIndexUnitTemp(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductIndexUnitTemp", obj, start, limit, out totalRowCount);
            return ds;
        }

        public string DealerAOPMerge(Hashtable obj)
        {
            string IsValid = string.Empty;
            obj.Add("IsValid", IsValid);

            this.ExecuteInsert("GC_DealerAOPMerge", obj);

            IsValid = obj["IsValid"].ToString();

            return IsValid;
        }

        public DataSet QueryDealerAndHospitalSumAOPTemp(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerAndHospitalSumAOPTemp", obj);
            return ds;
        }

        public DataSet GetHospitalTempIndexUnitToAmountSum(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalTempIndexUnitToAmountSum", obj);
            return ds;
        }

        public DataSet QueryHospitalUnitAopTempP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("QueryHospitalUnitAopTempP", obj);
            return ds;
        }

        public DataSet QueryHospitalProductAmountAmendmentTemp2(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAmountAmendmentTemp2", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet GetHospitalCriterionAOP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalCriterionAOP", obj);
            return ds;
        }

        public DataSet GetHospitalHistoryAOP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalHistoryAOP", obj);
            return ds;
        }

        public DataSet GetHospitalCurrentAOP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalCurrentAOP", obj);
            return ds;
        }

        public DataSet QueryHospitalCurrentAOP(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalCurrentAOP", obj, start, limit, out totalRowCount);
            return ds;
        }

        public DataSet QueryDealerAOPTempAmendment(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerAOPTempAmendment", obj);
            return ds;
        }

        public DataSet QueryDealerAOPTempUnitAmendment(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerAOPTempUnitAmendment", obj);
            return ds;
        }

        public DataSet GetDelaerHistoryAOP(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDelaerHistoryAOP", obj);
            return ds;
        }
        #endregion
    }
}
