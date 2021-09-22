using DMS.Business;
using DMS.Business.Cache;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Transfer;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Resources;
using System.Text;

namespace DMS.BusinessService.Transfer
{
    public class TransferListInfoService : ABaseQueryService, IDealerFilterFac
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        private ITransferBLL business = new TransferBLL();
        private IConsignmentDealerBLL Dell = new ConsignmentDealerBLL();
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public TransferListInfoVO Init(TransferListInfoVO model)
        {
            try
            {
                bool ShowType = false;
                string DealerId = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                DMS.Model.Transfer header = null;
                if (string.IsNullOrEmpty(model.InstanceId))
                {
                    ShowType = true;
                    header = GetNewTransfer(InstanceId);
                }
                header = business.GetObject(InstanceId);
                model.InstanceId = header.Id.ToString();
                if (header != null)
                {
                    //表头信息
                    model.IsDealer = IsDealer;
                    model.EntityModel = JsonHelper.Serialize(header);
                    model.LstBu = base.GetProductLine();
                    model.LstStatus = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_DealerTransfer_Status).ToArray());
                    //获取经销商
                    model.LstDealer = new ArrayList(DealerList().ToList());
                    //时间
                    if (header.TransferDate != null)
                    {
                        model.QryDate = header.TransferDate.Value.ToString("yyyyMMdd");
                    }
                    if (header.ToDealerDmaId != null)
                    {
                        model.hiddenDealerToId = header.ToDealerDmaId.Value.ToString();
                        //this.txtDealerToWin.Text = DealerCacheHelper.GetDealerName(mainData.ToDealerDmaId.Value);
                        //得到借入经销商默认分仓库ID
                        InvTrans invTrans = new InvTrans();
                        try
                        {
                            model.hiddenDealerToDefaultWarehouseId = invTrans.GetDefaultWarehouse(header.ToDealerDmaId.Value).ToString();
                        }
                        catch
                        {

                        }
                    }
                    //借入经销商
                    Guid dealerId = header.FromDealerDmaId ?? Guid.Empty;
                    IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
                    DealerMaster dealer = DealerCacheHelper.GetDealerById(dealerId);
                    if (ShowType)
                    {
                        if (dealer.DealerType == DealerType.T2.ToString())
                        {
                            var query = from d in dataSource where d.Id.Value != dealer.Id.Value && d.ParentDmaId.HasValue && (d.DealerType == dealer.DealerType || d.DealerType == DealerType.T1.ToString() || d.DealerType == DealerType.LP.ToString() || d.DealerType == DealerType.LS.ToString()) orderby d.ChineseName select d;
                            ArrayList r = new ArrayList();
                            r.AddRange(query.ToList<DealerMaster>());
                            model.LstDealerToList = r;
                        }
                        else
                        {
                            var query = from d in dataSource where d.Id.Value != dealer.Id.Value && ((d.ParentDmaId.HasValue && d.ParentDmaId.Value == dealer.ParentDmaId.Value) || d.DealerType == DealerType.T2.ToString()) orderby d.ChineseName select d;
                            ArrayList r = new ArrayList();
                            r.AddRange(query.ToList<DealerMaster>());
                            model.LstDealerToList = r;
                        }

                    }
                    else
                    {
                        //var query = from d in dataSource where d.Id.Value != dealer.Id.Value && d.ParentDmaId.HasValue && (d.ParentDmaId.Value == dealer.ParentDmaId.Value || d.Id == dealer.ParentDmaId )  orderby d.ChineseName select d;
                        ArrayList r = new ArrayList();
                        r.AddRange(dataSource.ToList<DealerMaster>());
                        model.LstDealerToList = r;
                    }

                    //产品总数量
                    //产品明细
                    int totalCount = 0;
                    Hashtable param = new Hashtable();
                    param.Add("hid", InstanceId);
                    DataTable dtProduct = business.QueryTransferLot(param, 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
                    //操作记录
                    DataTable dtLog = _business.QueryPurchaseOrderLogByHeaderId(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
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

        private DMS.Model.Transfer GetNewTransfer(Guid InstanceId)
        {
            DMS.Model.Transfer mainData = new DMS.Model.Transfer();
            mainData.Id = InstanceId;
            mainData.Type = TransferType.Rent.ToString();
            mainData.Status = DealerTransferStatus.Draft.ToString();
            mainData.FromDealerDmaId = RoleModelContext.Current.User.CorpId.Value;
            business.Insert(mainData);
            return mainData;
        }
        protected string NextNumber(string DealerFromId, string ProductLineWin)
        {
            AutoNumberBLL an = new AutoNumberBLL();
            if (string.IsNullOrEmpty(DealerFromId) || string.IsNullOrEmpty(ProductLineWin))
            {
                return string.Empty;
            }
            else
                return an.GetNextAutoNumber(new Guid(DealerFromId), OrderType.Next_TransferNbr, ProductLineWin);

        }



        #region 按钮事件

        /// <summary>
        /// 刷新数据
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public TransferListInfoVO RefershHeadData(TransferListInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                //产品明细
                Hashtable param = new Hashtable();
                param.Add("hid", InstanceId);
                DataTable dtProduct = business.QueryTransferLot(param, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        /// <summary>
        /// 修改借入经销商触发
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public TransferListInfoVO CheckDealer(TransferListInfoVO model)
        {
            try
            {
                string DealerToWinId = string.IsNullOrEmpty(model.QryDealerToWin.Key) ? "" : model.QryDealerToWin.Key;
                string QryDealerFromWinId = string.IsNullOrEmpty(model.QryDealerFromWin.Key) ? "" : model.QryDealerFromWin.Key;

                if (string.IsNullOrEmpty(DealerToWinId))
                {
                    model.hiddenDealerToId = string.Empty;
                    model.hiddenDealerToDefaultWarehouseId = string.Empty;
                }
                else if (DealerToWinId == QryDealerFromWinId)
                {
                    model.hiddenDealerToId = string.Empty;
                    model.hiddenDealerToDefaultWarehouseId = string.Empty;
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("借入经销商不能是自己");
                }
                else
                {

                    //ITransferBLL business = new TransferBLL();

                    //DealerMaster dealer = business.GetDealerMasterByName(this.cbDealerToWin.SelectedItem.Text);
                    DealerMaster dealer = business.GetDealerMasterById(new Guid(DealerToWinId));

                    if (dealer != null)
                    {
                        if (dealer.ActiveFlag.Value)
                        {
                            model.hiddenDealerToId = dealer.Id.Value.ToString();
                            //取得该经销商的默认仓库
                            InvTrans invTrans = new InvTrans();
                            try
                            {
                                model.hiddenDealerToDefaultWarehouseId = invTrans.GetDefaultWarehouse(dealer.Id.Value).ToString();
                            }
                            catch
                            {
                                model.hiddenDealerToId = string.Empty;
                                model.hiddenDealerToDefaultWarehouseId = string.Empty;
                                model.IsSuccess = false;
                                model.ExecuteMessage.Add("借入经销商的默认分仓库不存在");
                            }
                        }
                        else
                        {
                            model.hiddenDealerToId = string.Empty;
                            model.hiddenDealerToDefaultWarehouseId = string.Empty;
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("借入经销商无效");
                        }
                    }
                    else
                    {
                        model.hiddenDealerToId = string.Empty;
                        model.hiddenDealerToDefaultWarehouseId = string.Empty;
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("借入经销商不存在");
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
        /// 删除产品线,单行删除
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public TransferListInfoVO DeleteItem(TransferListInfoVO model)
        {
            try
            {
                bool result = false;
                try
                {
                    result = business.DeleteItem(new Guid(model.LotId));
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }

                if (!result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("删除异常");
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
        /// 修改产品线清除已选择的所有产品
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public TransferListInfoVO DeleteDetail(TransferListInfoVO model)
        {
            try
            {
                bool result = false;
                try
                {
                    int totalCount = 0;
                    result = business.DeleteDetail(new Guid(model.InstanceId));
                    Hashtable param = new Hashtable();
                    param.Add("hid", model.InstanceId);
                    DataTable dtProduct = business.QueryTransferLotHasFromToWarehouse(param, 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
                if (!result)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除明细数据异常");
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
        /// 更新数量、二维码
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public TransferListInfoVO SaveItem(TransferListInfoVO model)
        {
            //ITransferBLL business = new TransferBLL();
            bool result = false;
            try
            {
                string lotnumber = string.Empty;
                string messig = string.Empty;
                bool bl = true;
                IInventoryAdjustBLL bll = new InventoryAdjustBLL();
                //校验二维码库中是否存在这个二维码
                if (!string.IsNullOrEmpty(model.QRCode))
                {
                    if (model.QRCode != "NoQR")
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("借货出库存在二维码时数量只能为1");
                        return model;
                    }
                }
                if (model.QRCode == "NoQR" && !string.IsNullOrEmpty(model.EditQrCode))
                {
                    if (bll.QueryQrCodeIsExist(model.EditQrCode))
                    {
                        lotnumber = model.LotNumber + "@@" + model.EditQrCode;
                    }
                    else
                    {
                        bl = false;
                        messig = "该二维码不存在";
                    }

                }
                result = business.SaveItem(new Guid(model.LotId), Convert.ToDouble(model.TransferQty), lotnumber);
                if (!result)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("保存失败");
                }
                if (!bl)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(messig);
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
        /// 保存草稿
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public TransferListInfoVO SaveDraft(TransferListInfoVO model)
        {
            try
            {
                DMS.Model.Transfer mainData = business.GetObject(new Guid(model.InstanceId));
                if (!string.IsNullOrEmpty(model.QryDealerFromWin.Key))
                {
                    mainData.FromDealerDmaId = new Guid(model.QryDealerFromWin.Key);
                }
                if (!string.IsNullOrEmpty(model.QryProductLineWin.Key))
                {
                    mainData.ProductLineBumId = new Guid(model.QryProductLineWin.Key);
                }
                if (!string.IsNullOrEmpty(model.QryDealerToWin.Key))
                {
                    mainData.ToDealerDmaId = new Guid(model.QryDealerToWin.Key);
                }

                bool result = false;
                mainData.TransferUsrUserID = new Guid(this._context.User.Id);
                result = business.SaveDraft(mainData);

                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("保存成功");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("保存失败");
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
        public TransferListInfoVO DeleteDraft(TransferListInfoVO model)
        {
            try
            {
                bool result = false;
                result = business.DeleteDraft(new Guid(model.InstanceId));
                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("删除成功");
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
        public TransferListInfoVO DoRevoke(TransferListInfoVO model)
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
        /// 提交
        /// </summary>
        public TransferListInfoVO Submit(TransferListInfoVO model)
        {
            try
            {
                DMS.Model.Transfer mainData = business.GetObject(new Guid(model.InstanceId));
                if (!string.IsNullOrEmpty(model.QryDealerFromWin.Key))
                {
                    mainData.FromDealerDmaId = new Guid(model.QryDealerFromWin.Key);
                }
                if (!string.IsNullOrEmpty(model.QryProductLineWin.Key))
                {
                    mainData.ProductLineBumId = new Guid(model.QryProductLineWin.Key);
                }
                if (!string.IsNullOrEmpty(model.QryDealerToWin.Key))
                {
                    mainData.ToDealerDmaId = new Guid(model.QryDealerToWin.Key);
                }

                bool result = false;

                string errMsg = string.Empty;

                DealerMaster dealerfrom = DealerCacheHelper.GetDealerById(mainData.FromDealerDmaId.Value);
                DealerMaster dealerto = DealerCacheHelper.GetDealerById(mainData.ToDealerDmaId.Value);
                //判断移入和移出经销商红蓝还是否一致；如果不一致则不能提交
                if (business.IsTransferDealerTypeEqualByTrnID(mainData.FromDealerDmaId.Value, new Guid(model.QryDealerToWin.Key)))
                {
                    mainData.TransferUsrUserID = new Guid(this._context.User.Id);
                    if ((dealerfrom.DealerType == DealerType.T1.ToString() || dealerfrom.DealerType == DealerType.T2.ToString()) && dealerto.DealerType == DealerType.LP.ToString())
                    {
                        result = business.BorrowSubmit(mainData, ReceiptType.Rent, out errMsg);
                    }
                    else
                    {
                        result = business.Submit(mainData, ReceiptType.Rent, out errMsg);
                    }

                    if (result)
                    {
                        model.ExecuteMessage.Add("提交成功");
                        return model;
                    }
                    else
                    {
                        string resultMsg = "";
                        if (errMsg == "Submit.Msg.DealerUnauthorized")
                            resultMsg = "借入经销商授权检查未通过！";
                        if (errMsg == "Submit.Msg.InventoryCheckFailed")
                            resultMsg = "物料库存检查未通过！";
                        if (errMsg == "Submit.Msg.SaveFailed")
                            resultMsg = "保存信息出错！";
                        if (errMsg == "Submit.Msg.SaveFailed.AuthError")
                            resultMsg = "借入经销商没有产品授权！";
                        if (errMsg == "Submit.Msg.SubmitFailed")
                            resultMsg = "提交失败！";
                        if (errMsg == "Submit.Msg.SubmitSuccess")
                            resultMsg = "提交成功！";
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add(resultMsg);
                        return model;

                    }
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("红蓝海经销商之间互相不能借货！");
                    return model;
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


        #region 弹窗页面添加

        //增加产品
        public TransferListInfoVO DoAddProductItems(TransferListInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                string param = model.DealerParams;
                System.Diagnostics.Debug.WriteLine("AddItems : Param = " + param);
                param = param.Substring(0, param.Length - 1);
                ITransferBLL business = new TransferBLL();
                bool result;
                //modified by bozhenfei on 20100607
                result = business.AddItemsByType(model.QryTransferType,
                       new Guid(model.InstanceId),
                       new Guid(model.QryDealerFromId),
                       new Guid(model.QryDealerToWin.Key),
                       new Guid(model.QryProductLineWin.Key),
                       param.Split(','),
                       (new Guid(model.hiddenDealerToDefaultWarehouseId))
                       );
                if (result)
                {
                    Hashtable p = new Hashtable();
                    p.Add("hid", InstanceId);
                    DataTable dtProduct = business.QueryTransferLotHasFromToWarehouse(p, 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
                }
                else
                {
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
