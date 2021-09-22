using System;
using System.Collections.Generic;
using System.Data;

namespace DMS.Business
{
    using DMS.Model;
    using System.Collections;

    /// <summary>
    /// IDealerMasters
    /// </summary>
    public interface IDealerMasters
    {
        DealerMaster GetDealerMaster(Guid dmaId);
        IList<DealerMaster> GetAll();
        IList<DealerMaster> QueryForDealerMaster(DealerMaster dealermaster);


        /// <summary>
        /// Gets the dealers by sales.
        /// </summary>
        /// <param name="userId">The user id.</param>
        /// <param name="productLines">The product lines.</param>
        /// <returns></returns>
        IList<Guid> GetDealersBySales(string userId, Guid[] productLines);

        IList<DealerMaster> QueryForDealerMaster(DealerMaster dealermaster, int start, int limit, out int totalRowCount);
        IList<DealerMaster> QueryForDealerMasterByAllUser(Hashtable obj, int start, int limit, out int totalRowCount);

        DataSet QueryForDealerMaster(Hashtable param, int start, int limit, out int totalRowCount);
        DataTable QueryForDealerProfileMaster(Hashtable param, int start, int limit, out int totalRowCount);

        DataSet GetProductLineById(Guid ProductId);
        DataSet GetHospitalById(Guid Hospital);
        IList<LpDistributorData> QueryLPDistributorInfo(string batchNbr);
        DataSet GetParentDealer(Guid dealerId);

        DataSet ExportDealerMaster(Guid dmaId);
        DataSet GetDealerProductLine(Guid dealerId);
        DataSet ExportDealerAuthorization(Hashtable obj);

        #region 获取经销商合同信息
        DataSet GetDealerContract(Hashtable obj,int start, int limit, out int totalRowCount);
        DataSet GetDealerContract(Hashtable obj);
        int UpdateDealerContractThirdParty(Hashtable obj);
        #endregion

        #region 第三方披露表签名信息
        DataSet GetThirdPartSignature(Hashtable obj);
        int UpdateThirdPartSignature(Hashtable obj);
        #endregion

        //经销商联系人维护
        int UpdateDealerBaseContact(DealerMaster dealer);

        //通过账号获取经销信息
        DataSet GetDealerMassageByAccount(string userName);
        
        //获取经销商首页信息
        bool GetHomePageMessage(Hashtable obj);

        DataSet GetExcelDealerMasterByAllUser(Hashtable obj);

        //Add By SongWeiming on 2015-09-15 For GSP Project
        //获取经销商证照相关信息
        DealerMasterLicense QueryDealerMasterLicenseByDealerId(Guid dealerId);
        DataSet GetDealerMasterLicenseToTable(string dealerId);

        //根据经销商三级分类代码，获取经销商证照相关内容
        DataSet GetDealerLicenseCatagoryByCatId(string strCatId,string catType,string VersionNumber);

        //根据经销商分类代码类别，获取产品分类信息
        DataSet GetLicenseCatagoryByCatType(Hashtable obj);

        //提交证照信息更新申请
        bool SubmitLicenseApplication(DealerMasterLicense dml, string applyType);

        //证照信息更新申请审批通过
        bool ApproveLicenseApplication(Guid dealerId, string remark);

        bool RejectLicenseApplication(Guid dealerId, string remark);

        DataSet QueryDealerLicenseForExport(Hashtable param);
        //End Add SongWeiming on 2015-09-15 For GSP Project
        //lijie add 2016-04-13
        DataSet QueryDealerLicenseCfnForExport(Hashtable param);

        DealerMaster SelectDealerMasterParentTypebyId(Guid Id);

        DataSet GetDealerMaster(Hashtable obj, int start, int limit, out int totalRowCount);

        //经销商更名 T2
        bool UpdateDealerName(Hashtable obj, out string IsValid);
        IList<Interfacet2ContactInfo> SelectT2ContactInfoByID(Guid Id, int start, int limit, out int totalRowCount);
DataSet GetShiptoAddress(Guid NewApplyId);

        void addaddress(Hashtable hs);

        DataSet GetAddress(Guid Dealerid , int start, int limit, out int totalRowCount);

        void updateaddress(string  id);

        void updateshiptoaddress(Guid Dealerid);

        void insertDealerMasterLicenseModify(Hashtable hs);

        DataSet GetCFDAHead(Hashtable hs, int start, int limit, out int totalRowCount);

        DataSet GetCFDAHeadAll(string DealerId, string ApplyStatus);
        DataSet GetCFDAProcess(string MID);
        void UpdateDealerMasterLicenseModify(Hashtable hs);
        string GetNextCFDANo(string clientid, string strSettings);
        void DeleteShipToAddress(Guid DML_MID);
        void DeleteAttachment(Guid DML_MID);
        void DeleteDealerMasterLicenseModify(Guid DML_MID);
        void insertShipToAddress(Guid DML_MID, Guid DealerId);
        DataSet SelectSAPWarehouseAddress(Guid DealerId);
        void updateshiptoaddressbtn(string ID, string IsSendAddress);
        void DeleteSAPWarehouseAddress_temp(string id);
        DataSet SelectSAPWarehouseAddress_temp(Guid DML_MID);
        void SubmintCfdaMflow(string mdlId,string SubmintNo,string SalesRep);
        DataSet GetSalesRepByParam(Hashtable Param);
    }
}
