using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using System.IO;
using DMS.Business.MasterData;
using DMS.Model.Consignment;
using DMS.DataAccess.Consignment;

namespace DMS.Business
{
    public class ConsignmentMasterBLL : IConsignmentMasterBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public ConsignmentMaster GetConsignmentMasterKey(Guid id)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                ConsignmentMaster Mast = dao.GetObject(id);
                return Mast;
            }
           
        }

        public void InsertPurchaseOrderHeader(ConsignmentMaster obj)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                dao.Insert(obj);
            }
        }

        public DataSet SelectConsignmentMasterByFilter(Hashtable obj, int start, int limit, out int totalRowCount)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                obj.Add("OwnerIdentityType", this._context.User.IdentityType);
                obj.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
                obj.Add("OwnerId", new Guid(this._context.User.Id));
                obj.Add("OwnerCorpId", this._context.User.CorpId);
                BaseService.AddCommonFilterCondition(obj);
                DataSet ds = dao.SelectConsignmentMasterByFilter(obj,start,limit,out totalRowCount);
                return ds;
            }
        }

        public DataSet SelectConsignmentMasterById(Guid Id, int start, int limit, out int totalRowCount)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                DataSet ds = dao.SelectConsignmentMasterById(Id, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), start, limit, out totalRowCount);
                return ds;
            }
        }

        public ConsignmentMaster SelectConsignmentMasterById(Guid Id)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                ConsignmentMaster list = dao.GetObject(Id);
                return list;
            }
        }

        public bool SaveDraft(ConsignmentMaster header)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                ConsignmentMasterDao headerDao = new ConsignmentMasterDao();
                if (header.OrderStatus == PurchaseOrderStatus.Draft.ToString())
                {
                    header.UpdateUser = new Guid(_context.User.Id);
                    header.UpdateDate = DateTime.Now;

                    headerDao.Update(header);
                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        public bool Submit(ConsignmentMaster header,string DMA_ID)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                ConsignmentMasterDao headerDao = new ConsignmentMasterDao();

                PurchaseOrderBLL purchaseOrderBLL = new PurchaseOrderBLL();
                AutoNumberBLL autoNbr = new AutoNumberBLL();
                if (header.OrderStatus == ConsignmentMasterType.Draft.ToString())
                {
                   
                    header.OrderNo = autoNbr.GetNextAutoNumberForPO(new Guid(DMA_ID), OrderType.Next_PurchaseOrder, header.ProductLineId.Value, PurchaseOrderType.Consignment.ToString());
                    header.CreateUser = new Guid(this._context.User.Id);
                    header.CreateDate = DateTime.Now;
                    header.UpdateUser = new Guid(this._context.User.Id);
                    header.UpdateDate = DateTime.Now;
                    header.OrderStatus = ConsignmentType.Submit.ToString();
                    header.IsActive = true;
                    headerDao.Update(header);
                    

                    //订单操作日志
                    purchaseOrderBLL.InsertPurchaseOrderLog(header.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);


                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        public bool DeleteDraft(Guid Id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                ConsignmentMasterDao headerDao = new ConsignmentMasterDao();
                headerDao.Delete(Id);
                    
                trans.Complete();
            }
            return result;
        }

        public bool RevokeOrder(Guid id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                this.InsertPurchaseOrderLog(id, new Guid(this._context.User.Id), ConsignmentOrderType.Submitted, "撤销短期寄售规则");
                ConsignmentMasterDao headerDao = new ConsignmentMasterDao();
                headerDao.RevokeOrder(id);
                result = true;
                trans.Complete();
            }
            return result;
        }
        /// <summary>
        /// 记录订单操作
        /// </summary>
        /// <param name="header"></param>
        /// <returns></returns>
        public void InsertPurchaseOrderLog(Guid headerId, Guid userId, ConsignmentOrderType operType, string operNote)
        {
            using (PurchaseOrderLogDao dao = new PurchaseOrderLogDao())
            {
                PurchaseOrderLog log = new PurchaseOrderLog();
                log.Id = Guid.NewGuid();
                log.PohId = headerId;
                log.OperUser = userId;
                log.OperDate = DateTime.Now;
                log.OperType = operType.ToString();
                log.OperNote = operNote;
                dao.Insert(log);
            }
        }
        public bool DeleteCfns(Guid Id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                ConsignmentCfnDao cfnDao = new ConsignmentCfnDao();
                cfnDao.DeleteByCMID(Id);

                trans.Complete();
            }
            return result;
        }

        public bool DeleteCfn(Guid Id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                ConsignmentCfnDao cfnDao = new ConsignmentCfnDao();
                cfnDao.Delete(Id);

                trans.Complete();
            }
            return result;
        }

        public bool UpdateCfn(ConsignmentCfn consignmentCfn)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                ConsignmentCfnDao cfnDao = new ConsignmentCfnDao();
                cfnDao.Update(consignmentCfn);

                trans.Complete();
            }
            return result;
        }

        public ConsignmentCfn GetConsignmentCfnById(Guid id)
        {
            using (ConsignmentCfnDao dao = new ConsignmentCfnDao())
            {
                return dao.GetObject(id);
            }
        }

        public DataSet GetConsignmentCfnById(Guid id, int start, int limit, out int totalRowCount)
        {
            Hashtable table = new Hashtable();
            table.Add("CmId", id);

            using (ConsignmentCfnDao dao = new ConsignmentCfnDao())
            {
                return dao.QueryConsignmentCfnByFilter(table, start, limit, out totalRowCount);
            }
        }

        public bool AddCfn(Guid headerId, Guid productLineId, string cfnString, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            using (ConsignmentCfnDao dao = new ConsignmentCfnDao())
            {
                dao.AddMasterCfn(headerId, productLineId, cfnString, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        public bool AddCfnSet(Guid headerId,  string cfnString, string PriceType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            using (ConsignmentCfnDao dao = new ConsignmentCfnDao())
            {
                dao.AddMasterCfnSet(headerId, cfnString,PriceType, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        public bool AddPoReceipt(string ShipmentNbr, Guid UserId, out string rtnVal, out string rtnMsg)
        {
            bool result = false;
            Guid WhmId = Guid.Empty;//20191210,暂时未使用
            using (ConsignmentCfnDao dao = new ConsignmentCfnDao())
            {
                dao.PoReceipt(ShipmentNbr, WhmId, UserId, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        public DataSet SelectConsignmentMasterByealer(string CmId, int start, int limit, out int totalRowCount)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
               return dao.SelectConsignmentMasterByealer(CmId, start, limit,out totalRowCount);
            }
        }
        public DataSet QeryConsignmentMasterDealerSearch(Hashtable ht, int start, int limit, out int totalRowCount)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                return dao.QeryConsignmentMasterDealerSearch(ht, start, limit, out totalRowCount);
            }
        }
        public bool CheckedSubmit(Guid CM_ID, string ProductLineId,string name, out string rtnVal, out string rtnMsg, out string RtnRegMsg)
        {
            bool result = false;
            rtnVal = string.Empty;
            rtnMsg = string.Empty;
            RtnRegMsg = string.Empty;
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                dao.GC_ConsignmentMaster_CheckSubmit(CM_ID, ProductLineId, name, out rtnVal, out rtnMsg, out RtnRegMsg);
                result=true;
            }
            return result;
        }
        public DataSet QuqerConsignmentAuthorizationby(Hashtable ht, int start, int limit, out int totalRowCount)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                ht.Add("OwnerIdentityType", this._context.User.IdentityType);
                ht.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
                ht.Add("OwnerId", new Guid(this._context.User.Id));
                ht.Add("OwnerCorpId", this._context.User.CorpId);
                BaseService.AddCommonFilterCondition(ht);
                DataSet ds = dao.QuqerConsignmentAuthorizationby(ht, start, limit, out totalRowCount);
                return ds;
            }

        }
        public DataSet GetConsignmentMasterAll(string status)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                DataSet ds = dao.SelectConsignmentMasterAllby(status);
                return ds;
            }
        }
        public DataSet GetDelareProductLineby(string DmaId)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                DataSet ds = dao.GetDelareProductLineby(DmaId);
                return ds;
            }
        }
        public DataSet GetProductLineConsignmenby(string ProductLineId,string DMAID)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                DataSet ds = dao.GetProductLineConsignmenby(ProductLineId, DMAID);
                return ds;
            }
        }
        public bool InsertConsignmentAuthorizationby(Hashtable ht)
        {
            bool result = false;
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                dao.InsertConsignmentAuthorizationby(ht);
                result = true;
            }
            return result;
        }
        public bool UpdateConsignmentAuthorizationby(Hashtable ht)
        {
            bool result = false;
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                dao.UpdateConsignmentAuthorizationby(ht);
                result = true;
            }
            return result;
        }
        public DataSet SelecConsignmentAuthorizationby(string CAID)
        {
         
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
              DataSet ds =dao.SelecConsignmentAuthorizationby(CAID);
              return ds;
            }
            
        }
        public bool Updatstopby(string CAID)
        {
            bool result = false;
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                dao.Updatstopby(CAID);
                result = true;
            }
            return result;
        }
        public bool Updatrecoveryby(string CAID)
        {
            bool result = false;
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                dao.Updatrecoveryby(CAID);
                result = true;
            }
            return result;
        }
        public DataSet SelecConsignmentdatetimeby(Hashtable ht)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                DataSet ds = dao.SelecConsignmentdatetimeby(ht);
                return ds;
            }
        }
        public bool DeleteConsignmentDealerby(string CMID)
        {
            bool result = false;
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                dao.DeleteConsignmentDealerby(CMID);
                result = true;
            }
            return result;
        }
        public DataSet SelecConsignmentAuthorizationCount(Hashtable tb)
        {
            using (ConsignmentMasterDao dao = new ConsignmentMasterDao())
            {
                DataSet ds = dao.SelecConsignmentAuthorizationCount(tb);
                return ds;
            }
        }
        //查询寄售合同
        public ContractHeaderPO GetContractHeaderPOById(Guid Id)
        {
            using (ContractHeaderDao dao = new ContractHeaderDao())
            {
                ContractHeaderPO ds = dao.SelectById(Id);
                return ds;
            }
        }
    }
}
