using DMS.Common.Common;
using DMS.DataAccess.OBORESign;
using DMS.ViewModel.Util.DataImport;
using FrameLib.Common.Extention;
using FrameLib.Common.Mybatis;
using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Util.DataImport
{
    public  class ImportDealerContractWaterMark : ADataImport
    {
        protected override string PreFix
        {
            get
            {
                return "OBORPDF";
            }
        }

        public override void DownloadDetail(DataImportDetailDownloadVO model)
        {
            throw new NotImplementedException();
        }

        public override void DownloadTemplate(DataImportTemplateVO model)
        {
            throw new NotImplementedException();
        }

        public override DataImportDetailListVO QueryDetailList(DataImportDetailListVO model)
        {
            throw new NotImplementedException();
        }

        public override DataImportErrorListVO QueryErrorList(DataImportErrorListVO model)
        {
            throw new NotImplementedException();
        }

        protected override DataImportUploadVO CheckFile(DataImportUploadVO model, string fileName,string Name)
        {
            try
            {
                OBORESignDao dao = new OBORESignDao();
                BaseMapper.BeginTransaction();

             

                String ESID = model.Parameters.GetSafeStringValue("ESID");
                
               

                string pdf0path = fileName.Replace("docx", "pdf");

                using (WordApp wordapp = new WordApp(fileName))
                {
                    wordapp.Save();
                    wordapp.SavePdf(pdf0path);

                }
                String pdfname =  Path.GetFileName(pdf0path);
               
                dao.Save(ESID, pdfname, Name, RoleModelContext.Current.User.CorpId.ToString(), RoleModelContext.Current.User.Id.ToString());

                //WordTools.AddWaterMark(AppDomain.CurrentDomain.BaseDirectory + "Resources\\images\\WaterMark.jpg", pdf0path);

                //model.Results = new System.Collections.Hashtable();
                //model.Results.Add("FileUrl", Path.GetFileName(pdf0path));
                //model.Results.Add("FileName", this.OriginalFileName.Replace("docx", "pdf"));

                //以新名称复制文件到指定目录
                //File.Copy(pdf0path.Replace(".pdf", "_output.pdf"), AppDomain.CurrentDomain.BaseDirectory + "TEMP\\WaterMark\\" + Path.GetFileName(pdf0path));

                model.KeepFile = true;
                model.IsSuccess = true;
                model.CheckResult = true;
                BaseMapper.CommitTransaction();
            }
            catch (Exception ex)
            {
                BaseMapper.RollBackTransaction();

                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }
    }
}
