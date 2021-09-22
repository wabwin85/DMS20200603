using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;


namespace DMS.Business
{
    using Coolite.Ext.Web;
    using Grapecity.DataAccess.Transaction;
    using Lafite.RoleModel.Security;
    using DMS.DataAccess;
    using DMS.Model;
    using DMS.Common;
    using DMS.Model.Data;
    using System.Data;

    /// <summary>
    /// 样例
    /// </summary>
    public class InventoryTransactionSamples
    {
        public void setInventoryTransactionWithConstant()
        {

            /*  
             *  库存表有Inventory, Lot, InventoryTransaction, InventoryTransactionLot, LotMaster。

             *  类InvTrans影响表Inventory, Lot, InventoryTransaction, InventoryTransactionLot。LotMaster只在采购入库里做新增处理。

             *  其他时候LotMaster只是个信息参照表。

             * 
             *  库存表（Inventory）中不存在记录的库存事项，处理时将this.InventoryRecID置空，

             *  但其他的字段this.WarehouseRecID,this.ProductRecID保证不为空，该类会在表中添加记录。

             *  
             *  同样对于Lot表中没有的批次作同样处理。

             * 
             *  此类事项主要涉及往库存中增加新物料的事项。如：采购入库、样品移入、经销商借入库存、移库移入。

             *          
             *  采购入库的处理：LotMaster表和Lot表总是新增。Inventory表中仓库、产品不同时才新增。

             *  
             *  样品移入、经销商借入库存、移库移入的处理：

             *      Lot表：先查Lot表中是否有相同同一仓库、产品、批次的记录，若有则将数量相加，无则新增记录。

             *      Inventory表：先查是否有同一仓库、产品的记录，若有则数量相加，无则新增记录。

             *   
             * 2009/07/22 @ GrapeCity      
             */

            InvTrans itTest = new InvTrans();
            InvTransLot lot = new InvTransLot();
            lot.LotRecID = new Guid("df7a2b33-8666-486d-9072-143cde542d72"); //需要新建记录时,为空.
            lot.LotMasterRecID = new Guid("9b1bcc20-05e0-44e3-9739-8adee7ddf81e");
            lot.LotNumber = "200080901";
            lot.Qty = -1.0F;            //数量的一致性需要自己控制。（批次数量之和应等于事项的数量。负数为出库，正数为入库。）
            itTest.TransLots.Add(lot);  //如果有多个批次或序列号，这里增加多次。



            itTest.InventoryRecID = new Guid("cbd11290-90a9-45da-8fee-906ebc768759");//需要新建记录时,为空.
            itTest.WarehouseRecID = new Guid("8b05101f-045c-44a5-9512-9c490094d52b");
            itTest.ProductRecID = new Guid("bd0cd67a-9788-4412-8879-62ca71d970ec");
            itTest.Qty = -1.0F;
            itTest.Type = "销售发货"; //SR.CONST_INV_TRANS_TYPE_Shipment; 必需,参见类属性定义

            itTest.ReferenceID = Guid.NewGuid(); //必需,参见类属性定义


            itTest.SaveInventoryTransaction();

        }
    }

    /// <summary>
    /// 需要保存的批次
    /// </summary>
    public class InvTransLot
    {
        public Guid LotMasterRecID { get; set; }    //批次记录集

        public Guid LotRecID { get; set; }
        public float Qty { get; set; }
        public string LotNumber { get; set; }
    }

    /// <summary>
    /// 需要保存的当前库存和库存事项

    /// </summary>
    public class InvTrans
    {

        #region 公用方法（获得缺省仓库、获得系统用仓库）


        /// <summary>
        /// 获得经销商的缺省仓库
        /// </summary>
        /// <param name="DmaId">经销商记录号</param>
        /// <returns>仓库记录号</returns>
        public Guid GetDefaultWarehouse(Guid DmaId)
        {
            Hashtable ht = new Hashtable();
            Warehouses whs = new Warehouses();
            ht.Add("DmaId", DmaId);
            ht.Add("Type", SR.Consts_Default_Warehouse);
            ht.Add("ActiveFlag", "true");
            IList<Warehouse> wl = whs.GetWarehousesByHashtable(ht); //查询数据库是否有缺省仓库存在
            if (wl.Count == 0)
            {
                DealerMasters dms = new DealerMasters();
                string strDealerName = dms.GetDealerMaster(DmaId).ChineseName;
                throw new Exception(string.Format("经销商：{0}的缺省仓库没有找到，请确认。", strDealerName));
            }
            else
                return wl[0].Id.Value;//如果有多个,返回第一个。

        }
        /// <summary>
        /// 获得系统用的仓库
        /// </summary>
        /// <param name="DmaId">经销商记录代码</param>
        /// <returns>仓库的记录代码</returns>
        public Guid GetSystemHoldWarehouse(Guid DmaId)
        {
            Hashtable ht = new Hashtable();
            Warehouses whs = new Warehouses();
            ht.Add("DmaId", DmaId);
            ht.Add("ActiveFlag", "true");
            ht.Add("Type", SR.Consts_SystemHold_Warehouse);
            ht.Add("HoldWarehouse", "true");
            IList<Warehouse> wl = whs.SelectByHashtableForCreateSystemHoldWH(ht); //查询数据库是否有系统用的仓库存在
            if (wl.Count == 0)
            {
                Warehouse wh = new Warehouse();
                wh.Id = Guid.NewGuid();
                wh.DmaId = DmaId;
                wh.Name = "在途";
                wh.HoldWarehouse = true;
                wh.Type = SR.Consts_SystemHold_Warehouse;
                wh.ActiveFlag = true;
                whs.Insert(wh);
                return wh.Id.Value;
            }
            else
                return wl[0].Id.Value;//如果有多个,返回第一个。

        }

        #endregion


        public enum InvTransferType
        {
            TransferOnly = 0,//直接转移
            TransferBorrow, //借入、移入
            TransferRent,   //借出、移出
            TransferCancel, //撤销、拒绝
            TransferRentOnly //借出（只扣减借出方库存）
        }

        #region 属性

        private DateTime dtTransDate;
        public Guid? InventoryRecID { get; set; }
        public Guid? WarehouseRecID { get; set; }
        public Guid? ProductRecID { get; set; }
        public IList<InvTransLot> TransLots { get; set; }        //批次列表
        public float Qty { get; set; }
        public float UnitPrice { get; set; }

        public string Type { get; set; }
        /*  系统中的库存事项类型：

         *  移库
         *  经销商借货：借出、借入 --- 移库（两类）
         *          表中写：
         *              经销商借货：借出
         *              经销商借货：借入
         *  库存调整：退货、样品、报废

         *          表中写：
         *              库存调整：退货

         *              库存调整：样品

         *              库存调整：报废

         *  采购入库
         *  销售出库

         *         
        //public const string CONST_INV_TRANS_TYPE_POReceipt = "采购入库";
        //public const string CONST_INV_TRANS_TYPE_Shipment = "销售出库";
        //public const string CONST_INV_TRANS_TYPE_Transfer = "移库";
        //public const string CONST_INV_TRANS_TYPE_Transfer_RentOut = "经销商借货：借出";
        //public const string CONST_INV_TRANS_TYPE_Transfer_Borrow = "经销商借货：借入";
        //public const string CONST_INV_TRANS_TYPE_Adjust_Return = "库存调整：退货";
        //public const string CONST_INV_TRANS_TYPE_Adjust_Sample = "库存调整：样品";
        //public const string CONST_INV_TRANS_TYPE_Adjust_Scrap = "库存调整：报废";
        */

        public Guid? ReferenceID { get; set; }
        /*  库存事项对应的参考字段

         *  移库:TransferLine.TRL_ID
         *  经销商借货:TransferLine.TRL_ID
         *  库存调整:InventoryAdjustDetail.IAD_ID
         *  采购入库:POReceipt.POR_ID
         *  销售出库:ShipmentLine.SPL_ID
        */
        #endregion

        #region 方法
        /// <summary>
        /// 初始化

        /// </summary>
        public InvTrans()
        {
            this.InventoryRecID = null;
            this.ProductRecID = null;
            this.WarehouseRecID = null;
            this.TransLots = null;
            this.Qty = 1.0F;
            this.Type = "";
            this.TransLots = new List<InvTransLot>();
        }

        #region 使用专有属性保存库存事项


        /// <summary>
        /// 保存库存事务
        /// </summary>
        public void SaveInventoryTransaction()
        {
            CheckRequiredField();
            this.dtTransDate = DateTime.Now;

            using (TransactionScope trans = new TransactionScope())
            {
                try
                {
                    SaveInventory();
                    SaveLot();
                    SaveInventoryTransactions();
                    trans.Complete();
                }
                catch (Exception e)
                {
                    trans.VoteRollBack();

                }
                finally
                {

                }
            }

        }

        /// <summary>
        /// 检查是否传入仓库和产品记录号，若未传入则抛出异常报错。

        /// </summary>
        private void CheckRequiredField()
        {
            if (this.InventoryRecID == null)
            {
                if ((this.WarehouseRecID == null) || (this.ProductRecID == null))
                    throw new Exception("新建库存记录，必须有仓库和产品信息。");
            }
            else
            {
                foreach (InvTransLot lot in this.TransLots)
                {
                    if (lot.LotRecID == null)
                    {
                        if (lot.LotMasterRecID == null)
                        {
                            throw new Exception("新建批次记录时，必须要有批次信息。");
                        }
                    }
                }
            }
            if (this.ReferenceID == null)
            {
                throw new Exception("事项来源指针需要指定。");
            }
            if (this.Type == null)
            {
                throw new Exception("事项类型需要指定。");
            }
        }

        /// <summary>
        /// 保存或更新库存

        /// </summary>
        private void SaveInventory()
        {
            Inventories invs = new Inventories();
            Inventory inventory = new Inventory();
            Hashtable ht = new Hashtable();
            if (this.InventoryRecID == null)
            {
                inventory.Id = Guid.NewGuid();
                inventory.WhmId = this.WarehouseRecID.Value;
                inventory.PmaId = this.ProductRecID.Value;
                inventory.OnHandQuantity = this.Qty;
                invs.Insert(inventory);
            }
            else
            {
                ht.Add("Id", this.InventoryRecID.ToString());
                ht.Add("OnHandQuantity", this.Qty);
                invs.UpdateInventoryWithQty(ht);
            }
        }

        /// <summary>
        /// 保存或更新批次表
        /// </summary>
        private void SaveLot()
        {
            Lot saveLot = new Lot();
            Lots ls = new Lots();

            foreach (InvTransLot transLot in this.TransLots)
            {
                if (transLot.LotRecID == null)
                {
                    saveLot.Id = Guid.NewGuid();
                    saveLot.InvId = this.InventoryRecID.Value;
                    saveLot.LtmId = transLot.LotMasterRecID;
                    saveLot.OnHandQty = transLot.Qty;
                    ls.Insert(saveLot);
                }
                else
                {
                    Hashtable ht = new Hashtable();
                    ht.Add("Id", transLot.LotRecID.ToString());
                    ht.Add("OnHandQty", transLot.Qty);
                    ls.UpdateLotWithQty(ht);
                }
            }

        }

        /// <summary>
        /// 保存库存事项
        /// </summary>
        private void SaveInventoryTransactions()
        {
            InventoryTransaction itr = new InventoryTransaction();
            InventoryTransactionLot itrLot = new InventoryTransactionLot();

            itr.Id = Guid.NewGuid();
            itr.Quantity = this.Qty;
            itr.TransactionDate = this.dtTransDate;
            itr.Type = this.Type;
            itr.Referenceid = this.ReferenceID.Value;
            itr.WhmId = this.WarehouseRecID.Value;
            itr.PmaId = this.ProductRecID.Value;
            itr.UnitPrice = this.UnitPrice;

            InventoryTransactions itrs = new InventoryTransactions();
            itrs.Insert(itr);

            InventoryTransactionLots itrLots = new InventoryTransactionLots();

            foreach (InvTransLot invtranslot in this.TransLots)
            {
                itrLot.Id = Guid.NewGuid();
                itrLot.ItrId = itr.Id;
                itrLot.LtmId = invtranslot.LotMasterRecID;
                itrLot.Quantity = invtranslot.Qty;
                itrLot.LotNumber = invtranslot.LotNumber;
                itrLots.Insert(itrLot);
            }

        }

        #endregion

        #region 保存销售发货库存事项


        /*
         *
         * 
         */


        /// <summary>
        /// 销售发货的库存事项保存（无Transaction）

        /// </summary>
        /// <param name="prh"></param>
        /// <returns>返回</returns>
        public void SaveInvRelatedShipment(ShipmentHeader sHeader, ShipmentLine sLine, ShipmentLot sLot)
        {
            Hashtable ht = new Hashtable();
            Guid gidInvId;
            Guid gidItrId;

            LotMaster lm = new LotMaster();
            LotMasters lms = new LotMasters();
            Lot l = new Lot();
            Lots ls = new Lots();

            Inventories invs = new Inventories();
            InventoryTransactions its = new InventoryTransactions();

            Inventory inv = new Inventory();
            InventoryTransaction itr = new InventoryTransaction();

            //批次
            l = ls.GetLot(sLot.LotId);
            ht.Clear();
            ht.Add("Id", l.Id);
            ht.Add("OnHandQty", -sLot.LotShippedQty);
            ls.UpdateLotWithQty(ht);

            //库存
            ht.Clear();
            gidInvId = l.InvId;
            ht.Add("Id", gidInvId.ToString());
            ht.Add("OnHandQuantity", -sLot.LotShippedQty);
            invs.UpdateInventoryWithQty(ht);

            //库存事项
            gidItrId = Guid.NewGuid();
            itr.Id = gidItrId;
            itr.PmaId = sLine.ShipmentPmaId;
            itr.WhmId = sLot.WhmId;
            if (sLine.UnitPrice != null)
            {
                itr.UnitPrice = sLine.UnitPrice.Value;
            }
            itr.Type = SR.CONST_INV_TRANS_TYPE_Shipment;
            itr.Referenceid = sLot.Id;
            itr.TransactionDate = DateTime.Now;
            itr.Quantity = -sLot.LotShippedQty;
            itr.TransDescription = string.Format("销售出库单：{0} 行：{1}", sHeader.ShipmentNbr, sLine.LineNbr);
            its.Insert(itr);

            lm = lms.GetLotMaster(l.LtmId);

            //处理Inventory Transaction Lot
            InventoryTransactionLot ltrl = new InventoryTransactionLot();
            InventoryTransactionLots ltrls = new InventoryTransactionLots();
            ltrl.Id = Guid.NewGuid();
            ltrl.LtmId = l.LtmId;
            ltrl.ItrId = gidItrId;
            ltrl.LotNumber = lm.LotNumber;
            ltrl.Quantity = -sLot.LotShippedQty;
            ltrls.Insert(ltrl);

        }

        #endregion

        #region 保存库存调整库存事项

        /// <summary>
        /// 库存调整的库存事项保存（无Transaction）

        /// </summary>
        /// <param name="prh"></param>
        /// <returns>返回</returns>
        public void SaveInvRelatedInventoryAdjust(InventoryAdjustDetail iad, InventoryAdjustLot ial, AdjustType adjType, AdjustStatus adjStatus, Guid SystemHoldWarehouse, Guid? ToWarehouse)
        {
            string description;

            #region 其他入库

            if (adjType == AdjustType.StockIn)
            {
                LotMasters lms = new LotMasters();
                //判断LotMaster是否已存在
                LotMaster lm = lms.SelectLotMasterByLotNumber(ial.LotNumber, iad.PmaId);

                if (lm == null)
                {
                    lm = new LotMaster();
                    //增加LotMaster记录
                    lm.Id = Guid.NewGuid();
                    lm.LotNumber = ial.LotNumber;
                    lm.ExpiredDate = ial.ExpiredDate;
                    lm.CreateDate = DateTime.Now;
                    lm.ProductPmaId = iad.PmaId;
                    lms.Insert(lm);
                }

                if (adjStatus == AdjustStatus.Submit)
                {

                    //直接传入InventoryAdjustLot的LotId用于生成批次记录号。

                    description = string.Format("库存调整类型：{0}。移入仓库。", adjType.ToString());
                    this.HandleOneTransfer(ial.LotId.Value, lm.Id, iad.PmaId, ial.WhmId.Value, -ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_StockIn), description);
                }
                //撤销后要还原到库存中
                if (adjStatus == AdjustStatus.Cancelled)
                {
                    description = string.Format("库存调整类型：{0}。从仓库中移出。", adjType.ToString());
                    this.HandleOneTransfer(ial.LotId.Value, lm.Id, iad.PmaId, ial.WhmId.Value, ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_StockIn), description);
                }
            }

            #endregion

            #region 其他出库

            if (adjType == AdjustType.StockOut)
            {
                //提交后直接扣库存
                if (adjStatus == AdjustStatus.Submit)
                {
                    description = string.Format("库存调整类型：{0}。从仓库中移出。", adjType.ToString());
                    this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, ial.WhmId.Value, ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_StockOut), description);
                };
                //撤销后要还原到库存中
                if (adjStatus == AdjustStatus.Cancelled)
                {
                    description = string.Format("库存调整类型：{0}。移入仓库。", adjType.ToString());
                    this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, ial.WhmId.Value, -ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_StockOut), description);
                }
            }

            #endregion

            #region 退货

            if (adjType == AdjustType.Return || adjType == AdjustType.Exchange)
            {
                //Guid SystemHoldWarehouse;
                //InventoryAdjustHeader iah = new InventoryAdjustHeader();
                //InventoryAdjustHeaderDao iahdao = new InventoryAdjustHeaderDao();
                //iah = iahdao.GetObject(iad.IahId);
                //SystemHoldWarehouse = this.GetSystemHoldWarehouse(iah.DmaId);
                switch (adjStatus)
                {

                    //提交后将库存放到中间库
                    case AdjustStatus.Submitted:
                        description = string.Format("库存调整类型：{0}。从仓库中移出。", adjType.ToString());
                        this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, ial.WhmId.Value, ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Return), description);
                        description = string.Format("库存调整类型：{0}。移入中间库。", adjType.ToString());
                        this.HandleOneTransfer(ial.QrLotId.HasValue ? ial.QrLotId.Value : ial.LotId.Value, Guid.Empty, iad.PmaId, SystemHoldWarehouse, -ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Return), description);
                        break;
                    //审批通过后扣除实际库存，删除中间库存
                    case AdjustStatus.Accept:
                        description = string.Format("库存调整类型：{0}。从中间库移出。", adjType.ToString());
                        this.HandleOneTransfer(ial.QrLotId.HasValue ? ial.QrLotId.Value : ial.LotId.Value, Guid.Empty, iad.PmaId, SystemHoldWarehouse, ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Return), description);
                        if (ToWarehouse.HasValue)
                        {
                            description = string.Format("库存调整类型：{0}。移入仓库。", adjType.ToString());
                            this.HandleOneTransfer(ial.QrLotId.HasValue ? ial.QrLotId.Value : ial.LotId.Value, Guid.Empty, iad.PmaId, ToWarehouse.Value, -ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Return), description);
                        }
                        break;
                    //撤销后要从中间库移回库存
                    case AdjustStatus.Cancelled:
                        description = string.Format("库存调整类型：{0}。从中间库移出。", adjType.ToString());
                        this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, SystemHoldWarehouse, ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Return), description);
                        description = string.Format("库存调整类型：{0}。移回原仓库。", adjType.ToString());
                        this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, ial.WhmId.Value, -ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Return), description);
                        break;
                    //拒绝后从中间库移回库存
                    case AdjustStatus.Reject:
                        description = string.Format("库存调整类型：{0}。从中间库移出。", adjType.ToString());
                        this.HandleOneTransfer(ial.QrLotId.HasValue ? ial.QrLotId.Value : ial.LotId.Value, Guid.Empty, iad.PmaId, SystemHoldWarehouse, ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Return), description);
                        description = string.Format("库存调整类型：{0}。移回原仓库。", adjType.ToString());
                        this.HandleOneTransfer(ial.QrLotId.HasValue ? ial.QrLotId.Value : ial.LotId.Value, Guid.Empty, iad.PmaId, ial.WhmId.Value, -ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Return), description);
                        break;
                    default:
                        break;
                }
            }

            #endregion

            #region 转移给其他经销商

            if (adjType == AdjustType.Transfer)
            {
                //Guid SystemHoldWarehouse;
                //InventoryAdjustHeader iah = new InventoryAdjustHeader();
                //InventoryAdjustHeaderDao iahdao = new InventoryAdjustHeaderDao();
                //iah = iahdao.GetObject(iad.IahId);
                //SystemHoldWarehouse = this.GetSystemHoldWarehouse(iah.DmaId);
                switch (adjStatus)
                {

                    //提交后将库存放到中间库
                    case AdjustStatus.Submitted:
                        description = string.Format("库存调整类型：{0}。从仓库中移出。", adjType.ToString());
                        this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, ial.WhmId.Value, ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Transfer), description);
                        description = string.Format("库存调整类型：{0}。移入中间库。", adjType.ToString());
                        this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, SystemHoldWarehouse, -ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Transfer), description);
                        break;
                    //审批通过后扣除实际库存，删除中间库存
                    case AdjustStatus.Accept:
                        description = string.Format("库存调整类型：{0}。从中间库移出。", adjType.ToString());
                        this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, SystemHoldWarehouse, ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Transfer), description);
                        if (ToWarehouse.HasValue)
                        {
                            description = string.Format("库存调整类型：{0}。移入仓库。", adjType.ToString());
                            this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, ToWarehouse.Value, -ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Transfer), description);
                        }
                        break;
                    //撤销后要从中间库移回库存
                    case AdjustStatus.Cancelled:
                        description = string.Format("库存调整类型：{0}。从中间库移出。", adjType.ToString());
                        this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, SystemHoldWarehouse, ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Transfer), description);
                        description = string.Format("库存调整类型：{0}。移回原仓库。", adjType.ToString());
                        this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, ial.WhmId.Value, -ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Transfer), description);
                        break;
                    //拒绝后从中间库移回库存
                    case AdjustStatus.Reject:
                        description = string.Format("库存调整类型：{0}。从中间库移出。", adjType.ToString());
                        this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, SystemHoldWarehouse, ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Transfer), description);
                        description = string.Format("库存调整类型：{0}。移回原仓库。", adjType.ToString());
                        this.HandleOneTransfer(ial.LotId.Value, Guid.Empty, iad.PmaId, ial.WhmId.Value, -ial.LotQty, ial.Id, (SR.CONST_INV_TRANS_TYPE_Adjust_Transfer), description);
                        break;
                    default:
                        break;
                }
            }

            #endregion
        }

        /// <summary>
        /// 仓库中入/出一定数量的物料
        /// </summary>
        /// <param name="gidLot">批次</param>
        /// <param name="pmaId">产品</param>
        /// <param name="whmId">仓库</param>
        /// <param name="Qty">数量</param>
        /// <param name="RefId">参考</param>
        /// <param name="TransType">库存事项类型</param>
        /// <param name="TransationDescription">库存事项描述</param>
        private void HandleOneTransfer(Guid gidLot, Guid gidLmtId, Guid pmaId, Guid whmId, double Qty, Guid RefId, String TransType, String TransationDescription)
        {
            Inventories invs = new Inventories();
            Inventory inv = new Inventory();
            InventoryTransactions its = new InventoryTransactions();
            InventoryTransaction itr = new InventoryTransaction();
            Guid gidInvId;
            Guid gidItrId;
            Hashtable ht = new Hashtable();
            LotMaster lm = new LotMaster();
            LotMasters lms = new LotMasters();
            Cfns cfn = new Cfns();
            Lot l = new Lot();
            Lots ls = new Lots();

            //仓库中是否有相同的物料

            inv.WhmId = whmId;
            inv.PmaId = pmaId;
            inv.Id = null;
            IList<Inventory> lw = invs.QueryForInventory(inv);
            if (lw.Count == 0)
            {
                gidInvId = Guid.NewGuid();
                inv.Id = gidInvId;
                inv.OnHandQuantity = -Qty;
                invs.Insert(inv);
            }
            else
            {
                ht.Clear();
                gidInvId = lw[0].Id.Value;
                ht.Add("Id", gidInvId.ToString());
                ht.Add("OnHandQuantity", -Qty);
                invs.UpdateInventoryWithQty(ht);
            }

            //库存事项
            gidItrId = Guid.NewGuid();
            itr.Id = gidItrId;
            itr.PmaId = pmaId;
            itr.WhmId = whmId;
            itr.Type = TransType;
            itr.Referenceid = RefId;//此处记录的是调整批次主键
            itr.Quantity = -Qty;
            itr.TransactionDate = DateTime.Now;
            itr.TransDescription = TransationDescription;
            its.Insert(itr);

            //如果gidLmtId为空，表示gidLot是已存在的批次
            if (gidLmtId == Guid.Empty)
            {
                l = ls.GetLot(gidLot);
                gidLmtId = l.LtmId;
            }
            //查询LotMaster信息
            lm = lms.GetLotMaster(gidLmtId);

            ht.Clear();
            ht.Add("InvId", gidInvId);
            ht.Add("LtmId", gidLmtId);
            IList<Lot> ll = ls.SelectLotsByLotMasterAndWarehouse(ht);
            if (ll.Count == 0)
            {
                //移入的仓库没有对应的批次。
                l.Id = Guid.NewGuid();
                l.InvId = gidInvId;
                l.LtmId = gidLmtId;
                l.OnHandQty = -Qty;
                l.WhmId = inv.WhmId;
                l.CfnId = cfn.SelectByPMAID(inv.PmaId.ToString()).Id;
                l.ExpiredDate = lm.ExpiredDate;
                l.LotNumber = lm.Lot;
                l.QRCode = lm.QRCode;
                l.Dom = lm.Type;
                l.CreateDate = DateTime.Now;
                ls.Insert(l);
            }
            else
            {
                //移入仓库已经有对应的批次。
                ht.Clear();
                ht.Add("Id", ll[0].Id);
                ht.Add("OnHandQty", -Qty);
                ht.Add("CreateDate", DateTime.Now);
                ls.UpdateLotWithQty(ht);
            }


            //处理Inventory Transaction Lot
            InventoryTransactionLot ltrl = new InventoryTransactionLot();
            InventoryTransactionLots ltrls = new InventoryTransactionLots();
            ltrl.Id = Guid.NewGuid();
            ltrl.LtmId = lm.Id;
            ltrl.ItrId = gidItrId;
            ltrl.LotNumber = lm.LotNumber;
            ltrl.Quantity = -Qty;
            ltrls.Insert(ltrl);

        }

        #endregion

        #region 保存采购接收库存事项

        /// <summary>
        /// 采购入库的库存事项保存（无Transaction）

        /// </summary>
        /// <param name="prh"></param>
        /// <returns>返回</returns>
        public Hashtable SaveInvRelatedPOReceipt(PoReceipt pr, PoReceiptHeader ph, Guid vendorWhmId)
        {
            Hashtable ht = new Hashtable();
            Hashtable htRtn = new Hashtable();
            Guid gidInvId;
            Guid gidItrId;
            //LP在途库使用
            Guid gidInvId2;
            Guid gidItrId2;

            Inventories invs = new Inventories();
            InventoryTransactions its = new InventoryTransactions();

            Inventory inv = new Inventory();
            InventoryTransaction itr = new InventoryTransaction();

            //inv.WhmId = GetDefaultWarehouse(RoleModelContext.Current.User.CorpId.Value);
            inv.WhmId = ph.WhmId.Value;
            inv.PmaId = pr.SapPmaId;
            inv.Id = null;

            IList<Inventory> lw = invs.QueryForInventory(inv);
            if (lw.Count == 0)
            {
                gidInvId = Guid.NewGuid();
                inv.Id = gidInvId;
                inv.OnHandQuantity = pr.ReceiptQty;
                invs.Insert(inv);
            }
            else
            {
                gidInvId = lw[0].Id.Value;
                ht.Add("Id", gidInvId.ToString());
                ht.Add("OnHandQuantity", pr.ReceiptQty);
                invs.UpdateInventoryWithQty(ht);
            }

            gidItrId = Guid.NewGuid();
            itr.Id = gidItrId;
            itr.PmaId = pr.SapPmaId;
            itr.WhmId = inv.WhmId.Value;
            itr.UnitPrice = pr.UnitPrice.HasValue ? pr.UnitPrice.Value : 0;
            itr.Type = SR.CONST_INV_TRANS_TYPE_POReceipt;
            itr.Referenceid = pr.Id;//此处记录的是收货单行主键
            itr.Quantity = pr.ReceiptQty;
            itr.TransactionDate = DateTime.Now;
            itr.TransDescription = string.Format("接收{0}的第{1}行", ph.PoNumber + "(" + ph.SapShipmentid + ")", pr.LineNbr);
            its.Insert(itr);

            ht.Clear();
            htRtn.Add("InvID", gidInvId);
            htRtn.Add("ItrID", gidItrId);
            htRtn.Add("ProductID", pr.SapPmaId);
            //ht.Add("RelationID", pr.PrhId);
            //end

            if (vendorWhmId != Guid.Empty)
            {
                Inventory inv2 = new Inventory();
                InventoryTransaction itr2 = new InventoryTransaction();

                inv2.WhmId = vendorWhmId;
                inv2.PmaId = pr.SapPmaId;
                inv2.Id = null;

                IList<Inventory> lw2 = invs.QueryForInventory(inv2);
                if (lw2.Count == 0)
                {
                    gidInvId2 = Guid.NewGuid();
                    inv2.Id = gidInvId2;
                    inv2.OnHandQuantity = -pr.ReceiptQty;
                    invs.Insert(inv2);
                }
                else
                {
                    gidInvId2 = lw2[0].Id.Value;
                    ht.Add("Id", gidInvId2.ToString());
                    ht.Add("OnHandQuantity", -pr.ReceiptQty);
                    invs.UpdateInventoryWithQty(ht);
                }

                gidItrId2 = Guid.NewGuid();
                itr2.Id = gidItrId2;
                itr2.PmaId = pr.SapPmaId;
                itr2.WhmId = vendorWhmId;
                itr2.UnitPrice = pr.UnitPrice.HasValue ? pr.UnitPrice.Value : 0;
                itr2.Type = SR.CONST_INV_TRANS_TYPE_POReceipt;
                itr2.Referenceid = pr.Id;//此处记录的是收货单行主键
                itr2.Quantity = -pr.ReceiptQty;
                itr2.TransactionDate = DateTime.Now;
                itr2.TransDescription = string.Format("接收{0}的第{1}行", ph.PoNumber + "(" + ph.SapShipmentid + ")", pr.LineNbr);
                its.Insert(itr2);

                htRtn.Add("InvID2", gidInvId2);
                htRtn.Add("ItrID2", gidItrId2);
            }
            return htRtn;
        }


        /// <summary>
        /// 采购入库的批次事项保存（无Transaction）

        /// </summary>
        /// <param name="ht"></param>
        /// <param name="prl"></param>
        public void SaveLotRelatedPOReceiptLot(Hashtable ht, PoReceiptLot prl)
        {
            Guid gidItrId;
            Guid gidInvId;
            gidItrId = (Guid)ht["ItrID"];
            gidInvId = (Guid)ht["InvID"];

            //仅二级经销商
            Guid gidItrId2 = Guid.Empty;
            Guid gidInvId2 = Guid.Empty;
            if (ht.Contains("ItrID2") && ht.Contains("InvID2"))
            {
                gidItrId2 = (Guid)ht["ItrID2"];
                gidInvId2 = (Guid)ht["InvID2"];
            }
            //Guid RelationID = (Guid)ht["RelationID"];
            Guid ProductID = (Guid)ht["ProductID"];
            //end

            LotMasters lms = new LotMasters();
            //判断LotMaster是否已存在
            LotMaster lm = lms.SelectLotMasterByLotNumber(prl.LotNumber, ProductID);
            if (lm == null)
            {
                lm = new LotMaster();
                lm.Id = Guid.NewGuid();
                lm.LotNumber = prl.LotNumber;
                lm.ExpiredDate = prl.ExpiredDate;
                lm.CreateDate = DateTime.Now;
                lm.ProductPmaId = ProductID;
                lms.Insert(lm);
            }

            //处理Lot
            Lot l = new Lot();
            Lots ls = new Lots();
            Hashtable htForLotSave = new Hashtable();
            htForLotSave.Add("InvId", gidInvId);
            htForLotSave.Add("LtmId", lm.Id);
            IList<Lot> ll = ls.SelectLotsByLotMasterAndWarehouse(htForLotSave);

            if (ll.Count == 0)
            {
                l.Id = Guid.NewGuid();
                l.InvId = gidInvId;
                l.LtmId = lm.Id;
                l.OnHandQty = prl.ReceiptQty;
                ls.Insert(l);
            }
            else
            {
                htForLotSave.Clear();
                htForLotSave.Add("Id", ll[0].Id);
                htForLotSave.Add("OnHandQty", prl.ReceiptQty);
                ls.UpdateLotWithQty(htForLotSave);
            }

            //处理Inventory Transaction Lot
            InventoryTransactionLot ltrl = new InventoryTransactionLot();
            InventoryTransactionLots ltrls = new InventoryTransactionLots();
            ltrl.Id = Guid.NewGuid();
            ltrl.LtmId = lm.Id;
            ltrl.ItrId = gidItrId;
            ltrl.LotNumber = prl.LotNumber;
            ltrl.Quantity = prl.ReceiptQty;
            ltrls.Insert(ltrl);

            if (gidInvId2 != Guid.Empty && gidItrId2 != Guid.Empty)
            {
                //处理Lot
                Lot l2 = new Lot();
                htForLotSave.Clear();
                htForLotSave.Add("InvId", gidInvId2);
                htForLotSave.Add("LtmId", lm.Id);
                IList<Lot> ll2 = ls.SelectLotsByLotMasterAndWarehouse(htForLotSave);

                if (ll2.Count == 0)
                {
                    l2.Id = Guid.NewGuid();
                    l2.InvId = gidInvId2;
                    l2.LtmId = lm.Id;
                    l2.OnHandQty = -prl.ReceiptQty;
                    ls.Insert(l2);
                }
                else
                {
                    htForLotSave.Clear();
                    htForLotSave.Add("Id", ll2[0].Id);
                    htForLotSave.Add("OnHandQty", -prl.ReceiptQty);
                    ls.UpdateLotWithQty(htForLotSave);
                }

                //处理Inventory Transaction Lot
                InventoryTransactionLot ltrl2 = new InventoryTransactionLot();
                ltrl2.Id = Guid.NewGuid();
                ltrl2.LtmId = lm.Id;
                ltrl2.ItrId = gidItrId2;
                ltrl2.LotNumber = prl.LotNumber;
                ltrl2.Quantity = -prl.ReceiptQty;
                ltrls.Insert(ltrl2);
            }

        }

        #endregion

        #region 保存移库的库存事项


        /*移库说明：

         * 借货：提交时从仓库中移到系统保留仓库。未做收货的可以取消,取消时从保留仓库移回原仓库。

         * 收货：接收时从保留仓库移到接受方的缺省仓库。

         */


        /// <summary>
        /// 移库的库存事项保存（无Transaction）

        /// </summary>
        /// <param name="prh"></param>
        /// <returns>返回</returns>
        public Hashtable SaveInvRelatedTransfer(TransferLine trl, Transfer tr, InvTransferType tType)
        {
            Hashtable ht = new Hashtable();
            Hashtable htReturn = new Hashtable();
            Guid gidInvId;
            Guid gidItrId;
            Guid gidSystemHoldWarehouse = Guid.Empty;

            htReturn.Add("TransferType", tType);
            Inventories invs = new Inventories();
            InventoryTransactions its = new InventoryTransactions();

            Inventory inv = new Inventory();
            InventoryTransaction itr = new InventoryTransaction();
            if (tType != InvTransferType.TransferOnly)
            {
                gidSystemHoldWarehouse = this.GetSystemHoldWarehouse(tr.FromDealerDmaId.Value); //使用借出方的系统保留库。
            }

            //移出处理
            switch (tType)
            {
                case InvTransferType.TransferOnly:
                    inv.WhmId = trl.FromWarehouseWhmId;
                    break;
                case InvTransferType.TransferBorrow:
                    inv.WhmId = gidSystemHoldWarehouse;
                    break;
                case InvTransferType.TransferRent:
                    inv.WhmId = trl.FromWarehouseWhmId;
                    break;
                case InvTransferType.TransferCancel:
                    inv.WhmId = gidSystemHoldWarehouse;
                    break;
                case InvTransferType.TransferRentOnly:
                    inv.WhmId = trl.FromWarehouseWhmId;
                    break;
                default:
                    break;
            }
            inv.PmaId = trl.TransferPartPmaId;
            inv.Id = null;

            IList<Inventory> lw = invs.QueryForInventory(inv);
            if (lw.Count == 0)
            {
                gidInvId = Guid.NewGuid();
                inv.Id = gidInvId;
                inv.OnHandQuantity = -trl.TransferQty;
                invs.Insert(inv);
            }
            else
            {
                ht.Clear();
                gidInvId = lw[0].Id.Value;
                ht.Add("Id", gidInvId.ToString());
                ht.Add("OnHandQuantity", -trl.TransferQty);
                invs.UpdateInventoryWithQty(ht);
            }

            gidItrId = Guid.NewGuid();
            itr.Id = gidItrId;
            itr.PmaId = trl.TransferPartPmaId;
            itr.WhmId = inv.WhmId.Value;
            //itr.UnitPrice = trl.UnitPrice;
            itr.Type = SR.CONST_INV_TRANS_TYPE_Transfer;
            itr.Referenceid = trl.Id;
            itr.Quantity = -trl.TransferQty;
            itr.TransactionDate = DateTime.Now;
            itr.TransDescription = string.Format("移库单{0}的第{1}行。移出", tr.TransferNumber, trl.LineNbr);
            its.Insert(itr);
            htReturn.Add("InvID1", gidInvId);
            htReturn.Add("ItrID1", gidItrId);
            //移出处理-----


            if (tType == InvTransferType.TransferRentOnly)
                return htReturn;

            //移入处理
            switch (tType)
            {
                case InvTransferType.TransferOnly:
                    inv.WhmId = trl.ToWarehouseWhmId.Value;
                    break;
                case InvTransferType.TransferBorrow:
                    inv.WhmId = trl.ToWarehouseWhmId.Value;
                    break;
                case InvTransferType.TransferRent:
                    inv.WhmId = gidSystemHoldWarehouse;
                    break;
                case InvTransferType.TransferCancel:
                    inv.WhmId = trl.FromWarehouseWhmId;
                    break;
                default:
                    break;
            }
            inv.PmaId = trl.TransferPartPmaId;
            inv.Id = null;

            lw.Clear();
            lw = invs.QueryForInventory(inv);  //移入的仓库是否有同样的物料

            if (lw.Count == 0)
            {
                //如果没有则新建一条记录

                gidInvId = Guid.NewGuid();
                inv.Id = gidInvId;
                inv.OnHandQuantity = trl.TransferQty;
                invs.Insert(inv);
            }
            else
            {
                //如果有则在其上增加数量

                ht.Clear();
                gidInvId = lw[0].Id.Value;
                ht.Add("Id", gidInvId.ToString());
                ht.Add("OnHandQuantity", trl.TransferQty);
                invs.UpdateInventoryWithQty(ht);
            }

            gidItrId = Guid.NewGuid();
            itr.Id = gidItrId;
            itr.PmaId = trl.TransferPartPmaId;
            itr.WhmId = inv.WhmId.Value;
            //itr.UnitPrice = trl.UnitPrice;
            itr.Type = SR.CONST_INV_TRANS_TYPE_Transfer;
            itr.Referenceid = trl.Id;
            itr.TransactionDate = DateTime.Now;
            itr.Quantity = trl.TransferQty;
            itr.TransDescription = string.Format("移库单{0}的第{1}行。移入", tr.TransferNumber, trl.LineNbr);
            its.Insert(itr);
            htReturn.Add("InvID2", gidInvId);
            htReturn.Add("ItrID2", gidItrId);
            //移入处理-----
            return htReturn;
        }


        /// <summary>
        /// 移库的批次事项保存（无Transaction）

        /// </summary>
        /// <param name="ht"></param>
        /// <param name="prl"></param>
        public void SaveLotRelatedTransfer(Hashtable ht, TransferLine trl, TransferLot tll)
        {
            Guid gidItrId;
            Guid gidInvId;
            InvTransferType tType;
            tType = (InvTransferType)ht["TransferType"];
            Hashtable htForLotSave = new Hashtable();
            LotMasters lms = new LotMasters();
            Lot l = new Lot();
            Lots ls = new Lots();
            Inventory inv = new Inventory();
            Cfns cfn = new Cfns();
            if (tType == InvTransferType.TransferBorrow)
            {
                l = ls.GetLot(tll.QrlotId.HasValue ? tll.QrlotId.Value : tll.LotId);
            }
            else
            {
                l = ls.GetLot(tll.LotId);
            }
            Guid lotMasterRecID = l.LtmId;
            string lotNumber = lms.GetLotMaster(lotMasterRecID).LotNumber;

            double transferLotQuantity;
            transferLotQuantity = tll.TransferLotQty;

            //移出的批次


            gidItrId = (Guid)ht["ItrID1"];
            gidInvId = (Guid)ht["InvID1"];

            //处理Lot
            htForLotSave.Clear();
            htForLotSave.Add("InvId", gidInvId);
            htForLotSave.Add("LtmId", lotMasterRecID);
            IList<Lot> ll = ls.SelectLotsByLotMasterAndWarehouse(htForLotSave);

            if (ll.Count == 0)
            {
                //移出的仓库没有对应的批次。

                l.Id = Guid.NewGuid();
                l.InvId = gidInvId;
                l.LtmId = lotMasterRecID;
                l.OnHandQty = -transferLotQuantity;
                l.CreateDate = DateTime.Now;
                l.WhmId = trl.ToWarehouseWhmId;
                l.CfnId = cfn.SelectByPMAID(trl.TransferPartPmaId.ToString()).Id;
                l.QRCode = tll.LTMQRCode;
                l.LotNumber = tll.LTMLot;
                l.Dom = tll.DOM;
                l.ExpiredDate = tll.ExpiredDate;
                ls.Insert(l);
            }
            else
            {
                //移出仓库已经有对应的批次。

                htForLotSave.Clear();
                gidInvId = ll[0].Id;
                htForLotSave.Add("Id", gidInvId.ToString());
                htForLotSave.Add("OnHandQty", -transferLotQuantity);
                htForLotSave.Add("CreateDate", DateTime.Now);
                ls.UpdateLotWithQty(htForLotSave);
            }

            //处理Inventory Transaction Lot
            InventoryTransactionLot ltrl = new InventoryTransactionLot();
            InventoryTransactionLots ltrls = new InventoryTransactionLots();
            ltrl.Id = Guid.NewGuid();
            ltrl.LtmId = lotMasterRecID;
            ltrl.ItrId = gidItrId;
            ltrl.LotNumber = lotNumber;
            ltrl.Quantity = -transferLotQuantity;
            ltrls.Insert(ltrl);

            if (tType == InvTransferType.TransferRentOnly)
                return;

            //移入的批次
            l = ls.GetLot(tll.QrlotId == null ? tll.LotId : tll.QrlotId.Value);
            lotMasterRecID = l.LtmId;


            gidItrId = (Guid)ht["ItrID2"];
            gidInvId = (Guid)ht["InvID2"];

            htForLotSave.Clear();
            htForLotSave.Add("InvId", gidInvId);
            htForLotSave.Add("LtmId", lotMasterRecID);
            ll = ls.SelectLotsByLotMasterAndWarehouse(htForLotSave);
            if (ll.Count == 0)
            {
                //移入的仓库没有对应的批次。

                l.Id = Guid.NewGuid();
                l.InvId = gidInvId;
                l.LtmId = lotMasterRecID;
                l.OnHandQty = transferLotQuantity;
                l.CreateDate = DateTime.Now;
                l.WhmId = trl.ToWarehouseWhmId;
                l.CfnId = cfn.SelectByPMAID(trl.TransferPartPmaId.ToString()).Id;
                l.QRCode = tll.LTMQRCode;
                l.LotNumber = tll.LTMLot;
                l.ExpiredDate = tll.ExpiredDate;
                l.Dom = tll.DOM;
                l.CreateDate = DateTime.Now;
                ls.Insert(l);
            }
            else
            {
                //移入仓库已经有对应的批次。

                htForLotSave.Clear();
                gidInvId = ll[0].Id;
                htForLotSave.Add("Id", gidInvId.ToString());
                htForLotSave.Add("OnHandQty", transferLotQuantity);
                htForLotSave.Add("CreateDate", DateTime.Now);
                ls.UpdateLotWithQty(htForLotSave);
            }

            //处理Inventory Transaction Lot
            ltrl = new InventoryTransactionLot();
            ltrls = new InventoryTransactionLots();
            ltrl.Id = Guid.NewGuid();
            ltrl.LtmId = lotMasterRecID;
            ltrl.ItrId = gidItrId;
            ltrl.LotNumber = lotNumber;
            ltrl.Quantity = transferLotQuantity;
            ltrls.Insert(ltrl);
        }

        #endregion

        #region 库存盘点调整
        public void SaveInvRelatedStocktaking(StocktakingHeader sheader, StocktakingLine sline, StocktakingLot slot)
        {
            Inventories invBLL = new Inventories();
            LotMasters ltmBLL = new LotMasters();
            Lots lotBLL = new Lots();
            InventoryTransactions invTransBLL = new InventoryTransactions();
            InventoryTransactionLots lotTransBLL = new InventoryTransactionLots();

            Inventory inv = new Inventory();
            Lot lot = null;
            LotMaster ltm = null;
            InventoryTransaction invTrans = new InventoryTransaction();
            InventoryTransactionLot lotTrans = new InventoryTransactionLot();

            //根据仓库和物料判断库存记录是否存在
            inv.WhmId = sheader.WarehouseWhmId.Value;
            inv.PmaId = sline.PmaId;
            inv.Id = null;
            IList<Inventory> invList = invBLL.QueryForInventory(inv);
            if (invList == null || invList.Count == 0)
            {
                inv.Id = Guid.NewGuid();
                inv.OnHandQuantity = slot.CheckQty.Value;
                invBLL.Insert(inv);
            }
            else
            {
                inv = invList[0];
                inv.OnHandQuantity += slot.CheckQty.Value;
                invBLL.Update(inv);
            }
            //记录库存调整日志
            invTrans.Id = Guid.NewGuid();
            invTrans.PmaId = sline.PmaId;
            invTrans.WhmId = sheader.WarehouseWhmId.Value;
            invTrans.Type = SR.CONST_INV_TRANS_TYPE_Stocktaking;
            invTrans.Referenceid = sline.Id;
            invTrans.Quantity = slot.CheckQty.Value;
            invTrans.TransactionDate = DateTime.Now;
            invTrans.TransDescription = string.Format("库存盘点单：{0} 行：{1}", sheader.StocktakingNo, sline.LineNbr.ToString());
            invTransBLL.Insert(invTrans);

            //判断LotMaster是否已存在
            ltm = ltmBLL.SelectLotMasterByLotNumber(slot.LotNumber, sline.PmaId);
            if (ltm == null)
            {
                ltm.Id = Guid.NewGuid();
                ltm.LotNumber = slot.LotNumber;
                ltm.ExpiredDate = slot.ExpiredDate;
                ltm.CreateDate = DateTime.Now;
                ltm.ProductPmaId = sline.PmaId;
                ltmBLL.Insert(ltm);
            }

            Hashtable htForLotSave = new Hashtable();
            htForLotSave.Add("InvId", inv.Id.Value);
            htForLotSave.Add("LtmId", ltm.Id);

            IList<Lot> lotList = lotBLL.SelectLotsByLotMasterAndWarehouse(htForLotSave);

            if (lotList.Count == 0)
            {
                lot.Id = Guid.NewGuid();
                lot.InvId = inv.Id.Value;
                lot.LtmId = ltm.Id;
                lot.OnHandQty = slot.CheckQty.Value;
                lotBLL.Insert(lot);
            }
            else
            {
                htForLotSave.Clear();
                htForLotSave.Add("Id", lotList[0].Id);
                htForLotSave.Add("OnHandQty", slot.CheckQty.Value);
                lotBLL.UpdateLotWithQty(htForLotSave);
            }

            //记录批次调整日志
            lotTrans.Id = Guid.NewGuid();
            lotTrans.ItrId = invTrans.Id;
            lotTrans.LtmId = lot.LtmId;
            lotTrans.LotNumber = ltm.LotNumber;
            lotTrans.Quantity = slot.CheckQty.Value;
            lotTransBLL.Insert(lotTrans);
        }
        #endregion
        #endregion 方法

        #region qrcode

        public void AddLotMasterAndLotByQrEdit(InventoryAdjustDetail iad, InventoryAdjustLot ial, Guid SystemWarehouse)
        {
            LotMasters ltmBLL = new LotMasters();
            Inventories invBLL = new Inventories();
            Inventory inv = new Inventory();
            LotMaster lm = null;
            Lot l = null;
            Cfns cfn = new Cfns();
            Lots lotBLL = new Lots();
            InventoryAdjustLotDao lotDao = new InventoryAdjustLotDao();
            if (!string.IsNullOrEmpty(ial.QrLotNumber))
            {
                lm = ltmBLL.SelectLotMasterByLotNumber(ial.QrLotNumber, iad.PmaId);
                if (lm == null)
                {
                    LotMasters lms = new LotMasters();
                    //获取产品生产日期 lijie add 2016-04-08
                    string Lot = ial.LtmLot;
                    LotMaster Ltm = null;
                    Ltm = lms.SelectLotMasterByLotNumberPMAId(Lot, iad.PmaId);
                    lm = new LotMaster();
                    lm.Id = Guid.NewGuid();
                    lm.LotNumber = ial.QrLotNumber;
                    lm.ExpiredDate = ial.ExpiredDate;
                    lm.CreateDate = DateTime.Now;
                    lm.ProductPmaId = iad.PmaId;
                    lm.Lot = ial.LtmLot;
                    lm.QRCode = ial.LotQRCode;
                    if (ltmBLL != null)
                    {
                        lm.Type = Ltm.Type;
                    }
                    ltmBLL.Insert(lm);
                }
                inv.WhmId = SystemWarehouse;
                inv.PmaId = iad.PmaId;
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

                if (lotList.Count == 0)
                {
                    l = new Lot();
                    l.Id = Guid.NewGuid();
                    l.InvId = inv.Id.Value;
                    l.LtmId = lm.Id;
                    l.OnHandQty = 0;
                    l.Dom = lm.Type;
                    l.QRCode = ial.LotQRCode;
                    l.LotNumber = ial.LtmLot;
                    l.ExpiredDate = ial.ExpiredDate;
                    l.CreateDate = DateTime.Now;
                    l.CfnId = cfn.SelectByPMAID(inv.PmaId.ToString()).Id;
                    l.WhmId = ial.WhmId;
                    lotBLL.Insert(l);

                    ial.QrLotId = l.Id;
                    lotDao.Update(ial);
                }
                else
                {
                    ial.QrLotId = lotList[0].Id;
                    lotDao.Update(ial);
                }
            }


        }
        #endregion

    }

    #region RUID

    #region Inventory
    public class Inventories : IInventories
    {

        public Inventories()
        {
        }

        public IList<Inventory> QueryForInventory(Inventory inventory)
        {
            using (InventoryDao dao = new InventoryDao())
            {
                return dao.SelectByFilter(inventory);
            }
        }

        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="inventory"></param>
        /// <returns></returns>
        public bool Insert(Inventory inventory)
        {
            bool result = false;
            using (InventoryDao dao = new InventoryDao())
            {
                dao.Insert(inventory);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="inventory"></param>
        /// <returns></returns>
        public bool Update(Inventory inventory)
        {
            bool result = false;
            using (InventoryDao dao = new InventoryDao())
            {
                int afterRow = dao.Update(inventory);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改库存数量
        /// </summary>
        /// <param name="inventory"></param>
        /// <returns></returns>
        public bool UpdateInventoryWithQty(Hashtable ht)
        {
            bool result = false;
            using (InventoryDao dao = new InventoryDao())
            {
                int afterRow = dao.UpdateInventoryWithQty(ht);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        public bool Delete(Inventory inventory)
        {
            bool result = false;

            using (InventoryDao dao = new InventoryDao())
            {
                int afterRow = dao.Delete(inventory);
            }
            return result;
        }
        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中 Todo
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool SaveChanges(ChangeRecords<Inventory> data)
        {
            bool result = false;


            using (TransactionScope trans = new TransactionScope())
            {

                foreach (Inventory inventory in data.Updated)
                {
                    this.Update(inventory);
                }

                foreach (Inventory inventory in data.Created)
                {
                    this.Insert(inventory);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }
    }

    #endregion

    #region Lot
    public class Lots : ILots
    {

        public Lots()
        {
        }

        /// <summary>
        /// 通过批次号和仓库选择批次记录
        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public IList<Lot> SelectLotsByLotMasterAndWarehouse(Hashtable ht)
        {
            using (LotDao dao = new LotDao())
            {
                return dao.SelectLotsByLotMasterAndWarehouse(ht);
            }
        }

        public IList<Lot> SelectByFilter(Lot lot)
        {
            using (LotDao dao = new LotDao())
            {
                return dao.SelectByFilter(lot);
            }
        }

        /// <summary>
        /// 通过记录号获得现有库存中的批次

        /// </summary>
        /// <param name="Id"></param>
        /// <returns>批次记录</returns>
        public Lot GetLot(Guid Id)
        {
            using (LotDao dao = new LotDao())
            {
                return dao.GetObject(Id);
            }
        }


        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="lot"></param>
        /// <returns></returns>
        public bool Insert(Lot lot)
        {
            bool result = false;
            using (LotDao dao = new LotDao())
            {
                dao.Insert(lot);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="lot"></param>
        /// <returns></returns>
        public bool Update(Lot lot)
        {
            bool result = false;
            using (LotDao dao = new LotDao())
            {
                int afterRow = dao.Update(lot);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改库存批次的数量

        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public bool UpdateLotWithLotMasterWarehouseAndQty(Hashtable ht)
        {
            bool result = false;
            using (LotDao dao = new LotDao())
            {
                int afterRow = dao.UpdateLotWithLotMasterWarehouseAndQty(ht);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改库存数量
        /// </summary>
        /// <param name="ht"></param>
        /// <returns></returns>
        public bool UpdateLotWithQty(Hashtable ht)
        {
            bool result = false;
            using (LotDao dao = new LotDao())
            {
                int afterRow = dao.UpdateLotWithQty(ht);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="hospitalId"></param>
        /// <returns></returns>
        public bool Delete(Lot lot)
        {
            bool result = false;

            using (LotDao dao = new LotDao())
            {
                int afterRow = dao.Delete(lot);
            }
            return result;
        }
        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中 Todo
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool SaveChanges(ChangeRecords<Lot> data)
        {
            bool result = false;


            using (TransactionScope trans = new TransactionScope())
            {

                foreach (Lot lot in data.Updated)
                {
                    this.Update(lot);
                }

                foreach (Lot lot in data.Created)
                {
                    this.Insert(lot);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }
    }

    #endregion

    #region Transaction
    public class InventoryTransactions : IInventoryTransactions
    {

        public InventoryTransactions()
        {
        }


        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="transaction"></param>
        /// <returns></returns>
        public bool Insert(InventoryTransaction transaction)
        {
            bool result = false;
            using (InventoryTransactionDao dao = new InventoryTransactionDao())
            {
                dao.Insert(transaction);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="transaction"></param>
        /// <returns></returns>
        public bool Update(InventoryTransaction transaction)
        {
            bool result = false;
            using (InventoryTransactionDao dao = new InventoryTransactionDao())
            {
                int afterRow = dao.Update(transaction);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="transaction"></param>
        /// <returns></returns>
        public bool Delete(InventoryTransaction transaction)
        {
            bool result = false;

            using (InventoryTransactionDao dao = new InventoryTransactionDao())
            {
                int afterRow = dao.Delete(transaction);
            }
            return result;
        }
        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中 Todo
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool SaveChanges(ChangeRecords<InventoryTransaction> data)
        {
            bool result = false;


            using (TransactionScope trans = new TransactionScope())
            {

                foreach (InventoryTransaction transaction in data.Updated)
                {
                    this.Update(transaction);
                }

                foreach (InventoryTransaction transaction in data.Created)
                {
                    this.Insert(transaction);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }
    }

    #endregion

    #region TransactionLot
    public class InventoryTransactionLots : IInventoryTransactionLots
    {

        public InventoryTransactionLots()
        {
        }


        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="transaction"></param>
        /// <returns></returns>
        public bool Insert(InventoryTransactionLot transactionLot)
        {
            bool result = false;
            using (InventoryTransactionLotDao dao = new InventoryTransactionLotDao())
            {
                dao.Insert(transactionLot);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="transaction"></param>
        /// <returns></returns>
        public bool Update(InventoryTransactionLot transactionLot)
        {
            bool result = false;
            using (InventoryTransactionLotDao dao = new InventoryTransactionLotDao())
            {
                int afterRow = dao.Update(transactionLot);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="transaction"></param>
        /// <returns></returns>
        public bool Delete(InventoryTransactionLot transactionLot)
        {
            bool result = false;

            using (InventoryTransactionLotDao dao = new InventoryTransactionLotDao())
            {
                int afterRow = dao.Delete(transactionLot);
            }
            return result;
        }
        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中 Todo
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool SaveChanges(ChangeRecords<InventoryTransactionLot> data)
        {
            bool result = false;


            using (TransactionScope trans = new TransactionScope())
            {

                foreach (InventoryTransactionLot transactionLot in data.Updated)
                {
                    this.Update(transactionLot);
                }

                foreach (InventoryTransactionLot transactionLot in data.Created)
                {
                    this.Insert(transactionLot);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }
    }

    #endregion

    #region LotMaster
    public class LotMasters : ILotMasters
    {

        public LotMasters()
        {
        }

        /// <summary>
        /// 用Hashtable做条件获得批次信息

        /// </summary>
        /// <param name="hashtable"></param>
        /// <returns></returns>
        //public IList<LotMaster> GetLotMasterByHashtable(System.Collections.Hashtable hashtable)
        //{
        //    using (LotMasterDao dao = new LotMasterDao())
        //    {
        //        return dao.GetLotMasterByHashtable(hashtable);
        //    }

        //}
        /// <summary>
        /// 用记录号获得lot信息
        /// </summary>
        /// <param name="LotMasterRecId"></param>
        /// <returns></returns>
        public LotMaster GetLotMaster(Guid LotMasterRecId)
        {
            using (LotMasterDao dao = new LotMasterDao())
            {
                return dao.GetObject(LotMasterRecId);
            }
        }


        public IList<LotMaster> QueryForWarehouse(LotMaster lotMaster)
        {
            using (LotMasterDao dao = new LotMasterDao())
            {
                return dao.SelectByFilter(lotMaster);
            }
        }

        public LotMaster SelectLotMasterByLotNumber(string lotNumber, Guid productId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("LotNumber", lotNumber);
            ht.Add("PmaId", productId);
            using (LotMasterDao dao = new LotMasterDao())
            {
                IList<LotMaster> list = dao.SelectLotMasterByLotNumber(ht);
                if (list == null || list.Count == 0)
                    return null;
                return list[0];
            }
        }

        public LotMaster SelectLotMasterByLotNumberCFN(string lotNumber, string cfn)
        {
            Hashtable ht = new Hashtable();
            ht.Add("LotNumber", lotNumber);
            ht.Add("CFN", cfn);
            using (LotMasterDao dao = new LotMasterDao())
            {
                IList<LotMaster> list = dao.SelectLotMasterByLotNumberCFN(ht);
                if (list == null || list.Count == 0)
                    return null;
                return list[0];
            }
        }

        public LotMaster SelectLotMasterByLotNumberCFNQrCode(string lotNumber, string cfn)
        {
            Hashtable ht = new Hashtable();
            ht.Add("LotNumber", lotNumber);
            ht.Add("CFN", cfn);
            using (LotMasterDao dao = new LotMasterDao())
            {
                IList<LotMaster> list = dao.SelectLotMasterByLotNumberCFNQuCode(ht);
                if (list == null || list.Count == 0)
                    return null;
                return list[0];
            }
        }
        //lijie add 2016_04_05
        public LotMaster SelectLotMasterByLotNumberPMAId(string LotNumber, Guid PmaId)
        {
            Hashtable ht = new Hashtable();
            ht.Add("LotNumber", LotNumber);
            ht.Add("PmaId", PmaId);
            using (LotMasterDao dao = new LotMasterDao())
            {
                IList<LotMaster> list = dao.SelectLotMasterByLotNumberPMAId(ht);
                if (list == null || list.Count == 0)
                    return null;
                return list[0];
            }
        }
        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="lotMaster"></param>
        /// <returns></returns>
        public bool Insert(LotMaster lotMaster)
        {
            bool result = false;
            using (LotMasterDao dao = new LotMasterDao())
            {
                dao.Insert(lotMaster);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 修改
        /// </summary>
        /// <param name="lotMaster"></param>
        /// <returns></returns>
        public bool Update(LotMaster lotMaster)
        {
            bool result = false;
            using (LotMasterDao dao = new LotMasterDao())
            {
                int afterRow = dao.Update(lotMaster);
                result = true;
            }
            return result;
        }

        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="lotMaster"></param>
        /// <returns></returns>
        public bool Delete(LotMaster lotMaster)
        {
            bool result = false;

            using (LotMasterDao dao = new LotMasterDao())
            {
                int afterRow = dao.Delete(lotMaster);
            }
            return result;
        }
        /// <summary>
        /// SaveChanges, 把所有改变保存到数据库中 Todo
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public bool SaveChanges(ChangeRecords<LotMaster> data)
        {
            bool result = false;


            using (TransactionScope trans = new TransactionScope())
            {

                foreach (LotMaster warehouse in data.Updated)
                {
                    this.Update(warehouse);
                }

                foreach (LotMaster warehouse in data.Created)
                {
                    this.Insert(warehouse);
                }

                trans.Complete();

                result = true;
            }

            return result;
        }

        /// <summary>
        /// 同步LotMaster接口,获取最新更新的LotMaster
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public DataSet P_GetLotMaster(string currentdate)
        {
            using (LotMasterDao dao = new LotMasterDao())
            {
                return dao.P_GetLotMaster(currentdate);
            }
        }

    }
    #endregion

    #endregion RUID


}

