using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Contract;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using System.Linq;
using System.Collections.Generic;
using System.Data;
using DMS.Business.Excel;
using System.Collections.Specialized;
using Newtonsoft.Json;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.Common;
using DMS.Model;
using DMS.Model.Data;
using DMS.DataAccess.DataInterface;
using DMS.Business;

namespace DMS.BusinessService.Contract
{
    public class MergeAttachmentService : ABaseQueryService
    {
        public MergeAttachmentVO Init(MergeAttachmentVO model)
        {
            try
            {
                if (model.HidDealerType.ToSafeString().Equals(DealerType.T2.ToString()))
                {
                    //设定附件参数类型
                    model.HidFileType = SR.Const_ContractAnnex_Type_T2;
                    //HidSystemCreateAttachment.Value = "T2_SystemCreate";
                }
                else
                {
                    //维护一级经销商或者设备经销商，附件关联合同主表ID
                    if (model.HidDealerType.ToSafeString().Equals(DealerType.T1.ToString()))
                    {
                        //设定附件参数类型
                        model.HidFileType = SR.Const_ContractAnnex_Type_T1;
                        //HidSystemCreateAttachment.Value = "T1_SystemCreate";
                    }
                    else
                    {
                        //设定附件参数类型
                        model.HidFileType = SR.Const_ContractAnnex_Type_LP;
                        //HidSystemCreateAttachment.Value = "LP_SystemCreate";
                    }
                }
                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(model.HidFileType);
                dicts.Remove("T1_SystemCreate");
                dicts.Remove("T2_SystemCreate");
                dicts.Remove("T3_SystemCreate");
                model.LstFileType = JsonHelper.DataTableToArrayList(dicts.ToArray().ToDataSet().Tables[0]);
                
                if (model.HidDealerType.ToSafeString().Equals(DealerType.T2.ToString()))
                {
                    if (IsDealer && !RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) && !RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        model.DisableUpload = true;
                    }
                }

                if (RoleModelContext.Current.User.Roles.Contains(SR.Const_UserRole_ContractQuery))
                {
                    model.DisableUpload = true;
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

        public string Query(MergeAttachmentVO model)
        {
            try
            {
                AttachmentDao dao = new AttachmentDao();
                int totalCount = 0;

                Guid ContractId = new Guid(string.IsNullOrEmpty(model.HidContractId) ? Guid.Empty.ToString() : model.HidContractId);
                Hashtable tb = new Hashtable();
                tb.Add("MainId", ContractId);
                tb.Add("ParType", model.HidFileType.ToSafeString());

                int start = (model.Page - 1) * model.PageSize;
                model.RstResultList = JsonHelper.DataTableToArrayList(dao.GetAttachment(tb, start, model.PageSize, out totalCount).Tables[0]);

                model.DataCount = totalCount;
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
            return JsonConvert.SerializeObject(result);
        }

        public MergeAttachmentVO DeleteAttach(MergeAttachmentVO model)
        {
            try
            {
                //逻辑删除
                using (AttachmentDao dao = new AttachmentDao())
                {
                    Guid id = new Guid(string.IsNullOrEmpty(model.SelectAttachId) ? Guid.Empty.ToString() : model.SelectAttachId);
                    dao.Delete(id);
                    model.ExecuteMessage.Add("Success");
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

        public MergeAttachmentVO InitAttachInfo(MergeAttachmentVO model)
        {
            try
            {
                AttachmentDao dao = new AttachmentDao();
                if (!string.IsNullOrEmpty(model.SelectAttachId.ToSafeString()))
                {
                    DMS.Model.Attachment attach = dao.GetObject(model.SelectAttachId.ToSafeGuid());
                    if (attach != null)
                    {
                        //赋值
                        model.WinAttachName = attach.Name.Substring(0, attach.Name.LastIndexOf("."));
                        model.HidFileExt = attach.Name.Substring(attach.Name.LastIndexOf(".") + 1);
                        model.WinUploadDate = attach.UploadDate.ToShortDateString();
                        model.WinAttachType = new KeyValue(attach.Type, "");
                        model.HidOldType = attach.Type;

                        if (attach.Type == model.HidFileType.ToSafeString())
                        {
                            //添加
                            model.WinAttachType = new KeyValue("系统生成", "");
                            //设置状态
                            model.DisableDDL = true;
                        }
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

        public MergeAttachmentVO UpdateAttachmentName(MergeAttachmentVO model)
        {
            try
            {
                IAttachmentBLL attachmentBLL = new AttachmentBLL();
                string atId = model.SelectAttachId.ToSafeString();
                string atName = model.WinAttachName.ToSafeString();
                string fileType = model.HidFileExt.ToSafeString();
                string atType = model.WinAttachType.Key.ToSafeString();
                string oldAtType = model.HidOldType.ToSafeString();
                if (!string.IsNullOrEmpty(atId) && !string.IsNullOrEmpty(atName) && !string.IsNullOrEmpty(atType))
                {
                    attachmentBLL.UpdateAttachmentName(new Guid(atId), atName + "." + fileType, atType);
                    model.ExecuteMessage.Add("Success");
                }
                else if (!string.IsNullOrEmpty(atId) && !string.IsNullOrEmpty(atName) && oldAtType == model.HidFileType.ToSafeString())
                {
                    attachmentBLL.UpdateAttachmentName(new Guid(atId), atName + "." + fileType, oldAtType);
                    model.ExecuteMessage.Add("Success");
                }
                else
                {
                    model.ExecuteMessage.Add("Incomplete");
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
