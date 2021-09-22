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
    public class DealerAttachDetailService: ABaseQueryService
    {
        public DealerAttachDetailVO Init(DealerAttachDetailVO model)
        {
            try
            {
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

        public string Query(DealerAttachDetailVO model)
        {
            try
            {
                AttachmentDao dao = new AttachmentDao();
                int totalCount = 0;

                Guid DealerID = new Guid(string.IsNullOrEmpty(model.HidDealerId) ? Guid.Empty.ToString() : model.HidDealerId);
                Hashtable tb = new Hashtable();
                tb.Add("DealerID", DealerID);

                int start = (model.Page - 1) * model.PageSize;
                model.RstAttachList = JsonHelper.DataTableToArrayList(dao.GetAttachmentContract(tb, start, model.PageSize, out totalCount).Tables[0]);

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

        public DealerAttachDetailVO DeleteAttach(DealerAttachDetailVO model)
        {
            try
            {
                //逻辑删除
                using (AttachmentDao dao = new AttachmentDao())
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
    }
}
