using DMS.Common;
using DMS.Common.Common;
using DMS.DataAccess;
using DMS.DataAccess.ContractElectronic;
using DMS.ViewModel.Common;
using DMS.ViewModel.Platform;
using System;
using System.Collections;
using DMS.Common.Extention;

namespace DMS.BusinessService.Platform
{
    public class BulletinReadService : ABaseBusinessService
    {
        public BulletinReadVO Init(BulletinReadVO model)
        {
            try
            {
                BulletinMainDao bulletinMainDao = new BulletinMainDao();
                BulletinDetailDao bulletinDetailDao = new BulletinDetailDao();
                AttachmentDao attachmentDao = new AttachmentDao();

                if (base.UserInfo.CorpId.HasValue)
                {
                    Hashtable condition = new Hashtable();
                    condition.Add("BumId", model.InstanceId);
                    condition.Add("DealerDmaId", base.UserInfo.CorpId.Value);
                    condition.Add("IsRead", true);
                    condition.Add("ReadUser", base.UserInfo.Id);
                    condition.Add("ReadDate", DateTime.Now);
                    bulletinDetailDao.UpdateRead(condition);
                }
                Hashtable bulletinInfo = bulletinMainDao.SelectInfoForDashboard(base.IsDealer, base.UserInfo.CorpId, model.InstanceId.ToSafeGuid());

                model.IptTitle = bulletinInfo.GetSafeStringValue("Title");
                model.IptPublishedDate = bulletinInfo.GetSafeStringValue("PublishedDate");
                model.IptBody = bulletinInfo.GetSafeStringValue("Body").Replace("\n", "<br />");
                model.IptConfirmFlag = bulletinInfo.GetSafeBooleanValue("ConfirmFlag");

                Hashtable attachmentCondition = new Hashtable();
                attachmentCondition.Add("MainId", model.InstanceId);
                attachmentCondition.Add("Type", "Bulletin");
                model.RstAttachment = JsonHelper.DataTableToArrayList(attachmentDao.GetAttachmentByMainId(attachmentCondition).Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public BulletinReadVO Confirm(BulletinReadVO model)
        {
            try
            {
                BulletinMainDao bulletinMainDao = new BulletinMainDao();
                BulletinDetailDao bulletinDetailDao = new BulletinDetailDao();

                Hashtable condition = new Hashtable();
                condition.Add("BumId", model.InstanceId);
                condition.Add("DealerDmaId", base.UserInfo.CorpId.Value);
                condition.Add("IsConfirm", true);
                condition.Add("ConfirmUser", base.UserInfo.Id);
                condition.Add("ConfirmDate", DateTime.Now);
                bulletinDetailDao.UpdateConfirm(condition);
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
