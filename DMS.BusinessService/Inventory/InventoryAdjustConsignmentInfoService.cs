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
using DMS.ViewModel.Inventory;
using Grapecity.DataAccess.Transaction;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace DMS.BusinessService.Inventory
{
    public class InventoryAdjustConsignmentInfoService : ABaseQueryService, IDealerFilterFac
    {
        public static IInventoryAdjustBLL business = new InventoryAdjustBLL();
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public InventoryAdjustConsignmentInfoVO Init(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                InventoryAdjustHeader AdjustHeader = null;
                Guid InstanceId = model.IsNewApply ? Guid.NewGuid() : new Guid(model.InstanceId.ToString());
                model.LstBu = base.GetProductLine();
                model.IsDealer = IsDealer;
                model.LstDealer = new ArrayList(DealerListByFilter(false).ToList());
                model.DealerListType = "2";
                if (model.IsNewApply)
                {
                    //插入新数据
                    AdjustHeader = new InventoryAdjustHeader();
                    AdjustHeader.Id = InstanceId;
                    AdjustHeader.CreateDate = DateTime.Now;
                    AdjustHeader.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                    AdjustHeader.DmaId = RoleModelContext.Current.User.CorpId.Value;
                    AdjustHeader.Status = AdjustStatus.Draft.ToString();
                    AdjustHeader.WarehouseType = AdjustWarehouseType.Normal.ToString();

                    business.InsertInventoryAdjustHeader(AdjustHeader);
                }
                AdjustHeader = business.GetInventoryAdjustById(InstanceId);
                model.InstanceId = InstanceId.ToString();
                model.EntityModel = JsonHelper.Serialize(AdjustHeader);

                string userId = AdjustHeader.CreateUser.ToSafeString().ToLower();
                if (userId == RoleModelContext.Current.User.Id.ToLower())
                {
                    model.CheckCreateUser = true;
                }
                model.IptAdjustReason = AdjustHeader.UserDescription;//调整原因
                model.IptAdjustDate = (AdjustHeader.CreateDate ?? DateTime.Now).ToString("yyyyMMdd");
                if (AdjustHeader.ProductLineBumId != null)
                    model.IptProductLine = KeyValueHelper.CreateProductLine(new Guid(AdjustHeader.ProductLineBumId.ToSafeString()));
                model.IptDealer = KeyValueHelper.CreateDealer(new Guid(AdjustHeader.DmaId.ToString()));
                //model.IptAdjustType = AdjustHeader.ApplyType;
                if (!string.IsNullOrEmpty(AdjustHeader.Reason))
                    model.IptAdjustType = new KeyValue(AdjustHeader.Reason, DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_AdjustQty_Type, AdjustHeader.Reason));//调整类型
                model.IptNo = AdjustHeader.InvAdjNbr;//调整单号
                string m = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_AdjustQty_Status, AdjustHeader.Status);
                model.IptStatus = m;//状态
                model.IptAuditorNotes = AdjustHeader.AuditorNotes;

                Hashtable param = new Hashtable();
                param.Add("AdjustId", model.InstanceId);
                int totalCount = 0;
                DataSet ds = business.QueryInventoryAdjustLot(param, 0, int.MaxValue, out totalCount);
                model.RstContractDetail = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                //model.RstOperationLog = base.GetLog("Consign_ContractInfo", model.InstanceId.ToSafeGuid());
                DataSet Logds = _logbll.QueryPurchaseOrderLogByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);
                model.RstLogDetail = JsonHelper.DataTableToArrayList(Logds.Tables[0]);
                //绑定类型
                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_AdjustQty_Type);
                ArrayList r = new ArrayList();
                var winList = from d in dicts where d.Key.Equals(AdjustType.StockIn.ToString()) || d.Key.Equals(AdjustType.StockOut.ToString()) select d;
                r.AddRange(winList.ToList());
                model.LstType = r;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }



        /// <summary>
        /// 保存草稿
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryAdjustConsignmentInfoVO SaveDraft(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                //更新字段
                InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(model.InstanceId));
                if (!string.IsNullOrEmpty(model.IptProductLine.ToSafeString()))
                    if (model.IptProductLine.Value != "全部" && model.IptProductLine.Key != "")
                        mainData.ProductLineBumId = new Guid(model.IptProductLine.Key);
                if (!string.IsNullOrEmpty(model.IptAdjustType.ToSafeString()))
                    if (model.IptAdjustType.Value != "全部" && model.IptAdjustType.Key != "")
                        mainData.Reason = model.IptAdjustType.Key;
                if (!string.IsNullOrEmpty(model.IptAdjustReason))
                {
                    mainData.UserDescription = model.IptAdjustReason;
                }
                if (!string.IsNullOrEmpty(model.IptDealer.ToSafeString()))
                    if (model.IptDealer.Value != "全部" && model.IptDealer.Key != "")
                        mainData.DmaId = new Guid(model.IptDealer.Key);

                bool result = false;
                try
                {
                    result = business.SaveDraft(mainData);
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }

                if (result)
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("保存草稿失败");
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

        /// <summary>
        /// 删除草稿
        /// </summary>
        public InventoryAdjustConsignmentInfoVO DeleteDraft(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                bool result = false;
                result = business.DeleteDraft(new Guid(model.InstanceId));
                if (result)
                {
                    model.IsSuccess = true;
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除草稿失败");
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

        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryAdjustConsignmentInfoVO DoRevoke(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                bool result = false;
                try
                {
                    result = business.Revoke(new Guid(model.InstanceId));
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }

                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("撤销成功");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("撤销失败");

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
        /// <summary>
        /// 提交表单
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryAdjustConsignmentInfoVO DoSubmit(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(model.InstanceId));
                if (!string.IsNullOrEmpty(model.IptProductLine.ToSafeString()))
                    if (model.IptProductLine.Value != "全部" && model.IptProductLine.Key != "")
                        mainData.ProductLineBumId = new Guid(model.IptProductLine.Key);
                if (!string.IsNullOrEmpty(model.IptAdjustType.ToSafeString()))
                    if (model.IptAdjustType.Value != "全部" && model.IptAdjustType.Key != "")
                        mainData.Reason = model.IptAdjustType.Key;
                if (!string.IsNullOrEmpty(model.IptAdjustReason))
                {
                    mainData.UserDescription = model.IptAdjustReason;
                }
                if (!string.IsNullOrEmpty(model.IptDealer.ToSafeString()))
                    if (model.IptDealer.Value != "全部" && model.IptDealer.Key != "")
                        mainData.DmaId = new Guid(model.IptDealer.Key);

                bool result = false;
                model.hiddenIsRtnValue = true;
                //hiddenReturnMessing.Text = string.Empty;
                bool bl = true;
                string Messing = string.Empty;
                string RtnRegMsg = "";
                string QrCode = string.Empty;
                string IsValid = string.Empty;
                business.InventoryAdjust_CheckSubmit(model.InstanceId, model.IptAdjustType.Key, out RtnRegMsg, out IsValid);
                if (RtnRegMsg != string.Empty)
                {
                    model.hiddenIsRtnValue = false;
                    //bl = false;
                }
                if (IsValid == "Error" && !string.IsNullOrEmpty(RtnRegMsg))
                {
                    RtnRegMsg = RtnRegMsg.Replace(",", "</br>");
                    model.warnMsg = RtnRegMsg;
                    return model;
                }
                else if (IsValid == "Success")
                {
                    result = business.Submit(mainData);
                }
                if (!result)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("提交失败");
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
        /// <summary>
        /// 改变产品线，删除已添加的产品
        /// </summary>
        public InventoryAdjustConsignmentInfoVO OnProductLineChange(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                business.DeleteDetail(new Guid(model.InstanceId));
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        /// <summary>
        /// 修改调整类型
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryAdjustConsignmentInfoVO OnAdjustTypeChange(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                business.DeleteDetail(new Guid(model.InstanceId));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            return model;
        }

        /// <summary>
        /// 修改经销商
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryAdjustConsignmentInfoVO DeleteDetail(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                business.DeleteDetail(new Guid(model.InstanceId));
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            return model;
        }
        /// <summary>
        /// 编辑产品行（序列号/批号,库存,数量）自动保存操作
        /// </summary>
        /// <param name="CFN"></param>
        /// <param name="lotNumber"></param>
        /// <param name="expiredDate"></param>
        /// <param name="adjustQty"></param>
        /// <param name="EditQrCode"></param>
        public InventoryAdjustConsignmentInfoVO SaveItem(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                bool isCode = false;
                bool isLotNbr = false;
                string Messinge = string.Empty;
                LotMasters lms = new LotMasters();
                if (model.hiddenAdjustTypeId == AdjustType.StockOut.ToString())
                {
                    InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(model.LotId));
                    lot.LotQRCode = model.EditQrCode;
                    lot.LtmLot = model.lotNumber;
                    lot.QrLotNumber = model.lotNumber + "@@" + model.EditQrCode;
                    if (!string.IsNullOrEmpty(model.adjustQty))
                    {
                        lot.LotQty = Convert.ToDouble(model.adjustQty); 

                    }
                    if (!string.IsNullOrEmpty(model.EditQrCode))
                    {

                        if (business.QueryQrCodeIsExist(model.EditQrCode))
                        {
                            lot.QrLotNumber = model.lotNumber + "@@" + model.EditQrCode;

                        }
                        else
                        {

                            Messinge = Messinge + "该二维码不存在<BR/>";

                        }

                    }
                    if (string.IsNullOrEmpty(Messinge))
                    {
                        bool result = business.SaveItem(lot);

                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add(Messinge);
                        return model;
                    }
                    //this.DetailStore.DataBind();
                }
                if (model.hiddenAdjustTypeId == AdjustType.StockIn.ToString())
                {
                    InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(model.LotId));//this.hiddenCurrentEdit.Text
                    if (!string.IsNullOrEmpty(model.lotNumber) && !string.IsNullOrEmpty(model.EditQrCode))
                    {
                        LotMaster lm = new LotMaster();
                        if (!string.IsNullOrEmpty(model.lotNumber))
                        {
                            lm = lms.SelectLotMasterByLotNumberCFNQrCode(model.lotNumber, model.CFN);
                            if (lm == null)
                            {
                                Messinge = Messinge + "产品批号" + model.lotNumber + "不存在<BR/>";
                            }
                            else
                            {
                                lot.ExpiredDate = lm.ExpiredDate;
                            }
                        }
                        if (!string.IsNullOrEmpty(model.EditQrCode))
                        {
                            if (model.EditQrCode.Trim() != "NoQR")
                            {
                                if (!business.QueryQrCodeIsExist(model.EditQrCode))
                                {
                                    Messinge = Messinge + "二维码" + model.EditQrCode + "不存在<BR/>";
                                }
                                else
                                {
                                    if (Convert.ToDouble(model.adjustQty) != 1)
                                    {
                                        model.ExecuteMessage.Add("入库存在二维码时入库数量只能为1");
                                        return model;
                                    }
                                }
                            }

                        }
                        else
                        {
                            model.EditQrCode = "NoQR";
                        }


                        lot.LotNumber = model.lotNumber + "@@" + model.EditQrCode;

                        lot.QrLotNumber = model.lotNumber + "@@" + model.EditQrCode;

                        lot.LtmLot = model.lotNumber;
                        lot.LotQRCode = model.EditQrCode;
                        lot.LotQty = Convert.ToDouble(model.adjustQty);
                        bool result = business.SaveItem(lot);
                        if (result)
                        {
                            //this.DetailStore.DataBind();
                        }
                        else
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("保存出错");
                            return model;
                        }
                        if (Messinge != string.Empty)
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add(Messinge);
                            return model;
                        }
                    }
                    else if (!string.IsNullOrEmpty(model.adjustQty))
                    {
                        //InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(this.hiddenCurrentEdit.Text));
                        lot.LotQty = Convert.ToDouble(model.adjustQty);

                        bool result = business.SaveItem(lot);
                        if (!result)
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("保存出错");
                            return model;
                        }

                    }
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

        /// <summary>
        /// 刷新数据
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryAdjustConsignmentInfoVO RefershHeadData(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                //产品明细
                Hashtable param = new Hashtable();
                param.Add("AdjustId", InstanceId);
                DataSet ds = business.QueryInventoryAdjustLot(param, 0, int.MaxValue, out totalCount);
                model.RstContractDetail = JsonHelper.DataTableToArrayList(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }
        /// <summary>
        /// 删除行调用方法
        /// </summary>
        /// <param name="LotId"></param>
        public InventoryAdjustConsignmentInfoVO DeleteItem(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                bool result = false;
                result = business.DeleteItem(new Guid(model.LotId));
                if (!result)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除失败");
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
        public string Isnull(string Model)
        {
            if (string.IsNullOrEmpty(Model))
            {
                return null;
            }
            else
            {
                return Model.Trim();
            }

        }

        #region 弹窗页面添加

        //增加产品
        public InventoryAdjustConsignmentInfoVO DoAddProductItems(InventoryAdjustConsignmentInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                string param = model.ProductStrParams;
                System.Diagnostics.Debug.WriteLine("AddItems : Param = " + param);
                param = param.Substring(0, param.Length - 1);
                IInventoryAdjustBLL business = new InventoryAdjustBLL();
                //Edited By Song Yuqi On 20140319 Begin
                bool result = false;
                if ((model.hiddenDialogAdjustType == AdjustType.Return.ToString() || model.hiddenDialogAdjustType == AdjustType.Exchange.ToString())
                       && _context.User.CorpType == DealerType.T2.ToString()
                       && model.hiddenWarehouseType == AdjustWarehouseType.Consignment.ToString())
                {
                    result = business.AddItems(model.hiddenDialogAdjustType, new Guid(model.InstanceId), new Guid(model.hiddenDialogDealerId), model.cbWarehouse1, param.Split(','), model.hiddenReturnApplyType);
                }
                else if (model.hiddenDialogAdjustType == AdjustType.Transfer.ToString() && model.hiddenWarehouseType == AdjustWarehouseType.Borrow.ToString())
                {
                    result = business.AddConsignmentItemsInv(new Guid(model.InstanceId), new Guid(model.hiddenDialogDealerId), param.Split(','));
                }
                else
                {
                    result = business.AddItems(model.hiddenDialogAdjustType, new Guid(model.InstanceId), new Guid(model.hiddenDialogDealerId), model.cbWarehouse2, param.Split(','), model.hiddenReturnApplyType);
                }
                //Edited By Song Yuqi On 20140319 End

                if (result)
                {
                    if ((model.hiddenDialogAdjustType == AdjustType.Return.ToString() || model.hiddenDialogAdjustType == AdjustType.Exchange.ToString())
                        && _context.User.CorpType == DealerType.T2.ToString()
                        && model.hiddenWarehouseType == AdjustWarehouseType.Consignment.ToString())
                    {
                        // this.GridStore.DataBind();
                    }
                    else if (model.hiddenDialogAdjustType == AdjustType.Transfer.ToString() && model.hiddenWarehouseType == AdjustWarehouseType.Borrow.ToString())
                    {
                        // this.GridStore.DataBind();
                    }
                    else
                    {
                        //  this.GridStore.DataBind();
                    }

                }
                else
                {
                    //Ext.Msg.Alert(GetLocalResourceObject("DoYes.Alert.false.title").ToString(), GetLocalResourceObject("DoYes.Alert.false.body").ToString()).Show();
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("添加产品失败");
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

        #endregion

    }
}
