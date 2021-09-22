using System;
using System.Collections;
using System.Collections.Generic;
using IBatisNet.DataMapper;
using DMS.Model;
using System.Data;
using DMS.Model.Consignment;

namespace DMS.DataAccess.Consignment
{
    public class TransferDetailDao : BaseSqlMapDao
    {
        public TransferDetailDao()
            : base()
        {
        }

        #region Select

        public IList<Hashtable> SelectByHeadId(Guid headId, string SubCompanyId, string BrandId)
        {
            Hashtable detail = new Hashtable();
            detail.Add("TD_TH_ID", headId.ToString());
            detail.Add("SubCompanyId", SubCompanyId);
            detail.Add("BrandId", BrandId);
            return base.ExecuteQueryForList<Hashtable>("Consignment.TransferDetailMap.SelectByHeadId", detail);
        }

        public IList<Hashtable> SelectForConfirmByHeadId(Guid headId)
        {
            return base.ExecuteQueryForList<Hashtable>("Consignment.TransferDetailMap.SelectForConfirmByHeadId", headId);
        }

        #endregion

        #region Insert

        public void Insert(TransferDetailPO obj)
        {
            base.ExecuteInsert("Consignment.TransferDetailMap.Insert", obj);
        }

        #endregion

        #region Update

        #endregion

        #region Delete

        public void DeleteByHeadId(Guid headId)
        {
            base.ExecuteDelete("Consignment.TransferDetailMap.DeleteByHeadId", headId);
        }

        #endregion

        #region Procdure

        #endregion
    }
}
