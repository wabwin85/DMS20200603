using NPOI.HSSF.UserModel;
using NPOI.SS.Formula.Eval;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BatchImportService
{
    public class DBHelper
    {
        private string ConnStr = "server = 47.102.205.10;database = GenesisDMS_PRD;uid = sa;pwd = Gm123456";
        public void Sun()
        {
            ISheet sheet;
            string fullpath = @"C:\Users\zonghuihe\Desktop\促销导入\政策.xlsx"; //文件路径
            string filename = "政策.xlsx";//文件名称
            readSheet(fullpath, filename, out sheet);
            DataTable dt = new DataTable();
            IEnumerator rows = sheet.GetRowEnumerator();

            int rowCount = sheet.LastRowNum;//LastRowNum = PhysicalNumberOfRows - 1

            for (int j = 0; j < (sheet.GetRow(0).LastCellNum); j++)
            {
                DataColumn column = new DataColumn(HandleIn(sheet.GetRow(0).GetCell(j).StringCellValue));
                dt.Columns.Add(column);
            }

            int colCount = dt.Columns.Count;
            //将Sheet中的数据放到table中；
            for (int i = 1; i <= sheet.LastRowNum; i++)
            {
                IRow row = sheet.GetRow(i);
                if (row != null)
                {
                    //处理空行
                    if (row.Cells.Count <= 0)
                    {
                        continue;
                    }
                    DataRow dataRow = dt.NewRow();
                    if (row != null)
                    {
                        for (int j = 0; j < colCount; j++)//row.LastCellNum
                        {
                            if (j == 0)
                                dataRow[j] = Guid.NewGuid();
                            else
                                dataRow[j] = getCellValue(row.GetCell(j));// row.GetCell(j).ToString();
                        }

                        dataRow[colCount - 1] = i + 1;      //行号

                        dt.Rows.Add(dataRow);
                    }
                }
            }
            //根据导入的业务类型，检查导入模板是否正确
            string templateErrorMsg = string.Empty;

            List<string> tableColumn = new List<string>();
            tableColumn.Add("Id");
            tableColumn.Add("BU");
            tableColumn.Add("UseType");
            tableColumn.Add("AuthScope");
            tableColumn.Add("Remark1");
            tableColumn.Add("Remark2");
            tableColumn.Add("Remark3");
            tableColumn.Add("Remark4");
            DataTableToSQLServer(dt, tableColumn, "ExportTemp");
        }

        public string HandleIn(string obj)
        {
            string result = string.Empty;
            switch (obj)
            {
                case "Id":
                    result = "Id";
                    break;
                case "BU":
                    result = "BU";
                    break;
                case "类型":
                    result = "UseType";
                    break;
                case "授权范围":
                    result = "AuthScope";
                    break;
                case "备注1":
                    result = "Remark1";
                    break;
                case "备注2":
                    result = "Remark2";
                    break;
                case "备注3":
                    result = "Remark3";
                    break;
                case "备注4":
                    result = "Remark4";
                    break;
            }
            return result;
        }
        protected void readSheet(string fullpath, string filename, out ISheet sheet)
        {
            //读取xlsx文件；
            XSSFWorkbook xssfworkbook;
            //读取xls文件；
            HSSFWorkbook hssfworkbook;
            try
            {
                using (FileStream file = new FileStream(fullpath, FileMode.Open, FileAccess.Read))
                {
                    if (Path.GetExtension(filename).ToLower() == ".xlsx")
                    {
                        xssfworkbook = new XSSFWorkbook(file);
                        sheet = xssfworkbook.GetSheetAt(0);

                    }
                    else
                    {
                        hssfworkbook = new HSSFWorkbook(file);

                        sheet = hssfworkbook.GetSheetAt(0);
                    }
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        protected string getCellValue(ICell cell)
        {
            string rtnvalue = string.Empty;
            if (cell == null) return "";
            switch (cell.CellType)
            {
                case CellType.Boolean:
                    rtnvalue = cell.BooleanCellValue.ToString();
                    break;
                case CellType.Error:
                    rtnvalue = ErrorEval.GetText(cell.ErrorCellValue);
                    break;
                case CellType.Numeric:
                    if (DateUtil.IsCellDateFormatted(cell))
                    {//Excel日期格式列的type也为Numeric；
                        rtnvalue = cell.DateCellValue.ToString("yyyy-MM-dd");
                    }
                    else
                    {
                        rtnvalue = cell.NumericCellValue.ToString();
                    }
                    break;
                case CellType.String:
                    string strValue = cell.StringCellValue;
                    if (!string.IsNullOrEmpty(strValue))
                    {
                        rtnvalue = strValue.ToString();
                    }
                    else
                    {
                        rtnvalue = null;
                    }
                    break;
                case CellType.Unknown:
                case CellType.Blank:
                default:
                    rtnvalue = string.Empty;
                    break;
            }

            return rtnvalue;
        }

        public bool DataTableToSQLServer(DataTable dt, List<string> tableColumn, string tablename)
        {
            bool Status = false;
            using (var conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (SqlTransaction tran = conn.BeginTransaction())
                {
                    using (SqlCommand command = new SqlCommand("", conn))
                    {
                        try
                        {
                            command.CommandTimeout = 600;
                            command.Transaction = tran;
                            using (SqlBulkCopy sqlbulkcopy = new SqlBulkCopy(conn, SqlBulkCopyOptions.Default, tran))
                            {
                                sqlbulkcopy.DestinationTableName = tablename;
                                for (int i = 0; i < dt.Columns.Count; i++)
                                {
                                    sqlbulkcopy.ColumnMappings.Add(dt.Columns[i].ColumnName, dt.Columns[i].ColumnName);
                                }
                                sqlbulkcopy.WriteToServer(dt);
                            }
                            tran.Commit();
                            Status = true;
                        }
                        catch (Exception ex)
                        {
                            tran.Rollback();
                        }
                    }
                }
            }
            return Status;
        }

    }
}
