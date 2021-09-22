using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Common;
using DMS.Common.Common;
using System.Data;
using System.Collections;
using DMS.DataAccess;
using DMS.Model;
using System.Text.RegularExpressions;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using System.IO;
using System.Web;
using DMS.Business.EKPWorkflow;
using DMS.Model.EKPWorkflow;

namespace DMS.Business
{
    public class DealerMasterDDBscService : BaseService
    {
        private IRoleModelContext _context = RoleModelContext.Current;
        private IAttachmentBLL _attachBll = new AttachmentBLL();
        public DealerMasterDDBscView GetInitInfo(DealerMasterDDBscView model)
        {
            try
            {
                using (DealerMasterDDBscDao dao = new DealerMasterDDBscDao())
                {
                    DealerMasterDD dmdd = dao.GetObjectByContractID(string.IsNullOrEmpty(model.ContractID) ? Guid.Empty : new Guid(model.ContractID));
                    if (dmdd != null)
                    {
                        model.DDReportName = dmdd.DMDD_ReportName;
                        model.DDStartDate = dmdd.DMDD_StartDate;
                        model.DDEndDate = dmdd.DMDD_EndDate;
                    }
                    model.HtmlString = GetHtmlInfo(model.ContractID);
                    //附件
                    AttachmentStore_Refresh(model);
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
        public DealerMasterDDBscView AttachmentStore_Refresh(DealerMasterDDBscView model)
        {
            try
            {
                DataTable dt = new DataTable();
                Guid tid = string.IsNullOrEmpty(model.ContractID) ? Guid.Empty : new Guid(model.ContractID);
                int totalCount = 0;
                DataSet ds = _attachBll.GetAttachmentByMainId(tid, AttachmentType.DealerMasterDD, 0, int.MaxValue, out totalCount);
                if (ds != null)
                {
                    dt = ds.Tables[0];
                }
                model.AttachmentList = JsonHelper.DataTableToArrayList(dt);
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
        public DealerMasterDDBscView SaveInfo(DealerMasterDDBscView model)
        {
            try
            {
                using (DealerMasterDDBscDao dao = new DealerMasterDDBscDao())
                {
                    DealerMasterDD dmdd = new DealerMasterDD();
                    dmdd.DMDD_ID = Guid.NewGuid();
                    dmdd.DMDD_ContractID = string.IsNullOrEmpty(model.ContractID) ? Guid.Empty : new Guid(model.ContractID);
                    dmdd.DMDD_ReportName = model.DDReportName;
                    dmdd.DMDD_StartDate = model.DDStartDate;
                    dmdd.DMDD_EndDate = model.DDEndDate;
                    dmdd.DMDD_CreateDate = DateTime.Now;
                    dmdd.DMDD_CreateUser = _context.UserName;
                    dmdd.DMDD_UpdateDate = DateTime.Now;
                    dmdd.DMDD_UpdateUser = _context.UserName;
                    dao.Insert(dmdd);
                }
                model.IsSuccess = true;
                model.HtmlString = GetHtmlInfo(model.ContractID);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public DealerMasterDDBscView DeleteAttachment(DealerMasterDDBscView model)
        {
            try
            {
                Guid id = string.IsNullOrEmpty(model.DeleteAttachmentID) ? Guid.Empty : new Guid(model.DeleteAttachmentID);
                _attachBll.DelAttachment(id);
                string uploadFile = HttpContext.Current.Server.MapPath("..\\..\\..\\Upload\\UploadFile\\DealerMasterDDAttachment");
                File.Delete(uploadFile + "\\" + model.DeleteAttachmentName);
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add("删除附件失败，请联系DMS技术支持");
            }
            return model;
        }

        public String GetHtmlInfo(String adjId)
        {
            EkpHtmlBLL htmlBll = new EkpHtmlBLL();
            EkpWorkflowBLL ekpBll = new EkpWorkflowBLL();

            FormInstanceMaster formMaster = ekpBll.GetFormInstanceMasterByApplyId(adjId);
            if (formMaster != null)
            {
                return htmlBll.GetDmsHtmlCommonById(formMaster.ApplyId.ToString(), formMaster.modelId, formMaster.templateFormId, DmsTemplateHtmlType.Normal, "");
            }
            return "";
        }
    }
}
