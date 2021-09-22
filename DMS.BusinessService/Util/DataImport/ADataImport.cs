using DMS.Common.Common;
using DMS.ViewModel.Util.DataImport;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;

namespace DMS.BusinessService.Util.DataImport
{
    public abstract class ADataImport : ABaseService
    {
        protected String OriginalFileName;

        public DataImportUploadVO CheckFile(DataImportUploadVO model, HttpPostedFile file)
        {
            String fileName = "";
            try
            {
                this.OriginalFileName = Path.GetFileName(file.FileName);
                fileName = FileHelper.UploadFile(file, this.PreFix);

                this.OriginalFileName = OriginalFileName.Replace("docx", "pdf");
                model = this.CheckFile(model, fileName, OriginalFileName);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            finally
            {
                if (!model.KeepFile)
                {
                    FileHelper.Delete(fileName);
                }
            }
            return model;
        }

        public abstract DataImportErrorListVO QueryErrorList(DataImportErrorListVO model);

        public abstract DataImportDetailListVO QueryDetailList(DataImportDetailListVO model);

        public abstract void DownloadDetail(DataImportDetailDownloadVO model);

        public abstract void DownloadTemplate(DataImportTemplateVO model);

        protected abstract DataImportUploadVO CheckFile(DataImportUploadVO model, String fileName,String Name);

        protected abstract String PreFix { get; }
    }
}
