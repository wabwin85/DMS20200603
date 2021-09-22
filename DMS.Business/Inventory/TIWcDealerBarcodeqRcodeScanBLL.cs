using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Collections;
using DMS.DataAccess;
using Lafite.RoleModel.Security;
using Grapecity.DataAccess.Transaction;
using DMS.Model;
using DMS.Model.Data;
using DMS.Common;
namespace DMS.Business
{
    public class TIWcDealerBarcodeqRcodeScanBLL : ITIWcDealerBarcodeqRcodeScanBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        public DataSet QueryTIWcDealerBarcodeqRcodeScanByFilter(Hashtable table)
        {
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                table.Add("OwnerIdentityType", this._context.User.IdentityType);
                table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
                table.Add("OwnerId", new Guid(this._context.User.Id));
                BaseService.AddCommonFilterCondition(table);

                return dao.QueryTIWcDealerBarcodeqRcodeScanByFilter(table);
            }
        }

        public DataSet QueryTIWcDealerBarcodeqRcodeScanByFilter(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                table.Add("OwnerIdentityType", this._context.User.IdentityType);
                table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
                table.Add("OwnerId", new Guid(this._context.User.Id));
                BaseService.AddCommonFilterCondition(table);

                return dao.QueryTIWcDealerBarcodeqRcodeScanByFilter(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryInventoryqrOperationByFilter(Hashtable table)
        {
            BaseService.AddCommonFilterCondition(table);
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                return dao.QueryInventoryqrOperationByFilter(table);
            }
        }

        public bool AddItem(Guid userId, Guid dealerId, string lotString, string operationType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                dao.AddItem(userId, dealerId, lotString, operationType, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        public bool DeleteItem(Guid Id)
        {
            bool result = false;
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                dao.FakeDelete(Id);
                result = true;
            }
            return result;
        }

        public bool DeleteItems(string[] param)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
                {
                    foreach (string Id in param)
                    {
                        dao.FakeDelete(new Guid(Id.Split('@')[1]));
                    }

                    trans.Complete();

                    result = true;

                    return result;
                }
            }
        }

        public bool DeleteOperationItem(string Id)
        {
            using (InventoryqrOperationDao dao = new InventoryqrOperationDao())
            {
                int i = dao.Delete(new Guid(Id));
                if (i > 0)
                    return true;

                return false;
            }
        }

        public bool DeleteOperationItem(string dealerId, string operatinType)
        {
            using (InventoryqrOperationDao dao = new InventoryqrOperationDao())
            {
                Hashtable table = new Hashtable();

                table.Add("DealerId", dealerId);
                table.Add("OperationType", operatinType);

                int i = dao.DeleteInventoryqrOperationByFilter(table);
                if (i > 0)
                    return true;

                return false;
            }
        }

        public bool UpdateOperationItemForShipment(Guid Id, decimal qty, decimal? price)
        {
            using (InventoryqrOperationDao dao = new InventoryqrOperationDao())
            {
                Hashtable table = new Hashtable();

                table.Add("Id", Id.ToString());
                table.Add("Qty", qty.ToString());
                table.Add("ShipmentPrice", price);

                int i = dao.UpdateInventoryqrOperationForShipmentEdit(table);
                if (i > 0)
                    return true;

                return false;
            }
        }

        public bool SubmitShipment(Guid dealerId, Guid productLineId, Guid hospitalId, DateTime shipmentDate, string headXmlString, out string rtnVal, out string rtnMsg)
        {
            bool result = false;
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (InventoryqrOperationDao dao = new InventoryqrOperationDao())
            {
                dao.SubmitShipment(new Guid(_context.User.Id), dealerId, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), productLineId, hospitalId, shipmentDate, headXmlString, out rtnVal, out rtnMsg);

                if (rtnVal == "Success")
                {
                    result = true;
                }
            }
            return result;
        }

        public bool UpdateOperationItemForTransfer(Guid Id, decimal qty, Guid? toWarehouseId)
        {
            using (InventoryqrOperationDao dao = new InventoryqrOperationDao())
            {
                Hashtable table = new Hashtable();

                table.Add("Id", Id.ToString());
                table.Add("Qty", qty.ToString());
                table.Add("ToWarehouseId", toWarehouseId);

                int i = dao.UpdateInventoryqrOperationForTransferEdit(table);
                if (i > 0)
                    return true;

                return false;
            }
        }

        public bool UpdateInventoryqrOfToWarahouseIdByFilter(Hashtable table)
        {
            using (InventoryqrOperationDao dao = new InventoryqrOperationDao())
            {
                int i = dao.UpdateInventoryqrOfToWarahouseIdByFilter(table);
                if (i > 0)
                    return true;

                return false;
            }
        }

        public bool SubmitTransfer(Guid dealerId, Guid productLineId, string transferType, out string rtnVal, out string rtnMsg)
        {
            bool result = false;
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (InventoryqrOperationDao dao = new InventoryqrOperationDao())
            {
                dao.SubmitTransfer(new Guid(_context.User.Id), dealerId, productLineId, transferType, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out rtnVal, out rtnMsg);

                if (rtnVal == "Success")
                {
                    result = true;
                }
            }
            return result;
        }

        public TIWcDealerBarcodeqRcodeScan GetObject(Guid Id)
        {
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                return dao.GetObject(Id);
            }
        }

        public DataSet QueryTIWcDealerBarcodeqRcodeScanByUpnCode(Hashtable table)
        {
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                return dao.QueryTIWcDealerBarcodeqRcodeScanByUpnCode(table);
            }
        }

        public DataSet SelectCfnBUby(string Upn)
        {
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                return dao.SelectCfnBUby(Upn);
            }
        }

        public DataSet QueryTIWShipmentCfnBY(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                return dao.QueryTIWShipmentCfnBY(table, start, limit, out totalRowCount);
            }
        }

        public void QrCodeConvert_CheckSumbit(Guid DealerId, string NewQrCode, string LotString, string LotNumber, string Upn, string QrCode, string User, string ShipHeadId, string PamaId, string WhmId, out string rtnVal, out string rtnMsg)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                dao.QrCodeConvert_CheckSumbit(DealerId, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), NewQrCode, LotString, LotNumber, Upn, QrCode, User, ShipHeadId, PamaId, WhmId, out rtnVal, out rtnMsg);
            }
        }

        public DataSet SelectStockCfnBYUpnQrCodeLot(Hashtable table)
        {

            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                return dao.SelectStockCfnBYUpnQrCodeLot(table);
            }
        }

        public void StockQrCodeConvertCheckedSumbit(Guid DealerId, string StockInQrCode, string LotNumber, string Upn, string UserId, string WhmId, out string RtnVal, out string RtnMsg)
        {
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                dao.StockQrCodeConvertCheckedSumbit(DealerId, StockInQrCode, LotNumber, Upn, UserId, WhmId, out RtnVal, out RtnMsg);
            }
        }

        public bool StockSumbit(Guid DealerId, string LotNumber, string StockInQrCdoe, string StoCkOutQrCode, string WhmId, string Upn, string ProductLineBumId)
        {
            AutoNumberBLL auto = new AutoNumberBLL();
            InventoryAdjustHeaderDao mainDao = new InventoryAdjustHeaderDao();
            InventoryAdjustDetailDao lineDao = new InventoryAdjustDetailDao();
            InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
            LotDao ldao = new LotDao();
            InvTrans invTrans = new InvTrans();
            InventoryDao InvDao = new InventoryDao();

            InventoryAdjustDetail line = null;
            InventoryAdjustDetail lineIn = null;
            InventoryAdjustLot lot = null;

            InventoryAdjustBLL InvBll = new InventoryAdjustBLL();
            WarehouseDao waredao = new WarehouseDao();
            Warehouse ware = waredao.GetObject(new Guid(WhmId));
            //获取要出库的产品明细
            Hashtable table = new Hashtable();
            table.Add("LotNumber", LotNumber);
            table.Add("Upn", Upn);
            table.Add("QrCode", StoCkOutQrCode);
            table.Add("WarehouseId", WhmId);
            table.Add("DealerId", DealerId);
            DataSet ds = this.SelectStockCfnBYUpnQrCodeLot(table);
            //出库主单据
            InventoryAdjustHeader HeaderOut = new InventoryAdjustHeader();
            HeaderOut.Id = Guid.NewGuid();
            HeaderOut.InvAdjNbr = auto.GetNextAutoNumber(DealerId, OrderType.Next_AdjustNbr, ProductLineBumId);
            HeaderOut.Reason = "StockOut";
            HeaderOut.DmaId = DealerId;
            HeaderOut.ApprovalDate = DateTime.Now;
            HeaderOut.CreateDate = DateTime.Now;
            HeaderOut.UserDescription = "二维码替换：" + StoCkOutQrCode + "替换" + StockInQrCdoe;
            HeaderOut.Status = "Submit";
            HeaderOut.CreateUser = new Guid(_context.User.Id);
            HeaderOut.ProductLineBumId = new Guid(ProductLineBumId);
            HeaderOut.WarehouseType = "Normal";

            //入库主单据
            InventoryAdjustHeader HeaderIn = new InventoryAdjustHeader();
            HeaderIn.Id = Guid.NewGuid();
            HeaderIn.InvAdjNbr = auto.GetNextAutoNumber(DealerId, OrderType.Next_AdjustNbr, ProductLineBumId);
            HeaderIn.Reason = "StockIn";
            HeaderIn.DmaId = DealerId;
            HeaderIn.ApprovalDate = DateTime.Now;
            HeaderIn.CreateDate = DateTime.Now;
            HeaderIn.UserDescription = "二维码替换：" + StoCkOutQrCode + "替换" + StockInQrCdoe;
            HeaderIn.Status = "Submit";
            HeaderIn.CreateUser = new Guid(_context.User.Id);
            HeaderIn.ProductLineBumId = new Guid(ProductLineBumId);
            HeaderIn.WarehouseType = "Normal";

            bool bl = true;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {


                    mainDao.Insert(HeaderOut);
                    mainDao.Insert(HeaderIn);
                    double sum = 0;
                    #region  / /生成出库单
                    //遍历出库产品明细
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        #region 生成出货产品明细
                        line = InvBll.GetInventoryAdjustDetailByIndex(HeaderOut.Id, new Guid(ds.Tables[0].Rows[i]["PMAId"].ToString()));
                        if (line == null)
                        {
                            //如果记录不存在，则新增记录

                            line = new InventoryAdjustDetail();
                            line.Id = Guid.NewGuid();
                            line.IahId = HeaderOut.Id;
                            line.PmaId = new Guid(ds.Tables[0].Rows[i]["PMAId"].ToString());
                            line.Quantity = 0;
                            line.LineNbr = 0;
                            lineDao.Insert(line);
                        }
                        //出库明细
                        lot = new InventoryAdjustLot();
                        lot.Id = Guid.NewGuid();
                        lot.IadId = line.Id;
                        lot.LotId = new Guid(ds.Tables[0].Rows[i]["Id"].ToString());
                        lot.LotQty = Double.Parse(ds.Tables[0].Rows[i]["Qty"].ToString());
                        lot.WhmId = new Guid(WhmId);
                        lot.LotNumber = ds.Tables[0].Rows[i]["LotNumber"].ToString() + "@@" + ds.Tables[0].Rows[i]["QrCode"].ToString();

                        if (ds.Tables[0].Rows[i]["ExpiredDate"].ToString() == "")
                        {
                            lot.ExpiredDate = null;
                        }
                        else
                        {
                            lot.ExpiredDate = DateTime.ParseExact(ds.Tables[0].Rows[i]["ExpiredDate"].ToString(), "yyyyMMdd", null);
                        }
                        lotDao.Insert(lot);
                        #endregion

                        #region 库存操作
                        invTrans.SaveInvRelatedInventoryAdjust(line, lot, (AdjustType)Enum.Parse(typeof(AdjustType), "StockOut", true), AdjustStatus.Submit, new Guid(WhmId), null);

                        line.LineNbr = line.LineNbr + 1;
                        line.Quantity = line.Quantity + double.Parse(ds.Tables[0].Rows[i]["Qty"].ToString());
                        lineDao.Update(line);
                        sum = sum + double.Parse(ds.Tables[0].Rows[i]["Qty"].ToString());


                        #endregion

                    }
                    //记录订单日志
                    InvBll.InsertPurchaseOrderLog(HeaderOut.Id, new Guid(_context.User.Id), PurchaseOrderOperationType.CreateShipment, "二维码替换：" + StoCkOutQrCode + "替换" + StockInQrCdoe);
                    #endregion

                    #region //生成入库单明细
                    lineIn = InvBll.GetInventoryAdjustDetailByIndex(HeaderIn.Id, line.PmaId);
                    if (lineIn == null)
                    {
                        lineIn = new InventoryAdjustDetail();
                        lineIn.Id = Guid.NewGuid();
                        lineIn.IahId = HeaderIn.Id;
                        lineIn.PmaId = line.PmaId;
                        lineIn.Quantity = 0;
                        lineIn.LineNbr = 1;
                        lineDao.Insert(lineIn);


                    }
                    lineIn.Quantity = lineIn.Quantity + sum;
                    LotMasters ltmBLL = new LotMasters();
                    LotMaster lm = null;
                    lm = ltmBLL.SelectLotMasterByLotNumber(LotNumber + "@@" + StockInQrCdoe, lineIn.PmaId);
                    if (lm == null)
                    {
                        //如果该批次不存在
                        lm = new LotMaster();
                        lm.Id = Guid.NewGuid();
                        lm.LotNumber = LotNumber + "@@" + StockInQrCdoe;
                        lm.ExpiredDate = DateTime.ParseExact(ds.Tables[0].Rows[0]["ExpiredDate"].ToString(), "yyyyMMdd", null);
                        lm.CreateDate = DateTime.Now;
                        lm.ProductPmaId = lineIn.PmaId;
                        if (ds.Tables[0].Rows[0]["LtmYtype"] != DBNull.Value)
                        {
                            lm.Type = ds.Tables[0].Rows[0]["LtmYtype"].ToString();
                        }
                        ltmBLL.Insert(lm);
                    }
                    Inventory inv = new Inventory();
                    Inventories invBLL = new Inventories();
                    inv.WhmId = new Guid(WhmId);
                    inv.PmaId = lineIn.PmaId;
                    IList<Inventory> invList = invBLL.QueryForInventory(inv);
                    if (invList == null || invList.Count == 0)
                    {
                        //如果产品库存不存在
                        inv.Id = Guid.NewGuid();
                        inv.OnHandQuantity = 0;
                        invBLL.Insert(inv);
                    }
                    else
                    {
                        inv = invList[0];
                    }
                    //入库的的库存在原来的库存上加上这次出库库存的总和
                    inv.OnHandQuantity = inv.OnHandQuantity + sum;
                    Hashtable htForLotSave = new Hashtable();
                    htForLotSave.Add("InvId", inv.Id.Value);
                    htForLotSave.Add("LtmId", lm.Id);
                    Lots lotBLL = new Lots();
                    Lot l = null;

                    IList<Lot> lotList = lotBLL.SelectLotsByLotMasterAndWarehouse(htForLotSave);

                    if (lotList.Count == 0)
                    {
                        l = new Lot();
                        l.Id = Guid.NewGuid();
                        l.InvId = inv.Id.Value;
                        l.LtmId = lm.Id;

                        l.OnHandQty = 0;
                        lotBLL.Insert(l);

                    }
                    else
                    {
                        l = lotList[0];
                    }
                    //入库明细
                    InventoryAdjustLot invlotin = new InventoryAdjustLot();
                    invlotin.Id = Guid.NewGuid();
                    invlotin.IadId = lineIn.Id;
                    invlotin.LotQty = sum;
                    invlotin.WhmId = new Guid(WhmId);
                    invlotin.LotId = l.Id;
                    invlotin.LotNumber = LotNumber + "@@" + StockInQrCdoe;
                    invlotin.QrLotNumber = LotNumber + "@@" + StockInQrCdoe;
                    invlotin.ExpiredDate = lm.ExpiredDate;
                    lotDao.Insert(invlotin);
                    //库存操作
                    invTrans.SaveInvRelatedInventoryAdjust(lineIn, invlotin, (AdjustType)Enum.Parse(typeof(AdjustType), "StockIn", true), AdjustStatus.Submit, new Guid(WhmId), null);

                    //更明细合计数量
                    lineDao.Update(lineIn);
                    //记录日志
                    InvBll.InsertPurchaseOrderLog(HeaderIn.Id, new Guid(_context.User.Id), PurchaseOrderOperationType.CreateShipment, "二维码替换：" + StoCkOutQrCode + "替换" + StockInQrCdoe);
                    //记录上报描述

                    this.UpdateDealerBarcodeRemarkByDmaIdUpnLot(DealerId.ToString(), StockInQrCdoe, Upn, LotNumber, "在" + DateTime.Now + "执行二维码库存调整，调整数量:" + sum);
                    #endregion


                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                bl = false;
            }
            return bl;

        }
        public void UpdateDealerBarcodeRemarkByDmaIdUpnLot(string DmaId, string QrCode, string Upn, string Lot, string Remark)
        {
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            { 
                     dao.UpdateDealerBarcodeRemarkByDmaIdUpnLot(DmaId,QrCode,Upn,Lot,Remark);          
            }
        }
        public void GetCfnPriceHistorybyUpnLotDmaid(string DealerId, string HospId, out string RtnVal, out string RtnMsg)
        {
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                dao.GetCfnPriceHistorybyUpnLotDmaid(DealerId, HospId,out RtnVal,out RtnMsg);
            }
        }

        public DataSet selectremark(string DealerId)
        {
            using (TIWcDealerBarcodeqRcodeScanDao dao = new TIWcDealerBarcodeqRcodeScanDao())
            {
                return dao.selectremark(DealerId);
            }

        }

        

    }
}
