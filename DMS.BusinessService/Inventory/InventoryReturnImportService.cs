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
using System.Web.SessionState;

namespace DMS.BusinessService.Inventory
{
    public class InventoryReturnImportService: IRequiresSessionState
    {
        private InventoryAdjustBLL business = new InventoryAdjustBLL();

        private IRoleModelContext _context = RoleModelContext.Current;
        public InventoryReturnImportVO Init(InventoryReturnImportVO model)
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
        public string Query(InventoryReturnImportVO model)
        {
            try
            {
                IInventoryAdjustBLL bll = new InventoryAdjustBLL();

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                if (!model.IsFirstload)
                {
                    IList<DMS.Model.InventoryReturnInit> list = bll.QueryInventoryReturnInitErrorData(start, model.PageSize, out outCont);
                    model.RstResultList = new ArrayList(list.ToList());
                }
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
        public InventoryReturnImportVO Save(InventoryReturnImportVO model)
        {
            try
            {
                DMS.Model.InventoryReturnInit r = new DMS.Model.InventoryReturnInit();
                r.Id = new Guid(model.Id);
                r.Warehouse = model.warehouse;
                r.ArticleNumber = model.articleNumber;
                r.ReturnQty = model.returnQty;
                r.LotNumber = model.lotNumber;
                r.QrCode = model.qrCode;
                r.PurchaseOrderNbr = model.purchaseOrderNbr;
                business.Update(r);

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
        public InventoryReturnImportVO Delete(InventoryReturnImportVO model)
        {
            try
            {
                business.Delete(new Guid(model.Id));
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
        public InventoryReturnImportVO ImportDB(InventoryReturnImportVO model)
        {
            try
            {
                model.IsSuccess = true;
                string importType = "Import";
                string errMsg = string.Empty;
                string IsValid = string.Empty;
                if (business.VerifyInventoryReturnInit(importType, out IsValid))
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
