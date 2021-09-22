using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.ViewModel.Order;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.SessionState;

namespace DMS.BusinessService.Order
{
    public class OrderApplyLPImportService: IRequiresSessionState
    {
        private PurchaseOrderBLL business = new PurchaseOrderBLL();

        private IRoleModelContext _context = RoleModelContext.Current;
        public OrderApplyLPImportVO Init(OrderApplyLPImportVO model)
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
        public string Query(OrderApplyLPImportVO model)
        {
            try
            {
                IPurchaseOrderBLL bll = new PurchaseOrderBLL();

                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                if (!model.IsFirstload)
                {
                    IList<DMS.Model.PurchaseOrderInit> list = bll.QueryPurchaseOrderInitErrorData(start, model.PageSize, out outCont);
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
        public OrderApplyLPImportVO Save(OrderApplyLPImportVO model)
        {
            try
            {
                model.ImportButtonDisable = true;//默认禁用
                DMS.Model.PurchaseOrderInit r = new DMS.Model.PurchaseOrderInit();
                r.Id = new Guid(model.Id);
                r.OrderType = model.OrderType;
                r.ArticleNumber = model.articleNumber;
                r.RequiredQty = model.RequiredQty;
                r.LotNumber = model.lotNumber;
                r.Amount = model.Amount;
                r.ProductLine = model.ProductLine;
                r.PointType = model.PointType;
                business.Update(r);

                string IsValid = string.Empty;
                business.VerifyPurchaseOrderInit("Upload", out IsValid);
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
        public OrderApplyLPImportVO Delete(OrderApplyLPImportVO model)
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
        public OrderApplyLPImportVO ImportDB(OrderApplyLPImportVO model)
        {
            try
            {
                string importType = "Import";
                string errMsg = string.Empty;
                string IsValid = string.Empty;
                if (business.VerifyPurchaseOrderInit(importType, out IsValid))
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
