using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business.Contract
{
    using DMS.Model;
    using System.Data;
    using System.Collections;

    public interface IContractAmendmentService
    {
        ContractAmendment GetContractAmendmentByID(Guid camId);

        int UpdateAmendmentCmidByConid(Hashtable obj);

        DataSet SelectAmendmentMain(Hashtable table);
        DataSet SelectAmendmentProposals(Hashtable table);
        string CheckAttachmentUpload(Hashtable table);
        bool SaveAmendmentUpdate(AmendmentMainTemp main, AmendmentProposalsTemp proposals);
        DataSet GetUpdatelog(string contractid, int start, int limit, out int totalRowCount);
        void TerritoryEditorInitAdmin(Hashtable table);
        DataSet AuthorizationProductSelectedAdmin(Hashtable table);
        void AddContractProductAdmin(Hashtable table);
        DataSet GetProductHospitalSeletedAdmin(Hashtable table, int start, int limit, out int totalRowCount);
        bool DeleteProductSelectedAdmin(Hashtable table);
        void DeleteHospitalAOPTempAdmin(Hashtable table);
        void DeleteDealerAOPTempAdmin(Hashtable table);
        void DeleteAuthorizationHospitalTempAdmin(Guid[] changes,string Id);
        DataSet GetCopyProductCanAdmin(Hashtable obj);
        int CopyHospitalTempFromOtherAuthAdmin(Hashtable obj);
        void AddProductHospitalAdmin(Hashtable obj);
        DataSet SelectHospitalProductAOPAdmin(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet SelectHospitalProductAOPAdmin(Hashtable table);
        DataSet SelectDealerAOPAdmin(Hashtable obj);
        void AOPEditorInitAdmin(Hashtable obj);
        void SaveHospitalAopAdmin(Hashtable obj);
        void SaveDealerAopAdmin(Hashtable obj);
        DataSet GetContractAttachmentAdmin(Hashtable table, int start, int limit, out int totalRowCount);
        DataSet GetContractAttachmentAdmin(Hashtable table);
        void UploadContractAttachment(Hashtable obj);
    }
}
