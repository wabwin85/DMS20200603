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
using DMS.DataAccess.Consignment;

namespace DMS.Business
{
    public class ShipmentBLL : IShipmentBLL
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        private IClientBLL _clientBLL = new ClientBLL();

        #region Action Define
        public const string Action_DealerShipment = "DealerShipment";
        public const string Action_DealerShipmentAudit = "DealerShipmentAudit";
        public const string Action_ImplantMaint = "ImplantMaint";
        public const string Action_DIBImplantDownload = "DIBImplantDownload";
        public const string Action_VASImplantDownload = "VASImplantDownload";
        public const string Action_PrintSetting = "PrintSetting";
        #endregion

        [AuthenticateHandler(ActionName = Action_DealerShipment, Description = "销售授权-销售出库单", Permissoin = PermissionType.Read)]
        public DataSet QueryShipmentHeader(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);

            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);

            }
        }

        //[AuthenticateHandler(ActionName = Action_DealerShipmentAudit, Description = "销售授权-销售冲红审批", Permissoin = PermissionType.Read)]
        public DataSet QueryShipmentHeaderAudit(Hashtable table, int start, int limit, out int totalRowCount)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);

            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                if (this._context.User.CorpType == DealerType.LP.ToString()|| this._context.User.CorpType == DealerType.LS.ToString())
                {
                    return dao.SelectByFilterForLP(table, start, limit, out totalRowCount);
                }
                else
                {

                    return dao.SelectByFilterForHQ(table, start, limit, out totalRowCount);
                }
            }
        }

        public void InsertShipmentHeader(ShipmentHeader obj)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                dao.Insert(obj);
            }
        }

        public DataSet QueryShipmentLot(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);
            }
        }

        public DataSet QueryShipmentLot(Hashtable table)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                return dao.SelectByFilter(table);
            }
        }

        public DataSet QueryShipmentLotSum(Hashtable table)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                return dao.SelectSumByFilter(table);
            }
        }

        public ShipmentHeader GetShipmentHeaderById(Guid id)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.GetObject(id);
            }
        }

        public ShipmentHeader GetShipmentHeaderByLotId(Guid id)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.SelectShipmentHeaderByLotId(id);
            }
        }

        public ShipmentLot GetShipmentLotById(Guid id)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                return dao.GetObject(id);
            }
        }

        public ShipmentLine GetShipmentLineByIndex(Guid OrderId, Guid ProductId)
        {
            using (ShipmentLineDao dao = new ShipmentLineDao())
            {
                Hashtable param = new Hashtable();
                param.Add("SphId", OrderId);
                param.Add("ShipmentPmaId", ProductId);

                IList<ShipmentLine> lines = dao.SelectByHashtable(param);

                if (lines.Count > 0)
                {
                    return lines[0];
                }
            }
            return null;
        }

        public ShipmentLot GetShipmentLotByIndex(Guid LineId, Guid LotId)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                Hashtable param = new Hashtable();
                param.Add("SplId", LineId);
                param.Add("LotId", LotId);

                IList<ShipmentLot> lots = dao.SelectByHashtable(param);

                if (lots.Count > 0)
                {
                    return lots[0];
                }
            }
            return null;
        }

        public ShipmentLot GetShipmentLotByLotNumber(Guid LineId, Guid LotId)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                Hashtable param = new Hashtable();
                param.Add("SplId", LineId);
                param.Add("LotId", LotId);

                IList<ShipmentLot> lots = dao.SelectByLotNumber(param);

                if (lots.Count > 0)
                {
                    return lots[0];
                }
            }
            return null;
        }

        public IList<ShipmentLot> GetShipmentLotByLineId(Guid LineId)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                Hashtable param = new Hashtable();
                param.Add("SplId", LineId);

                return dao.SelectByHashtable(param);
            }
        }

        public bool AddItems(Guid OrderId, Guid DealerId, Guid HospitalId, string[] LotIds)
        {
            bool result = false;


            ShipmentLine line = null;
            ShipmentLot lot = null;
            ShipmentHeader header = null;

            using (TransactionScope trans = new TransactionScope())
            {
                ShipmentLineDao lineDao = new ShipmentLineDao();
                ShipmentLotDao lotDao = new ShipmentLotDao();
                CurrentInvDao dao = new CurrentInvDao();
                DealerProductPriceHistoryDao dphDao = new DealerProductPriceHistoryDao();
                Product product = new Product();
                ProductDao pma = new ProductDao();
                ShipmentHeaderDao headerDao = new ShipmentHeaderDao();

                Hashtable param = new Hashtable();
                param.Add("LotIds", LotIds);
                //DataTable dtLine = dao.SelectInventoryAdjustDetailByLotIDs(param).Tables[0];
                DataTable dtLot = dao.SelectInventoryAdjustLotByLotIDs(param).Tables[0];

                int i = 1;

                for (int j = 0; j < dtLot.Rows.Count; j++)
                {
                    //判断Line是否已经有记录

                    line = GetShipmentLineByIndex(OrderId, new Guid(dtLot.Rows[j]["ProductId"].ToString()));
                    //DataRow[] drLots = dtLot.Select("ProductId = '" + dtLot.Rows[j]["ProductId"].ToString() + "'");
                    if (line == null)
                    {
                        //如果记录不存在，则新增记录

                        line = new ShipmentLine();
                        line.Id = Guid.NewGuid();
                        line.SphId = OrderId;
                        line.ShipmentPmaId = new Guid(dtLot.Rows[j]["ProductId"].ToString());
                        //modified by bozhenfei on 20100608 在后面逻辑中保证数量一致
                        line.ShipmentQty = 0;
                        //line.ShipmentQty = Convert.ToDouble(drLots.Length); //缺省发运数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                        line.LineNbr = i++;




                        lineDao.Insert(line);
                    }
                    //插入Lot表

                    //DataRow[] drLots = dtLot.Select("ProductId = '" + line.ShipmentPmaId.ToString() + "'");

                    product = pma.GetObject(line.ShipmentPmaId);
                    string pmaLineId = product.ProductLineBumId.ToString();
                    //for (int n= 0; n < drLots.Length; n++)
                    //{
                    //   // 判断Lot表是否已经有记录
                    //    //判断CRM产品（非66开头）的，是否已经添加过同一批号
                    //    if (pmaLineId == "97a4e135-74c7-4802-af23-9d6d00fcb2cc" &&
                    //        !product.Upn.StartsWith("66") && !IsAdminRole())
                    //    {
                    //        lot = GetShipmentLotByLotNumber(line.Id, new Guid(drLots[n]["LotId"].ToString()));
                    //    }
                    //    else
                    //    {
                    //        lot = GetShipmentLotByIndex(line.Id, new Guid(drLots[n]["LotId"].ToString()));
                    //    }
                    lot = GetShipmentLotByIndex(line.Id, new Guid(dtLot.Rows[j]["LotId"].ToString()));
                    if (lot == null)
                    {
                        //如果记录不存在，则新增记录

                        lot = new ShipmentLot();
                        lot.Id = Guid.NewGuid();
                        lot.SplId = line.Id;
                        lot.LotId = new Guid(dtLot.Rows[j]["LotId"].ToString());
                        lot.LotShippedQty = 1; //缺省发运数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                        lot.WhmId = new Guid(dtLot.Rows[j]["WarehouseId"].ToString());
                        lot.DOM = dtLot.Rows[j]["DOM"].ToString();
                        lot.Lot = dtLot.Rows[j]["LtmLot"].ToString();
                        lot.QRCode = dtLot.Rows[j]["LotQRCode"].ToString();
                        lot.ExpiredDate = DateTime.ParseExact(dtLot.Rows[j]["ExpiredDate"].ToString(), "yyyyMMdd", null);

                        if (IsAdminRole())
                        {
                            lot.AdjType = "Adj";
                            lot.AdjReason = lot.Remark;
                            lot.AdjAction = "Add";
                            lot.InputTime = DateTime.Now;
                        }

                        //lot.IsFreeSales = lot.UnitPrice <=Convert.ToDecimal(0.01)? true : false;

                        //Edited By Song Yuqi On 2016-03-03 Begin
                        //修改销售价格的逻辑，根据DmaId,PmaId,HosId，若存在则获取唯一价格
                        //若不存在，则根据DmaId,PmaId，获取价格
                        //若都不存在，则需要用户手工输入销售单价
                        Hashtable table = new Hashtable();
                        table.Add("DmaId", DealerId);
                        table.Add("PmaId", dtLot.Rows[j]["ProductId"].ToString());
                        //table.Add("SltId", dtLot.Rows[j]["LotId"].ToString());
                        table.Add("SltId", HospitalId.ToString());//
                        BaseService.AddCommonFilterCondition(table);
                        DealerProductPriceHistory dph = dphDao.SelectByFilterPMADMA(table);

                        if (dph != null)
                        {
                            lot.UnitPrice = Convert.ToDecimal(dph.UnitPrice);
                        }
                        else
                        {
                            //若不存在，则根据DmaId,PmaId，获取价格
                            table = new Hashtable();
                            table.Add("DmaId", DealerId);
                            table.Add("PmaId", dtLot.Rows[j]["ProductId"].ToString());
                            BaseService.AddCommonFilterCondition(table);
                            dph = dphDao.SelectByFilterPMADMA(table);

                            if (dph != null)
                            {
                                lot.UnitPrice = Convert.ToDecimal(dph.UnitPrice);
                            }
                        }
                        // lot.UnitPrice = Convert.ToDecimal(drLots[j]["UnitPrice"].ToString());
                        lotDao.Insert(lot);
                        //行记录增加数量 @ 2010/6/8 by Bozhenfei
                        line.ShipmentQty = line.ShipmentQty + 1;

                        //Edited By Song Yuqi On 2016-03-03 End
                    }
                    else
                    {
                        DataSet ds = lotDao.SelectShipmentLotQrCodeBYLineIdandLotId(new Guid(dtLot.Rows[j]["LotId"].ToString()));
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            //判断二维码是否为NoQR如果是就新增 lijie add 20160401
                            if (ds.Tables[0].Rows[0]["QrCode"].ToString() == "NoQR")
                            {
                                lot = new ShipmentLot();
                                lot.Id = Guid.NewGuid();
                                lot.SplId = line.Id;
                                lot.LotId = new Guid(dtLot.Rows[j]["LotId"].ToString());
                                lot.LotShippedQty = 1; //缺省发运数量置为1。 为减少用户的输入量，修改需求 @ 2009/12/3 by Steven
                                lot.WhmId = new Guid(dtLot.Rows[j]["WarehouseId"].ToString());
                                if (IsAdminRole())
                                {
                                    lot.AdjType = "Adj";
                                    lot.AdjReason = lot.Remark;
                                    lot.AdjAction = "Add";
                                    lot.InputTime = DateTime.Now;
                                }

                                //Edited By Song Yuqi On 2016-03-03 Begin
                                //修改销售价格的逻辑，根据DmaId,PmaId,HosId，若存在则获取唯一价格
                                //若不存在，则根据DmaId,PmaId，获取价格
                                //若都不存在，则需要用户手工输入销售单价
                                Hashtable table = new Hashtable();
                                table.Add("DmaId", DealerId);
                                table.Add("PmaId", dtLot.Rows[j]["ProductId"].ToString());
                                //table.Add("SltId", dtLot.Rows[j]["LotId"].ToString());
                                table.Add("SltId", HospitalId.ToString());//
                                BaseService.AddCommonFilterCondition(table);
                                DealerProductPriceHistory dph = dphDao.SelectByFilterPMADMA(table);

                                if (dph != null)
                                {
                                    lot.UnitPrice = Convert.ToDecimal(dph.UnitPrice);
                                }
                                else
                                {
                                    //若不存在，则根据DmaId,PmaId，获取价格
                                    table = new Hashtable();
                                    table.Add("DmaId", DealerId);
                                    table.Add("PmaId", dtLot.Rows[j]["ProductId"].ToString());
                                    BaseService.AddCommonFilterCondition(table);
                                    dph = dphDao.SelectByFilterPMADMA(table);

                                    if (dph != null)
                                    {
                                        lot.UnitPrice = Convert.ToDecimal(dph.UnitPrice);
                                    }
                                }
                                // lot.UnitPrice = Convert.ToDecimal(drLots[j]["UnitPrice"].ToString());
                                lotDao.Insert(lot);
                                //行记录增加数量 @ 2010/6/8 by Bozhenfei
                                line.ShipmentQty = line.ShipmentQty + 1;



                            }
                        }
                    }
                    // }
                    //更新行记录数量 @ 2010/6/8 by Bozhenfei
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

            ShipmentLine line = null;
            ShipmentLot lot = null;

            using (TransactionScope trans = new TransactionScope())
            {
                ShipmentLineDao lineDao = new ShipmentLineDao();
                ShipmentLotDao lotDao = new ShipmentLotDao();
                //取出lot和line记录
                lot = lotDao.GetObject(LotId);
                line = lineDao.GetObject(lot.SplId);

                //删除Lot记录
                lotDao.Delete(LotId);

                //判断LineId下是否还有其他Lot记录
                if (GetShipmentLotByLineId(lot.SplId).Count > 0)
                {
                    //若有其他记录，则更新line的Qty
                    line.ShipmentQty = lotDao.SelectTotalShipmentLotQtyByLineId(lot.SplId);
                    lineDao.Update(line);
                }
                else
                {
                    //若没有其他记录，则Line记录本身也要删除
                    lineDao.Delete(lot.SplId);
                }

                result = true;

                trans.Complete();
            }

            return result;
        }

        public bool SaveItem(ShipmentLot lot, double price)
        {
            bool result = false;

            ShipmentLine line = null;

            using (TransactionScope trans = new TransactionScope())
            {
                ShipmentLineDao lineDao = new ShipmentLineDao();
                ShipmentLotDao lotDao = new ShipmentLotDao();
                ShipmentHeaderDao headerDao = new ShipmentHeaderDao();
                ProductDao pmaDao = new ProductDao();

                lot.InputTime = DateTime.Now;
                lot.AdjReason = lot.Remark;

                //if (lot.UnitPrice <= Convert.ToDecimal(0.01))
                //{
                //    lot.IsFreeSales = true;
                //}
                lotDao.Update(lot);
                line = lineDao.GetObject(lot.SplId);

                line.ShipmentQty = lotDao.SelectTotalShipmentLotQtyByLineId(lot.SplId);
                //line.UnitPrice = price;//added by bozhenfei on 20100608
                lineDao.Update(line);

                result = true;

                trans.Complete();
            }

            return result;
        }

        public bool SaveItem(ShipmentLot lot)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {             
                ShipmentLotDao lotDao = new ShipmentLotDao();
                lot.InputTime = DateTime.Now;
                lot.AdjReason = lot.Remark;            
                lotDao.Update(lot);
                result = true;
                trans.Complete();
            }
            return result;
        }

        public bool DeleteDraft(Guid id)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                ShipmentHeaderDao mainDao = new ShipmentHeaderDao();
                ShipmentLineDao lineDao = new ShipmentLineDao();
                ShipmentLotDao lotDao = new ShipmentLotDao();
                ShipmentOperationDao operDao = new ShipmentOperationDao();
                //判断表头中状态是否是草稿
                ShipmentHeader main = mainDao.GetObject(id);
                if (main.Status == ShipmentOrderStatus.Draft.ToString())
                {
                    //删除lot表
                    lotDao.DeleteByHeaderId(id);
                    //删除line表
                    lineDao.DeleteByHeaderId(id);
                    //删除operation表
                    operDao.DeleteByHeaderId(id);
                    //删除主表
                    mainDao.Delete(id);

                    //二级经销商寄售订单删除ShipmentConsignment表
                    if (main.Type == ShipmentOrderType.Consignment.ToString())
                    {
                        ShipmentConsignmentDao consignmentDao = new ShipmentConsignmentDao();
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
                ShipmentHeaderDao mainDao = new ShipmentHeaderDao();
                ShipmentLineDao lineDao = new ShipmentLineDao();
                ShipmentLotDao lotDao = new ShipmentLotDao();
                //判断表头中状态是否是草稿
                ShipmentHeader main = mainDao.GetObject(id);
                if (main.Status == ShipmentOrderStatus.Draft.ToString())
                {
                    //删除lot表
                    lotDao.DeleteByHeaderId(id);
                    //删除line表

                    lineDao.DeleteByHeaderId(id);

                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        public bool SaveDraft(ShipmentHeader obj)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                ShipmentHeaderDao mainDao = new ShipmentHeaderDao();

                //判断表头中状态是否是草稿
                ShipmentHeader main = mainDao.GetObject(obj.Id);
                if (main.Status == ShipmentOrderStatus.Draft.ToString())
                {
                    obj.UpdateDate = DateTime.Now;// added by songweiming on 20100628
                    mainDao.Update(obj);
                    result = true;
                }
                trans.Complete();
            }
            return result;
        }

        public string Submit(ShipmentHeader obj,string OperatType)
        {
            string result = "";
            decimal receiptPrice = 0;
            //保存主信息

            using (TransactionScope trans = new TransactionScope())
            {
                ShipmentHeaderDao mainDao = new ShipmentHeaderDao();

                //判断表头中状态是否是草稿
                ShipmentHeader main = mainDao.GetObject(obj.Id);
                if (main.Status == ShipmentOrderStatus.Draft.ToString())
                {
                    obj.UpdateDate = DateTime.Now;// added by songweiming on 20100628
                    obj.SubmitDate = DateTime.Now;// added by songweiming on 20100628
                    mainDao.Update(obj);
                    result = "Success";
                }
                trans.Complete();
            }

            if (result != "Success") return "保存主信息出错";//保存主信息出错


            //result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    AutoNumberBLL auto = new AutoNumberBLL();
                    ShipmentHeaderDao mainDao = new ShipmentHeaderDao();
                    ShipmentLineDao lineDao = new ShipmentLineDao();
                    ShipmentLotDao lotDao = new ShipmentLotDao();
                    ConsignCommonDao consignDao = new ConsignCommonDao();
                    InvTrans invTrans = new InvTrans();
                    ReportInventoryHistoryDao rihDao = new ReportInventoryHistoryDao();
                    InventoryAdjustBLL invAdjust = new InventoryAdjustBLL();

                    ShipmentlpConfirmHeaderDao confirmHeaderDao = new ShipmentlpConfirmHeaderDao();
                    ShipmentlpConfirmDetailDao confirmDetailDao = new ShipmentlpConfirmDetailDao();

                    //判断表头中状态是否是草稿
                    ShipmentHeader main = mainDao.GetObject(obj.Id);
                    if (main.Status == ShipmentOrderStatus.Draft.ToString())
                    {

                        //Added By Song Yuqi Begin
                        //只有二级经销商寄售类型的销售单会执行
                        //if (_context.User.CorpType == DealerType.T2.ToString() && main.Type == ShipmentOrderType.Consignment.ToString())
                        //{
                        //    string RtnVal = string.Empty;
                        //    string RtnMsg = string.Empty;
                        //    mainDao.SumbitConsignment(obj.Id, obj.HospitalHosId.Value, obj.ProductLineBumId.Value, out RtnVal, out RtnMsg);
                        //    if (RtnVal != "Success")
                        //    {
                        //        return false;
                        //    }
                        //}
                        //Added By Song Yuqi End

                        if (CheckLotInventory(obj.Id, OperatType))
                        {
                            obj.Status = ShipmentOrderStatus.Complete.ToString();
                            obj.ShipmentNbr = auto.GetNextAutoNumber(obj.DealerDmaId, OrderType.Next_ShipmentNbr, obj.ProductLineBumId.Value);
                            //obj.ShipmentDate = DateTime.Now;//modified by bozhenfei 销售日期改为手工维护
                            // added by songweiming on 20100628
                            obj.UpdateDate = DateTime.Now;
                            if (!string.IsNullOrEmpty(obj.InvoiceNo))
                            {
                                obj.InvoiceFirstDate = DateTime.Now;
                            }
                            mainDao.Update(obj);

                            IList<ShipmentLine> lines = lineDao.SelectByHeaderId(obj.Id);

                            int lineNumber = 1;

                            ProductDao product = new ProductDao();

                            foreach (ShipmentLine line in lines)
                            {
                                line.LineNbr = lineNumber++;
                                lineDao.Update(line);

                                IList<ShipmentLot> lots = lotDao.SelectByLineId(line.Id);

                                foreach (ShipmentLot lot in lots)
                                {
                                    ///Todo: 库存操作

                                    if (lot.UnitPrice == null)
                                    {
                                        return "价格为空";
                                    }

                                    if (main.ProductLineBumId.ToString() == "97a4e135-74c7-4802-af23-9d6d00fcb2cc" && !product.GetObject(line.ShipmentPmaId).Upn.StartsWith("66")
                                        && lot.LotShippedQty > 1 && !IsAdminRole())
                                    {
                                        return "CRM产品线非66开头产品的销售数量不能大于1";
                                    }
                                    AddShipLotMas(lot, line.ShipmentPmaId, lot.WhmId);
                                    invTrans.SaveInvRelatedShipment(obj, line, lot);

                                    Hashtable table = new Hashtable();
                                    table.Add("WhmId", lot.WhmId);
                                    table.Add("PmaId", line.ShipmentPmaId);
                                    table.Add("LotId", lot.LotId);
                                    table.Add("ShipmentDate", obj.ShipmentDate);
                                    table.Add("QTY", lot.LotShippedQty);
                                    rihDao.UpdateForShipment(table);

                                    //Edited By Song Yuqi 2016-03-03 增加参数Hospital Id
                                    UpdatePrice(line, lot, obj.DealerDmaId, obj.HospitalHosId.Value);

                                    //如果用户没有选择寄售申请单，则默认一个
                                    if (lot.CahId == Guid.Empty)
                                    {
                                        Hashtable tb = new Hashtable();
                                        tb.Add("DealerId", obj.DealerDmaId);
                                        tb.Add("ProductLineId", obj.ProductLineBumId);
                                        tb.Add("LotId", lot.LotId);
                                        tb.Add("PmaId", line.ShipmentPmaId);

                                        DataSet ds = new DataSet();
                                        ds = invAdjust.GetConsignmentOrderNbr(tb);
                                        if (ds.Tables[0].Rows.Count > 0)
                                        {
                                            lot.CahId = new Guid(ds.Tables[0].Rows[0]["Id"].ToString());
                                            lotDao.Update(lot);
                                        }

                                    }
                                }
                            }

                            #region Added By Song Yuqi On 2016-04-06 
                            //若类型为寄售销售单，那么提交后需要将销售数据新增至平台价格确认表中
                            if (obj.Type == "Consignment" && this.IsAdminRole())
                            {
                                ShipmentlpConfirmHeader confirmHeader = new ShipmentlpConfirmHeader();
                                ShipmentlpConfirmDetail confirmDetail = null;

                                confirmHeader.Id = Guid.NewGuid();
                                confirmHeader.SalesNo = obj.ShipmentNbr;
                                confirmHeader.OrderNo = obj.ShipmentNbr;
                                confirmHeader.ConfirmDate = DateTime.Now;
                                confirmHeader.Remark = obj.NoteForPumpSerialNbr;
                                confirmHeader.ImportUser = main.ShipmentUser.Value;
                                confirmHeader.ImportDate = DateTime.Now;

                                confirmHeaderDao.Insert(confirmHeader);

                                DataSet shipmentLotDs = lotDao.QueryShipmentLotBySphId(main.Id);

                                if (shipmentLotDs != null && shipmentLotDs.Tables.Count > 0 && shipmentLotDs.Tables[0].Rows.Count > 0)
                                {
                                    foreach (DataRow dr in shipmentLotDs.Tables[0].Rows)
                                    {
                                        confirmDetail = new ShipmentlpConfirmDetail();
                                        confirmDetail.Id = Guid.NewGuid();
                                        confirmDetail.SchId = confirmHeader.Id;
                                        confirmDetail.Upn = dr["Upn"].ToString();
                                        confirmDetail.Lot = dr["LotNumber"].ToString();
                                        confirmDetail.Qty = decimal.Parse(dr["LotShippedQty"].ToString());

                                        if (dr["AdjAction"] == null || !decimal.TryParse(dr["AdjAction"].ToString(), out receiptPrice))
                                        {
                                            return "采购价必须填写";
                                        }

                                        confirmDetail.UnitPrice = decimal.Parse(dr["AdjAction"].ToString());
                                        confirmDetail.IsCalRebate = null;

                                        confirmDetailDao.Insert(confirmDetail);
                                    }
                                }
                            }
                            #endregion

                            if (!string.IsNullOrEmpty(obj.Type))
                            {
                                //销售单接口表(T2寄售库)
                                if (RoleModelContext.Current.User.CorpType == DealerType.T2.ToString()
                                    && obj.Type == ShipmentOrderType.Consignment.ToString())
                                {
                                    //寄售项目，不需维护平台价格确认接口，而是生成“销售寄售买断单据”
                                    //InsertSalesInterface(obj);
                                    string RtnVal = "";
                                    string RtnMsg = "";
                                    Hashtable ht = new Hashtable();
                                    BaseService.AddCommonFilterCondition(ht);
                                    consignDao.ProcConsigntInvBuyOff("Shipment_Consignment", obj.ShipmentNbr, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out RtnVal, out RtnMsg);
                                    if (!RtnVal.Equals("Success")) throw new Exception(RtnMsg);
                                }



                                //一级及平台寄售销售，需发邮件给财务
                                //if ((RoleModelContext.Current.User.CorpType == DealerType.T1.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LP.ToString())
                                //    && obj.Type == ShipmentOrderType.Borrow.ToString())
                                //{
                                //    MailDeliveryAddressDao mailAddressDao = new MailDeliveryAddressDao();
                                //    //传入当前经销商ID，然后获取对应的邮件地址
                                //    Hashtable ht = new Hashtable();
                                //    ht.Add("DmaId", obj.DealerDmaId);
                                //    ht.Add("ProductLineID", Guid.Empty);
                                //    ht.Add("MailType", "ConsignmentShipment");
                                //    IList<MailDeliveryAddress> mailList = mailAddressDao.QueryOrderMailAddressByConditions(ht);

                                //    MessageBLL msgBll = new MessageBLL();
                                //    foreach (MailDeliveryAddress mailAddress in mailList)
                                //    {
                                //        //邮件
                                //        Dictionary<String, String> dictMailSubject = new Dictionary<String, String>();
                                //        Dictionary<String, String> dictMailBody = new Dictionary<String, String>();
                                //        dictMailSubject.Add("Dealer", this._context.User.CorpName);
                                //        dictMailSubject.Add("ShipmentNbr", obj.ShipmentNbr);

                                //        dictMailBody.Add("Dealer", this._context.User.CorpName);
                                //        dictMailBody.Add("ShipmentNbr", obj.ShipmentNbr);
                                //        dictMailBody.Add("ShipmentID", obj.Id.ToString());
                                //        ConsignmentApplyDetailsDao dao = new ConsignmentApplyDetailsDao();
                                //        string rtnVal = "";
                                //        string rtnMsg = "";
                                //        DataSet ds = dao.GC_GetApplyOrderHtml(obj.Id, "Id", "V_Shipment", "Id", "V_ShipmentTable", out rtnVal, out rtnMsg);
                                //        rtnMsg = ds.Tables[0].Rows[0]["HtmlStr"] != null ? ds.Tables[0].Rows[0]["HtmlStr"].ToString() : "";
                                //        dictMailBody.Add("HTML", rtnMsg);

                                //        msgBll.AddToMailMessageQueue(MailMessageTemplateCode.EMAIL_SHIPMENT_FINANCE_APPROVE, dictMailSubject, dictMailBody, mailAddress.MailAddress);
                                //    }
                                //}
                            }
                            //订单操作日志
                            this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);

                            result = "Success";
                        }

                    }
                    trans.Complete();
                }
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }
            return result;
        }

        public void AddShipLotMas(ShipmentLot lot, Guid PmaId, Guid SystemHoldWarehouse)
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

                    lm.CreateDate = DateTime.Now;
                    lm.ProductPmaId = PmaId;
                    ltmBLL.Insert(lm);
                }

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
                ShipmentLotDao lotDao = new ShipmentLotDao();
                if (lotList.Count == 0)
                {
                    l = new Lot();
                    l.Id = Guid.NewGuid();
                    l.InvId = inv.Id.Value;
                    l.LtmId = lm.Id;

                    l.WhmId = SystemHoldWarehouse;
                    l.CfnId = cfn.SelectByPMAID(PmaId.ToString()).Id;
                    l.ExpiredDate = lm.ExpiredDate;
                    l.QRCode = lm.QRCode;
                    l.LotNumber = lm.Lot;
                    l.Dom = lm.QRCode;
                   

                    l.OnHandQty = 0;
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

        public void InsertSalesInterface(ShipmentHeader obj)
        {
            Guid corpId = new Guid(RoleModelContext.Current.User.CorpId.Value.ToString());

            using (SalesInterfaceDao dao = new SalesInterfaceDao())
            {
                SalesInterface inter = new SalesInterface();
                inter.Id = Guid.NewGuid();
                inter.BatchNbr = string.Empty;
                inter.RecordNbr = string.Empty;
                inter.SphId = obj.Id;
                inter.SphShipmentNbr = obj.ShipmentNbr;
                inter.Status = PurchaseOrderMakeStatus.Pending.ToString();
                inter.ProcessType = PurchaseOrderCreateType.Manual.ToString();
                inter.CreateUser = new Guid(this._context.User.Id);
                inter.CreateDate = DateTime.Now;
                inter.UpdateDate = DateTime.Now;
                inter.Clientid = _clientBLL.GetParentClientByCorpId(obj.DealerDmaId).Id;
                dao.Insert(inter);
            }

        }

        /// <summary>
        /// 更新产品单价
        /// </summary>
        /// <param name="lines"></param>
        /// <param name="dealerId"></param>
        public void UpdatePrice(ShipmentLine line, ShipmentLot lot, Guid dealerId, Guid hospitalId)
        {

            //foreach (ShipmentLine line in lines)
            //{
            Guid pmaId = line.ShipmentPmaId;
            //Guid sltId = lot.LotId;
            Guid sltId = hospitalId; //Edited By Song Yuqi On 2016-03-03 存放Hospital ID。

            Hashtable table = new Hashtable();
            DealerProductPriceHistoryDao dphDao = new DealerProductPriceHistoryDao();
            table.Add("DmaId", dealerId);
            table.Add("PmaId", pmaId);
            table.Add("SltId", sltId);
            BaseService.AddCommonFilterCondition(table);
            DealerProductPriceHistory dph = new DealerProductPriceHistory();
            dph = dphDao.SelectByFilterPMADMA(table);
            if (dph == null)
            {
                DealerProductPriceHistory dp = new DealerProductPriceHistory();
                dp.UnitPrice = Convert.ToDecimal(lot.UnitPrice);
                dp.CreateDate = DateTime.Now;
                dp.UpdateDate = DateTime.Now;
                dp.PmaId = pmaId;
                dp.DmaId = dealerId;
                dp.SltId = sltId;
                dp.Id = System.Guid.NewGuid();
                dphDao.Insert(dp);
            }
            else
            {
                dph.UpdateDate = DateTime.Now;
                dph.UnitPrice = Convert.ToDecimal(lot.UnitPrice);
                dphDao.Update(dph);
            }
            //}
        }
        ///// <summary>
        ///// 更新状态（取消红冲，红冲后待审批）
        ///// </summary>
        ///// <param name="obj"></param>
        //public bool Update(ShipmentHeader obj)
        //{
        //    using (ShipmentHeaderDao mainDao = new ShipmentHeaderDao())
        //    {
        //        mainDao.Update(obj);
        //        if (obj.Status == ShipmentOrderStatus.Cancelled.ToString())
        //        {
        //            this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Reject, null);
        //        }
        //        if (obj.Status == ShipmentOrderStatus.Submitted.ToString())
        //        {

        //            this.InsertPurchaseOrderLog(obj.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);
        //        }
        //    }
        //    return true;

        //}

        public bool GetSubmittedOrder(Guid nbr)
        {
            using (ShipmentHeaderDao mainDao = new ShipmentHeaderDao())
            {
                return mainDao.GetSubmittedOrder(nbr);
            }
        }

        /// <summary>
        /// 审批通过，记录审批操作，增加库存；冲红，记录冲红操作，增加库存；取消审批，记录取消操作，扣减库存；
        ///
        /// </summary>
        /// <param name="OrderId"></param>
        /// <returns></returns>
        public bool Revoke(Guid OrderId, string orderStatus)
        {
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                AutoNumberBLL auto = new AutoNumberBLL();
                ShipmentHeaderDao mainDao = new ShipmentHeaderDao();
                ShipmentLineDao lineDao = new ShipmentLineDao();
                ShipmentLotDao lotDao = new ShipmentLotDao();
                InvTrans invTrans = new InvTrans();
                PurchaseOrderHeaderDao pHeaderDao = new PurchaseOrderHeaderDao();

                ShipmentHeader main = mainDao.GetObject(OrderId);
                //判断表头中状态是待审批；修改待审批单据状态，不生成新单据；同意，恢复库存
                if (main.Status == ShipmentOrderStatus.Submitted.ToString())
                {
                    //同意将状态改为已冲红
                    if (orderStatus == "Agree")
                    {
                        main.Status = ShipmentOrderStatus.Reversed.ToString();
                        Guid sid = new Guid(main.ReverseSphId.ToString());
                        ShipmentHeader oldMain = mainDao.GetObject(sid);
                        oldMain.UpdateDate = DateTime.Now;
                        oldMain.Status = ShipmentOrderStatus.Reversed.ToString();
                        mainDao.Update(oldMain);
                        this.InsertPurchaseOrderLog(oldMain.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Approve, null);

                        //从冲红单的备注获取原销售单，并从销售单获取对应的订单，然后更新订单状态为“撤销”
                        if (!string.IsNullOrEmpty(main.NoteForPumpSerialNbr))
                        {
                            String shipmentNote = main.NoteForPumpSerialNbr;
                            int staIdxNo = shipmentNote.IndexOf("「");
                            int endIdxNo = shipmentNote.IndexOf("」");
                            if (staIdxNo >= 0 && endIdxNo >= 0 && endIdxNo - staIdxNo - 1 > 0)
                            {
                                String shipmentNo = shipmentNote.Substring(staIdxNo + 1, endIdxNo - staIdxNo - 1);
                                //根据销售单单据号，找到订单号，然后更新订单状态
                                Hashtable ht = new Hashtable();
                                ht.Add("orderStatus", "Revoked");
                                ht.Add("shipmentNo", shipmentNo);
                                int updateRowNum = pHeaderDao.UpdateClearBorrowPurchaseOrderStatus(ht);
                                if (updateRowNum > 0)
                                {
                                    //根据备注和订单类型获取订单ID
                                    PurchaseOrderHeader poh = pHeaderDao.GetClearBorrowPurchaseOrderHeader(ht)[0];
                                    this.InsertPurchaseOrderLog(poh.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.WriteOff, "因销售单冲红操作，对系统自动生成的清指定批号订单进行撤销操作");
                                }

                            }
                        }

                    }
                    //取消将状态改为已取消
                    if (orderStatus == "Canclled")
                    {
                        main.Status = ShipmentOrderStatus.Cancelled.ToString();
                    }
                    main.UpdateDate = DateTime.Now;
                    main.SubmitDate = DateTime.Now;
                    mainDao.Update(main);




                    //同意，恢复库存
                    if (orderStatus == "Agree")
                    {
                        IList<ShipmentLine> lines = lineDao.SelectByHeaderId(main.Id);

                        foreach (ShipmentLine line in lines)
                        {

                            IList<ShipmentLot> lots = lotDao.SelectByLineId(line.Id);

                            foreach (ShipmentLot lot in lots)
                            {

                                invTrans.SaveInvRelatedShipment(main, line, lot);
                            }
                        }


                        this.InsertPurchaseOrderLog(main.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Approve, null);
                    }


                    if (orderStatus == "Canclled")
                    {
                        //记录操作日志
                        this.InsertPurchaseOrderLog(main.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Cancel, null);
                    }

                    result = true;

                }

                //判断表头中状态是完成；orderStatus是ToApprove时不恢复库存；LP做T2的冲红时往接口表写记录
                if (main.Status == ShipmentOrderStatus.Complete.ToString() && !mainDao.GetSubmittedOrder(main.Id))
                {
                    if (string.IsNullOrEmpty(orderStatus))
                    {
                        main.Status = ShipmentOrderStatus.Reversed.ToString();
                    }
                    main.UpdateDate = DateTime.Now;
                    mainDao.Update(main);


                    ShipmentHeader mainNew = new ShipmentHeader();
                    mainNew.Id = Guid.NewGuid();
                    mainNew.HospitalHosId = main.HospitalHosId;
                    mainNew.ShipmentNbr = auto.GetNextAutoNumber(main.DealerDmaId, OrderType.Next_ShipmentNbr, main.ProductLineBumId.Value);
                    mainNew.DealerDmaId = main.DealerDmaId;
                    mainNew.ShipmentDate = main.ShipmentDate;
                    mainNew.SubmitDate = DateTime.Now;
                    //将状态改为已冲红
                    if (string.IsNullOrEmpty(orderStatus))
                    {
                        mainNew.Status = ShipmentOrderStatus.Reversed.ToString();
                        mainNew.NoteForPumpSerialNbr = "从原销售单号「" + main.ShipmentNbr + "」冲红";
                    }

                    if (orderStatus == "ToApprove")
                    {
                        mainNew.Status = ShipmentOrderStatus.Submitted.ToString();
                        mainNew.NoteForPumpSerialNbr = "从原销售单号「" + main.ShipmentNbr + "」生成待审批";
                    }
                    mainNew.ReverseSphId = main.Id;
                    mainNew.ProductLineBumId = main.ProductLineBumId;
                    mainNew.UpdateDate = DateTime.Now;//added by songweiming on 20100628
                    mainNew.Type = main.Type;
                    mainNew.ShipmentUser = main.ShipmentUser;
                    mainNew.InvoiceNo = main.InvoiceNo;
                    mainNew.Office = main.Office;
                    mainNew.InvoiceTitle = main.InvoiceTitle;
                    mainNew.InvoiceDate = main.InvoiceDate;
                    mainNew.IsAuth = main.IsAuth;
                    mainDao.Insert(mainNew);

                    IList<ShipmentLine> lines = lineDao.SelectByHeaderId(main.Id);
                    foreach (ShipmentLine line in lines)
                    {
                        //生成冲红Line记录
                        ShipmentLine lineNew = new ShipmentLine();
                        lineNew.Id = Guid.NewGuid();
                        lineNew.SphId = mainNew.Id;
                        lineNew.ShipmentPmaId = line.ShipmentPmaId;
                        lineNew.ShipmentQty = 0 - line.ShipmentQty;
                        //lineNew.UnitPrice = line.UnitPrice;
                        lineNew.LineNbr = line.LineNbr;
                        lineDao.Insert(lineNew);

                        IList<ShipmentLot> lots = lotDao.SelectByLineId(line.Id);

                        foreach (ShipmentLot lot in lots)
                        {
                            //生成冲红Lot记录
                            ShipmentLot lotNew = new ShipmentLot();
                            lotNew.Id = Guid.NewGuid();
                            lotNew.SplId = lineNew.Id;
                            lotNew.LotShippedQty = 0 - lot.LotShippedQty;
                            lotNew.UnitPrice = lot.UnitPrice;
                            lotNew.LotId = lot.LotId;
                            lotNew.WhmId = lot.WhmId;
                            lotNew.CahId = lot.CahId;
                            lotNew.Lot = lot.Lot;
                            lotNew.QRCode = lot.QRCode;
                            lotNew.ExpiredDate = lot.ExpiredDate;
                            lotNew.DOM = lot.DOM;

                            lotDao.Insert(lotNew);
                            ///冲红恢复库存操作
                            if (string.IsNullOrEmpty(orderStatus))
                            {
                                invTrans.SaveInvRelatedShipment(mainNew, lineNew, lotNew);
                            }
                        }
                    }

                    if (string.IsNullOrEmpty(orderStatus))
                    {
                        //销售单接口表（LP冲红T2寄售单)
                        if (!string.IsNullOrEmpty(mainNew.Type))
                        {
                            if ((RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LS.ToString())
                                && mainNew.Type == ShipmentOrderType.Consignment.ToString())
                            {
                                this.InsertSalesInterface(mainNew);
                            }
                        }
                        //记录操作日志
                        this.InsertPurchaseOrderLog(mainNew.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.WriteOff, null);
                        this.InsertPurchaseOrderLog(main.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.WriteOff, null);

                    }
                    if (orderStatus == "ToApprove")
                    {
                        //记录操作日志
                        this.InsertPurchaseOrderLog(main.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);
                        this.InsertPurchaseOrderLog(mainNew.Id, new Guid(this._context.User.Id), PurchaseOrderOperationType.Submit, null);
                    }

                    result = true;

                }


                trans.Complete();
            }

            return result;
        }


        public bool CheckLotInventory(Guid OrderId, string OperatType)
        {
            bool result = true;
            using (LotDao daoInv = new LotDao())
            {
                ShipmentLotDao dao = new ShipmentLotDao();
                IList<ShipmentLot> lots = dao.SelectShipmentLotByHeaderId(OrderId);
                foreach (ShipmentLot lot in lots)
                {
                    Lot lotInv = daoInv.GetObject(lot.LotId);

                    if (!IsAdminRole() && !OperatType.Equals("UpdateShipment"))
                    {
                        if (lotInv.OnHandQty < lot.LotShippedQty || lot.LotShippedQty <= 0)
                        {
                            return false;
                        }
                    }
                    else
                    {
                        if (lotInv.OnHandQty < lot.LotShippedQty || lot.LotShippedQty == 0)
                        {
                            return false;
                        }
                    }
                }

                return result;
            }
        }

        public double GetShipmentTotalAmount(Guid id)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.SelectShipmentTotalAmountByHeaderId(id);
            }
        }

        public double GetShipmentTotalQty(Guid id)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.SelectShipmentTotalQtyByHeaderId(id);
            }
        }

        public IList<ShipmentOperation> GetShipmentOperationByHeaderId(Guid id)
        {
            using (ShipmentOperationDao dao = new ShipmentOperationDao())
            {
                return dao.GetShipmentOperationByHeaderId(id);
            }
        }

        public void InsertShipmentOperation(ShipmentOperation obj)
        {
            using (ShipmentOperationDao dao = new ShipmentOperationDao())
            {
                dao.Insert(obj);
            }
        }

        public void UpdateShipmentOperation(ShipmentOperation obj)
        {
            using (ShipmentOperationDao dao = new ShipmentOperationDao())
            {
                dao.Update(obj);
            }
        }

        public void UpdateMainDataInvoiceNo(ShipmentHeader obj)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {

                dao.UpdateInvoiceNo(obj);
            }
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

        public DealerCommonSetting QueryGetDealerCommonSetting(Guid id)
        {
            using (DealerCommonSettingDao dao = new DealerCommonSettingDao())
            {
                return dao.SelectDealerCommonSettingbyDMA(id);
            }
        }

        public void InsertDealerCommonSetting(DealerCommonSetting obj)
        {
            using (DealerCommonSettingDao dao = new DealerCommonSettingDao())
            {
                dao.Insert(obj);
            }
        }

        public void UpdateDealerCommonSetting(DealerCommonSetting obj)
        {
            using (DealerCommonSettingDao dao = new DealerCommonSettingDao())
            {
                dao.Update(obj);
            }
        }

        public DataSet QueryShipmentLotForPrint(Hashtable table)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                return dao.SelectByFilterForPrint(table);
            }
        }

        /// <summary>
        /// 将Excel文件中的数据导入到ShipmentInit表，并做相应的初始化
        /// </summary>
        /// <param name="ds"></param>
        /// <returns></returns>
        public bool Import(DataTable dt, string fileName,string OperType)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            DealerMasterLicenseDao dmDao = new DealerMasterLicenseDao();
            string InitNo= dmDao.GetNextCFDANo("ShipmentInit", "Next_ShipmentInit");
            DateTime UploadDate = DateTime.Now;
            bool result = false;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ShipmentInitDao dao = new ShipmentInitDao();
                    //删除上传人的数据
                    //dao.DeleteByUser(new Guid(_context.User.Id));

                    int lineNbr = 1;
                    IList<ShipmentInit> list = new List<ShipmentInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        //string errString = string.Empty;
                        ShipmentInit data = new ShipmentInit();
                        data.Id = Guid.NewGuid();
                        data.User = new Guid(_context.User.Id);
                        data.UploadDate = UploadDate;
                        data.FileName = fileName;
                        data.No = InitNo;
                        data.DmaId = new Guid(_context.User.CorpId.Value.ToString());
                        data.OperType = OperType;
                        //医院名称
                        data.HospitalName = dr[0] == DBNull.Value ? null : dr[0].ToString();
                        if (string.IsNullOrEmpty(data.HospitalName))
                            data.HospitalNameErrMsg = "医院名称为空";
                        //data.HospitalName = dr[1] == DBNull.Value ? null : dr[1].ToString();

                        data.ShipmentDate = dr[1] == DBNull.Value ? null : dr[1].ToString();
                        if (!string.IsNullOrEmpty(data.ShipmentDate))
                        {
                            DateTime date;
                            if (DateTime.TryParse(data.ShipmentDate, out date))
                                data.ShipmentDate = date.ToString("yyyy-MM-dd");
                            else
                                data.ShipmentDateErrMsg = "销售日期格式不正确";
                        }
                        else
                        {
                            data.ShipmentDateErrMsg = "销售日期为空";
                        }

                        //WhmName
                        data.Warehouse = dr[2] == DBNull.Value ? null : dr[2].ToString();
                        if (string.IsNullOrEmpty(data.Warehouse))
                            data.WarehouseErrMsg = "仓库名称为空";

                        data.ArticleNumber = dr[3] == DBNull.Value ? null : dr[3].ToString();
                        if (string.IsNullOrEmpty(data.ArticleNumber))
                            data.ArticleNumberErrMsg = "产品型号为空";

                        data.LotNumber = dr[4] == DBNull.Value ? null : dr[4].ToString();
                        if (string.IsNullOrEmpty(data.LotNumber))
                            data.LotNumberErrMsg = "产品批号为空";
                        data.QrCode = dr[5] == DBNull.Value ? "" : dr[5].ToString();
                        if (data.QrCode == "")
                        {
                            data.QrCode = "NoQR"; //未填写二维码用NoQR代替
                        }

                        data.Qty = dr[6] == DBNull.Value ? null : dr[6].ToString();
                        if (!string.IsNullOrEmpty(data.Qty))
                        {
                            decimal qty;
                            if (!Decimal.TryParse(data.Qty, out qty))
                                data.QtyErrMsg = "销售数量格式不正确";
                            else if (Decimal.Parse(data.Qty) < 0)
                                data.QtyErrMsg = "销售数量不能小于0";

                        }
                        else
                        {
                            data.QtyErrMsg = "销售数量为空";
                        }



                        data.Price = dr[7] == DBNull.Value ? null : dr[7].ToString();
                        if (!string.IsNullOrEmpty(data.Price))
                        {
                            decimal price;
                            if (!Decimal.TryParse(data.Price, out price))
                                data.PriceErrMsg = "销售单价格式不正确";
                            else if (Decimal.Parse(data.Price) < 0)
                                data.PriceErrMsg = "单价不能小于0";
                        }
                        else
                        {
                            data.PriceErrMsg = "销售单价为空";
                        }
                        
                        data.HospitalOffice = dr[8] == DBNull.Value ? null : dr[8].ToString();
                        data.InvoiceNumber = dr[9] == DBNull.Value ? null : dr[9].ToString();
                        data.InvoiceDate = dr[10] == DBNull.Value ? null : dr[10].ToString();
                        data.InvoiceTitle = dr[11] == DBNull.Value ? null : dr[11].ToString();
                        data.ChineseName = dr[12] == DBNull.Value ? null : dr[12].ToString();

                        if (!string.IsNullOrEmpty(data.InvoiceDate))
                        {
                            DateTime date;
                            if (DateTime.TryParse(data.InvoiceDate, out date))
                                data.InvoiceDate = date.ToString("yyyy-MM-dd");
                            else
                                data.InvoiceDateErrMsg = "发票日期格式不正确";
                        }
                        data.LotShipmentDate = dr[13] == DBNull.Value ? null : dr[13].ToString();
                        if (!string.IsNullOrEmpty(data.LotShipmentDate))
                        {
                            DateTime date;
                            if (DateTime.TryParse(data.LotShipmentDate, out date))
                                data.LotShipmentDate = date.ToString("yyyy-MM-dd");
                            else
                                data.LotShipmentDateErrMsg = "过效期产品用量日期格式不正确";
                        }
                        else
                        {
                        }
                        data.Remark = dr[14] == DBNull.Value ? null : dr[14].ToString();

                        data.ConsignmentNbr = dr[15] == DBNull.Value ? null : dr[15].ToString();

                        data.LineNbr = lineNbr++;
                        data.ErrorFlag = !(string.IsNullOrEmpty(data.HospitalNameErrMsg)
                            && string.IsNullOrEmpty(data.ShipmentDateErrMsg)
                            && string.IsNullOrEmpty(data.LotNumberErrMsg)
                            && string.IsNullOrEmpty(data.ArticleNumberErrMsg)
                            && string.IsNullOrEmpty(data.QtyErrMsg)
                            && string.IsNullOrEmpty(data.PriceErrMsg)
                            && string.IsNullOrEmpty(data.WarehouseErrMsg)
                            && string.IsNullOrEmpty(data.InvoiceDateErrMsg)
                            && string.IsNullOrEmpty(data.LotShipmentDateErrMsg)
                            );

                        if (!(string.IsNullOrEmpty(data.HospitalName) && string.IsNullOrEmpty(data.ShipmentDate)
                            && string.IsNullOrEmpty(data.ArticleNumber) && string.IsNullOrEmpty(data.LotNumber)
                            && string.IsNullOrEmpty(data.Price) && string.IsNullOrEmpty(data.Qty)
                            && string.IsNullOrEmpty(data.Warehouse) && string.IsNullOrEmpty(data.HospitalOffice)
                            && string.IsNullOrEmpty(data.InvoiceNumber) && string.IsNullOrEmpty(data.InvoiceDate)
                            && string.IsNullOrEmpty(data.InvoiceTitle) && string.IsNullOrEmpty(data.ChineseName)
                            && string.IsNullOrEmpty(data.LotShipmentDate) && string.IsNullOrEmpty(data.Remark))
                            && data.LineNbr != 1)
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
        /// 验证数据是否符合要求（二次导入）
        /// </summary>
        /// <returns></returns>
        public bool Verify(out string IsValid, int IsImport)
        {
            System.Diagnostics.Debug.WriteLine("Verify Start : " + DateTime.Now.ToString());
            bool result = false;
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            //调用存储过程验证数据
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                IsValid = dao.Initialize(new Guid(_context.User.Id), IsImport, new Guid(Convert.ToString(ht["SubCompanyId"])), new Guid(Convert.ToString(ht["BrandId"])));
                result = true;
            }
            System.Diagnostics.Debug.WriteLine("Verify Finish : " + DateTime.Now.ToString());
            return result;
        }


        public IList<ShipmentInit> QueryErrorData(int start, int limit, out int totalRowCount)
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("UserId", new Guid(_context.User.Id));
                //param.Add("Error", true);
                return dao.SelectByHashtable(param, start, limit, out totalRowCount);

            }
        }

        public void Delete(Guid id)
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                dao.Delete(id);
            }
        }

        public void Update(ShipmentInit obj)
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                dao.UpdateForEdit(obj);
            }
        }

        public void DeleteByUser()
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                dao.DeleteByUser(new Guid(_context.User.Id));
            }
        }

        public ShipmentInit SelectShipmentCount()
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                return dao.SelectShipmentCount(new Guid(_context.User.Id));
            }
        }

        public void InsertImportData(out string RtnVal, out string RtnMsg)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                dao.InsertImportData(new Guid(_context.User.Id), Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out RtnVal, out RtnMsg);
            }
        }

        public ShipmentHeader GetShipmentHeaderByIdForPrinting(Guid id)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.GetObjectForPrinting(id);
            }
        }

        /// <summary>
        /// 根据客户端ID初始化接口表
        /// </summary>
        /// <param name="clientid"></param>
        /// <param name="batchNbr"></param>
        /// <returns></returns>
        public int InitLPConsignmentInterfaceByClientID(string clientid, string batchNbr)
        {
            using (SalesInterfaceDao dao = new SalesInterfaceDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("Clientid", clientid);
                ht.Add("BatchNbr", batchNbr);
                ht.Add("UpdateDate", DateTime.Now);
                return dao.InitByClientID(ht);
            }

        }

        /// <summary>
        /// 根据批处理号得到订单明细数据
        /// </summary>
        /// <param name="batchNbr"></param>
        /// <returns></returns>
        public IList<LpConsignmentSalesData> QueryLPConsignmentSalesInfoByBatchNbr(string batchNbr)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (SalesInterfaceDao dao = new SalesInterfaceDao())
            {
                return dao.QueryLPConsignmentSalesInfoByBatchNbr(batchNbr,Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]));

            }
        }

        public bool AfterLpConsignmentSalesInfoDownload(string BatchNbr, string ClientID, string Success, out string RtnVal)
        {
            bool result = false;

            using (SalesInterfaceDao dao = new SalesInterfaceDao())
            {
                dao.AfterDownload(BatchNbr, ClientID, Success, out RtnVal);
                result = true;
            }
            return result;

        }

        public void UpdateReportInventoryHistory()
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                ReportInventoryHistoryDao rihDao = new ReportInventoryHistoryDao();
                IList<ShipmentInit> list = dao.GetAll();
                foreach (var item in list)
                {
                    Hashtable table = new Hashtable();
                    table.Add("WhmId", item.WhmId);
                    table.Add("PmaId", item.PmaId);
                    table.Add("LtmId", item.LtmId);
                    table.Add("QTY", item.Qty);
                    table.Add("ShipmentDate", item.ShipmentDate);
                    rihDao.UpdateForUpload(table);

                }
            }
        }

        public void DoConfirm()
        {
            UploadLog log = new UploadLog();
            log.Id = Guid.NewGuid();
            log.Type = "销售";
            log.CreateUser = new Guid(_context.User.Id);
            log.UploadDate = DateTime.Now;
            log.DmaId = RoleModelContext.Current.User.CorpId.Value;

            using (UploadLogDao dao = new UploadLogDao())
            {
                dao.Insert(log);
            }
        }

        public IDictionary<string, string> SelectShipmentOrderStatus()
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                IDictionary<string, string> dicts = dao.SelectShipmentOrderStatus();
                return dicts;
            }
        }

        /// <summary>
        /// 二级与一级经销商寄售提交自动生成补货单，一级经销商借货单提交自动生成补货单
        /// </summary>
        /// <param name="RtnVal"></param>
        /// <returns></returns>
        public void ConsignmentForOrder(ShipmentHeader obj, string ShipmentType, out string RtnVal, out string RtnMsg)
        {
            RtnVal = string.Empty;
            RtnMsg = string.Empty;

            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                //if (RoleModelContext.Current.User.CorpType == DealerType.T1.ToString()
                //           && obj.Type == ShipmentOrderType.Consignment.ToString())
                //{
                //    ShipmentHeader main = dao.GetObject(obj.Id);
                //    ShipmentType = "ConsignmentSales";
                //    dao.ConsigmentForOrder(main.ShipmentNbr, ShipmentType, out RtnVal, out RtnMsg);

                //}

                if (RoleModelContext.Current.User.CorpType == DealerType.T2.ToString()
                           && obj.Type == ShipmentOrderType.Consignment.ToString())
                {
                    ShipmentHeader main = dao.GetObject(obj.Id);
                    ShipmentType = "ConsignmentSales";
                    Hashtable ht = new Hashtable();
                    BaseService.AddCommonFilterCondition(ht);
                    dao.T2ConsigmentForOrder(main.ShipmentNbr, ShipmentType, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out RtnVal, out RtnMsg);

                }

                //modified by SongWeiming on 2014-05-29 物流平台的SA模式也会直接销售到医院
                //if ((RoleModelContext.Current.User.CorpType == DealerType.T1.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LP.ToString())
                //    && obj.Type == ShipmentOrderType.Borrow.ToString())
                //{
                //    ShipmentHeader main = dao.GetObject(obj.Id);
                //    ShipmentType = "ClearBorrowManual";
                //    dao.ConsigmentForOrder(main.ShipmentNbr, ShipmentType, out RtnVal, out RtnMsg);
                //}

                if ((RoleModelContext.Current.User.CorpType == DealerType.T1.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LS.ToString())
                    && obj.Type == ShipmentOrderType.Borrow.ToString())
                {
                    // 平台一级寄售产品报销量需要生成寄售销售买断单据
                    ShipmentHeader main = dao.GetObject(obj.Id);
                    ConsignCommonDao consignDao = new ConsignCommonDao();
                    Hashtable ht = new Hashtable();
                    BaseService.AddCommonFilterCondition(ht);
                    consignDao.ProcConsigntInvBuyOff("Shipment_Consignment", main.ShipmentNbr, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out RtnVal, out RtnMsg);
                    if (!RtnVal.Equals("Success")) throw new Exception(RtnMsg);
                }
            }
        }

        #region Added By Song Yuqi
        public bool AddConsignmentItems(Guid OrderId, Guid DealerId, string[] LtmIds)
        {
            bool result = false;

            ShipmentConsignment sc = null;
            using (TransactionScope trans = new TransactionScope())
            {
                using (ShipmentConsignmentDao dao = new ShipmentConsignmentDao())
                {
                    using (DealerProductPriceHistoryDao dphDao = new DealerProductPriceHistoryDao())
                    {
                        //删除ShipmentConsignment表记录
                        Hashtable parma = new Hashtable();
                        parma.Add("SphId", OrderId);
                        IList<ShipmentConsignment> list = dao.GetShipmentConsignmentByFilter(parma);

                        CurrentInvDao ciDao = new CurrentInvDao();

                        Hashtable param = new Hashtable();
                        param.Add("LtmIds", LtmIds);
                        DataTable dtLine = ciDao.SelectInventoryAdjustDetailByLotIDs(param).Tables[0];
                        //DataTable dtLot = ciDao.SelectInventoryAdjustLotByLotIDs(param).Tables[0];
                        Guid ProductId;
                        Guid LtmId;
                        foreach (DataRow drLine in dtLine.Rows)
                        {
                            //记录数为0
                            //记录数不存在则插入
                            if (list.Count == 0 || list.Where<ShipmentConsignment>(p => p.LtmId == new Guid(drLine["LtmId"].ToString())).Count() == 0)
                            {
                                ProductId = new Guid(drLine["ProductId"].ToString());
                                LtmId = new Guid(drLine["LtmId"].ToString());
                                Hashtable table = new Hashtable();
                                table.Add("DmaId", DealerId);
                                table.Add("PmaId", ProductId);
                                table.Add("LtmId", LtmId);
                                BaseService.AddCommonFilterCondition(table);
                                DealerProductPriceHistory dph = dphDao.SelectByFilterPmaDmaLtm(table);

                                sc = new ShipmentConsignment();
                                sc.Id = Guid.NewGuid();
                                sc.LtmId = LtmId;
                                sc.SphId = OrderId;
                                sc.ShippedQty = 1;
                                if (dph != null)
                                    sc.UnitPrice = Convert.ToDecimal(dph.UnitPrice);

                                dao.Insert(sc);
                            }
                        }

                    }
                }

                result = true;
                trans.Complete();
            }

            return result;
        }

        public DataSet QueryShipmentConsignment(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (ShipmentConsignmentDao dao = new ShipmentConsignmentDao())
            {
                return dao.SelectByFilter(table, start, limit, out totalRowCount);
            }
        }

        public ShipmentConsignment GetShipmentConsignmentById(Guid id)
        {
            using (ShipmentConsignmentDao dao = new ShipmentConsignmentDao())
            {
                return dao.GetObject(id);
            }
        }

        public bool SaveConsignmentItem(ShipmentConsignment sc)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                using (ShipmentConsignmentDao dao = new ShipmentConsignmentDao())
                {
                    dao.Update(sc);
                }

                result = true;

                trans.Complete();
            }

            return result;
        }

        public double GetConsignmentShipmentTotalAmount(Guid id)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.SelectConsignmentShipmentTotalAmountByHeaderId(id);
            }
        }

        public double GetConsignmentShipmentTotalQty(Guid id)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.SelectConsignmentShipmentTotalQtyByHeaderId(id);
            }
        }

        public bool DeleteConsignmentItem(Guid LotId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                using (ShipmentConsignmentDao dao = new ShipmentConsignmentDao())
                {
                    dao.Delete(LotId);
                }

                result = true;

                trans.Complete();
            }

            return result;
        }

        public bool DeleteConsignmentItemByHeaderId(Guid headId)
        {
            using (ShipmentConsignmentDao dao = new ShipmentConsignmentDao())
            {
                int i = dao.DeleteByHeaderId(headId);

                if (i > 0)
                    return true;
                return false;
            }

        }
        #endregion

        #region 二级经销商寄售销售冲红接口
        public void InsertDealerSalesWriteback(IList<InterfaceDealerSalesWriteback> list)
        {

            using (TransactionScope trans = new TransactionScope())
            {
                using (InterfaceDealerSalesWritebackDao dao = new InterfaceDealerSalesWritebackDao())
                {
                    foreach (InterfaceDealerSalesWriteback item in list)
                    {
                        dao.Insert(item);
                    }
                }
                trans.Complete();
            }
        }

        public bool AfterInterfaceDealerSalesWritebackUpload(string BatchNbr, string ClientID, out string IsValid, out string RtnMsg)
        {
            bool result = false;

            using (InterfaceDealerSalesWritebackDao dao = new InterfaceDealerSalesWritebackDao())
            {
                dao.AfterUpload(BatchNbr, ClientID, out IsValid, out RtnMsg);
                result = true;
            }
            return result;

        }

        public IList<InterfaceDealerSalesWriteback> SelectDealerSalesWritebackByBatchNbrErrorOnly(string BatchNbr)
        {
            using (InterfaceDealerSalesWritebackDao dao = new InterfaceDealerSalesWritebackDao())
            {
                return dao.SelectDealerSalesWritebackByBatchNbrErrorOnly(BatchNbr);

            }
        }

        public IList<InterfaceDealerSalesWriteback> SelectDealerSalesWritebackByBatchNbr(string BatchNbr)
        {
            using (InterfaceDealerSalesWritebackDao dao = new InterfaceDealerSalesWritebackDao())
            {
                return dao.SelectDealerSalesWritebackByBatchNbr(BatchNbr);

            }
        }

        public bool RevokeInterface(string WriteBackNo, Guid OrderId, string ShipmentNbr, DateTime WriteBackDate, string Remark)
        {
            Guid id = new Guid("00000000-0000-0000-0000-000000000000");
            bool result = false;
            using (TransactionScope trans = new TransactionScope())
            {
                AutoNumberBLL auto = new AutoNumberBLL();
                ShipmentHeaderDao mainDao = new ShipmentHeaderDao();
                ShipmentLineDao lineDao = new ShipmentLineDao();
                ShipmentLotDao lotDao = new ShipmentLotDao();
                InvTrans invTrans = new InvTrans();
                PurchaseOrderHeaderDao pHeaderDao = new PurchaseOrderHeaderDao();

                ShipmentHeader main = mainDao.GetObject(OrderId);

                //判断表头中状态是完成；orderStatus是ToApprove时不恢复库存；LP做T2的冲红时往接口表写记录
                if (main.Status == ShipmentOrderStatus.Complete.ToString() && !mainDao.GetSubmittedOrder(main.Id))
                {
                    main.Status = ShipmentOrderStatus.Reversed.ToString();
                    main.UpdateDate = DateTime.Now;
                    mainDao.Update(main);
                    //从销售单获取对应的订单，然后更新订单状态为“撤销”
                    if (!string.IsNullOrEmpty(main.ShipmentNbr))
                    {
                        //根据销售单单据号，找到订单号，然后更新订单状态
                        Hashtable ht = new Hashtable();
                        ht.Add("orderStatus", "Revoked");
                        ht.Add("shipmentNo", main.ShipmentNbr);
                        int updateRowNum = pHeaderDao.UpdateClearBorrowPurchaseOrderStatus(ht);
                        if (updateRowNum > 0)
                        {
                            //根据备注和订单类型获取订单ID
                            PurchaseOrderHeader poh = pHeaderDao.GetClearBorrowPurchaseOrderHeader(ht)[0];
                            this.InsertPurchaseOrderLog(poh.Id, id, PurchaseOrderOperationType.WriteOff, "因销售单冲红操作，对系统自动生成的清指定批号订单/寄售销售订单进行撤销操作");
                        }

                    }

                    //生成冲红单
                    ShipmentHeader mainNew = new ShipmentHeader();
                    mainNew.Id = Guid.NewGuid();
                    mainNew.HospitalHosId = main.HospitalHosId;
                    mainNew.ShipmentNbr = WriteBackNo;// auto.GetNextAutoNumber(main.DealerDmaId, OrderType.Next_ShipmentNbr, main.ProductLineBumId.Value);
                    mainNew.DealerDmaId = main.DealerDmaId;
                    mainNew.ShipmentDate = main.ShipmentDate;
                    mainNew.SubmitDate = WriteBackDate;
                    //将状态改为已冲红

                    mainNew.Status = ShipmentOrderStatus.Reversed.ToString();
                    mainNew.NoteForPumpSerialNbr = "从原销售单号「" + main.ShipmentNbr + "」冲红" + ";" + Remark;

                    mainNew.ReverseSphId = main.Id;
                    mainNew.ProductLineBumId = main.ProductLineBumId;
                    mainNew.UpdateDate = DateTime.Now;//added by songweiming on 20100628
                    mainNew.Type = main.Type;
                    mainNew.ShipmentUser = main.ShipmentUser;
                    mainNew.InvoiceNo = main.InvoiceNo;
                    mainNew.Office = main.Office;
                    mainNew.InvoiceTitle = main.InvoiceTitle;
                    mainNew.InvoiceDate = main.InvoiceDate;
                    mainNew.IsAuth = main.IsAuth;
                    mainDao.Insert(mainNew);

                    IList<ShipmentLine> lines = lineDao.SelectByHeaderId(main.Id);
                    foreach (ShipmentLine line in lines)
                    {
                        //生成冲红Line记录
                        ShipmentLine lineNew = new ShipmentLine();
                        lineNew.Id = Guid.NewGuid();
                        lineNew.SphId = mainNew.Id;
                        lineNew.ShipmentPmaId = line.ShipmentPmaId;
                        lineNew.ShipmentQty = 0 - line.ShipmentQty;
                        //lineNew.UnitPrice = line.UnitPrice;
                        lineNew.LineNbr = line.LineNbr;
                        lineDao.Insert(lineNew);

                        IList<ShipmentLot> lots = lotDao.SelectByLineId(line.Id);

                        foreach (ShipmentLot lot in lots)
                        {
                            //生成冲红Lot记录
                            ShipmentLot lotNew = new ShipmentLot();
                            lotNew.Id = Guid.NewGuid();
                            lotNew.SplId = lineNew.Id;
                            lotNew.LotShippedQty = 0 - lot.LotShippedQty;
                            lotNew.UnitPrice = lot.UnitPrice;
                            lotNew.LotId = lot.LotId;
                            lotNew.WhmId = lot.WhmId;
                            lotNew.Lot = lot.Lot;
                            lotNew.QRCode = lot.QRCode;
                            lotNew.ExpiredDate = lot.ExpiredDate;
                            lotNew.DOM = lot.DOM;
                            lotDao.Insert(lotNew);
                            invTrans.SaveInvRelatedShipment(mainNew, lineNew, lotNew);

                        }
                    }


                    //销售单接口表（LP冲红T2寄售单)
                    if (!string.IsNullOrEmpty(mainNew.Type))
                    {
                        this.InsertSalesInterfaceWriteBack(mainNew);
                    }
                    //记录操作日志
                    this.InsertPurchaseOrderLog(mainNew.Id, id, PurchaseOrderOperationType.WriteOff, null);
                    this.InsertPurchaseOrderLog(main.Id, id, PurchaseOrderOperationType.WriteOff, null);

                    result = true;

                }


                trans.Complete();
            }


            return result;
        }

        public void InsertSalesInterfaceWriteBack(ShipmentHeader obj)
        {
            using (SalesInterfaceDao dao = new SalesInterfaceDao())
            {
                SalesInterface inter = new SalesInterface();
                inter.Id = Guid.NewGuid();
                inter.BatchNbr = string.Empty;
                inter.RecordNbr = string.Empty;
                inter.SphId = obj.Id;
                inter.SphShipmentNbr = obj.ShipmentNbr;
                inter.Status = PurchaseOrderMakeStatus.Pending.ToString();
                inter.ProcessType = PurchaseOrderCreateType.Manual.ToString();
                inter.CreateUser = obj.ShipmentUser;
                inter.CreateDate = DateTime.Now;
                inter.UpdateDate = DateTime.Now;
                inter.Clientid = _clientBLL.GetParentClientByCorpId(obj.DealerDmaId).Id;
                dao.Insert(inter);
            }

        }

        public bool IsAdminRole()
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.SelectAdminRole(new Guid(RoleModelContext.Current.User.Id));
            }
        }

        public bool SelectAdminRoleAction(Guid id)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.SelectAdminRoleAction(id);
            }
        }
        #endregion

        //经销商提交医院销售数据前数据校验 Add by Songweiming on 2015-08-27 
        public bool CheckSubmit(Guid sphId, string shipmentDate, Guid shipmentUser, Guid dealerId, Guid productLineId, Guid hospitalId, out string rtnVal, out string rtnMsg)
        {
            bool result = false;

            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                dao.CheckSubmit(sphId, shipmentDate, shipmentUser, dealerId, productLineId, hospitalId, out rtnVal, out rtnMsg);
                result = true;
            }
            return result;
        }

        public DataSet SelectShipmentLotByChecked(string Id)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                DataSet ds = dao.SelectShipmentLotByChecked(Id);
                return ds;
            }
        }
        public DataSet SelectShipmentdistictLotid(string Id)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                DataSet ds = dao.SelectShipmentdistictLotid(Id);
                return ds;
            }
        }
        public DataSet SelectShipmentLotQty(string lotId, string sphId)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                DataSet ds = dao.SelectShipmentLotQty(lotId, sphId);
                return ds;
            }
        }

        public string DeleteShipmentNotAuthCfn(Hashtable obj)
        {
            using (ShipmentLineDao dao = new ShipmentLineDao())
            {
                string massage = dao.DeleteShipmentNotAuthCfn(obj);
                return massage;
            }
        }

        public int DeleteErrorShipmentLot(Hashtable obj)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                int massage = dao.DeleteErrorShipmentLotByHeaderId(obj);
                return massage;
            }
        }



        #region 销售调整 Added By Song Yuqi On 2016-03-29
        /// <summary>
        /// 查询历史销售数据
        /// </summary>
        /// <param name="table"></param>
        /// <returns></returns>
        public DataSet QueryShipmentLotByFilter(Hashtable table)
        {
            using (ShipmentAdjustLotDao dao = new ShipmentAdjustLotDao())
            {
                return dao.QueryShipmentLotByFilter(table);
            }
        }

        /// <summary>
        /// 获得添加的销售明细数据
        /// </summary>
        /// <param name="sphId"></param>
        /// <returns></returns>
        public DataSet QueryShipmentAdjustLotForShipmentBySphId(Guid sphId)
        {
            using (ShipmentAdjustLotDao dao = new ShipmentAdjustLotDao())
            {
                return dao.QueryShipmentAdjustLotForShipmentBySphId(sphId);
            }
        }

        /// <summary>
        /// 获得添加的库存数据
        /// </summary>
        /// <param name="sphId"></param>
        /// <returns></returns>
        public DataSet QueryShipmentAdjustLotForInventoryBySphId(Guid sphId)
        {
            using (ShipmentAdjustLotDao dao = new ShipmentAdjustLotDao())
            {
                return dao.QueryShipmentAdjustLotForInventoryBySphId(sphId);
            }
        }

        public void AddShipmentItems(Guid SphId, Guid DealerId, Guid HosId, string LotIdString, string AddType, out string rtnVal, out string rtnMsg)
        {
            using (ShipmentAdjustLotDao dao = new ShipmentAdjustLotDao())
            {
                dao.AddShipmentAdjustItem(SphId, DealerId, HosId, LotIdString, AddType, out rtnVal, out rtnMsg);
            }
        }

        public bool DeleteAdjustItem(Guid SalId, Guid SphId, Guid LotId)
        {
            bool result = false;

            using (TransactionScope trans = new TransactionScope())
            {
                using (ShipmentAdjustLotDao dao = new ShipmentAdjustLotDao())
                {
                    dao.Delete(SalId);

                    Hashtable table = new Hashtable();
                    table.Add("SphId", SphId);
                    table.Add("LotId", LotId);
                    dao.DeleteShipmentLotByFilter(table);

                    result = true;
                }
                trans.Complete();
            }

            return result;
        }

        public bool DeleteShipmentAdjustLotBySphId(Guid sphId)
        {
            bool result = false;
            using (ShipmentAdjustLotDao dao = new ShipmentAdjustLotDao())
            {
                int i = dao.DeleteShipmentAdjustLotBySphId(sphId);
                if (i > 0)
                    result = true;
            }

            return result;
        }

        public ShipmentAdjustLot GetShipmentAdjustLotById(Guid Id)
        {
            using (ShipmentAdjustLotDao dao = new ShipmentAdjustLotDao())
            {
                return dao.GetObject(Id);
            }
        }

        public bool SaveShipmentAdjust(ShipmentAdjustLot obj)
        {
            bool result = false;
            using (ShipmentAdjustLotDao dao = new ShipmentAdjustLotDao())
            {
                int i = dao.Update(obj);
                if (i > 0)
                    result = true;
            }
            return result;
        }

        public void AddShipmentAdjustToShipmentLot(Guid SphId, Guid DealerId, Guid HosId, string ShipmentDate, string Reason,string OpsUser, out string rtnVal, out string rtnMsg)
        {
            using (ShipmentAdjustLotDao dao = new ShipmentAdjustLotDao())
            {
                dao.AddShipmentAdjustToShipmentLot(SphId, DealerId, HosId, ShipmentDate, Reason, OpsUser, out rtnVal, out rtnMsg);
            }
        }

        #endregion

        #region 蓝海的Endo及IC产品线，上报销量时必须上传附件

        public bool CheckNeedUploadAttachment(Guid DealerId, Guid ProductLineId)
        {
            bool result = false;
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                Hashtable ht = new Hashtable();
                ht.Add("DealerId", DealerId);
                ht.Add("ProductLineId", ProductLineId);
                DataSet ds = dao.CheckNeedUploadAttachment(ht);
                if (ds.Tables[0].Rows[0]["Cnt"].ToString() != "0")
                {
                    result = true;
                }
            }

            return result;
        }

        public ShipmentlpConfirmHeader GetShipmentlpConfirmHeaderByOrderNo(string OrderNo)
        {
            using (ShipmentlpConfirmHeaderDao dao = new ShipmentlpConfirmHeaderDao())
            {
                return dao.GetShipmentlpConfirmHeaderByOrderNo(OrderNo);
            }
        }
        public DataSet GetShipmentlpConfirmHeaderInfoByOrderUpnLot(Hashtable ht, int start, int limit, out int totalRowCount)
        {
            using (ShipmentlpConfirmHeaderDao dao = new ShipmentlpConfirmHeaderDao())
            {
                return dao.QueryShipmentlpConfirmHeaderInfoByOrderUpnLot(ht, start, limit, out totalRowCount);
            }
        }
        public bool UpdateSCHConfirmDate(Hashtable ht)
        {
            bool reslur = false;
            using (ShipmentlpConfirmHeaderDao dao = new ShipmentlpConfirmHeaderDao())
            {
                dao.UpdateSCHConfirmDate(ht);
                reslur = true;
            }
            return reslur;
        }
        public bool SaveAdjustItemPrice(Hashtable ht)
        {
            bool reslur = false;
            using (ShipmentlpConfirmHeaderDao dao = new ShipmentlpConfirmHeaderDao())
            {
                dao.SaveAdjustItemPrice(ht);
                reslur = true;
            }
            return reslur;
        }
        public int GetCalendarDateSix()
        {

            using (ShipmentAdjustLotDao dao = new ShipmentAdjustLotDao())
            {
                return dao.GetCalendarDateSix();
            }
        }
        #endregion

        #region 经销商上报销量上传文件控制
        public DataSet SelectLimitNumber(Guid DealerId)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                DataSet ds = dao.SelectLimitNumber(DealerId);
                return ds;
            }
        }

        public DataSet SelectShipmentLimitBUCount(Guid DealerId)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                DataSet ds = dao.SelectShipmentLimitBUCount(DealerId);
                return ds;
            }
        }
        #endregion

        #region 查询财务是否添加过寄售销售单批注
        public DataSet SelectShipmentLog(string sphId)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                DataSet ds = dao.SelectShipmentLog(sphId);
                return ds;
            }
        }

        public void GenClearBorrow(string sphId, out string rtnVal, out string rtnMsg)
        {
            Hashtable ht = new Hashtable();
            BaseService.AddCommonFilterCondition(ht);
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                dao.GenClearBorrow(sphId, Convert.ToString(ht["SubCompanyId"]), Convert.ToString(ht["BrandId"]), out rtnVal, out rtnMsg);
            }
        }
        #endregion

        public DataSet ExportShipmentByFilter(Hashtable table)
        {
            //获取当前登录身份类型以及所属组织

            table.Add("OwnerIdentityType", this._context.User.IdentityType);
            table.Add("OwnerOrganizationUnits", this._context.User.GetOrganizationUnits());
            table.Add("OwnerId", new Guid(this._context.User.Id));
            table.Add("OwnerCorpId", this._context.User.CorpId);

            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.ExportShipmentByFilter(table);

            }
        }

        #region 关联发票号新增附件 Added By Song Yuqi On 2017-05-02

        public IList<ShipmentInvoiceInit> QueryShipmentInvoiceInitErrorData(int start, int limit, out int totalRowCount)
        {
            using (ShipmentInvoiceInitDao dao = new ShipmentInvoiceInitDao())
            {
                Hashtable param = new Hashtable();
                param.Add("UserId", new Guid(_context.User.Id));

                return dao.QueryShipmentInvoiceInitErrorData(param, start, limit, out totalRowCount);
            }
        }

        public DataSet ExportShipmentAttachment(Hashtable obj)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.ExportShipmentAttachment(obj);

            }
        }

        public DataSet ShipmentAttachmentDownload(string id)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.ShipmentAttachmentDownload(id);

            }
        }




        public int InsertAttachmentForShipmentUploadFile(string fileName, string fileUrl)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                Hashtable table = new Hashtable();

                table.Add("FileName", fileName);
                table.Add("FileUrl", fileUrl);
                table.Add("FileType", AttachmentType.ShipmentToHospital.ToString());
                table.Add("UserId", _context.User.Id);
                table.Add("InvoiceNo", fileName.Split('.').Count() > 0 ? fileName.Split('.')[0].Trim() : fileName);
                table.Add("DealerId", _context.User.CorpId);

                int i = dao.QueryShipmentUploadFileByInvoiceNo(table);

                if (i > 0)
                {
                    //若此发票已存在
                    //那么先删除老的发票信息（AT_MainId + AT_Name相同含扩展名）
                    //为了不必要的问题，程序执行逻辑删除，不删除Attachment中信息，也不删除物理文件
                    dao.FakeDeleteAttachmentByMainIdAndFileName(table);
                    //新增发票信息
                    dao.InsertAttachmentForShipmentUploadFile(table);
                }

                return i;
            }
        }

        public void DeleteShipmentInvoiceInitByUser()
        {
            using (ShipmentInvoiceInitDao dao = new ShipmentInvoiceInitDao())
            {
                dao.DeleteShipmentInvoiceInitByUser(new Guid(_context.User.Id));
            }
        }

        public bool InvoiceImport(DataTable dt, string fileName)
        {
            System.Diagnostics.Debug.WriteLine("Import Start : " + DateTime.Now.ToString());
            bool result = true;
            try
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    ShipmentInvoiceInitDao dao = new ShipmentInvoiceInitDao();

                    int lineNbr = 1;
                    IList<ShipmentInvoiceInit> list = new List<ShipmentInvoiceInit>();
                    foreach (DataRow dr in dt.Rows)
                    {
                        ShipmentInvoiceInit data = new ShipmentInvoiceInit();
                        data.Id = Guid.NewGuid();
                        data.LineNbr = lineNbr++;
                        data.ImportDate = DateTime.Now;
                        data.ImportUser = new Guid(_context.User.Id);
                        data.IsError = false;

                        //导入人必须为经销商
                        if (_context.User.CorpId.HasValue)
                        {
                            data.DmaId = _context.User.CorpId.Value;
                        }
                        else
                        {
                            data.ErrorMsg = data.ErrorMsg + "导入人不是经销商,";
                        }

                        //0、经销商
                        data.ShipmentNbr = dr[0] == DBNull.Value ? string.Empty : dr[0].ToString().Trim();
                        if (string.IsNullOrEmpty(data.ShipmentNbr.Trim()))
                            data.ErrorMsg = data.ErrorMsg + "销售单号必须填写,";

                        //1、发票号
                        data.InvoiceNo = dr[0] == DBNull.Value ? string.Empty : dr[1].ToString().Trim();
                        if (string.IsNullOrEmpty(data.InvoiceNo.Trim()))
                            data.ErrorMsg = data.ErrorMsg + "发票号必须填写,";

                        if (!string.IsNullOrEmpty(data.ErrorMsg))
                        {
                            data.IsError = true;
                            result = false;
                        }

                        if (data.LineNbr != 1)
                        {
                            list.Add(data);
                        }
                    }
                    dao.BatchInvoiceInsert(list);

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
        /// 验证数据是否符合要求（二次导入）
        /// </summary>
        /// <returns></returns>
        public void InvoiceVerify(int IsImport, out string RtnVal, out string RtnMsg)
        {
            System.Diagnostics.Debug.WriteLine("Verify Start : " + DateTime.Now.ToString());
            //调用存储过程验证数据
            using (ShipmentInvoiceInitDao dao = new ShipmentInvoiceInitDao())
            {
                dao.Initialize(new Guid(_context.User.Id), IsImport, out RtnVal, out RtnMsg);
            }
            System.Diagnostics.Debug.WriteLine("Verify Finish : " + DateTime.Now.ToString());
        }

        #endregion

        #region 销售单批量导入
        public DataSet QueryShipmentInitList(Hashtable param)
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                return dao.SelectShipmentInitList(param);

            }
        }
        public bool ShipmentInitCheck()
        {
            bool result = false;
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                DataSet ds= dao.GetShipmentInit(this._context.User.CorpId.Value.ToString());
                if (ds.Tables[0].Rows.Count== 0)
                {
                    result = true;
                }
                return result;
            }
        }
        public DataSet QueryShipmentInitResult(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                return dao.QueryShipmentInitResult(table, start, limit, out totalRowCount);
            }
        }
        public DataSet ExportShipmentInitResult(Hashtable table)
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                return dao.ExportShipmentInitResult(table);
            }
        }
        public DataSet QueryShipmentInitProcessing(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                return dao.QueryShipmentInitProcessing(table, start, limit, out totalRowCount);
            }
        }
        public DataSet QueryDealerAuthorizationList(Hashtable table, int start, int limit, out int totalRowCount)
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                return dao.QueryDealerAuthorizationList(table, start, limit, out totalRowCount);
            }
        }
        public DataSet GetShipmentInitSum(Hashtable table)
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                return dao.GetShipmentInitSum(table);
            }
        }
        #endregion

        public DataSet GetHospitalShipmentbscBeforeSubmitInitByCondition(Hashtable table)
        {
            using (HospitalShipmentbscBeforeSubmitInitDao dao = new HospitalShipmentbscBeforeSubmitInitDao())
            {
                return dao.GetObjectByCondition(table);
            }
        }

        public DataSet GetHospitalShipmentSumBeforeSubmitInitByCondition(Hashtable table)
        {
            using (HospitalShipmentbscBeforeSubmitInitDao dao = new HospitalShipmentbscBeforeSubmitInitDao())
            {
                return dao.GetObjectSumInfoByCondition(table);
            }
        }
        public DataSet GetShipmentInitNoConfirm(Hashtable table)
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                return dao.GetShipmentInitNoConfirm(table);
            }
        }
        public int ConfirmShipmenInit(string stringNo)
        {
            using (ShipmentInitDao dao = new ShipmentInitDao())
            {
                return dao.ConfirmShipmenInit(stringNo);
            }
        }

        public DataSet GetHospitalShipmentbscBeforeSubmitInitForExport(Hashtable table)
        {
            using (HospitalShipmentbscBeforeSubmitInitDao dao = new HospitalShipmentbscBeforeSubmitInitDao())
            {
                return dao.GetObjectForExportByCondition(table);
            }
        }

        public bool SaveUpdateLog(ShipmentLot lot)
        {
            bool result = false;
          
            ShipmentLotDao lotDao = new ShipmentLotDao();
            Hashtable obj = new Hashtable();
            obj.Add("SLT_ID", lot.Id);
            obj.Add("InputUser",_context.User.Id);

            lotDao.SaveUpdateLog(obj);
            result = true;

            return result;
        }

        public DataSet SelectShipmentHeaderToUploadToBSC(int start, int limit, out int totalRowCount)
        {
            using (ShipmentHeaderDao dao = new ShipmentHeaderDao())
            {
                return dao.SelectShipmentHeaderToUploadToBSC(start, limit, out totalRowCount);
            }
        }

        public DataSet SelectShipmentLotToUploadToBSC(string SPH_ID)
        {
            using (ShipmentLotDao dao = new ShipmentLotDao())
            {
                return dao.SelectShipmentLotToUploadToBSC(SPH_ID);
            }
        }
    }
}
