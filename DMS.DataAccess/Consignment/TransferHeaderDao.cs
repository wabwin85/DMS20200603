using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;
using DMS.Model.Consignment;

namespace DMS.DataAccess.Consignment
{
    public class TransferHeaderDao : BaseSqlMapDao
    {
        public TransferHeaderDao()
            : base()
        {
        }

        #region Select

        public TransferHeaderPO SelectById(Guid id)
        {
            return base.ExecuteQueryForObject<TransferHeaderPO>("Consignment.TransferHeaderMap.SelectById", id);
        }

        public IList<Hashtable> SelectByCondition(String TransferType, bool IsDealer, Guid? DealerId, Guid? ProductLine, String TransferNo, String TransferStatus, String Dealer, String Upn, string SubCompanyId, string BrandId)
        {
            Hashtable condition = new Hashtable();
            condition.Add("TransferType", TransferType);
            condition.Add("IsDealer", IsDealer ? "True" : "False");
            condition.Add("DealerId", DealerId);
            condition.Add("ProductLine", ProductLine);
            condition.Add("TransferNo", TransferNo);
            condition.Add("TransferStatus", TransferStatus);
            condition.Add("Dealer", Dealer);
            condition.Add("Upn", Upn);
            condition.Add("SubCompanyId", SubCompanyId);
            condition.Add("BrandId", BrandId);
            return base.ExecuteQueryForList<Hashtable>("Consignment.TransferHeaderMap.SelectByCondition", condition);
        }

        #endregion

        #region Insert

        public void Insert(TransferHeaderPO obj)
        {
            base.ExecuteInsert("Consignment.TransferHeaderMap.Insert", obj);
        }

        #endregion

        #region Update

        public void Update(TransferHeaderPO obj)
        {
            base.ExecuteUpdate("Consignment.TransferHeaderMap.Update", obj);
        }

        public void UpdateStatus(Guid id, String status)
        {
            TransferHeaderPO obj = new TransferHeaderPO();
            obj.TH_ID = id;
            obj.TH_Status = status;
            base.ExecuteUpdate("Consignment.TransferHeaderMap.UpdateStatus", obj);
        }

        #endregion

        #region Delete

        #endregion

        #region Procdure

        #endregion
    }
}
