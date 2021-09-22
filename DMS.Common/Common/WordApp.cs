using Microsoft.Office.Interop.Word;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;

namespace DMS.Common.Common
{
    public class WordApp : IDisposable
    {
        private object missing = Missing.Value;
        private Application app = null;
        private Document document = null;

        public WordApp(string filePath)
        {
            app = new ApplicationClass();
            app.Visible = false;
            app.DisplayAlerts = WdAlertLevel.wdAlertsNone;
            object fileName = filePath;
            try
            {
                document = app.Documents.Open(ref fileName, ref missing,
                ref missing, ref missing, ref missing, ref missing, ref missing,
                ref missing, ref missing, ref missing, ref missing, ref missing,
                ref missing, ref missing, ref missing, ref missing);
            }
            catch (Exception ex)
            {

            }
        }

        public void Save()
        {
            document.Save();
        }

        public void SaveAs(string filePath)
        {
            object fileName = filePath;
            object format = WdSaveFormat.wdFormatDocumentDefault;
            document.SaveAs(ref fileName, ref format, ref missing,
                ref missing, ref missing, ref missing, ref missing,
                ref missing, ref missing, ref missing, ref missing,
                ref missing, ref missing, ref missing, ref missing,
                ref missing);
        }

        public void SavePdf(string filePath)
        {
            document.ExportAsFixedFormat(filePath, WdExportFormat.wdExportFormatPDF);
        }

        public void Dispose()
        {
            try
            {
                try
                {
                    if (document != null)
                    {
                        document.Close(false, missing, false);
                        document = null;
                    }
                }
                catch
                {
                }

                try
                {
                    if (app != null)
                    {
                        app.Quit();
                        app = null;
                    }
                }
                catch
                {
                }

                try
                {
                    GC.Collect();
                }
                catch
                {
                }

                try
                {
                    GC.WaitForPendingFinalizers();
                }
                catch
                {
                }
            }
            finally
            {

            }
        }

    }
}
