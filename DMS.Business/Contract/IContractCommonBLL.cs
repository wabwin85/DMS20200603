using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using DMS.Model;
    using System.Data;
    using System.Collections;
    public interface IContractCommonBLL
    {
        IList<ClassificationContract> GetPartContractIdByCCCode(Hashtable obj);
        string CheckSubBUType(string subBUCode);
        DataSet GetPartContractIdByProductId(Hashtable obj);

        IList<ClassificationAuthorization> GetPartsAuthorization(string partsContractId);//更具合同产品分类获取授权产品分类
        DataSet GetPartsAuthorizedTemp(Hashtable obj);//获取授权产品分类并确认是否已经被授权
        DataSet GetPartAuthorizationHospitalTemp(Hashtable obj, int start, int limit, out int totalRowCount);//合同所对应授权医院
        DataSet GetPartAuthorizationHospitalTempNoBR(Hashtable obj, int start, int limit, out int totalRowCount);//合同所对应授权医院
        DataSet GetPartAuthorizationHospitalTempP(Hashtable obj, int start, int limit);

        void RemoveAuthorizationTemp(string ContractId, Guid[] changes);//删除授权医院
        void ModifyPartsAuthorizationTemp(Hashtable obj);
        void SysFormalAuthorizationToTemp(Hashtable obj);
        void UpdateContractTerritoryDepartment(Hashtable obj);

        void SynchronousAOPToTempUnit(Hashtable obj);
        void SynchronousAOPToTempAmount(Hashtable obj);
        void ResetAopAmount(Hashtable objHos, Hashtable objDealer,string contractId);
        DataSet GetClassificationQuotaTempByContractId(string obj);
        DataSet GetQuotaPriceTempByContractId(string obj);
        DataSet GetAllQuotaPriceForTemp(Hashtable obj);
        void MaintainDealerAOPByHospitalAOP(Hashtable obj);

        //指标查询
        DataSet QueryHospitalProductAOPTemp(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet QueryHospitalProductAOPTemp2(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet QueryHospitalProductAOPTemp(Hashtable obj);

        DataSet QueryHospitalProductAmountTemp(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet QueryHospitalProductAmountTemp(Hashtable obj);
        DataSet QueryHospitalProductAmountTemp2(Hashtable obj, int start, int limit, out int totalRowCount);

        DataSet QueryHospitalProductAmountAmendmentTemp(Hashtable obj, int start, int limit, out int totalRowCount);

        DataSet GetHospitalProductAmountTemp(Hashtable obj);
        DataSet QueryAopDealerUnionHospitalAmount(Hashtable obj);
        VAopDealer QueryDealerAOPAndHospitalAOPUnitTemp(Hashtable obj);
        VAopDealer GetDealerAOPAndHospitalAOPAmountTemp(Hashtable obj);

        DataSet GetAopDealerUnionHospitalUnitHistoryQuery(Hashtable obj);

        bool SaveHospitalProductAOPUnit(Guid ContractId, string PartsContractCode, VAopICDealerHospital aopDealers, int month);
        bool SaveHospitalProductAOPAmount(Guid ContractId, string PartsContractCode, VAopDealerHospitalTemp aopHospital, int month);

        bool SaveAopDealerTemp(string contractId, string partsContractId, VAopDealer aopDealer);

        DataSet QueryClassificationQuotaByQuery(Hashtable obj);
        DataSet QueryAuthorizationClassificationQuotaByQuery(Hashtable obj);


        #region add new dcms Project on 20160629
        DataSet QueryHospitalIndexTemp(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet QueryProductIndexTemp(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet GetDealerTempIndex(Hashtable obj);
        DataSet GetHospitalTempIndexSum(Hashtable obj);
        DataSet GetDealerIndexTempYears(Hashtable obj);

        bool HospitalProductAOPInput(DataTable table, string contractId);
        bool VerifyHospitalProductImport(out string IsValid, string contractId,DateTime beginDate);
        DataSet QueryHospitalIndexImputError(Hashtable obj, int start, int limit, out int totalRowCount);
        string HospitalProductAOPInputSubmint(string contractId);
        int DeleteProductHospitalInitById(string contractId);

        DataSet QueryHospitalIndexUnitTemp(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet QueryProductIndexUnitTemp(Hashtable obj, int start, int limit, out int totalRowCount);

        string DealerAOPMerge(Hashtable obj);
        DataSet QueryDealerAndHospitalSumAOPTemp (Hashtable obj);
        DataSet GetHospitalTempIndexUnitToAmountSum(Hashtable obj);
      
        DataSet QueryHospitalUnitAopTempP(Hashtable obj, int start, int limit);
        bool SaveHospitalProductAOPUnitMerge(Guid ContractId, string PartsContractCode, VAopDealerHospitalTemp aopHospital, int month);

        //修改指标
        DataSet QueryHospitalProductAmountAmendmentTemp2(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet GetHospitalCriterionAOP(Hashtable obj);
        DataSet GetHospitalHistoryAOP(Hashtable obj);
        DataSet GetHospitalCurrentAOP(Hashtable obj);
        DataSet QueryHospitalCurrentAOP(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet QueryDealerAOPTempAmendment(Hashtable obj);
        DataSet QueryDealerAOPTempUnitAmendment(Hashtable obj);
        DataSet GetDelaerHistoryAOP(Hashtable obj);
        #endregion
    }
}
