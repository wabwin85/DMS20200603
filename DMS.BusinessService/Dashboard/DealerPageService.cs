using DMS.Common.Common;
using DMS.DataAccess.Lafite;
using DMS.ViewModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using DMS.Common.Extention;
using DMS.ViewModel.Dashboard;
using DMS.DataAccess;
using DMS.DataAccess.Platform;
using DMS.DataAccess.Interface;
using DMS.ViewModel.Common;
using DMS.Model;
using DMS.Common;

namespace DMS.BusinessService.Dashboard
{
    public class DealerPageService : ABaseService
    {
        #region Ajax Method

        public DealerPageVO Init(DealerPageVO model)
        {
            try
            {
                model.IptCorpType = base.UserInfo.CorpType;

                SystemManualDao systemManualDao = new SystemManualDao();
                BulletinMainDao bulletinMainDao = new BulletinMainDao();
                RvDealerKpiScoreSummaryDao rvDealerKpiScoreSummaryDao = new RvDealerKpiScoreSummaryDao();
                RvDealerKpiScoreDetailDao rvDealerKpiScoreDetailDao = new RvDealerKpiScoreDetailDao();
                RvDealerKpiScoreWarningDao rvDealerKpiScoreWarningDao = new RvDealerKpiScoreWarningDao();
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
                    model.RstSummary.Add(new KeyValue("OrderQT", String.Format("本月已采购总数量：{0}<br />总金额：{1}", Convert.ToInt32(OrderQT.ItemQty.ToSafeDecimal()).ToIntString(), OrderQT.TotalAmount.ToSafeDecimal().ToDecimalString())));
                }
                //本月累计销售（销售单：数量、金额）
                model.RstSummary.Add(new KeyValue("ShipmentQT", String.Format("本月累计销售总数量：{0}<br />总金额：{1}", Convert.ToInt32(ShipmentQT.ItemQty.ToSafeDecimal()).ToIntString(), ShipmentQT.TotalAmount.ToSafeDecimal().ToDecimalString())));
                //本月累计冲红（冲红销售单：数量、金额）
                model.RstSummary.Add(new KeyValue("ShipmentReversedQT", String.Format("本月累计冲红总数量：{0}<br />总金额：{1}", Convert.ToInt32(ShipmentReversedQT.ItemQty.ToSafeDecimal()).ToIntString(), ShipmentReversedQT.TotalAmount.ToSafeDecimal().ToDecimalString())));
                //本月累计借货出库（借货出库单：数量）
                model.RstSummary.Add(new KeyValue("TransferQT", String.Format("本月累计借货出库总数量：{0}<br />总金额：{1}", Convert.ToInt32(TransferQT.ItemQty.ToSafeDecimal()).ToIntString(), TransferQT.TotalAmount.ToSafeDecimal().ToDecimalString())));
                //本月累计退货（审批通过的退货单：数量）
                model.RstSummary.Add(new KeyValue("InventoryAdjustQT", String.Format("本月累计退货总数量：{0}<br />总金额：{1}", Convert.ToInt32(InventoryAdjustQT.ItemQty.ToSafeDecimal()).ToIntString(), InventoryAdjustQT.TotalAmount.ToSafeDecimal().ToDecimalString())));
                //当前经销商普通库库存数（包括缺省仓库）
                model.RstSummary.Add(new KeyValue("NormalInventory", String.Format("当前经销商普通库库存数(包括缺省仓库)：{0}", Convert.ToInt32(NormalInventory.ItemQty.ToSafeDecimal()).ToIntString())));
                //当前经销商寄售库库存数
                model.RstSummary.Add(new KeyValue("ConsignmentInventory", String.Format("当前经销商寄售库库存数：{0}", Convert.ToInt32(ConsignmentInventory.ItemQty.ToSafeDecimal()).ToIntString())));
                //当前经销商借货库库存数
                model.RstSummary.Add(new KeyValue("BorrowInventory", String.Format("当前经销商借货库库存数：{0}", Convert.ToInt32(BorrowInventory.ItemQty.ToSafeDecimal()).ToIntString())));
                //当前经销商在途库库存数
                model.RstSummary.Add(new KeyValue("SystemHoldInventory", String.Format("当前经销商在途库库存数：{0}", Convert.ToInt32(SystemHoldInventory.ItemQty.ToSafeDecimal()).ToIntString())));

                //DMS教程
                Hashtable ht = new Hashtable();
                ht.Add("Type", "Dealer");
                model.RstManual = systemManualDao.SelectListByType(ht);

                //公告
                model.RstNotice = bulletinMainDao.SelectListForDashboard(base.IsDealer, base.UserInfo.CorpId);

                //季度
                model.LstQuarter = rvDealerKpiScoreSummaryDao.SelectDealerQuarterList(base.UserInfo.CorpId);
                model.IptQuarter = new KeyValue(model.LstQuarter.Count > 0 ? model.LstQuarter[0].GetSafeStringValue("Quarter") : "");
                //BU
                if (!model.IptQuarter.Key.IsNullOrEmpty())
                {
                    model.LstBu = rvDealerKpiScoreSummaryDao.SelectDealerBuList(base.UserInfo.CorpId, model.IptQuarter.Key);
                    model.IptBu = new KeyValue(model.LstBu.Count > 0 ? model.LstBu[0].GetSafeStringValue("BuCode") : "", model.LstBu.Count > 0 ? model.LstBu[0].GetSafeStringValue("BuName") : "");
                }
                else
                {
                    model.LstBu = new List<Hashtable>();
                    model.IptBu = new KeyValue();
                }

                //报表
                if (!model.IptQuarter.Key.IsNullOrEmpty() && !model.IptBu.Key.IsNullOrEmpty())
                {
                    model.RstDimension = rvDealerKpiScoreDetailDao.SelectDealerDimension(base.UserInfo.CorpId, model.IptQuarter.Key, model.IptBu.Key);
                    model.RstTrend = rvDealerKpiScoreWarningDao.SelectDealerTrend(base.UserInfo.CorpId, model.IptQuarter.Key, model.IptBu.Key);
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

        public DealerPageVO RefreshNotice(DealerPageVO model)
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

        public DealerPageVO ChangeQuarter(DealerPageVO model)
        {
            try
            {
                RvDealerKpiScoreSummaryDao rvDealerKpiScoreSummaryDao = new RvDealerKpiScoreSummaryDao();
                RvDealerKpiScoreDetailDao rvDealerKpiScoreDetailDao = new RvDealerKpiScoreDetailDao();
                RvDealerKpiScoreWarningDao rvDealerKpiScoreWarningDao = new RvDealerKpiScoreWarningDao();

                if (!model.IptQuarter.Key.IsNullOrEmpty())
                {
                    model.LstBu = rvDealerKpiScoreSummaryDao.SelectDealerBuList(base.UserInfo.CorpId, model.IptQuarter.Key);
                    model.IptBu = new KeyValue(model.LstBu.Count > 0 ? model.LstBu[0].GetSafeStringValue("BuCode") : "", model.LstBu.Count > 0 ? model.LstBu[0].GetSafeStringValue("BuName") : "");
                }
                else
                {
                    model.LstBu = new List<Hashtable>();
                    model.IptBu = new KeyValue();
                }

                if (!model.IptQuarter.Key.IsNullOrEmpty() && !model.IptBu.Key.IsNullOrEmpty())
                {
                    model.RstDimension = rvDealerKpiScoreDetailDao.SelectDealerDimension(base.UserInfo.CorpId, model.IptQuarter.Key, model.IptBu.Key);
                    model.RstTrend = rvDealerKpiScoreWarningDao.SelectDealerTrend(base.UserInfo.CorpId, model.IptQuarter.Key, model.IptBu.Key);
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

        public DealerPageVO ChangeBu(DealerPageVO model)
        {
            try
            {
                RvDealerKpiScoreDetailDao rvDealerKpiScoreDetailDao = new RvDealerKpiScoreDetailDao();
                RvDealerKpiScoreWarningDao rvDealerKpiScoreWarningDao = new RvDealerKpiScoreWarningDao();

                if (!model.IptQuarter.Key.IsNullOrEmpty() && !model.IptBu.Key.IsNullOrEmpty())
                {
                    model.RstDimension = rvDealerKpiScoreDetailDao.SelectDealerDimension(base.UserInfo.CorpId, model.IptQuarter.Key, model.IptBu.Key);
                    model.RstTrend = rvDealerKpiScoreWarningDao.SelectDealerTrend(base.UserInfo.CorpId, model.IptQuarter.Key, model.IptBu.Key);
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

        public DealerPageVO Refresh(DealerPageVO model)
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

        public DealerPageVO ChangeChart(DealerPageVO model)
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

        #endregion

        #region Internal Function

        #endregion
    }
}
