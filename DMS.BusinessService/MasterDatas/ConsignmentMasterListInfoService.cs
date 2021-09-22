using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess.ContractElectronic;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.MasterDatas;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.MasterDatas
{
    public class ConsignmentMasterListInfoService : ABaseBusinessService
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        private IConsignmentMasterBLL consignment = new ConsignmentMasterBLL();
        private IConsignmentDealerBLL Dell = new ConsignmentDealerBLL();
        public const string DMA_ID = "FB62D945-C9D7-4B0F-8D26-4672D2C728B7";
        public ConsignmentMasterListInfoVO Init(ConsignmentMasterListInfoVO model)
        {
            try
            {
                string DealerId = string.Empty;
                ConsignmentMaster header = null;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                model.IsNewApply = (InstanceId == Guid.Empty);
                if (model.IsNewApply)
                {
                    header = GetNewConsignmentMaster();
                }
                else
                {
                    header = consignment.SelectConsignmentMasterById(InstanceId);
                }
                if (header != null)
                {
                    //表头信息
                    model.InstanceId = header.Id.ToString();
                    model.EntityModel = JsonHelper.Serialize(header);
                    model.LstBu = base.GetProductLine();
                    model.LstType = new ArrayList(DictionaryHelper.GetDictionary(SR.Const_Consignment_Rule).ToArray());
                    model.LstStatus = new ArrayList(DictionaryHelper.GetDictionary(SR.Const_Consignment_Type).ToArray());
                    int totalCount = 0;
                    //产品明细
                    DataTable dtProduct = consignment.GetConsignmentCfnById(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
                    //经销商
                    DataTable dtDealer = consignment.SelectConsignmentMasterByealer(InstanceId.ToString(), 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstDealerList = JsonHelper.DataTableToArrayList(dtDealer);

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

        private ConsignmentMaster GetNewConsignmentMaster()
        {
            ConsignmentMaster header = new ConsignmentMaster();
            header.Id = Guid.NewGuid();
            header.OrderStatus = PurchaseOrderStatus.Draft.ToString();
            header.CreateUser = new Guid(RoleModelContext.Current.User.Id);
            header.CreateDate = DateTime.Now;

            consignment.InsertPurchaseOrderHeader(header);
            return header;
        }

        #region 按钮事件

        //删除产品线
        public ConsignmentMasterListInfoVO DeletePlineItem(ConsignmentMasterListInfoVO model)
        {
            try
            {
                bool result = Dell.DelletePling(new Guid(model.PlineItemId));
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        //修改产品线
        public ConsignmentMasterListInfoVO ChangeProductLine(ConsignmentMasterListInfoVO model)
        {
            Guid InstanceId = new Guid(model.InstanceId);
            //更换产品组，删除订单原产品组下的所有产品
            bool result = consignment.DeleteCfns(InstanceId);
            //删除原有销售
            DeleteConsignmentDealer(InstanceId);
            return model;
        }
        public void DeleteConsignmentDealer(Guid InstanceId)
        {
            consignment.DeleteConsignmentDealerby(InstanceId.ToString());
        }

        /// <summary>
        /// 刷新数据
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentMasterListInfoVO RefershHeadData(ConsignmentMasterListInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                //产品明细
                DataTable dtProduct = consignment.GetConsignmentCfnById(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
                //经销商
                DataTable dtDealer = consignment.SelectConsignmentMasterByealer(InstanceId.ToString(), 0, int.MaxValue, out totalCount).Tables[0];
                model.RstDealerList = JsonHelper.DataTableToArrayList(dtDealer);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }
        /// <summary>
        /// 删除经销商
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentMasterListInfoVO DeleteItem(ConsignmentMasterListInfoVO model)
        {
            try
            {
                bool result = Dell.DeleteDealer(new Guid(model.DealerItemId));
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
        /// 更新产品线数量
        /// </summary>
        /// <param name="PlineItemId"></param>
        /// <param name="PlineItemNum"></param>
        public ConsignmentMasterListInfoVO UpdateItem(ConsignmentMasterListInfoVO model)
        {
            try
            {
                Guid PlineItemId = string.IsNullOrEmpty(model.PlineItemId) ? Guid.Empty : new Guid(model.PlineItemId);
                string PlineItemNum = string.IsNullOrEmpty(model.RequiredQty) ? "1" : model.RequiredQty;
                ConsignmentCfn detail = consignment.GetConsignmentCfnById(PlineItemId);
                if (!string.IsNullOrEmpty(PlineItemNum))
                {
                    detail.Qty = Convert.ToDecimal(PlineItemNum);
                    detail.Amount = detail.Qty * detail.Price;
                }
                bool result = consignment.UpdateCfn(detail);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }
        /// <summary>
        /// 保存草稿
        /// </summary>
        public ConsignmentMasterListInfoVO SaveDraft(ConsignmentMasterListInfoVO model)
        {
            try
            {
                ConsignmentMasterListInfo entity = JsonConvert.DeserializeObject<ConsignmentMasterListInfo>(model.EntityModel);
                ConsignmentMaster header = GetFormValue(entity);
                bool result = consignment.SaveDraft(header);
                if (!result)
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
        public ConsignmentMasterListInfoVO DeleteDraft(ConsignmentMasterListInfoVO model)
        {
            try
            {
                Guid InstanceId = new Guid(model.InstanceId);
                bool result = consignment.DeleteDraft(InstanceId);
                if (!result)
                {
                    model.IsSuccess = true;
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
        /// 提交验证
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentMasterListInfoVO CheckedSubmit(ConsignmentMasterListInfoVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                string RtnRegMsg = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                bool result = consignment.CheckedSubmit(InstanceId, model.QryBu, model.QryConsignmentName.Trim(), out rtnVal, out rtnMsg, out RtnRegMsg);
                model.hidRtnVal = rtnVal;
                model.hidRtnMsg = rtnMsg;
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
        public ConsignmentMasterListInfoVO Submit(ConsignmentMasterListInfoVO model)
        {
            try
            {
                ConsignmentMasterListInfo entity = JsonConvert.DeserializeObject<ConsignmentMasterListInfo>(model.EntityModel);
                ConsignmentMaster header = GetFormValue(entity);
                bool result = consignment.Submit(header, DMA_ID);
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
        /// 撤销
        /// </summary>
        public ConsignmentMasterListInfoVO Revoke(ConsignmentMasterListInfoVO model)
        {
            try
            {
                Guid InstanceId = new Guid(model.InstanceId);
                bool result = consignment.RevokeOrder(InstanceId);
                if (result)
                {
                    //订单已撤销
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("订单已撤销");
                }
                else
                {
                    //订单无法撤销
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("订单无法撤销，可能订单状态已经改变，请刷新！");
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

        public ConsignmentMaster GetFormValue(ConsignmentMasterListInfo result)
        {
            ConsignmentMaster header = consignment.SelectConsignmentMasterById(new Guid(result.InstanceId));
            header.ProductLineId = string.IsNullOrEmpty(result.ProductLineId) ? null as Guid? : new Guid(result.ProductLineId);
            header.OrderType = string.IsNullOrEmpty(result.OrderType) ? "" : result.OrderType;
            //header.TerritoryCode = this.cbTerritory.SelectedItem.Value;
            //汇总信息
            header.Remark = result.Remark;
            if (result.ConsignmentDay != string.Empty)
            {
                header.ConsignmentDay = Convert.ToInt32(result.ConsignmentDay);
            }

            header.ConsignmentName = result.ConsignmentName.Trim();
            header.DelayTime = string.IsNullOrEmpty(result.DelayTime) ? 0 : Convert.ToInt32(result.DelayTime);
            if (!string.IsNullOrEmpty(result.StartDate))
            {
                header.StartDate = Convert.ToDateTime(result.StartDate);
            }
            if (!string.IsNullOrEmpty(result.EndDate))
            {
                header.EndDate = Convert.ToDateTime(result.EndDate);
            }

            header.CreateDate = DateTime.Now;
            header.CreateUser = new Guid(RoleModelContext.Current.User.Id);

            return header;
        }
        #endregion


        #region 弹窗页面添加

        //添加经销商
        public ConsignmentMasterListInfoVO DoAddItems(ConsignmentMasterListInfoVO model)
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
                    DataTable dtDealer = consignment.SelectConsignmentMasterByealer(InstanceId.ToString(), 0, int.MaxValue, out totalCount).Tables[0];
                    model.RstDealerList = JsonHelper.DataTableToArrayList(dtDealer);
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
        //增加产品
        public ConsignmentMasterListInfoVO DoAddProductItems(ConsignmentMasterListInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                string param = model.DealerParams;
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                (new ConsignmentMasterBLL()).AddCfn(InstanceId, new Guid(model.QryBu), param.Substring(0, param.Length - 1), out rtnVal, out rtnMsg);
                if (rtnMsg.Length > 0 || rtnVal != "Success")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnMsg);
                }
                DataTable dtProduct = consignment.GetConsignmentCfnById(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
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
        /// 产品组套添加功能
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public ConsignmentMasterListInfoVO DoAddCfnSet(ConsignmentMasterListInfoVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                string param = model.DealerParams;
                string parms = param.Substring(0, param.Length - 1);
                (new ConsignmentMasterBLL()).AddCfnSet(InstanceId, parms, "", out rtnVal, out rtnMsg);
                if (rtnMsg.Length > 0 && rtnVal != "Success")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnMsg);
                }
                DataTable dtProduct = consignment.GetConsignmentCfnById(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
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

    }

}
