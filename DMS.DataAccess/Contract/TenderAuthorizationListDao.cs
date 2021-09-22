using DMS.Model;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.Contract
{
    public class TenderAuthorizationListDao : BaseSqlMapDao
    {
        /// <summary>
        /// 默认构造函数
        /// </summary>
        public TenderAuthorizationListDao() : base()
        {
        }
        //查询
        public DataSet GetTenderAuthorizationList(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTenderAuthorizationList", obj, start, limit, out totalRowCount);
            return ds;
        }
        //合同类型
        public DataSet ExpApplicType(string id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectExpApplicType", id);
            return ds;
        }
        //  授权医院
        public DataSet ExpHospital(string id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectExpHospital", id);
            return ds;
        }
        //替换书签
        public DataSet SelectTenderWork(string No)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTenderWork", No);
            return ds;
        }
        public DataSet ExcelTenderAuthorization(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExcelTenderAuthorization", obj);
            return ds;
        }
        public DataSet GetAuthorizationList(Guid id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportTenderAuthorizationList", id);
            return ds;
        }
        public DataSet GetAuthorization(Guid id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportTenderAuthorization", id);
            return ds;
        }
        //上级平台商
        public DataSet SelectSuperiorDealer(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectSuperiorDealerInfo", obj);
            return ds;
        }
        //正式合同
        public DataSet SelectContract(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectContract", obj);
            return ds;
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public AuthorizationTenderMain GetTenderMainById(Guid objKey)
        {
            AuthorizationTenderMain obj = this.ExecuteQueryForObject<AuthorizationTenderMain>("SelectAuthorizationTenderMain", objKey);
            return obj;
        }
        public DataSet GetTenderHospitalQuery(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTenderHospitalByCondition", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet GetTenderHospitalProductQuery(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTenderProductSelected", obj);
            return ds;
        }
        public DataSet GetTenderFileQuery(Hashtable obj, int start, int limit, out int totalCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTenderFileQuery", obj, start, limit, out totalCount);
            return ds;
        }
        public DataSet CheckTenderDealerName(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTenderDealerName", obj);
            return ds;
        }
        public int DeleteTenderProduct(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTenderProduct", obj);
            return cnt;
        }
        public int DeleteTenderHospital(Hashtable obj)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTenderHospital", obj);
            return cnt;
        }
        //清空授权医院
        public int ClearHospital(string DtmId)
        {
            int cnt = (int)this.ExecuteDelete("ClearHospital", DtmId);
            return cnt;
        }
        //清空授权产品
        public int ClearHospitalProduct(string DtmId)
        {
            int cnt = (int)this.ExecuteDelete("ClearHospitalProduct", DtmId);
            return cnt;
        }
        public void AddTenderProduct(Hashtable obj)
        {
            base.ExecuteInsert("AddTenderProduct", obj);
        }
        public DataSet GetTenderAllProduct(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTenderAllProduct", obj);
            return ds;
        }
        public object DeleteTenderProduct(string key)
        {
            return base.ExecuteDelete("DeleteTenderProductByKey", key);
        }
        public void InsertTenderMain(AuthorizationTenderMain obj)
        {
            this.ExecuteInsert("InsertAuthorizationTenderMain", obj);
        }
        public int UpdateTenderMain(AuthorizationTenderMain obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAuthorizationTenderMain", obj);
            return cnt;
        }
        public int DeleteTenderProductByDtmId(string DtmId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTenderProductByDtmId", DtmId);
            return cnt;
        }
        public int DeleteTenderHospitalByDtmId(string DtmId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTenderHospitalByDtmId", DtmId);
            return cnt;
        }
        public int DeleteTenderMainByDtmId(string DtmId)
        {
            int cnt = (int)this.ExecuteDelete("DeleteTenderMainByDtmId", DtmId);
            return cnt;
        }
        public void AddTenderHospital(string dtmId, string HospitalId)
        {
            Hashtable obj = new Hashtable();
            obj.Add("DtmId", dtmId);
            obj.Add("HospitalId", HospitalId);
            this.ExecuteInsert("InsertAuthorizationTenderHospital", obj);
        }
        public string GetNextAutoNumberForTender(string deptcode, string clientid, string strSettings)
        {
            string strNextAutoNumber = "";
            Hashtable ht = new Hashtable();
            ht.Add("DeptCode", deptcode);
            ht.Add("ClientID", clientid);
            ht.Add("Settings", strSettings);
            ht.Add("nextnbr", strNextAutoNumber);
            this.ExecuteInsert("GetNextAutoNumberForTender", ht);
            strNextAutoNumber = ht["nextnbr"].ToString();
            return strNextAutoNumber;
        }
        public DataSet GetTenderAttachmentType(string MainId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectTenderAttachmentType", MainId);
            return ds;
        }

        public int UpdateTenderHospitalDept(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateTenderHospitalDept", obj);
            return cnt;
        }
        public DataSet ExcleHospitalproduct(string id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExcleHospitalproduct", id);
            return ds;
        }
        //授权医院和产品清单
        public DataSet ExcleHospitalproductWork(Hashtable id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExcleHospitalproductWork", id);
            return ds;
        }

        public DataSet ExcleHospital(string id, int start, int limit, out int totalRowCoun)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExcleHospital", id, start, limit, out totalRowCoun);
            return ds;
        }
        public DataSet ExportTenderAuthorizationProduct(string id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("ExportTenderAuthorizationProduct", id);
            return ds;
        }
        public DataSet SelectHospitalNum(string id)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalNum", id);
            return ds;
        }


        public DataTable QueryTenderAuthorizationForHtmlById(string id)
        {
            DataTable dt = this.ExecuteQueryForDataSet("QueryTenderAuthorizationForHtmlById", id).Tables[0];
            return dt;
        }
    }
}
