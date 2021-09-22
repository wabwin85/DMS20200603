using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.ViewModel.Order;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.SessionState;

namespace DMS.BusinessService.Order
{
    public class BatchOrderInitService : IRequiresSessionState
    {
        private IBatchOrderInitBLL business = new BatchOrderInitBLL();

        private IRoleModelContext _context = RoleModelContext.Current;
        public BatchOrderInitVO Init(BatchOrderInitVO model)
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
        public string Query(BatchOrderInitVO model)
        {
            try
            {
                int outCont = 0;
                int start = (model.Page - 1) * model.PageSize;
                if (!model.IsFirstload)
                {
                    DataSet ds = business.QueryBatchOrderInitErrorData(start, model.PageSize, out outCont);
                    model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
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
        /// 导入数据库
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public BatchOrderInitVO ImportDB(BatchOrderInitVO model)
        {
            try
            {
                string importType = "Import";
                string errMsg = string.Empty;
                string IsValid = string.Empty;
                if (business.VerifyBatchOrderInitBLL(importType, out IsValid))
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
