using DMS.Common.Common;
using DMS.DataAccess.Lafite;
using DMS.ViewModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using DMS.Common.Extention;
using DMS.Common;
using DMS.Model.Data;
using DMS.Business;
using Lafite.RoleModel.Provider;
using Lafite.RoleModel.Security;
using System.Web.Security;
using DMS.DataAccess.HCPPassport;
using DMS.DataAccess.Platform;
using DMS.DataAccess;
using DMS.DataAccess.Interface;
using DMS.Model;
using DMS.ViewModel.Common;
using DMS.DataAccess.MasterPage;
using DMS.ViewModel.Dashboard;

namespace DMS.BusinessService.Dashboard
{
    public class AdminPageService : ABaseService
    {
        #region Ajax Method

        public AdminPageVO Init(AdminPageVO model)
        {
            try
            {
                SystemManualDao systemManualDao = new SystemManualDao();
                BulletinMainDao bulletinMainDao = new BulletinMainDao();
                HomeDao homeDao = new HomeDao();
                DealerqaDao dealerqaDao = new DealerqaDao();

                //待处理&汇总信息
                Hashtable condition = new Hashtable();
                condition.Add("DealerId", base.UserInfo.CorpId);
                condition.Add("OwnerId", base.UserInfo.Id.ToSafeGuid());
                IList<WaitProcessTask> todoList = dealerqaDao.QueryWaitForProcessByDealer(condition);

                WaitProcessTask POReceiptHeader = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.POReceiptHeader.ToString()).First();
                WaitProcessTask DealerQA = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.DealerQA.ToString()).First();
                WaitProcessTask UploadInventory = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.UploadInventory.ToString()).First();
                WaitProcessTask UploadLog = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.UploadLog.ToString()).First();
                WaitProcessTask ShipmentHeader = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.ShipmentHeader.ToString()).First();
                WaitProcessTask OrderQT = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.OrderQT.ToString()).First();
                WaitProcessTask ShipmentQT = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.ShipmentQT.ToString()).First();
                WaitProcessTask ShipmentReversedQT = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.ShipmentReversedQT.ToString()).First();
                WaitProcessTask ShipmentICQT = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.ShipmentICQT.ToString()).First();
                WaitProcessTask TransferQT = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.TransferQT.ToString()).First();
                WaitProcessTask InventoryAdjustQT = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.InventoryAdjustQT.ToString()).First();

                WaitProcessTask NormalInventory = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.NormalInventory.ToString()).First();
                WaitProcessTask ConsignmentInventory = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.ConsignmentInventory.ToString()).First();
                WaitProcessTask BorrowInventory = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.BorrowInventory.ToString()).First();
                WaitProcessTask SystemHoldInventory = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.SystemHoldInventory.ToString()).First();
                WaitProcessTask HasOrderStrategy = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.HasOrderStrategy.ToString()).First();
                WaitProcessTask UploadSalesForecast = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.UploadSalesForecast.ToString()).First();

                WaitProcessTask UploadInvoice = todoList.Where<WaitProcessTask>(p => p.ModelID == WaitProcess.UploadInvoice.ToString()).First();

                //待处理
                model.RstTodo = new List<KeyValue>();
                //待收货
                if (POReceiptHeader.RecordCount.ToSafeInt() != 0)
                {
                    model.RstTodo.Add(new KeyValue("POReceipt", String.Format("待收货({0})", POReceiptHeader.RecordCount.ToSafeInt().ToIntString())));
                }
                //待填写销售预测数据
                if (UploadSalesForecast.RecordCount.ToSafeInt() != 0)
                {
                    model.RstTodo.Add(new KeyValue("SalesForecast", String.Format("待填写销售预测数据({0})", UploadSalesForecast.RecordCount.ToSafeInt().ToIntString())));
                }
                //待上传发票
                if (UploadInvoice.RecordCount.ToSafeInt() != 0)
                {
                    model.RstTodo.Add(new KeyValue("Invoice", String.Format("待上传发票({0})", UploadInvoice.RecordCount.ToSafeInt().ToIntString())));
                }
                //需要上传库存数据
                if (UploadInventory.RecordCount.ToSafeInt() == 0)
                {
                    model.RstTodo.Add(new KeyValue("Inventory", "需要上传库存数据"));
                }
                //需要填写销售数据
                if (UploadLog.RecordCount.ToSafeInt() == 0 && ShipmentHeader.RecordCount.ToSafeInt() == 0)
                {
                    model.RstTodo.Add(new KeyValue("Shipment", "需要填写销售数据"));
                }
                //问题未回复
                if (DealerQA.RecordCount.ToSafeInt() != 0)
                {
                    model.RstTodo.Add(new KeyValue("DealerQA", String.Format("问题未回复({0})", DealerQA.RecordCount.ToSafeInt().ToIntString())));
                }

                //汇总信息
                model.RstSummary = new List<KeyValue>();
                //本月已采购总数量
                //先判断登录人员是否具有订单管理菜单的权限
                if (HasOrderStrategy.ItemQty.ToSafeInt() > 0)
                {
                    model.RstSummary.Add(new KeyValue("OrderQT", String.Format("本月已采购总数量：{0}<br />总金额：{1}", OrderQT.ItemQty.ToSafeInt().ToIntString(), OrderQT.TotalAmount.ToSafeDecimal().ToDecimalString())));
                }
                //本月累计销售（销售单：数量、金额）
                model.RstSummary.Add(new KeyValue("ShipmentQT", String.Format("本月累计销售总数量：{0}<br />总金额：{1}", ShipmentQT.ItemQty.ToSafeInt().ToIntString(), ShipmentQT.TotalAmount.ToSafeDecimal().ToDecimalString())));
                //本月累计冲红（冲红销售单：数量、金额）
                model.RstSummary.Add(new KeyValue("ShipmentReversedQT", String.Format("本月累计冲红总数量：{0}<br />总金额：{1}", ShipmentReversedQT.ItemQty.ToSafeInt().ToIntString(), ShipmentReversedQT.TotalAmount.ToSafeDecimal().ToDecimalString())));
                //本月累计借货出库（借货出库单：数量）
                model.RstSummary.Add(new KeyValue("TransferQT", String.Format("本月累计借货出库总数量：{0}<br />总金额：{1}", TransferQT.ItemQty.ToSafeInt().ToIntString(), TransferQT.TotalAmount.ToSafeDecimal().ToDecimalString())));
                //本月累计退货（审批通过的退货单：数量）
                model.RstSummary.Add(new KeyValue("InventoryAdjustQT", String.Format("本月累计退货总数量：{0}<br />总金额：{1}", InventoryAdjustQT.ItemQty.ToSafeInt().ToIntString(), InventoryAdjustQT.TotalAmount.ToSafeDecimal().ToDecimalString())));
                //当前经销商普通库库存数（包括缺省仓库）
                model.RstSummary.Add(new KeyValue("NormalInventory", String.Format("当前经销商普通库库存数(包括缺省仓库)：{0}", NormalInventory.ItemQty.ToSafeInt().ToIntString())));
                //当前经销商寄售库库存数
                model.RstSummary.Add(new KeyValue("ConsignmentInventory", String.Format("当前经销商寄售库库存数：{0}", ConsignmentInventory.ItemQty.ToSafeInt().ToIntString())));
                //当前经销商借货库库存数
                model.RstSummary.Add(new KeyValue("BorrowInventory", String.Format("当前经销商借货库库存数：{0}", BorrowInventory.ItemQty.ToSafeInt().ToIntString())));
                //当前经销商在途库库存数
                model.RstSummary.Add(new KeyValue("SystemHoldInventory", String.Format("当前经销商在途库库存数：{0}", SystemHoldInventory.ItemQty.ToSafeInt().ToIntString())));

                //DMS教程
                Hashtable ht = new Hashtable();
                ht.Add("Type", "Dealer");
                model.RstManual = systemManualDao.SelectListByType(ht);

                //公告
                model.RstNotice = bulletinMainDao.SelectListForDashboard(base.IsDealer, base.UserInfo.CorpId);

                model.LstYear = homeDao.SelectYearList();
                model.IptYear = new KeyValue(model.LstYear.Count > 0 ? model.LstYear[0].GetSafeStringValue("YearCode") : "");

                DataSet result = homeDao.SelectAdminPageSumInfo(model.IptYear.Key);

                this.SetRst(result, model);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public AdminPageVO RefreshNotice(AdminPageVO model)
        {
            try
            {
                BulletinMainDao bulletinMainDao = new BulletinMainDao();

                model.RstNotice = bulletinMainDao.SelectListForDashboard(base.IsDealer, base.UserInfo.CorpId);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public AdminPageVO Refresh(AdminPageVO model)
        {
            try
            {
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        
        public AdminPageVO ChangeYear(AdminPageVO model)
        {
            try
            {
                HomeDao homeDao = new HomeDao();

                if (!model.IptYear.Key.IsNullOrEmpty())
                {
                    DataSet result = homeDao.SelectAdminPageSumInfo(model.IptYear.Key);

                    this.SetRst(result, model);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public AdminPageVO SetRst(DataSet result,AdminPageVO model)
        {
            //报表             
            if (result != null)
            {
                DataTable Order = result.Tables[0];
                if (Order.Rows.Count > 0)
                {
                    model.RstOrder.Add("Month1", Order.Rows[0].GetSafeIntValue("Summary"));
                    model.RstOrder.Add("Month2", Order.Rows[1].GetSafeIntValue("Summary"));
                    model.RstOrder.Add("Month3", Order.Rows[2].GetSafeIntValue("Summary"));
                    model.RstOrder.Add("Month4", Order.Rows[3].GetSafeIntValue("Summary"));
                    model.RstOrder.Add("Month5", Order.Rows[4].GetSafeIntValue("Summary"));
                    model.RstOrder.Add("Month6", Order.Rows[5].GetSafeIntValue("Summary"));
                    model.RstOrder.Add("Month7", Order.Rows[6].GetSafeIntValue("Summary"));
                    model.RstOrder.Add("Month8", Order.Rows[7].GetSafeIntValue("Summary"));
                    model.RstOrder.Add("Month9", Order.Rows[8].GetSafeIntValue("Summary"));
                    model.RstOrder.Add("Month10", Order.Rows[9].GetSafeIntValue("Summary"));
                    model.RstOrder.Add("Month11", Order.Rows[10].GetSafeIntValue("Summary"));
                    model.RstOrder.Add("Month12", Order.Rows[11].GetSafeIntValue("Summary"));
                }
                DataTable OrderProduct = result.Tables[1];
                if (OrderProduct.Rows.Count > 0)
                {
                    model.RstOrderProduct.Add("Month1", OrderProduct.Rows[0].GetSafeDecimalValue("Summary"));
                    model.RstOrderProduct.Add("Month2", OrderProduct.Rows[1].GetSafeDecimalValue("Summary"));
                    model.RstOrderProduct.Add("Month3", OrderProduct.Rows[2].GetSafeDecimalValue("Summary"));
                    model.RstOrderProduct.Add("Month4", OrderProduct.Rows[3].GetSafeDecimalValue("Summary"));
                    model.RstOrderProduct.Add("Month5", OrderProduct.Rows[4].GetSafeDecimalValue("Summary"));
                    model.RstOrderProduct.Add("Month6", OrderProduct.Rows[5].GetSafeDecimalValue("Summary"));
                    model.RstOrderProduct.Add("Month7", OrderProduct.Rows[6].GetSafeDecimalValue("Summary"));
                    model.RstOrderProduct.Add("Month8", OrderProduct.Rows[7].GetSafeDecimalValue("Summary"));
                    model.RstOrderProduct.Add("Month9", OrderProduct.Rows[8].GetSafeDecimalValue("Summary"));
                    model.RstOrderProduct.Add("Month10", OrderProduct.Rows[9].GetSafeDecimalValue("Summary"));
                    model.RstOrderProduct.Add("Month11", OrderProduct.Rows[10].GetSafeDecimalValue("Summary"));
                    model.RstOrderProduct.Add("Month12", OrderProduct.Rows[11].GetSafeDecimalValue("Summary"));
                }
                DataTable Shipment = result.Tables[2];
                if (Shipment.Rows.Count > 0)
                {
                    model.RstShipment.Add("Month1", Shipment.Rows[0].GetSafeIntValue("Summary"));
                    model.RstShipment.Add("Month2", Shipment.Rows[1].GetSafeIntValue("Summary"));
                    model.RstShipment.Add("Month3", Shipment.Rows[2].GetSafeIntValue("Summary"));
                    model.RstShipment.Add("Month4", Shipment.Rows[3].GetSafeIntValue("Summary"));
                    model.RstShipment.Add("Month5", Shipment.Rows[4].GetSafeIntValue("Summary"));
                    model.RstShipment.Add("Month6", Shipment.Rows[5].GetSafeIntValue("Summary"));
                    model.RstShipment.Add("Month7", Shipment.Rows[6].GetSafeIntValue("Summary"));
                    model.RstShipment.Add("Month8", Shipment.Rows[7].GetSafeIntValue("Summary"));
                    model.RstShipment.Add("Month9", Shipment.Rows[8].GetSafeIntValue("Summary"));
                    model.RstShipment.Add("Month10", Shipment.Rows[9].GetSafeIntValue("Summary"));
                    model.RstShipment.Add("Month11", Shipment.Rows[10].GetSafeIntValue("Summary"));
                    model.RstShipment.Add("Month12", Shipment.Rows[11].GetSafeIntValue("Summary"));
                }
                DataTable ShipmentProduct = result.Tables[3];
                if (ShipmentProduct.Rows.Count > 0)
                {
                    model.RstShipmentProduct.Add("Month1", ShipmentProduct.Rows[0].GetSafeDecimalValue("Summary"));
                    model.RstShipmentProduct.Add("Month2", ShipmentProduct.Rows[1].GetSafeDecimalValue("Summary"));
                    model.RstShipmentProduct.Add("Month3", ShipmentProduct.Rows[2].GetSafeDecimalValue("Summary"));
                    model.RstShipmentProduct.Add("Month4", ShipmentProduct.Rows[3].GetSafeDecimalValue("Summary"));
                    model.RstShipmentProduct.Add("Month5", ShipmentProduct.Rows[4].GetSafeDecimalValue("Summary"));
                    model.RstShipmentProduct.Add("Month6", ShipmentProduct.Rows[5].GetSafeDecimalValue("Summary"));
                    model.RstShipmentProduct.Add("Month7", ShipmentProduct.Rows[6].GetSafeDecimalValue("Summary"));
                    model.RstShipmentProduct.Add("Month8", ShipmentProduct.Rows[7].GetSafeDecimalValue("Summary"));
                    model.RstShipmentProduct.Add("Month9", ShipmentProduct.Rows[8].GetSafeDecimalValue("Summary"));
                    model.RstShipmentProduct.Add("Month10", ShipmentProduct.Rows[9].GetSafeDecimalValue("Summary"));
                    model.RstShipmentProduct.Add("Month11", ShipmentProduct.Rows[10].GetSafeDecimalValue("Summary"));
                    model.RstShipmentProduct.Add("Month12", ShipmentProduct.Rows[11].GetSafeDecimalValue("Summary"));
                }

                DataTable Interface = result.Tables[4];
                if (Interface.Rows.Count > 0)
                {
                    model.RstInterface.Add("Month1", Interface.Rows[0].GetSafeIntValue("Summary"));
                    model.RstInterface.Add("Month2", Interface.Rows[1].GetSafeIntValue("Summary"));
                    model.RstInterface.Add("Month3", Interface.Rows[2].GetSafeIntValue("Summary"));
                    model.RstInterface.Add("Month4", Interface.Rows[3].GetSafeIntValue("Summary"));
                    model.RstInterface.Add("Month5", Interface.Rows[4].GetSafeIntValue("Summary"));
                    model.RstInterface.Add("Month6", Interface.Rows[5].GetSafeIntValue("Summary"));
                    model.RstInterface.Add("Month7", Interface.Rows[6].GetSafeIntValue("Summary"));
                    model.RstInterface.Add("Month8", Interface.Rows[7].GetSafeIntValue("Summary"));
                    model.RstInterface.Add("Month9", Interface.Rows[8].GetSafeIntValue("Summary"));
                    model.RstInterface.Add("Month10", Interface.Rows[9].GetSafeIntValue("Summary"));
                    model.RstInterface.Add("Month11", Interface.Rows[10].GetSafeIntValue("Summary"));
                    model.RstInterface.Add("Month12", Interface.Rows[11].GetSafeIntValue("Summary"));
                }

                DataTable LPInterface = result.Tables[5];
                if (LPInterface.Rows.Count > 0)
                {
                    model.RstLPInterface.Add("Month1", LPInterface.Rows[0].GetSafeIntValue("Summary"));
                    model.RstLPInterface.Add("Month2", LPInterface.Rows[1].GetSafeIntValue("Summary"));
                    model.RstLPInterface.Add("Month3", LPInterface.Rows[2].GetSafeIntValue("Summary"));
                    model.RstLPInterface.Add("Month4", LPInterface.Rows[3].GetSafeIntValue("Summary"));
                    model.RstLPInterface.Add("Month5", LPInterface.Rows[4].GetSafeIntValue("Summary"));
                    model.RstLPInterface.Add("Month6", LPInterface.Rows[5].GetSafeIntValue("Summary"));
                    model.RstLPInterface.Add("Month7", LPInterface.Rows[6].GetSafeIntValue("Summary"));
                    model.RstLPInterface.Add("Month8", LPInterface.Rows[7].GetSafeIntValue("Summary"));
                    model.RstLPInterface.Add("Month9", LPInterface.Rows[8].GetSafeIntValue("Summary"));
                    model.RstLPInterface.Add("Month10", LPInterface.Rows[9].GetSafeIntValue("Summary"));
                    model.RstLPInterface.Add("Month11", LPInterface.Rows[10].GetSafeIntValue("Summary"));
                    model.RstLPInterface.Add("Month12", LPInterface.Rows[11].GetSafeIntValue("Summary"));
                }
                //for(int i = 0;i < Interface.Rows.Count;i++)
                //{
                //    model.RstInterface.Add("YEAR"+(i +1).ToSafeString(), Interface.Rows[i].GetSafeIntValue("Summary"));
                //    model.RstInterfaceName.Add("Name" + (i + 1).ToSafeString(), Interface.Rows[i].GetSafeStringValue("YEAR"));
                //}

                DataTable Menu = result.Tables[6];
                if (Menu.Rows.Count > 9)
                {
                    model.RstMenu.Add("MenuLP1", Menu.Rows[0].GetSafeDecimalValue("LP"));
                    model.RstMenu.Add("MenuLP2", Menu.Rows[1].GetSafeDecimalValue("LP"));
                    model.RstMenu.Add("MenuLP3", Menu.Rows[2].GetSafeDecimalValue("LP"));
                    model.RstMenu.Add("MenuLP4", Menu.Rows[3].GetSafeDecimalValue("LP"));
                    model.RstMenu.Add("MenuLP5", Menu.Rows[4].GetSafeDecimalValue("LP"));
                    model.RstMenu.Add("MenuLP6", Menu.Rows[5].GetSafeDecimalValue("LP"));
                    model.RstMenu.Add("MenuLP7", Menu.Rows[6].GetSafeDecimalValue("LP"));
                    model.RstMenu.Add("MenuLP8", Menu.Rows[7].GetSafeDecimalValue("LP"));
                    model.RstMenu.Add("MenuLP9", Menu.Rows[8].GetSafeDecimalValue("LP"));
                    model.RstMenu.Add("MenuLP10", Menu.Rows[9].GetSafeDecimalValue("LP"));
                    model.RstMenu.Add("MenuT11", Menu.Rows[0].GetSafeDecimalValue("T1"));
                    model.RstMenu.Add("MenuT12", Menu.Rows[1].GetSafeDecimalValue("T1"));
                    model.RstMenu.Add("MenuT13", Menu.Rows[2].GetSafeDecimalValue("T1"));
                    model.RstMenu.Add("MenuT14", Menu.Rows[3].GetSafeDecimalValue("T1"));
                    model.RstMenu.Add("MenuT15", Menu.Rows[4].GetSafeDecimalValue("T1"));
                    model.RstMenu.Add("MenuT16", Menu.Rows[5].GetSafeDecimalValue("T1"));
                    model.RstMenu.Add("MenuT17", Menu.Rows[6].GetSafeDecimalValue("T1"));
                    model.RstMenu.Add("MenuT18", Menu.Rows[7].GetSafeDecimalValue("T1"));
                    model.RstMenu.Add("MenuT19", Menu.Rows[8].GetSafeDecimalValue("T1"));
                    model.RstMenu.Add("MenuT110", Menu.Rows[9].GetSafeDecimalValue("T1"));
                    model.RstMenu.Add("MenuT21", Menu.Rows[0].GetSafeDecimalValue("T2"));
                    model.RstMenu.Add("MenuT22", Menu.Rows[1].GetSafeDecimalValue("T2"));
                    model.RstMenu.Add("MenuT23", Menu.Rows[2].GetSafeDecimalValue("T2"));
                    model.RstMenu.Add("MenuT24", Menu.Rows[3].GetSafeDecimalValue("T2"));
                    model.RstMenu.Add("MenuT25", Menu.Rows[4].GetSafeDecimalValue("T2"));
                    model.RstMenu.Add("MenuT26", Menu.Rows[5].GetSafeDecimalValue("T2"));
                    model.RstMenu.Add("MenuT27", Menu.Rows[6].GetSafeDecimalValue("T2"));
                    model.RstMenu.Add("MenuT28", Menu.Rows[7].GetSafeDecimalValue("T2"));
                    model.RstMenu.Add("MenuT29", Menu.Rows[8].GetSafeDecimalValue("T2"));
                    model.RstMenu.Add("MenuT210", Menu.Rows[9].GetSafeDecimalValue("T2"));
                    model.RstMenuName.Add("Name1", Menu.Rows[0].GetSafeStringValue("ModuleID"));
                    model.RstMenuName.Add("Name2", Menu.Rows[1].GetSafeStringValue("ModuleID"));
                    model.RstMenuName.Add("Name3", Menu.Rows[2].GetSafeStringValue("ModuleID"));
                    model.RstMenuName.Add("Name4", Menu.Rows[3].GetSafeStringValue("ModuleID"));
                    model.RstMenuName.Add("Name5", Menu.Rows[4].GetSafeStringValue("ModuleID"));
                    model.RstMenuName.Add("Name6", Menu.Rows[5].GetSafeStringValue("ModuleID"));
                    model.RstMenuName.Add("Name7", Menu.Rows[6].GetSafeStringValue("ModuleID"));
                    model.RstMenuName.Add("Name8", Menu.Rows[7].GetSafeStringValue("ModuleID"));
                    model.RstMenuName.Add("Name9", Menu.Rows[8].GetSafeStringValue("ModuleID"));
                    model.RstMenuName.Add("Name10", Menu.Rows[9].GetSafeStringValue("ModuleID"));
                }
            }
            return model;
        }
        #endregion

        #region Internal Function

        #endregion
    }
}
