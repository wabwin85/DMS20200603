using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Data;
using DMS.Business.Excel.Objects;
using System.IO; 
using Lafite.RoleModel.Security;
using Lafite.RoleModel.Security.Authorization;
using DMS.Common;
using System.Web;
using DMS.DataAccess.MasterData;
using Grapecity.DataAccess.Transaction;

namespace DMS.Business.Excel
{
    public class XlsImport
    {
        private IRoleModelContext _context = RoleModelContext.Current;

        private Xml xml;
        private string strExcelPath = System.Configuration.ConfigurationSettings.AppSettings["ExcelPath"];       
        private string strModulePath;

        private string strProcedure;
        private DataTable[] dtSheetSetting;
        private DataTable dtSheets;
       // protected static readonly ILog Log = LogManager.GetLogger("log4net");
        
        /// <summary>
        /// 初始化EXCEL下载类库
        /// </summary>
        /// <param name="strXlsType">下载配置文件的类型</param>
        public XlsImport(string strXlsType)
        {
            //设置路径
            strExcelPath = string.IsNullOrEmpty(strExcelPath) ? "Excel" : strExcelPath;
            strExcelPath = Utility.FormatPath(strExcelPath, "/");            
            strModulePath = System.Web.HttpContext.Current.Server.MapPath("~" + Utility.CombinePath(strExcelPath, "Import/module", "/"));
            
            //设置模板对象
            xml = new Xml();
            xml.loadImport(strModulePath + "\\" + strXlsType + ".xml");
            Reload();
        }

        //
        public string Import(DataTable dt)
        {
            string strReturn = "Error";

            //将dt插入临时表,目前默认只有1个SHEET
            strReturn = XlsImportTempTable(0, dt);
            //校验并导入
            if (strReturn.Equals("Success"))
            {
                strReturn = ImportUpdate();
            }

            return strReturn;
        }

        public string ImportUpdate()
        {
            string strReturn = "Error";
            try{
                //调用系统统一校验合法性（包括字段类型、是否为空、基础合法性校验）
                strReturn = XlsImportTempTable_Check1(0);

                //调用业务存储过程校验（根据每个导入单独编写，应当包含放入正式表的逻辑）
                if (strReturn.Equals("Success"))
                {
                    strReturn = XlsImportTempTable_Check2();
                }
            }
            catch (Exception ex)
            {
                return "Error";
            } 
            return strReturn;
        }

        public DataTable GetErrorList(int start, int limit, out int totalRowCount)
        {
            Hashtable param = new Hashtable();
            param.Add("UserId", new Guid(_context.User.Id));
            param.Add("TableName", dtSheets.Rows[0]["TableName"].ToString());
            XlsImportDao dao = new XlsImportDao();
            return dao.XlsImportTempTable_GetErrorList(param, start, limit, out totalRowCount);
        }
        private string XlsImportTempTable(int index, DataTable dtOriginData)
        {
            try
            {
                XlsImportTempTable_Delete(index);
                DataTable dt = ReloadOriginDataTable(index, dtOriginData);
                XlsImportTempTable_Insert(index, dt); 
            }
            catch (Exception ex)
            {
                return "Error";
            } 
            return "Success";
        }

        private string XlsImportTempTable_Check1(int index)
        {
            string strReturn = "Error";
            try
            {  
                DataTable dtSetting = dtSheetSetting[index];
                string strSetting = ConertToXml(dtSetting);
                string TempTableName = dtSheets.Rows[index]["TableName"].ToString(); 

                Hashtable ht = new Hashtable();
                ht.Add("UserId", new Guid(_context.User.Id));
                ht.Add("TableName", TempTableName);
                ht.Add("SettingTable", strSetting); 
                ht.Add("IsValid", "Error");
                XlsImportDao dao = new XlsImportDao();
                strReturn = dao.XlsImportTempTable_Check1(ht);
            }
            catch (Exception ex)
            {
                return "Error";
            }
            return strReturn;
        }

        private string XlsImportTempTable_Check2()
        {
            string strReturn = "Error";
            try
            {
                Hashtable ht = new Hashtable();
                ht.Add("UserId", new Guid(_context.User.Id));
                ht.Add("ProcedureName", strProcedure); 
                ht.Add("IsValid", "Error");
                XlsImportDao dao = new XlsImportDao();
                strReturn = dao.XlsImportTempTable_Check2(ht);
            }
            catch (Exception ex)
            {
                return "Error";
            }
            return strReturn;
        }

        /// <summary>
        /// 将源数据的DataTable重新定义
        /// </summary>
        /// <param name="index"></param>
        /// <param name="dt"></param>
        /// <returns></returns>
        private DataTable ReloadOriginDataTable(int index, DataTable dt)
        {
            DataTable dtReturn = new DataTable();
            for (int i = 0; i < dtSheetSetting[index].Rows.Count; i++)
            {
                dtReturn.Columns.Add(new DataColumn(dtSheetSetting[index].Rows[i]["ColumnName"].ToString()));
            }
            dtReturn.Columns.Add(new DataColumn("II_ID", typeof(Guid)));
            dtReturn.Columns.Add(new DataColumn("II_User", typeof(Guid)));
            dtReturn.Columns.Add(new DataColumn("II_UploadDate", typeof(DateTime)));
            dtReturn.Columns.Add(new DataColumn("II_LineNbr", typeof(int)));
            dtReturn.Columns.Add(new DataColumn("II_ErrorFlag", typeof(int)));
            dtReturn.Columns.Add(new DataColumn("II_ErrorMsg"));

            for (int i = Int32.Parse(dtSheets.Rows[index]["DataStartRowNumber"].ToString()) - 1; i < dt.Rows.Count; i++)
            {
                DataRow dr = dtReturn.NewRow();
                for (int j = 0; j < dtSheetSetting[index].Rows.Count; j++)
                {
                    dr[dtSheetSetting[index].Rows[j]["ColumnName"].ToString()]
                        = dt.Rows[i][Int32.Parse(dtSheetSetting[index].Rows[j]["Position"].ToString())].ToString();
                }
                dr["II_ID"] = Guid.NewGuid();
                dr["II_User"] = new Guid(_context.User.Id);
                dr["II_UploadDate"] = DateTime.Now;
                dr["II_LineNbr"] = i + 1;
                dr["II_ErrorFlag"] = 0;
                dr["II_ErrorMsg"] = "";
                dtReturn.Rows.Add(dr);
            } 
            return dtReturn;
        }

        /// <summary>
        /// 将XML配置文件变成DataTable
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        private void Reload()
        {
            strProcedure = xml.iExcel.Procedure;
            dtSheetSetting = new DataTable[xml.iExcel.iSheets.Count];
            dtSheets = new DataTable();
            dtSheets.Columns.Add(new DataColumn("TableName"));
            dtSheets.Columns.Add(new DataColumn("DataStartRowNumber"));

            for (int i = 0; i < xml.iExcel.iSheets.Count; i++)
            {
                DataRow drSheet = dtSheets.NewRow();
                drSheet["TableName"] = xml.iExcel.iSheets[i].TableName;
                drSheet["DataStartRowNumber"] = xml.iExcel.iSheets[i].DataStartRowNumber;
                dtSheets.Rows.Add(drSheet);

                DataTable dtSheet = new DataTable();
                dtSheet.Columns.Add(new DataColumn("Position"));
                dtSheet.Columns.Add(new DataColumn("ColumnName"));
                dtSheet.Columns.Add(new DataColumn("DescName"));
                dtSheet.Columns.Add(new DataColumn("DataType"));
                dtSheet.Columns.Add(new DataColumn("IsRequired"));
                dtSheet.Columns.Add(new DataColumn("ErrorMsgColumn"));
                dtSheet.Columns.Add(new DataColumn("CheckType"));
                dtSheet.Columns.Add(new DataColumn("CheckValue"));
                for (int j = 0; j < xml.iExcel.iSheets[i].iRecords.Count; j++)
                {
                    DataRow dr = dtSheet.NewRow();    
                    dr["Position"] = xml.iExcel.iSheets[i].iRecords[j].Position;
                    dr["ColumnName"] = xml.iExcel.iSheets[i].iRecords[j].ColumnName;
                    dr["DescName"] = xml.iExcel.iSheets[i].iRecords[j].DescName;
                    dr["DataType"] = xml.iExcel.iSheets[i].iRecords[j].DataType;
                    dr["IsRequired"] = xml.iExcel.iSheets[i].iRecords[j].IsRequired;
                    dr["ErrorMsgColumn"] = xml.iExcel.iSheets[i].iRecords[j].ErrorMsgColumn;
                    dr["CheckType"] = xml.iExcel.iSheets[i].iRecords[j].CheckType;
                    dr["CheckValue"] = xml.iExcel.iSheets[i].iRecords[j].CheckValue;
                    dtSheet.Rows.Add(dr);
                }
                dtSheetSetting[i] = dtSheet;
            }
        }

        private string ConertToXml(DataTable dt)
        {
            dt.TableName = "Table";
            if (null != dt.DataSet)
            {
                dt.DataSet.DataSetName = "DocumentElement";
            }
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            dt.WriteXml(ms);
            string xmlContent = System.Text.Encoding.UTF8.GetString(ms.ToArray());
            return string.Format("<?xml   version=\"1.0\"   encoding=\"unicode\"   ?> {0}", xmlContent);
        }

        private void XlsImportTempTable_Insert(int index,DataTable dt)
        {
            using (TransactionScope trans = new TransactionScope())
            {
                XlsImportDao dao = new XlsImportDao();
                dao.XlsImportTempTable_Insert(dtSheets.Rows[index]["TableName"].ToString(),dt);
                trans.Complete();
            }
        }

        private void XlsImportTempTable_Delete(int index)
        { 
            Hashtable ht = new Hashtable();
            ht.Add("UserId", new Guid(_context.User.Id));
            ht.Add("TableName", dtSheets.Rows[index]["TableName"].ToString());
            XlsImportDao dao = new XlsImportDao();
            dao.XlsImportTempTable_Delete(ht);
        }

    }
}
