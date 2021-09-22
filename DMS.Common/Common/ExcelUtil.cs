using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using NPOI;
using NPOI.HPSF;
using NPOI.HSSF;
using NPOI.HSSF.UserModel;
using NPOI.HSSF.Util;
using NPOI.POIFS;
using NPOI.Util;
using NPOI.SS.UserModel;
using NPOI.SS.Util;
using NPOI.XSSF.UserModel;

namespace DMS.Common.Common
{
    public static class ExcelUtil
    {
        #region 私有方法
        /// <summary>
        /// 为拼接SQL语句给字符串加引号
        /// </summary>
        /// <param name="str">字符串</param>
        /// <returns>加引号后的字符串，单引号被替换成两个单引号。</returns>
        private static String QuotedStr(String str)
        {
            return "'" + str.Replace("'", "''") + "'";
        }

        /// <summary>
        /// 为拼接SQL语句给对象加引号（SQL Server版本）
        /// </summary>
        /// <param name="obj">要拼接到SQL语句中的对象。</param>
        /// <returns>根据对象类型，返回拼接到SQL语句中的字符串。</returns>
        private static String QuotedObject(Object obj)
        {
            if (obj == null) return "NULL";

            if (obj == DBNull.Value)
            {
                return "NULL";
            }
            if (obj is String)
            {
                return QuotedStr(obj as String);
            }
            if (obj is DateTime)
            {
                return "'" + ((DateTime)obj).ToString("yyyy/MM/dd") + "'";
            }
            if (obj is Guid)
            {
                return "'" + obj + "'";
            }
            if (obj is Boolean)
            {
                return (bool)obj ? "1" : "0";
            }
            return obj.ToString();
        }

        /// <summary>
        /// 下载指定的文件
        /// </summary>
        /// <param name="fileName">下载文件名</param>
        /// <param name="fileFullPath">要下载的物理文件路径。</param>
        /// <param name="deleteAfterResponse">下载完成后是否删除。</param>
        public static void ResponseExcelFile(String fileName, String fileFullPath, bool deleteAfterResponse)
        {
            try
            {
                FileInfo fileInfo = new FileInfo(fileFullPath);
                string aLastName = fileFullPath.Substring(fileFullPath.LastIndexOf(".") + 1, (fileFullPath.Length - fileFullPath.LastIndexOf(".") - 1));
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Charset = "UTF-8";
                HttpContext.Current.Response.ContentEncoding = Encoding.UTF8;
                HttpContext.Current.Response.AppendHeader("Content-Disposition",
                                                                     "attachment; filename=" +
                                                                     HttpUtility.UrlEncode(fileName, Encoding.UTF8) + "."+ aLastName
                                                                     );
                HttpContext.Current.Response.AddHeader("Content-Length", fileInfo.Length.ToString());
                HttpContext.Current.Response.ContentType = "application/vnd.ms-excel;charset=UTF8";
                HttpContext.Current.Response.ContentEncoding = Encoding.UTF8;
                HttpContext.Current.Response.WriteFile(fileInfo.FullName);
                HttpContext.Current.Response.WriteFile(fileInfo.FullName, 0, fileInfo.Length);
                HttpContext.Current.Response.Flush();
                if (deleteAfterResponse)
                {
                    File.Delete(fileFullPath);
                }
                //HttpContext.Current.Response.End();
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        #endregion 私有方法

        #region Excel导入

        /// <summary>
        /// 从Excel提取数据--》Dataset
        /// </summary>
        /// <param name="fileName">Excel文件路径名</param>
        /// <param name="sheetName">SheetName</param>
        /// <returns></returns>
        public static DataSet GetUpLoadExcelToDataSet(FileUpload ful)
        {
            DataSet ds = new DataSet();
            string fileExt = Path.GetExtension(ful.FileName).ToLower();
            if (Path.GetExtension(ful.FileName).ToLower() != ".xlsx" && Path.GetExtension(ful.FileName).ToLower() != ".xls")
            {
                throw new Exception("文件必须为Excel格式");
                //return null;
            }

            string targetFullFilename = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString() + fileExt);
            ful.SaveAs(targetFullFilename);

            //将第一行作为数据行读取，以便将所有内容作为字符串处理
            OleDbConnection ExcelConn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + targetFullFilename + ";Extended Properties=\"Excel 12.0 Xml;HDR=YES;\"");
            try
            {
                ExcelConn.Open();
                string sqlMaster;
                OleDbDataAdapter oleAdMaster = null;
                foreach (DataRow dr in ExcelConn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null).Rows)
                {
                    string TableName = dr["Table_Name"].ToString();
                    if (TableName.EndsWith("$"))
                    {
                        sqlMaster = string.Format(" SELECT *  FROM [{0}]", TableName);
                        oleAdMaster = new OleDbDataAdapter(sqlMaster, ExcelConn);

                        oleAdMaster.Fill(ds, TableName.Substring(0, TableName.Length - 1));
                    }
                }
                oleAdMaster.Dispose();
                ExcelConn.Close();
                ExcelConn.Dispose();
                return ds;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                ExcelConn.Close();
                System.IO.File.Delete(targetFullFilename);
            }
        }


        public static DataTable GetDataTable(String filepath, String SheetName)
        {
            return ExcelUtil.GetDataTable(filepath, SheetName, false);
        }

        public static DataTable GetDataTable(String filepath, String SheetName, bool containHead)
        {
            try
            {
                String fileExt = Path.GetExtension(filepath);
                OleDbConnection oledbcon = null;

                if (fileExt == ".xls")
                {
                    //导入数字字符较长或导入数字格式为字符串时oledb读出的记录数据会以科学计数法显示(HDR=YES修改NO 前8行为数字，后边行数某列会变为空)
                    oledbcon = new OleDbConnection("Provider=Microsoft.ACE.OleDb.12.0;Data Source=" + filepath + ";Extended Properties='Excel 8.0;HDR=No;IMEX=1;'");
                }
                else if (fileExt == ".xlsx")
                {
                    oledbcon = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filepath + ";Extended Properties='Excel 12.0;HDR=No;IMEX=1;MaxScanRows=0;'");
                }
                OleDbDataAdapter oledbAdaptor = new OleDbDataAdapter("SELECT * FROM [" + SheetName + "$]", oledbcon);

                DataSet ds = new DataSet();
                oledbAdaptor.Fill(ds);
                oledbcon.Close();

                if (!containHead)
                {
                    ds.Tables[0].Rows.RemoveAt(0);
                }

                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                throw new Exception("文件格式错误，找不到名字为[" + SheetName + "]的sheet");
            }
        }

        #endregion Excel导入

        #region Excel导出

        /// <summary>
        /// 导出Excel文件为2007 格式 
        /// </summary>
        /// <param name="fileName">文件名</param>
        /// <param name="dt"></param>
        public static void ExportDataTableAsExcel2007(string fileName, DataTable dt)
        {
            ResponseExcelFile(fileName, ExportDataTableExcel(dt), true);
        }

        /// <summary>
        /// 导出Excel文件为2007 格式
        /// </summary>
        /// <param name="fileName">文件名</param>
        /// <param name="ds"></param>
        public static void ExportDataSetAsExcel2007(string fileName, DataSet ds)
        {
            ResponseExcelFile(fileName, ExportDataSetExcel(ds), true);
        }

        private static string ExportDataSetExcel(DataSet ds)
        {
            String file = Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".xlsx");
            String connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + file + ";Extended Properties=\"Excel 12.0 Xml;\"";
            OleDbConnection conn = new OleDbConnection(connStr);
            conn.Open();
            try
            {
                String sql = "";
                foreach (DataTable table in ds.Tables)
                {
                    sql = "";
                    foreach (DataColumn column in table.Columns)
                    {
                        if (sql.Length != 0)
                        {
                            sql += ",";
                        }

                        if (column.DataType == typeof(string) || column.DataType == typeof(DateTime) ||
                            column.DataType == typeof(Guid))
                        {
                            sql += "[" + column.ColumnName + "] TEXT NULL";
                        }
                        else
                        {
                            sql += "[" + column.ColumnName + "] DECIMAL NULL";
                        }
                    }

                    if (sql.Length != 0)
                    {
                        if (table.TableName == "")
                            table.TableName = "Sheet1";
                        sql = "CREATE TABLE [" + table.TableName + "] (" + sql + ")";

                        OleDbCommand cmd = new OleDbCommand(sql, conn);
                        cmd.ExecuteNonQuery();
                        foreach (DataRow row in table.Rows)
                        {
                            sql = "";
                            String fields = "";
                            foreach (DataColumn column in table.Columns)
                            {
                                if (sql.Length != 0)
                                {
                                    sql += ",";
                                    fields += ",";
                                }
                                sql += QuotedObject(row[column]);
                                fields += "[" + column.ColumnName + "]";
                            }

                            if (sql.Length != 0)
                            {
                                cmd.CommandText = "INSERT INTO [" + table.TableName + "] (" + fields + ") VALUES (" +
                                                  sql +
                                                  ")";
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
            }
            return file;
        }

        private static string ExportDataTableExcel(DataTable dt)
        {
            String file = Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".xlsx");
            String connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + file + ";Extended Properties=\"Excel 12.0 Xml;\"";
            OleDbConnection conn = new OleDbConnection(connStr);
            conn.Open();
            try
            {
                String sql = "";

                sql = "";
                foreach (DataColumn column in dt.Columns)
                {
                    if (sql.Length != 0)
                    {
                        sql += ",";
                    }

                    if (column.DataType == typeof(string) || column.DataType == typeof(DateTime) ||
                        column.DataType == typeof(Guid))
                    {
                        sql += "[" + column.ColumnName + "] TEXT NULL";
                    }
                    else
                    {
                        sql += "[" + column.ColumnName + "] DECIMAL NULL";
                    }
                }

                if (sql.Length != 0)
                {
                    if (dt.TableName == "")
                        dt.TableName = "Sheet1";
                    sql = "CREATE TABLE [" + dt.TableName + "] (" + sql + ")";
                    OleDbCommand cmd = new OleDbCommand(sql, conn);
                    cmd.ExecuteNonQuery();
                    foreach (DataRow row in dt.Rows)
                    {
                        sql = "";
                        String fields = "";
                        foreach (DataColumn column in dt.Columns)
                        {
                            if (sql.Length != 0)
                            {
                                sql += ",";
                                fields += ",";
                            }
                            sql += QuotedObject(row[column]);
                            fields += "[" + column.ColumnName + "]";
                        }

                        if (sql.Length != 0)
                        {
                            cmd.CommandText = "INSERT INTO [" + dt.TableName + "] (" + fields + ") VALUES (" + sql +
                                              ")";
                            cmd.ExecuteNonQuery();
                        }
                    }
                }

            }
            finally
            {
                conn.Close();
            }

            return file;
        }

        #endregion Excel导出
    }

    public static class ExcelExporter
    {
        /// <summary>
        /// 根据DataSet生成Excel文件
        /// </summary>
        /// <param name="ds">要导出数据的DataSet</param>
        /// <returns></returns>
        private static string GenerateExcelFromDataSet(DataSet ds)
        {
            String strfilePath = Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".xls");
            using (FileStream fileStream = File.Create(strfilePath))
            {
                XSSFWorkbook workbook = new XSSFWorkbook();
                foreach (DataTable dataTable in ds.Tables)
                {
                    //构造Sheet
                    ISheet sheet =
                        workbook.CreateSheet(string.IsNullOrEmpty(dataTable.TableName)
                                                 ? Guid.NewGuid().ToString()
                                                 : dataTable.TableName);


                    //背景色
                    ICellStyle style8 = workbook.CreateCellStyle();
                    style8.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.Grey25Percent.Index;
                    style8.FillPattern = FillPattern.SolidForeground;

                    ICellStyle style9 = workbook.CreateCellStyle();
                    style9.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.Rose.Index;
                    style9.FillPattern = FillPattern.SolidForeground;

                    ICellStyle style10 = workbook.CreateCellStyle();
                    style10.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.Yellow.Index;
                    style10.FillPattern = FillPattern.SolidForeground;

                    //日期格式
                    ICellStyle dateLockStyle = workbook.CreateCellStyle();
                    IDataFormat format = workbook.CreateDataFormat();
                    dateLockStyle.DataFormat = format.GetFormat("yyyy-mm-dd");
                    dateLockStyle.IsLocked = true;

                    ICellStyle unDateLockStyle = workbook.CreateCellStyle();
                    unDateLockStyle.DataFormat = format.GetFormat("yyyy-mm-dd");
                    unDateLockStyle.IsLocked = false;

                    //金额格式
                    ICellStyle decimalStyle = workbook.CreateCellStyle();
                    decimalStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("0.000000");
                    decimalStyle.IsLocked = true;

                    ICellStyle unLockDecimalStyle = workbook.CreateCellStyle();
                    unLockDecimalStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("0.000000");
                    unLockDecimalStyle.IsLocked = false;

                    //锁定格式
                    ICellStyle lockStyle = workbook.CreateCellStyle();
                    lockStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("@");
                    lockStyle.IsLocked = true;

                    //非锁定格式
                    ICellStyle unLockStyle = workbook.CreateCellStyle();
                    unLockStyle.DataFormat = HSSFDataFormat.GetBuiltinFormat("@");
                    unLockStyle.IsLocked = false;

                    //构造表头
                    IRow rowHeader = sheet.CreateRow(0);
                    for (int i = 0; i < dataTable.Columns.Count; i++)
                    {
                        ICell cellHeader = rowHeader.CreateCell(dataTable.Columns[i].Ordinal);
                        cellHeader.SetCellValue(dataTable.Columns[i].ColumnName);
                        cellHeader.CellStyle = style8;

                        //初始化所有的列都为非锁定
                        sheet.SetDefaultColumnStyle(i, lockStyle);
                        sheet.SetColumnWidth(i, 3000);
                    }

                    //构造Body
                    for (int i = 0; i < dataTable.Rows.Count; i++)
                    {
                        IRow rowBody = sheet.CreateRow(i + 1);

                        foreach (DataColumn column in dataTable.Columns)
                        {
                            string drValue = dataTable.Rows[i][column].ToString();

                            ICell cellBody = rowBody.CreateCell(column.Ordinal);

                            switch (column.DataType.ToString())
                            {
                                case "System.String"://字符串类型
                                    cellBody.SetCellValue(drValue);
                                    cellBody.CellStyle = unLockStyle;
                                    break;
                                case "System.DateTime"://日期类型   
                                    DateTime dateV;
                                    if (DateTime.TryParse(drValue, out dateV))
                                    {
                                        cellBody.SetCellValue(dateV);
                                        cellBody.CellStyle = dateLockStyle;
                                    }
                                    break;
                                case "System.Boolean"://布尔型   
                                    if (string.IsNullOrEmpty(drValue))
                                    {
                                        cellBody.SetCellValue(string.Empty);
                                    }
                                    else
                                    {
                                        bool boolV = false;
                                        bool.TryParse(drValue, out boolV);
                                        string boolStr = string.Empty;
                                        boolStr = boolV ? "是" : "否";
                                        cellBody.SetCellValue(boolStr);
                                    }

                                    cellBody.CellStyle = unLockStyle;
                                    break;
                                case "System.Int16"://整型   
                                case "System.Int32":
                                case "System.Int64":
                                case "System.Byte":

                                    if (string.IsNullOrEmpty(drValue))
                                    {
                                        cellBody.SetCellValue(string.Empty);
                                    }
                                    else
                                    {
                                        int intV = 0;
                                        int.TryParse(drValue, out intV);
                                        cellBody.SetCellValue(intV);
                                    }

                                    cellBody.CellStyle = unLockStyle;
                                    break;
                                case "System.Decimal"://浮点型   
                                case "System.Double":

                                    if (string.IsNullOrEmpty(drValue))
                                    {
                                        cellBody.SetCellValue(string.Empty);
                                    }
                                    else
                                    {
                                        double doubV = 0;
                                        double.TryParse(drValue, out doubV);
                                        cellBody.SetCellValue(doubV);
                                    }

                                    cellBody.CellStyle = decimalStyle;
                                    break;

                                case "System.DBNull"://空值处理   
                                    cellBody.SetCellValue("");
                                    cellBody.CellStyle = unLockStyle;
                                    break;
                                default:
                                    cellBody.SetCellValue("");
                                    cellBody.CellStyle = unLockStyle;
                                    break;
                            }
                        }
                    }
                }
                workbook.Write(fileStream);
                fileStream.Close();
            }
            return strfilePath;
        }

        private static string GenerateCsvFromDataSet(DataSet ds)
        {
            String strfilePath = Path.Combine(Path.GetTempPath(), Guid.NewGuid() + ".csv");

            DataTable dt = ds.Tables[0];
            FileStream fs = null;
            StreamWriter sw = null;
            try
            {
                fs = new FileStream(strfilePath, System.IO.FileMode.Create, System.IO.FileAccess.Write);
                sw = new StreamWriter(fs, new System.Text.UnicodeEncoding());
                //Tabel header
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    sw.Write(dt.Columns[i].ColumnName);
                    sw.Write("\t");
                }
                sw.WriteLine("");
                //Table body
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    for (int j = 0; j < dt.Columns.Count; j++)
                    {
                        //sw.Write(DelQuota(dt.Rows[i][j].ToString()));
                        sw.Write(dt.Rows[i][j].ToString());
                        sw.Write("\t");
                    }
                    sw.WriteLine("");
                }
                sw.Flush();
            }
            catch (Exception ex)
            {

            }
            finally
            {
                if (sw != null)
                {
                    sw.Close();
                }

                if (fs != null)
                {
                    fs.Close();
                }
            }
            return strfilePath;
        }

        public static string DelQuota(string str)
        {
            string result = str;
            string[] strQuota = { "~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "`", ";", "'", ",", ".", "/", ":", "/,", "<", ">", "?" };
            for (int i = 0; i < strQuota.Length; i++)
            {
                if (result.IndexOf(strQuota[i]) > -1)
                    result = result.Replace(strQuota[i], "");
            }
            return result;
        }

        /// <summary>
        /// 由DataSet导出Excel
        /// </summary>
        /// <param name="fileName">指定Excel文件名称</param>
        /// <param name="ds">要导出数据的DataSet</param>
        /// <returns></returns>
        public static void ExportDataSetToExcel(DataSet ds)
        {
            string strFilePath = GenerateCsvFromDataSet(ds);
            ExcelUtil.ResponseExcelFile(ds.DataSetName, strFilePath, true);
        }
    }
}
