using DMS.Model;
using DMS.Model.ViewModel.ContractElectronic;
using IBatisNet.Common.Exceptions;
using IBatisNet.DataMapper;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace DMS.DataAccess.ContractElectronic
{
    public class LPandT1Dao : BaseSqlMapDao
    {
        public LPandT1Dao() : base()
        {
        }
        public void InsertContract(ContractDetailView model)
        {
            if (model.DealerType == "LP" || model.DealerType == "T1")
            {
                InsertLPT1Contract(model);
            }
            if (model.DealerType == "T2")
            {
                InsertT2Contract(model);
            }
        }
        public void InsertLPT1Contract(ContractDetailView model)
        {
            this.ExecuteInsert("InsertContract", model);
        }

        public void InsertT2Contract(ContractDetailView model)
        {
            this.ExecuteInsert("InsertT2Contract", model);
        }

        public void deleteContract(ContractDetailView model)
        {
            Hashtable ht = new Hashtable();
            ht.Add("ContractNo", model.ContractNo);
            ht.Add("ContractId", model.ContractId);
            ht.Add("ContractType", model.ContractType);
            ht.Add("DealerType", model.DealerType);
            ht.Add("ExportId", model.ExportId);
            if (model.DealerType == "LP" || model.DealerType == "T1")
            {
                deleteContractLPT1(ht);
            }
            if (model.DealerType == "T2")
            {
                deleteContractT2(ht);
            }
        }
        public DataSet SelectDeleteContract(ContractDetailView model)
        {
            Hashtable ht = new Hashtable();
            DataSet ds = new DataSet();
            ht.Add("ContractNo", model.ContractNo);
            ht.Add("ContractId", model.ContractId);
            ht.Add("ContractType", model.ContractType);
            ht.Add("DealerType", model.DealerType);
            ht.Add("ExportId", model.ExportId);
            if (model.DealerType == "LP" || model.DealerType == "T1")
            {
                ds = SelectDeleteContractLPT1(ht);
            }
            if (model.DealerType == "T2")
            {

                ds = SelectDeleteContractT2(ht);
            }
            return ds;
        }

        public void deleteContractLPT1(Hashtable ht)
        {
            this.ExecuteDelete("deleteContract", ht);
        }
        public DataSet SelectDeleteContractLPT1(Hashtable ht)
        {
            var rel = this.ExecuteQueryForDataSet("SelectDeleteContract", ht);
            return rel;
        }
        public void deleteContractT2(Hashtable ht)
        {
            this.ExecuteDelete("deleteContractT2", ht);
        }
        public DataSet SelectDeleteContractT2(Hashtable ht)
        {
            var rel = this.ExecuteQueryForDataSet("SelectDeleteContractT2", ht);
            return rel;
        }

        public void InsertVersion(Hashtable ht)
        {
            this.ExecuteInsert("InsertVersion", ht);
        }
        public void DeleteDraftSelectExportTemp(string ExportId)
        {
            this.ExecuteDelete("DeleteDraftSelectExportTemp", ExportId);
        }


        public void BatchInsertSelectedTmp(IList<SelectedTemplate> list, Guid exportId)
        {

            DataTable dt = new DataTable();
            dt.Columns.Add("ExportId", typeof(Guid));
            dt.Columns.Add("TemplateId", typeof(Guid));
            dt.Columns.Add("DisplayOrder", typeof(int));
            dt.Columns.Add("UploadFilePath", typeof(string));
            dt.Columns.Add("FileName", typeof(string));
            dt.Columns.Add("FileType", typeof(string));
            for (int i = 0; i < list.Count; i++)
            {
                DataRow dr = dt.NewRow();
                var t = list[i];
                dr["ExportId"] = exportId;
                dr["TemplateId"] = new Guid(t.TmpID);
                dr["UploadFilePath"] = list[i].FilePath;
                dr["DisplayOrder"] = i + 1;
                dr["FileName"] = list[i].TmpName;
                dr["FileType"] = list[i].FileType;
                dt.Rows.Add(dr);
            }
            this.BatchInsert("Contract.ExportSelectedTemplate", dt);
        }
        public void BatchInsert(string descTableName, DataTable dt)
        {
            string constr = this.SqlMap.DataSource.ConnectionString;
            using (SqlConnection connect = new SqlConnection(constr))
            {
                connect.Open();
                using (SqlBulkCopy bulkCopy = new SqlBulkCopy(connect))
                {
                    bulkCopy.DestinationTableName = descTableName;
                    try
                    {
                        bulkCopy.WriteToServer(dt);
                    }
                    catch (Exception ex)
                    {
                        throw new IBatisNetException("Execute Batch Insert.  Cause: " + ex.Message, ex);
                    }
                }
            }
        }
        public DataSet SelectExportSelectedTemplateByFileType(string ExportId, string FileType)
        {
            Hashtable ht = new Hashtable();
            ht.Add("ExportId", ExportId);
            ht.Add("FileType", FileType);
            return ExecuteQueryForDataSet("SelectExportSelectedTemplateByFileType", ht);
        }
        public DataSet GetContractListByDealerId(Hashtable ht)
        {
            return ExecuteQueryForDataSet("GetContractListByDealerId", ht);
        }
        public void DeleteExportVersionByExporId(string ExportId)
        {
            ExecuteDelete("DeleteExportVersionByExporId", ExportId);
        }
        public DataSet SelectExportVersionExporId(string ExporId)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectExportVersionExporId", ExporId);
            return ds;

        }

        public DataSet SelectDealerTypeExporId(string DealerID)
        {
            DataSet ds = this.ExecuteQueryForDataSet("SelectDealerTypeExporId", DealerID);
            return ds;

        }
        public void UpdateExportVersionStatusByExportId(string ExporId, string Stauts)
        {

            Hashtable ht = new Hashtable();
            ht.Add("ExportId", ExporId);
            ht.Add("VersionStatus", Stauts);
            int i = this.ExecuteUpdate("UpdateExportVersionStatusByExportId", ht);
        }
        public void UpdateExportSelectedTemplateExportId(string ExportId, string UploadFilePath, string FileName)
        {
            Hashtable ht = new Hashtable();
            ht.Add("UploadFilePath", UploadFilePath);
            ht.Add("FileName", FileName);
            ht.Add("ExportId", ExportId);
            this.ExecuteUpdate("UpdateExportSelectedTemplateExportId", ht);
        }
        public DataSet GetExportSelectedTemplateByExportId(string ExportId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("ExportId", ExportId);
            return this.ExecuteQueryForDataSet("GetExportSelectedTemplateByExportId", ht);

        }
        public DataSet SelectDealerMaster(string DealerName)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DealerName", DealerName);
            if (string.IsNullOrEmpty(DealerName))
            {
                return this.ExecuteQueryForDataSet("SelectDealerMasterALL", ht);
            }
            else
            {
                return this.ExecuteQueryForDataSet("SelectDealerMaster1", ht);
            }
           

        }
        public DataSet SelectDealerType(string ID)
        {
            Hashtable ht = new Hashtable();
            ht.Add("ID", ID);
            return this.ExecuteQueryForDataSet("SelectDealerType1", ht);

        }
        public DataSet GetSingStatusList(string DictType)
        {
            return this.ExecuteQueryForDataSet("GetSingStatusList", DictType);
        }
        public DataSet GetProductLineRelation(Hashtable ht)
        {
            return this.ExecuteQueryForDataSet("GetProductLineRelation", ht);
        }

        public DataSet GetReadTemplate(Hashtable ht)
        {
            DataSet ds = this.ExecuteQueryForDataSet("GetReadTemplate", ht);

            return ds;
        }
        public DataTable IsReadFile(Hashtable obj)
        {
            DataTable ds = this.ExecuteQueryForDataSet("SelectReadFile", obj).Tables[0];
            return ds;
        }
        public void InsertDetail(Hashtable tb)
        {
            this.ExecuteInsert("InsertDetail", tb);

        }

        public DataTable QueryDealerTrainingByDealerId(Hashtable table)
        {
            DataSet ds = base.ExecuteQueryForDataSet("QueryDealerTrainingByDealerId", table);
            return ds.Tables[0];
        }

    }
}
