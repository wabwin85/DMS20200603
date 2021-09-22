using DMS.Model;
using DMS.DataAccess;
using DMS.Model.ViewModel.InventoryReturn;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Common.Common;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;
using DMS.Common;

namespace DMS.Business
{
    public class InventoryReturnBscService : BaseService
    {
        private static string strDateFormat = "yyyy-MM-dd HH:mm:ss:ffff";
        public InventoryReturnBscVO InitPage(InventoryReturnBscVO model,bool isInit)
        {
            using (InventoryReturnBscDao dao = new InventoryReturnBscDao())
            {
                InventoryReturnBsc obj = dao.GetObject(new Guid(model.AdjId));

                if (obj != null)
                {
                    model.InvoiceNo = string.IsNullOrEmpty(obj.InvoiceNo) ? string.Empty : obj.InvoiceNo;
                    model.RGANo = string.IsNullOrEmpty(obj.RgaNo) ? string.Empty : obj.RgaNo;
                    model.DeliveryNo = string.IsNullOrEmpty(obj.DeliveryNo) ? string.Empty : obj.DeliveryNo;
                    model.ReasonCode = string.IsNullOrEmpty(obj.ReasonCode) ? string.Empty : obj.ReasonCode;
                    model.ReasonCn = string.IsNullOrEmpty(obj.ReasonCn) ? string.Empty : obj.ReasonCn;
                    model.ReasonEn = string.IsNullOrEmpty(obj.ReasonEn) ? string.Empty : obj.ReasonEn;
                    model.Rev1 = string.IsNullOrEmpty(obj.Rev1) ? string.Empty : obj.Rev1;
                    model.Rev2 = string.IsNullOrEmpty(obj.Rev2) ? string.Empty : obj.Rev2;
                    model.Rev3 = string.IsNullOrEmpty(obj.Rev3) ? string.Empty : obj.Rev3;
                    model.RevokeRemark = string.IsNullOrEmpty(obj.RevokeRemark) ? string.Empty : obj.RevokeRemark;
                    model.LastUpdateTime = obj.UpdateDate.HasValue ? obj.UpdateDate.Value.ToString(strDateFormat) : string.Empty;
                }

                if (isInit)
                {
                    EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
                    
                    model.CurrentNodeIds = ekpBll.GetCurrentNodeId(model.AdjId, base.UserInfo.LoginId);
                    model.LstReason = DictionaryHelper.GetDictionary("CONST_ReturnReason_EKP").ToArray<KeyValuePair<string, string>>();
                    model.HtmlString = this.GetInventoryReturnHtmlInfo(model.AdjId);
                }

                model.IsSuccess = true;
                return model;
            }
        }

        public InventoryReturnBscVO DoSave(InventoryReturnBscVO model)
        {
            using (InventoryReturnBscDao dao = new InventoryReturnBscDao())
            {
                string lastUpdateDate = model.LastUpdateTime;
                InventoryReturnBscVO returnVO = new InventoryReturnBscVO();
                returnVO.AdjId = model.AdjId;
                
                if (!string.IsNullOrEmpty(lastUpdateDate))
                {
                    returnVO = this.InitPage(returnVO, false);

                    if (model.LastUpdateTime != lastUpdateDate)
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("页面信息已改变，请刷新！");

                        return model;
                    }
                }

                EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();
                List<EkpOperation> operList = ekpBll.GetOperationList(base.UserInfo.LoginId, model.AdjId);
                EkpOperParam ekpOperParam = ekpBll.GetEkpParam(operList, EkpOperType.handler_pass);
                if (ekpOperParam == null)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("当前用户没有修改的权限");
                    return model;
                }
                
                InventoryReturnBsc obj = new InventoryReturnBsc();
                obj.AdjId = new Guid(model.AdjId);
                obj.InvoiceNo = model.InvoiceNo;
                obj.RgaNo = model.RGANo;
                obj.DeliveryNo = model.DeliveryNo;
                obj.ReasonCode = model.ReasonCode;
                obj.ReasonCn = model.ReasonCn;
                obj.ReasonEn = model.ReasonEn;
                obj.RevokeRemark = model.RevokeRemark;
                obj.Rev1 = model.Rev1;
                obj.Rev2 = model.Rev2;
                obj.Rev3 = model.Rev3;
                obj.CreateDate = DateTime.Now;
                obj.CreateUser = new Guid(base.UserInfo.Id);
                obj.CreateUserName = base.UserInfo.UserName;
                obj.UpdateDate = obj.CreateDate;
                obj.UpdateUser = new Guid(base.UserInfo.Id);
                obj.UpdateUserName = base.UserInfo.UserName;

                dao.SaveInventoryReturnBsc(obj);

                model.CurrentNodeIds = ekpBll.GetCurrentNodeId(model.AdjId, base.UserInfo.LoginId);
                model.LastUpdateTime = obj.UpdateDate.Value.ToString(strDateFormat);
                model.HtmlString = this.GetInventoryReturnHtmlInfo(model.AdjId);

                model.IsSuccess = true;
                return model;
            }
        }


        public String GetInventoryReturnHtmlInfo(String adjId)
        {
            EkpHtmlBLL htmlBll = new EkpHtmlBLL();
            EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

            FormInstanceMaster formMaster = ekpBll.GetFormInstanceMasterByApplyId(adjId);

            return htmlBll.GetDmsHtmlCommonById(formMaster.ApplyId.ToString(), formMaster.modelId, formMaster.templateFormId, DmsTemplateHtmlType.Normal,"");
        }
    }
}
