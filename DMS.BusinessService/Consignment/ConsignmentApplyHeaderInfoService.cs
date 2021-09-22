using DMS.Business;
using DMS.Business.Cache;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.Model;
using DMS.Model.Consignment;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Consignment;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Consignment
{
    public class ConsignmentApplyHeaderInfoService : ABaseQueryService
    {
        public IConsignmentApplyDetailsBLL DtBll = new ConsignmentApplyDetailsBLL();
        public IConsignmentApplyHeaderBLL bll = new ConsignmentApplyHeaderBLL();
        public IConsignmentMasterBLL ConMastBll = new ConsignmentMasterBLL();
        public IConsignmentDealerBLL CdelaBll = new ConsignmentDealerBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        public ConsignmentApplyHeaderInfoVO Init(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                string DealerId = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                model.IsDealer = IsDealer;
                if (IsDealer)
                {
                    model.hidCorpType = RoleModelContext.Current.User.CorpType;
                }
                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary("Product_source");
                model.LstcbProductsource = new ArrayList(dicts.ToArray());
                ConsignmentApplyHeader header = bll.GetConsignmentApplyHeaderSing(InstanceId);
                if (header == null)
                {
                    header = NewConshead(InstanceId);
                }
                model.InstanceId = header.Id.ToString();
                if (header != null)
                {
                    model.LstBu = base.GetProductLine();
                    model.EntityModel = JsonHelper.Serialize(header);
                    DealerId = header.DmaId.ToString();

                    string DealerName = DealerCacheHelper.GetDealerById(header.DmaId.Value).ChineseName;//经销商名称
                    model.QryDealerId = header.DmaId.Value.ToString();
                    model.QryDealer = DealerName;
                    model.QryApplyType = DictionaryCacheHelper.GetDictionaryNameById(SR.ConsignmentApply_Order_Type, "DealerConsignmentApply");//申请但类型
                    DataSet dsApply = DtBll.SelecConsignmentApplyDetailsCfnSum(InstanceId.ToString());
                    if (dsApply.Tables[0].Rows.Count > 0)
                    {
                        model.Qrynumber = dsApply.Tables[0].Rows[0]["Qtysum"].ToString();
                        model.QryTaoteprice = dsApply.Tables[0].Rows[0]["Pricesum"].ToString();
                    }
                    var cbproline = header.ProductLineId == null ? "" : header.ProductLineId.ToString();
                    model.Qrycbproline = new KeyValue(cbproline, "");
                    if (cbproline != string.Empty)
                    {
                        if (header.OrderStatus == ConsignmentOrderType.Draft.ToString())
                        {

                            model.LstcbHospital = JsonHelper.DataTableToArrayList(HospatBindata(cbproline, header.DmaId.Value.ToString()).Tables[0]);
                            string cbHospital = header.HospitalId == null ? "" : header.HospitalId.ToString();
                            model.QrycbHospital = new KeyValue(cbHospital, header.HospitalName);
                        }
                        else
                        {
                            model.cbHospitalHidden = true;

                        }
                    }
                    else
                    {
                        model.LstcbHospital = JsonHelper.DataTableToArrayList(HospatBindata(Guid.Empty.ToString(), "").Tables[0]);//初始化医院cb
                    }
                    if (DealerId == string.Empty && header.ProductLineId != null)
                    {
                        DealerId = header.ProductLineId.Value.ToString();
                    }
                    model.LstDealerConsignment = JsonHelper.DataTableToArrayList(CdelaBindata(DealerId, cbproline));

                    if (DealerId != null)
                    {
                        ArrayList ware = new ArrayList();
                        ware.AddRange(Bind_SAPWarehouseAddress(new Guid(DealerId)).ToList());
                        model.LstSAPWarehouseAddress = ware;
                    }
                    model.LstProlineDma = JsonHelper.DataTableToArrayList(GetProductLineDma(cbproline));
                    model.QrySubmitDate = header.SubmitDate == null ? "" : header.SubmitDate.ToString();
                    model.QryApplyNo = header.OrderNo == null ? "" : header.OrderNo;
                    model.QryDelayState = DictionaryCacheHelper.GetDictionaryNameById(SR.CONST_Delay_Status, header.DelayOrderStatus == null ? "" : header.DelayOrderStatus);
                    model.QryOrderState = DictionaryCacheHelper.GetDictionaryNameById(SR.ConsignmentApply_Status, header.OrderStatus == null ? "" : header.OrderStatus); ;
                    model.QryConsignment = header.Reason;
                    model.QryRemark = header.Remark;
                    model.QrySalesName = header.SalesName;
                    model.QrySalesEmail = header.SalesEmail;
                    model.QrySalesPhone = header.SalesPhone;
                    model.QryConsignee = header.Consignee;
                    model.QryTexthospitalname = header.SendHospital;
                    model.QryHospitalAddress = header.SendAddress;
                    model.QrycbSAPWarehouseAddress = new KeyValue(header.ShipToAddress, "");
                    model.QryConsigneePhone = header.ConsigneePhone;
                    if (header.Rdd != null)
                    {
                        model.QrydfRDD = header.Rdd.Value.ToString();
                    }
                    model.QryNumberDays = header.CmConsignmentDay.ToString();
                    model.QryDelaytimes = header.DelayDelayTime == null ? "" : header.DelayDelayTime.ToString();
                    model.QryBeginData = !header.CmStartDate.HasValue ? "" : header.CmStartDate.Value.ToString("yyyy-MM-dd");
                    model.QryEndData = !header.CmEndDate.HasValue ? "" : header.CmEndDate.Value.ToString("yyyy-MM-dd");

                    if (header.IsFixedMoney.HasValue)
                    {
                        model.QryIsControlAmount = header.IsFixedMoney.Value ? "是" : "否";
                    }
                    if (header.IsFixedQty.HasValue)
                    {
                        model.QryIsControlNumber = header.IsFixedQty.Value ? "是" : "否";
                    }
                    if (header.IsUseDiscount.HasValue)
                    {
                        model.QryIsDiscount = header.IsUseDiscount.Value ? "是" : "否";
                    }
                    if (header.Iskb.HasValue)
                    {
                        model.QryIsKB = header.Iskb.Value ? "是" : "否";
                    }

                    model.hidProductLine = header.ProductLineId.HasValue ? header.ProductLineId.Value.ToString() : "";
                    model.HospId = header.HospitalId == null ? "" : header.HospitalId.Value.ToString();
                    model.txtRuleId = header.CmId == null ? "" : header.CmId.ToString();
                    model.txtConsignmentRuleId = header.CmConsignmentName;
                    model.hidorderState = header.OrderStatus;


                    model.hidConsignment = header.CmId.ToString();
                    model.hidUpdateDate = header.UpdateDate.ToString();



                    if (!string.IsNullOrEmpty(header.ConsignmentFrom))
                    {
                        model.hidChanConsignment = header.ConsignmentFrom;

                    }
                    else
                    {
                        model.hidChanConsignment = "Bsc";

                    }
                    string DivisionCode = string.Empty;
                    //产品线下的销售
                    if (!string.IsNullOrEmpty(cbproline))
                    {
                        model.LstSalesRepStor = JsonHelper.DataTableToArrayList(DealerConsignmentStoreBindata(cbproline, out DivisionCode,model.QryDealerId));
                    }
                    else
                    {

                        model.LstSalesRepStor = JsonHelper.DataTableToArrayList(DealerConsignmentStoreBindata(Guid.Empty.ToString(), out DivisionCode, model.QryDealerId));//初始化销售cb
                    }
                    model.hidDivisionCode = DivisionCode;


                    int totalCount = 0;
                    DataTable dtResult = DtBll.SelectConsignmentApplyProList(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstResultList = JsonHelper.DataTableToArrayList(dtResult);

                    DataTable dtLog = new PurchaseOrderBLL().QueryPurchaseOrderLogByHeaderId(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
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
        public void AssignFrom(ConsignmentApplyHeaderInfoVO model, ConsignmentApplyHeader header, Guid InstanceId, string DealerId)
        {
            model.QryApplyType = DictionaryCacheHelper.GetDictionaryNameById(SR.ConsignmentApply_Order_Type, "DealerConsignmentApply");//申请但类型
            DataSet dsApply = DtBll.SelecConsignmentApplyDetailsCfnSum(InstanceId.ToString());
            if (dsApply.Tables[0].Rows.Count > 0)
            {
                model.Qrynumber = dsApply.Tables[0].Rows[0]["Qtysum"].ToString();
                model.QryTaoteprice = dsApply.Tables[0].Rows[0]["Pricesum"].ToString();
            }
            var cbproline = header.ProductLineId == null ? "" : header.ProductLineId.ToString();
            model.Qrycbproline = new KeyValue(cbproline, "");
            if (cbproline != string.Empty)
            {
                if (header.OrderStatus == ConsignmentOrderType.Draft.ToString())
                {

                    model.LstcbHospital = JsonHelper.DataTableToArrayList(HospatBindata(cbproline, header.DmaId.Value.ToString()).Tables[0]);
                    string cbHospital = header.HospitalId == null ? "" : header.HospitalId.ToString();
                    model.QrycbHospital = new KeyValue(cbHospital, header.HospitalName);
                }
                else
                {
                    model.cbHospitalHidden = true;

                }
            }
            else
            {
                model.LstcbHospital = JsonHelper.DataTableToArrayList(HospatBindata(Guid.Empty.ToString(), "").Tables[0]);//初始化医院cb
            }
            if (DealerId == string.Empty && header.ProductLineId != null)
            {
                DealerId = header.ProductLineId.Value.ToString();
            }
            model.LstDealerConsignment = JsonHelper.DataTableToArrayList(CdelaBindata(DealerId, cbproline));

            if (DealerId != null)
            {
                ArrayList ware = new ArrayList();
                ware.AddRange(Bind_SAPWarehouseAddress(new Guid(DealerId)).ToList());
                model.LstSAPWarehouseAddress = ware;
            }
            model.LstProlineDma = JsonHelper.DataTableToArrayList(GetProductLineDma(cbproline));
            model.QrySubmitDate = header.SubmitDate == null ? "" : header.SubmitDate.ToString();
            model.QryApplyNo = header.OrderNo == null ? "" : header.OrderNo;
            model.QryDelayState = DictionaryCacheHelper.GetDictionaryNameById(SR.CONST_Delay_Status, header.DelayOrderStatus == null ? "" : header.DelayOrderStatus);
            model.QryOrderState = DictionaryCacheHelper.GetDictionaryNameById(SR.ConsignmentApply_Status, header.OrderStatus == null ? "" : header.OrderStatus); ;
            model.QryConsignment = header.Reason;
            model.QryRemark = header.Remark;
            model.QrySalesName = header.SalesName;
            model.QrySalesEmail = header.SalesEmail;
            model.QrySalesPhone = header.SalesPhone;
            model.QryConsignee = header.Consignee;
            model.QryTexthospitalname = header.SendHospital;
            model.QryHospitalAddress = header.SendAddress;
            model.QrycbSAPWarehouseAddress = new KeyValue(header.ShipToAddress, "");
            model.QryConsigneePhone = header.ConsigneePhone;
            if (header.Rdd != null)
            {
                model.QrydfRDD = header.Rdd.Value.ToString();
            }
            model.QryNumberDays = header.CmConsignmentDay.ToString();
            model.QryDelaytimes = header.DelayDelayTime == null ? "" : header.DelayDelayTime.ToString();
            model.QryBeginData = !header.CmStartDate.HasValue ? "" : header.CmStartDate.Value.ToString("yyyy-MM-dd");
            model.QryEndData = !header.CmEndDate.HasValue ? "" : header.CmEndDate.Value.ToString("yyyy-MM-dd");

            if (header.IsFixedMoney.HasValue)
            {
                model.QryIsControlAmount = header.IsFixedMoney.Value ? "是" : "否";
            }
            if (header.IsFixedQty.HasValue)
            {
                model.QryIsControlNumber = header.IsFixedQty.Value ? "是" : "否";
            }
            if (header.IsUseDiscount.HasValue)
            {
                model.QryIsDiscount = header.IsUseDiscount.Value ? "是" : "否";
            }
            if (header.Iskb.HasValue)
            {
                model.QryIsKB = header.Iskb.Value ? "是" : "否";
            }

            model.hidProductLine = header.ProductLineId.HasValue ? header.ProductLineId.Value.ToString() : "";
            model.HospId = header.HospitalId == null ? "" : header.HospitalId.Value.ToString();
            model.txtRuleId = header.CmId == null ? "" : header.CmId.ToString();
            model.txtConsignmentRuleId = header.CmConsignmentName;
            model.hidorderState = header.OrderStatus;

            model.hidConsignment = header.CmId.ToString();
            model.hidUpdateDate = header.UpdateDate.ToString();

            if (!string.IsNullOrEmpty(header.ConsignmentFrom))
            {
                model.hidChanConsignment = header.ConsignmentFrom;

            }
            else
            {
                model.hidChanConsignment = "Bsc";

            }
            string DivisionCode = string.Empty;
            //产品线下的销售
            if (!string.IsNullOrEmpty(cbproline))
            {
                model.LstSalesRepStor = JsonHelper.DataTableToArrayList(DealerConsignmentStoreBindata(cbproline, out DivisionCode, model.QryDealerId));
            }
            else
            {

                model.LstSalesRepStor = JsonHelper.DataTableToArrayList(DealerConsignmentStoreBindata(Guid.Empty.ToString(), out DivisionCode, model.QryDealerId));//初始化销售cb
            }
            model.hidDivisionCode = DivisionCode;

            int totalCount = 0;
            DataTable dtResult = DtBll.SelectConsignmentApplyProList(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
            model.RstResultList = JsonHelper.DataTableToArrayList(dtResult);

            DataTable dtLog = new PurchaseOrderBLL().QueryPurchaseOrderLogByHeaderId(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
            model.RstLogDetail = JsonHelper.DataTableToArrayList(dtLog);
        }
        public DataTable DealerConsignmentStoreBindata(string ProlineId, out string DivisionCode,string DmaID="")
        {
            DivisionCode = "";
            DataSet ds = bll.GetProductLineVsDivisionCode(ProlineId);
            DataSet SalesRepDs;
            string code = string.Empty;
            if (ds.Tables[0].Rows.Count > 0)
            {

                code = ds.Tables[0].Rows[0]["DivisionCode"].ToString();
                DivisionCode = code;
            }

            SalesRepDs = bll.GetDealerSaleByPL(ProlineId,DmaID);//bll.GetDealerSale(code);
            if (SalesRepDs != null)
                return SalesRepDs.Tables[0];
            else
                return new DataTable();
        }

        public DataTable GetProductLineDma(string cbproline)
        {
            DataSet ds = new DataSet();
            if (!string.IsNullOrEmpty(cbproline))
            {
                ds = DtBll.SelectProductLineDma(cbproline);
                if (ds.Tables.Count > 0)
                    return ds.Tables[0];
                else
                    return new DataTable();
            }
            else
                return new DataTable();
        }
        public virtual IList<SapWarehouseAddress> Bind_SAPWarehouseAddress(Guid dealerId)
        {
            IRoleModelContext context = RoleModelContext.Current;

            Warehouses business = new Warehouses();
            //取得经销商的所有仓库
            IList<SapWarehouseAddress> list = business.QueryForWarehouse(dealerId);

            if (list == null)
                list = new List<SapWarehouseAddress>();
            return list;
        }
        /// <summary>
        /// 绑定经销商合同
        /// </summary>
        /// <param name="DealerId"></param>
        /// <param name="cbprolineId"></param>
        /// <returns></returns>
        private DataTable CdelaBindata(string DealerId, string cbprolineId)
        {
            Hashtable table = new Hashtable();
            DataSet ds = new DataSet();
            IConsignmentDealerBLL CdelaBll = new ConsignmentDealerBLL();
            if (DealerId != string.Empty)
            {
                table.Add("DealerId", DealerId);
                table.Add("Status", "Completed");
                table.Add("ProductLineId", cbprolineId == "" ? Guid.Empty.ToString() : cbprolineId);
                //获取符合条件的寄售合同
                //DataSet ds = CdelaBll.GetConsignmentDealer(table);
                ds = CdelaBll.GetConsignmentContractDealer(table);
            }
            if (ds != null)
                return ds.Tables[0];
            else
                return null;
        }
        public DataSet HospatBindata(string ProductLine, string HiDmaId)
        {
            DealerMasters dm = new DealerMasters();
            Hashtable table = new Hashtable();
            table.Add("DealerId", string.IsNullOrEmpty(HiDmaId) ? Guid.Empty.ToString() : HiDmaId);
            if (!string.IsNullOrEmpty(ProductLine))
            {
                table.Add("ProductLine", ProductLine);
            }
            table.Add("ShipmentDate", DateTime.Now);
            DataSet ds = dm.SelectHospitalForDealerByShipmentDate(table);
            return ds;
        }
        public ConsignmentApplyHeader NewConshead(Guid InstanceId)
        {
            ConsignmentApplyHeader header = new ConsignmentApplyHeader();
            header.Id = InstanceId;
            header.DmaId = RoleModelContext.Current.User.CorpId.Value;
            header.OrderStatus = "Draft";
            header.CreateUser = new Guid(RoleModelContext.Current.User.Id);
            header.CreateDate = DateTime.Now;
            bll.AddHeader(header);
            return header;
        }
        /// <summary>
        /// 修改产品线，更新表单等数据
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO SetConsignment(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                //ClearConsignmentinfo();
                SetConsignmentinfo(model);
                //SetAddCfnSetBtnHidden();
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
        /// 产品来源修改
        /// </summary>
        /// <param name="model"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO ChanConsignmentFrom(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                bool result = DtBll.HeaderDtcfn(InstanceId);
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
        /// 修改产品线，更新表单等数据
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO ChangeProductLine(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                string DivisionCode = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);

                //更换产品线，删除订单原产品组下的所有产品
                bool result = DtBll.HeaderDtcfn(InstanceId);
                model.LstDealerConsignment = JsonHelper.DataTableToArrayList(CdelaBindata(model.QryDealerId, model.Qrycbproline.Key));

                //清空寄售规则
                //txtRule.SelectedItem.Value = string.Empty;
                //cbSale.SelectedItem.Value = string.Empty;
                //ClearConsignmentinfo();
                //ClearSaleInfo();
                SetConsignmentinfo(model);
                //变更产品线下的销售
                model.LstSalesRepStor = JsonHelper.DataTableToArrayList(DealerConsignmentStoreBindata(model.Qrycbproline.Key, out DivisionCode, model.QryDealerId));
                //获取产品线下的经销商
                model.LstProlineDma = JsonHelper.DataTableToArrayList(GetProductLineDma(model.Qrycbproline.Key));
                //获取产品线想的医院
                DataSet ds = HospatBindata(model.Qrycbproline.Key, model.QryDealerId);

                model.LstcbHospital = JsonHelper.DataTableToArrayList(ds == null ? new DataTable() : ds.Tables[0]);
                //SetAddCfnSetBtnHidden();
                //更新Virtual DC    
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public void SetConsignmentinfo(ConsignmentApplyHeaderInfoVO model)
        {
            if (model.QryRule != null)
            {
                if (!string.IsNullOrEmpty(model.QryRule.Key.ToSafeString()))
                {
                    ContractHeaderPO Mast = ConMastBll.GetContractHeaderPOById((new Guid(model.QryRule.Key)));

                    if (Mast != null)
                    {
                        model.QryNumberDays = Mast.CCH_ConsignmentDay.ToString();
                        model.QryDelaytimes = Mast.CCH_DelayNumber.ToString();
                        model.QryIsControlAmount = Mast.CCH_IsFixedMoney.Value ? "是" : "否";
                        model.QryIsControlNumber = Mast.CCH_IsFixedQty.Value ? "是" : "否";
                        model.QryIsKB = Mast.CCH_IsKB.Value ? "是" : "否";
                        model.QryIsDiscount = Mast.CCH_IsUseDiscount.Value ? "是" : "否";

                        if (Mast.CCH_BeginDate != null)
                        {
                            model.QryBeginData = Mast.CCH_BeginDate.Value.ToString("yyyy-MM-dd");
                        }
                        if (Mast.CCH_EndDate != null)
                        {
                            model.QryEndData = Mast.CCH_EndDate.Value.ToString("yyyy-MM-dd");
                        }
                    }
                }
            }
        }
        #region 页面事件

        /// <summary>
        /// 刷新数据
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO RefershHeadData(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                //产品明细
                DataTable dtResult = DtBll.SelectConsignmentApplyProList(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstResultList = JsonHelper.DataTableToArrayList(dtResult);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        /// <summary>
        /// 修改医院触发
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO HospitChange(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.QrycbHospital.ToSafeString()))
                {
                    DataSet ds = bll.SelectHospitSale(model.QrycbHospital.Key, model.hidDivisionCode);
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        model.SaleSelectedId = ds.Tables[0].Rows[0]["Id"].ToString();
                    }
                    else
                    {
                        model.SaleSelectedId = "";
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
        /// 删除产品明细
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO DeleteItem(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                bool result = DtBll.DeleteCfn(new Guid(model.PlineItemId));
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
        /// 更新产品明细
        /// </summary>
        /// <param name="ItemId"></param>
        /// <param name="qty"></param>
        /// <param name="cfnPrice"></param>
        /// <param name="upn"></param>
        public ConsignmentApplyHeaderInfoVO UpdateItem(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {

                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;

                Guid detailId = new Guid(model.PlineItemId);
                ConsignmentApplyDetails detail = new ConsignmentApplyDetails();
                detail = DtBll.GetConsignmentApplyDetailsSing(detailId);
                if (!string.IsNullOrEmpty(model.RequiredQty))
                {
                    detail.Qty = Convert.ToDecimal(model.RequiredQty);
                }
                if (!string.IsNullOrEmpty(model.cfnPrice))
                {
                    detail.Price = Convert.ToDecimal(model.cfnPrice);
                }
                detail.Amount = detail.Qty * detail.Price;
                bool result = DtBll.UpdateConsignmentApplyDetails(detail);
                rtnVal = "Success";

                model.hidRtnVal = rtnVal;
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

        #region 按钮事件
        public ConsignmentApplyHeaderInfoVO DelayClick(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                bool result = false;
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                string errorMsg = string.Empty;
                Guid InstanceId = new Guid(model.InstanceId);
                ConsignmentApplyHeader header = new ConsignmentApplyHeader();
                header = bll.GetConsignmentApplyHeaderSing(InstanceId);
                if (bll.SelectSalesSing(header.SalesName, header.SalesEmail))
                {
                    if (header.DelayOrderStatus == ConsignmentDelayStatus.Submitted.ToString())
                    {
                        rtnVal = "Error";
                        rtnMsg = "状态已更新，请重新获取!";
                    }
                    else if (header.DelayDelayTime > 0)
                    {

                        decimal totalAmount = 0;
                        DataSet ds = bll.SelecPOReceiptPriceSum(InstanceId.ToString());

                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            totalAmount = ds.Tables[0].Rows[0]["TotalAmount"] == DBNull.Value ? 0 : decimal.Parse(ds.Tables[0].Rows[0]["TotalAmount"].ToString());
                        }
                        //延期申请时，库存产品总金额若为0，那么不允许申请延期
                        if (totalAmount == 0)
                        {
                            rtnVal = "Error";
                            rtnMsg = "库存为0不允许申请延期!";
                        }
                        else
                        {
                            header.DelayOrderStatus = ConsignmentDelayStatus.Submitted.ToString();
                            header.DelaySubmitUser = new Guid(RoleModelContext.Current.User.Id);
                            header.DelaySubmitDate = DateTime.Now;
                            result = bll.SetDelayStatus(header, out errorMsg);
                        }
                    }
                    else
                    {
                        rtnVal = "Error";
                        rtnMsg = "延期次数已用完!";
                    }
                }
                else
                {
                    errorMsg = "销售已不存在，申请延期失败";
                }
                if (!string.IsNullOrEmpty(errorMsg))
                {
                    rtnVal = "Error";
                    rtnMsg = errorMsg;
                }

                model.hidRtnVal = rtnVal;
                model.hidRtnMsg = rtnMsg;
                if (result)
                {
                    model.hidIsSaved = true;
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
        /// 提交验证表单，是否允许提交
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO CheckSubmit(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                Guid InstanceId = new Guid(model.InstanceId);
                ContractHeaderPO Mast = ConMastBll.GetContractHeaderPOById((new Guid(model.QryRule.Key)));

                IConsignmentMasterBLL Mastbll = new ConsignmentMasterBLL();
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                string RtnRegMsg = string.Empty;
                string Texthospitalname = string.Empty;
                string HospitalAddress = string.Empty;

                //DataSet ds = Mastbll.SelecConsignmentdatetimeby(ht);
                if (Mast != null)
                {

                    if (Convert.ToDateTime(Mast.CCH_BeginDate) <= DateTime.Now && Convert.ToDateTime(Mast.CCH_EndDate) > DateTime.Now)
                    {

                        ConsignmentApplyHeader header = null;
                        header = bll.GetConsignmentApplyHeaderSing(InstanceId);
                        if (header != null)
                        {
                            //  hidorderState.Text = header.OrderStatus;
                            if (header.OrderStatus.Equals(ConsignmentOrderType.Draft.ToString()))
                            {

                                bool result = CdelaBll.ChcekCfnSumbit(InstanceId, _context.User.CorpId.Value, model.Qrycbproline.Key, model.QryRule.Key, out rtnVal, out rtnMsg, out RtnRegMsg);//, out Texthospitalname,out HospitalAddress

                            }
                            else
                            {
                                rtnVal = "Error";
                                rtnMsg = "单据已被改变，请重新修改！";
                            }
                        }
                    }
                    else
                    {
                        rtnVal = "Error";
                        rtnMsg = model.QryRule.Value + "不在有效期范围内!";
                    }
                }
                model.hidRtnVal = rtnVal;
                model.hidRtnMsg = rtnMsg.Replace("$$", "<BR/>");
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
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO Submit(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                string resMsg = string.Empty;
                Guid InstanceId = new Guid(model.InstanceId);
                //List<FormInfoEditRow> editRow = JsonConvert.DeserializeObject<List<FormInfoEditRow>>(model.EditRows);
                //foreach (FormInfoEditRow item in editRow)
                //{
                //    Guid PlineItemId = new Guid(item.Id);
                //    UpdateItem(item.Id, item.RequiredQty, item.cfnPrice, "");
                //}

                AutoNumberBLL auto = new AutoNumberBLL();
                ConsignmentApplyHeader Header = GetFormValue(model, InstanceId);
                if (bll.SelectSalesSing(Header.SalesName, Header.SalesEmail))
                {
                    //调整为获取寄售合同数据绑定
                    //ContractHeaderPO ComHeader = ConMastBll.GetContractHeaderPOById((new Guid(txtRule.SelectedItem.Value)));
                    ContractHeaderPO ComHeader = ConMastBll.GetContractHeaderPOById(new Guid(model.QryRule.Key));
                    if (ComHeader != null)
                    {
                        Header.CmConsignmentDay = ComHeader.CCH_ConsignmentDay;
                        Header.CmDelayNumber = ComHeader.CCH_DelayNumber;
                        Header.CmStartDate = ComHeader.CCH_BeginDate;
                        Header.CmEndDate = ComHeader.CCH_EndDate;
                        Header.DelayDelayTime = ComHeader.CCH_DelayNumber;
                        Header.IsFixedMoney = ComHeader.CCH_IsFixedMoney;
                        Header.IsFixedQty = ComHeader.CCH_IsFixedQty;
                        Header.Iskb = ComHeader.CCH_IsKB;
                        Header.IsUseDiscount = ComHeader.CCH_IsUseDiscount;
                        DateTime time = DateTime.Now;
                        Header.SubmitDate = time;
                        Header.UpdateDate = time;

                        Header.OrderStatus = ConsignmentOrderType.Submitted.ToString();
                    }
                    bool result = bll.Sumbit(Header, out resMsg);

                    if (!result)
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("保存失败");
                    }
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("销售已不存在，请重新选择");
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
        public ConsignmentApplyHeaderInfoVO SaveDraft(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                var status = false;
                Guid InstanceId = new Guid(model.InstanceId);
                //List<FormInfoEditRow> editRow = JsonConvert.DeserializeObject<List<FormInfoEditRow>>(model.EditRows);
                //foreach (FormInfoEditRow item in editRow)
                //{
                //    Guid PlineItemId = new Guid(item.Id);
                //    UpdateItem(item.Id, item.RequiredQty, item.cfnPrice, "");
                //}
                ConsignmentApplyHeader Header = GetFormValue(model, InstanceId);

                if (!string.IsNullOrEmpty(model.QryRule.ToSafeString()))
                {
                    if (!string.IsNullOrEmpty(model.QryRule.Key))
                        status = true;
                }
                if (status)//寄售合同不为空
                {
                    //调整为获取寄售合同数据绑定
                    ContractHeaderPO Mast = ConMastBll.GetContractHeaderPOById(new Guid(model.QryRule.Key));

                    Header.IsFixedMoney = Mast.CCH_IsFixedMoney;
                    Header.IsFixedQty = Mast.CCH_IsFixedQty;
                    Header.Iskb = Mast.CCH_IsKB;
                    Header.IsUseDiscount = Mast.CCH_IsUseDiscount;
                    Header.CmStartDate = Mast.CCH_BeginDate;
                    Header.CmEndDate = Mast.CCH_EndDate;
                    Header.DelayDelayTime = Mast.CCH_DelayNumber;
                    Header.CmDelayNumber = Mast.CCH_DelayNumber;
                    Header.CmConsignmentDay = Mast.CCH_ConsignmentDay;
                }
                else
                {
                    Header.IsFixedMoney = null;
                    Header.IsFixedQty = null;
                    Header.Iskb = null;
                    Header.IsUseDiscount = null;
                    Header.CmStartDate = null;
                    Header.CmEndDate = null;
                    Header.DelayDelayTime = null;
                    Header.CmDelayNumber = null;
                    Header.CmConsignmentDay = null;
                }
                DateTime time = DateTime.Now;
                Header.UpdateDate = time;
                bool result = bll.SaveDraft(Header);
                if (result)
                {
                    model.hidIsSaved = true;
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
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO DeleteDraft(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                Guid InstanceId = new Guid(model.InstanceId);
                bool result = bll.DeltetDraft(InstanceId);
                if (result)
                {
                    model.hidIsSaved = true;
                }
                return model;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ConsignmentApplyHeader GetFormValue(ConsignmentApplyHeaderInfoVO model, Guid InstanceId)
        {
            ConsignmentApplyHeader Header = bll.GetConsignmentApplyHeaderSing(InstanceId);
            Header.DmaId = string.IsNullOrEmpty(model.QryDealerId.ToSafeString()) ? null as Guid? : new Guid(model.QryDealerId.ToString());
            Header.ProductLineId = string.IsNullOrEmpty(model.Qrycbproline.ToSafeString()) ? null as Guid? : string.IsNullOrEmpty(model.Qrycbproline.Key) ? null as Guid? : new Guid(model.Qrycbproline.Key);
            Header.OrderType = "DealerConsignmentApply";
            Header.SalesName = model.QrySalesName;
            Header.SalesEmail = model.QrySalesEmail;
            Header.SalesPhone = model.QrySalesPhone;
            Header.Consignee = model.QryConsignee;
            Header.ConsigneePhone = model.QryConsigneePhone;
            Header.SendAddress = model.QryHospitalAddress;//主单信息中的医院名称
            Header.SendHospital = model.QryTexthospitalname;
            if (model.QrydfRDD != null && Convert.ToDateTime(model.QrydfRDD) > DateTime.MinValue)
            {
                Header.Rdd = Convert.ToDateTime(model.QrydfRDD);
            }
            else
            {
                Header.Rdd = null;
            }
            Header.ShipToAddress = model.QrycbSAPWarehouseAddress.Key;
            Header.Remark = model.QryRemark;
            Header.Reason = model.QryConsignment;
            if (!string.IsNullOrEmpty(model.QryRule.ToSafeString()))
            {
                if (!string.IsNullOrEmpty(model.QryRule.Key))
                {
                    Header.CmId = new Guid(model.QryRule.Key);
                    Header.CmConsignmentName = model.QryRule.Value;
                }
            }
            else
            {
                Header.CmId = null;
                Header.CmConsignmentName = null;
            }
            if (!string.IsNullOrEmpty(model.QryNumberDays))
            {
                Header.CmConsignmentDay = int.Parse(model.QryNumberDays);
            }
            if (!string.IsNullOrEmpty(model.QrycbSuorcePro.ToSafeString()))
            {
                if (!string.IsNullOrEmpty(model.QrycbSuorcePro.Key))
                    Header.ConsignmentId = new Guid(model.QrycbSuorcePro.Key);
            }
            else
            {
                Header.ConsignmentId = null;
            }
            Header.CmDelayNumber = int.Parse(string.IsNullOrEmpty(model.QryDelaytimes) ? "0" : model.QryDelaytimes);
            Header.DelayDelayTime = int.Parse(string.IsNullOrEmpty(model.QryDelaytimes) ? "0" : model.QryDelaytimes);

            if (!string.IsNullOrEmpty(model.QryBeginData))
            {
                Header.CmStartDate = Convert.ToDateTime(model.QryBeginData);
            }
            if (!string.IsNullOrEmpty(model.QryEndData))
            {
                Header.CmEndDate = Convert.ToDateTime(model.QryEndData);
            }

            if (!string.IsNullOrEmpty(model.QrycbHospital.ToSafeString()))
            {
                if (!string.IsNullOrEmpty(model.QrycbHospital.Key))
                {
                    Header.HospitalId = new Guid(model.QrycbHospital.Key);
                    Header.HospitalName = model.QrycbHospital.Value;
                }
            }
            Header.ConsignmentFrom = model.QrycbProductsource.Key;//产品来源

            //添加新寄售合同字段
            Header.IsFixedMoney = (string.IsNullOrEmpty(model.QryIsControlAmount) ? "" : model.QryIsControlAmount).Equals("是") ? true : false;
            Header.IsUseDiscount = (string.IsNullOrEmpty(model.QryIsDiscount) ? "" : model.QryIsDiscount).Equals("是") ? true : false;
            Header.IsFixedQty = (string.IsNullOrEmpty(model.QryIsControlNumber) ? "" : model.QryIsControlNumber).Equals("是") ? true : false;
            Header.Iskb = (string.IsNullOrEmpty(model.QryIsKB) ? "" : model.QryIsKB).Equals("是") ? true : false;

            return Header;
        }
        #endregion


        #region 弹窗页面添加

        //退回，待开发
        public ConsignmentApplyHeaderInfoVO DoAddItems(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                IConsignmentDealerBLL Bll = new ConsignmentDealerBLL();
                string param = model.DealerParams;
                param = param.Substring(0, param.Length - 1);
                bool result = Bll.InsertDealer(param.Split(',').ToArray(), InstanceId.ToString());
                if (result)
                {
                    int totalCount = 0;
                    //  DataTable dtDealer = consignment.SelectConsignmentMasterByealer(InstanceId.ToString(), 0, int.MaxValue, out totalCount).Tables[0];
                    // model.RstDealerList = JsonHelper.DataTableToArrayList(dtDealer);
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
        /// 增加产品
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO DoAddProductItems(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                string param = model.DealerParams;
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                (new ConsignmentApplyDetailsBLL()).AddSpecialCfn(InstanceId, new Guid(model.QryDealerId), param.Substring(0, param.Length - 1), model.QrySpecialPrice, model.QryOrderType, out rtnVal, out rtnMsg);

                DataTable dtResult = DtBll.SelectConsignmentApplyProList(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstResultList = JsonHelper.DataTableToArrayList(dtResult);
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
        /// 产品组套添加功能
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO DoAddCfnSet(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                Guid InstanceId = new Guid(model.InstanceId);
                Guid DealerId = new Guid(model.QryDealerId);
                string parms = model.DealerParams.Substring(0, model.DealerParams.Length - 1);
                (new ConsignmentApplyDetailsBLL()).AddCfnSet(InstanceId, DealerId, parms, "", out rtnVal, out rtnMsg);
                if (rtnMsg.Length > 0 || rtnVal != "Success")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnMsg);
                }
                int totalCount = 0;
                DataTable dtResult = DtBll.SelectConsignmentApplyProList(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstResultList = JsonHelper.DataTableToArrayList(dtResult);
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
        /// 添加退货单产品
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentApplyHeaderInfoVO AddOtherdealersCfn(ConsignmentApplyHeaderInfoVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                Guid InstanceId = new Guid(model.InstanceId);
                string DealerId = model.QryDealerId;
                string parms = model.DealerParams.Substring(0, model.DealerParams.Length - 1);
                (new ConsignmentApplyDetailsBLL()).AddConsignmenfnInventCfn(InstanceId, DealerId, parms, model.QryOrderType, out rtnVal, out rtnMsg);
                if (rtnMsg.Length > 0 || rtnVal != "Success")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnMsg);
                }
                //查询 产品明细
                int totalCount = 0;
                DataTable dtResult = DtBll.SelectConsignmentApplyProList(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstResultList = JsonHelper.DataTableToArrayList(dtResult);
                model.IsSuccess = true;
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




