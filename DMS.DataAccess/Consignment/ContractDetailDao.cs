using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;
using DMS.Model.Consignment;

namespace DMS.DataAccess.Consignment
{
    public class ContractDetailDao : BaseSqlMapDao
    {

        public ContractDetailDao()
            : base()
        {
        }

        public void InsertConsignmentContractDetail(Guid DMA_ID, ArrayList CfnShortNumber, ArrayList Type)
        {
            ContractDetailPO ContractDetailPO = new ContractDetailPO();
            //ContractDetail.CCH_ID = ID;
            for (int i = 0; i < CfnShortNumber.Count; i++)
            {
                ContractDetailPO.CCH_ID = Guid.NewGuid();
                ContractDetailPO.CCD_CCH_ID = DMA_ID;
                ContractDetailPO.CCD_CfnShortNumber = CfnShortNumber[i].ToString();
                ContractDetailPO.CCD_CfnType = Type[i].ToString();
                this.ExecuteInsert("Consignment.ContractDetail.Insert", ContractDetailPO);
            }
        }

        public DataTable QueryConsignmentContractDetail(string ID)
        {
            Hashtable ConsignContract = new Hashtable();
            ConsignContract.Add("CCD_CCH_ID", ID);

            DataTable ds = this.ExecuteQueryForDataSet("Consignment.ContractDetail.QueryConsignmentContractDetail", ConsignContract).Tables[0];
            return ds;
        }

        public int Delete(Guid CCD_CCH_ID)
        {
            int cnt = (int)this.ExecuteDelete("Consignment.ContractDetail.Delete", CCD_CCH_ID);
            return cnt;
        }

        public IList<Hashtable> SelectContractUpnList(Guid contractId, Guid dealerId, String filter, string SubCompany, string Brand)
        {
            Hashtable condition = new Hashtable();
            condition.Add("ContractId", contractId);
            condition.Add("DealerId", dealerId);
            condition.Add("Filter", filter);
            condition.Add("SubCompanyId", SubCompany);
            condition.Add("BrandId", Brand);

            return this.ExecuteQueryForList<Hashtable>("Consignment.ContractDetail.SelectContractUpnList", condition);
        }

        public IList<Hashtable> SelectContractUpnPrice(Guid dealerId, IList<String> upnList, string SubCompanyId, string BrandId)
        {
            Hashtable condition = new Hashtable();
            condition.Add("DealerId", dealerId);
            condition.Add("UpnList", upnList);
            condition.Add("SubCompanyId", SubCompanyId);
            condition.Add("BrandId", BrandId);

            return this.ExecuteQueryForList<Hashtable>("Consignment.ContractDetail.SelectContractUpnPrice", condition);
        }


        public IList<Hashtable> SelectContractSetPrice(Guid dealerId, IList<String> setList)
        {
            Hashtable condition = new Hashtable();
            condition.Add("DealerId", dealerId);
            condition.Add("SetList", setList);

            return this.ExecuteQueryForList<Hashtable>("Consignment.ContractDetail.SelectContractSetPrice", condition);
        }


        public IList<Hashtable> SelectUPN(Guid BU, Guid dealerId, IList<String> upnList)
        {
            Hashtable condition = new Hashtable();
            condition.Add("BU", BU);
            condition.Add("DealerId", dealerId);
            condition.Add("UpnList", upnList);

            return this.ExecuteQueryForList<Hashtable>("Consignment.ContractDetail.SelectUPN", condition);
        }
        public IList<Hashtable> SelectSet(Guid BU, Guid dealerId, IList<String> LstSet)
        {
            Hashtable condition = new Hashtable();
            condition.Add("BU", BU);
            condition.Add("DealerId", dealerId);
            condition.Add("SetList", LstSet);

            return this.ExecuteQueryForList<Hashtable>("Consignment.ContractDetail.SelectSet", condition);
        }

        public IList<Hashtable> SelectProductDetail(Guid BU, Guid dealerId, string ID)
        {
            Hashtable condition = new Hashtable();
            condition.Add("BU", BU);
            condition.Add("DealerId", dealerId);
            condition.Add("ID", ID);

            return this.ExecuteQueryForList<Hashtable>("Consignment.ContractDetail.SelectProductDetail", condition);
        }
    }
}
