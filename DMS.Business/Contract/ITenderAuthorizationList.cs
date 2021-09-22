using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Model;
using System.Data;
using System.Collections;

namespace DMS.Business.Contract
{
    public interface  ITenderAuthorizationList
    {
        DataSet GetTenderAuthorizationList(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet ExcelTenderAuthorization(Hashtable obj);
        DataSet GetAuthorizationList(Guid id);

        DataSet GetAuthorization(Guid id);
        AuthorizationTenderMain GetTenderMainById(Guid Id);
        DataSet GetTenderHospitalQuery(Hashtable obj, int start, int limit, out int totalRowCount);
        DataSet GetTenderHospitalProductQuery(Hashtable obj);
        DataSet CheckTenderDealerName(Hashtable obj);
        bool DeleteTenderHospital(Hashtable obj);
        void AddTenderProduct(Hashtable obj);
        DataSet GetTenderAllProduct(Hashtable obj);
        void DeleteTenderProduct(Guid[] changes);
        void InsertTenderMain(AuthorizationTenderMain tendermain);
        void SaveAuthTenderMain(AuthorizationTenderMain tendermain, string operType);
        void DeleteAuthTenderMain(string DtmId);
        bool SaveHospitalOfAuthorization(string dtmId, IDictionary<string, string>[] changes);
        string GetNextAutoNumberForTender(string deptcode, string clientid, string strSettings);
        string CheckTenderAttachment(string mainId);
        int UpdateTenderHospitalDept(Hashtable obj);
        DataSet ExportHospitalProduct(string id);

        DataSet ExportHospital(string id, int start, int limit, out int totalRowCount);
        DataSet ExportTenderAuthorizationProduct(string id);

        DataSet SelectHospitalNum(string id);
       
    }
}
