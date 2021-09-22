
/**********************************************
这是代码自动生成的，如果重新生成，所做的改动将会丢失
 * NameSpace   : DMS.DataAccess 
 * ClassName   : ContractAmendment
 * Created Time: 2013/12/4 17:57:05
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
    /// ContractAmendment的Dao
    /// </summary>
    public class ContractAmendmentDao : BaseSqlMapDao
    {

        /// <summary>
        /// 默认构造函数
        /// </summary>
        public ContractAmendmentDao() : base()
        {
        }

        /// <summary>
        /// 根据PK得到实体
        /// </summary>
        /// <param name="PK">PK</param>
        /// <returns>实体</returns>
        public ContractAmendment GetObject(Guid objKey)
        {
            ContractAmendment obj = this.ExecuteQueryForObject<ContractAmendment>("SelectContractAmendment", objKey);
            return obj;
        }

        public int UpdateAmendmentCmidByConid(Hashtable obj)
        {
            int cnt = (int)this.ExecuteUpdate("UpdateAmendmentCmidByConid", obj);
            return cnt;
        }
        public DataSet SelectAmendmentMain(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAmendmentMain", table);
            return ds;
        }
        public DataSet SelectAmendmentProposals(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAmendmentProposals", table);
            return ds;
        }
        public string CheckAttachmentUpload(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAttachmentUpload", table);
            if (ds.Tables[0].Rows.Count > 0)
            {
                return "1";
            }
            else
            {
                return "0";
            }
        }

        public void InsertAmendmentMainTemp(AmendmentMainTemp obj)
        {
            this.ExecuteInsert("InsertAmendmentMainTemp", obj);
        }
        public void InsertAmendmentProposalsTemp(AmendmentProposalsTemp obj)
        {
            this.ExecuteInsert("InsertAmendmentProposalsTemp", obj);
        }
        public string AmendmentInitialize(string tempId, string contractType)
        {
            string IsValid = string.Empty;

            Hashtable obj = new Hashtable();
            obj.Add("TempId", tempId);
            obj.Add("ContractType", contractType);
            obj.Add("IsValid", IsValid);

            this.ExecuteInsert("ContractUpdateSubmint", obj);

            IsValid = obj["IsValid"].ToString();

            return IsValid;
        }
        public DataSet GetUpdatelog(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAmedmentUpdatelog", table, start, limit, out totalRowCount);
            return ds;
        }
        public void TerritoryEditorInitAdmin(Hashtable table)
        {
            this.ExecuteInsert("TerritoryEditorInitAdmin", table);
        }
        public DataSet AuthorizationProductSelectedAdmin(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorizationProductSelectedAdmin", table);
            return ds;
        }
        public void AddContractProductAdminItem(Hashtable table)
        {
            this.ExecuteInsert("IsertContractProductAdminItem", table);
        }
        public DataSet GetProductHospitalSeletedAdmin(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectProductHospitalSeletedAdmin", table, start, limit, out totalRowCount);
            return ds;
        }
        public bool DeleteProductSelectedAdmin(Hashtable table)
        {
            int cnt = (int)this.ExecuteDelete("DeleteProductSelectedAdmin", table);
            return cnt > 0;
        }
        public void DeleteHospitalAOPTempAdmin(Hashtable table)
        {
            int cnt = (int)this.ExecuteDelete("DeleteHospitalAOPTempAdmin", table);
        }
        public void DeleteDealerAOPTempAdmin(Hashtable table)
        {
            int cnt = (int)this.ExecuteDelete("DeleteDealerAOPTempAdmin", table);
        }
        public object DeleteAuthorizationHospitalTempAdmin(Guid Id, string tempid)
        {
            Hashtable table = new Hashtable();
            table.Add("Id", Id);
            table.Add("TempId", tempid);
            return base.ExecuteDelete("DeleteAuthorizationHospitalTempAdmin", table);
        }
        public DataSet GetCopyProductCanAdmin(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDCMSCopyProductCanAdmin", obj);
            return ds;
        }
        public int CopyHospitalTempFromOtherAuthAdmin(Hashtable obj)
        {
            return base.ExecuteUpdate("CopyHospitalTempFromOtherAuthAdmin", obj);
        }

        public void AddProductHospitalAdmin(Hashtable obj)
        {
            this.ExecuteInsert("InsertProductHospitalTempAdmin", obj);
        }
        public DataSet SelectHospitalProductAOPAdmin(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAOPAdmin", table, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet SelectHospitalProductAOPAdmin(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectHospitalProductAOPAdmin", table);
            return ds;
        }
        public DataSet SelectDealerAOPAdmin(Hashtable obj)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerAOPAdmin", obj);
            return ds;
        }
        public void AOPEditorInitAdmin(Hashtable table)
        {
            this.ExecuteInsert("AOPEditorInitAdmin", table);
        }
        public int SaveHospitalAopAdmin(Hashtable obj)
        {
            return base.ExecuteUpdate("SaveHospitalAopAdmin", obj);
        }
        public int SaveDealerAopAdmin(Hashtable obj)
        {
            return base.ExecuteUpdate("SaveDealerAopAdmin", obj);
        }
        public DataSet GetContractAttachmentAdmin(Hashtable table, int start, int limit, out int totalRowCount)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectContractAttachmentAdmin", table, start, limit, out totalRowCount);
            return ds;
        }
        public DataSet GetContractAttachmentAdmin(Hashtable table)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectContractAttachmentAdmin", table);
            return ds;
        }
        public void UploadContractAttachment(Hashtable obj)
        {
            this.ExecuteInsert("UploadContractAttachmentAdmin", obj);
        }
    }
}