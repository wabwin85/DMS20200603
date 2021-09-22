using DMS.Business;
using DMS.Business.Cache;
using DMS.Business.EKPWorkflow;
using DMS.BusinessService.Util;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess.Consignment;
using DMS.Model;
using DMS.Model.Data;
using DMS.Model.EKPWorkflow;
using DMS.ViewModel.Common;
using DMS.ViewModel.Consign.Common;
using DMS.ViewModel.POReceipt;
using Grapecity.DataAccess.Transaction;
using iTextSharp.text;
using iTextSharp.text.pdf;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.POReceipt
{
    public class POReceiptListInfoService : ABaseQueryService, IDealerFilterFac //ABaseBusinessService
    {
        public static IPOReceipt business = new DMS.Business.POReceipt();
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public POReceiptListInfoVO Init(POReceiptListInfoVO model)
        {
            try
            {
                ContractHeaderDao ContractHeader = new ContractHeaderDao();
                ContractDetailDao ContractDetailDao = new ContractDetailDao();

                //  model.LstBu = base.GetProductLine();
                model.IsDealer = IsDealer;
                model.DealerType = RoleModelContext.Current.User.CorpType;
                if (model.InstanceId.IsNullOrEmpty())
                {
                    model.IsNewApply = true;
                    model.ViewMode = "Edit";
                    model.InstanceId = Guid.NewGuid().ToSafeString();
                    //model.IptApplyBasic = base.CreateDefaultApplyBasic();
                    model.CheckCreateUser = true;
                }
                else
                {
                    model.IsNewApply = false;
                    Guid InstanceId = new Guid(model.InstanceId.ToString());
                    PoReceiptHeader header = business.GetObjectAddWarehouse(InstanceId);
                    model.IptSapNumber = header.SapShipmentid;
                    model.IptDealer = DealerCacheHelper.GetDealerName(header.DealerDmaId);
                    model.IptStatus = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_Receipt_Status, header.Status);
                    model.IptPoNumber = header.PoNumber;
                    model.IptVendor = DealerCacheHelper.GetDealerName(header.VendorDmaId);
                    model.IptSapShipmentDate = (header.SapShipmentDate == null) ? "" : header.SapShipmentDate.Value.ToString("yyyy-MM-dd HH:mm:ss");
                    model.IptFormStatus = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_Receipt_Status, header.Status);
                    model.IptCarrier = header.Carrier;
                    model.IptTrackingNo = header.TrackingNo;
                    model.IptShipType = header.ShipType;
                    model.IptWarehouse = header.WHMName;
                    model.IptWhmId = header.WhmId.ToString();
                    model.IptFromWarehouse = header.FromWHMName;
                    Hashtable param = new Hashtable();
                    param.Add("hid", InstanceId);
                    int totalCount = 0;
                    DataTable dt = business.QueryPoReceiptLot(param, 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstContractDetail = JsonHelper.DataTableToArrayList(dt);
                    //判断是否显示收获按钮
                    if (IsDealer)
                    {
                        //取得经销商的开帐日期
                        DealerMasters dms = new DealerMasters();
                        DealerMaster dm = dms.GetDealerMaster(header.DealerDmaId);
                        //经销商不允许取消收货单
                        model.CancelButton = true;

                        //Edit by Songweiming on 2013-11-18 允许物流平台在界面上进行收货，修改下面这句语句
                        //if (dm == null || RoleModelContext.Current.User.CorpType == DealerType.LP.ToString())
                        //RLD在界面上进行收货
                        if ((RoleModelContext.Current.User.CorpId.ToString().ToUpper() == "2F2D2BD9-6FAE-4A40-BC44-8E5FECC1C6DD" || RoleModelContext.Current.User.CorpId.ToString().ToUpper() == "3D9B9EA0-1214-42CA-A2EF-D93C5C887040") && header.DealerDmaId.ToString() == RoleModelContext.Current.User.CorpId.ToString())
                        {
                            model.SaveButton = !(header.Status == ReceiptStatus.Waiting.ToString());
                        }
                        else if (dm == null || header.DealerDmaId.ToString() != RoleModelContext.Current.User.CorpId.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LP.ToString())
                        {
                            model.SaveButton = true;
                        }
                        else
                        {
                            model.SaveButton = !(header.Status == ReceiptStatus.Waiting.ToString());
                        }

                        //this.SaveButton.Disabled = !(header.Status == ReceiptStatus.Waiting.ToString());
                    }
                    else
                    {
                        model.SaveButton = true;
                        //管理员允许取消收货单，当且仅当单据类型是采购入库单，且状态是待接收的单据能够取消
                        if (header.Status.Equals(ReceiptStatus.Waiting.ToString()) && header.Type.Equals(ReceiptType.PurchaseOrder.ToString()))
                        {
                            model.CancelButton = false;
                        }
                        else
                        {
                            model.CancelButton = true;
                        }

                    }
                    //获取仓库列表
                    IList<Warehouse> LstWarehorse = WarehouseByDealer(header.DealerDmaId.ToString(), "");
                    model.LstWarehouse = new ArrayList(LstWarehorse.ToList());
                    //model.RstOperationLog = base.GetLog("POReceipt_POReceiptlist", model.InstanceId.ToSafeGuid());
                    DataTable dtLog = _logbll.QueryPurchaseOrderLogByHeaderId(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];

                    model.RstLogDetail = JsonHelper.DataTableToArrayList(dtLog);
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

        #region 确认收货/取消收货单
        public POReceiptListInfoVO DoYes(POReceiptListInfoVO model)
        {
            string rtnVal = string.Empty;
            Guid InstanceId = new Guid(model.InstanceId.ToString());
            Guid IptWhmId = string.IsNullOrEmpty(model.IptWhmId) ? Guid.Empty : new Guid(model.IptWhmId);
            //收货业务
            //IPOReceipt business = new DMS.Business.POReceipt();
            try
            {
                rtnVal = business.SavePoReceipt(InstanceId, IptWhmId);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (rtnVal == "Success")
            {
                //this.ResultStore.DataBind();
                //this.DetailWindow.Hide();
                //收货成功,刷新表单列表
                model.ExecuteMessage.Add("收货成功！");
                model.IsSuccess = true;
            }
            else
            {
                // Ext.Msg.Alert(GetLocalResourceObject("DoConfirm.Confirm.Title").ToString(), rtnVal.ToString()).Show();
                //收货失败
                model.IsSuccess = false;
                model.ExecuteMessage.Add(rtnVal.ToString());
            }

            return model;
        }

        //取消收货单
        public POReceiptListInfoVO DoCancelYes(POReceiptListInfoVO model)
        {
            //取消收货单
            //IPOReceipt business = new DMS.Business.POReceipt();
            bool result = false;
            Guid InstanceId = new Guid(model.InstanceId.ToString());
            try
            {
                result = business.CancelPoReceipt(InstanceId);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            if (result)
            {
                //this.ResultStore.DataBind();
                //this.DetailWindow.Hide();
                //Ext.Msg.Alert(GetLocalResourceObject("DoConfirm.Confirm.Title").ToString(), GetLocalResourceObject("DoCancelYes.True.Alert.Body").ToString()).Show();
                //取消成功,刷新表单列表
                model.IsSuccess = true;
            }
            else
            {
                // Ext.Msg.Alert(GetLocalResourceObject("DoConfirm.Confirm.Title").ToString(), GetLocalResourceObject("DoCancelYes.Alert.Body").ToString()).Show();
                //取消失败
                model.IsSuccess = false;
                model.ExecuteMessage.Add("取消失败");
            }
            return model;
        }
        #endregion


    }
}
