using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;
using DMS.Model.Consignment;

namespace DMS.DataAccess.Consignment
{
    public class TransferConfirmDao : BaseSqlMapDao
    {
        public TransferConfirmDao()
            : base()
        {
        }

        #region Select

        public IList<Hashtable> SelectInventoryList(Guid upnId, Guid dealerId)
        {
            Hashtable condition = new Hashtable();
            condition.Add("UpnId", upnId);
            condition.Add("DealerId", dealerId);
            return base.ExecuteQueryForList<Hashtable>("Consignment.TransferConfirmMap.SelectInventoryList", condition);
        }

        public IList<Hashtable> SelectConfirmedList(Guid transferHeadId)
        {
            return base.ExecuteQueryForList<Hashtable>("Consignment.TransferConfirmMap.SelectConfirmedList", transferHeadId);
        }

        #endregion

        #region Insert

        public void Insert(TransferConfirmPO obj)
        {
            base.ExecuteInsert("Consignment.TransferConfirmMap.Insert", obj);
        }

        #endregion

        #region Update

        #endregion

        #region Delete

        #endregion

        #region Procdure

        #endregion
    }
}
