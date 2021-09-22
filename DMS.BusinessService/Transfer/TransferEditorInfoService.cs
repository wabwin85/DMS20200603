using DMS.Business;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Model.Data;
using DMS.ViewModel.Transfer;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Transfer
{
    public class TransferEditorInfoService : ABaseQueryService, IDealerFilterFac
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        private ITransferBLL business = new TransferBLL();
        private IConsignmentDealerBLL Dell = new ConsignmentDealerBLL();
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public TransferEditorInfoVO Init(TransferEditorInfoVO model)
        {
            try
            {
                string DealerId = string.Empty;
                model.BtnReasonVisibile = false;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                DMS.Model.Transfer header = null;
                if (string.IsNullOrEmpty(model.InstanceId))
                {
                    string TransType = model.QryTransType;
                    string DealerFromId = model.QryDealerFromId;
                    string ProductLineWin = model.QryProductLineWin == null ? "" : model.QryProductLineWin.Key;
                    header = GetNewTransfer(InstanceId, TransType, DealerFromId, ProductLineWin);
                }
                header = business.GetObject(InstanceId);
                model.InstanceId = header.Id.ToString();
                if (header != null)
                {
                    //表头信息
                    //ArrayList list = new ArrayList();
                    //list.Add(header);
                    //model.EntityModel = list;
                    model.IsDealer = IsDealer;
                    model.EntityModel = JsonHelper.Serialize(header);
                    model.LstBu = base.GetProductLine();
                    model.LstStatus = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_DealerTransfer_Status).ToArray());
                    //获取经销商
                    model.LstDealer = new ArrayList(DealerList().ToList());
                    //if (_context.User.CorpType == DealerType.LS.ToString() || !IsDealer)
                    //{
                    //    //移入仓库可以是医院类型仓库或主仓库
                    //    model.LstWarehouse = new ArrayList(WarehouseByDealerAndType(header.FromDealerDmaId.Value, header.Type == TransferType.Transfer.ToString() ? "Normal" : "Consignment").ToList());
                    //}
                    //else
                    //{
                    //    //移入仓库只能是医院库类型
                    //    model.LstWarehouse = new ArrayList(WarehouseByDealerAndType(header.FromDealerDmaId.Value, header.Type == TransferType.Transfer.ToString() ? "HospitalOnly" : "Consignment").ToList());
                    //}
                    //20191217,显示主仓库及普通库
                    model.LstWarehouse = new ArrayList(WarehouseByDealerAndType(header.FromDealerDmaId.Value, header.Type == TransferType.Transfer.ToString() ? "MoveNormal" : "Consignment").ToList());
                    int totalCount = 0;
                    //产品总数量
                    Hashtable p = new Hashtable();
                    p.Add("TrnId", InstanceId);
                    TransferBLL transferBLL = new TransferBLL();
                    Decimal lineNum = transferBLL.GetTransferLineProductNumByTrnId(p);
                    model.ProductSumText = lineNum.ToString();

                    //产品明细
                    Hashtable param = new Hashtable();
                    param.Add("hid", InstanceId);
                    DataTable dtProduct = business.QueryTransferLotHasFromToWarehouse(param, 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);

                    DataTable dtLog = _business.QueryPurchaseOrderLogByHeaderId(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstLogDetail = JsonHelper.DataTableToArrayList(dtLog);
                    if (header.Status == DealerTransferStatus.Draft.ToString())
                        model.BtnReasonVisibile = _context.User.LoginId.Contains("_99") ? true : business.SelectLimitBUCount(RoleModelContext.Current.User.CorpId.Value).Tables[0].Rows[0]["cnt"].ToString() == "0";
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

        private DMS.Model.Transfer GetNewTransfer(Guid InstanceId, string TransType, string DealerFromId, string ProductLineWin)
        {
            DMS.Model.Transfer mainData = new DMS.Model.Transfer();
            mainData.Id = InstanceId;
            mainData.Type = TransType;
            mainData.Status = DealerTransferStatus.Draft.ToString();
            mainData.FromDealerDmaId = RoleModelContext.Current.User.CorpId.Value;
            mainData.ToDealerDmaId = RoleModelContext.Current.User.CorpId.Value;
            mainData.TransferNumber = NextNumber(DealerFromId, ProductLineWin);
            mainData.TransferDate = DateTime.Now;
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
        public TransferEditorInfoVO RefershHeadData(TransferEditorInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                //产品明细
                Hashtable param = new Hashtable();
                param.Add("hid", InstanceId);
                DataTable dtProduct = business.QueryTransferLotHasFromToWarehouse(param, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }
        /// <summary>
        /// 单行删除产品明细
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public TransferEditorInfoVO DeleteItem(TransferEditorInfoVO model)
        {
            try
            {
                bool result = false;
                result = business.DeleteItem(new Guid(model.LotId));
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
        public TransferEditorInfoVO DeleteDetail(TransferEditorInfoVO model)
        {
            try
            {
                bool result = false;
                int totalCount = 0;
                result = business.DeleteDetail(new Guid(model.InstanceId));
                Hashtable param = new Hashtable();
                param.Add("hid", model.InstanceId);
                DataTable dtProduct = business.QueryTransferLotHasFromToWarehouse(param, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
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
        public TransferEditorInfoVO SaveTransferItem(TransferEditorInfoVO model)
        {
            //ITransferBLL business = new TransferBLL();
            try
            {
                bool result = false;

                string Number = string.Empty;
                bool bl = true;
                InventoryAdjustBLL bll = new InventoryAdjustBLL();

                Guid? whid = null;
                if (!string.IsNullOrEmpty(model.ToWarehouseId))
                {
                    whid = new Guid(model.ToWarehouseId);
                }
                if (!string.IsNullOrEmpty(model.QRCode))
                {
                    if (model.QRCode != "NoQR" && Convert.ToInt32(model.TransferQty) != 1)
                    {
                        //model.IsSuccess = false;
                        model.hiddenMsg = "warning";
                        model.ExecuteMessage.Add("移库存在二维码时数量只能为1");
                        return model;
                    }
                }
                if (model.QRCode == "NoQR" && !string.IsNullOrEmpty(model.EditQrCode))
                {
                    if (bll.QueryQrCodeIsExist(model.EditQrCode))
                    {
                        Number = model.LotNumber + "@@" + model.EditQrCode;
                    }
                    else
                    {
                        bl = false;
                    }
                }
                result = business.SaveTransferItem(new Guid(model.LotId), whid, Convert.ToDouble(model.TransferQty), Number);

                //this.DetailStore.DataBind();
                if (!result)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("保存出错");
                }
                if (!bl)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("该二维码不存在");
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
        public TransferEditorInfoVO SaveDraft(TransferEditorInfoVO model)
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
                if (!string.IsNullOrEmpty(model.QryDealerFromWin.Key))
                {
                    mainData.ToDealerDmaId = new Guid(model.QryDealerFromWin.Key);
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
        public TransferEditorInfoVO DeleteDraft(TransferEditorInfoVO model)
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
        /// 提交
        /// </summary>
        public TransferEditorInfoVO Submit(TransferEditorInfoVO model)
        {
            try
            {
                bool result = false;
                string errMsg = string.Empty;

                //ITransferBLL business = new TransferBLL();

                //判断line表中移入库与移出库是否一致；如果一致则不能提交
                if (!business.IsTransferLineWarehouseEqualByTrnID(model.InstanceId))
                {
                    //更新字段
                    DMS.Model.Transfer mainData = business.GetObject(new Guid(model.InstanceId));
                    mainData.FromDealerDmaId = RoleModelContext.Current.User.CorpId;
                    mainData.ToDealerDmaId = RoleModelContext.Current.User.CorpId;

                    if (!string.IsNullOrEmpty(model.QryProductLineWin.Key))
                    {
                        mainData.ProductLineBumId = new Guid(model.QryProductLineWin.Key);
                    }

                    DataSet ds = business.SelectTransferLotByFilter(new Guid(model.InstanceId));

                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        errMsg = ds.Tables[0].Rows[0][0].ToString();
                    }

                    if (!string.IsNullOrEmpty(errMsg))
                    {
                        errMsg = errMsg.Replace(",", "<br/>");
                        //  Ext.Msg.Alert("Error", errMsg).Show();
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add(errMsg);
                        return model;
                    }
                    mainData.TransferUsrUserID = new Guid(this._context.User.Id);
                    result = business.TransferSubmit(mainData, out errMsg);

                    if (result)
                    {
                        model.ExecuteMessage.Add(errMsg);
                        model.hiddrtn = "WarehouseNotEqual";
                        return model;
                    }
                    else
                    {
                        if (errMsg == "DoSubmit.False.Alert.Body")
                        {
                            model.ExecuteMessage.Add("提交失败");
                        }
                        if (errMsg == "Submit.Msg.InventoryCheckFailed")
                        {
                            model.ExecuteMessage.Add("移库数量超过库存数量！");
                        }
                        return model;
                    }
                }
                else
                {
                    model.hiddrtn = "WarehouseEqual";
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
        public TransferEditorInfoVO DoAddProductItems(TransferEditorInfoVO model)
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
                       new Guid(model.QryDealerToId),
                       new Guid(model.QryProductLineWin.Key),
                       param.Split(','),
                       (new Guid(string.IsNullOrEmpty(model.QryWarehouseWin.Key) ? Guid.Empty.ToString() : model.QryWarehouseWin.Key))
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