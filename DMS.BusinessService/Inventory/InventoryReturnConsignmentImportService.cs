using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.ViewModel.Inventory;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Inventory
{
    public class InventoryReturnConsignmentImportService
    {
        private InventoryAdjustBLL business = new InventoryAdjustBLL();

        private IRoleModelContext _context = RoleModelContext.Current;
        public InventoryReturnConsignmentImportVO Init(InventoryReturnConsignmentImportVO model)
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
        public string Query(InventoryReturnConsignmentImportVO model)
        {
            try
            {
                IInventoryAdjustBLL bll = new InventoryAdjustBLL();

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                IList<DMS.Model.InventoryReturnConsignmentInit> list = bll.QueryInventoryReturnConsignmentInitErrorData(start, model.PageSize, out outCont);
                model.RstResultList = new ArrayList(list.ToList());

                model.DataCount = outCont;
                model.IsSuccess = true;

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        /// <summary>
        /// 保存
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnConsignmentImportVO Save(InventoryReturnConsignmentImportVO model)
        {
            try
            {
                DMS.Model.InventoryReturnConsignmentInit r = new DMS.Model.InventoryReturnConsignmentInit();
                r.Id = new Guid(model.Id);
                r.Warehouse = model.warehouse;
                r.ArticleNumber = model.articleNumber;
                r.ReturnQty = model.returnQty;
                r.LotNumber = model.lotNumber;
                r.QrCode = model.qrCode;
                r.PurchaseOrderNbr = model.purchaseOrderNbr;
                business.UpdateReturnConsignment(r);
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
        /// 删除
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnConsignmentImportVO Delete(InventoryReturnConsignmentImportVO model)
        {
            try
            {
                business.DeleteConsignmentInit(new Guid(model.Id));
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
        /// 导入数据库
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnConsignmentImportVO ImportDB(InventoryReturnConsignmentImportVO model)
        {
            try
            {
                string importType = "Import";
                string errMsg = string.Empty;
                string IsValid = string.Empty;
                if (business.VerifyInventoryReturnConsignmentInit(importType, out IsValid))
                {
                    if (IsValid == "Success")
                    {
                        if (importType == "Upload")
                        {
                            //ImportButtonDisabled = true;
                            errMsg = "已成功上传文件！";
                        }
                        else
                        {
                            errMsg = "数据导入成功！";
                        }
                    }
                    else if (IsValid == "Error")
                    {
                        errMsg = "数据包含错误！";
                    }
                    else
                    {
                        errMsg = "数据导入异常！";
                    }
                }
                else
                {
                    errMsg = "导入数据过程发生错误！";
                }
                if (IsValid != "Success")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(errMsg);
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

    }
}
