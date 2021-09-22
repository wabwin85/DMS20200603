using DMS.DataAccess;
using DMS.Model;
using System.Collections;
using System.Data;
using Lafite.RoleModel.Security.Authorization;
using Lafite.RoleModel.Security;
using System;
using Grapecity.DataAccess.Transaction;

namespace DMS.Business.Contract
{
    public class ContractAmendmentService : IContractAmendmentService
    {
        public ContractAmendment GetContractAmendmentByID(Guid camId)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.GetObject(camId);
            }
        }

        public int UpdateAmendmentCmidByConid(Hashtable obj)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.UpdateAmendmentCmidByConid(obj);
            }
        }

        public DataSet SelectAmendmentMain(Hashtable table)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.SelectAmendmentMain(table);
            }
        }
        public DataSet SelectAmendmentProposals(Hashtable table)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.SelectAmendmentProposals(table);
            }
        }
        public string CheckAttachmentUpload(Hashtable table)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.CheckAttachmentUpload(table);
            }
        }
        public bool SaveAmendmentUpdate (AmendmentMainTemp main, AmendmentProposalsTemp proposals)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                ContractAmendmentDao headerDao = new ContractAmendmentDao();

                //为维护主信息到临时表
                headerDao.InsertAmendmentMainTemp(main);
                //维护修改信息到临时表
                headerDao.InsertAmendmentProposalsTemp(proposals);
                //调用存储过程对现有合同备份 维护正式表
                headerDao.AmendmentInitialize(main.TempId.ToString(),"Amendment");
                result = true;
                trans.Complete();
            }
            return result;
        }
        public DataSet GetUpdatelog(string contractid, int start, int limit, out int totalRowCount)
        {
            Hashtable table = new Hashtable();
            table.Add("ContractId", contractid);
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.GetUpdatelog(table, start, limit, out totalRowCount);
            }
        }
        public void TerritoryEditorInitAdmin(Hashtable table)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                dao.TerritoryEditorInitAdmin(table);
            }
        }
        public DataSet AuthorizationProductSelectedAdmin(Hashtable table)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.AuthorizationProductSelectedAdmin(table);
            }
        }
        public void AddContractProductAdmin(Hashtable table)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                dao.AddContractProductAdminItem(table);
            }
        }
        public DataSet GetProductHospitalSeletedAdmin(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.GetProductHospitalSeletedAdmin(table, start, limit, out totalRowCount);
            }
        }
        public bool DeleteProductSelectedAdmin(Hashtable table)
        {
            bool massage = false;
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                dao.DeleteProductSelectedAdmin(table);
                DeleteHospitalAOPTempAdmin(table);
                massage = true;
            }
            return massage;
        }

        public void DeleteHospitalAOPTempAdmin(Hashtable table)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                dao.DeleteHospitalAOPTempAdmin(table);
            }
        }
        public void DeleteDealerAOPTempAdmin(Hashtable table)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                dao.DeleteDealerAOPTempAdmin(table);
            }
        }
        public void DeleteAuthorizationHospitalTempAdmin(Guid[] changes, string tempid)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                ContractAmendmentDao dao = new ContractAmendmentDao();

                foreach (Guid item in changes)
                {
                    dao.DeleteAuthorizationHospitalTempAdmin(item, tempid);
                }
                trans.Complete();
            }
        }
        public DataSet GetCopyProductCanAdmin(Hashtable obj)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.GetCopyProductCanAdmin(obj);
            }
        }
        public int CopyHospitalTempFromOtherAuthAdmin(Hashtable obj)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.CopyHospitalTempFromOtherAuthAdmin(obj);
            }
        }
        public void AddProductHospitalAdmin(Hashtable obj)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                dao.AddProductHospitalAdmin(obj);
            }
        }
        public DataSet SelectHospitalProductAOPAdmin(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.SelectHospitalProductAOPAdmin(table, start, limit, out totalRowCount);
            }
        }
        public DataSet SelectHospitalProductAOPAdmin(Hashtable table)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.SelectHospitalProductAOPAdmin(table);
            }
        }
        public DataSet SelectDealerAOPAdmin(Hashtable obj)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.SelectDealerAOPAdmin(obj);
            }
        }
        public void AOPEditorInitAdmin(Hashtable obj)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                dao.AOPEditorInitAdmin(obj);
            }
        }
        public void SaveHospitalAopAdmin(Hashtable obj)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                dao.SaveHospitalAopAdmin(obj);
            }
        }
        public void SaveDealerAopAdmin(Hashtable obj)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                dao.SaveDealerAopAdmin(obj);
            }
        }
        public DataSet GetContractAttachmentAdmin(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.GetContractAttachmentAdmin(table, start, limit, out totalRowCount);
            }
        }
        public DataSet GetContractAttachmentAdmin(Hashtable table)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                return dao.GetContractAttachmentAdmin(table);
            }
        }
        public void UploadContractAttachment(Hashtable obj)
        {
            using (ContractAmendmentDao dao = new ContractAmendmentDao())
            {
                dao.UploadContractAttachment(obj);
            }
        }
    }
}
