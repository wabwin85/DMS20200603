using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.OleDb;
using System.IO;

namespace DMS.Website.Common
{
    public class ExcelHelper
    {
        public static DataTable GetDataTable(string filePath, string sheet)
        {
            System.Diagnostics.Debug.WriteLine("GetDataSet Start : " + DateTime.Now.ToString());
            string fileExtention = System.IO.Path.GetExtension(filePath).ToLower();
            string strConn = null;
            string strTable = string.Format("select * from [{0}$]", sheet);
            DataSet ds = new DataSet();

            //if (fileExtention == ".xls")
            //{
            //    strConn = "Provider=Microsoft.Jet.OLEDB.4.0;" + "Data Source=" + filePath + ";" + "Extended Properties=\"Excel 8.0;HDR=NO;IMEX=1;\"";
            //}
            //else if (fileExtention == ".xlsx")
            //{
            //    strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + filePath + ";" + "Extended Properties=\"Excel 12.0;HDR=NO;IMEX=1;\"";
            //}

            strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + filePath + ";" + "Extended Properties=\"Excel 12.0;HDR=NO;IMEX=1;\"";

            using (OleDbConnection conn = new OleDbConnection(strConn))
            {
                conn.Open();
                OleDbDataAdapter adapter = new OleDbDataAdapter(strTable, strConn);
                adapter.Fill(ds, sheet);
                conn.Close();
            }
            System.Diagnostics.Debug.WriteLine("GetDataSet Finish : " + DateTime.Now.ToString());
            return ds.Tables[sheet];
        }

        /// <summary>
        /// 根据上传的文件，读取指定工作表的数据
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="sheets"></param>
        /// <returns></returns>
        public static DataSet GetDataSet(string filePath, string[] sheets)
        {
            string fileExtention = Path.GetExtension(filePath).ToLower();
            string strConn = null;

            DataSet ds = new DataSet();

            if (fileExtention == ".xls")
            {
                strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + filePath + ";" + "Extended Properties=\"Excel 8.0;HDR=NO;IMEX=1;\"";
            }
            else if (fileExtention == ".xlsx")
            {
                strConn = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + filePath + ";" + "Extended Properties=\"Excel 12.0;HDR=NO;IMEX=1;\"";
            }

            string errMsg = string.Empty;

            using (OleDbConnection conn = new OleDbConnection(strConn))
            {
                try
                {
                    conn.Open();
                    foreach (string sheet in sheets)
                    {
                        try
                        {
                            OleDbDataAdapter adapter = new OleDbDataAdapter("select * from [" + sheet + "$]", strConn);
                            adapter.Fill(ds, sheet);
                        }
                        catch
                        {
                            //throw new Exception(string.Format("上传的文件不包含工作表[{0}]", sheet));
                            errMsg += string.Format("上传的文件不包含工作表[{0}]<br/>", sheet);
                        }
                    }
                    conn.Close();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }

            if (!string.IsNullOrEmpty(errMsg))
                throw new Exception(errMsg);

            return ds;
        }
    }
}
