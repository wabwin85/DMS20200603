using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DMS.Business
{
    using Coolite.Ext.Web;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security;
    using Lafite.RoleModel.Security.Authorization;
    using DMS.DataAccess;
    using DMS.Model;
    using DMS.Common;
    using System.Data;
    using System.Collections;
    using DMS.Model.Data;
    using DMS.Business.Cache;
    using DMS.Business.DataInterface;

    /// <summary>
    /// DealerMaster 经销商信息维护

    /// </summary>
    public class POReceipt : IPOReceipt
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_DealerReceipt = "DealerReceipt";
        public const string Action_UploadWaybill = "UploadWaybill";
        #endregion

        public POReceipt()
        {

        }

        public PoReceiptHeader GetObject(Guid id)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.GetObject(id);
            }
        }

        public PoReceiptHeader GetObjectAddWarehouse(Guid id)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.GetObjectAddWarehouse(id);
            }
        }

        public IList<PoReceiptHeader> GetAll()
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.GetAll();
            }
        }


        public IList<PoReceiptHeader> SelectByFilter(PoReceiptHeader header)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.SelectByFilter(header);
            }
        }

        [AuthenticateHandler(ActionName = Action_DealerReceipt, Description = "经销商收货", Permissoin = PermissionType.Read)]
        public DataSet QueryPoReceipt(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryPoReceipt(Hashtable table)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));

            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.SelectByFilter(table);
            }
        }

        public int GetPoReceiptCountByDealer(Guid DealerId)
        {
            Hashtable param = new Hashtable();
            param.Add("DealerDmaId", DealerId);
            param.Add("Status", ReceiptStatus.Waiting.ToString());
            param.Add("CanBeReceived", true);
            int count = 0;
            DataSet ds = this.QueryPoReceipt(param);
            if (ds.Tables != null)
            {
                count = ds.Tables[0].Rows.Count;
            }
            return count;
        }

        public DataSet QueryPoReceiptLot(Hashtable table, int start, int limit, out int totalRowCount)
        {
            BaseService.AddCommonFilterCondition(table);
            using (PoReceiptLotDao dao = new PoReceiptLotDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryPoReceiptLot(Hashtable table)
        {
            using (PoReceiptLotDao dao = new PoReceiptLotDao())
            {
                return dao.SelectByFilter(table);
            }
        }

        public string SavePoReceipt(Guid id, Guid WhmId)
        {

            string rtnVal = "";
            string rtnMsg = "";



            PoReceiptHeaderDao mainDao = new PoReceiptHeaderDao();
            DMS.Model.PoReceiptHeader main = mainDao.GetObject(id);

            using (ConsignmentCfnDao dao = new ConsignmentCfnDao())
            {
                dao.PoReceipt(main.SapShipmentid, WhmId, new Guid(this._context.User.Id), out rtnVal, out rtnMsg);
            }
            //using (TransactionScope trans = new TransactionScope())
            //{


            //    #region 确认收货


            //    //if (main.Type == ReceiptType.Rent.ToString())
            //    //{
            //    //    //经销商借货处理
            //    //    Transfer tranMain = tranDao.GetDealerTransferByTransferNumber(main.SapShipmentid);
            //    //    if (tranMain != null && main.Status == ReceiptStatus.Waiting.ToString() && tranMain.Status == DealerTransferStatus.OntheWay.ToString())
            //    //    {
            //    //        //查询明细记录
            //    //        IList<TransferLine> lines = tranlineDao.SelectById(tranMain.Id);
            //    //        foreach (TransferLine line in lines)
            //    //        {
            //    //            //插入库存记录
            //    //            Hashtable ht = invTrans.SaveInvRelatedTransfer(line, tranMain, InvTrans.InvTransferType.TransferBorrow);
            //    //            //查询批次记录
            //    //            IList<TransferLot> lots = tranlotDao.SelectByLineId(line.Id);
            //    //            foreach (TransferLot lot in lots)
            //    //            {
            //    //                //插入批次记录
            //    //                invTrans.SaveLotRelatedTransfer(ht, line, lot);
            //    //            }
            //    //        }

            //    //        //更新主表的状态

            //    //        main.Status = ReceiptStatus.Complete.ToString();
            //    //        main.ReceiptDate = DateTime.Now;
            //    //        main.ReceiptUsrUserID = new Guid(this._context.User.Id);
            //    //        mainDao.Update(main);
            //    //        //更新Transfer表状态

            //    //        tranMain.Status = DealerTransferStatus.Complete.ToString();
            //    //        tranDao.Update(tranMain);
            //    //        this.InsertPurchaseOrderLog(main.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Receipt, null);
            //    //        result = true;
            //    //    }

            //    //}
            //    //else
            //    //{
            //    //    //SAP订单处理
            //    //    if (main.Status == ReceiptStatus.Waiting.ToString())
            //    //    {
            //    //        //查询是否是二级经销商收货,如果供应商是LP，则取得LP的在途库
            //    //        Guid vendorWhmId = Guid.Empty;
            //    //        DealerMaster vendor = DealerCacheHelper.GetDealerById(main.VendorDmaId);
            //    //        if (vendor.DealerType.Equals(DealerType.LP.ToString()) && main.Type != ReceiptType.Complain.ToString())
            //    //        {
            //    //            vendorWhmId = invTrans.GetSystemHoldWarehouse(vendor.Id.Value);
            //    //        }
            //    //        //查询明细记录
            //    //        IList<DMS.Model.PoReceipt> details = detailDao.SelectByPrhId(main.Id);
            //    //        foreach (DMS.Model.PoReceipt detail in details)
            //    //        {
            //    //            //插入库存记录
            //    //            Hashtable ht = invTrans.SaveInvRelatedPOReceipt(detail, main, vendorWhmId);
            //    //            //查询批次记录
            //    //            IList<DMS.Model.PoReceiptLot> lots = lotDao.SelectByPorId(detail.Id);
            //    //            foreach (DMS.Model.PoReceiptLot lot in lots)
            //    //            {
            //    //                //插入批次记录
            //    //                invTrans.SaveLotRelatedPOReceiptLot(ht, lot);
            //    //            }
            //    //        }

            //    //        //更新主表的状态

            //    //        main.Status = ReceiptStatus.Complete.ToString();
            //    //        main.ReceiptDate = DateTime.Now;
            //    //        main.ReceiptUsrUserID = new Guid(this._context.User.Id);
            //    //        mainDao.Update(main);
            //    //        this.InsertPurchaseOrderLog(main.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Receipt, null);
            //    //        result = true;
            //    //    }

            //    //}
            //    #endregion

            //    //根据id查询主记录


            //    trans.Complete();
            //}

            if (rtnVal == "Success")
            {
                return rtnVal;
            }
            else
            {
                return rtnMsg;
            }

        }

        public Boolean CancelPoReceipt(Guid id)
        {
            bool result = false;


            using (TransactionScope trans = new TransactionScope())
            {
                PoReceiptHeaderDao mainDao = new PoReceiptHeaderDao();
                //根据id查询主记录
                DMS.Model.PoReceiptHeader main = mainDao.GetObject(id);

                //只能取消采购入库类型的发货单
                if (main.Type == ReceiptType.PurchaseOrder.ToString())
                {
                    if (main.Status == ReceiptStatus.Waiting.ToString())
                    {
                        String rtnVal = "";
                        String rtnMsg = "";
                        mainDao.CancelPOReceiptByHeaderId(main.Id, new Guid(this._context.User.Id), out rtnVal, out rtnMsg);
                        if (rtnVal == "Failure")
                        {
                            throw new Exception("Error in cancel Purchase Order Receipt!");
                        }
                        result = true;
                    }
                }
                trans.Complete();
            }
            return result;
        }

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

        public DataSet GetPoReceiptProductLine(Guid dealerId)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.GetPoReceiptProductLine(dealerId, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
            }
        }

        /// <summary>
        /// 运单数据上传 
        /// </summary>
        [AuthenticateHandler(ActionName = Action_UploadWaybill, Description = "运单数据上传", Permissoin = PermissionType.Write)]
        public bool Import(DataSet ds, string fileName)
        {
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    WaybillInitDao dao = new WaybillInitDao();
                    //删除上传人的数据
                    dao.DeleteByUserID(new Guid(_context.User.Id));
                    //读取DataSet数据至数据库

                    int lineNbr = 1;
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        string errString = string.Empty;
                        WaybillInit data = new WaybillInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        if (dr[0] == DBNull.Value)
                        {
                            errString += "发货单号为空,";
                        }
                        else
                        {
                            data.SapDeliveryNo = dr[0].ToString();

                        }

                        if (dr[1] == DBNull.Value)
                        {

                            errString += "发货日期为空,";
                        }
                        else
                        {
                            //根据
                            try
                            {
                                data.ShippingDate = Convert.ToDateTime(dr[1].ToString());
                            }
                            catch
                            {
                                errString += "发货日期格式不正确,";
                            }

                        }
                        if (dr[2] == DBNull.Value)
                        {
                            errString += "承运方为空,";
                        }
                        else
                        {

                            data.Carrier = dr[2].ToString();

                        }
                        if (dr[3] == DBNull.Value)
                        {
                            errString += "运单号为空,";
                        }
                        else
                        {

                            data.TrackingNo = dr[3].ToString();

                        }
                        if (dr[4] == DBNull.Value)
                        {
                            errString += "运输方式为空,";
                        }
                        else
                        {

                            data.ShipType = dr[4].ToString();

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

        public bool Verify(out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (WaybillInitDao dao = new WaybillInitDao())
            {
                IsValid = dao.Initialize(new Guid(_context.User.Id));
                result = true;
            }
            return result;
        }

        [AuthenticateHandler(ActionName = Action_UploadWaybill, Description = "运单数据上传", Permissoin = PermissionType.Read)]
        public DataSet GetErrorList(Guid UserId)
        {
            using (WaybillInitDao dao = new WaybillInitDao())
            {
                return dao.GetErrorList(UserId);
            }
        }

        public int DeleteByUserID(Guid UserId)
        {
            using (WaybillInitDao dao = new WaybillInitDao())
            {
                return dao.DeleteByUserID(UserId);
            }
        }

        public void Insert(WaybillInit obj)
        {
            using (WaybillInitDao dao = new WaybillInitDao())
            {
                dao.Insert(obj);
            }
        }

        public string Initialize(Guid UserId)
        {
            using (WaybillInitDao dao = new WaybillInitDao())
            {
                return dao.Initialize(UserId);
            }
        }

        public double GetReceiptTotalAmount(Guid id)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (PoReceiptLotDao dao = new PoReceiptLotDao())
            {
                return dao.GetReceiptTotalAmountByHeaderId(id, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));
            }
        }

        public double GetReceiptTotalQty(Guid id)
        {
            using (PoReceiptLotDao dao = new PoReceiptLotDao())
            {
                return dao.GetReceiptTotalQtyByHeaderId(id);
            }
        }

        /// <summary>
        /// 导出查询结果
        /// </summary>
        /// <param name="totalRowCount"></param>
        /// <returns></returns>
        public DataSet QueryPoReceiptForExport(Hashtable table)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            BaseService.AddCommonFilterCondition(table);
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.SelectByFilterForExport(table);
            }
        }
        public bool POReceImport(DataTable dt, string fileName, out string batchNumber, out string ClientID, out string Messinge)
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
                    DeliveryBLL business = new DeliveryBLL();
                    IList<InterfaceShipment> importData = new List<InterfaceShipment>();

                    int line = 0;
                    ClientDao Cdao = new ClientDao();
                    Client C = new Client();
                    C.CorpId = _context.User.CorpId.Value;
                    C.ActiveFlag = true;
                    IList<Client> list = Cdao.GetAll();
                    C = list.First(p => p.CorpId == _context.User.CorpId.Value && p.ActiveFlag == true);
                    ClientID = C.Id;
                    batchNumber = GetBatchNumber(C.Id.ToString(), DataInterfaceType.LpDeliveryUploader);

                    foreach (DataRow row in dt.Rows)
                    {
                        if (line != 0)
                        {
                            InterfaceShipment Ishipment = new InterfaceShipment();

                            Ishipment.Id = Guid.NewGuid();
                            Ishipment.DealerSapCode = row[0] == DBNull.Value ? "" : row[0].ToString();
                            Ishipment.OrderNo = row[1] == DBNull.Value ? "" : row[1].ToString();
                            Ishipment.SapDeliveryNo = row[2] == DBNull.Value ? "" : row[2].ToString();
                            if (row[3] != DBNull.Value)
                            {
                                DateTime dtm;
                                if (DateTime.TryParse(row[3].ToString(), out dtm))
                                {
                                    Ishipment.SapDeliveryDate = dtm;
                                }
                                else
                                {
                                    row[3] = DBNull.Value;
                                }
                            }
                            Ishipment.ShipmentType = row[4] == DBNull.Value ? "" : row[4].ToString();
                            Ishipment.ArticleNumber = row[5] == DBNull.Value ? "" : row[5].ToString();
                            Ishipment.LotNumber = row[6] == DBNull.Value ? "" : row[6].ToString();
                            Ishipment.QrCode = row[7] == DBNull.Value ? Ishipment.QrCode : row[7].ToString();
                            if (row[8] != DBNull.Value)
                            {
                                Decimal dc;

                                if (Decimal.TryParse(row[8].ToString(), out dc))
                                {
                                    Ishipment.DeliveryQty = dc;
                                }
                                else
                                {
                                    row[8] = DBNull.Value;
                                }
                            }
                            // Ishipment.DeliveryQty = row[8] == DBNull.Value ? Ishipment.DeliveryQty : Convert.ToDecimal(row[8].ToString());
                            // Ishipment.UnitPrice = row[9] == DBNull.Value ? Ishipment.DeliveryQty : Convert.ToDecimal(row[9].ToString());
                            if (row[9] != DBNull.Value)
                            {
                                Decimal dc;

                                if (Decimal.TryParse(row[9].ToString(), out dc))
                                {
                                    Ishipment.UnitPrice = dc;
                                }
                                else
                                {
                                    row[9] = DBNull.Value;
                                }
                            }
                            Ishipment.LineNbr = line;
                            Ishipment.ImportDate = DateTime.Now;
                            Ishipment.Clientid = C.Id;
                            Ishipment.BatchNbr = batchNumber;
                            //Ishipment.ToWhmCode = row[10] == DBNull.Value ? "" : row[10].ToString();

                            if (!string.IsNullOrEmpty(Ishipment.DealerSapCode) && !string.IsNullOrEmpty(Ishipment.OrderNo) && !string.IsNullOrEmpty(Ishipment.SapDeliveryNo)
                                && row[3] != DBNull.Value && (!string.IsNullOrEmpty(Ishipment.ShipmentType) && (Ishipment.ShipmentType == "Normal"
                                || Ishipment.ShipmentType == "Consignment" || Ishipment.ShipmentType == "Lend")) && !string.IsNullOrEmpty(Ishipment.ArticleNumber) && !string.IsNullOrEmpty(Ishipment.LotNumber) && !string.IsNullOrEmpty(Ishipment.QrCode)
                                && row[8] != DBNull.Value && row[9] != DBNull.Value)
                            {
                                //校验用户是否已经填写必填的信息

                                importData.Add(Ishipment);

                            }
                            else
                            {
                                Messinge = Messinge + "订单号" + Ishipment.OrderNo + "信息填写不完整,或者格式错误;行号" + (line + 1) + "\r\n";
                            }

                        }
                        line = line + 1;
                    }
                    //一张发货单号不能对应多张采购单编号
                    //if (Messinge == string.Empty)
                    //{
                    //    int Brcount = importData.Select(p => p.OrderNo).Distinct().Count();
                    //    if (Brcount > 1)
                    //    {
                    //        Messinge = Messinge + "一张发货单号不能对应多张采购单编号";
                    //    }
                    //        int qty = importData.Select(p => p.DeliveryQty).ToList().Count();
                    //    if (qty > 0)
                    //    {
                    //        Messinge = Messinge + "发货数量,必须大于0";
                    //    }
                    //    int price = importData.Select(p => p.UnitPrice <= 0).ToList().Count();
                    //    if (price > 0)
                    //    {
                    //        Messinge = Messinge + "产品金额,必须大于0";
                    //    }
                    //}
                    if (string.IsNullOrEmpty(Messinge))
                    {

                        business.ImportInterfaceShipment(importData);
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
        public DataSet SelectPoreCeExistsDma(string batchNumber, string DmaId)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.SelectPoreCeExistsDma(batchNumber, DmaId);
            }
        }
        public DataSet DistinctInterfaceShipmentBYBatchNbr(string BatchNbr)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.DistinctInterfaceShipmentBYBatchNbr(BatchNbr);
            }
        }
        public DataSet SelectInterfaceShipmentBYBatchNbrQtyUnprice(string BatchNbr)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.SelectInterfaceShipmentBYBatchNbrQtyUnprice(BatchNbr);
            }
        }
        public static string GetBatchNumber(string clientid, DataInterfaceType type)
        {
            AutoNumberBLL autoNbr = new AutoNumberBLL();
            return autoNbr.GetNextAutoNumberForInt(clientid, type);
        }
        public DataSet SelectInterfaceShipmentBYBatchNbr(string BatchNbr, int start, int limit, out int totalRowCount)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.SelectInterfaceShipmentBYBatchNbr(BatchNbr, start, limit, out totalRowCount);
            }
        }
        public PoReceiptHeader GetPoReceiptHeaderByOrderNo(string OrderNo)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.GetPoReceiptHeaderByOrderNo(OrderNo);
            }
        }
        public bool UpdatePoReceipHeaderDate(PoReceiptHeader Header)
        {
            bool result = false;
            try
            {
                using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
                {
                    dao.Update(Header);
                    result = true;
                }
            }
            catch (Exception e)
            {
                result = false;
            }
            return result;
        }

        public bool DeletePOReceipt(string ProOrderNo)
        {

            bool result = false;
            try
            {
                using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
                {
                    dao.DeletePoReceipt(ProOrderNo);
                    result = true;
                }
            }
            catch (Exception e)
            {
                result = false;
            }
            return result;


        }

        public bool DeliveryNoteBSCSLC(string ProOrderNo)
        {
            bool result = false;
            try
            {
                using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
                {
                    dao.DeleteDeliveryNoteBSCSLC(ProOrderNo);
                    result = true;
                }
            }
            catch (Exception e)
            {
                result = false;
            }
            return result;
        }

        public DataSet GetPOReceiptHeader_SAPNoQR(string ProOrderNo)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.GetPOReceiptHeader_SAPNoQR(ProOrderNo); ;
            }
        }

        public bool UpdatePOReceiptHeader_SAPNoQR(string ProOrderNo)
        {
            bool result = false;
            try
            {
                using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
                {
                    dao.UpdatePOReceiptHeader_SAPNoQR(ProOrderNo);
                    result = true;
                }
            }
            catch (Exception e)
            {
                result = false;
            }
            return result;
        }

        public DataSet DNB_BatchNbr(string ProOrderNo)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.GetDeliveryNoteBSCSLC(ProOrderNo);
            }
        }
    }

    /// <summary>
    /// 处理采购接收单头
    /// </summary>
    public class PoReceiptHeaders : IPoReceiptHeaders
    {

        public PoReceiptHeaders()
        {

        }

        public PoReceiptHeader GetPoReceiptHeader(Guid Id)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.GetObject(Id);
            }
        }


        public IList<PoReceiptHeader> QueryForWarehouse(PoReceiptHeader poHeader)
        {
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                return dao.SelectByFilter(poHeader);
            }
        }

        #region CUID functions
        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        public bool Insert(PoReceiptHeader poHeader)
        {
            bool result = false;
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                dao.Insert(poHeader);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="hospital"></param>
        /// <returns></returns>
        public bool Update(PoReceiptHeader poHeader)
        {
            bool result = false;
            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                int afterRow = dao.Update(poHeader);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        public bool Delete(PoReceiptHeader poHeader)
        {
            bool result = false;

            using (PoReceiptHeaderDao dao = new PoReceiptHeaderDao())
            {
                int afterRow = dao.Delete(poHeader);
            }
            return result;
        }
        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中 Todo
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool SaveChanges(ChangeRecords<PoReceiptHeader> data)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                foreach (PoReceiptHeader poHeader in data.Updated)
                {
                    this.Update(poHeader);
                }

                foreach (PoReceiptHeader poHeader in data.Created)
                {
                    this.Insert(poHeader);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }

        #endregion

    }

    /// <summary>
    /// 处理采购接收单行
    /// </summary>
    public class PoReceipts : IPoReceipts
    {

        public PoReceipts()
        {

        }

        public PoReceipt GetPoReceiptLine(Guid Id)
        {
            using (PoReceiptDao dao = new PoReceiptDao())
            {
                return dao.GetObject(Id);
            }
        }


        public IList<PoReceipt> QueryForWarehouse(PoReceipt poReceiptLine)
        {
            using (PoReceiptDao dao = new PoReceiptDao())
            {
                return dao.SelectByFilter(poReceiptLine);
            }
        }

        #region CUID functions
        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="poReceiptLine"></param>
        /// <returns></returns>
        public bool Insert(PoReceipt poReceiptLine)
        {
            bool result = false;
            using (PoReceiptDao dao = new PoReceiptDao())
            {
                dao.Insert(poReceiptLine);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="poReceiptLine"></param>
        /// <returns></returns>
        public bool Update(PoReceipt poReceiptLine)
        {
            bool result = false;
            using (PoReceiptDao dao = new PoReceiptDao())
            {
                int afterRow = dao.Update(poReceiptLine);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="poReceiptLine"></param>
        /// <returns></returns>
        public bool Delete(PoReceipt poReceiptLine)
        {
            bool result = false;

            using (PoReceiptDao dao = new PoReceiptDao())
            {
                int afterRow = dao.Delete(poReceiptLine);
            }
            return result;
        }
        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中 Todo
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool SaveChanges(ChangeRecords<PoReceipt> data)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                foreach (PoReceipt poReceiptLine in data.Updated)
                {
                    this.Update(poReceiptLine);
                }

                foreach (PoReceipt poReceiptLine in data.Created)
                {
                    this.Insert(poReceiptLine);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }
        #endregion

    }

    /// <summary>
    /// 处理采购接收单批次行
    /// </summary>
    public class PoReceiptLots : IPoReceiptLots
    {

        public PoReceiptLots()
        {

        }

        public PoReceiptLot GetPoReceiptLot(Guid Id)
        {
            using (PoReceiptLotDao dao = new PoReceiptLotDao())
            {
                return dao.GetObject(Id);
            }
        }


        public IList<PoReceiptLot> QueryForWarehouse(PoReceiptLot poReceiptLot)
        {
            using (PoReceiptLotDao dao = new PoReceiptLotDao())
            {
                return dao.SelectByFilter(poReceiptLot);
            }
        }

        #region CUID functions
        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="poReceiptLine"></param>
        /// <returns></returns>
        public bool Insert(PoReceiptLot poReceiptLot)
        {
            bool result = false;
            using (PoReceiptLotDao dao = new PoReceiptLotDao())
            {
                dao.Insert(poReceiptLot);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="poReceiptLine"></param>
        /// <returns></returns>
        public bool Update(PoReceiptLot poReceiptLot)
        {
            bool result = false;
            using (PoReceiptLotDao dao = new PoReceiptLotDao())
            {
                int afterRow = dao.Update(poReceiptLot);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="poReceiptLine"></param>
        /// <returns></returns>
        public bool Delete(PoReceiptLot poReceiptLot)
        {
            bool result = false;

            using (PoReceiptLotDao dao = new PoReceiptLotDao())
            {
                int afterRow = dao.Delete(poReceiptLot);
            }
            return result;
        }
        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中 Todo
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool SaveChanges(ChangeRecords<PoReceiptLot> data)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                foreach (PoReceiptLot poReceiptLot in data.Updated)
                {
                    this.Update(poReceiptLot);
                }

                foreach (PoReceiptLot poReceiptLot in data.Created)
                {
                    this.Insert(poReceiptLot);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }
        #endregion


    }


    public class ArrivalDate : IArrivalDate
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_UploadArrivalDate = "UploadArrivalDate";
        #endregion

        /// <summary>
        /// 运单数据上传 
        /// </summary>
        [AuthenticateHandler(ActionName = Action_UploadArrivalDate, Description = "最终到货日期数据上传", Permissoin = PermissionType.Write)]
        public bool ImportArrivalDate(DataSet ds, string fileName)
        {
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ArrivalDateInitDao dao = new ArrivalDateInitDao();
                    //删除上传人的数据
                    dao.DeleteByUserId(new Guid(_context.User.Id));
                    //读取DataSet数据至数据库

                    int lineNbr = 1;
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        string errString = string.Empty;
                        ArrivalDateInit data = new ArrivalDateInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        if (dr[0] == DBNull.Value)
                        {
                            errString += "承运方为空,";
                        }
                        else
                        {
                            data.Carrier = dr[0].ToString();

                        }
                        if (dr[1] == DBNull.Value)
                        {
                            errString += "运单号为空,";
                        }
                        else
                        {

                            data.TrackingNo = dr[1].ToString();

                        }
                        if (dr[2] == DBNull.Value)
                        {

                            errString += "送达日期为空,";
                        }
                        else
                        {
                            //根据
                            try
                            {
                                data.ArrivalDate = Convert.ToDateTime(dr[2].ToString());
                            }
                            catch
                            {
                                errString += "送达日期格式不正确,";
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

        public bool Verify(out string IsValid, string FileName)
        {
            bool result = false;
            //调用存储过程验证数据
            using (ArrivalDateInitDao dao = new ArrivalDateInitDao())
            {
                IsValid = dao.Initialize(new Guid(_context.User.Id), FileName);
                result = true;
            }
            return result;
        }

        [AuthenticateHandler(ActionName = Action_UploadArrivalDate, Description = "最终到货日期数据上传", Permissoin = PermissionType.Read)]
        public DataSet GetArrivalDateErrorList(Guid UserId, string FileName)
        {
            using (ArrivalDateInitDao dao = new ArrivalDateInitDao())
            {
                return dao.GetErrorList(UserId, FileName);
            }
        }


        public void InsertArrivalDate(ArrivalDateInit obj)
        {
            using (ArrivalDateInitDao dao = new ArrivalDateInitDao())
            {
                dao.Insert(obj);
            }
        }

        public string InitializeArrivalDate(Guid UserId, string FileName)
        {
            using (ArrivalDateInitDao dao = new ArrivalDateInitDao())
            {
                return dao.Initialize(UserId, FileName);
            }
        }
    }

    public class SendInvoice : ISendInvoice
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        #region Action Define
        public const string Action_UploadSendInvoice = "UploadSendInvoice";
        #endregion

        /// <summary>
        /// 运单数据上传 
        /// </summary>
        [AuthenticateHandler(ActionName = Action_UploadSendInvoice, Description = "发票寄送数据上传", Permissoin = PermissionType.Write)]
        public bool ImportSendInvoice(DataSet ds, string fileName)
        {
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    SendInvoiceInitDao dao = new SendInvoiceInitDao();
                    //删除上传人的数据
                    dao.DeleteByUserId(new Guid(_context.User.Id));
                    //读取DataSet数据至数据库

                    int lineNbr = 1;
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        string errString = string.Empty;
                        SendInvoiceInit data = new SendInvoiceInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = DateTime.Now;
                        data.FileName = fileName;

                        if (dr[0] == DBNull.Value)
                        {
                            errString += "经销商ERP Account为空,";
                        }
                        else
                        {
                            data.SapCode = dr[0].ToString();

                        }
                        if (dr[1] == DBNull.Value)
                        {
                            errString += "经销商中文名称为空,";
                        }
                        else
                        {

                            data.DmaChineseName = dr[1].ToString();

                        }
                        if (dr[2] == DBNull.Value)
                        {
                            data.InvoiceNo = "";
                        }
                        else
                        {

                            data.InvoiceNo = dr[2].ToString();

                        }
                        if (dr[3] == DBNull.Value)
                        {
                            errString += "承运方为空,";
                        }
                        else
                        {

                            data.Carrier = dr[3].ToString();

                        }
                        if (dr[4] == DBNull.Value)
                        {
                            errString += "运单号为空,";
                        }
                        else
                        {

                            data.TrackingNo = dr[4].ToString();

                        }
                        if (dr[5] == DBNull.Value)
                        {

                            errString += "寄送日期为空,";
                        }
                        else
                        {
                            //根据
                            try
                            {
                                data.SendDate = Convert.ToDateTime(dr[5].ToString());
                            }
                            catch
                            {
                                errString += "寄送日期格式不正确,";
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

        /// <summary>
        /// 验证数据
        /// </summary>
        /// <param name="IsValid"></param>
        /// <returns></returns>
        public bool Verify(out string IsValid)
        {
            bool result = false;
            //调用存储过程验证数据
            using (SendInvoiceInitDao dao = new SendInvoiceInitDao())
            {
                IsValid = dao.Initialize(new Guid(_context.User.Id));
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 获取错误信息
        /// </summary>
        /// <param name="UserId"></param>
        /// <returns></returns>
        [AuthenticateHandler(ActionName = Action_UploadSendInvoice, Description = "发票寄送数据上传", Permissoin = PermissionType.Read)]
        public DataSet GetSendInvoiceErrorList(Guid UserId)
        {
            using (SendInvoiceInitDao dao = new SendInvoiceInitDao())
            {
                return dao.GetErrorList(UserId);
            }
        }

        /// <summary>
        /// 新增数据
        /// </summary>
        /// <param name="obj"></param>
        public void InsertSendInvoice(SendInvoiceInit obj)
        {
            using (SendInvoiceInitDao dao = new SendInvoiceInitDao())
            {
                dao.Insert(obj);
            }
        }



    }
}
