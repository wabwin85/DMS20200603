using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web.Security;
using System.Web;
using System.IO;

namespace DMS.BusinessService.Attachment
{
    public class UploadAttachmentService : ABaseService
    {
        #region Ajax Method

        //public UploadAttachmentVO Upload(UploadAttachmentVO model, HttpPostedFile file)
        //{
        //    try
        //    {
        //        PolicyAttachmentDao policyAttachmentDao = new PolicyAttachmentDao();

        //        if (file.ContentLength > SystemConfig.MaxFileSize) //  < 200M
        //        {
        //            model.IsSuccess = false;
        //            model.ExecuteMessage.Add("文件太大不能上传！");
        //        }
        //        else
        //        {
        //            String folderYear = DateTime.Now.Year.ToString();
        //            String fileName = Path.GetFileName(file.FileName);

        //            if (!String.IsNullOrEmpty(fileName))
        //            {
        //                String fileExtension = Path.GetExtension(fileName);
        //                if (file == null || file.FileName.Trim() == "")
        //                {
        //                    model.IsSuccess = false;
        //                    model.ExecuteMessage.Add("文件不存在！");
        //                }
        //                else
        //                {
        //                    DateTime date = DateTime.Now;

        //                    //生成随机文件名
        //                    String preFix = model.IptForeignTableName;
        //                    String saveName = date.Year.ToString() + date.Month.ToString() + date.Day.ToString() + date.Hour.ToString() + date.Minute.ToString() + date.Second.ToString() + date.Millisecond.ToString() + "-" + Guid.NewGuid().ToString();
        //                    saveName = preFix + "_" + saveName + fileExtension;

        //                    String filePath = AppDomain.CurrentDomain.BaseDirectory + BusinessConfig.UploadDirectory + "\\" + folderYear + "\\";

        //                    filePath = FileHelper.BuildPath(filePath);

        //                    String fullName = Path.Combine(filePath, saveName);

        //                    file.SaveAs(fullName);

        //                    PolicyAttachmentPO policyAttachment = new PolicyAttachmentPO();
        //                    policyAttachment.AttachmentId = Guid.NewGuid();
        //                    policyAttachment.ForeignTableName = model.IptForeignTableName;
        //                    policyAttachment.ForeignTableId = Guid.Empty;
        //                    policyAttachment.AttachmentName = fileName;
        //                    policyAttachment.AttachmentUrl = folderYear + "/" + saveName;
        //                    policyAttachment.CreateTime = DateTime.Now;

        //                    policyAttachmentDao.Insert(policyAttachment);

        //                    model.IptAttachmentId = policyAttachment.AttachmentId.ToSafeString();
        //                    model.IptAttachmentName = fileName;
        //                }
        //            }
        //            else
        //            {
        //                model.IsSuccess = false;
        //                model.ExecuteMessage.Add("文件不存在！");
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        LogHelper.Error(ex);

        //        model.IsSuccess = false;
        //        model.ExecuteMessage.Add(ex.Message);
        //    }
        //    return model;
        //}

        #endregion

        #region Internal Function

        #endregion
    }
}
