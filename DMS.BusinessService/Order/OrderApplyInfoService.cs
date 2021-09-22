using DMS.Business;
using DMS.Business.Cache;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Order;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Order
{
    public class OrderApplyInfoService : ABaseQueryService, IDealerFilterFac
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        private IWarehouses _warehouse = new DMS.Business.Warehouses();
        private IContractMaster _contractMaster = new ContractMaster();
        private IInventoryAdjustBLL _invAdjBiz = new InventoryAdjustBLL();
        private IAttachmentBLL _attachBll = new AttachmentBLL();

        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public OrderApplyInfoVO Init(OrderApplyInfoVO model)
        {
            try
            {
                string DealerId = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                PurchaseOrderHeader header = new PurchaseOrderHeader();
                if (model.IsNewApply)
                {
                    header = GetNewPurchaseOrderHeader(InstanceId);
                }
                else
                {
                    header = _business.GetPurchaseOrderHeaderById(InstanceId);
                }
                model.InstanceId = header.Id.ToSafeString();
                model.IsDealer = IsDealer;
                model.DealerType = RoleModelContext.Current.User.CorpType;
                model.EntityModel = JsonHelper.Serialize(header);
                model.LstBu = base.GetProductLine();
                //订单类型
                model.LstOrderType = OrderTypeStore_RefreshData(header.OrderStatus);
                //获取积分类型
                model.LstPointType = new ArrayList(DictionaryHelper.GetDictionary(SR.PRO_PointType).ToList());

                int totalCount = 0;
                SetFormValue(model, header);
                CaculateFormValue(model, InstanceId);
                //经销商
                List<DealerMaster> dealerList = DealerList().ToList();
                DealerMaster dealer = dealerList.Where(s => s.Id == new Guid(model.hidDealerId)).FirstOrDefault();
                dealerList = new List<DealerMaster>();
                dealerList.Add(dealer);
                model.QryDealer = new KeyValue(model.hidDealerId, dealer.ChineseName);
                model.LstDealer = new ArrayList(dealerList);
                //经销商对应的仓库
                model.hidWareHouseType = GetInitWarehouseType(model.IsNewApply, model);
                model.LstWarehouse = new ArrayList(WarehouseByDealer(model.hidDealerId, model.hidWareHouseType).ToList());
                model.IsExistsPaymentTypBYDma = _business.SelectDealerPaymentTypBYDmaId(model.hidDealerId);
                //产品明细
                DataTable dtProduct = new DataTable();
                DataSet dsDetail = new DataSet();
                dsDetail = _business.QueryPurchaseOrderDetailByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);
                if (dsDetail != null)
                    dtProduct = dsDetail.Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
                //发货明细
                dsDetail = new PurchaseOrderBLL().QueryPoReceiptOrderDetailByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);
                if (dsDetail != null)
                    dtProduct = dsDetail.Tables[0];
                model.RstShipDetail = JsonHelper.DataTableToArrayList(dtProduct);
                //附件
                AttachmentStore_Refresh(model);
                //日志
                DataTable dtLog = _business.QueryPurchaseOrderLogByHeaderId(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstLogDetail = JsonHelper.DataTableToArrayList(dtLog);


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }


        private string GetInitWarehouseType(bool IsNewApply, OrderApplyInfoVO model)
        {
            string WarehosueType = string.Empty;
            if (IsNewApply)
            {//新增
                if (model.LstOrderType.Count > 0)
                {
                    WarehosueType = ((System.Collections.Generic.KeyValuePair<string, string>)(model.LstOrderType.ToArray()[0])).Key;
                }
            }
            else
            {
                WarehosueType = model.hidOrderType;
            }
            if ("Normal" == WarehosueType || "Exchange" == WarehosueType)
            {
                return "Normal";
            }
            else if ("Consignment" == WarehosueType || "ConsignmentSales" == WarehosueType || "SCPO" == WarehosueType)
            {
                return "Consignment";
            }
            else if ("PRO" == WarehosueType || "CRPO" == WarehosueType)
            {
                return "Normal";
            }
            else
            {
                return "Normal";
            }
        }
        private void SetFormValue(OrderApplyInfoVO model, PurchaseOrderHeader header)
        {
            //表头信息
            model.hidDealerId = header.DmaId.HasValue ? header.DmaId.Value.ToString() : Guid.Empty.ToSafeString();
            model.hidProductLine = header.ProductLineBumId.HasValue ? header.ProductLineBumId.Value.ToString() : "";
            model.hidOrderStatus = ((PurchaseOrderStatus)Enum.Parse(typeof(PurchaseOrderStatus), header.OrderStatus, true)).ToString();
            model.hidTerritoryCode = header.TerritoryCode;
            model.hidLatestAuditDate = header.LatestAuditDate.HasValue ? header.LatestAuditDate.Value.ToString() : "";

            model.hidOrderType = header.OrderType;
            model.QryOrderNO = header.OrderNo;
            model.hidWarehouse = header.WhmId.HasValue ? header.WhmId.Value.ToString() : "";
            model.QryOrderStatus = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_Order_Status, header.OrderStatus);

            if (string.IsNullOrEmpty(header.Vendorid))
            {
                model.QryOrderTo = DealerCacheHelper.GetDealerById(DealerCacheHelper.GetDealerById(header.DmaId.Value).ParentDmaId.Value).ChineseName;
                model.hidVenderId = DealerCacheHelper.GetDealerById(DealerCacheHelper.GetDealerById(header.DmaId.Value).ParentDmaId.Value).Id.ToString();

            }
            else
            {
                model.QryOrderTo = DealerCacheHelper.GetDealerById(new Guid(header.Vendorid.ToString())).ChineseName;
                model.hidVenderId = DealerCacheHelper.GetDealerById(new Guid(header.Vendorid.ToString())).Id.ToString();
            }

            model.QrySubmitDate = header.SubmitDate.HasValue ? header.SubmitDate.Value.ToString("yyyy-MM-dd HH:mm:ss") : "";

            //汇总信息
            model.QryRemark = header.Remark;
            //订单信息
            model.QryContactPerson = header.ContactPerson;
            model.QryContact = header.Contact;
            model.QryContactMobile = header.ContactMobile;
            //收货信息
            model.QryShipToAddress = header.ShipToAddress;
            model.QryConsignee = header.Consignee;
            model.QryConsigneePhone = header.ConsigneePhone;
            model.QryCarrier = header.TerritoryCode;//将区域代码字段用作承运商信息
            if (header.Rdd.HasValue)
            {
                model.QryRDD = header.Rdd.Value.ToString("yyyy-MM-dd");
            }
            //设定期望到货日期只能选取当前时间之后的日期
            //this.dtRDD.MinDate = DateTime.Now.AddDays(1);

            model.hidPointType = header.PointType;
            //this.cbpaymentTpype.SelectedItem.Value = header.SapOrderNo == null ? "" : header.SapOrderNo;
            //this.cbpaymentTpype1.SelectedItem.Value = header.SapOrderNo == null ? "" : header.SapOrderNo;
            model.hidpayment = header.SapOrderNo == null ? "" : header.SapOrderNo;
        }

        private void CaculateFormValue(OrderApplyInfoVO model, Guid InstanceId)
        {
            DataSet ds = _business.SumPurchaseOrderByHeaderId(InstanceId);
            if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
            {
                if (model.QryOrderType.Key == PurchaseOrderType.PRO.ToString() || model.QryOrderType.Key == PurchaseOrderType.CRPO.ToString())
                {
                    model.QryTotalAmount = "0";
                }
                else
                {
                    model.QryTotalAmount = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("F2");
                }
                model.QryTotalQty = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalQty"]).ToString("F2");
                model.QryTotalReceiptQty = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalReceiptQty"]).ToString("F2");
            }
        }
        /// <summary>
        /// 修改dropdownlist重新计算表头信息，可扩展查询产品明细
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyInfoVO RefershHeadData(OrderApplyInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                CaculateFormValue(model, InstanceId);
                //产品明细
                DataTable dtProduct = new DataTable();
                DataSet dsDetail = new DataSet();
                dsDetail = _business.QueryPurchaseOrderDetailByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);
                if (dsDetail != null)
                    dtProduct = dsDetail.Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        /// <summary>
        /// 订单类型
        /// </summary>
        /// <param name="PageStatus">单据状态</param>
        protected ArrayList OrderTypeStore_RefreshData(string PageStatus)
        {

            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Order_Type);
            //如果单据状态是草稿状态,则只显示普通订单、寄售订单
            if (PageStatus.Equals(PurchaseOrderStatus.Draft.ToString()))
            {
                var resultType = (from t in dicts
                                  where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                         t.Key == PurchaseOrderType.Consignment.ToString() ||
                                         t.Key == PurchaseOrderType.Exchange.ToString() ||
                                         t.Key == PurchaseOrderType.BOM.ToString() ||
                                         t.Key == PurchaseOrderType.SCPO.ToString() ||
                                         t.Key == PurchaseOrderType.PRO.ToString() ||
                                         t.Key == PurchaseOrderType.CRPO.ToString())
                                  select t);
                return new ArrayList(resultType.ToList());

            }
            else
            {
                var resultType = (from t in dicts select t);
                return new ArrayList(resultType.ToList());
            }
        }

        /// <summary>
        /// 更新订单数量
        /// </summary>
        /// <param name="model"></param>
        /// <param name="ItemId"></param>
        public OrderApplyInfoVO UpdateItem(OrderApplyInfoVO model)
        {
            try
            {
                Guid detailId = !string.IsNullOrEmpty(model.ItemId) ? new Guid(model.ItemId) : Guid.Empty;
                PurchaseOrderDetail detail = _business.GetPurchaseOrderDetailById(detailId);

                if (!string.IsNullOrEmpty(model.RequiredQty))
                {
                    detail.RequiredQty = Convert.ToDecimal(model.RequiredQty);
                    detail.Amount = detail.RequiredQty * detail.CfnPrice;
                    //不需要计算税率
                    //detail.Tax = detail.RequiredQty * detail.CfnPrice * (SR.Consts_TaxRate - 1);
                    detail.Tax = detail.RequiredQty * detail.CfnPrice * 0;
                }
                bool result = _business.UpdateCfn(detail);
            }
            catch (Exception ex)
            {
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
                LogHelper.Error(ex);
            }
            return model;
        }


        #region 按钮事件

        /// <summary>
        /// 删除产品线
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyInfoVO DeleteItem(OrderApplyInfoVO model)
        {
            try
            {
                bool result = false;
                try
                {
                    result = _business.DeleteCfn(new Guid(model.LotId));
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }
                if (!result)
                {
                    model.IsSuccess = false;
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
        /// 保存草稿
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyInfoVO SaveDraft(OrderApplyInfoVO model)
        {
            try
            {
                PurchaseOrderHeader header = this.GetFormValue(model);
                bool result = _business.SaveDraft(header);
                if (result)
                {
                    //  Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveDraft.True.Alert.Body").ToString()).Show();
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("保存成功");
                }
                else
                {
                    // Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.False.Alert.Title").ToString(), GetLocalResourceObject("SaveDraft.False.Alert.Body").ToString()).Show();
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
        public OrderApplyInfoVO DeleteDraft(OrderApplyInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                bool result = _business.DeleteDraft(InstanceId);
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
        public OrderApplyInfoVO DoRevoke(OrderApplyInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                bool result = _business.RevokeT2Order(InstanceId);
                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("订单已撤销");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("订单无法撤销<BR/>可能订单状态已经改变，请刷新！");
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
        /// 复制
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyInfoVO DoCopy(OrderApplyInfoVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                Guid DealerId = string.IsNullOrEmpty(model.hidDealerId) ? Guid.Empty : new Guid(model.hidDealerId);
                bool result = _business.Copy(InstanceId, DealerId, model.hidPriceType, out rtnVal, out rtnMsg);
                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("复制订单成功");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("复制订单失败！");
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
        public OrderApplyInfoVO Submit(OrderApplyInfoVO model)
        {
            try
            {
                //List<EditRowInfo> editRow = JsonConvert.DeserializeObject<List<EditRowInfo>>(model.EditRowParams);
                //foreach (EditRowInfo item in editRow)
                //{
                //    UpdateItem(item.Id, item.RequiredQty, item.Amount);
                //}

                PurchaseOrderHeader header = this.GetFormValue(model);
                bool result = _business.Submit(header, "");
                if (result)
                {
                    model.ExecuteMessage.Add("提交成功");
                }
                else
                {
                    // Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.False.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.False.Alert.Body").ToString()).Show();
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("提交失败(可能为库存数量不足等情况，请联系管理员)");
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

        private bool IsGuid(string strSrc)
        {
            if (String.IsNullOrEmpty(strSrc)) { return false; }

            bool _result = false;
            try
            {
                Guid _t = new Guid(strSrc);
                _result = true;
            }

            catch { }
            return _result;
        }
        public OrderApplyInfoVO CheckSubmit(OrderApplyInfoVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                string rtnval1 = string.Empty;
                string rtnMsg1 = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                Guid DealerId = string.IsNullOrEmpty(model.hidDealerId) ? Guid.Empty : new Guid(model.hidDealerId);
                if (model.QryOrderType.Key.Equals(PurchaseOrderType.PRO.ToString()) || model.QryOrderType.Key.Equals(PurchaseOrderType.CRPO.ToString()))
                {
                    _business.CheckSubmit(InstanceId, DealerId, "", model.hidPriceType, model.hidOrderType, out rtnVal, out rtnMsg);

                    if (rtnVal == "Success" || rtnVal == "Warn")
                    {
                        // _business.RedInvoice_SumbitChecked(this.InstanceId.ToString(), this.DealerId.ToString(), cbProductLine.SelectedItem.Value, this.hidPointType.Text, this.hidOrderType.Text, out rtnval1, out rtnMsg1);
                        model.hidRtnVal = "Success";
                    }
                    else
                    {
                        model.hidRtnVal = "Error";
                    }

                    model.hidRtnMsg = rtnMsg.Replace("$$", "<BR/>") + rtnMsg1;
                }
                else
                {
                    bool result = _business.CheckSubmit(InstanceId, DealerId, "00000000-0000-0000-0000-000000000000", model.hidPriceType, "", out rtnVal, out rtnMsg);
                    model.hidRtnVal = rtnVal;
                    model.hidRtnMsg = rtnMsg;
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
        /// 使用积分
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyInfoVO CaculateFormValuePoint(OrderApplyInfoVO model)
        {
            try
            {
                model.hidPointCheckErr = "0";
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                //预提积分
                this.CheckPointOrder(model);
                //返回预提结果
                string masg = "";
                DataSet ds = _business.SumPurchaseOrderByHeaderId(InstanceId);

                //预提额度
                //this.CheckRedInvoicesOrder();
                //DataSet dsrev = _business.SumPurchaseOrderByRedInvoicesHeaderId(this.InstanceId.ToString()); 
                if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
                {
                    if (model.QryOrderType.Key.Equals(PurchaseOrderType.CRPO.ToString()))
                    {
                        masg = "总金额：" + Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("F2") + ", ";
                        masg += "积分抵用：" + Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"]).ToString("F2") + ", ";
                        masg += "还需现金支付：" + (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]) - Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"])).ToString("F2") + ", ";
                        if (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]) - Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"]) > 0)
                        {
                            model.hidPointCheckErr = "1";
                        }
                        model.ExecuteMessage.Add(masg);
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
        private string CheckPointOrder(OrderApplyInfoVO model)
        {
            Hashtable obj = new Hashtable();
            obj.Add("POH_ID", model.InstanceId);
            obj.Add("DMA_ID", model.hidDealerId);
            if (!string.IsNullOrEmpty(model.hidProductLine))
            {
                obj.Add("ProductLineId", model.hidProductLine);
            }
            if (!string.IsNullOrEmpty(model.hidPointType))
            {
                obj.Add("PointType", model.hidPointType);
            }
            string retValue = "";
            _business.OrderPointCheck(obj, out retValue);
            return retValue;
        }
        /// <summary>
        /// 订单类型修改后台逻辑
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyInfoVO ChangeOrderType(OrderApplyInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                //更换订单类型，删除订单原产品组下的所有产品
                bool result = _business.DeleteDetail(InstanceId);
                if (model.QryOrderType.Key.Equals(PurchaseOrderType.CRPO.ToString()))
                {
                    int i = _business.DeleteOrderPointByOrderHeaderId(InstanceId);
                }
                //SetAddCfnSetBtnHidden();
                //IsShowpaymentType();
                model.IsExistsPaymentTypBYDma = _business.SelectDealerPaymentTypBYDmaId(model.hidDealerId);
                model.LstWarehouse = new ArrayList(WarehouseByDealer(model.hidDealerId, model.hidWareHouseType).ToList());
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
        /// 积分修改删除原有订单
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyInfoVO ChangePointType(OrderApplyInfoVO model)
        {
            try
            {
                //更新积分类型，删除订单原产品组下的所有产品
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);

                //更换产品组，删除订单原使用积分
                if (model.QryOrderType.Key.Equals(PurchaseOrderType.CRPO.ToString()))
                {
                    int i = _business.DeleteOrderPointByOrderHeaderId(InstanceId);
                    _business.DeleteOrderRedInvoicesByOrderHeaderId(InstanceId.ToString());
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
        /// 修改产品线
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyInfoVO ChangeProductLine(OrderApplyInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                //更换产品组，删除订单原产品组下的所有产品
                bool result = _business.DeleteDetail(InstanceId);
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

        #region 私有方法

        private PurchaseOrderHeader GetNewPurchaseOrderHeader(Guid InstanceId)
        {
            PurchaseOrderHeader header = new PurchaseOrderHeader();
            header.Id = InstanceId;
            header.DmaId = _context.User.CorpId.Value;
            header.OrderStatus = PurchaseOrderStatus.Draft.ToString();
            header.CreateUser = new Guid(_context.User.Id);
            header.CreateDate = DateTime.Now;
            header.CreateType = PurchaseOrderCreateType.Manual.ToString();
            header.LastVersion = 0;

            //取得订单联系人和收货信息
            DealerMaster dm = _business.GetDealerMasterByDealer(header.DmaId.Value);
            if (dm != null)
            {
                //header.ShipToAddress = dm.ShipToAddress;
                header.TerritoryCode = dm.Certification; //承运商信息
            }
            DealerShipTo dsh = _business.GetDealerShipToByUser(new Guid(_context.User.Id));
            if (dsh != null)
            {
                header.ContactPerson = dsh.ContactPerson;
                header.Contact = dsh.Contact;
                header.ContactMobile = dsh.ContactMobile;
                header.Consignee = dsh.Consignee;
                header.ConsigneePhone = dsh.ConsigneePhone;
            }


            _business.InsertPurchaseOrderHeader(header);
            return header;
        }
        private PurchaseOrderHeader GetFormValue(OrderApplyInfoVO model)
        {
            Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
            PurchaseOrderHeader header = _business.GetPurchaseOrderHeaderById(InstanceId);
            header.ProductLineBumId = string.IsNullOrEmpty(model.hidProductLine) ? null as Guid? : new Guid(model.hidProductLine);
            header.OrderType = string.IsNullOrEmpty(model.hidOrderType) ? "" : model.hidOrderType;
            //header.TerritoryCode = this.cbTerritory.SelectedItem.Value;
            //汇总信息
            header.Remark = model.QryRemark;
            //订单信息
            header.ContactPerson = model.QryContactPerson;
            header.Contact = model.QryContact;
            header.ContactMobile = model.QryContactMobile;
            //收货信息
            header.WhmId = string.IsNullOrEmpty(model.QryWarehouse.ToSafeString()) ? null as Guid? : string.IsNullOrEmpty(model.QryWarehouse.Key) ? null as Guid? : new Guid(model.QryWarehouse.Key);
            header.ShipToAddress = model.QryShipToAddress;
            header.Consignee = model.QryConsignee;
            header.ConsigneePhone = model.QryConsigneePhone;
            if (!string.IsNullOrEmpty(model.QryRDD))
            {
                try
                {
                    if (Convert.ToDateTime(model.QryRDD) > DateTime.MinValue)
                    {
                        header.Rdd = Convert.ToDateTime(model.QryRDD);
                    }
                }
                catch { }
            }
            else
            {
                header.Rdd = null;
            }
            //承运商信息
            header.TerritoryCode = model.QryCarrier;
            header.Vendorid = string.IsNullOrEmpty(model.hidVenderId) ? null : model.hidVenderId;
            //Edit By SongWeiming on 2017-04-18 去除RSM的选择
            //header.SalesAccount = this.cbSales.SelectedItem.Value;
            header.SapOrderNo = model.hidpayment;
            header.PointType = string.IsNullOrEmpty(model.QryPointType.ToSafeString()) ? "" : model.QryPointType.Key;
            return header;
        }
        #endregion

        #region 弹窗页面添加

        //增加产品
        public OrderApplyInfoVO DoAddProductItems(OrderApplyInfoVO model)
        {
            try
            {
                int totalCount = 0;
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                Guid hidDealerId = string.IsNullOrEmpty(model.hidDealerId) ? Guid.Empty : new Guid(model.hidDealerId);
                if (model.IscfnDialog)
                {
                    string param = model.PickerParams;
                    string checkparam = model.CheckpickearrParams;
                    (new PurchaseOrderBLL()).AddSpecialCfnPromotion(InstanceId, hidDealerId, param.Substring(0, param.Length - 1), checkparam.Substring(0, checkparam.Length - 1), model.hidSpecialPriceId, model.hidOrderType, out rtnVal, out rtnMsg);
                }
                else
                {
                    string param = model.PickerParams;
                    (new PurchaseOrderBLL()).AddCfn(InstanceId, hidDealerId, param.Substring(0, param.Length - 1), model.hidOrderType, out rtnVal, out rtnMsg);
                }
                if (rtnMsg.Length > 0 || rtnVal != "Success")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnMsg);
                }
                //查询产品明细
                DataTable dtProduct = new DataTable();
                DataSet dsDetail = new DataSet();
                dsDetail = _business.QueryPurchaseOrderDetailByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);
                if (dsDetail != null)
                    dtProduct = dsDetail.Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
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
        /// 增加组套产品
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyInfoVO DoAddProductSetItems(OrderApplyInfoVO model)
        {
            try
            {
                int totalCount = 0;
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                Guid hidDealerId = string.IsNullOrEmpty(model.hidDealerId) ? Guid.Empty : new Guid(model.hidDealerId);

                string param = model.PickerParams;
                string checkparam = model.CheckpickearrParams;
                (new PurchaseOrderBLL()).AddBSCCfnSet(InstanceId, hidDealerId, param.Substring(0, param.Length - 1), model.hidPriceType, out rtnVal, out rtnMsg);
                if (rtnMsg.Length > 0 || rtnVal != "Success")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnMsg);
                }
                //查询产品明细
                DataTable dtProduct = new DataTable();
                DataSet dsDetail = new DataSet();
                dsDetail = _business.QueryPurchaseOrderDetailByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);
                if (dsDetail != null)
                    dtProduct = dsDetail.Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
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

        #region 附件处理
        /// <summary>
        /// 附件列表
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyInfoVO AttachmentStore_Refresh(OrderApplyInfoVO model)
        {
            try
            {
                DataTable dt = new DataTable();
                Guid tid = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                int totalCount = 0;
                DataSet ds = _attachBll.GetAttachmentByMainId(tid, AttachmentType.ReturnAdjust, 0, int.MaxValue, out totalCount);
                if (ds != null)
                {
                    dt = ds.Tables[0];
                }
                model.LstAttachmentList = JsonHelper.DataTableToArrayList(dt);

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
        /// 删除附件
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyInfoVO DeleteAttachment(OrderApplyInfoVO model)
        {
            try
            {
                Guid id = string.IsNullOrEmpty(model.AttachmentId) ? Guid.Empty : new Guid(model.AttachmentId);
                _attachBll.DelAttachment(id);
                string uploadFile = Server.MapPath("..\\..\\..\\Upload\\UploadFile\\AdjustAttachment");
                File.Delete(uploadFile + "\\" + model.AttachmentName);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add("删除附件失败，请联系DMS技术支持");
            }
            return model;
        }
        #endregion

    }
}
