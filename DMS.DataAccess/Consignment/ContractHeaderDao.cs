using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;
using DMS.Model.Consignment;

namespace DMS.DataAccess.Consignment
{
    public class ContractHeaderDao : BaseSqlMapDao
    {

        public ContractHeaderDao()
            : base()
        {
        }

        public DataTable QueryDealer(Hashtable obj)
        {
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.SelectDealer", obj).Tables[0];
            return ds;
        }

        //public DataTable QueryBu(Hashtable obj)
        //{
        //    DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.SelectBu", obj).Tables[0];
        //    return ds;
        //}

        public DataTable QueryUPN(string Bu,string Dealer,string QryFilter)
        {
            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("DealerId", Dealer);
            ConsignContract.Add("ProductLineId", Bu);
            ConsignContract.Add("Filter", QryFilter);
            //ConsignContract.Add("cfnType", cfnType);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.SelectUPN", ConsignContract).Tables[0];
            return ds;
        }

        public DataTable QuerySet(string Bu, string Dealer, string QryFilter)
        {
            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("DealerId", Dealer);
            ConsignContract.Add("ProductLineId", Bu);
            ConsignContract.Add("Filter", QryFilter);
          
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.SelectSet", ConsignContract).Tables[0];
            return ds;
        }

        public DataTable QueryConsignContractType(string ConsignContractType)
        {
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.SelectConsignContractType", ConsignContractType).Tables[0];
            return ds;
        }
        public DataTable SelectConsignContractList(String QryBu, String QryContractNo, String QryDealer, String QryDiscountRule, String QryHasUpn, String QryIsAuto, String QryStatus, String StartDate, String EndDate, Guid? DealerID, string SubCompanyId, string BrandId)
        {
            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("QryBu", QryBu);
            ConsignContract.Add("QryContractNo", QryContractNo);
            ConsignContract.Add("QryDealer", QryDealer);
            ConsignContract.Add("QryDiscountRule", QryDiscountRule);
            ConsignContract.Add("QryHasUpn", QryHasUpn);
            ConsignContract.Add("QryIsAuto", QryIsAuto);
            ConsignContract.Add("QryStatus", QryStatus);
            ConsignContract.Add("StartDate", StartDate);
            ConsignContract.Add("EndDate", EndDate);
            ConsignContract.Add("DealerID", DealerID);
            ConsignContract.Add("SubCompanyId", SubCompanyId);
            ConsignContract.Add("BrandId", BrandId);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.SelectConsignContractList", ConsignContract).Tables[0];
            return ds;
        }

        public void InsertConsignContractInfoSave(Guid ID,String IptConsignmentDay, String StartDate, String EndDate, String IptDealer, string IptDelayNumber, bool IptIsFixedMoney, bool IptIsFixedQty, bool IptIsKB, bool IptIsUseDiscount, string IptProductLine, string IptRemark, string IptStatus,string UserID,string ContractName)
        {
            ContractHeaderPO ContractHeader = new ContractHeaderPO();
            ConsignCommonDao consignCommonDao = new ConsignCommonDao();
            ContractHeader.CCH_ID = ID;
            ContractHeader.CCH_ConsignmentDay =Convert.ToInt32(IptConsignmentDay);
            ContractHeader.CCH_BeginDate =Convert.ToDateTime(StartDate);
            ContractHeader.CCH_EndDate = Convert.ToDateTime(EndDate);
            ContractHeader.CCH_DMA_ID = new Guid(IptDealer);
            ContractHeader.CCH_DelayNumber = Convert.ToInt32(IptDelayNumber);
            ContractHeader.CCH_IsFixedMoney = IptIsFixedMoney;
            ContractHeader.CCH_IsFixedQty = IptIsFixedQty;
            ContractHeader.CCH_IsKB = IptIsKB;
            ContractHeader.CCH_IsUseDiscount = IptIsUseDiscount;
            ContractHeader.CCH_ProductLine_BUM_ID =new Guid(IptProductLine);
            ContractHeader.CCH_Remark = IptRemark;
            ContractHeader.CCH_Status = "Draft";
            ContractHeader.CCH_CreateUser = new Guid(UserID);
            ContractHeader.CCH_No =consignCommonDao.ProcGetNextAutoNumber(null,new Guid(IptProductLine), "CASTC", "ContractHeader");
            //ContractHeader.CCH_No = this.GetNextAutoNumberForPromotion(GetBuDivisionName(IptProductLine), "CASTC", "ContractHeader");
            ContractHeader.CCH_Name = ContractName;
            this.ExecuteInsert("Consignment.ContractHeader.Insert", ContractHeader);
        }
        public void InsertConsignContractInfoSubmit(Guid ID, String IptConsignmentDay, String StartDate, String EndDate, String IptDealer, string IptDelayNumber, bool IptIsFixedMoney, bool IptIsFixedQty, bool IptIsKB, bool IptIsUseDiscount, string IptProductLine, string IptRemark, string IptStatus, string UserID, string ContractName)
        {
            ContractHeaderPO ContractHeader = new ContractHeaderPO();
            ConsignCommonDao consignCommonDao = new ConsignCommonDao();
            ContractHeader.CCH_ID = ID;
            ContractHeader.CCH_ConsignmentDay = Convert.ToInt32(IptConsignmentDay);
            ContractHeader.CCH_BeginDate = Convert.ToDateTime(StartDate);
            ContractHeader.CCH_EndDate = Convert.ToDateTime(EndDate);
            ContractHeader.CCH_DMA_ID =new Guid(IptDealer);
            ContractHeader.CCH_DelayNumber = Convert.ToInt32(IptDelayNumber);
            ContractHeader.CCH_IsFixedMoney = IptIsFixedMoney;
            ContractHeader.CCH_IsFixedQty = IptIsFixedQty;
            ContractHeader.CCH_IsKB = IptIsKB;
            ContractHeader.CCH_IsUseDiscount = IptIsUseDiscount;
            ContractHeader.CCH_ProductLine_BUM_ID =new Guid(IptProductLine);
            ContractHeader.CCH_Remark = IptRemark;
            ContractHeader.CCH_Status = "InApproval";
            ContractHeader.CCH_CreateUser = new Guid(UserID);
            ContractHeader.CCH_No = consignCommonDao.ProcGetNextAutoNumber(null, new Guid(IptProductLine), "CASTC", "ContractHeader");
            ContractHeader.CCH_Name = ContractName;
            this.ExecuteInsert("Consignment.ContractHeader.Insert", ContractHeader);
        }

        public void UpateConsignContractInfoSubmit(Guid ID, String IptConsignmentDay, String StartDate, String EndDate, String IptDealer, string IptDelayNumber, bool IptIsFixedMoney, bool IptIsFixedQty, bool IptIsKB, bool IptIsUseDiscount, string IptProductLine, string IptRemark, string IptStatus, string UserID, string ContractName)
        {
            ContractHeaderPO ContractHeader = new ContractHeaderPO();
            ContractHeader.CCH_ID = ID;
            ContractHeader.CCH_ConsignmentDay = Convert.ToInt32(IptConsignmentDay);
            ContractHeader.CCH_BeginDate = Convert.ToDateTime(StartDate);
            ContractHeader.CCH_EndDate = Convert.ToDateTime(EndDate);
            ContractHeader.CCH_DMA_ID =new Guid(IptDealer);
            ContractHeader.CCH_DelayNumber = Convert.ToInt32(IptDelayNumber);
            ContractHeader.CCH_IsFixedMoney = IptIsFixedMoney;
            ContractHeader.CCH_IsFixedQty = IptIsFixedQty;
            ContractHeader.CCH_IsKB = IptIsKB;
            ContractHeader.CCH_IsUseDiscount = IptIsUseDiscount;
            ContractHeader.CCH_ProductLine_BUM_ID =new Guid(IptProductLine);
            ContractHeader.CCH_Remark = IptRemark;
            ContractHeader.CCH_Status = "InApproval";
            ContractHeader.CCH_CreateUser = new Guid(UserID);
            ContractHeader.CCH_Name = ContractName;
            ContractHeader.CCH_CreateDate = DateTime.Now;
            this.ExecuteUpdate("Consignment.ContractHeader.Update", ContractHeader);

        }

        public void UpateConsignContractInfoSave(Guid ID, String IptConsignmentDay, String StartDate, String EndDate, String IptDealer, string IptDelayNumber, bool IptIsFixedMoney, bool IptIsFixedQty, bool IptIsKB, bool IptIsUseDiscount, string IptProductLine, string IptRemark, string IptStatus, string UserID, string ContractName)
        {
            ContractHeaderPO ContractHeader = new ContractHeaderPO();
            ContractHeader.CCH_ID = ID;
            ContractHeader.CCH_ConsignmentDay = Convert.ToInt32(IptConsignmentDay);
            ContractHeader.CCH_BeginDate = Convert.ToDateTime(StartDate);
            ContractHeader.CCH_EndDate = Convert.ToDateTime(EndDate);
            ContractHeader.CCH_DMA_ID = new Guid(IptDealer);
            ContractHeader.CCH_DelayNumber = Convert.ToInt32(IptDelayNumber);
            ContractHeader.CCH_IsFixedMoney = IptIsFixedMoney;
            ContractHeader.CCH_IsFixedQty = IptIsFixedQty;
            ContractHeader.CCH_IsKB = IptIsKB;
            ContractHeader.CCH_IsUseDiscount = IptIsUseDiscount;
            ContractHeader.CCH_ProductLine_BUM_ID = new Guid(IptProductLine);
            ContractHeader.CCH_Remark = IptRemark;
            ContractHeader.CCH_Status = "Draft";
            
            ContractHeader.CCH_Name = ContractName;
            ContractHeader.CCH_CreateUser =new Guid(UserID);
            ContractHeader.CCH_CreateDate = DateTime.Now;
            this.ExecuteUpdate("Consignment.ContractHeader.Update", ContractHeader);

        }


        public string GetBuDivisionName(string ProductLineID)
        {
            Hashtable BuDivisionName = new Hashtable();

            BuDivisionName.Add("ProductLineID", ProductLineID);

            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.GetBuDivisionName", BuDivisionName).Tables[0];
            if (ds.Rows.Count>0) {
                return ds.Rows[0]["DivisionName"].ToString();
            }
            return "";
        }

        public string GetNextAutoNumberForPromotion(string deptcode, string clientid, string strSettings)
        {
            using (ContractHeaderDao policyDao = new ContractHeaderDao())
            {
                string strNextAutoNumber = "";
                Hashtable ht = new Hashtable();
                ht.Add("DeptCode", deptcode);
                ht.Add("ClientID", clientid);
                ht.Add("Settings", strSettings);
                ht.Add("nextnbr", strNextAutoNumber);
                this.ExecuteInsert("Consignment.ContractHeader.SelectNextAutoNumberForPromotion", ht);
                strNextAutoNumber = ht["nextnbr"].ToString();
                return strNextAutoNumber;
            }
        }


        public DataTable QueryContractHeader(string ContractId)
        {

            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("ContractId", ContractId);

            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.SelectContractHeader", ConsignContract).Tables[0];
            return ds;
        }
        public DataTable QueryContractHeaderAll(string ContractId)
        {

            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("ContractId", ContractId);

            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.SelectContractHeaderAll", ConsignContract).Tables[0];
            return ds;
        }
        public DataTable SelectContractInfo(string CCH_ID)
        {
            Hashtable condition = new Hashtable();
            condition.Add("CCH_ID", CCH_ID);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.SelectContractInfo", condition).Tables[0];
            return ds;

        }

        public ContractHeaderPO SelectById(Guid id)
        {
            return this.ExecuteQueryForObject<ContractHeaderPO>("Consignment.ContractHeader.SelectById", id);
        }

        public IList<Hashtable> SelectActiveList(Guid bu, Guid dealerId)
        {
            Hashtable condition = new Hashtable();
            condition.Add("Bu", bu);
            condition.Add("DealerId", dealerId);
            return this.ExecuteQueryForList<Hashtable>("Consignment.ContractHeader.SelectActiveList", condition);
        }

        public int Delete(Guid objKey)
        {
            int cnt = (int)this.ExecuteDelete("Consignment.ContractHeader.Delete", objKey);
            return cnt;
        }

        public String GetNumber(Guid ID)
        {
            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("ID", ID);
            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.GetNumber", ConsignContract).Tables[0];
            return ds.Rows.Count > 0 ? ds.Rows[0]["CCH_No"].ToString() : null;
        }

        public string UPNCheck(Hashtable tb)
        {

            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractHeader.UPNCheck", tb).Tables[0];
            return ds.Rows.Count > 0 ? ds.Rows[0][0].ToString(): "";
        }


    }
}
