using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.ViewModel.Util.DataImport;
using DMS.Common;
using System.Data;
using DMS.Common.Common;

namespace DMS.BusinessService.Util.DataImport.Impl
{
    public class DataImportTest : ADataImport
    {
        protected override string PreFix
        {
            get
            {
                return "TEST";
            }
        }

        public override void DownloadDetail(DataImportDetailDownloadVO model)
        {
            throw new NotImplementedException();
        }

        public override void DownloadTemplate(DataImportTemplateVO model)
        {
            String fullName = AppDomain.CurrentDomain.BaseDirectory + "Upload\\PROOther\\Template_InitPoint.xls";
            WebHelper.DownloadFile(fullName, "Template.xls", model.DownloadCookie);
        }

        public override DataImportDetailListVO QueryDetailList(DataImportDetailListVO model)
        {
            throw new NotImplementedException();
        }

        public override DataImportErrorListVO QueryErrorList(DataImportErrorListVO model)
        {
            try
            {
                //SELECT '' AS RowNum,
                //       '' AS ErrorMessage
                //FROM   TABLE
                //ORDER BY
                //       RowNum

                model.RstResultList = new DataTable();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }

        protected override DataImportUploadVO CheckFile(DataImportUploadVO model, string fileName,string Name)
        {
            try
            {
                //获取Excel文件中的内容
                DataTable applyInfo = ExcelUtil.GetDataTable(fileName, "Sheet1");

                model.CheckResult = true;
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
