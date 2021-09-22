using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Collections.Specialized;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Consign;
using DMS.ViewModel.Common;
using DMS.DataAccess;
using DMS.DataAccess.ContractElectronic;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using DMS.ViewModel;
using DMS.Common.Extention;
using DMS.Model.Consignment;
using DMS.DataAccess.Consignment;
using DMS.BusinessService;

namespace DMS.BusinessService.Attachment
{
    public class DownloadAttachmentService : ABaseService
    {
        #region Ajax Method

        public void Download(Guid attachmentId, String attachmentType, String cookie)
        {
            try
            {
                AttachmentDao attachmentDao = new AttachmentDao();
                DMS.Model.Attachment attachment = attachmentDao.GetObject(attachmentId);

                String fullName = "";
                if (attachmentType.IsNullOrEmpty())
                {
                    fullName = AppDomain.CurrentDomain.BaseDirectory + "\\Upload\\UploadFile\\" + attachment.Url;
                }
                else
                {
                    fullName = AppDomain.CurrentDomain.BaseDirectory + "\\Upload\\UploadFile\\" + attachmentType + "\\" + attachment.Url;
                }
                
                WebHelper.DownloadFile(fullName, attachment.Name, cookie);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                throw ex;
            }
        }

        #endregion

        #region Internal Function

        #endregion
    }
}
