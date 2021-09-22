using System;
using System.Web;
using System.Runtime.Remoting.Contexts;
using System.Reflection;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.IO;
using Microsoft.Office.Interop.Excel;

namespace DMS.Common.Common
{
    [Synchronization]
    public abstract class ExcelApp : ContextBoundObject
    {
        #region property

        protected ApplicationClass app;
        protected Workbook book;
        protected Worksheet sheet;
        protected Range range;
        protected object missing = Missing.Value;

        //Excel启动之前时间
        protected DateTime beforeTime;
        //Excel启动之后时间
        protected DateTime afterTime;

        protected String fileName = "";

        protected HttpResponse response = HttpContext.Current.Response;

        #endregion

        #region

        #endregion

        #region

        protected void InitApp()
        {
            beforeTime = DateTime.Now;
            app = new ApplicationClass();
            //app.Visible = true;
            app.DisplayAlerts = false;
            afterTime = DateTime.Now;
        }

        protected void OpenFile(String templateName)
        {
            try
            {
                book = app.Workbooks.Open(AppDomain.CurrentDomain.BaseDirectory + @"/Upload/" + templateName, false, false, missing, missing, missing,
          missing, missing, missing, missing, missing, missing, missing, missing, missing);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void OpenDistinceFile(String fileName)
        {
            try
            {
                book = app.Workbooks.Open(fileName, false, false, missing, missing, missing,
          missing, missing, missing, missing, missing, missing, missing, missing, missing);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void SaveFile(String folder)
        {
            fileName = HttpContext.Current.Server.MapPath(@"~/Upload/UploadFile/" + folder + "/" + Guid.NewGuid().ToString() + ".xlsx");

            book.SaveAs(fileName, missing, missing, missing, missing, missing, XlSaveAsAccessMode.xlExclusive, missing, missing, missing, missing, missing);
        }

        protected void Close()
        {
            try
            {
                if (book != null)
                {
                    book.Close(false, missing, false);
                }
            }
            catch (Exception e)
            {
                
            }

            try
            {
                if (app != null)
                {
                    app.Workbooks.Close();
                    app.Quit();
                }
            }
            catch (Exception e)
            {
                
            }

            try
            {
                if (range != null)
                {
                    Marshal.ReleaseComObject(range);
                    range = null;
                }
            }
            catch (Exception e)
            {
                
            }

            try
            {
                if (sheet != null)
                {
                    Marshal.ReleaseComObject(sheet);
                    sheet = null;
                }
            }
            catch (Exception e)
            {
               
            }

            try
            {
                if (book != null)
                {
                    Marshal.ReleaseComObject(book);
                    book = null;
                }
            }
            catch (Exception e)
            {
                
            }

            try
            {
                if (app != null)
                {
                    Marshal.ReleaseComObject(app);
                    app = null;
                }
            }
            catch (Exception e)
            {
                
            }

            try
            {
                GC.Collect();
            }
            catch (Exception e)
            {
                
            }

            try
            {
                GC.WaitForPendingFinalizers();
            }
            catch (Exception e)
            {
                
            }
            //this.KillExcelProcess();
        }

        protected void KillExcelProcess()
        {
            DateTime startTime;
            Process[] processes = Process.GetProcessesByName("Excel");

            //得不到Excel进程ID，暂时只能判断进程启动时间

            foreach (Process process in processes)
            {
                startTime = process.StartTime;
                if (startTime > beforeTime && startTime < afterTime)
                    process.Kill();
            }
        }

        protected void ExportFile(String downloadName)
        {
            try
            {
                response.Clear();
                response.Buffer = true;

                //以字符流的形式下载文件 
                System.IO.FileStream fs = new System.IO.FileStream(fileName, System.IO.FileMode.Open);
                byte[] bytes = new byte[(int)fs.Length];
                fs.Read(bytes, 0, bytes.Length);
                fs.Close();
                response.ContentType = "application/octet-stream";
                //通知浏览器下载文件而不是打开 
                response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlEncode(downloadName, System.Text.Encoding.UTF8));
                response.BinaryWrite(bytes);
                response.Flush();
                response.End();
            }
            catch (Exception ex)
            {

            }

            //downloadName = HttpUtility.UrlEncode(downloadName, System.Text.Encoding.UTF8);
            //Stream iStream = null;

            ////以10K为单位缓存:
            //byte[] buffer = new Byte[10000];

            //int length;

            //long dataToRead;

            //try
            //{
            //    // 打开文件.
            //    iStream = new FileStream(fileName, FileMode.Open, FileAccess.Read, FileShare.Read);


            //    // 得到文件大小:
            //    dataToRead = iStream.Length;

            //    response.ContentType = "application/octet-stream";
            //    response.AddHeader("Content-Disposition", "attachment; filename=" + downloadName + ".xlsx");

            //    while (dataToRead > 0)
            //    {
            //        //保证客户端连接

            //        if (response.IsClientConnected)
            //        {
            //            length = iStream.Read(buffer, 0, 10000);

            //            response.OutputStream.Write(buffer, 0, length);

            //            response.Flush();

            //            buffer = new Byte[10000];
            //            dataToRead = dataToRead - length;
            //        }
            //        else
            //        {
            //            //结束循环
            //            dataToRead = -1;
            //        }
            //    }
            //}
            //catch (Exception ex)
            //{
            //    // 出错.
            //    response.Write("Error : " + ex.Message);
            //}
            //finally
            //{
            //    if (iStream != null)
            //    {
            //        //关闭文件
            //        iStream.Close();
            //    }
            //}

        }

        protected void ExportFile(String downloadName, String type)
        {
            downloadName = HttpUtility.UrlEncode(downloadName, System.Text.Encoding.UTF8);
            Stream iStream = null;

            //以10K为单位缓存:
            byte[] buffer = new Byte[10000];

            int length;

            long dataToRead;

            try
            {
                // 打开文件.
                iStream = new FileStream(fileName, FileMode.Open, FileAccess.Read, FileShare.Read);


                // 得到文件大小:
                dataToRead = iStream.Length;

                response.ContentType = "application/octet-stream";
                response.AddHeader("Content-Disposition", "attachment; filename=" + downloadName + "." + type);

                while (dataToRead > 0)
                {
                    //保证客户端连接

                    if (response.IsClientConnected)
                    {
                        length = iStream.Read(buffer, 0, 10000);

                        response.OutputStream.Write(buffer, 0, length);

                        response.Flush();

                        buffer = new Byte[10000];
                        dataToRead = dataToRead - length;
                    }
                    else
                    {
                        //结束循环
                        dataToRead = -1;
                    }
                }
            }
            catch (Exception ex)
            {
                // 出错.
                response.Write("Error : " + ex.Message);
            }
            finally
            {
                if (iStream != null)
                {
                    //关闭文件
                    iStream.Close();
                }
            }

        }

        protected void DeleteFile()
        {
            FileInfo fi = new FileInfo(fileName);
            if (fi != null)
            {
                fi.Delete();
            }
        }

        protected void CleanComObject(ref Worksheet worksheet)
        {
            if (worksheet != null)
            {
                Marshal.ReleaseComObject(worksheet);
                worksheet = null;
            }
        }

        protected void CleanComObject(ref Sheets worksheets)
        {
            if (worksheets != null)
            {
                Marshal.ReleaseComObject(worksheets);
                worksheets = null;
            }
        }

        protected void FillCell(Worksheet worksheet, int row, int col, String value)
        {
            if (worksheet == null || row < 0 || col < 0)
            {
                throw new ArgumentException();
            }
            Range range = (Range)worksheet.Cells[row, col];
            range.Value2 = value;
        }

        protected void FillCell(Worksheet worksheet, int startRow, int startCol, int endRow, int endCol, object value)
        {
            if (worksheet == null || startRow < 0 || endRow < 0 || endRow < 0 || endCol < 0)
            {
                throw new ArgumentException();
            }
            worksheet.get_Range(worksheet.Cells[startRow, startCol], worksheet.Cells[endRow, endCol]).Value2 = value;
        }

        protected void FillFormula(Worksheet worksheet, int row, int col, String formula)
        {
            if (worksheet == null || row < 0 || col < 0)
            {
                throw new ArgumentException();
            }
            Range range = (Range)worksheet.Cells[row, col];
            range.Formula = formula;
        }

        protected void MergeCells(Worksheet worksheet, int startRow, int startCol, int endRow, int endCol)
        {
            Range r;
            r = worksheet.get_Range(worksheet.Cells[startRow, startCol], worksheet.Cells[endRow, endCol]);
            r.MergeCells = true;
        }

        //protected void NewSheet(int sheetNum)
        //{
        //    Sheets sheets = this.book.Worksheets;
        //    int count = sheets.Count;
        //    sheets.Add(sheets[count], missing, sheetNum, missing);
        //    this.CleanComObject(ref sheets);
        //}

        protected void CopySheetBefore(int source, int target)
        {
            Sheets sheets = this.book.Worksheets;
            Worksheet tmpSheet = (Worksheet)(sheets[source]);
            tmpSheet.Copy(sheets[target], missing);

            this.CleanComObject(ref tmpSheet);
            this.CleanComObject(ref sheets);
        }

        protected void CopySheetAfter(int source, int target)
        {
            Sheets sheets = this.book.Worksheets;
            int count = sheets.Count;
            Worksheet tmpSheet = (Worksheet)(sheets[source]);
            tmpSheet.Copy(missing, sheets[target]);

            this.CleanComObject(ref tmpSheet);
            this.CleanComObject(ref sheets);
        }

        protected void NewSheetEnd()
        {
            Sheets sheets = this.book.Worksheets;
            int count = sheets.Count;
            Worksheet tmpSheet = (Worksheet)(sheets[count]);
            sheets.Add(missing, tmpSheet, missing, missing);

            this.CleanComObject(ref tmpSheet);
            this.CleanComObject(ref sheets);
        }

        protected void NewSheet(int sheetNum)
        {
            Sheets sheets = this.book.Worksheets;
            int count = sheets.Count;
            Worksheet tmpSheet = (Worksheet)(sheets[sheetNum]);
            tmpSheet.Copy(missing, sheets[sheetNum]);
            //sheets.Add(missing, tmpSheet, missing, missing);
            this.CleanComObject(ref tmpSheet);
            this.CleanComObject(ref sheets);
        }

        protected void DeleteSheet(int sheetNum)
        {
            Sheets sheets = this.book.Worksheets;

            Worksheet headSheet = (Worksheet)(sheets[sheetNum]);
            headSheet.Delete();

            this.CleanComObject(ref headSheet);
            this.CleanComObject(ref sheets);
        }

        protected String GetCellValue(Worksheet worksheet, int row, int col)
        {
            if (worksheet == null || row < 0 || col < 0)
            {
                throw new ArgumentException();
            }
            Range range = (Range)worksheet.Cells[row, col];
            return range.Value2 == null ? "" : range.Value2.ToString();
        }

        protected void DeleteRow(Worksheet worksheet, int row)
        {
            Range range = (Range)worksheet.Rows[row, Type.Missing];
            range.EntireRow.Delete(XlDeleteShiftDirection.xlShiftUp);
        }

        protected void InsertRow(Worksheet worksheet, int row)
        {
            Range range = (Range)worksheet.Rows[row, Type.Missing];

            range.EntireRow.Insert(XlDirection.xlDown, XlInsertFormatOrigin.xlFormatFromLeftOrAbove);
        }

        protected void SetTextFormat(Worksheet worksheet, int row, int col)
        {
            Range range = (Range)worksheet.Cells[row, col];
            range.NumberFormatLocal = "@";
        }
        #endregion
    }
}
