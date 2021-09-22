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
using DMS.Business.MasterData;
using DMS.Business.DataInterface;
using System.Net;
using System.Xml;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;
using Newtonsoft.Json.Linq;
using DMS.Business.ERPInterface;
using DMS.DataAccess.EKPWorkflow;

namespace DMS.Business
{
    public class InventoryAdjustBLL : IInventoryAdjustBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        private IClientBLL _clientBLL = new ClientBLL();
        private kmReviewWebserviceBLL ekpBll = new kmReviewWebserviceBLL();

        #region Action Define
        public const string Action_DealerAdj = "DealerAdj";
        public const string Action_DealerAdjAudit = "DealerAdjAudit";
        public const string Action_InventoryAdjustConsignment = "InventoryAdjustConsignment";
        public const string Action_InventoryAdjust = "InventoryAdjust";
        public const string Action_InventoryReturn = "InventoryReturn";
        public const string Action_InventoryReturnAudit = "InventoryReturnAudit";
        #endregion

        public InventoryAdjustHeader GetInventoryAdjustById(Guid id)
        {
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.GetObject(id);
            }
        }

        public InventoryAdjustLot GetInventoryAdjustLotById(Guid id)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.GetObject(id);
            }
        }

        [AuthenticateHandler(ActionName = Action_InventoryAdjust, Description = "库存授权-其他出入库-普通仓库", Permissoin = PermissionType.Read)]
        public DataSet QueryInventoryAdjustHeader(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            string[] roles = this._context.User.Roles;

            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_InventoryAdjustConsignment, Description = "库存授权-其他出入库-寄售仓库", Permissoin = PermissionType.Read)]
        public DataSet QueryInventoryAdjustHeaderConsignment(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);

            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilterConsignment(table, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerAdjAudit, Description = "库存调整审批", Permissoin = PermissionType.Read)]
        public DataSet QueryInventoryAdjustHeaderAudit(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));

            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilterAudit(table, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_InventoryReturn, Description = "库存授权-退货申请", Permissoin = PermissionType.Read)]
        public DataSet QueryInventoryAdjustHeaderReturn(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织，退货

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilterReturn(table, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_InventoryReturnAudit, Description = "库存授权-退货审批", Permissoin = PermissionType.Read)]
        public DataSet QueryInventoryAdjustHeaderReturnAudit(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);

            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilterReturnAudit(table, start, limit, out totalRowCount);
            }
        }

        //[AuthenticateHandler(ActionName = Action_InventoryReturn, Description = "库存授权-退货申请", Permissoin = PermissionType.Read)]
        public DataSet QueryInventoryAdjustHeaderCTOS(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));

            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilterCTOS(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryInventoryAdjustHeaderAudit(Hashtable table)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));

            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilterAudit(table);
            }
        }

        public DataSet QueryIsOtherStockInAvailable(Hashtable table)
        {
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilterAudit(table);
            }
        }

        public DataSet QueryInventoryAdjustLot(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryInventoryAdjustLot(Hashtable table)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectByFilter(table);
            }
        }

        public DataSet QueryInventoryAdjustLotCTOS(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectByFilterInventoryAdjustLotCTOS(table, start, limit, out totalRowCount);
            }
        }

        public InventoryAdjustDetail GetInventoryAdjustDetailByIndex(Guid AdjustId, Guid ProductId)
        {
            using (InventoryAdjustDetailDao dao = new InventoryAdjustDetailDao())
            {
                Hashtable param = new Hashtable();
                param.Add("IahId", AdjustId);
                param.Add("PmaId", ProductId);

                IList<InventoryAdjustDetail> lines = dao.SelectByHashtable(param);

                if (lines.Count > 0)
                {
                    return lines[0];
                }
            }
            return null;
        }

        public InventoryAdjustLot GetInventoryAdjustLotByIndex(Guid LineId, Guid LotId)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                Hashtable param = new Hashtable();
                param.Add("IadId", LineId);
                param.Add("LotId", LotId);

                IList<InventoryAdjustLot> lots = dao.SelectByHashtable(param);

                if (lots.Count > 0)
                {
                    return lots[0];
                }
            }
            return null;
        }

        public IList<InventoryAdjustLot> GetInventoryAdjustLotByLineId(Guid LineId)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                Hashtable param = new Hashtable();
                param.Add("IadId", LineId);

                return dao.SelectByHashtable(param);
            }
        }

        public int GetPendingAuditCount()
        {
            int count = 0;
            Hashtable param = new Hashtable();
            param.Add("Status", AdjustStatus.Submitted.ToString());

            DataSet ds = this.QueryInventoryAdjustHeaderAudit(param);

            if (ds.Tables != null)
            {
                count = ds.Tables[0].Rows.Count;
            }

            return count;
        }

        public int IsOtherStockInAvailable(Guid UserId)
        {
            int count = 0;
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {


                DataSet ds = dao.SelectIsOtherStockInAvailable(UserId);

                if (ds.Tables != null)
                {
                    count = Int32.Parse(ds.Tables[0].Rows[0][0].ToString());
                }

            }
            return count;
        }

        public void InsertInventoryAdjustHeader(InventoryAdjustHeader obj)
        {
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                dao.Insert(obj);
            }
        }

        public void ConsignInsertInventoryAdjustHeader(InventoryAdjustHeader obj)
        {
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                dao.ConsignInsert(obj);
            }
        }

        /// <summary>
        /// 订单操作日志
        /// </summary>
        /// <param name="headerId"></param>
        /// <param name="userId"></param>
        /// <param name="operType"></param>
        /// <param name="operNote"></param>
        public void InsertPurchaseOrderLog(Guid headerId, Guid userId, PurchaseOrderOperationType operType, string operNote)
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

        public bool SaveDraft(InventoryAdjustHeader obj)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustHeaderDao mainDao = new InventoryAdjustHeaderDao();

                //判断表头中状态是否是草稿
                InventoryAdjustHeader main = mainDao.GetObject(obj.Id);
                if (main.Status == AdjustStatus.Draft.ToString())
                {
                    mainDao.Update(obj);
                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        public bool DeleteDraft(Guid id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustHeaderDao mainDao = new InventoryAdjustHeaderDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                InventoryAdjustDetailDao detailDao = new InventoryAdjustDetailDao();

                //判断表头中状态是否是草稿
                InventoryAdjustHeader main = mainDao.GetObject(id);
                if (main.Status == AdjustStatus.Draft.ToString())
                {
                    //删除lot表

                    lotDao.DeleteByAdjustId(id);
                    //删除line表

                    detailDao.DeleteByAdjustId(id);
                    //删除主表
                    mainDao.Delete(id);

                    //二级经销商寄售退货单删除InventoryAdjustConsignment表
                    if (main.WarehouseType == AdjustWarehouseType.Consignment.ToString())
                    {
                        InventoryAdjustConsignmentDao consignmentDao = new InventoryAdjustConsignmentDao();
                        consignmentDao.DeleteByHeaderId(id);
                    }

                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        public bool DeleteDetail(Guid id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustHeaderDao mainDao = new InventoryAdjustHeaderDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                InventoryAdjustDetailDao detailDao = new InventoryAdjustDetailDao();

                //判断表头中状态是否是草稿
                InventoryAdjustHeader main = mainDao.GetObject(id);
                if (main.Status == AdjustStatus.Draft.ToString())
                {
                    //删除lot表

                    lotDao.DeleteByAdjustId(id);
                    //删除line表

                    detailDao.DeleteByAdjustId(id);

                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        public bool AddItems(string Type, Guid AdjustId, Guid DealerId, string WarehouseId, string[] LotIds, string ReturnApplyType)
        {
            bool result = false;

            if (Type == AdjustType.StockIn.ToString())
            {
                //其他入库添加授权产品
                result = AddItemsCfn(AdjustId, DealerId, WarehouseId, LotIds);
            }
            else
            {
                //其他出库和退货，添加库存产品
                result = AddItemsInv(AdjustId, DealerId, LotIds, ReturnApplyType);
            }

            return result;
        }

        public bool ConsignAddItems(string Type, Guid AdjustId, Guid DealerId, string WarehouseId, string[] LotIds, string[] Price, string ReturnApplyType)
        {
            bool result = false;

            //其他出库和退货，添加库存产品
            result = ConsignAddItemsInv(AdjustId, DealerId, LotIds, Price, ReturnApplyType);
            return result;
        }

        public bool AddItemsInv(Guid AdjustId, Guid DealerId, string[] LotIds, string ReturnApplyType)
        {
            bool result = false;


            InventoryAdjustDetail line = null;
            InventoryAdjustLot lot = null;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustDetailDao lineDao = new InventoryAdjustDetailDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                CurrentInvDao dao = new CurrentInvDao();

                Hashtable param = new Hashtable();
                param.Add("LotIds", LotIds);
                DataTable dtLine = dao.SelectInventoryAdjustDetailByLotIDs(param).Tables[0];
                DataTable dtLot = dao.SelectInventoryAdjustLotByLotIDs(param).Tables[0];

                int i = 1;
                //循环遍历选中的产品明细,一个批次一Line行和一Lot行，允许重复
                for (int j = 0; j < dtLot.Rows.Count; j++)
                {
                    DataRow drLot = dtLot.Rows[j];
                    line = GetInventoryAdjustDetailByIndex(AdjustId, new Guid(drLot["ProductId"].ToString()));
                    if (line == null)
                    {
                        //如果记录不存在，则新增记录

                        line = new InventoryAdjustDetail();
                        line.Id = Guid.NewGuid();
                        line.IahId = AdjustId;
                        line.PmaId = new Guid(drLot["ProductId"].ToString());
                        line.Quantity = 0;
                        line.LineNbr = i++;
                        lineDao.Insert(line);
                    }

                    //如果记录不存在，则新增记录

                    lot = new InventoryAdjustLot();
                    lot.Id = Guid.NewGuid();
                    lot.IadId = line.Id;
                    lot.LotId = new Guid(drLot["LotId"].ToString());
                    lot.LotQty = 1;  //缺省发运数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                    lot.WhmId = new Guid(drLot["WarehouseId"].ToString());
                    lot.LotNumber = drLot["LtmLot"].ToString() + "@@" + drLot["LotQRCode"].ToString();
                    lot.LtmLot = drLot["LtmLot"].ToString();
                    lot.LotQRCode = drLot["LotQRCode"].ToString();
                    lot.DOM = drLot["DOM"].ToString();
                    //如果批次的效期为空, 这里报错. @2009-11-30 by Steven 
                    DealerMaster dm = new DealerMasterDao().GetObject(DealerId);
                    //获取产品的价格 lijie add 2016-06-21
                    if (dm.DealerType == "T2")
                    {
                        DataSet Pds = lotDao.SelectProdectById(drLot["ProductId"].ToString());

                        Hashtable ht = new Hashtable();
                        //Add By SongWeiming On 2017-03-06  ReturnApplyType，用来获取价格时判断是否合同约定条款内的，如果是约定条款内的，则CRM产品打8折
                        ht.Add("ReturnApplyType", ReturnApplyType);
                        //End Add By SongWeiming On 2017-03-06
                        ht.Add("DealerId", DealerId);
                        ht.Add("CfnId", Pds.Tables[0].Rows[0]["PMA_CFN_ID"].ToString());
                        ht.Add("Lot", lot.LotNumber);
                        //20191104
                        BaseService.AddCommonFilterCondition(ht);
                        Hashtable ds = lotDao.SelectReturnCfnPrice(ht);
                        lot.UnitPrice = decimal.Parse(ds["Price"].ToString());
                        if (drLot["ExpiredDate"].ToString() == "")
                        {
                            lot.ExpiredDate = null;
                        }
                        else
                        {
                            lot.ExpiredDate = DateTime.ParseExact(drLot["ExpiredDate"].ToString(), "yyyyMMdd", null);
                        }
                    }
                    else     //非二级价格从发货数据中取，并取出ERP中相应主ID及明细行ID信息
                    {
                        Hashtable ht = new Hashtable();
                        ht.Add("DealerId", DealerId);
                        ht.Add("LotNumber", lot.LotNumber);
                        ht.Add("PmaId", drLot["ProductId"].ToString());
                        BaseService.AddCommonFilterCondition(ht);
                        DataSet ds = lotDao.SelectReturnCfnPriceForT1AndLP(ht);
                        if(ds.Tables[0]!=null&& ds.Tables[0].Rows.Count>0)
                        {
                            if(!string.IsNullOrEmpty(Convert.ToString(ds.Tables[0].Rows[0]["PRL_ExpiredDate"])))
                            {
                                lot.ExpiredDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["PRL_ExpiredDate"]);
                            }
                            if (!string.IsNullOrEmpty(Convert.ToString(ds.Tables[0].Rows[0]["PRL_DOM"])))
                            {
                                lot.DOM = Convert.ToString(ds.Tables[0].Rows[0]["PRL_DOM"]);
                            }
                            if (!string.IsNullOrEmpty(Convert.ToString(ds.Tables[0].Rows[0]["Price"])))
                            {
                                lot.UnitPrice = decimal.Parse(Convert.ToString(ds.Tables[0].Rows[0]["Price"]));
                            }
                            lot.ERPNbr = Convert.ToString(ds.Tables[0].Rows[0]["PRL_ERPNbr"]);
                            lot.ERPLineNbr = Convert.ToString(ds.Tables[0].Rows[0]["PRL_ERPLineNbr"]);
                        }
                    }
                    lotDao.Insert(lot);

                    line.Quantity = line.Quantity + 1;
                    lineDao.Update(line);

                }

                //foreach (DataRow drLine in dtLine.Rows)
                //{

                //    //判断Detail是否已经有记录

                //    line = GetInventoryAdjustDetailByIndex(AdjustId, new Guid(drLine["ProductId"].ToString()));
                //    DataRow[] drLots = dtLot.Select("ProductId = '" + drLine["ProductId"].ToString() + "'");
                //    if (line == null)
                //    {
                //        //如果记录不存在，则新增记录

                //        line = new InventoryAdjustDetail();
                //        line.Id = Guid.NewGuid();
                //        line.IahId = AdjustId;
                //        line.PmaId = new Guid(drLine["ProductId"].ToString());
                //        //modified by bozhenfei on 20100604 在后面逻辑中保证数量一致
                //        line.Quantity = 0;
                //        //line.Quantity = Convert.ToDouble(drLots.Length) ;  //缺省数量置为1,合计为总行数。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                //        line.LineNbr = i++;
                //        lineDao.Insert(line);
                //    }
                //    //插入Lot表

                //    for (int j = 0; j < drLots.Length; j++)
                //    {
                //        //判断TransferLot表是否已经有记录
                //        lot = GetInventoryAdjustLotByIndex(line.Id, new Guid(drLots[j]["LotId"].ToString()));

                //            //如果记录不存在，则新增记录

                //            lot = new InventoryAdjustLot();
                //            lot.Id = Guid.NewGuid();
                //            lot.IadId = line.Id;
                //            lot.LotId = new Guid(drLots[j]["LotId"].ToString());
                //            lot.LotQty = 1;  //缺省发运数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                //            lot.WhmId = new Guid(drLots[j]["WarehouseId"].ToString());
                //            lot.LotNumber = drLots[j]["LotNumber"].ToString();
                //            //如果批次的效期为空, 这里报错. @2009-11-30 by Steven 
                //            if (drLots[j]["ExpiredDate"].ToString() == "")
                //            {
                //                lot.ExpiredDate = null;
                //            }
                //            else
                //            {
                //                lot.ExpiredDate = DateTime.ParseExact(drLots[j]["ExpiredDate"].ToString(), "yyyyMMdd", null);
                //            }

                //            lotDao.Insert(lot);
                //            //行记录增加数量 @ 2010/6/4 by Bozhenfei
                //            line.Quantity = line.Quantity + 1;

                //    }
                //    //更新行记录数量 @ 2010/6/4 by Bozhenfei
                //    lineDao.Update(line);
                //}

                result = true;

                trans.Complete();
            }

            return result;
        }

        //出库和寄售买断
        public bool ConsignAddItemsInv(Guid AdjustId, Guid DealerId, string[] LotIds, string[] Price, string ReturnApplyType)
        {
            bool result = false;


            InventoryAdjustDetail line = null;
            InventoryAdjustLot lot = null;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustDetailDao lineDao = new InventoryAdjustDetailDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                CurrentInvDao dao = new CurrentInvDao();

                Hashtable param = new Hashtable();
                param.Add("LotIds", LotIds);
                DataTable dtLine = dao.SelectInventoryAdjustDetailByLotIDs(param).Tables[0];
                DataTable dtLot = dao.SelectInventoryAdjustLotByLotIDs(param).Tables[0];

                int i = 1;
                //循环遍历选中的产品明细,一个批次一Line行和一Lot行，允许重复
                for (int j = 0; j < dtLot.Rows.Count; j++)
                {
                    DataRow drLot = dtLot.Rows[j];
                    line = GetInventoryAdjustDetailByIndex(AdjustId, new Guid(drLot["ProductId"].ToString()));
                    if (line == null)
                    {
                        //如果记录不存在，则新增记录

                        line = new InventoryAdjustDetail();
                        line.Id = Guid.NewGuid();
                        line.IahId = AdjustId;
                        line.PmaId = new Guid(drLot["ProductId"].ToString());
                        line.Quantity = 0;
                        line.LineNbr = i++;
                        lineDao.Insert(line);
                    }

                    //如果记录不存在，则新增记录

                    lot = new InventoryAdjustLot();
                    lot.Id = Guid.NewGuid();
                    lot.IadId = line.Id;
                    lot.LotId = new Guid(drLot["LotId"].ToString());
                    lot.LotQty = 1;  //缺省发运数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                    lot.WhmId = new Guid(drLot["WarehouseId"].ToString());
                    lot.LotNumber = drLot["Ltmlot"].ToString() + "@@" + drLot["LotQRCode"].ToString();
                    lot.LotQRCode = drLot["LotQRCode"].ToString();
                    lot.LtmLot = drLot["Ltmlot"].ToString();
                    lot.DOM = drLot["DOM"].ToString();
                    /*
                   //如果批次的效期为空, 这里报错. @2009-11-30 by Steven 
                   //获取产品的价格 lijie add 2016-06-21
                   DataSet Pds = lotDao.SelectProdectById(drLot["ProductId"].ToString());
                   Hashtable ht = new Hashtable();
                   //Add By SongWeiming On 2017-03-06  ReturnApplyType，用来获取价格时判断是否合同约定条款内的，如果是约定条款内的，则CRM产品打8折
                   ht.Add("ReturnApplyType", ReturnApplyType);
                   //End Add By SongWeiming On 2017-03-06
                   ht.Add("DealerId", DealerId);
                   ht.Add("CfnId", Pds.Tables[0].Rows[0]["PMA_CFN_ID"].ToString());
                   ht.Add("Lot", lot.LtmLot);
                   Hashtable ds = lotDao.SelectReturnCfnPrice(ht); */

                    lot.UnitPrice = decimal.Parse(Price[j] == "" ? "0" : Price[j]);
                    if (drLot["ExpiredDate"].ToString() == "")
                    {
                        lot.ExpiredDate = null;
                    }
                    else
                    {
                        lot.ExpiredDate = DateTime.ParseExact(drLot["ExpiredDate"].ToString(), "yyyyMMdd", null);
                    }

                    lotDao.Insert(lot);

                    line.Quantity = line.Quantity + 1;
                    lineDao.Update(line);

                }
                result = true;

                trans.Complete();
            }

            return result;
        }
        //入库
        public bool AddItemsCfn(Guid AdjustId, Guid DealerId, string WarehouseId, string[] PmaIds)
        {
            bool result = false;


            InventoryAdjustDetail line = null;
            InventoryAdjustLot lot = null;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustDetailDao lineDao = new InventoryAdjustDetailDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                InvTrans invTrans = new InvTrans();

                int i = 1;
                Guid whId = new Guid();

                if (string.IsNullOrEmpty(WarehouseId))
                {
                    whId = invTrans.GetDefaultWarehouse(DealerId);
                }
                else
                {
                    whId = new Guid(WarehouseId);
                }

                foreach (string PmaId in PmaIds)
                {
                    //判断Detail是否已经有记录

                    line = GetInventoryAdjustDetailByIndex(AdjustId, new Guid(PmaId));
                    if (line == null)
                    {
                        //如果记录不存在，则新增记录

                        line = new InventoryAdjustDetail();
                        line.Id = Guid.NewGuid();
                        line.IahId = AdjustId;
                        line.PmaId = new Guid(PmaId);

                        //modified by  bozhenfei on 20100604
                        line.Quantity = 0;
                        //line.Quantity = 1;  //缺省数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                        line.LineNbr = i++;
                        lineDao.Insert(line);
                    }
                    //插入Lot表

                    lot = new InventoryAdjustLot();
                    lot.Id = Guid.NewGuid();
                    lot.IadId = line.Id;
                    lot.LotId = Guid.NewGuid();
                    lot.LotQty = 1;  //缺省数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                    lot.WhmId = whId;
                    lot.LotNumber = null;
                    lot.ExpiredDate = null;
                    lot.DOM = null;
                    lotDao.Insert(lot);
                    //行记录增加数量 @ 2010/6/4 by Bozhenfei
                    line.Quantity = line.Quantity + 1;
                    lineDao.Update(line);
                }

                result = true;

                trans.Complete();
            }

            return result;
        }

        public bool DeleteItem(Guid LotId)
        {
            bool result = false;

            InventoryAdjustDetail line = null;
            InventoryAdjustLot lot = null;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustDetailDao lineDao = new InventoryAdjustDetailDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                //CurrentInvDao dao = new CurrentInvDao();

                //取出lot和line记录
                lot = lotDao.GetObject(LotId);
                line = lineDao.GetObject(lot.IadId);

                //删除Lot记录
                lotDao.Delete(LotId);

                //判断LineId下是否还有其他Lot记录
                if (GetInventoryAdjustLotByLineId(lot.IadId).Count > 0)
                {
                    //若有其他记录，则更新line的Qty
                    line.Quantity = lotDao.SelectTotalInventoryAdjustLotQtyByLineId(lot.IadId);
                    lineDao.Update(line);
                }
                else
                {
                    //若没有其他记录，则Line记录本身也要删除
                    lineDao.Delete(lot.IadId);
                }

                result = true;

                trans.Complete();
            }

            return result;
        }

        public DataSet CheckLotNumber(Guid LotId, string LotNumber)
        {
            DataSet result = null;

            InventoryAdjustDetail line = null;
            InventoryAdjustLot lot = null;
            InventoryAdjustHeader main = null;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustDetailDao lineDao = new InventoryAdjustDetailDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                InventoryAdjustHeaderDao mainDao = new InventoryAdjustHeaderDao();
                ICurrentInvBLL invBll = new CurrentInvBLL();

                lot = lotDao.GetObject(LotId);
                line = lineDao.GetObject(lot.IadId);
                main = mainDao.GetObject(line.IahId);

                //判断批次号是否存在

                Hashtable param = new Hashtable();
                param.Add("DealerId", main.DmaId);
                param.Add("ProductId", line.PmaId);
                param.Add("LotNumber", LotNumber);
                result = invBll.QueryCurrentInvByLotNumber(param);

                trans.Complete();
            }

            return result;
        }

        public bool SaveItem(InventoryAdjustLot lot)
        {
            bool result = false;

            InventoryAdjustDetail line = null;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustDetailDao lineDao = new InventoryAdjustDetailDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();

                lotDao.Update(lot);
                line = lineDao.GetObject(lot.IadId);

                line.Quantity = lotDao.SelectTotalInventoryAdjustLotQtyByLineId(lot.IadId);
                // DataTable LOT = lotDao.SelectTotalInventoryAdjustLot(lot.IadId).Tables[0];
                //DataTable QRCode  = lotDao.SelectTotalInventoryAdjustQRCode(lot.IadId).Tables[0];
                //line.QRCode = LOT.Rows[0]["QRCode"].ToString();
                //line.Lot = LOT.Rows[0]["LOT"].ToString();
                lineDao.Update(line);

                result = true;

                trans.Complete();
            }

            return result;
        }
        //退货，寄售买断
        public bool Submit(InventoryAdjustHeader obj)
        {
            bool needSynEkp = false;
            bool result = false;

            //保存主信息

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustHeaderDao mainDao = new InventoryAdjustHeaderDao();

                //判断表头中状态是否是草稿
                InventoryAdjustHeader main = mainDao.GetObject(obj.Id);
                if (main.Status == AdjustStatus.Draft.ToString())
                {
                    mainDao.Update(obj);
                    result = true;
                }
                trans.Complete();
            }

            if (!result) return false;//保存主信息出错


            result = false;

            #region 不使用事物，更新退换货产品的产品单价 Edited By Song Yuqi On 2017-04-12 For 退货额度池控制 Begin
            if (obj.Reason == AdjustType.Return.ToString() || obj.Reason == AdjustType.Exchange.ToString())
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;

                Hashtable ht = new Hashtable();
                BaseService.AddCommonFilterCondition(ht);
                InventoryAdjustHeaderDao headerDao = new InventoryAdjustHeaderDao();
                headerDao.UpdateAdjustCfnPrice(obj.Id, obj.DmaId, obj.ProductLineBumId.Value, obj.Reason
                    , obj.ApplyType, new Guid(_context.User.Id), Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out rtnVal, out rtnMsg);

                if (rtnVal != "Success")
                {
                    throw new Exception("$$$提交失败:" + rtnMsg + "$$$");
                }
            }
            #endregion Edited By Song Yuqi On 2017-04-12 For 退货额度池控制 End

            using (TransactionScope trans = new TransactionScope())
            {
                AutoNumberBLL auto = new AutoNumberBLL();
                InventoryAdjustHeaderDao mainDao = new InventoryAdjustHeaderDao();
                InventoryAdjustDetailDao detailDao = new InventoryAdjustDetailDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                InvTrans invTrans = new InvTrans();
                DealerShipToDao infoDao = new DealerShipToDao();
                DealerMasterDao dmDao = new DealerMasterDao();
                MailDeliveryAddressDao mailAddressDao = new MailDeliveryAddressDao();
                InventoryAdjustConsignmentDao consignemtnDao = new InventoryAdjustConsignmentDao();
                DealerMasterDao dao = new DealerMasterDao();
                DealerMaster Dms = dao.SelectDealerMasterParentTypebyId(obj.DmaId);
                //DealerMaster Partdms = new DealerMaster();
                ////获取它平台的经销商信息
                //Partdms = dao.GetObject(Dms.ParentDmaId.Value);
                //判断表头中状态是否是草稿
                InventoryAdjustHeader main = mainDao.GetObject(obj.Id);
                if (main.Status == AdjustStatus.Draft.ToString())
                {
                    //Added By Song Yuqi On 20140320 Begin
                    //InventoryAdjustConsignment
                    //if ((obj.Reason == AdjustType.Return.ToString() || obj.Reason == AdjustType.Exchange.ToString())
                    //    && _context.User.CorpType == DealerType.T2.ToString()
                    //    && main.WarehouseType == AdjustWarehouseType.Consignment.ToString())
                    //{
                    //    string RtnVal = string.Empty;
                    //    string RtnMsg = string.Empty;
                    //    consignemtnDao.SumbitConsignment(obj.Id, out RtnVal, out RtnMsg);
                    //    if (RtnVal != "Success")
                    //    {
                    //        return false;
                    //    }
                    //}
                    //转移给其他经销商
                    //if (obj.Reason == AdjustType.Transfer.ToString() && main.WarehouseType == AdjustWarehouseType.Borrow.ToString())
                    //{
                    //    string RtnVal = string.Empty;
                    //    string RtnMsg = string.Empty;
                    //    consignemtnDao.SumbitBorrow(obj.Id, out RtnVal, out RtnMsg);
                    //    if (RtnVal != "Success")
                    //    {
                    //        return false;
                    //    }
                    //}

                    //Added By Song Yuqi On 20140320 End

                    bool invChecked = true;
                    bool qrChecked = true;
                    if (obj.Reason != AdjustType.StockIn.ToString())
                    {
                        //其他出库和退货需要库存检查
                        if (obj.Reason == AdjustType.Return.ToString() || obj.Reason == AdjustType.Exchange.ToString() || obj.Reason == AdjustType.Transfer.ToString())
                        {
                            invChecked = CheckLineInventory(obj.Id);
                        }
                        else
                        {
                            //invChecked = CheckLotInventory(obj.Id);
                            invChecked = CheckLineInventory(obj.Id);
                        }
                    }
                    //检查是否有未填写QRcode的记录
                    //退换货申请不校验二维码
                    //if (obj.Reason != AdjustType.Return.ToString() && obj.Reason != AdjustType.Exchange.ToString())
                    //{
                    //    qrChecked = CheckQrCode(obj.Id);
                    //}
                    //检查退货类型与仓库是否匹配
                    if (obj.Reason == AdjustType.Return.ToString() || obj.Reason == AdjustType.Exchange.ToString())
                    {
                        string Messinge = string.Empty;
                        DataSet AppyDs = this.SelectAdjustRenturnApplyTypebyHeadid(obj.Id.ToString());
                        if (AppyDs.Tables[0].Rows.Count > 0)
                        {
                            Messinge = AppyDs.Tables[0].Rows[0][0].ToString();
                            throw new Exception("$$$提交失败:" + Messinge + "$$$");

                        }

                        //Edited By Song Yuqi On 2017-04-12 For 退货额度池控制 Begin
                        string rtnVal = string.Empty;
                        string rtnMsg = string.Empty;

                        mainDao.ReturnAjustBeforeSubmit(obj.Id, obj.InvAdjNbr, obj.UserDescription, obj.DmaId, obj.ProductLineBumId.Value, obj.Reason
                            , obj.ApplyType, new Guid(_context.User.Id), _context.User.FullName, out rtnVal, out rtnMsg);

                        if (rtnVal != "Success")
                        {
                            throw new Exception("$$$提交失败:" + rtnMsg + "$$$");
                        }
                        //Edited By Song Yuqi On 2017-04-12 For 退货额度池控制 End
                    }
                    if (invChecked && qrChecked)
                    {
                        if (obj.Reason == AdjustType.StockOut.ToString())
                        {
                            //其他出库不需要审批，完成状态
                            obj.Status = AdjustStatus.Complete.ToString();
                        }
                        else if (obj.Reason == AdjustType.StockIn.ToString())
                        {
                            //其他入库暂时不需要审批，直接完成状态
                            obj.Status = AdjustStatus.Complete.ToString();
                        }
                        else
                        {
                            //  Dms = dao.GetObject(obj.DmaId);
                            //退货,寄售转销售
                            //if (obj.Reason == AdjustType.CTOS.ToString() && obj.ProductLineBumId == new Guid("8f15d92a-47e4-462f-a603-f61983d61b7b") && Dms.Taxpayer == "红海" && Dms.DealerType == "T2")
                            //{
                            //    //变更为不需要RSM审批 lije edit 2016-10-24
                            //    obj.Status = AdjustStatus.RsmApproval.ToString();

                            //}
                            // if (obj.Reason == AdjustType.Return.ToString()  && obj.ProductLineBumId == new Guid("8f15d92a-47e4-462f-a603-f61983d61b7b") && ((Dms.Taxpayer == "红海" && Dms.DealerType == "T2") || Dms.DealerType == "T1") && obj.WarehouseType == "Normal")
                            //{
                            //    //变更为不需要RSM审批 lije edit 2016-10-24
                            //    obj.Status = AdjustStatus.RsmApproval.ToString();
                            //}
                            //else
                            //{
                            obj.Status = AdjustStatus.Submitted.ToString();
                            //}

                            //Added By Song Yuqi On 2017-08-24 For 普通退换货对接EKP Begin
                            //在提交EKP后再修改单据
                            //obj.Status = AdjustStatus.Submitted.ToString();

                            //obj.Status = AdjustStatus.Draft.ToString();
                            //End

                        }
                        if (obj.Reason == AdjustType.CTOS.ToString())
                        {
                            obj.InvAdjNbr = auto.GetNextAutoNumber(obj.DmaId, OrderType.Next_ConsignToSellNbr, obj.ProductLineBumId.Value);
                        }
                        else
                        {
                            obj.InvAdjNbr = auto.GetNextAutoNumber(obj.DmaId, OrderType.Next_AdjustNbr, obj.ProductLineBumId.Value);
                        }
                        obj.CreateDate = DateTime.Now;
                        obj.ApprovalDate = DateTime.Now;
                        //mainDao.Update(obj);

                        //Edit By 宋卫铭 on 2014-1-24，退货单提交的时候就直接发数据给接口
                        //Edit By 胡勇on 2015-06-03 寄售转销售提交的时候就直接发数据给接口
                        if (obj.Reason == AdjustType.Return.ToString() || obj.Reason == AdjustType.Exchange.ToString() || obj.Reason == AdjustType.CTOS.ToString() || obj.Reason == AdjustType.Transfer.ToString())
                        {

                            //if (obj.Reason == AdjustType.CTOS.ToString() && obj.ProductLineBumId == new Guid("8f15d92a-47e4-462f-a603-f61983d61b7b") && Dms.Taxpayer == "红海" && Dms.DealerType == "T2")
                            //{
                            //    //变更为不需要RSM审批 lije edit 2016-10-24
                            //    InterfaceForEWApproval(obj);
                            //}
                            // if (obj.Reason == AdjustType.Return.ToString() && obj.ProductLineBumId == new Guid("8f15d92a-47e4-462f-a603-f61983d61b7b") && ((Dms.Taxpayer == "红海" && Dms.DealerType == "T2") || Dms.DealerType == "T1") && obj.WarehouseType == "Normal")
                            //{
                            //变更为不需要RSM审批 lije edit 2016-10-24
                            //    InterfaceForEWApproval(obj);
                            //}

                            if ((obj.Reason == AdjustType.Return.ToString() || obj.Reason == AdjustType.Exchange.ToString() || obj.Reason == AdjustType.Transfer.ToString()) && (Dms.DealerType == "T1" || Dms.DealerType == "LP" || Dms.DealerType == "LS"))
                            {


                                //如果是退货，换货或寄售转移的并且经销商为T1或者平台时发起Ew_f审批 lijie add 2016-06-26
                                //InterfaceRetrunForEWApproval(obj);

                                needSynEkp = true;
                                obj.Status = AdjustStatus.Draft.ToString();

                            }
                            else
                            {
                                this.InsertAdjustInterfaceBySubDealerId(obj);
                            }
                        }
                        if (needSynEkp)
                        {
                            InventoryAdjustHeaderDao adjHeaderDao = new InventoryAdjustHeaderDao();
                            DataTable dt = adjHeaderDao.GetInventoryReturnForEkpFormDataById(obj.Id);

                            string docSubject = dt.Rows[0]["docSubject"].ToString();
                            string templateId = DictionaryHelper.GetDictionaryNameById("CONST_TemplateId", "DealerReturn");
                            if (string.IsNullOrEmpty(templateId))
                            {
                                throw new Exception("OA流程ID未配置！");
                            }
                            //Added By Song Yuqi On 2017-08-24 For 普通退换货对接EKP Begin  //
                            ekpBll.DoSubmit(obj.Rsm, obj.Id.ToString(), obj.InvAdjNbr, "DealerReturn", docSubject
                                , EkpModelId.DealerReturn.ToString(), EkpTemplateFormId.DealerReturnTemplate.ToString(), templateId);
                            obj.Status = AdjustStatus.Submitted.ToString();
                        }

                        mainDao.Update(obj);
                        IList<InventoryAdjustDetail> details = detailDao.SelectByHashtable(obj.Id);

                        Guid SystemHoldWarehouse = invTrans.GetSystemHoldWarehouse(obj.DmaId);

                        int lineNumber = 1;
                        int totalQty = 0;
                        foreach (InventoryAdjustDetail detail in details)
                        {
                            detail.LineNbr = lineNumber++;
                            detailDao.Update(detail);
                            totalQty += Convert.ToInt32(detail.Quantity);
                            if (obj.Reason == AdjustType.StockIn.ToString() || obj.Reason == AdjustType.StockOut.ToString())//added by bozhenfei on 20100901
                            {
                                //20191209 其他出入库-普通仓库增加审批


                                //其他出库和其他入库，直接增减库存
                                IList<InventoryAdjustLot> lots = lotDao.SelectByHashtable(detail.Id);

                                foreach (InventoryAdjustLot lot in lots)
                                {
                                    //if (obj.Reason == AdjustType.StockIn.ToString())
                                    //{
                                    //    lot.LotNumber = lot.QrLotNumber;
                                    //}
                                    //校验修改后的二维码在lotmaster中是否存在，不存在则新增lotmaster和lot表，存在则更新InventoryAdjustLot表的IAL_QRLOT_ID,
                                    //退货
                                    invTrans.AddLotMasterAndLotByQrEdit(detail, lot, lot.WhmId.Value);
                                    ///Todo: 库存操作
                                    invTrans.SaveInvRelatedInventoryAdjust(detail, lot, (AdjustType)Enum.Parse(typeof(AdjustType), obj.Reason, true), AdjustStatus.Submit, SystemHoldWarehouse, null);//modified by bozhenfei on 20100901
                                }
                            }
                            else if (obj.Reason == AdjustType.Return.ToString() || obj.Reason == AdjustType.Exchange.ToString())
                            {

                                //退货，将库存移入在途库
                                IList<InventoryAdjustLot> lots = lotDao.SelectByHashtable(detail.Id);

                                foreach (InventoryAdjustLot lot in lots)
                                {
                                    //校验修改后的二维码在lotmaster中是否存在，不存在则新增lotmaster和lot表，存在则更新InventoryAdjustLot表的IAL_QRLOT_ID
                                    invTrans.AddLotMasterAndLotByQrEdit(detail, lot, SystemHoldWarehouse);
                                    ///Todo: 库存操作
                                    invTrans.SaveInvRelatedInventoryAdjust(detail, lot, AdjustType.Return, AdjustStatus.Submitted, SystemHoldWarehouse, null);
                                }

                            }
                            else if (obj.Reason == AdjustType.Transfer.ToString())
                            {
                                //转移给其他经销商，将库存移入在途库
                                IList<InventoryAdjustLot> lots = lotDao.SelectByHashtable(detail.Id);

                                foreach (InventoryAdjustLot lot in lots)
                                {
                                    ///Todo: 库存操作
                                    invTrans.SaveInvRelatedInventoryAdjust(detail, lot, AdjustType.Transfer, AdjustStatus.Submitted, SystemHoldWarehouse, null);
                                }
                            }
                        }


                        this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);


                        //发送短信及邮件
                        try
                        {
                            if ((this._context.User.CorpType == DealerType.T2.ToString() || this._context.User.CorpType == DealerType.T1.ToString() || this._context.User.CorpType == DealerType.LP.ToString() || this._context.User.CorpType == DealerType.LS.ToString()) && (obj.Reason == AdjustType.Return.ToString() || obj.Reason == AdjustType.Exchange.ToString()))
                            {


                                //获取接收邮件及短信的人员
                                //需求更改：如果是二级的订单，则获取LP相关人员的账号（限定为接收邮件的人员）
                                //如果是LP或一级经销商的订单，则需要获取CS人员及BU相关人员，根据产品线进行设定

                                //传入当前经销商ID，然后获取对应的邮件地址
                                Hashtable ht = new Hashtable();
                                ht.Add("DmaId", this._context.User.CorpId.Value);
                                ht.Add("ProductLineID", obj.ProductLineBumId);
                                ht.Add("MailType", "GoodsReturn");
                                IList<MailDeliveryAddress> mailList = mailAddressDao.QueryOrderMailAddressByConditions(ht);



                                //DealerShipTo dst = new DealerShipTo();
                                //dst = dealerShiptoDao.GetParentDealerEmailAddressByDmaId(this._context.User.CorpId.Value);

                                //获取经销商信息
                                DealerMaster dm = new DealerMaster();
                                dm = dmDao.GetObject(this._context.User.CorpId.Value);



                                if (mailList != null && mailList.Count > 0 && dm != null)
                                {
                                    //获取订单包括的产品数及总金额
                                    //Decimal productNumber = 0;
                                    //Decimal orderPrice = 0;

                                    //foreach (PurchaseOrderDetail detail in orderDetailList)
                                    //{
                                    //    productNumber += detail.RequiredQty.Value;
                                    //    orderPrice += detail.Amount.Value;
                                    //}

                                    //StringBuilder sb = new StringBuilder();
                                    //DataSet ds = detailDao.SelectPurchaseOrderDetailByHeaderIdForMail(header.Id);
                                    //if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
                                    //{
                                    //    //构造表格
                                    //    sb.Append("<TABLE style=\"BACKGROUND: #ccccff; border:1px solid\" cellSpacing=\"3\" cellPadding=\"0\">");
                                    //    sb.Append("<TBODY>");
                                    //    //表头
                                    //    sb.Append("<TR>");
                                    //    sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //    sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Division</SPAN></STRONG>");
                                    //    sb.Append("</TD>");
                                    //    sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //    sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Level2</SPAN></STRONG>");
                                    //    sb.Append("</TD>");
                                    //    sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //    sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Qty</SPAN></STRONG>");
                                    //    sb.Append("</TD>");
                                    //    sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //    sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Amount</SPAN></STRONG>");
                                    //    sb.Append("</TD>");
                                    //    sb.Append("</TR>");

                                    //    foreach (DataRow row in ds.Tables[0].Rows)
                                    //    {
                                    //        sb.Append("<TR>");
                                    //        sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //        sb.Append(row["Division"].ToString());
                                    //        sb.Append("</TD>");
                                    //        sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //        sb.Append(row["Level2"].ToString());
                                    //        sb.Append("</TD>");
                                    //        sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //        sb.Append(Convert.ToDecimal(row["Qty"].ToString()).ToString("f0"));
                                    //        sb.Append("</TD>");
                                    //        sb.Append("<TD style=\"BACKGROUND: #fcfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //        sb.Append(Convert.ToDecimal(row["Amount"].ToString()).ToString("f2"));
                                    //        sb.Append("</TD>");
                                    //        sb.Append("</TR>");

                                    //    }

                                    //    //表尾
                                    //    sb.Append("<TR>");
                                    //    sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //    sb.Append("&nbsp;");
                                    //    sb.Append("</TD>");
                                    //    sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //    sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">Total</SPAN></STRONG>");
                                    //    sb.Append("</TD>");
                                    //    sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //    sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">" + ((int)productNumber).ToString() + "</SPAN></STRONG>");
                                    //    sb.Append("</TD>");
                                    //    sb.Append("<TD style=\"BACKGROUND: #ccfcff; PADDING-BOTTOM: 0.75pt; PADDING-TOP: 0.75pt; PADDING-LEFT: 0.75pt; PADDING-RIGHT: 0.75pt\">");
                                    //    sb.Append("<STRONG><SPAN style=\"FONT-FAMILY: 宋体\">" + orderPrice.ToString("f2") + " RMB</SPAN></STRONG>");
                                    //    sb.Append("</TD>");
                                    //    sb.Append("</TR>");

                                    //    sb.Append("</TBODY>");
                                    //    sb.Append("</TABLE>");
                                    //}

                                    MessageBLL msgBll = new MessageBLL();
                                    foreach (MailDeliveryAddress mailAddress in mailList)
                                    {
                                        //邮件
                                        Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                        Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                                        dictMailSubject.Add("Dealer", this._context.User.CorpName);
                                        dictMailSubject.Add("OrderNo", obj.InvAdjNbr);

                                        dictMailBody.Add("Dealer", this._context.User.CorpName);
                                        dictMailBody.Add("OrderDate", obj.CreateDate.Value.ToString());
                                        dictMailBody.Add("OrderNo", obj.InvAdjNbr);
                                        dictMailBody.Add("ProductNumber", totalQty.ToString());
                                        //dictMailBody.Add("Summary", sb.ToString());

                                        msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_INVENTORY_RETURN, dictMailSubject, dictMailBody, mailAddress.MailAddress);
                                    }

                                    //短信
                                    //Dictionary<String, String> dictSMS = new Dictionary<String, String>();
                                    //dictSMS.Add("OrderDate", newHeader.SubmitDate.Value.ToShortDateString().ToString());
                                    //dictSMS.Add("OrderNo", newHeader.OrderNo);
                                    //dictSMS.Add("OrderAmount", orderPrice.ToString("f2"));
                                    //dictSMS.Add("ProductNumber", ((int)productNumber).ToString());
                                    //msgBll.AddToShortMessageQueue(ShortMessageTemplateCode.SMS_ORDER_SUBMIT, dictSMS, dm.Phone);

                                }
                            }
                        }
                        catch
                        {

                        }
                        result = true;
                    }
                }
                trans.Complete();
            }

            return result;
        }

        public bool Revoke(Guid AdjustId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustHeaderDao mainDao = new InventoryAdjustHeaderDao();
                InventoryAdjustDetailDao detailDao = new InventoryAdjustDetailDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                InvTrans invTrans = new InvTrans();

                InventoryAdjustHeader main = mainDao.GetObject(AdjustId);
                if (main.Status == AdjustStatus.Submitted.ToString() || main.Status == AdjustStatus.Submit.ToString())
                {
                    //提交、待审批状态可以撤回

                    main.Status = AdjustStatus.Cancelled.ToString();
                    main.ApprovalDate = DateTime.Now;
                    mainDao.Update(main);

                    Guid SystemHoldWarehouse = invTrans.GetSystemHoldWarehouse(main.DmaId);


                    //如果调整类型是其他出库，则撤销后要还原到库存中
                    //如果调整类型是其他入库，则撤销后要扣减库存
                    //如果调整类型是退货，则撤销后要从中间库移回库存
                    IList<InventoryAdjustDetail> details = detailDao.SelectByHashtable(main.Id);

                    foreach (InventoryAdjustDetail detail in details)
                    {
                        IList<InventoryAdjustLot> lots = lotDao.SelectByHashtable(detail.Id);

                        foreach (InventoryAdjustLot lot in lots)
                        {
                            ///Todo: 库存操作
                            invTrans.SaveInvRelatedInventoryAdjust(detail, lot, (AdjustType)Enum.Parse(typeof(AdjustType), main.Reason, true), AdjustStatus.Cancelled, SystemHoldWarehouse, null);//modified by bozhenfei on 20100901
                        }
                    }


                    this.InsertPurchaseOrderLog(AdjustId, new Guid(this._context.User.Id), PurchaseOrderOperationType.Reject, null);
                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        public bool CheckLotInventory(Guid AdjustId)
        {
            bool result = true;
            LotDao daoInv = new LotDao();
            InventoryAdjustLotDao dao = new InventoryAdjustLotDao();
            IList<InventoryAdjustLot> lots = dao.SelectInventoryAdjustLotByAdjustId(AdjustId);
            foreach (InventoryAdjustLot lot in lots)
            {
                Lot lotInv = daoInv.GetObject(lot.LotId.Value);

                if (lotInv.OnHandQty < lot.LotQty || lot.LotQty <= 0)
                {
                    return false;
                }
            }

            return result;
        }

        public bool CheckLineInventory(Guid AdjustId)
        {
            bool result = true;
            LotDao daoInv = new LotDao();

            InventoryAdjustLotDao dao = new InventoryAdjustLotDao();
            IList<InventoryAdjustLot> lots = dao.SelectInventoryAdjustLotSumQtyByAdjustId(AdjustId);
            foreach (InventoryAdjustLot lot in lots)
            {
                Lot lotInv = daoInv.GetObject(lot.LotId.Value);

                if (lotInv.OnHandQty < lot.LotQty || lot.LotQty <= 0)
                {
                    return false;
                }
            }

            return result;
        }

        public bool CheckQrCode(Guid AdjustId)
        {
            bool result = true;
            InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
            DataTable dt = lotDao.SelectLotQrCodeChecked(AdjustId).Tables[0];

            if (dt.Rows.Count > 0 && dt.Rows[0]["CNT"].ToString() != "0")
            {
                return false;
            }


            return result;
        }

        public bool Reject(InventoryAdjustHeader obj)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustHeaderDao mainDao = new InventoryAdjustHeaderDao();
                InventoryAdjustDetailDao detailDao = new InventoryAdjustDetailDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                InvTrans invTrans = new InvTrans();

                InventoryAdjustHeader main = mainDao.GetObject(obj.Id);

                if (main.Status == AdjustStatus.Submitted.ToString())
                {
                    obj.Status = AdjustStatus.Reject.ToString();
                    obj.ApprovalDate = DateTime.Now;
                    obj.ApprovalUsrUserid = new Guid(RoleModelContext.Current.User.Id);

                    mainDao.Update(obj);

                    //如果调整类型是退货，则拒绝后从中间库移回库存
                    if (main.Reason == AdjustType.Return.ToString())
                    {
                        Guid SystemHoldWarehouse = invTrans.GetSystemHoldWarehouse(obj.DmaId);

                        IList<InventoryAdjustDetail> details = detailDao.SelectByHashtable(obj.Id);

                        foreach (InventoryAdjustDetail detail in details)
                        {
                            IList<InventoryAdjustLot> lots = lotDao.SelectByHashtable(detail.Id);

                            foreach (InventoryAdjustLot lot in lots)
                            {
                                ///Todo: 库存操作
                                invTrans.SaveInvRelatedInventoryAdjust(detail, lot, AdjustType.Return, AdjustStatus.Reject, SystemHoldWarehouse, null);
                            }
                        }
                    }

                    this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Reject, null);
                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        public bool Approve(InventoryAdjustHeader obj)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustHeaderDao mainDao = new InventoryAdjustHeaderDao();
                InventoryAdjustDetailDao detailDao = new InventoryAdjustDetailDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                InvTrans invTrans = new InvTrans();

                InventoryAdjustHeader main = mainDao.GetObject(obj.Id);

                if (main.Status == AdjustStatus.Submitted.ToString())
                {

                    obj.Status = AdjustStatus.Accept.ToString();
                    obj.ApprovalDate = DateTime.Now;
                    obj.ApprovalUsrUserid = new Guid(RoleModelContext.Current.User.Id);

                    mainDao.Update(obj);

                    //如果调整类型是退货，则扣除实际库存，删除中间库存
                    if (main.Reason == AdjustType.Return.ToString())
                    {
                        Guid SystemHoldWarehouse = invTrans.GetSystemHoldWarehouse(obj.DmaId);
                        Guid ToWarehouse = invTrans.GetDefaultWarehouse(_context.User.CorpId.Value);

                        IList<InventoryAdjustDetail> details = detailDao.SelectByHashtable(obj.Id);

                        foreach (InventoryAdjustDetail detail in details)
                        {
                            IList<InventoryAdjustLot> lots = lotDao.SelectByHashtable(detail.Id);

                            foreach (InventoryAdjustLot lot in lots)
                            {
                                ///Todo: 库存操作
                                invTrans.SaveInvRelatedInventoryAdjust(detail, lot, AdjustType.Return, AdjustStatus.Accept, SystemHoldWarehouse, ToWarehouse);
                            }
                        }

                        //写入库存调整接口表
                        //Edit By 宋卫铭 on 2014-1-24；退货申请提交时发送数据到借口，申请通过时不需要发送数据到借口
                        //this.InsertAdjustInterface(obj);
                    }

                    this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Approve, null);
                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        public void InsertAdjustInterface(InventoryAdjustHeader obj)
        {
            using (AdjustInterfaceDao dao = new AdjustInterfaceDao())
            {
                AdjustInterface inter = new AdjustInterface();
                inter.Id = Guid.NewGuid();
                inter.BatchNbr = String.Empty;
                inter.RecordNbr = String.Empty;
                inter.IahId = obj.Id;
                inter.IahAdjustNo = obj.InvAdjNbr;
                inter.Status = PurchaseOrderMakeStatus.Pending.ToString();
                inter.ProcessType = PurchaseOrderCreateType.Manual.ToString();
                inter.CreateUser = new Guid(_context.User.Id);
                inter.CreateDate = DateTime.Now;
                inter.UpdateUser = new Guid(_context.User.Id);
                inter.UpdateDate = DateTime.Now;
                inter.Clientid = _clientBLL.GetClientByCorpId(_context.User.CorpId.Value).Id;
                dao.Insert(inter);
            }
        }

        public void InsertAdjustInterfaceBySubDealerId(InventoryAdjustHeader obj)
        {
            using (AdjustInterfaceDao dao = new AdjustInterfaceDao())
            {
                AdjustInterface inter = new AdjustInterface();
                inter.Id = Guid.NewGuid();
                inter.BatchNbr = String.Empty;
                inter.RecordNbr = String.Empty;
                inter.IahId = obj.Id;
                inter.IahAdjustNo = obj.InvAdjNbr;
                inter.Status = PurchaseOrderMakeStatus.Pending.ToString();
                inter.ProcessType = PurchaseOrderCreateType.Manual.ToString();
                inter.CreateUser = new Guid(_context.User.Id);
                inter.CreateDate = DateTime.Now;
                inter.UpdateUser = new Guid(_context.User.Id);
                inter.UpdateDate = DateTime.Now;
                inter.Clientid = _clientBLL.GetParentClientByCorpId(obj.DmaId).Id;
                dao.Insert(inter);
            }
        }

        public void DeleteAdjustInterface(Guid AdjustId)
        {
            using (AdjustInterfaceDao dao = new AdjustInterfaceDao())
            {
                dao.DeleteAdjustInterfaceByIahId(AdjustId);
            }
        }

        public DataSet QueryInventoryReturnForExport(Hashtable table)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);

            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilterForExport(table);
            }

        }

        public DataSet QueryInventoryAdjustAuditForExport(Hashtable table)
        {
            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);
            BaseService.AddCommonFilterCondition(table);

            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilterForAdjustAuditExport(table);
            }

        }

        public DataSet QueryLPGoodsReturnApprove(string OrderID)
        {
            Hashtable table = new Hashtable();
            table.Add("OrderID", OrderID);
            using (PurchaseOrderLogDao dao = new PurchaseOrderLogDao())
            {
                return dao.QueryLPGoodsReturnApprove(table);
            }

        }

        /// <summary>
        /// 查询Excel订单导入出错信息
        /// </summary>
        /// <returns></returns>
        public IList<InventoryReturnInit> QueryInventoryReturnInitErrorData(int start, int limit, out int totalRowCount)
        {
            using (InventoryReturnInitDao dao = new InventoryReturnInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("User", new Guid(_context.User.Id));
                //param.Add("ErrorFlag", true);
                return dao.SelectByHashtable(param, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 调用存储过程处理Excel订单导入数据
        /// </summary>
        /// <param name="IsValid"></param>
        /// <returns></returns>
        public bool VerifyInventoryReturnInit(string importType, out string IsValid)
        {
            bool result = false;

            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            //调用存储过程验证数据
            using (InventoryReturnInitDao dao = new InventoryReturnInitDao())
            {
                IsValid = dao.Initialize(importType, new Guid(_context.User.Id), Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 导入订单中间表
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        public bool ImportInventoryReturnInit(DataSet ds, string fileName)
        {
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    InventoryReturnInitDao dao = new InventoryReturnInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));
                    //读取DataSet数据至数据库
                    int lineNbr = 1;
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        string errString = string.Empty;
                        InventoryReturnInit data = new InventoryReturnInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;
                        if (_context.User.CorpId.HasValue)
                        {
                            data.DmaId = _context.User.CorpId.Value;
                        }
                        else
                        {
                            errString += "请使用经销商帐号导入订单,";
                        }
                        if (dr[0] == DBNull.Value)
                        {
                            errString += "仓库名称为空,";
                        }
                        else
                        {
                            data.Warehouse = dr[0].ToString();
                        }

                        if (dr[1] == DBNull.Value)
                        {
                            errString += "产品型号为空,";
                        }
                        else
                        {
                            data.ArticleNumber = dr[1].ToString();
                        }
                        if (dr[2] == DBNull.Value)
                        {
                            errString += "产品批次号为空,";
                        }
                        else
                        {
                            data.LotNumber = dr[2].ToString();
                        }

                        if (dr[3] == DBNull.Value)
                        {
                            errString += "退货数量为空,";
                        }
                        else
                        {
                            try
                            {
                                data.ReturnQty = dr[3] == DBNull.Value ? null : dr[3].ToString();
                                if (!string.IsNullOrEmpty(data.ReturnQty))
                                {
                                    decimal qty;
                                    if (!Decimal.TryParse(data.ReturnQty, out qty))
                                        data.ReturnQtyErrMsg = "库存数量格式不正确";

                                }
                            }
                            catch
                            {
                                errString += "库存数量必须为大于0的整数,";
                            }
                        }

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !string.IsNullOrEmpty(errString);
                        data.ErrorDescription = errString;

                        dao.Insert(data);
                    }
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            return result;
        }


        public bool Import(DataTable dt, string fileName, out string resMsg)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    InventoryReturnInitDao dao = new InventoryReturnInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<InventoryReturnInit> list = new List<InventoryReturnInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        InventoryReturnInit data = new InventoryReturnInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        if (_context.User.CorpId.HasValue)
                        {
                            data.DmaId = _context.User.CorpId.Value;
                        }

                        //Warehouse
                        data.Warehouse = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.Warehouse))
                            data.WarehouseErrMsg = "仓库名称为空";

                        //ArticleNumber
                        data.ArticleNumber = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.ArticleNumber))
                            data.ArticleNumberErrMsg = "产品型号为空";

                        //LotNumber
                        data.LotNumber = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.LotNumber))
                        {
                            data.LotNumberErrMsg = "产品批次号为空";
                        }


                        data.QrCode = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        //if (string.IsNullOrEmpty(data.QrCode))
                        //{
                        //    data.QrCodeErrMsg += "二维码为空";
                        //}
                        //else if (data.QrCode.ToUpper() == "NOQR")
                        //{
                        //    data.QrCodeErrMsg += "二维码不能为NoQR";
                        //}


                        //Qty
                        data.ReturnQty = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (!string.IsNullOrEmpty(data.ReturnQty))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.ReturnQty, out qty))
                                data.ReturnQtyErrMsg = "退货数量格式不正确";

                        }
                        else
                        {
                            data.ReturnQtyErrMsg = "退货数量为空";
                        }
                        //关联订单号
                        data.PurchaseOrderNbr = dr[4] == DBNull.Value ? null : dr[4].ToString();



                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.WarehouseErrMsg)
                            && string.IsNullOrEmpty(data.ArticleNumberErrMsg)
                            && string.IsNullOrEmpty(data.LotNumberErrMsg)
                            && string.IsNullOrEmpty(data.ReturnQtyErrMsg)
                            && string.IsNullOrEmpty(data.QrCodeErrMsg)
                            );

                        if (data.LineNbr != 1)
                        {
                            list.Add(data);
                        }
                    }
                    dao.BatchInsert(list);
                    result = true;
                    resMsg = "Success";
                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                resMsg = ex.ToString();
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        public void Delete(Guid id)
        {
            using (InventoryReturnInitDao dao = new InventoryReturnInitDao())
            {
                dao.Delete(id);
            }
        }

        public void DeleteConsignmentInit(Guid id)
        {
            using (InventoryReturnConsignmentInitDao dao = new InventoryReturnConsignmentInitDao())
            {
                dao.Delete(id);
            }
        }

        public void Update(InventoryReturnInit data)
        {
            using (InventoryReturnInitDao dao = new InventoryReturnInitDao())
            {
                dao.UpdateForEdit(data);
            }
        }



        #region Added By Song Yuqi On 20140319
        public bool AddConsignmentItemsInv(Guid AdjustId, Guid DealerId, string[] LtmIds)
        {
            bool result = false;
            InventoryAdjustDetail line = null;
            InventoryAdjustLot lot = null;
            //InventoryAdjustConsignment iac = null;
            using (TransactionScope trans = new TransactionScope())
            {
                InventoryAdjustDetailDao lineDao = new InventoryAdjustDetailDao();
                InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
                CurrentInvDao dao = new CurrentInvDao();

                Hashtable param = new Hashtable();
                param.Add("LotIds", LtmIds);
                DataTable dtLine = dao.SelectInventoryAdjustDetailByLotIDs(param).Tables[0];
                DataTable dtLot = dao.SelectInventoryAdjustLotByLotIDs(param).Tables[0];

                int i = 1;
                //循环遍历选中的产品明细,一个批次一Line行和一Lot行，允许重复
                for (int j = 0; j < dtLot.Rows.Count; j++)
                {
                    DataRow drLot = dtLot.Rows[j];
                    line = GetInventoryAdjustDetailByIndex(AdjustId, new Guid(drLot["ProductId"].ToString()));
                    if (line == null)
                    {
                        //如果记录不存在，则新增记录

                        line = new InventoryAdjustDetail();
                        line.Id = Guid.NewGuid();
                        line.IahId = AdjustId;
                        line.PmaId = new Guid(drLot["ProductId"].ToString());
                        line.Quantity = 0;
                        line.LineNbr = i++;
                        lineDao.Insert(line);
                    }

                    //如果记录不存在，则新增记录

                    lot = new InventoryAdjustLot();

                    lot.IadId = line.Id;
                    lot.LotId = new Guid(drLot["LotId"].ToString());

                    lot.WhmId = new Guid(drLot["WarehouseId"].ToString());
                    lot.LotNumber = drLot["LotNumber"].ToString();
                    //如果批次的效期为空, 这里报错. @2009-11-30 by Steven 
                    Hashtable ht = new Hashtable();
                    ht.Add("Lot", lot.LotNumber);
                    ht.Add("WhmId", lot.WhmId);
                    ht.Add("LotId", lot.LotId);
                    ht.Add("IadId", lot.IadId);
                    DataSet ds = lotDao.SelectExistsCFnbyLotIdWhmIdLot(ht);

                    if (ds.Tables[0].Rows.Count <= 0)
                    {
                        //判断产品是否添加过 lijie add 2016-05-30
                        lot.LotQty = 1;  //缺省发运数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                        lot.Id = Guid.NewGuid();
                        if (drLot["ExpiredDate"].ToString() == "")
                        {
                            lot.ExpiredDate = null;
                        }
                        else
                        {
                            lot.ExpiredDate = DateTime.ParseExact(drLot["ExpiredDate"].ToString(), "yyyyMMdd", null);
                        }
                        lotDao.Insert(lot);

                        line.Quantity = line.Quantity + 1;
                    }
                    lineDao.Update(line);

                }
                #region
                //using (InventoryAdjustConsignmentDao dao = new InventoryAdjustConsignmentDao())
                //{
                //    //删除ShipmentConsignment表记录
                //    Hashtable parma = new Hashtable();
                //    parma.Add("IahId", AdjustId);
                //    IList<InventoryAdjustConsignment> list = dao.GetInventoryAdjustConsignmentByFilter(parma);

                //    CurrentInvDao ciDao = new CurrentInvDao();

                //    Hashtable param = new Hashtable();
                //    param.Add("LotIds", LtmIds);
                //    DataTable dtLine = ciDao.SelectInventoryAdjustDetailByLotIDs(param).Tables[0];
                //    Guid ProductId;
                //    Guid LtmId;
                //    foreach (DataRow drLine in dtLine.Rows)
                //    {
                //        //记录数为0
                //        //记录数不存在则插入
                //        if (list.Count == 0 || list.Where<InventoryAdjustConsignment>(p => p.LtmId == new Guid(drLine["LtmId"].ToString())).Count() == 0)
                //        {
                //            ProductId = new Guid(drLine["ProductId"].ToString());
                //            LtmId = new Guid(drLine["LtmId"].ToString());
                //            Hashtable table = new Hashtable();
                //            table.Add("DmaId", DealerId);
                //            table.Add("PmaId", ProductId);
                //            table.Add("LtmId", LtmId);

                //            iac = new InventoryAdjustConsignment();
                //            iac.Id = Guid.NewGuid();
                //            iac.LtmId = LtmId;
                //            iac.IahId = AdjustId;
                //            iac.ShippedQty = 1;

                //            dao.Insert(iac);
                //        }
                //    }
                //}
                #endregion
                result = true;
                trans.Complete();
            }

            return result;
        }

        public DataSet QueryInventoryAdjustConsignment(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (InventoryAdjustConsignmentDao dao = new InventoryAdjustConsignmentDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);
            }
        }

        public InventoryAdjustConsignment GetInventoryAdjustConsignmentById(Guid id)
        {
            using (InventoryAdjustConsignmentDao dao = new InventoryAdjustConsignmentDao())
            {
                return dao.GetObject(id);
            }
        }

        public bool SaveConsignmentItem(InventoryAdjustConsignment sc)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                using (InventoryAdjustConsignmentDao dao = new InventoryAdjustConsignmentDao())
                {
                    dao.Update(sc);
                }

                result = true;

                trans.Complete();
            }

            return result;
        }

        public bool DeleteConsignmentItem(Guid id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                using (InventoryAdjustConsignmentDao dao = new InventoryAdjustConsignmentDao())
                {
                    dao.Delete(id);
                }

                result = true;

                trans.Complete();
            }

            return result;
        }

        public bool DeleteConsignmentItemByHeaderId(Guid headId)
        {
            using (InventoryAdjustConsignmentDao dao = new InventoryAdjustConsignmentDao())
            {
                int i = dao.DeleteByHeaderId(headId);

                if (i > 0)
                    return true;
                return false;
            }

        }

        public DataSet GetPurchaseOrderNbr(Hashtable table)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.SelectByFilterForPurchseOrder(table);
            }
        }
        #endregion

        #region added by huyong on 2014-3-28
        public void UpdateReturnConsignment(InventoryReturnConsignmentInit data)
        {
            using (InventoryReturnConsignmentInitDao dao = new InventoryReturnConsignmentInitDao())
            {
                dao.UpdateForEdit(data);
            }
        }

        public bool ImportReturnConsignment(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    InventoryReturnConsignmentInitDao dao = new InventoryReturnConsignmentInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<InventoryReturnConsignmentInit> list = new List<InventoryReturnConsignmentInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        InventoryReturnConsignmentInit data = new InventoryReturnConsignmentInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        if (_context.User.CorpId.HasValue)
                        {
                            data.DmaId = _context.User.CorpId.Value;
                        }
                        //仓库
                        data.Warehouse = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.Warehouse))
                            data.WarehouseErrMsg = "仓库名称为空";
                        //订单号
                        data.PurchaseOrderNbr = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        //ArticleNumber
                        data.ArticleNumber = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.ArticleNumber))
                            data.ArticleNumberErrMsg = "产品型号为空";

                        //LotNumber
                        data.LotNumber = dr[3] == DBNull.Value ? null : dr[3].ToString() + "@@" + dr[5].ToString();
                        if (string.IsNullOrEmpty(data.LotNumber))
                            data.LotNumberErrMsg = "产品批次号为空";

                        //QrCode
                        data.QrCode = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        if (string.IsNullOrEmpty(data.QrCode))
                        {
                            data.LotNumberErrMsg += "二维码为空";
                        }
                        else if (data.QrCode.ToUpper() == "NOQR")
                        {
                            data.LotNumberErrMsg += "二维码不能为NoQR";
                        }

                        //Qty
                        data.ReturnQty = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (!string.IsNullOrEmpty(data.ReturnQty))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.ReturnQty, out qty))
                                data.ReturnQtyErrMsg = "退货数量格式不正确";

                        }
                        else
                        {
                            data.ReturnQtyErrMsg = "退货数量为空";
                        }

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.ArticleNumberErrMsg)
                            && string.IsNullOrEmpty(data.LotNumberErrMsg)
                            && string.IsNullOrEmpty(data.ReturnQtyErrMsg)
                            );

                        if (data.LineNbr != 1)
                        {
                            list.Add(data);
                        }
                    }
                    dao.BatchInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        /// <summary>
        /// 调用存储过程处理Excel订单导入数据
        /// </summary>
        /// <param name="IsValid"></param>
        /// <returns></returns>
        public bool VerifyInventoryReturnConsignmentInit(string importType, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (InventoryReturnConsignmentInitDao dao = new InventoryReturnConsignmentInitDao())
            {
                IsValid = dao.Initialize(importType, new Guid(_context.User.Id));
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 查询Excel订单导入出错信息
        /// </summary>
        /// <returns></returns>
        public IList<InventoryReturnConsignmentInit> QueryInventoryReturnConsignmentInitErrorData(int start, int limit, out int totalRowCount)
        {
            using (InventoryReturnConsignmentInitDao dao = new InventoryReturnConsignmentInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("User", new Guid(_context.User.Id));
                //param.Add("ErrorFlag", true);
                return dao.SelectByHashtable(param, start, limit, out totalRowCount);
            }
        }
        #endregion

        #region added on 2015-10-19

        public void UpdateAdjust(InventoryAdjustInit data)
        {
            using (InventoryAdjustInitDao dao = new InventoryAdjustInitDao())
            {
                dao.UpdateForEdit(data);
            }
        }

        public void DeleteAdjust(Guid id)
        {
            using (InventoryAdjustInitDao dao = new InventoryAdjustInitDao())
            {
                dao.Delete(id);
            }
        }

        /// <summary>
        /// 调用存储过程处理Excel订单导入数据
        /// </summary>
        /// <param name="IsValid"></param>
        /// <returns></returns>
        public bool VerifyInventoryAdjustInit(string importType, out string IsValid)
        {
            bool result = false;
            //20191025
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            //调用存储过程验证数据
            using (InventoryAdjustInitDao dao = new InventoryAdjustInitDao())
            {
                IsValid = dao.Initialize(importType, new Guid(_context.User.Id), Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 导入订单中间表
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        public bool ImportInventoryAdjustInit(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    InventoryAdjustInitDao dao = new InventoryAdjustInitDao();
                    string aa = _context.User.Id;
                    string bb = _context.User.UserName;

                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<InventoryAdjustInit> list = new List<InventoryAdjustInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        InventoryAdjustInit data = new InventoryAdjustInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        //类型
                        data.AdjustType = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        data.SAPCode = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.SAPCode))
                            data.SAPCodeErrMsg = "经销商编号为空";
                        //经销商名称
                        data.ChineseName = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.ChineseName))
                            data.ChineseNameErrMsg = "经销商名称为空";
                        //仓库名称
                        data.Warehouse = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (string.IsNullOrEmpty(data.Warehouse))
                            data.WarehouseErrMsg = "仓库名称为空";
                        //ArticleNumber
                        data.ArticleNumber = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (string.IsNullOrEmpty(data.ArticleNumber))
                            data.ArticleNumberErrMsg = "产品型号为空";

                        //LotNumber
                        data.LotNumber = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        if (string.IsNullOrEmpty(data.LotNumber))
                            data.LotNumberErrMsg = "产品批次号为空";
                        data.QrCode = dr[6] == DBNull.Value ? null : dr[6].ToString();
                        //Qty
                        data.ReturnQty = dr[7] == DBNull.Value ? null : dr[7].ToString();
                        if (!string.IsNullOrEmpty(data.ReturnQty))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.ReturnQty, out qty))
                                data.ReturnQtyErrMsg = "调整数量格式不正确";

                        }
                        else
                        {
                            data.ReturnQtyErrMsg = "调整数量为空";
                        }

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.ArticleNumberErrMsg)
                            && string.IsNullOrEmpty(data.LotNumberErrMsg)
                            && string.IsNullOrEmpty(data.ReturnQtyErrMsg)
                            && string.IsNullOrEmpty(data.SAPCodeErrMsg)
                            );

                        if (data.LineNbr != 1)
                        {
                            list.Add(data);
                        }
                    }
                    dao.BatchInsert(list);
                    result = true;

                    trans.Complete();
                }
            }
            catch
            {

            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());

            return result;
        }

        /// <summary>
        /// 查询Excel订单导入出错信息
        /// </summary>
        /// <returns></returns>
        public IList<InventoryAdjustInit> QueryInventoryAdjustInitErrorData(int start, int limit, out int totalRowCount)
        {
            using (InventoryAdjustInitDao dao = new InventoryAdjustInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("User", new Guid(_context.User.Id));
                //param.Add("ErrorFlag", true);
                return dao.SelectByHashtable(param, start, limit, out totalRowCount);
            }
        }

        #endregion

        public DataSet GetReturnDealerListByFilter(Hashtable table)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                DataSet ds = dao.GetReturnDealerListByFilter(table);
                return ds;
            }
        }

        public DataSet GetConsignmentOrderNbr(Hashtable table)
        {
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectByFilterForConsignmentOrder(table);
            }
        }

        public DataSet GetInventoryAdjustBorrowById(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (InventoryAdjustConsignmentDao dao = new InventoryAdjustConsignmentDao())
            {
                return dao.GetInventoryAdjustBorrowByFilter(table, start, limit, out totalRowCount);
            }
        }

        public DataSet SelectByFilterInventoryAdjustLotTransfer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectByFilterInventoryAdjustLotTransfer(table, start, limit, out totalRowCount);
            }
        }

        #region added by huyong on 2015-12-25
        public bool QueryQrCodeIsExist(string QrCode)
        {
            bool result;
            using (QrCodeMasterDao dao = new QrCodeMasterDao())
            {
                result = dao.QueryQrCodeIsExist(QrCode).Tables[0].Rows[0]["CNT"].ToString() != "0";
            }
            return result;
        }

        public bool QueryQrCodeIsDouble(Guid adjustID, string QrCode, Guid lotID)
        {
            bool result;
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Id", adjustID);
                ht.Add("QrCode", QrCode);
                ht.Add("IalId", lotID);
                result = dao.QueryQrCodeIsDouble(ht).Tables[0].Rows[0]["CNT"].ToString() != "0";
            }
            return result;
        }


        #endregion
        public DataSet SelectInventoryAdjustLotChecked(string Id)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectInventoryAdjustLotChecked(Id);
            }
        }
        public DataSet SelectInverntoryRutrnQrCode(string DealreId, Double Qty, string QrCode, string EditQrCode)
        {
            Hashtable ht = new Hashtable();
            ht.Add("DealreId", DealreId);
            ht.Add("Qty", Qty);
            ht.Add("QrCode", QrCode);
            ht.Add("EditQrCode", EditQrCode);
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectInverntoryRutrnQrCode(ht);
            }
        }
        public DataSet SelectInverntorRuturSumQty(string HeadId)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectInverntorRuturSumQty(HeadId);
            }

        }
        public DataSet SelectInvernLotRuturnTransferQty(string HeadId)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectInvernLotRuturnTransferQty(HeadId);
            }
        }
        public DataSet SelectInventoryAdjustLotQrCode(string HeadId, string QrCode)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectInventoryAdjustLotBYIdQrCode(HeadId, QrCode);
            }
        }
        public DataSet SelectInventoryAdjustLot(string HeadId)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectInventoryAdjustLot(HeadId);
            }

        }
        public DataSet SelectInventoryAdjustLotQrCodeBYDmIdHeadId(string HeadId, string DmaId)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectInventoryAdjustLotQrCodeBYDmIdHeadId(HeadId, DmaId);
            }

        }
        public bool InventoryAdjustImport(DataTable dt, string fileName, out string batchNumber, out string ClientID, out string Messinge)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            batchNumber = string.Empty;
            ClientID = string.Empty;
            Messinge = string.Empty;
            try
            {

                using (TransactionScope trans = new TransactionScope())
                {

                    IList<InterfaceDealerReturnConfirm> importData = new List<InterfaceDealerReturnConfirm>();

                    int line = 0;
                    ClientDao Cdao = new ClientDao();
                    Client C = new Client();
                    C.CorpId = _context.User.CorpId.Value;
                    C.ActiveFlag = true;
                    IList<Client> list = Cdao.GetAll();
                    C = list.First(p => p.CorpId == _context.User.CorpId.Value && p.ActiveFlag == true);
                    ClientID = C.Id;
                    batchNumber = GetBatchNumber(C.Id.ToString(), DataInterfaceType.DealerReturnConfirmUploader);

                    foreach (DataRow row in dt.Rows)
                    {
                        if (line != 0)
                        {
                            InterfaceDealerReturnConfirm Ishipment = new InterfaceDealerReturnConfirm();
                            Ishipment.Id = Guid.NewGuid();
                            String strQRCode = "";
                            if (row[4] == DBNull.Value)
                            {
                                strQRCode = "NoQR";
                            }
                            else if (row[4].ToString().ToUpper().Contains("NOQR"))
                            {
                                strQRCode = "NoQR";
                            }
                            else
                            {
                                strQRCode = row[4].ToString();
                            }
                            Ishipment.ReturnNo = row[0] == DBNull.Value ? "" : row[0].ToString();


                            if (row[1] != DBNull.Value)
                            {
                                DateTime dc;

                                if (DateTime.TryParse(row[1].ToString(), out dc))
                                {
                                    Ishipment.ConfirmDate = dc;
                                }
                                else
                                {
                                    row[1] = DBNull.Value;
                                }
                            }
                            Ishipment.Upn = row[2] == DBNull.Value ? "" : row[2].ToString();
                            if (row[3] != DBNull.Value)
                            {
                                Ishipment.Lot = row[3].ToString() + "@@" + strQRCode;
                            }
                            if (row[5] != DBNull.Value)
                            {
                                int IsConfirm = 0;
                                int.TryParse(row[5].ToString(), out IsConfirm);
                                Ishipment.IsConfirm = IsConfirm == 1 ? true : false;
                                Ishipment.Qty = IsConfirm;
                            }
                            // Ishipment.DeliveryQty = row[8] == DBNull.Value ? Ishipment.DeliveryQty : Convert.ToDecimal(row[8].ToString());
                            // Ishipment.UnitPrice = row[9] == DBNull.Value ? Ishipment.DeliveryQty : Convert.ToDecimal(row[9].ToString());
                            if (row[6] != DBNull.Value)
                            {
                                Decimal dc;

                                if (Decimal.TryParse(row[6].ToString(), out dc))
                                {
                                    Ishipment.UnitPrice = dc;
                                }
                                else
                                {
                                    row[6] = DBNull.Value;
                                }
                            }
                            Ishipment.Remark = row[7] == DBNull.Value ? "" : row[7].ToString();
                            Ishipment.LineNbr = line;
                            Ishipment.ImportDate = DateTime.Now;
                            Ishipment.Clientid = ClientID;
                            Ishipment.BatchNbr = batchNumber;
                            if (!string.IsNullOrEmpty(Ishipment.ReturnNo) && row[1] != DBNull.Value &&
                                !string.IsNullOrEmpty(Ishipment.Upn) && row[3] != DBNull.Value && row[5] != DBNull.Value
                                && row[6] != DBNull.Value)
                            {
                                //校验用户是否已经填写必填的信息

                                importData.Add(Ishipment);

                            }
                            else
                            {
                                Messinge = Messinge + "订单号" + Ishipment.ReturnNo + "信息填写不完整,或者格式错误;行号" + (line + 1) + "\r\n";
                            }

                        }
                        line = line + 1;
                    }

                    if (string.IsNullOrEmpty(Messinge))
                    {
                        AdjustBLL business = new AdjustBLL();

                        business.ImportInterfaceDealerReturnConfirm(importData);
                        result = true;
                    }

                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                Messinge = ex.ToString();
            }
            System.Diagnostics.Debug.WriteLine("Import Finish : " + DateTime.Now.ToString());
            return result;
        }
        public static string GetBatchNumber(string clientid, DataInterfaceType type)
        {
            AutoNumberBLL autoNbr = new AutoNumberBLL();
            return autoNbr.GetNextAutoNumberForInt(clientid, type);
        }
        public DataSet QueryInterfaceDealerReturnConfirmBybatchNumber(string batchNumber, int start, int limit, out int totalRowCount)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.QueryInterfaceDealerReturnConfirmBybatchNumber(batchNumber, start, limit, out totalRowCount);
            }
        }
        public DataSet SelectExistsDMAParent(string batchNumber, string DmaId)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectExistsDMAParent(batchNumber, DmaId);
            }
        }

        #region 校验分页的关联订单号是否都填写
        public DataSet SelectInventoryAdjustPrhIDBYHeadId(string HeaderID)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectInventoryAdjustPrhIDBYHeadId(HeaderID);
            }
        }
        #endregion
        public DataSet SelectT_I_QV_SalesRepDealerByProductLine(Hashtable ht)
        {
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectT_I_QV_SalesRepDealerByProductLine(ht);
            }
        }
        public DataSet SelectT_I_QV_SalesRepByProductLine(Hashtable ht)
        {
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.SelectT_I_QV_SalesRepByProductLine(ht);
            }
        }
        public void InterfaceForEWApproval(InventoryAdjustHeader header)
        {

            if ("1" != SR.CONST_DMS_DEVELOP)
            {
                EwfService.WfAction wfAction = new EwfService.WfAction();
                wfAction.Credentials = new NetworkCredential(SR.CONST_EWF_USER_NAME, SR.CONST_EWF_USER_PWD, SR.CONST_EWF_DOMAIN);
                string template = string.Empty;
                if (header.Reason == AdjustType.CTOS.ToString())
                {
                    //类型为寄售转销售
                    template = WorkflowTemplate.EndoConsignToSaleTemplate.Clone().ToString();
                }
                else if (header.Reason == AdjustType.Return.ToString())
                {
                    //类型为退货
                    template = WorkflowTemplate.EndoGoodsReturnTemplate.Clone().ToString();
                }
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                bool flag = GetApplyOrderHtml(header.Id, header.ApplyType, out rtnVal, out rtnMsg);
                if (flag)
                {
                    template = string.Format(template, SR.CONST_ENDO_ORDER_NO, header.Rsm, header.Rsm, "", header.InvAdjNbr, rtnMsg);

                    wfAction.StartInstanceXml(template, SR.CONST_EWF_WEB_PWD);

                }

            }

        }
        /// <summary>
        /// 调用退换货审批E_wf接口
        /// </summary>
        /// <param name="header"></param>
        public void InterfaceRetrunForEWApproval(InventoryAdjustHeader header)
        {

            try
            {
                if ("1" != SR.CONST_DMS_DEVELOP)
                {
                    DealerMasterDao dao = new DealerMasterDao();
                    DealerMaster Dms = dao.SelectDealerMasterParentTypebyId(header.DmaId);
                    PushStackDao pushStackDao = new PushStackDao();
                    EwfService.WfAction wfAction = new EwfService.WfAction();
                    wfAction.Credentials = new NetworkCredential(SR.CONST_EWF_USER_NAME, SR.CONST_EWF_USER_PWD, SR.CONST_EWF_DOMAIN);
                    string template = string.Empty;
                    template = WorkflowTemplate.T1LpRetrunTemplate.Clone().ToString();
                    #region
                    //string IsRSMApproval="0";
                    //string  IsDRMApproval="0";
                    //string IsConsignTransferApproval="0";
                    //if ((Dms.DealerType == "T1" || Dms.DealerType=="LP") && (header.Reason == AdjustType.Return.ToString() || header.Reason==AdjustType.Exchange.ToString()) && header.ProductLineBumId == new Guid("8f15d92a-47e4-462f-a603-f61983d61b7b"))
                    //{
                    //    //T1或LP经销商的Endo订单，需要RSM审批，IsRSMApproval设置为true

                    //    IsRSMApproval = "1";
                    //}
                    //else if ((Dms.DealerType == "T1" || Dms.DealerType == "LP") && (header.Reason == AdjustType.Return.ToString() || header.Reason == AdjustType.Exchange.ToString()) && header.ApplyType == "ContractualClause")
                    //{
                    //    //T1或LP经销商在合同条款内的退货，需要DRM审批，IsDRMApproval设置为true

                    //    IsDRMApproval = "1";

                    //}
                    //else if (header.Reason == AdjustType.Transfer.ToString())
                    //{

                    //    //如果是寄售转移，IsConsignTransferApproval设置为true

                    //    IsConsignTransferApproval = "1";
                    //}
                    #endregion
                    //获取产品总数量和总价格
                    DataSet Pds = this.SelectReturnProductQtyorPrice(header.Id.ToString());

                    decimal SumPrice = 0;
                    SumPrice = decimal.Parse(Pds.Tables[0].Rows[0]["SumPrice"].ToString());
                    //获取产品线编号
                    string DivisionCode = string.Empty;
                    using (ConsignmentApplyHeaderDao Cdao = new ConsignmentApplyHeaderDao())
                    {
                        DivisionCode = Cdao.GetProductLineVsDivisionCode(header.ProductLineBumId.Value.ToString()).Tables[0].Rows[0]["DivisionCode"].ToString();
                    }
                    string rtnVal = string.Empty;
                    string rtnMsg = string.Empty;
                    bool flag = GetApplyOrderHtml(header.Id, header.ApplyType, out rtnVal, out rtnMsg);
                    if (flag)
                    {
                        //template = string.Format(template, SR.CONST_ENDO_ORDER_NO, header.Rsm, header.Rsm, "", header.InvAdjNbr, rtnMsg,IsRSMApproval,IsDRMApproval,IsConsignTransferApproval);
                        template = string.Format(template, "2736", "88", "88", DivisionCode, header.InvAdjNbr, rtnMsg, SumPrice, header.ApplyType, header.Rsm, header.Reason == "Return" ? "3" : header.Reason == "Exchange" ? "2" : "0", header.RetrunReason == null ? "" : header.RetrunReason);


                        //Edit By SongWeiming on 2017-03-14 不再直接调用E-WF接口，而是写入接口表，由定时程序进行调用
                        Hashtable ss = new Hashtable();
                        ss.Add("PrimaryKey", header.Id);
                        ss.Add("PushType", "Exchange");
                        ss.Add("PushMethod", "PushMethodEwf");
                        ss.Add("PushContent", template);
                        pushStackDao.Insert(ss);


                        //wfAction.StartInstanceXml(template, SR.CONST_EWF_WEB_PWD);
                        //string xml=wfAction.StartInstanceXml(template, SR.CONST_EWF_WEB_PWD);
                        //string xml = "<RET><RETITEM><TYPE>E</TYPE><MESSAGE>保存数据失败！Invalid column name 'REQUESTTIME'. The Original Sql is Insert Into BIZ_RETURN_NEW_MAIN (EID,DEPID,DMSNO,RETURNTYPE,REQUESTTIME,SUBRETURNTYPE,REAGIONRSM,WFBIZINDEX,WFINSTANCEID) Values(1006536,18,'24535718AJ16072703',1,NULL,2,1027232,1,311334)         </MESSAGE></RETITEM></RET>";
                        //XmlDocument xmldoc = new XmlDocument();//实例化一个XmlDocument对像
                        //xmldoc.LoadXml(xml);//加载为xml文档
                        //XmlNode node = xmldoc.SelectSingleNode("RET/RETITEM/TYPE");
                        //string tp = node.InnerText;
                        //如果type不为s则代表有错误信息，需要抛出异常。订单状态不改变lijie add 2016-08-02
                        //if (tp != "S")
                        //{
                        //    XmlNode mesing = xmldoc.SelectSingleNode("RET/RETITEM/MESSAGE");
                        //    throw new Exception("接口调用失败:" + mesing.InnerText);
                        //}
                        //End Edit By SongWeiming on 2017-03-14
                    }

                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        public bool GetApplyOrderHtml(Guid headerId, string ApplyType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;
            using (ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao())
            {
                DataSet ds = null;
                Hashtable ht = new Hashtable();
                ht.Add("TypeName", "CONST_AdjustRenturn_Type");
                ht.Add("Key", ApplyType);
                DataSet Dds = this.SelectAdjustRenturn_Reason(ht);
                if (Dds.Tables[0].Rows[0]["REV3"].ToString() == "Normal")
                {
                    //如果如果是从普通仓库退换货要带上产品价格
                    ds = dao.GC_GetApplyOrderHtml(headerId, "Id", "V_InventoryNormalAdjust", "Id", "V_InventoryNormaAdjustTable", out rtnVal, out rtnMsg);
                }
                else























































                {
                    //如果是从寄售仓库退换货不需要带上产品价格
                    ds = dao.GC_GetApplyOrderHtml(headerId, "Id", "V_InventoryAdjust", "Id", "V_InventoryAdjustTable", out rtnVal, out rtnMsg);
                }
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    rtnVal = "Success";
                    rtnMsg = ds.Tables[0].Rows[0]["HtmlStr"] != null ? ds.Tables[0].Rows[0]["HtmlStr"].ToString() : "";
                    result = true;
                }
                else
                {
                    rtnVal = "Failure";
                    result = false;
                }
            }
            return result;
        }
        public void InventoryAdjust_CheckSubmit(string IahId, string AdjustType, out string RtnRegMsg, out string IsValid)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                dao.InventoryAdjust_CheckSubmit(IahId, AdjustType, out RtnRegMsg, out IsValid);
            }
        }

        //Added By Song Yuqi On 2016-06-06
        public string CheckProductAuth(Guid id, Guid dealerId, Guid productLineId)
        {
            Hashtable table = new Hashtable();
            table.Add("DealerId", dealerId);
            table.Add("ProductLineId", productLineId);
            table.Add("ReturnOrderId", id);

            DealerContracts dc = new DealerContracts();
            table = dc.GetDealerSpecialAuthByType(table, DealerAuthorizationType.Return, dealerId, productLineId);

            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                DataSet ds = dao.CheckInventoryProductAuthInfo(table);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    return ds.Tables[0].Rows[0][0].ToString();
                }
                return string.Empty;
            }
        }


        public DataSet ExistsPOReceiptHeaderIsUpn(Hashtable ht)
        {

            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.ExistsPOReceiptHeaderIsUpn(ht);

            }

        }
        public DataSet ExistsConsignmentIsUpn(Hashtable ht)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.ExistsConsignmentIsUpn(ht);

            }
        }
        public DataSet GetInventoryDtBYIahId(string IahId)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.GetInventoryDtBYIahId(IahId);
            }
        }
        public DataSet SelectAdjustRenturn_Reason(Hashtable ht)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectAdjustRenturn_Reason(ht);
            }
        }
        public DataSet SelectReturnProductQtyorPrice(string IahId)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectReturnProductQtyorPrice(IahId);
            }
        }
        public DataSet SelectAdjustRenturnApplyTypebyHeadid(string iahId)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.SelectAdjustRenturnApplyTypebyHeadid(iahId);
            }
        }
        public DataSet GetProductLineByDmaId(string DmaId)
        {
            using (InventoryAdjustLotDao dao = new InventoryAdjustLotDao())
            {
                return dao.GetProductLineByDmaId(DmaId);
            }
        }
        public InventoryAdjustHeader GetInventoryAdjustByIdPrint(Guid Id)
        {
            using (InventoryAdjustHeaderDao dao = new InventoryAdjustHeaderDao())
            {
                return dao.GetInventoryAdjustByIdPrint(Id);
            }
        }
        private string GetInventoryReturnXmlForERP(InventoryAdjustHeader headInfo, IList<InventoryAdjustLot> listDetailInfo)
        {
            InventoryAdjustLotDao detailDao = new InventoryAdjustLotDao();
            try
            {
                string strOrg = System.Configuration.ConfigurationManager.AppSettings["FSaleOrgId"];
                JObject data = new JObject();
                data.Add("IsVerifyBaseDataField", SafeJTokenFromObject(true));
                //ERP 是否需要审批
                data.Add("IsAutoSubmitAndAudit", SafeJTokenFromObject(false));

                // 基础信息
                JObject head = new JObject();
                //单据类型
                JObject FBillTypeID = new JObject();
                FBillTypeID.Add("FNumber", SafeJTokenFromObject("THTZD01"));
                head.Add("FBillTypeID", FBillTypeID);

                string strReason = "";
                if(headInfo.Reason== "Return")
                {
                    strReason = "商业退货";
                }
                else if (headInfo.Reason == "Exchange")
                {
                    strReason = "商业换货";
                }
                else if (headInfo.Reason == "ZLReturn")
                {
                    strReason = "质量退货";
                }
                //是否质量退货
                head.Add("F_THHLEIXING", SafeJTokenFromObject(strReason));//质量退货、商业退货、商业换货
                //销售组织分子公司
                JObject FSaleOrgId = new JObject();
                //FSaleOrgId.Add("FNumber", SafeJTokenFromObject(BaseService.CurrentSubCompany?.Key));
                //string SaleOrgId = System.Configuration.ConfigurationManager.AppSettings["FSaleOrgId"];
                FSaleOrgId.Add("FNumber", SafeJTokenFromObject(strOrg));
                head.Add("FSaleOrgId", FSaleOrgId);
                //库存组织
                JObject FRetorgId = new JObject();
                //FSaleOrgId.Add("FNumber", SafeJTokenFromObject(BaseService.CurrentSubCompany?.Key));
                //string RetorgId = "2300";//System.Configuration.ConfigurationManager.AppSettings["FSaleOrgId"];
                FRetorgId.Add("FNumber", SafeJTokenFromObject(strOrg));
                head.Add("FRetorgId", FRetorgId);

                //销售日期
                head.Add("FDate", SafeJTokenFromObject(headInfo.LastUpdateDate.Value.ToString("yyyy-MM-dd")));
                head.Add("FBillNo", SafeJTokenFromObject(headInfo.InvAdjNbr));
                //ERPCode
                JObject FCustId = new JObject();
                DealerMasterDao dmd = new DealerMasterDao();
                IList<Hashtable> lhat = dmd.SelectDealerMainByDealerID(headInfo.DmaId);//this._context.User.CorpId
                string ERPCode = "";
                if (lhat.Count > 0)
                {
                    ERPCode = Convert.ToString(lhat[0]["ERPCode"]);
                }
                FCustId.Add("FNumber", SafeJTokenFromObject(ERPCode));
                head.Add("FRetcustId", FCustId);

                //退货原因
                JObject FReturnReason = new JObject();
                FReturnReason.Add("FNumber", SafeJTokenFromObject("XSTHYY01"));
                head.Add("FReturnReason", FReturnReason);


                // 财务信息
                JObject finance = new JObject();
                /* //是否含税
                 finance.Add("FIsIncludedTax", SafeJTokenFromObject(true));
                 //价外税
                 finance.Add("FIsPriceExcludeTax", SafeJTokenFromObject(true));
                 //结算货币
                 JObject FSettleCurrId = new JObject();
                 FSettleCurrId.Add("FNumber", SafeJTokenFromObject("PRE001"));
                 finance.Add("FSettleCurrId", FSettleCurrId);
                 //汇率类型
                 JObject FExchangeTypeId = new JObject();
                 FExchangeTypeId.Add("FNumber", SafeJTokenFromObject("HLTX01_SYS"));
                 finance.Add("FExchangeTypeId", FExchangeTypeId);
                 //汇率
                 finance.Add("FExchangeRate", SafeJTokenFromObject(1.0));*/

                //结算组织
                JObject FSettleOrgId = new JObject();
                FSettleOrgId.Add("FNumber", SafeJTokenFromObject(strOrg));
                finance.Add("FSettleOrgId", FSettleOrgId);
                head.Add("SubHeadEntity", finance);

                // 单据明细信息
                JArray entry = new JArray();
                for (int i = 0; i < listDetailInfo.Count; i++)
                {
                    JObject row = new JObject();
                    JObject FMaterialId = new JObject();
                    CfnDao cfndao = new CfnDao();
                    //为方便取到CFNid命名为WhmId详见sql语句
                    Cfn cfn = cfndao.GetCfn(listDetailInfo[i].WhmId.Value);
                    string CustomerFaceNbr = cfn.ERPCode;
                    //物料编码
                    FMaterialId.Add("FNumber", SafeJTokenFromObject(CustomerFaceNbr));
                    row.Add("FMaterialId", FMaterialId);
                    //货主类型
                    row.Add("FOwnerTypeID", SafeJTokenFromObject("BD_OwnerOrg"));
                    //货主
                    JObject FOwnerID = new JObject();
                    FOwnerID.Add("FNumber", SafeJTokenFromObject(strOrg));
                    row.Add("FOwnerID", FOwnerID);
                    //销售单位
                    JObject FUnitID = new JObject();
                    FUnitID.Add("FNumber", SafeJTokenFromObject(cfn.Property3));
                    row.Add("FUnitID", FUnitID);
                    row.Add("FQty", SafeJTokenFromObject(listDetailInfo[i].LotQty));
                    //批号
                    JObject FLot = new JObject();
                    FLot.Add("FNumber", SafeJTokenFromObject(listDetailInfo[i].LtmLot));
                    row.Add("FLot", FLot);
                    //生产日期 显示
                    row.Add("FPRODUCEDATE", SafeJTokenFromObject(listDetailInfo[i].DOM));
                    //有效期至 显示
                    row.Add("FExpiryDate", SafeJTokenFromObject(listDetailInfo[i].ExpiredDate.Value.ToString("yyyy-MM-dd")));

                    row.Add("FTaxPrice", SafeJTokenFromObject(listDetailInfo[i].UnitPrice));
                    //退货类型
                    JObject FRmType = new JObject();
                    FRmType.Add("FNumber", SafeJTokenFromObject("THLX01_SYS"));
                    row.Add("FRmType", FRmType);

                    row.Add("FDeliverydate", SafeJTokenFromObject(headInfo.LastUpdateDate.Value.ToString("yyyy-MM-dd")));
                    //序列号子单据
                    JArray SerialSubEntity = new JArray();
                    Hashtable ht = new Hashtable();
                    ht.Add("IadId", listDetailInfo[i].IadId);
                    ht.Add("LotId", listDetailInfo[i].LotId);
                    IList<InventoryAdjustLot> SerialSubList = detailDao.SelectByHashtable(ht);
                    foreach (var serialSub in SerialSubList)
                    {
                        JObject rows = new JObject();
                        rows.Add("FSerialNo", SafeJTokenFromObject(serialSub.LotQRCode));
                        //rows.Add("FSerialId", SafeJTokenFromObject(""));
                        
                        SerialSubEntity.Add(rows);
                    }
                    row.Add("F_SRT_SerialSubEntity", SerialSubEntity);
                    //关联关系表
                    if (!string.IsNullOrEmpty(listDetailInfo[i].ERPNbr) && !string.IsNullOrEmpty(listDetailInfo[i].ERPLineNbr))
                    {
                        JArray FEntity_Link = new JArray();
                        JObject rowF = new JObject();
                        rowF.Add("FEntity_Link_FRuleId", SafeJTokenFromObject("BGP_XSCKDTOTHTZD"));//BGP_SAL_SaleOrderToReturnNotice 
                        rowF.Add("FEntity_Link_FSTableName", SafeJTokenFromObject("T_SAL_OUTSTOCKENTRY"));//T_SAL_ORDERENTRY
                        rowF.Add("FEntity_Link_FSBillId", SafeJTokenFromObject(listDetailInfo[i].ERPNbr));//SafeJTokenFromObject("2000123"));//
                        rowF.Add("FEntity_Link_FSId", SafeJTokenFromObject(listDetailInfo[i].ERPLineNbr));//SafeJTokenFromObject()
                        FEntity_Link.Add(rowF);
                        row.Add("FEntity_Link", FEntity_Link);
                    }
                    entry.Add(row);
                }
                head.Add("FEntity", entry);
                data.Add("Model", head);
                return data.ToString();
            }
            catch (Exception ex)
            {
                return "";
            }
        }
        public bool PushReturnToERP(Guid AdjustID, out string errMsg)
        {
            bool interfaceBL = false;
            try
            {
                IInventoryAdjustBLL business = new InventoryAdjustBLL();
                InventoryAdjustLotDao detailDao = new InventoryAdjustLotDao();
                InventoryAdjustHeaderDao headerDao = new InventoryAdjustHeaderDao();
                InventoryAdjustHeader header = business.GetInventoryAdjustById(AdjustID);
                IList<InventoryAdjustLot> orderDetailList = detailDao.SelectRetrunInventoryAdjustLotByAdjustId(AdjustID);
                string ERPXML = GetInventoryReturnXmlForERP(header, orderDetailList);
                errMsg = "";
                if (string.IsNullOrEmpty(ERPXML))
                {
                    interfaceBL = false;
                }
                else
                {
                    OrderAndProduct oap = new OrderAndProduct();
                    interfaceBL = oap.AddReturnOrder(header.Id.ToString(), ERPXML, out errMsg);
                    //推送成功后更新状态
                    if (interfaceBL)
                    {
                        header.Status = "INERP";
                        headerDao.Update(header);
                    }
                }
            }
            catch (Exception ex)
            {
                interfaceBL = false;
                errMsg = ex.Message;
            }
            return interfaceBL;
        }
        private JToken SafeJTokenFromObject(Object ob)
        {
            if (ob == null)
            {
                return JToken.FromObject("");
            }
            else
            {
                return JToken.FromObject(ob);
            }
        }
        //换货自动生成订单
        public bool ReturnAutoCreateOrder(string AdjustID,out string msg)
        {
            FormInstanceMaster formInstance = GetFormInstanceMasterByApplyId(AdjustID);
            msg = "";
            bool interfaceBL = true;
            //退还货触发特殊业务
            ekpBll.ExecutiveCommonFormBusiness(formInstance.ApplyId.ToString(), formInstance.modelId, formInstance.templateFormId, "EKP触发特殊业务", "System", "EKP触发特殊业务");
            //订单自动推送ERP
            InventoryAdjustHeader headerIAH = GetInventoryAdjustById(formInstance.ApplyId.Value);

            if (headerIAH != null && headerIAH.Reason == "Exchange")
            {
                PurchaseOrderHeaderDao headerDao = new PurchaseOrderHeaderDao();
                PurchaseOrderDetailDao detailDao = new PurchaseOrderDetailDao();
                PurchaseOrderBLL pobll = new PurchaseOrderBLL();
                PurchaseOrderHeader header = headerDao.GetOrderByOrderNo(headerIAH.InvAdjNbr + "ZRB");

                if (header != null)
                {
                    IList<PurchaseOrderDetail> orderDetailList = detailDao.SelectByHeaderId(header.Id);
                    string ERPXML = pobll.GetOrderXmlForERP(header, orderDetailList);
                    string errMsg = "";
                    if (string.IsNullOrEmpty(ERPXML))
                    {
                        interfaceBL = false;
                    }
                    else
                    {
                        OrderAndProduct oap = new OrderAndProduct();
                        interfaceBL = oap.AddSaleOrderToERP(header.Id.ToString(), ERPXML, out errMsg);

                    }
                    if (!interfaceBL)
                    {
                        header.OrderStatus = PurchaseOrderStatus.Submitted.ToString();
                        pobll.InsertPurchaseOrderLog(header.Id, Guid.Empty, PurchaseOrderOperationType.Submit, "金蝶返回错误信息：" + errMsg);
                    }
                    else
                    {
                        header.OrderStatus = PurchaseOrderStatus.Uploaded.ToString();
                        pobll.InsertPurchaseOrderLog(header.Id, Guid.Empty, PurchaseOrderOperationType.Submit, "订单推送ERP成功");
                    }
                    msg = errMsg;
                    headerDao.Update(header);
                }
                else
                {
                    interfaceBL = false;
                    msg += "未找到订单：" + header.Id;
                }
            }
            return interfaceBL;
        }

        private FormInstanceMaster GetFormInstanceMasterByApplyId(string applyId)
        {
            using (FormInstanceMasterDao dao = new FormInstanceMasterDao())
            {
                Hashtable table = new Hashtable();
                table.Add("ApplyId", applyId);

                IList<FormInstanceMaster> list = dao.SelectFormInstanceMasterListByFilter(table);
                if (list != null && list.Count() > 0)
                {
                    return list.First<FormInstanceMaster>();
                }
                return null;
            }
        }

    }
}
