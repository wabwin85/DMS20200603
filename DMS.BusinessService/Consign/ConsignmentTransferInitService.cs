using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.ViewModel.Consign;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.SessionState;

namespace DMS.BusinessService.Consign
{
    public class ConsignmentTransferInitService : ABaseBusinessService
    {
        #region Ajax Method
        IConsignmentApplyHeaderBLL bll = new ConsignmentApplyHeaderBLL();
        public string QueryErrorData(ConsignmentTransferInitVO model)
        {
            try
            {
                int totalCount = 0;
                IShipmentBLL business = new ShipmentBLL();
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = bll.SelectConsignmentTransferInitList(start, model.PageSize, out totalCount);

                model.DataCount = totalCount;
                model.IsSuccess = true;

                model.RstInitImportResult = JsonHelper.DataTableToArrayList(ds.Tables[0]);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstInitImportResult, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public ConsignmentTransferInitVO DeleteErrorData(ConsignmentTransferInitVO model)
        {
            try
            {
                bll.ConsignmentTransferDelete(model.DelErrorId.ToSafeString());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public ConsignmentTransferInitVO ImportCorrectData(ConsignmentTransferInitVO model)
        {
            try
            {
                string IsValid = string.Empty;

                if (bll.VerifyConsignmentTransferInit("Import", out IsValid))
                {
                    if (IsValid == "Success")
                    {
                        model.ExecuteMessage.Add("Success");
                    }
                    else if (IsValid == "Error")
                    {
                        model.ExecuteMessage.Add("上传文件中包含错误数据，详情查看列表！");
                    }
                    else
                    {
                        model.ExecuteMessage.Add("数据导入异常！");
                    }
                }
                else
                {
                    model.ExecuteMessage.Add("导入数据过程发生错误！");
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
