using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.MasterDatas;
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

namespace DMS.BusinessService.MasterDatas
{
    public class DealerAttachDetailForDDService: ABaseQueryService
    {
        public DealerAttachDetailForDDVO Init(DealerAttachDetailForDDVO model)
        {
            try
            {
                DealerMasterDDBscDao dao = new DealerMasterDDBscDao();
                //DealerMasterDD dmdd = dao.GetObjectByDealerID(string.IsNullOrEmpty(model.HidDealerId) ? Guid.Empty : new Guid(model.HidDealerId));
                //if (dmdd != null)
                //{
                //    model.IptDDReportName = dmdd.DMDD_ReportName;
                //    model.IptDDStartDate = dmdd.DMDD_StartDate?.ToString("yyyy-MM-dd");
                //    model.IptDDEndDate = dmdd.DMDD_EndDate?.ToString("yyyy-MM-dd");
                //}
                model.WinIptDDStartDate = DateTime.Now.ToString("yyyy-MM-dd");
                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary("Dealer_Annex");
                model.LstFileType = JsonHelper.DataTableToArrayList(dicts.ToArray().ToDataSet().Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(DealerAttachDetailForDDVO model)
        {
            try
            {
                AttachmentDao dao = new AttachmentDao();
                int totalCount = 0;

                Guid DealerID = new Guid(string.IsNullOrEmpty(model.HidDealerId) ? Guid.Empty.ToString() : model.HidDealerId);
                Hashtable tb = new Hashtable();
                tb.Add("DealerID", DealerID);
                if (!string.IsNullOrEmpty(model.QryDDReportName))
                {
                    tb.Add("DDReportName", model.QryDDReportName);
                }
                if (model.QryDDStartDate != null && !string.IsNullOrEmpty(model.QryDDStartDate.StartDate))
                {
                    tb.Add("DDStartDateS", model.QryDDStartDate.StartDate);
                }
                if (model.QryDDStartDate != null && !string.IsNullOrEmpty(model.QryDDStartDate.EndDate))
                {
                    tb.Add("DDStartDateE", model.QryDDStartDate.EndDate);
                }
                if (model.QryDDEndDate != null && !string.IsNullOrEmpty(model.QryDDEndDate.StartDate))
                {
                    tb.Add("DDEndDateS", model.QryDDEndDate.StartDate);
                }
                if (model.QryDDEndDate != null && !string.IsNullOrEmpty(model.QryDDEndDate.EndDate))
                {
                    tb.Add("DDEndDateE", model.QryDDEndDate.EndDate);
                }
                //tb.Add("AttachmentType", model.HidDealerType + "_BackgroundCheck");
                int start = (model.Page - 1) * model.PageSize;
                model.RstAttachList = JsonHelper.DataTableToArrayList(dao.GetAttachmentContractForDD(tb, start, model.PageSize, out totalCount).Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstAttachList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }

        public DealerAttachDetailForDDVO DeleteAttach(DealerAttachDetailForDDVO model)
        {
            try
            {
                //逻辑删除
                using (AttachmentDao dao = new AttachmentDao())
                {
                    Guid id = new Guid(string.IsNullOrEmpty(model.SelectAttachId) ? Guid.Empty.ToString() : model.SelectAttachId);
                    dao.Delete(id);
                }
                //DD信息删除
                using (DealerMasterDDBscDao dao = new DealerMasterDDBscDao())
                {
                    Guid id = new Guid(string.IsNullOrEmpty(model.SelectAttachId) ? Guid.Empty.ToString() : model.SelectAttachId);
                    dao.Delete(id);
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

        public DealerAttachDetailForDDVO SaveDDInfo(DealerAttachDetailForDDVO model)
        {
            try
            {
                using (DealerMasterDDBscDao dao = new DealerMasterDDBscDao())
                {
                    DealerMasterDD dmdd = new DealerMasterDD();
                    dmdd.DMDD_ID = Guid.NewGuid();
                    dmdd.DMDD_ContractID = null;
                    dmdd.DMDD_DealerID = new Guid(model.HidDealerId);
                    dmdd.DMDD_ReportName = model.WinIptDDReportName;
                    dmdd.DMDD_IsHaveRedFlag = model.WinIptIsHaveRedFlag;
                    if (!string.IsNullOrEmpty(model.WinIptDDStartDate))
                    {
                        dmdd.DMDD_StartDate = Convert.ToDateTime(model.WinIptDDStartDate);
                    }
                    if (!string.IsNullOrEmpty(model.WinIptDDEndDate))
                    {
                        dmdd.DMDD_EndDate = Convert.ToDateTime(model.WinIptDDEndDate);
                    }
                    //dmdd.DMDD_DD = attId;
                    dmdd.DMDD_CreateDate = DateTime.Now;
                    dmdd.DMDD_CreateUser = RoleModelContext.Current.UserName;
                    dmdd.DMDD_UpdateDate = DateTime.Now;
                    dmdd.DMDD_UpdateUser = RoleModelContext.Current.UserName;
                    dao.Insert(dmdd);
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
