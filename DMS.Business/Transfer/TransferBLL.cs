using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.Model.DataInterface;
using DMS.Common;
using System.Data;
using System.Collections;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;

namespace DMS.Business
{
    public class TransferBLL : ITransferBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_DealerTransferOut = "DealerTransferOut";
        public const string Action_DealerMovement = "DealerMovement";
        public const string Action_TransferApply = "TransferApply";
        public const string Action_TransferAudit = "TransferAudit";
        public const string Action_TransferRent = "TransferRent";
        public const string Action_TransferRentConsignment = "TransferRentConsignment";
        #endregion

        /// <summary>
        /// 根据Transfer的主键查询一个对象

        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public Transfer GetObject(Guid id)
        {
            using (TransferDao dao = new TransferDao())
            {
                return dao.GetObject(id);
            }
        }

        /// <summary>
        /// 根据hashtable分页查询Transfer表

        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_TransferRent, Description = "库存授权-借货出库", Permissoin = PermissionType.Read)]
        public DataSet QueryTransferRent(Hashtable table, int start, int limit, out int totalRowCount)
        {

            //table.Add("Type", TransferType.Rent.ToString().Split(','));
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (TransferDao dao = new TransferDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 根据hashtable分页导出Transfer表

        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_TransferRent, Description = "库存授权-借货出库", Permissoin = PermissionType.Read)]
        public DataSet SelectByFilterTransferExport(Hashtable table)
        {

            //table.Add("Type", TransferType.Rent.ToString().Split(','));
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (TransferDao dao = new TransferDao())
            {
                return dao.SelectByFilterTransferExport(table);
            }
        }

        [AuthenticateHandler(ActionName = Action_TransferRentConsignment, Description = "库存授权-寄售库调拨", Permissoin = PermissionType.Read)]
        public DataSet QueryTransferRentConsignment(Hashtable table, int start, int limit, out int totalRowCount)
        {

            //table.Add("Type", TransferType.Rent.ToString().Split(','));
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);
            using (TransferDao dao = new TransferDao())
            {
                return dao.SelectByFilterTransferCommit(table, start, limit, out totalRowCount);
            }
        }

        [AuthenticateHandler(ActionName = Action_TransferApply, Description = "库存授权-移库申请", Permissoin = PermissionType.Read)]
        public DataSet QueryTransfer(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //table.Add("Type", TransferType.Transfer.ToString());//仅移库

            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);

            BaseService.AddCommonFilterCondition(table);
            using (TransferDao dao = new TransferDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);

            }
        }
        /// <summary>
        /// 获得移库单行的相关信息，用于显示
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryTransferLotHasFromToWarehouse(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (TransferLotDao dao = new TransferLotDao())
            {
                return dao.SelectLotByFilterHasFromToWarehouse(table, start, limit, out totalRowCount);
            }
        }


        /// <summary>
        /// 获得移库单行的相关信息，用于显示不分页
        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryTransferLotHasFromToWarehouse(Hashtable table)
        {
            using (TransferLotDao dao = new TransferLotDao())
            {
                return dao.SelectLotByFilterHasFromToWarehouse(table);
            }
        }


        /// <summary>
        /// 根据hashtable分页查询TransferLot表

        /// </summary>
        /// <param name="table"></param>
        /// <param name="start"></param>
        /// <param name="limit"></param>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryTransferLot(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (TransferLotDao dao = new TransferLotDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 新增一个Transfer对象
        /// </summary>
        /// <param name="obj"></param>
        public void Insert(Transfer obj)
        {
            using (TransferDao dao = new TransferDao())
            {
                dao.Insert(obj);
            }
        }

        /// <summary>
        /// 更新一个Transfer对象
        /// </summary>
        /// <param name="obj"></param>
        public void Update(Transfer obj)
        {
            using (TransferDao dao = new TransferDao())
            {
                dao.Update(obj);
            }
        }

        /// <summary>
        /// 保存草稿
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public bool SaveDraft(Transfer obj)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();

                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(obj.Id);
                if (main.Status == DealerTransferStatus.Draft.ToString())
                {
                    mainDao.Update(obj);
                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 经销商移库提交，冻结库解冻提交
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public bool TransferSubmit(Transfer obj, out string err)
        {
            bool result = false;
            err = string.Empty;
            //保存主信息

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();

                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(obj.Id);
                if (main.Status == DealerTransferStatus.Draft.ToString())
                {
                    mainDao.Update(obj);
                    result = true;
                }
                trans.Complete();
            }

            if (!result) { err = "DoSubmit.False.Alert.Body"; return false; }//保存主信息出错


            result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();
                TransferLineDao lineDao = new TransferLineDao();
                TransferLotDao lotDao = new TransferLotDao();
                LotDao lDao = new LotDao();
                LotMasterDao lmDao = new LotMasterDao();
                ProductDao pDao = new ProductDao();
                AutoNumberBLL auto = new AutoNumberBLL();
                DealerShipToDao infoDao = new DealerShipToDao();
                DealerMasterDao dmDao = new DealerMasterDao();
                InvTrans invTrans = new InvTrans();


                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(obj.Id);
                if (main.Status == DealerTransferStatus.Draft.ToString())
                {
                    //检查物料批次库存

                    if (CheckLotInventory(obj.Id))
                    {



                        //T2寄售库移库提交后，状态变为待审批，不直接改变库存
                        if (this._context.User.CorpType == DealerType.T2.ToString() && obj.Type == TransferType.TransferConsignment.ToString())
                        {
                            obj.Status = DealerTransferStatus.Submitted.ToString();
                        }
                        else
                        {
                            //置为提交状态
                            obj.Status = DealerTransferStatus.Complete.ToString();
                        }
                        //生成出库单号
                        obj.TransferNumber = auto.GetNextAutoNumber(obj.FromDealerDmaId.Value, OrderType.Next_RentNbr, obj.ProductLineBumId.Value);
                        //生成出库日期
                        obj.TransferDate = DateTime.Now;
                        mainDao.Update(obj);

                        //更新Line表的LineNumber
                        IList<TransferLine> lines = lineDao.SelectById(obj.Id);

                        int lineNumber = 1;
                        int totalQty = 0;

                        foreach (TransferLine line in lines)
                        {
                            line.LineNbr = lineNumber++;
                            lineDao.Update(line);
                            totalQty += Convert.ToInt32(line.TransferQty);
                            Hashtable ht = new Hashtable();
                            //插入库存记录
                            if (this._context.User.CorpType == DealerType.T2.ToString() && obj.Type == TransferType.TransferConsignment.ToString())
                            {
                                ht = invTrans.SaveInvRelatedTransfer(line, obj, InvTrans.InvTransferType.TransferRent);
                            }
                            else
                            {
                                ht = invTrans.SaveInvRelatedTransfer(line, obj, InvTrans.InvTransferType.TransferOnly);
                            }
                            ///获取分仓库

                            IList<TransferLot> lots = lotDao.SelectByLineId(line.Id);
                            foreach (TransferLot lot in lots)
                            {
                                //插入批次记录

                                AddLotMastLotQrEdit(lot, line.TransferPartPmaId, line.FromWarehouseWhmId, line.ToWarehouseWhmId.Value, ht);

                                invTrans.SaveLotRelatedTransfer(ht, line, lot);
                            }
                        }

                        //订单操作日志
                        this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);

                        //发送邮件至队列
                        if (this._context.User.CorpType == DealerType.T2.ToString() && obj.Type == TransferType.TransferConsignment.ToString())
                        {
                            //获取接收邮件及短信的人员
                            //二级的订单，则获取LP相关人员的账号
                            DealerShipTo dst = new DealerShipTo();

                            dst = infoDao.GetParentDealerEmailAddressByDmaId(this._context.User.CorpId.Value);

                            //获取经销商信息
                            DealerMaster dm = new DealerMaster();
                            dm = dmDao.GetObject(this._context.User.CorpId.Value);

                            if (dst != null && dm != null)
                            {
                                MessageBLL msgBll = new MessageBLL();
                                //邮件
                                Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                                dictMailSubject.Add("Dealer", this._context.User.CorpName);
                                dictMailSubject.Add("OrderNo", obj.TransferNumber);

                                dictMailBody.Add("Dealer", this._context.User.CorpName);
                                dictMailBody.Add("OrderDate", obj.TransferDate.Value.GetDateTimeFormats('D')[3].ToString());
                                dictMailBody.Add("OrderNo", obj.TransferNumber);
                                dictMailBody.Add("ProductNumber", totalQty.ToString());
                                msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_INVENTORY_TRANSFER, dictMailSubject, dictMailBody, dst.Email);

                                //短信
                                //Dictionary<String, String> dictSMS = new Dictionary<String, String>();
                                //dictSMS.Add("OrderDate", obj.TransferDate.Value.GetDateTimeFormats('D')[3].ToString());
                                //dictSMS.Add("OrderNo", obj.TransferNumber);
                                //dictSMS.Add("ProductNumber", totalQty.ToString());
                                //msgBll.AddToShortMessageQueue(ShortMessageTemplateCode.SMS_ORDER_REVOKE, dictSMS, dm.Phone);
                            }
                        }
                        //判断是否是华西医院的平台商，移入仓库是华西医院库

                        DataTable dtHuaXi = mainDao.SelectIsHuaXiDealer(main.FromDealerDmaId.Value);
                        if (dtHuaXi.Rows.Count > 0)
                        {
                            DataTable dtPush = mainDao.GetPushTransferLot(main.Id).Tables[0];
                            if (dtPush.Rows.Count > 0)
                            {
                                string contentlot = "data\":[";
                                for (int i = 0; i < dtPush.Rows.Count; i++)
                                {
                                    contentlot += "{\"finvcode\":\"" + dtPush.Rows[i]["PMA_UPN"].ToString() + "\",\"invcode\":\"" + dtPush.Rows[i]["PMA_UPN_HuaXi"].ToString() + "\",\"amount\":" + dtPush.Rows[i]["TLT_TransferLotQty"].ToString() + ",\"fcode\":\"" + dtPush.Rows[i]["QRCode"].ToString() + "\",\"batchno\":\"" + dtPush.Rows[i]["LotNumber"].ToString() + "\",\"indate\":\"" + dtPush.Rows[i]["LTM_ExpiredDate"].ToString() + "\"},";
                                }
                                contentlot = contentlot.Substring(0, contentlot.Length - 1) + "]";
                                String content = "{\"u\":\"" + dtHuaXi.Rows[0]["DMA_Sap_Code_HuaXi"].ToString() + "\",\"p\":\"" + dtHuaXi.Rows[0]["DMA_MD5"].ToString() + "\",\"t\":\"" + DateTime.Now.ToString() + "\", \"api\":\"huaxi.viewhigh.mate.setdeliveryorder\",\"v\":\"1.0\" ,\"data\":{\"" + contentlot + "\"}}";
                                //写入PushStack表
                                PushStackDao push = new PushStackDao();
                                Hashtable tb = new Hashtable();
                                tb.Add("PrimaryKey", Guid.NewGuid());
                                tb.Add("PushType", "SetDeliveryOrder");
                                tb.Add("PushMethod", "PushMethodHuaXi");
                                tb.Add("PushContent", content);
                                push.Insert(tb);


                            }
                        }

                        //判断是否移入仓库是北京协和医院
                        //DataTable dtXieHe = mainDao.SelectIsXieHeHospital(main.Id);
                        //if(dtXieHe.Rows.Count > 0 && dtXieHe.Rows[0]["CNT"].ToString() != "0")
                        //{
                        //    //调用存储过程，写入PushStack表
                        //    mainDao.XieHeGetExpressInfo(main.Id);
                        //}

                        err = "Submit.Msg.SubmitSuccess";
                        result = true;
                    }
                    else
                    {
                        err = "Submit.Msg.InventoryCheckFailed";
                    }

                }


                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 提交草稿，验证通过后生成收货单，提交
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public bool Submit(Transfer obj, ReceiptType receiptType, out string err)
        {
            bool result = false;
            err = string.Empty;
            //保存主信息

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();

                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(obj.Id);
                if (main.Status == DealerTransferStatus.Draft.ToString())
                {
                    mainDao.Update(obj);
                    result = true;
                }
                trans.Complete();
            }
            //保存主信息出错

            if (!result)
            {
                err = "Submit.Msg.SaveFailed";
                return false;
            }

            //Added By Song Yuqi On 2016-06-12 Begin
            //仅当借货出库时会校验借入方的授权是否有效
            if (receiptType == ReceiptType.Rent || receiptType == ReceiptType.TransferDistribution)
            {
                string errorMessage = this.CheckProductAuth(obj.Id, obj.FromDealerDmaId.Value, obj.ProductLineBumId.Value);
                if (!string.IsNullOrEmpty(errorMessage))
                {
                    err = "Submit.Msg.SaveFailed.AuthError";
                    return false;
                }
            }
            //Added By Song Yuqi On 2016-06-12 End

            result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();
                TransferLineDao lineDao = new TransferLineDao();
                TransferLotDao lotDao = new TransferLotDao();
                PoReceiptHeaderDao rhDao = new PoReceiptHeaderDao();
                PoReceiptDao rDao = new PoReceiptDao();
                PoReceiptLotDao rlDao = new PoReceiptLotDao();
                LotDao lDao = new LotDao();
                LotMasterDao lmDao = new LotMasterDao();
                ProductDao pDao = new ProductDao();
                AutoNumberBLL auto = new AutoNumberBLL();

                InvTrans invTrans = new InvTrans();

                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(obj.Id);
                if (main.Status == DealerTransferStatus.Draft.ToString())
                {
                    //检查物料批次库存 检查借入经销商的授权
                    bool isValid = true;

                    if (!CheckDealerToContract(obj.Id, obj.ToDealerDmaId.Value))
                    {
                        isValid = false;
                        err = "Submit.Msg.DealerUnauthorized";
                    }

                    if (isValid && !CheckLotInventory(obj.Id))
                    {
                        isValid = false;
                        err = "Submit.Msg.InventoryCheckFailed";
                    }

                    if (isValid)
                    {
                        //置为提交状态

                        obj.Status = DealerTransferStatus.OntheWay.ToString();
                        //生成出库单号
                        obj.TransferNumber = auto.GetNextAutoNumber(obj.FromDealerDmaId.Value, OrderType.Next_RentNbr, obj.ProductLineBumId.Value);
                        //生成出库日期
                        obj.TransferDate = DateTime.Now;
                        mainDao.Update(obj);

                        //根据借入经销商再次获得其默认分仓库
                        Guid DealerToWHId = invTrans.GetDefaultWarehouse(obj.ToDealerDmaId.Value);


                        //生成收货单Header记录
                        PoReceiptHeader rheader = new PoReceiptHeader();
                        rheader.Id = Guid.NewGuid();
                        rheader.PoNumber = auto.GetNextAutoNumber(obj.ToDealerDmaId.Value, OrderType.Next_POReceiptNbr, obj.ProductLineBumId.Value);
                        rheader.SapShipmentid = obj.TransferNumber;
                        rheader.DealerDmaId = obj.ToDealerDmaId.Value;
                        rheader.SapShipmentDate = DateTime.Now;
                        rheader.Status = ReceiptStatus.Waiting.ToString();
                        rheader.VendorDmaId = obj.FromDealerDmaId.Value;
                        rheader.Type = receiptType.ToString();//ReceiptType.Rent.ToString();
                        rheader.ProductLineBumId = obj.ProductLineBumId;
                        rheader.WhmId = DealerToWHId;//表头保存默认收货仓库
                        rhDao.Insert(rheader);

                        //更新Line表的LineNumber
                        IList<TransferLine> lines = lineDao.SelectById(obj.Id);

                        int lineNumber = 1;

                        foreach (TransferLine line in lines)
                        {
                            line.ToWarehouseWhmId = DealerToWHId;
                            line.LineNbr = lineNumber++;
                            lineDao.Update(line);

                            //插入库存记录
                            Hashtable ht = invTrans.SaveInvRelatedTransfer(line, obj, InvTrans.InvTransferType.TransferRent);

                            //生成收货单Line记录
                            DMS.Model.PoReceipt rline = new DMS.Model.PoReceipt();
                            rline.Id = Guid.NewGuid();
                            rline.SapPmaId = line.TransferPartPmaId;
                            rline.ReceiptQty = line.TransferQty;
                            rline.PrhId = rheader.Id;
                            //Product product = pDao.GetObject(line.TransferPartPmaId);
                            //rline.UnitPrice = product.SapUnitPrice;
                            rline.LineNbr = line.LineNbr;
                            rDao.Insert(rline);

                            IList<TransferLot> lots = lotDao.SelectByLineId(line.Id);
                            foreach (TransferLot lot in lots)
                            {
                                //插入批次记录

                                AddLotMastLotQrEdit(lot, line.TransferPartPmaId, line.FromWarehouseWhmId, DealerToWHId, null);
                                invTrans.SaveLotRelatedTransfer(ht, line, lot);

                                //生成收货单Lot记录
                                PoReceiptLot rlot = new PoReceiptLot();
                                rlot.Id = Guid.NewGuid();
                                rlot.PorId = rline.Id;
                                Lot l = lDao.GetObject(lot.QrlotId.HasValue ? lot.QrlotId.Value : lot.LotId);
                                LotMaster lm = lmDao.GetObject(l.LtmId);
                                rlot.LotNumber = lm.LotNumber;
                                rlot.ReceiptQty = lot.TransferLotQty;
                                //过期日期为空时.value不能自动转换 Changed @2009/12/21 by Steven
                                rlot.ExpiredDate = lm.ExpiredDate;
                                rlot.WhmId = line.ToWarehouseWhmId;
                                rlDao.Insert(rlot);
                            }
                        }

                        //收货单操作日志
                        this.InsertPurchaseOrderLog(rheader.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);

                        //订单操作日志
                        this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);


                        //

                        err = "Submit.Msg.SubmitSuccess";

                        result = true;
                    }
                }
                else
                {
                    err = "Submit.Msg.SubmitFailed";
                }
                trans.Complete();
            }
            return result;
        }
        public bool DistributionSubmit(Transfer obj, ReceiptType receiptType, out string err)
        {
            bool result = false;
            err = string.Empty;
            //保存主信息

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();

                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(obj.Id);
                if (main.Status == DealerTransferStatus.Draft.ToString())
                {
                    mainDao.Update(obj);
                    result = true;
                }
                trans.Complete();
            }
            //保存主信息出错

            if (!result)
            {
                err = "提交失败！";
                return false;
            }

            //Added By Song Yuqi On 2016-06-12 Begin
            //校验借入方的授权是否有效
            
            string errorMessage = this.CheckProductAuth(obj.Id, obj.FromDealerDmaId.Value, obj.ProductLineBumId.Value);
            if (!string.IsNullOrEmpty(errorMessage))
            {
                err = "借入经销商没有产品授权！";
                return false;
            }
            
            //Added By Song Yuqi On 2016-06-12 End

            result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();
                TransferLineDao lineDao = new TransferLineDao();
                TransferLotDao lotDao = new TransferLotDao();
                LotDao lDao = new LotDao();
                LotMasterDao lmDao = new LotMasterDao();
                ProductDao pDao = new ProductDao();
                AutoNumberBLL auto = new AutoNumberBLL();

                InvTrans invTrans = new InvTrans();

                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(obj.Id);
                if (main.Status == DealerTransferStatus.Draft.ToString())
                {
                    //检查物料批次库存 检查借入经销商的授权
                    bool isValid = true;

                    if (!CheckDealerToContract(obj.Id, obj.ToDealerDmaId.Value))
                    {
                        isValid = false;
                        err = "借入经销商授权检查未通过！";
                    }

                    if (isValid && !CheckLotInventory(obj.Id))
                    {
                        isValid = false;
                        err = "物料库存检查未通过！";
                    }

                    if (isValid)
                    {
                        //置为提交状态

                        obj.Status = DealerTransferStatus.Complete.ToString();
                        //生成出库单号
                        obj.TransferNumber = auto.GetNextAutoNumber(obj.FromDealerDmaId.Value, OrderType.Next_TransferNbr, obj.ProductLineBumId.Value);
                        //生成出库日期
                        obj.TransferDate = DateTime.Now;
                        mainDao.Update(obj);

                        //根据借入经销商再次获得其默认分仓库
                        Guid DealerToWHId = invTrans.GetDefaultWarehouse(obj.ToDealerDmaId.Value);
                        
                        //更新Line表的LineNumber
                        IList<TransferLine> lines = lineDao.SelectById(obj.Id);

                        int lineNumber = 1;

                        foreach (TransferLine line in lines)
                        {
                            line.ToWarehouseWhmId = DealerToWHId;
                            line.LineNbr = lineNumber++;
                            lineDao.Update(line);

                            //插入库存记录
                            Hashtable ht = invTrans.SaveInvRelatedTransfer(line, obj, InvTrans.InvTransferType.TransferOnly);
                            
                            IList<TransferLot> lots = lotDao.SelectByLineId(line.Id);
                            foreach (TransferLot lot in lots)
                            {
                                //插入批次记录

                                AddLotMastLotQrEdit(lot, line.TransferPartPmaId, line.FromWarehouseWhmId, DealerToWHId, null);
                                invTrans.SaveLotRelatedTransfer(ht, line, lot);
                                
                            }
                        }
                        
                        //订单操作日志
                        this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);


                        //

                        err = "提交成功！";

                        result = true;
                    }
                }
                else
                {
                    err = "提交失败！";
                }
                trans.Complete();
            }
            return result;
        }
        public void AddLotMastLotQrEdit(TransferLot lot, Guid PmaId, Guid FromWarehouseWhmId, Guid SystemHoldWarehouse, Hashtable ht)
        {
            LotMasters ltmBLL = new LotMasters();
            LotMaster lm = null;
            Inventories invBLL = new Inventories();
            Inventory inv = new Inventory();
            Cfns cfn = new Cfns();

            Lot l = null;
            Lots lotBLL = new Lots();

            if (lot.QrLotNumber != null)
            {
                lm = ltmBLL.SelectLotMasterByLotNumber(lot.QrLotNumber, PmaId);

                if (lm == null)
                {
                    lm = new LotMaster();
                    lm.Id = Guid.NewGuid();
                    lm.LotNumber = lot.QrLotNumber;

                    lm.ExpiredDate = new DateTime(9999, 12, 31);//20191209,时间有限制，Insert异常
                    lm.CreateDate = DateTime.Now;
                    lm.ProductPmaId = PmaId;
                    ltmBLL.Insert(lm);
                }

                if (ht != null)
                {
                    //移出经销商
                    Hashtable htForLotSave = new Hashtable();
                    htForLotSave.Add("InvId", ht["InvID1"].ToString());
                    htForLotSave.Add("LtmId", lm.Id);
                    IList<Lot> lotList = lotBLL.SelectLotsByLotMasterAndWarehouse(htForLotSave);
                    TransferLotDao lotDao = new TransferLotDao();
                    if (lotList.Count == 0)
                    {
                        l = new Lot();
                        l.Id = Guid.NewGuid();
                        l.InvId = new Guid(ht["InvID1"].ToString());
                        l.LtmId = lm.Id;
                        l.OnHandQty = 0;
                        l.QRCode = lm.QRCode;
                        l.LotNumber = lm.LotNumber;
                        l.WhmId = FromWarehouseWhmId;
                        l.Dom = lm.Type;
                        l.ExpiredDate = lm.ExpiredDate;
                        l.CfnId = cfn.SelectByPMAID(PmaId.ToString()).Id;
                        l.CreateDate = DateTime.Now;
                        lotBLL.Insert(l);

                        lot.QrlotId = l.Id;
                        lotDao.Update(lot);
                    }
                    else
                    {
                        lot.QrlotId = lotList[0].Id;
                        lotDao.Update(lot);
                    }

                    //移入经销商
                    Hashtable htForLotSave1 = new Hashtable();
                    htForLotSave1.Add("InvId", ht["InvID2"].ToString());
                    htForLotSave1.Add("LtmId", lm.Id);
                    IList<Lot> lotList1 = lotBLL.SelectLotsByLotMasterAndWarehouse(htForLotSave1);
                    TransferLotDao lotDao1 = new TransferLotDao();
                    if (lotList1.Count == 0)
                    {
                        l = new Lot();
                        l.Id = Guid.NewGuid();
                        l.InvId = new Guid(ht["InvID2"].ToString());
                        l.LtmId = lm.Id;
                        l.OnHandQty = 0;
                        l.QRCode = lm.QRCode;
                        l.LotNumber = lm.LotNumber;
                        l.WhmId = SystemHoldWarehouse;
                        l.Dom = lm.Type;
                        l.ExpiredDate = lm.ExpiredDate;
                        l.CfnId = cfn.SelectByPMAID(PmaId.ToString()).Id;
                        l.CreateDate = DateTime.Now;
                        lotBLL.Insert(l);
                        lotDao1.Update(lot);
                    }

                }
                else
                {
                    inv.WhmId = SystemHoldWarehouse;
                    inv.PmaId = PmaId;


                    IList<Inventory> invList = invBLL.QueryForInventory(inv);
                    if (invList == null || invList.Count == 0)
                    {
                        inv.Id = Guid.NewGuid();
                        inv.OnHandQuantity = 0;
                        invBLL.Insert(inv);
                    }
                    else
                    {
                        inv = invList[0];
                    }
                    Hashtable htForLotSave = new Hashtable();
                    htForLotSave.Add("InvId", inv.Id.Value);
                    htForLotSave.Add("LtmId", lm.Id);
                    IList<Lot> lotList = lotBLL.SelectLotsByLotMasterAndWarehouse(htForLotSave);
                    TransferLotDao lotDao = new TransferLotDao();
                    if (lotList.Count == 0)
                    {
                        l = new Lot();
                        l.Id = Guid.NewGuid();
                        l.InvId = inv.Id.Value;
                        l.LtmId = lm.Id;
                        l.OnHandQty = 0;
                        l.QRCode = lm.QRCode;
                        l.LotNumber = lm.LotNumber;
                        l.WhmId = inv.WhmId;
                        l.Dom = lm.Type;
                        l.ExpiredDate = lm.ExpiredDate;
                        l.CfnId = cfn.SelectByPMAID(PmaId.ToString()).Id;
                        l.CreateDate = DateTime.Now;
                        lotBLL.Insert(l);

                        lot.QrlotId = l.Id;
                        lotDao.Update(lot);
                    }
                    else
                    {
                        lot.QrlotId = lotList[0].Id;
                        lotDao.Update(lot);
                    }
                }
            }
        }
        public bool Revoke(Guid id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();
                TransferLineDao lineDao = new TransferLineDao();
                TransferLotDao lotDao = new TransferLotDao();
                PoReceiptHeaderDao rhDao = new PoReceiptHeaderDao();
                InvTrans invTrans = new InvTrans();

                //判断是否可以撤回
                Transfer main = mainDao.GetObject(id);
                PoReceiptHeader rheader = rhDao.SelectByTransferNumber(main.TransferNumber);
                if (main.Status == DealerTransferStatus.OntheWay.ToString() && rheader != null && rheader.Status != ReceiptStatus.Complete.ToString())
                {
                    //更改原出库单的状态为取消
                    main.Status = DealerTransferStatus.Cancelled.ToString();
                    mainDao.Update(main);

                    //生成Line记录
                    IList<TransferLine> lines = lineDao.SelectById(main.Id);

                    foreach (TransferLine line in lines)
                    {
                        //插入库存记录
                        Hashtable ht = invTrans.SaveInvRelatedTransfer(line, main, InvTrans.InvTransferType.TransferCancel);

                        //生成Lot记录
                        IList<TransferLot> lots = lotDao.SelectByLineId(line.Id);
                        foreach (TransferLot lot in lots)
                        {
                            invTrans.SaveLotRelatedTransfer(ht, line, lot);
                        }
                    }

                    //将收货单状态改为取消

                    rheader.Status = ReceiptStatus.Cancelled.ToString();
                    rhDao.Update(rheader);

                    result = true;

                }
                trans.Complete();
            }
            return result;
        }

        public bool CheckDealerToContract(Guid TransferId, Guid DealerToId)
        {
            bool result = true;

            TransferLineDao dao = new TransferLineDao();
            IList<TransferLine> lines = dao.SelectById(TransferId);
            foreach (TransferLine line in lines)
            {
                Hashtable param = new Hashtable();
                param.Add("ProductId", line.TransferPartPmaId);
                param.Add("DealerId", DealerToId);
                DataSet ds = dao.CheckDealerContractByPmaIdForTransfer(param);
                if (ds.Tables == null || ds.Tables[0].Rows.Count <= 0)
                {
                    return false;
                }
            }

            return result;
        }

        public bool CheckLotInventory(Guid TransferId)
        {
            //验证Lot表

            bool result = true;
            LotDao daoInv = new LotDao();
            TransferLotDao dao = new TransferLotDao();
            IList<TransferLot> lots = dao.SelectById(TransferId);
            foreach (TransferLot lot in lots)
            {
                Lot lotInv = daoInv.GetObject(lot.QrlotId == null ? lot.LotId : lot.QrlotId.Value);
                //借出数量为0或者借出数量大于库存数量则返回失败

                if (Math.Round(lotInv.OnHandQty, 1) < lot.TransferLotQty || lot.TransferLotQty <= 0)
                {
                    return false;
                }
            }

            return result;
        }


        /// <summary>
        /// 删除草稿
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool DeleteDraft(Guid id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();
                TransferLotDao lotDao = new TransferLotDao();
                TransferLineDao detailDao = new TransferLineDao();

                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(id);
                if (main.Status == DealerTransferStatus.Draft.ToString())
                {
                    //删除lot表

                    lotDao.DeleteById(id);
                    //删除line表

                    detailDao.DeleteById(id);
                    //删除主表
                    mainDao.Delete(id);

                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 根据名称取得经销商对象

        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public DealerMaster GetDealerMasterByName(string name)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetObjectByName(name);
            }
        }

        /// <summary>
        /// 根据名称取得经销商对象

        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public DealerMaster GetDealerMasterById(Guid id)
        {
            using (DealerMasterDao dao = new DealerMasterDao())
            {
                return dao.GetObject(id);
            }
        }

        /// <summary>
        /// 变更产品线或经销商时删除明细
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool DeleteDetail(Guid id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();
                TransferLotDao lotDao = new TransferLotDao();
                TransferLineDao detailDao = new TransferLineDao();

                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(id);
                if (main.Status == DealerTransferStatus.Draft.ToString())
                {
                    //删除lot表

                    lotDao.DeleteById(id);
                    //删除line表

                    detailDao.DeleteById(id);

                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        public TransferLine GetTransferLineByIndex(Guid TransferId, Guid ProductId, Guid FromWarehouseId, Guid ToWarehouseId)
        {
            using (TransferLineDao dao = new TransferLineDao())
            {
                Hashtable param = new Hashtable();
                param.Add("TrnId", TransferId);
                param.Add("TransferPartPmaId", ProductId);
                param.Add("FromWarehouseWhmId", FromWarehouseId);
                param.Add("ToWarehouseWhmId", ToWarehouseId);

                IList<TransferLine> lines = dao.SelectByFilter(param);

                if (lines.Count > 0)
                {
                    return lines[0];
                }
            }
            return null;
        }

        public TransferLine GetTransferLineByIndex(Guid TransferId, Guid ProductId, Guid FromWarehouseId)
        {
            using (TransferLineDao dao = new TransferLineDao())
            {
                Hashtable param = new Hashtable();
                param.Add("TrnId", TransferId);
                param.Add("TransferPartPmaId", ProductId);
                param.Add("FromWarehouseWhmId", FromWarehouseId);

                IList<TransferLine> lines = dao.SelectByFilter(param);

                if (lines.Count > 0)
                {
                    return lines[0];
                }
            }
            return null;
        }

        public Decimal GetTransferLineProductNumByTrnId(Hashtable ht)
        {
            using (TransferLineDao dao = new TransferLineDao())
            {

                Decimal productNum = 0;
                IList<TransferLine> lines = dao.SelectByFilter(ht);

                foreach (TransferLine line in lines)
                {
                    productNum += Convert.ToDecimal(line.TransferQty);
                }
                return productNum;
            }

        }

        /// <summary>
        /// 经销商移库，判断line表中移除库与移入库是否一致
        /// </summary>
        /// <param name="TransferId"></param>
        /// <returns></returns>
        public bool IsTransferLineWarehouseEqualByTrnID(String TransferId)
        {
            using (TransferLineDao dao = new TransferLineDao())
            {
                Hashtable param = new Hashtable();
                param.Add("TrnId", TransferId);
                IList<TransferLine> lines = dao.SelectByFilter(param);

                foreach (TransferLine line in lines)
                {
                    if (line.FromWarehouseWhmId == line.ToWarehouseWhmId)
                    {
                        return true;
                    }

                }
                return false;
            }
        }

        public TransferLot GetTransferLotByIndex(Guid LineId, Guid LotId)
        {
            using (TransferLotDao dao = new TransferLotDao())
            {
                Hashtable param = new Hashtable();
                param.Add("TrlId", LineId);
                param.Add("LotId", LotId);

                IList<TransferLot> lots = dao.SelectByFilter(param);

                if (lots.Count > 0)
                {
                    return lots[0];
                }
            }
            return null;
        }

        public IList<TransferLot> GetTransferLotByLineId(Guid LineId)
        {
            using (TransferLotDao dao = new TransferLotDao())
            {
                Hashtable param = new Hashtable();
                param.Add("TrlId", LineId);

                return dao.SelectByFilter(param);
            }
        }
        //冻结库物料选择
        public bool AddItemsByType(string type, Guid TransferId, Guid DealerFromId, Guid DealerToId, Guid ProductLineId, string[] LotIds, Guid? ToWarehouseId)
        {
            bool result = false;
            if (type == TransferType.Rent.ToString())
            {
                result = AddRentItems(TransferId, DealerFromId, DealerToId, ProductLineId, LotIds, ToWarehouseId.Value);
            }
            else if (type == TransferType.Transfer.ToString() || type == TransferType.TransferConsignment.ToString() || type == TransferType.RentConsignment.ToString() || type == TransferType.TransferDistribution.ToString())
            {
                result = AddTransferItems(TransferId, DealerFromId, DealerToId, ProductLineId, LotIds, ToWarehouseId.Value);
            }
            return result;
        }

        public bool AddRentItems(Guid TransferId, Guid DealerFromId, Guid DealerToId, Guid ProductLineId, string[] LotIds, Guid ToWarehouseId)
        {
            bool result = false;


            TransferLine line = null;
            TransferLot lot = null;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferLineDao lineDao = new TransferLineDao();
                TransferLotDao lotDao = new TransferLotDao();
                CurrentInvDao dao = new CurrentInvDao();
                //InvTrans invTrans = new InvTrans();

                Hashtable param = new Hashtable();
                param.Add("LotIds", LotIds);
                DataTable dtLine = dao.SelectTransferLineByLotIDs(param).Tables[0];
                DataTable dtLot = dao.SelectTransferLotByLotIDs(param).Tables[0];

                int i = 1;
                //Guid DealerToWHId = invTrans.GetDefaultWarehouse(DealerToId);

                //添加
                foreach (DataRow drLine in dtLine.Rows)
                {
                    //判断TransferLine表是否已经有记录
                    line = GetTransferLineByIndex(TransferId, new Guid(drLine["ProductId"].ToString()), new Guid(drLine["WarehouseId"].ToString()), ToWarehouseId);
                    DataRow[] drLots = dtLot.Select("ProductId = '" + drLine["ProductId"].ToString() + "' and WarehouseId = '" + drLine["WarehouseId"].ToString() + "'");
                    if (line == null)
                    {
                        //如果记录不存在，则新增记录

                        line = new TransferLine();
                        line.Id = Guid.NewGuid();
                        line.TrnId = TransferId;
                        line.TransferPartPmaId = new Guid(drLine["ProductId"].ToString());
                        line.FromWarehouseWhmId = new Guid(drLine["WarehouseId"].ToString());
                        line.ToWarehouseWhmId = ToWarehouseId;
                        //modified by bozhenfei on 20100607 在后面逻辑中保证数量一致
                        line.TransferQty = 0;
                        //line.TransferQty = Convert.ToDouble(drLots.Length); //缺省数量置为1,合计为总行数。为减少用户的输入量，修改需求 @ 2009/12/3 By Steven
                        line.LineNbr = i++;
                        lineDao.Insert(line);
                    }
                    //插入TransferLot表

                    //DataRow[] drLots = dtLot.Select("ProductId = '" + line.TransferPartPmaId.ToString() + "' and WarehouseId = '" + line.FromWarehouseWhmId.ToString() + "'");
                    for (int j = 0; j < drLots.Length; j++)
                    {
                        DataRow drLot = dtLot.Rows[j];
                        //判断TransferLot表是否已经有记录
                        lot = GetTransferLotByIndex(line.Id, new Guid(drLots[j]["LotId"].ToString()));
                        if (lot == null)
                        {
                            //如果记录不存在，则新增记录

                            lot = new TransferLot();
                            lot.Id = Guid.NewGuid();
                            lot.TrlId = line.Id;
                            lot.WhmId = line.FromWarehouseWhmId;
                            lot.LotId = new Guid(drLots[j]["LotId"].ToString());
                            lot.TransferLotQty = 1; //缺省数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 By Steven
                            lot.LTMLot = drLots[j]["LTMLot"].ToString();
                            lot.LTMQRCode = drLots[j]["LTMQRCode"].ToString();
                            lot.ExpiredDate = DateTime.ParseExact(drLot["ExpiredDate"].ToString(), "yyyyMMdd", null);
                            lot.DOM = drLot["DOM"] != DBNull.Value ? Convert.ToDateTime(drLot["DOM"]).ToString("yyyy-MM-dd") : "";
                            lotDao.Insert(lot);
                            //行记录增加数量 @ 2010/6/7 by Bozhenfei
                            line.TransferQty = line.TransferQty + 1;
                        }
                    }
                    //更新行记录数量 @ 2010/6/7 by Bozhenfei
                    lineDao.Update(line);
                }

                result = true;

                trans.Complete();
            }

            return result;
        }

        public bool AddTransferItems(Guid TransferId, Guid DealerFromId, Guid DealerToId, Guid ProductLineId, string[] LotIds, Guid ToWarehouseId)
        {
            bool result = false;


            TransferLine line = null;
            TransferLot lot = null;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferLineDao lineDao = new TransferLineDao();
                TransferLotDao lotDao = new TransferLotDao();
                CurrentInvDao dao = new CurrentInvDao();
                //InvTrans invTrans = new InvTrans();

                Hashtable param = new Hashtable();
                param.Add("LotIds", LotIds);
                DataTable dtLot = dao.SelectTransferLotByLotIDs(param).Tables[0];

                /*      
    <select id="SelectTransferLotByLotIDs" parameterClass="System.Collections.Hashtable" resultClass="CurrentInv">
          SELECT
          Lot.LOT_ID AS LotId,
          Product.PMA_ID AS ProductId,
          Inventory.INV_WHM_ID AS WarehouseId
          FROM Inventory
          INNER JOIN Lot ON Inventory.INV_ID = Lot.LOT_INV_ID
          INNER JOIN Product ON Inventory.INV_PMA_ID = Product.PMA_ID
          <dynamic prepend="WHERE">
              <isNotNull prepend="and" property="LotIds">
                  Lot.LOT_ID IN
                  <iterate  property="LotIds" open="(" close=")" conjunction=",">
                      #LotIds[]#
                  </iterate>
              </isNotNull>
          </dynamic>
      </select>
                 */
                int i = 1;

                //一个批次一Transfer行和一Lot行,允许重复
                foreach (DataRow drLot in dtLot.Rows)
                {
                    ////判断TransferLot表是否已经有记录
                    //lot = GetTransferLotByIndex(line.Id, new Guid(drLot["LotId"].ToString()));
                    //if (lot == null)
                    //{
                    //新增行记录

                    line = new TransferLine();
                    line.Id = Guid.NewGuid();
                    line.TrnId = TransferId;
                    line.TransferPartPmaId = new Guid(drLot["ProductId"].ToString());
                    line.FromWarehouseWhmId = new Guid(drLot["WarehouseId"].ToString());
                    //添加默认移入仓库 @ 2010/6/7 By Bozhenfei
                    if (ToWarehouseId != Guid.Empty)
                    {
                        line.ToWarehouseWhmId = ToWarehouseId;
                    }
                    //End
                    line.TransferQty = 1; //缺省发运数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 By Steven
                    line.LineNbr = i++;
                    lineDao.Insert(line);

                    //新增批次记录
                    lot = new TransferLot();
                    lot.Id = Guid.NewGuid();
                    lot.TrlId = line.Id;
                    lot.LotId = new Guid(drLot["LotId"].ToString());
                    lot.DOM = drLot["DOM"].ToString();
                    lot.ExpiredDate = DateTime.ParseExact(drLot["ExpiredDate"].ToString(), "yyyyMMdd", null);
                    lot.LTMLot = drLot["LTMLot"].ToString();
                    lot.LTMQRCode = drLot["LTMQRCode"].ToString();
                    lot.TransferLotQty = 1; //缺省数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                    lotDao.Insert(lot);
                    //}
                }

                result = true;

                trans.Complete();
            }

            return result;
        }

        public DataSet SelectTransferLotByFilter(Guid headerId)
        {
            using (TransferLotDao dao = new TransferLotDao())
            {
                return dao.SelectTransferLotByFilter(headerId);
            }
        }

        /// <summary>
        /// 保存移库数据的目的仓库和批次数数量

        /// </summary>
        /// <param name="LotId">批次表记录Id</param>
        /// <param name="ToWarehouseID">目的仓库的的仓库Id</param>
        /// <param name="TransferQty">移库的数量</param>
        /// <returns></returns>
        public bool SaveTransferItem(Guid LotId, Guid? ToWarehouseID, double TransferQty, string LotNumber)
        {
            bool result = false;


            TransferLine line = null;
            TransferLot lot = null;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferLineDao lineDao = new TransferLineDao();
                TransferLotDao lotDao = new TransferLotDao();
                CurrentInvDao dao = new CurrentInvDao();

                //取得TransferLot记录
                lot = lotDao.GetObject(LotId);
                //取得原始值
                if (LotNumber != string.Empty)
                {
                    lot.QrLotNumber = LotNumber;
                }
                double oldValue = lot.TransferLotQty;
                //取得TransferLine记录
                line = lineDao.GetObject(lot.TrlId);

                //此处最好加入与库存判断的逻辑
                lot.TransferLotQty = TransferQty;
                line.TransferQty += TransferQty - oldValue;
                line.ToWarehouseWhmId = ToWarehouseID;

                lotDao.Update(lot);
                lineDao.Update(line);

                result = true;

                trans.Complete();
            }

            return result;
        }

        /// <summary>
        /// 经销商借货
        /// </summary>
        /// <param name="LotId"></param>
        /// <param name="TransferQty"></param>
        /// <returns></returns>

        public bool SaveItem(Guid LotId, double TransferQty, string LotNumber)
        {
            bool result = false;


            TransferLine line = null;
            TransferLot lot = null;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferLineDao lineDao = new TransferLineDao();
                TransferLotDao lotDao = new TransferLotDao();
                CurrentInvDao dao = new CurrentInvDao();

                //更新TransferLot记录
                lot = lotDao.GetObject(LotId);
                lot.TransferLotQty = TransferQty;
                if (!string.IsNullOrEmpty(LotNumber))
                {
                    lot.QrLotNumber = LotNumber;
                }
                lotDao.Update(lot);

                //更新TransferLine记录
                line = lineDao.GetObject(lot.TrlId);
                line.TransferQty = lotDao.SelectTotalTransferLotQtyByLineId(lot.TrlId);
                lineDao.Update(line);

                result = true;

                trans.Complete();
            }

            return result;
        }

        public bool DeleteItem(Guid LotId)
        {
            bool result = false;

            TransferLine line = null;
            TransferLot lot = null;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferLineDao lineDao = new TransferLineDao();
                TransferLotDao lotDao = new TransferLotDao();
                CurrentInvDao dao = new CurrentInvDao();

                //取出lot和line记录
                lot = lotDao.GetObject(LotId);
                line = lineDao.GetObject(lot.TrlId);

                //删除TransferLot记录
                lotDao.Delete(LotId);

                //判断LineId下是否还有其他Lot记录
                if (GetTransferLotByLineId(lot.TrlId).Count > 0)
                {
                    //若有其他记录，则更新line的TransferQty
                    line.TransferQty = lotDao.SelectTotalTransferLotQtyByLineId(lot.TrlId);
                    lineDao.Update(line);
                }
                else
                {
                    //若没有其他记录，则Line记录本身也要删除
                    lineDao.Delete(lot.TrlId);
                }

                result = true;

                trans.Complete();
            }

            return result;
        }

        //added by huyong 2013-7-4
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

        [AuthenticateHandler(ActionName = Action_TransferAudit, Description = "库存授权-二级经销商移库审批", Permissoin = PermissionType.Read)]
        public DataSet QueryTransferForAudit(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);
            using (TransferDao dao = new TransferDao())
            {
                return dao.SelectByFilterTransferForAudit(table, start, limit, out totalRowCount);

            }
        }

        /// <summary>
        /// 经销商寄售移库审批
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public bool TransferAudit(Transfer obj, string type, string note)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();
                TransferLineDao lineDao = new TransferLineDao();
                TransferLotDao lotDao = new TransferLotDao();
                LotDao lDao = new LotDao();
                LotMasterDao lmDao = new LotMasterDao();
                ProductDao pDao = new ProductDao();
                AutoNumberBLL auto = new AutoNumberBLL();

                InvTrans invTrans = new InvTrans();


                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(obj.Id);
                //检查物料批次库存

                if (type == "Agree")
                {
                    obj.Status = DealerTransferStatus.Complete.ToString();
                }
                else
                {
                    obj.Status = DealerTransferStatus.Deny.ToString();
                }
                //生成修改日期
                obj.LastUpdateDate = DateTime.Now;
                mainDao.Update(obj);

                //更新Line表的LineNumber
                IList<TransferLine> lines = lineDao.SelectById(obj.Id);

                int lineNumber = 1;

                foreach (TransferLine line in lines)
                {
                    line.LineNbr = lineNumber++;
                    lineDao.Update(line);

                    Hashtable ht = new Hashtable();
                    //插入库存记录
                    if (type == "Agree")
                    {
                        ht = invTrans.SaveInvRelatedTransfer(line, obj, InvTrans.InvTransferType.TransferBorrow);
                    }
                    else
                    {
                        ht = invTrans.SaveInvRelatedTransfer(line, obj, InvTrans.InvTransferType.TransferCancel);
                    }

                    IList<TransferLot> lots = lotDao.SelectByLineId(line.Id);
                    foreach (TransferLot lot in lots)
                    {
                        //插入批次记录
                        invTrans.SaveLotRelatedTransfer(ht, line, lot);
                    }
                }

                //订单操作日志
                if (type == "Agree")
                {
                    this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Approve, note);
                }
                else
                {
                    this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Reject, note);
                }

                result = true;

                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 普通库借货提交草稿，给T1借货给LP使用,只生成借货出库单，并扣减库存。
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public bool BorrowSubmit(Transfer obj, ReceiptType receiptType, out string err)
        {
            bool result = false;
            err = string.Empty;
            //保存主信息

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();

                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(obj.Id);
                if (main.Status == DealerTransferStatus.Draft.ToString())
                {
                    mainDao.Update(obj);
                    result = true;
                }
                trans.Complete();
            }
            //保存主信息出错

            if (!result)
            {
                err = "Submit.Msg.SaveFailed";
                return false;
            }

            //Added By Song Yuqi On 2016-06-12 Begin
            //仅当借货出库时会校验借入方的授权是否有效
            if (receiptType == ReceiptType.Rent || receiptType == ReceiptType.TransferDistribution)
            {
                string errorMessage = this.CheckProductAuth(obj.Id, obj.FromDealerDmaId.Value, obj.ProductLineBumId.Value);
                if (!string.IsNullOrEmpty(errorMessage))
                {
                    err = errorMessage;
                    return false;
                }
            }
            //Added By Song Yuqi On 2016-06-12 End

            result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                TransferDao mainDao = new TransferDao();
                TransferLineDao lineDao = new TransferLineDao();
                TransferLotDao lotDao = new TransferLotDao();
                PoReceiptHeaderDao rhDao = new PoReceiptHeaderDao();
                PoReceiptDao rDao = new PoReceiptDao();
                PoReceiptLotDao rlDao = new PoReceiptLotDao();
                LotDao lDao = new LotDao();
                LotMasterDao lmDao = new LotMasterDao();
                ProductDao pDao = new ProductDao();
                AutoNumberBLL auto = new AutoNumberBLL();

                InvTrans invTrans = new InvTrans();

                //判断表头中状态是否是草稿
                Transfer main = mainDao.GetObject(obj.Id);
                if (main.Status == DealerTransferStatus.Draft.ToString())
                {
                    //检查物料批次库存 检查借入经销商的授权
                    bool isValid = true;

                    if (!CheckDealerToContract(obj.Id, obj.ToDealerDmaId.Value))
                    {
                        isValid = false;
                        err = "Submit.Msg.DealerUnauthorized";
                    }

                    if (isValid && !CheckLotInventory(obj.Id))
                    {
                        isValid = false;
                        err = "Submit.Msg.InventoryCheckFailed";
                    }

                    if (isValid)
                    {
                        //置为提交状态

                        obj.Status = DealerTransferStatus.Complete.ToString();
                        //生成出库单号
                        obj.TransferNumber = auto.GetNextAutoNumber(obj.FromDealerDmaId.Value, OrderType.Next_RentNbr, obj.ProductLineBumId.Value);
                        //生成出库日期
                        obj.TransferDate = DateTime.Now;
                        mainDao.Update(obj);

                        //根据借入经销商再次获得其默认分仓库
                        Guid DealerToWHId = invTrans.GetDefaultWarehouse(obj.ToDealerDmaId.Value);


                        //更新Line表的LineNumber
                        IList<TransferLine> lines = lineDao.SelectById(obj.Id);

                        int lineNumber = 1;

                        foreach (TransferLine line in lines)
                        {
                            line.ToWarehouseWhmId = DealerToWHId;
                            line.LineNbr = lineNumber++;
                            lineDao.Update(line);

                            //插入库存记录
                            Hashtable ht = invTrans.SaveInvRelatedTransfer(line, obj, InvTrans.InvTransferType.TransferRentOnly);

                            IList<TransferLot> lots = lotDao.SelectByLineId(line.Id);
                            foreach (TransferLot lot in lots)
                            {
                                //插入批次记录
                                AddLotMastLotQrEdit(lot, line.TransferPartPmaId, line.FromWarehouseWhmId, DealerToWHId, null);
                                invTrans.SaveLotRelatedTransfer(ht, line, lot);

                            }
                        }

                        this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);

                        err = "Submit.Msg.SubmitSuccess";

                        result = true;
                    }
                }
                else
                {
                    err = "Submit.Msg.SubmitFailed";
                }
                trans.Complete();
            }
            return result;
        }

        /// <summary>
        /// 查询Excel订单导入出错信息
        /// </summary>
        /// <returns></returns>
        public IList<TransferInit> QueryTransferInitErrorData(int start, int limit, out int totalRowCount)
        {
            using (TransferInitDao dao = new TransferInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("User", new Guid(_context.User.Id));
                //param.Add("ErrorFlag", true);
                return dao.SelectByHashtable(param, start, limit, out totalRowCount);
            }
        }

        /// <summary>
        /// 查询Excel订单导入出错信息-借货出库
        /// </summary>
        /// <returns></returns>
        public IList<TransferBorrowInit> QueryTransferBorrowInitErrorData(int start, int limit, out int totalRowCount)
        {
            using (TransferBorrowInitDao dao = new TransferBorrowInitDao())
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
        public bool VerifyTransferInit(string importType, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            //20191028
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (TransferInitDao dao = new TransferInitDao())
            {
                IsValid = dao.Initialize(importType, new Guid(_context.User.Id), Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 调用存储过程处理Excel订单导入数据(借货出库)-20191028
        /// </summary>
        /// <param name="IsValid"></param>
        /// <returns></returns>
        public bool VerifyTransferListInit(string importType, out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            //20191028
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (TransferBorrowInitDao dao = new TransferBorrowInitDao())
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
        public bool ImportTransferInit(DataSet ds, string fileName)
        {
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    TransferInitDao dao = new TransferInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));
                    //读取DataSet数据至数据库
                    int lineNbr = 1;
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        string errString = string.Empty;
                        TransferInit data = new TransferInit();
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
                            errString += "移出仓库名称为空,";
                        }
                        else
                        {
                            data.WarehouseFrom = dr[0].ToString();
                        }
                        if (dr[1] == DBNull.Value)
                        {
                            errString += "移入仓库名称为空,";
                        }
                        else
                        {
                            data.WarehouseTo = dr[1].ToString();
                        }

                        if (dr[2] == DBNull.Value)
                        {
                            errString += "产品型号为空,";
                        }
                        else
                        {
                            data.ArticleNumber = dr[2].ToString();
                        }
                        if (dr[3] == DBNull.Value)
                        {
                            errString += "产品批次号为空,";
                        }
                        else
                        {
                            data.LotNumber = dr[3].ToString();
                        }

                        if (dr[4] == DBNull.Value)
                        {
                            errString += "移库数量为空,";
                        }
                        else
                        {
                            try
                            {
                                data.TransferQty = dr[4] == DBNull.Value ? null : dr[4].ToString();
                                if (!string.IsNullOrEmpty(data.TransferQty))
                                {
                                    decimal qty;
                                    if (!Decimal.TryParse(data.TransferQty, out qty))
                                        data.TransferQtyErrMsg = "移库数量格式不正确";

                                }
                            }
                            catch
                            {
                                errString += "移库数量必须为大于0的整数,";
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


        public bool Import(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    TransferInitDao dao = new TransferInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<TransferInit> list = new List<TransferInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        TransferInit data = new TransferInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        if (_context.User.CorpId.HasValue)
                        {
                            data.DmaId = _context.User.CorpId.Value;
                        }

                        //WarehouseFrom
                        data.WarehouseFrom = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.WarehouseFrom))
                            data.WarehouseFromErrMsg = "移出仓库名称为空";

                        //WarehouseTo
                        data.WarehouseTo = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.WarehouseTo))
                            data.WarehouseToErrMsg = "移入仓库名称为空";

                        //ArticleNumber
                        data.ArticleNumber = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.ArticleNumber))
                            data.ArticleNumberErrMsg = "产品型号为空";

                        //LotNumber
                        data.LotNumber = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (string.IsNullOrEmpty(data.LotNumber))
                            data.LotNumberErrMsg = "产品批次号为空";
                        if (string.IsNullOrEmpty(dr[4] == DBNull.Value ? null : dr[4].ToString()) || dr[4].ToString().ToUpper() == "NOQR")
                        {
                            data.LotNumberErrMsg = data.LotNumberErrMsg + ",二维码为空";
                        }
                        else if (string.IsNullOrEmpty(dr[4] != DBNull.Value ? null : dr[4].ToString()) && string.IsNullOrEmpty(dr[3] != DBNull.Value ? null : dr[3].ToString()) && dr[4].ToString().ToUpper() != "NOQR")
                        {
                            data.LotNumber = data.LotNumber + "@@" + dr[4].ToString();
                        }
                        //Qty
                        data.TransferQty = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        if (!string.IsNullOrEmpty(data.TransferQty))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.TransferQty, out qty))
                                data.TransferQtyErrMsg = "移库数量格式不正确";

                        }
                        else
                        {
                            data.TransferQtyErrMsg = "移库数量为空";
                        }

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.WarehouseFromErrMsg)
                            && string.IsNullOrEmpty(data.WarehouseToErrMsg)
                            && string.IsNullOrEmpty(data.ArticleNumberErrMsg)
                            && string.IsNullOrEmpty(data.LotNumberErrMsg)
                            && string.IsNullOrEmpty(data.TransferQtyErrMsg)
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
        /// 借货出库导入
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public bool TransferListImport(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    TransferBorrowInitDao dao = new TransferBorrowInitDao();
                    //删除上传人的数据
                    dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<TransferBorrowInit> list = new List<TransferBorrowInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        TransferBorrowInit data = new TransferBorrowInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        if (_context.User.CorpId.HasValue)
                        {
                            data.DmaId = _context.User.CorpId.Value;
                        }


                        //DealerFrom
                        data.DealerFrom = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.DealerFrom))
                            data.DealerFromErrMsg = "移出经销商名称为空";

                        //DealerTo
                        data.DealerTo = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.DealerTo))
                            data.DealerToErrMsg = "移入经销商名称为空";

                        //WarehouseFrom
                        data.WarehouseFrom = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (string.IsNullOrEmpty(data.WarehouseFrom))
                            data.WarehouseFromErrMsg = "移出仓库名称为空";

                        //WarehouseTo
                        data.WarehouseTo = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (string.IsNullOrEmpty(data.WarehouseTo))
                            data.WarehouseToErrMsg = "移入仓库名称为空";

                        //ArticleNumber
                        data.ArticleNumber = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (string.IsNullOrEmpty(data.ArticleNumber))
                            data.ArticleNumberErrMsg = "产品型号为空";

                        //LotNumber
                        data.LotNumber = dr[5] == DBNull.Value ? null : dr[5].ToString();
                        if (string.IsNullOrEmpty(data.LotNumber))
                            data.LotNumberErrMsg = "产品批次号为空";
                        if (string.IsNullOrEmpty(dr[6] == DBNull.Value ? null : dr[6].ToString()) || dr[6].ToString().ToUpper() == "NOQR")
                        {
                            data.LotNumberErrMsg = data.LotNumberErrMsg + ",二维码为空";
                        }
                        else if (string.IsNullOrEmpty(dr[6] != DBNull.Value ? null : dr[6].ToString()) && string.IsNullOrEmpty(dr[5] != DBNull.Value ? null : dr[5].ToString()) && dr[6].ToString().ToUpper() != "NOQR")
                        {
                            data.LotNumber = data.LotNumber + "@@" + dr[6].ToString();
                        }
                        //Qty
                        data.TransferQty = dr[7] == DBNull.Value ? null : dr[7].ToString();
                        if (!string.IsNullOrEmpty(data.TransferQty))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.TransferQty, out qty))
                                data.TransferQtyErrMsg = "移库数量格式不正确";

                        }
                        else
                        {
                            data.TransferQtyErrMsg = "移库数量为空";
                        }

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.WarehouseFromErrMsg)
                            && string.IsNullOrEmpty(data.WarehouseToErrMsg)
                            && string.IsNullOrEmpty(data.ArticleNumberErrMsg)
                            && string.IsNullOrEmpty(data.LotNumberErrMsg)
                            && string.IsNullOrEmpty(data.TransferQtyErrMsg)
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

        public void Delete(Guid id)
        {
            using (TransferInitDao dao = new TransferInitDao())
            {
                dao.Delete(id);
            }
        }

        public void Update(TransferInit data)
        {
            using (TransferInitDao dao = new TransferInitDao())
            {
                dao.UpdateForEdit(data);
            }
        }
        #region ITransferBLL 成员

        #endregion


        #region 借货下载接口
        public int InitRentInterfaceForLpByClientID(string clientid, string batchNbr)
        {
            using (TransferDao dao = new TransferDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Clientid", clientid);
                ht.Add("BatchNbr", batchNbr);
                ht.Add("UpdateDate", DateTime.Now);
                return dao.InitTransferByClientID(ht);
            }
        }

        public IList<LpRentData> QueryRentInfoByBatchNbrForLp(string batchNbr)
        {
            using (TransferDao dao = new TransferDao())
            {
                return dao.QueryRentInfoByBatchNbrForLp(batchNbr);
            }
        }

        public void AfterLpRentDataDownload(string BatchNbr, string ClientID, string RtnVal, out string RtnMsg)
        {
            using (TransferDao dao = new TransferDao())
            {
                dao.AfterLpRentDataDownload(BatchNbr, ClientID, RtnVal, out RtnMsg);
            }
        }
        #endregion

        //Added By Song Yuqi On 2016-06-06
        public string CheckProductAuth(Guid id, Guid dealerId, Guid productLineId)
        {
            Hashtable table = new Hashtable();
            table.Add("DealerId", dealerId);
            table.Add("ProductLineId", productLineId);
            table.Add("TransferOrderId", id);

            DealerContracts dc = new DealerContracts();
            table = dc.GetDealerSpecialAuthByType(table, DealerAuthorizationType.Transfer, dealerId, productLineId);

            using (TransferLotDao dao = new TransferLotDao())
            {
                DataSet ds = dao.CheckTransferProductAuthInfo(table);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    return ds.Tables[0].Rows[0][0].ToString();
                }
                return string.Empty;
            }
        }
        public void BorrowTransferDelete(Guid id)
        {
            using (TransferBorrowInitDao dao = new TransferBorrowInitDao())
            {
                dao.Delete(id);
            }
        }

        public void BorrowTransferUpdate(TransferBorrowInit data)
        {
            using (TransferBorrowInitDao dao = new TransferBorrowInitDao())
            {
                dao.UpdateForEdit(data);
            }
        }

        #region 历史移库单导出
        public DataSet SelectByFilterTransferForExport(Hashtable table)
        {
            using (TransferDao dao = new TransferDao())
            {
                table.Add("OwnerIdentityType", this._context.User.IdentityType);
                table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
                table.Add("OwnerId", new Guid(this._context.User.Id));
                table.Add("OwnerCorpId", this._context.User.CorpId);
                BaseService.AddCommonFilterCondition(table);
                return dao.SelectByFilterTransferForExport(table);
            }
        }
        #endregion

        public DataSet SelectLimitBUCount(Guid DMAID)
        {
            using (TransferDao dao = new TransferDao())
            {
                return dao.SelectLimitBUCount(DMAID);
            }
        }

        public DataSet SelectLimitReason(Guid DMAID)
        {
            using (TransferDao dao = new TransferDao())
            {
                return dao.SelectLimitReason(DMAID);
            }
        }

        public DataSet SelectWarehouse(Guid DMAID)
        {
            using (TransferDao dao = new TransferDao())
            {
                return dao.SelectLimitWarehouse(DMAID);
            }
        }
        //冻结库解冻查询
        public DataSet SelectByFilterTransferFrozen(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);
            BaseService.AddCommonFilterCondition(table);

            using (TransferDao dao = new TransferDao())
            {
                return dao.SelectByFilterTransferFrozen(table, start, limit, out totalRowCount);

            }
        }

        /// <summary>
        /// 判断移入和移出经销商红蓝还是否一致
        /// </summary>
        /// <param name="TransferId"></param>
        /// <returns></returns>
        public bool IsTransferDealerTypeEqualByTrnID(Guid FromDMAID, Guid ToDMAID)
        {
            using (TransferDao dao = new TransferDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("FromDMAID", FromDMAID);
                ht.Add("ToDMAID", ToDMAID);
                DataTable dt = dao.SelectDealerMarketType(ht);
                if (dt.Rows[0]["FromMarketType"].ToString() == dt.Rows[0]["ToMarketType"].ToString())
                {
                    return true;
                }

                return false;
            }
        }
    }
}
