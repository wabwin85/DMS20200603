using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;
using DMS.Model.Consignment;

namespace DMS.DataAccess.Consignment
{
    public class ConsignmentTerminationDao : BaseSqlMapDao
    {
        public ConsignmentTerminationDao()
            : base()
        {
        }



        public DataTable SelectConsignTerminationList(string QryTerminationNo, string QryStatus, string QryContractNo, Guid? DealerID, string SubCompanyId, string BrandId)
        {

            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("CST_NO", QryTerminationNo);
            ConsignContract.Add("CST_Status", QryStatus);
            ConsignContract.Add("CCH_NO", QryContractNo);
            ConsignContract.Add("DealerID", DealerID);
            ConsignContract.Add("SubCompanyId", SubCompanyId);
            ConsignContract.Add("BrandId", BrandId);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignmentTermination.SelectConsignmentTerminationList", ConsignContract).Tables[0];
            return ds;
        }




        public void InsertConsignmentTerminationSubmit(string ID,string ContractID,string CST_Reason,string CST_Remark,string CST_CreateUser,string CST_CreateDate,Guid Bu)
        {
            ConsignmentTerminationPO ConsignmentTermination = new ConsignmentTerminationPO();
            ConsignCommonDao consignCommonDao = new ConsignCommonDao();
            ConsignmentTermination.CST_ID = ID;
            ConsignmentTermination.CST_CCH_ID = ContractID;
            ConsignmentTermination.CST_No = consignCommonDao.ProcGetNextAutoNumber(null, Bu, "CST", "ConsignmentTermination");
            ConsignmentTermination.CST_Status = "Termination";
            ConsignmentTermination.CST_Reason = CST_Reason;
            ConsignmentTermination.CST_Remark = CST_Remark;
            ConsignmentTermination.CST_CreateUser = CST_CreateUser;
            ConsignmentTermination.CST_CreateDate = CST_CreateDate;
            this.ExecuteInsert("Consignment.ConsignmentTermination.Insert", ConsignmentTermination);
            
            
        }


        public void InsertConsignmentTerminationSave(string ID, string ContractID, string CST_Reason, string CST_Remark, string CST_CreateUser, string CST_CreateDate,Guid Bu)
        {
            ConsignmentTerminationPO ConsignmentTermination = new ConsignmentTerminationPO();
            ConsignCommonDao consignCommonDao = new ConsignCommonDao();
            ConsignmentTermination.CST_ID = ID;
            ConsignmentTermination.CST_CCH_ID = ContractID;
            ConsignmentTermination.CST_No = consignCommonDao.ProcGetNextAutoNumber(null, Bu, "CST", "ConsignmentTermination");
            ConsignmentTermination.CST_Reason = CST_Reason;
            ConsignmentTermination.CST_Status = "Draft";
            ConsignmentTermination.CST_Remark = CST_Remark;
            ConsignmentTermination.CST_CreateUser = CST_CreateUser;
            ConsignmentTermination.CST_CreateDate = CST_CreateDate;

            this.ExecuteInsert("Consignment.ConsignmentTermination.Insert", ConsignmentTermination);
           
        }

        public void UpdateConsignmentTerminationSubmit(string ID, string ContractID, string CST_Reason, string CST_Remark, string CST_CreateUser, string CST_CreateDate)
        {
            ConsignmentTerminationPO ConsignmentTermination = new ConsignmentTerminationPO();

            ConsignmentTermination.CST_ID = ID;
            ConsignmentTermination.CST_CCH_ID = ContractID;
            //ConsignmentTermination.CST_No = this.GetNextAutoNumberForTermination(GetBuDivisionName(ContractID), "CST", "ConsignmentTermination");
            ConsignmentTermination.CST_Reason = CST_Reason;
            ConsignmentTermination.CST_Status = "Termination";
            ConsignmentTermination.CST_Remark = CST_Remark;
            ConsignmentTermination.CST_CreateUser = CST_CreateUser;
            ConsignmentTermination.CST_CreateDate = CST_CreateDate;
            this.ExecuteUpdate("Consignment.ConsignmentTermination.Update", ConsignmentTermination);
        }

        public void UpdateConsignmentTerminationSave(string ID, string ContractID, string CST_Reason, string CST_Remark, string CST_CreateUser, string CST_CreateDate)
        {
            ConsignmentTerminationPO ConsignmentTermination = new ConsignmentTerminationPO();

            ConsignmentTermination.CST_ID = ID;
            ConsignmentTermination.CST_CCH_ID = ContractID;
            //ConsignmentTermination.CST_No = this.GetNextAutoNumberForTermination(GetBuDivisionName(ContractID), "CST", "ConsignmentTermination");
            ConsignmentTermination.CST_Reason = CST_Reason;
            ConsignmentTermination.CST_Status = "Draft";
            ConsignmentTermination.CST_Remark = CST_Remark;
            ConsignmentTermination.CST_CreateUser = CST_CreateUser;
            ConsignmentTermination.CST_CreateDate = CST_CreateDate;

            this.ExecuteUpdate("Consignment.ConsignmentTermination.Update", ConsignmentTermination);

        }
        public string GetBuDivisionName(string ContractID)
        {
            Hashtable BuDivisionName = new Hashtable();

            BuDivisionName.Add("CCH_ID", ContractID);

            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignmentTermination.GetBuDivisionName", BuDivisionName).Tables[0];
            if (ds.Rows.Count > 0)
            {
                return ds.Rows[0]["DivisionName"].ToString();
            }
            return "";
        }

        public string GetNextAutoNumberForTermination(string deptcode, string clientid, string strSettings)
        {
            using (ContractHeaderDao policyDao = new ContractHeaderDao())
            {
                string strNextAutoNumber = "";
                Hashtable ht = new Hashtable();
                ht.Add("DeptCode", deptcode);
                ht.Add("ClientID", clientid);
                ht.Add("Settings", strSettings);
                ht.Add("nextnbr", strNextAutoNumber);
                this.ExecuteInsert("Consignment.ConsignmentTermination.SelectNextAutoNumberForTermination", ht);
                strNextAutoNumber = ht["nextnbr"].ToString();
                return strNextAutoNumber;
            }
        }

        public DataTable SelectConsignTerminationInfo(string TerminationID)
        {

            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("TerminationID", TerminationID);
           

            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignmentTermination.SelectConsignTerminationInfo", ConsignContract).Tables[0];
            return ds;
        }


        public int Delete(Guid CST_ID)
        {
            int cnt = (int)this.ExecuteDelete("Consignment.ConsignmentTermination.Delete", CST_ID);
            return cnt;
        }

        public String GetNumber(Guid ID)
        {
            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("ID", ID);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ConsignmentTermination.GetNumber", ConsignContract).Tables[0];
            return ds.Rows.Count > 0 ? ds.Rows[0]["CST_No"].ToString() : null;
        }

    }
}
