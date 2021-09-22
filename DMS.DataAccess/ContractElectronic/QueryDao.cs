using DMS.Model;
using DMS.Model.ViewModel.ContractElectronic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.ContractElectronic
{
    public class QueryDao : BaseSqlMapDao
    {
        public QueryDao() : base()
        {
        }

        public DataSet SelectAllContractByApproved(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAllContractByApproved", ht);

            return ds;
        }
        public DataSet SelectBU(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectBU", ht);
            return ds;
        }
        public DataSet SelectClassContractByBU(string divisionCode)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectClassContractByBU", divisionCode);
            return ds;
        }
        public DataSet SelectContractByContractId(ContractDetailView model)
        {
            Hashtable obj = new Hashtable();
            DataSet ds = new DataSet();
            obj.Add("ContractId", model.ContractId);
            obj.Add("ContractType", model.ContractType);
            obj.Add("DeptId", model.DeptId);
            if (model.DealerType == "LP" || model.DealerType == "T1")
            {
                ds = SelectContractMainByContractId(obj);
            }
            if (model.DealerType == "T2")
            {
                ds = SelectContractT2MainByContractId(obj);
            }
            return ds;
        }
        public DataSet SelectContractMainByContractId(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectContractMainByContractId", ht);
            return ds;
        }
        public DataSet SelectContractT2MainByContractId(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectContractT2MainByContractId", ht);
            return ds;
        }

        public DataSet SelectFunAppointmentByContractID(string contractID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFunAppointmentByContractID", contractID);
            return ds;
        }
        public DataSet SelectFunAmendmentByContractID(string contractID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFunAmendmentByContractID", contractID);
            return ds;
        }
        public DataSet SelectFunRenewalByContractID(string contractID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFunRenewalByContractID", contractID);
            return ds;
        }
        public DataSet SelectFunTerminationByContractID(string contractID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFunTerminationByContractID", contractID);
            return ds;
        }
        public DataSet GetFunGC_Fn_GetContractDate(string DealerID,string AgreementBegin,string AgreementEnd)
        {
            Hashtable tb = new Hashtable();
            tb.Add("DealerID", DealerID);
            tb.Add("AgreementBegin", AgreementBegin);
            tb.Add("AgreementEnd", AgreementEnd);
            DataSet ds = this.ExecuteQueryForDataSet("GetFunGC_Fn_GetContractDate", tb);
            return ds;
        }
        public DataSet SelectExportTemplate(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectExportTemplate", ht);
            return ds;
        }
        public DataSet SelectFunAuthorizationData(string contractID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFunAuthorizationData", contractID);
            return ds;
        }
        public DataSet SelectFunDealerAopData(string contractID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFunDealerAopData", contractID);
            return ds;
        }
        public DataSet SelectFunHospitalAopData(string contractID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectFunHospitalAopData", contractID);
            return ds;
        }
        public IList<ContractDetailView> SelectContractT2MainByExportId(Hashtable ht)
        {
            IList<ContractDetailView> list = this.ExecuteQueryForList<ContractDetailView>("SelectContractT2MainByExportId", ht);
            return list;
        }
        public IList<ContractDetailView> SelectContractMainByExportId(Hashtable ht)
        {
            IList<ContractDetailView> list = this.ExecuteQueryForList<ContractDetailView>("SelectContractMainByExportId", ht);
            return list;
        }

        
        public IList<SelectedTemplate> SelectExportTemplateToList(Hashtable ht)
        {
            IList<SelectedTemplate> list = this.ExecuteQueryForList<SelectedTemplate>("SelectExportTemplateToList", ht);
            return list;
        }
        public string DealerAopDataHtmlTable(string ContractId)
        {
            string result = this.ExecuteQueryForObject("DealerAopDataHtmlTable", ContractId).ToString();
            return result;
        }
        public DataSet GetSubBuContract(string DealerName,string DeptId,string SUBDEPID,string ContractNo)
        {
            Hashtable tb = new Hashtable();
            tb.Add("DealerName", DealerName);
            tb.Add("DeptId", DeptId);
            tb.Add("SUBDEPID", SUBDEPID);
            tb.Add("ContractNo", ContractNo);
            DataSet ds = this.ExecuteQueryForDataSet("GetSubBuContract", tb);
            return ds;
        }
        public string T2DealerAopDataHtmlTable(string ContractId)
        {
            string result = this.ExecuteQueryForObject("T2DealerAopDataHtmlTable", ContractId).ToString();
            return result;
        }
        public string T2DealerPEPPHtmlTable(string ContractId)
        {
            string result = this.ExecuteQueryForObject("T2DealerPEPPHtmlTable", ContractId).ToString();
            return result;
        }
        public string T2DealerPEHtmlTable(string ContractId)
        {
            string result = this.ExecuteQueryForObject("T2DealerPEHtmlTable", ContractId).ToString();
            return result;
        }

        public DataTable SelectAuthorizationData(string ContractId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorizationData", ContractId);
            return ds.Tables[0];
        }
        public DataTable GetT2Taxamount(string ContractId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetT2Taxamount", ContractId);
            return ds.Tables[0];
        }
        public DataSet SelectAuthorizationByContractId(string ContractId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorizationByContractId", ContractId);
            return ds;
        }
        public DataSet SelectAuthorizationProductByContractId(string ContractId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("ContractId", ContractId);
            DataSet ds = this.ExecuteQueryForDataSet("SelectAuthorizationProductByContractId", ht);
            return ds;
        }

        /// <summary>
        /// 植入医院指标
        /// </summary>
        /// <param name="ContractId"></param>
        /// <returns></returns>
        public string DealerImportAopDataHtmlTable(string ContractId)
        {
            string result = this.ExecuteQueryForObject("DealerImportAopDataHtmlTable", ContractId).ToString();
            return result;
        }
        public string T2DealerImportAopDataHtmlTable(string ContractId)
        {
            string result = this.ExecuteQueryForObject("T2DealerImportAopDataHtmlTable", ContractId).ToString();
            return result;
        }
        public DataSet SelectClassificationFunAuthorizationData(string contractID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectClassificationFunAuthorizationData", contractID);
            return ds;
        }

        public DataTable GetContractEsignTypeByContractId(string contractID)
        {
            DataTable dt = this.ExecuteQueryForDataSet("GetContractEsignTypeByContractId", contractID).Tables[0];
            return dt;
        }

        public DataTable GetContract(string DealerName, string SubCompanyId, string BrandId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DealerName", DealerName);
            ht.Add("SubCompanyId", SubCompanyId);
            ht.Add("BrandId", BrandId);
            DataTable dt = this.ExecuteQueryForDataSet("GetContract", ht).Tables[0];
            //DataTable dt = new DataTable();
            return dt;
        }
        public DataTable GetContractMainInfo(string ContractID)
        {
            Hashtable ht = new Hashtable();
            ht.Add("ContractID", ContractID);
            DataTable dt = this.ExecuteQueryForDataSet("GetContractMainInfo", ht).Tables[0];
            //DataTable dt = new DataTable();
            return dt;
        }
        public DataTable GetClassificationContract(string Code)
        {
            DataTable dt = this.ExecuteQueryForDataSet("GetClassificationContract", Code).Tables[0];
            //DataTable dt = new DataTable();
            return dt;
        }
    }
}
