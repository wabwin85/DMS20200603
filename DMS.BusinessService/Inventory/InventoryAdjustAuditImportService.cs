using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Collections.Specialized;
using DMS.Common;
using DMS.ViewModel.Consign;
using DMS.ViewModel.Common;
using DMS.DataAccess;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using DMS.Business.DataInterface;
using DMS.Business;
using DMS.Model;
using System.Web.SessionState;
using DMS.ViewModel.Inventory;
using DMS.Common.Common;

namespace DMS.BusinessService.Inventory
{
    public class InventoryAdjustAuditImportService : IRequiresSessionState
    {
        private InventoryAdjustBLL business = new InventoryAdjustBLL();

        private IRoleModelContext _context = RoleModelContext.Current;
        public InventoryAdjustAuditImportVO Init(InventoryAdjustAuditImportVO model)
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
        public string Query(InventoryAdjustAuditImportVO model)
        {
            try
            {
                IInventoryAdjustBLL bll = new InventoryAdjustBLL();

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                if (!model.IsFirstload)
                {
                    IList<DMS.Model.InventoryAdjustInit> list = bll.QueryInventoryAdjustInitErrorData(start, model.PageSize, out outCont);
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
        public InventoryAdjustAuditImportVO Save(InventoryAdjustAuditImportVO model)
        {
            try
            {
                model.ImportButtonDisable = true;//默认禁用
                DMS.Model.InventoryAdjustInit r = new DMS.Model.InventoryAdjustInit();
                r.Id = new Guid(model.Id);
                r.ChineseName = model.ChineseName;
                r.Warehouse = model.Warehouse;
                r.ArticleNumber = model.ArticleNumber;
                r.ReturnQty = model.ReturnQty;
                r.LotNumber = model.LotNumber;
                r.AdjustType = model.AdjustType;
                r.SAPCode = model.SAPCode;
                r.QrCode = model.QrCode;
                business.UpdateAdjust(r);

                string IsValid = string.Empty;
                business.VerifyInventoryAdjustInit("Upload", out IsValid);
                if (IsValid == "Success")
                {
                    model.ImportButtonDisable = false;
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
        /// 删除
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryAdjustAuditImportVO Delete(InventoryAdjustAuditImportVO model)
        {
            try
            {
                business.DeleteAdjust(new Guid(model.Id));
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
        public InventoryAdjustAuditImportVO ImportDB(InventoryAdjustAuditImportVO model)
        {
            try
            {
                string importType = "Import";
                string errMsg = string.Empty;
                string IsValid = string.Empty;
                if (business.VerifyInventoryAdjustInit(importType, out IsValid))
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
                }
                model.ExecuteMessage.Add(errMsg);
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
