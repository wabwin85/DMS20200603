//引入Excel的COM组件
using System;
using System.Data;
using System.Configuration;
using System.Web;
using DMS.Business.Excel.Objects;
using Microsoft.Office.Interop.Excel;
using System.Reflection;
using System.Runtime.InteropServices;

namespace DMS.Business.Excel
{
    /// <SUMMARY>
    /// ExcelEdit 的摘要说明
    /// </SUMMARY>
    public class ExcelEdit
    {
        //protected static readonly ILog Log = LogManager.GetLogger("log4net");
        public string strVersion;
        public string mFilename;
        public Microsoft.Office.Interop.Excel.Application app;
        public Microsoft.Office.Interop.Excel.Workbooks wbs;
        public Microsoft.Office.Interop.Excel.Workbook wb;
        public Microsoft.Office.Interop.Excel.Worksheets wss;
        public Microsoft.Office.Interop.Excel.Worksheet ws;
        public ExcelEdit(string Version)
        {
            strVersion = Version.ToLower();
        }
        public void Create()//创建一个Excel对象
        {
            app = new Microsoft.Office.Interop.Excel.Application();
            app.Visible = true;
            wbs = app.Workbooks;
            wb = wbs.Add(true);
            app.DisplayAlerts = false;
            app.AlertBeforeOverwriting = false;
        }
        public void Open(string FileName)//打开一个Excel文件
        {
            try
            {
                app = new Microsoft.Office.Interop.Excel.Application();
                //app.Visible = true;
                wbs = app.Workbooks;
                //wb = wbs.Add(FileName);

                wb = app.Workbooks.Open(FileName, false, false, Type.Missing, Type.Missing, Type.Missing,
                    Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);


                //wb = wbs.Open(FileName, 0, true, 5,"", "", true, Excel.XlPlatform.xlWindows, "t", false, false, 0, true,Type.Missing,Type.Missing);
                //wb = wbs.Open(FileName,Type.Missing,Type.Missing,Type.Missing,Type.Missing,Type.Missing,Type.Missing,Excel.XlPlatform.xlWindows,Type.Missing,Type.Missing,Type.Missing,Type.Missing,Type.Missing,Type.Missing,Type.Missing);
                mFilename = FileName;
            }
            catch (Exception ex)
            {
                //Log.Error(ex);

            }
        }


        public Microsoft.Office.Interop.Excel.Worksheet GetSheet(string SheetName)
        //获取一个工作表
        {
            Microsoft.Office.Interop.Excel.Worksheet s = (Microsoft.Office.Interop.Excel.Worksheet)wb.Worksheets[SheetName];
            return s;
        }
        public Microsoft.Office.Interop.Excel.Worksheet GetSheet(int iSheetIndex)
        //获取一个工作表
        {
            Microsoft.Office.Interop.Excel.Worksheet s = (Microsoft.Office.Interop.Excel.Worksheet)wb.Worksheets[iSheetIndex];
            return s;
        }
        public Microsoft.Office.Interop.Excel.Worksheet AddSheet(string SheetName)
        //添加一个工作表
        {
            Microsoft.Office.Interop.Excel.Worksheet s = (Microsoft.Office.Interop.Excel.Worksheet)wb.Worksheets.Add(Type.Missing, Type.Missing, Type.Missing, Type.Missing);
            s.Name = SheetName;
            return s;
        }
        public Microsoft.Office.Interop.Excel.Worksheet AddSheet()
        //添加一个工作表
        {
            Microsoft.Office.Interop.Excel.Worksheet s = (Microsoft.Office.Interop.Excel.Worksheet)wb.Worksheets.Add(Type.Missing, Type.Missing, Type.Missing, Type.Missing);
            //s.Name = SheetName;
            return s;
        }

        public void CopySheet(string srcSheetName, string destSheetName)
        //复制工作表
        {
            Microsoft.Office.Interop.Excel.Worksheet src = GetSheet(srcSheetName);
            src.Copy(Missing.Value, src); //在SRC之后添加1个SHEET
            Microsoft.Office.Interop.Excel.Worksheet dest = GetSheet(src.Index + 1);
            dest.Name = destSheetName;
        }

        //复制工作表(从某个EXCEL文件的第几个SHEET复制到当前EXCEL的第几个EXCEL之后
        public void CopySheet(string strSrcExcelName, int iSrcSheetIndex, int sDescSheetIndexAfter, string strNewSheetName)
        {
            Microsoft.Office.Interop.Excel.Workbook wb1 = wbs.Open(strSrcExcelName, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing,
                   Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing,
                   Type.Missing, Type.Missing);
            Microsoft.Office.Interop.Excel.Worksheet worksheet1 = (Microsoft.Office.Interop.Excel.Worksheet)wb1.Sheets[iSrcSheetIndex];
            worksheet1.Copy(Missing.Value, this.GetSheet(sDescSheetIndexAfter));
            this.GetSheet(sDescSheetIndexAfter + 1).Name = strNewSheetName;
            wb1.Close(false, Type.Missing, Type.Missing);
            wb1 = null;
        }

        public Microsoft.Office.Interop.Excel.Worksheet AddLastSheet()
        //添加一个工作表(最后)
        {
            Microsoft.Office.Interop.Excel.Worksheet s = (Microsoft.Office.Interop.Excel.Worksheet)wb.Worksheets.Add(GetSheet(wb.Worksheets.Count), Type.Missing, Type.Missing, Type.Missing);
            //s.Name = SheetName;
            return s;
        }

        public void DelSheet(string SheetName)//删除一个工作表
        {
            app.DisplayAlerts = false;
            ((Microsoft.Office.Interop.Excel.Worksheet)wb.Worksheets[SheetName]).Delete();
            app.DisplayAlerts = true;
        }
        public Microsoft.Office.Interop.Excel.Worksheet ReNameSheet(string OldSheetName, string NewSheetName)//重命名一个工作表一
        {
            Microsoft.Office.Interop.Excel.Worksheet s = (Microsoft.Office.Interop.Excel.Worksheet)wb.Worksheets[OldSheetName];
            s.Name = NewSheetName;
            return s;
        }

        public Microsoft.Office.Interop.Excel.Worksheet ReNameSheet(Microsoft.Office.Interop.Excel.Worksheet Sheet, string NewSheetName)//重命名一个工作表二
        {
            Sheet.Name = NewSheetName;
            return Sheet;
        }
        //刷新工作表
        public void RefreshAll()
        {
            wb.RefreshAll();
        }
        //复制单元格
        public void CopyCellValue(Microsoft.Office.Interop.Excel.Worksheet ws, 
            int StartX, int StartY, int StartX1, int StartY1,
            int EndX, int EndY, int EndX1, int EndY1
            )
        {
            ws.get_Range(ws.Cells[StartX, StartY], ws.Cells[StartX1, StartY1]).Copy(Type.Missing);
            ws.get_Range(ws.Cells[EndX, EndY], ws.Cells[EndX1, EndY1]).PasteSpecial(
                    Microsoft.Office.Interop.Excel.XlPasteType.xlPasteAll,
                    Microsoft.Office.Interop.Excel.XlPasteSpecialOperation.xlPasteSpecialOperationNone, false, false);
            //ws.get_Range(ws.Cells[StartX, StartY], ws.Cells[StartX1, StartY1]).Copy(ws.get_Range(ws.Cells[EndX, EndY], ws.Cells[EndX1, EndY1]));
        }
        //选定范围自适应列宽
        public void ColumnsAutoFit(Microsoft.Office.Interop.Excel.Worksheet ws, int x, int y, int x1, int y1)
        {
            ws.get_Range(ws.Cells[x, y], ws.Cells[x1, y1]).EntireColumn.AutoFit();
        }
        //默认使用区域的自适应列宽
        public void ColumnsAutoFit(Microsoft.Office.Interop.Excel.Worksheet ws)
        {
            ws.UsedRange.EntireColumn.AutoFit();
        }

        //选定范围删除数据
        public void ClearContents(Microsoft.Office.Interop.Excel.Worksheet ws, int x, int y, int x1, int y1)
        {
            ws.get_Range(ws.Cells[x, y], ws.Cells[x1, y1]).ClearContents();
        }

        public void SetCellValue(Microsoft.Office.Interop.Excel.Worksheet ws, int x, int y, object value)
        //ws：要设值的工作表     X行Y列     value   值
        {
            ws.Cells[x, y] = value;
        }
        public void SetCellValue(string ws, int x, int y, object value)
        //ws：要设值的工作表的名称 X行Y列 value 值
        {

            GetSheet(ws).Cells[x, y] = value;
        }
        public void SetCellValue(Microsoft.Office.Interop.Excel.Worksheet ws, int x, int y, int x1, int y1, object value)
        //ws：要设值的工作表     X行Y列     value   值
        {
            ws.get_Range(ws.Cells[x, y], ws.Cells[x1, y1]).Value2 = value;
        }

        
        
        public void SetActiveCell(Microsoft.Office.Interop.Excel.Worksheet ws, int x, int y, int x1, int y1)
        {
            Range rg = ws.get_Range(ws.Cells[x, y], ws.Cells[x1, y1]);
            rg.Activate();
        }
         

        public void SetCellProperty(Microsoft.Office.Interop.Excel.Worksheet ws, int Startx, int Starty, int Endx, int Endy, int size, string name, Microsoft.Office.Interop.Excel.Constants color, Microsoft.Office.Interop.Excel.Constants HorizontalAlignment)
        //设置一个单元格的属性   字体，   大小，颜色   ，对齐方式
        {
            name = "宋体";
            size = 12;
            color = Microsoft.Office.Interop.Excel.Constants.xlAutomatic;
            HorizontalAlignment = Microsoft.Office.Interop.Excel.Constants.xlRight;
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Font.Name = name;
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Font.Size = size;
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Font.Color = color;
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).HorizontalAlignment = HorizontalAlignment;
        }

        public void SetCellProperty(string wsn, int Startx, int Starty, int Endx, int Endy, int size, string name, Microsoft.Office.Interop.Excel.Constants color, Microsoft.Office.Interop.Excel.Constants HorizontalAlignment)
        {
            //name = "宋体";
            //size = 12;
            //color = Excel.Constants.xlAutomatic;
            //HorizontalAlignment = Excel.Constants.xlRight;

            Microsoft.Office.Interop.Excel.Worksheet ws = GetSheet(wsn);
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Font.Name = name;
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Font.Size = size;
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Font.Color = color;

            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).HorizontalAlignment = HorizontalAlignment;
        }

        public void SetCellProperty(Microsoft.Office.Interop.Excel.Worksheet ws, int Startx, int Starty, int Endx, int Endy, cellProperty cellProperty)
        //设置一个单元格的属性
        {
            if (cellProperty.Excel_Font() != null) ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Font.Name = cellProperty.Excel_Font();
            if (cellProperty.Excel_FontSize() != 0) ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Font.Size = cellProperty.Excel_FontSize();
            if (cellProperty.Excel_FontColor() != 0) ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Font.ColorIndex = cellProperty.Excel_FontColor();
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).HorizontalAlignment = cellProperty.Excel_HorizontalAlignment();
            if (cellProperty.Excel_BackgroudColor() != 0) ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Interior.ColorIndex = cellProperty.Excel_BackgroudColor();
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Font.Bold = cellProperty.Excel_FontBond();
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).NumberFormat = cellProperty.Excel_Format();
        }

        public void CopyFormat(Microsoft.Office.Interop.Excel.Worksheet ws, int Startx, int Starty, int Endx, int Endy, int toStartx, int toStarty, int toEndx, int toEndy)
        //格式刷区域
        {
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Copy(Type.Missing);
            ws.get_Range(ws.Cells[toStartx, toStarty], ws.Cells[toEndx, toEndy]).PasteSpecial(
                    Microsoft.Office.Interop.Excel.XlPasteType.xlPasteFormats,
                    Microsoft.Office.Interop.Excel.XlPasteSpecialOperation.xlPasteSpecialOperationNone, false, false);

        }

        public void RunMacro(string name)
        {
            try
            {
                app.Run(name, Missing.Value, Missing.Value, Missing.Value, Missing.Value,
                    Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value,
                    Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value,
                    Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value,
                    Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value,
                    Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value,
                    Missing.Value);
            }
            catch (Exception ex)
            {
            }
        }

        public void SetCellLineStyle(Microsoft.Office.Interop.Excel.Worksheet ws, int Startx, int Starty, int Endx, int Endy)
        //设置网格线
        {
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Borders.LineStyle = 1;
            ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).Columns.AutoFit();
            //ws.get_Range(ws.Cells[Startx, Starty], ws.Cells[Endx, Endy]).AutoFit();
        }

        public void UniteCells(Microsoft.Office.Interop.Excel.Worksheet ws, int x1, int y1, int x2, int y2)
        //合并单元格
        {
            app.DisplayAlerts = false;
            ws.get_Range(ws.Cells[x1, y1], ws.Cells[x2, y2]).Merge(Type.Missing);
        }

        public void UniteCells(string ws, int x1, int y1, int x2, int y2)
        //合并单元格
        {
            app.DisplayAlerts = false;
            GetSheet(ws).get_Range(GetSheet(ws).Cells[x1, y1], GetSheet(ws).Cells[x2, y2]).Merge(Type.Missing);

        }


        public void InsertTable(System.Data.DataTable dt, string ws, int startX, int startY)
        //将内存中数据表格插入到Excel指定工作表的指定位置 为在使用模板时控制格式时使用一
        {

            for (int i = 0; i <= dt.Rows.Count - 1; i++)
            {
                for (int j = 0; j <= dt.Columns.Count - 1; j++)
                {
                    GetSheet(ws).Cells[startX + i, j + startY] = dt.Rows[i][j].ToString();

                }

            }

        }
        public void InsertTable(System.Data.DataTable dt, Microsoft.Office.Interop.Excel.Worksheet ws, int startX, int startY)
        //将内存中数据表格插入到Excel指定工作表的指定位置二
        {

            for (int i = 0; i <= dt.Rows.Count - 1; i++)
            {
                for (int j = 0; j <= dt.Columns.Count - 1; j++)
                {

                    ws.Cells[startX + i, j + startY] = dt.Rows[i][j];

                }

            }

        }


        public void AddTable(System.Data.DataTable dt, string ws, int startX, int startY)
        //将内存中数据表格添加到Excel指定工作表的指定位置一
        {

            for (int i = 0; i <= dt.Rows.Count - 1; i++)
            {
                for (int j = 0; j <= dt.Columns.Count - 1; j++)
                {

                    GetSheet(ws).Cells[i + startX, j + startY] = dt.Rows[i][j];

                }

            }

        }
        public void AddTable(System.Data.DataTable dt, Microsoft.Office.Interop.Excel.Worksheet ws, int startX, int startY)
        //将内存中数据表格添加到Excel指定工作表的指定位置二
        {


            for (int i = 0; i <= dt.Rows.Count - 1; i++)
            {
                for (int j = 0; j <= dt.Columns.Count - 1; j++)
                {

                    ws.Cells[i + startX, j + startY] = dt.Rows[i][j];

                }
            }

        }
        //public void InsertPictures(string Filename, string ws)
        ////插入图片操作一
        //{
        //    GetSheet(ws).Shapes.AddPicture(Filename, MsoTriState.msoFalse, MsoTriState.msoTrue, 10, 10, 150, 150);
        //    //后面的数字表示位置
        //}

        //public void InsertPictures(string Filename, string ws, int Height, int Width)
        //插入图片操作二
        //{
        //    GetSheet(ws).Shapes.AddPicture(Filename, MsoTriState.msoFalse, MsoTriState.msoTrue, 10, 10, 150, 150);
        //    GetSheet(ws).Shapes.get_Range(Type.Missing).Height = Height;
        //    GetSheet(ws).Shapes.get_Range(Type.Missing).Width = Width;
        //}
        //public void InsertPictures(string Filename, string ws, int left, int top, int Height, int Width)
        //插入图片操作三
        //{

        //    GetSheet(ws).Shapes.AddPicture(Filename, MsoTriState.msoFalse, MsoTriState.msoTrue, 10, 10, 150, 150);
        //    GetSheet(ws).Shapes.get_Range(Type.Missing).IncrementLeft(left);
        //    GetSheet(ws).Shapes.get_Range(Type.Missing).IncrementTop(top);
        //    GetSheet(ws).Shapes.get_Range(Type.Missing).Height = Height;
        //    GetSheet(ws).Shapes.get_Range(Type.Missing).Width = Width;
        //}

        public void InsertActiveChart(Microsoft.Office.Interop.Excel.XlChartType ChartType, string ws, int DataSourcesX1, int DataSourcesY1, int DataSourcesX2, int DataSourcesY2, Microsoft.Office.Interop.Excel.XlRowCol ChartDataType)
        //插入图表操作
        {
            ChartDataType = Microsoft.Office.Interop.Excel.XlRowCol.xlColumns;
            wb.Charts.Add(Type.Missing, Type.Missing, Type.Missing, Type.Missing);
            {
                wb.ActiveChart.ChartType = ChartType;
                wb.ActiveChart.SetSourceData(GetSheet(ws).get_Range(GetSheet(ws).Cells[DataSourcesX1, DataSourcesY1], GetSheet(ws).Cells[DataSourcesX2, DataSourcesY2]), ChartDataType);
                wb.ActiveChart.Location(Microsoft.Office.Interop.Excel.XlChartLocation.xlLocationAsObject, ws);
            }
        }
        public bool Save()
        //保存文档
        {
            if (mFilename == "")
            {
                return false;
            }
            else
            {
                wb.Save();
                return true;
            }
        }
        public string SaveAs(object FileName)
        //文档另存为
        {
            try
            {
                string strPostfix = getPostfix();
                string strFileName = FileName.ToString() + strPostfix;
                if (strPostfix.Equals(".xls"))
                    wb.SaveAs(strFileName, Microsoft.Office.Interop.Excel.XlFileFormat.xlExcel8, Type.Missing, Type.Missing, Type.Missing, Type.Missing, XlSaveAsAccessMode.xlExclusive, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);
                //wb.SaveAs(strFileName, Microsoft.Office.Interop.Excel.XlFileFormat.xlExcel7, Type.Missing, Type.Missing, Type.Missing, Type.Missing, XlSaveAsAccessMode.xlExclusive, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);
                if (strPostfix.Equals(".xlsx"))
                    wb.SaveAs(strFileName, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Microsoft.Office.Interop.Excel.XlSaveAsAccessMode.xlExclusive, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);

                //wb.SaveAs(strFileName, XlFileFormat.xlOpenXMLWorkbook, Type.Missing, Type.Missing, Type.Missing, Type.Missing,
                //   XlSaveAsAccessMode.xlExclusive, XlSaveConflictResolution.xlLocalSessionChanges, Type.Missing, Type.Missing, Type.Missing, Type.Missing);

                if (strPostfix.Equals(".html"))
                {
                    wb.PublishObjects.Add(XlSourceType.xlSourceSheet, strFileName, "明细", Type.Missing, Microsoft.Office.Interop.Excel.XlHtmlType.xlHtmlStatic, "abc", "手术日报");
                    wb.PublishObjects.Publish();
                    wb.PublishObjects.Delete();
                }
                // wb.SaveAs(strFileName, Microsoft.Office.Interop.Excel.XlFileFormat.xlHtml, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Microsoft.Office.Interop.Excel.XlSaveAsAccessMode.xlNoChange, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);

                return strFileName;
            }
            catch (Exception ex)
            {
                //Log.Error(ex);
                return null;

            }
        }

        public string SaveAsHtml(string FileName, string[] strHtml)
        //文档另存为
        {
            try
            {
                string strPostfix = getPostfix();
                string strFileName = FileName + strPostfix;

                if (strPostfix.Equals(".html"))
                {
                    for (int i = 0; i < strHtml.Length; i++)
                    {
                        wb.PublishObjects.Add(XlSourceType.xlSourceSheet, strFileName, strHtml[i], Type.Missing, Microsoft.Office.Interop.Excel.XlHtmlType.xlHtmlStatic, strHtml[i], strHtml[i]);

                    }
                    wb.PublishObjects.Publish();
                    wb.PublishObjects.Delete();
                    wb.Save();
                }
                // wb.SaveAs(strFileName, Microsoft.Office.Interop.Excel.XlFileFormat.xlHtml, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Microsoft.Office.Interop.Excel.XlSaveAsAccessMode.xlNoChange, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);

                return strFileName;
            }
            catch (Exception ex)
            {
                return null;

            }
        }

        private string getPostfix()
        {
            string strPostfix = "";
            if (!string.IsNullOrEmpty(strVersion) && strVersion.Equals("excel2003"))
            {
                strPostfix = ".xls";
            }
            if (!string.IsNullOrEmpty(strVersion) && strVersion.Equals("excel2007"))
            {
                strPostfix = ".xlsx";
            }
            if (!string.IsNullOrEmpty(strVersion) && strVersion.Equals("html"))
            {
                strPostfix = ".html";
            }
            if (string.IsNullOrEmpty(strPostfix))
            {
                if (app.Version.Contains("12."))
                    strPostfix = ".xlsx";
                else
                    strPostfix = ".xls";
            }
            return strPostfix;
        }

        public void Close()
        //关闭一个Excel对象，销毁对象
        {
            //wb.Save();
            wb.Close(Type.Missing, Type.Missing, Type.Missing);
            wbs.Close();
            app.Quit();
            //Kill(app);
            wb = null;
            wbs = null;
            app = null;
            GC.Collect();
        }

        public void CloseWithoutSave()
        //关闭一个Excel对象，销毁对象
        {
            //wb.Save();
            wb.Close(false, Type.Missing, Type.Missing);
            wbs.Close();
            app.Quit();
            //Kill(app);
            wb = null;
            wbs = null;
            app = null;
            GC.Collect();
        }

        [DllImport("User32.dll", CharSet = CharSet.Auto)]
        private static extern int GetWindowThreadProcessId(IntPtr hwnd, out int ID);
        private static void Kill(Microsoft.Office.Interop.Excel.Application excel)
        {
            IntPtr t = new IntPtr(excel.Hwnd);   //得到这个句柄，具体作用是得到这块内存入口 
            int k = 0;
            GetWindowThreadProcessId(t, out k);   //得到本进程唯一标志k
            System.Diagnostics.Process p = System.Diagnostics.Process.GetProcessById(k);   //得到对进程k的引用
            p.Kill();     //关闭进程k
        }
    }
}
