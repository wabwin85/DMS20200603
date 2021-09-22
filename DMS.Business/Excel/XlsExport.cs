using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Data;
using DMS.Business.Excel.Objects;
using System.IO;

namespace DMS.Business.Excel
{
    public class XlsExport
    {
        private ExcelEdit ExcelEdit;
        private int iSheet = 0;
        private int iMainInfo = 0;
        private int iDetailInfo = 0;

        private List<sheet> lSheet;
        private Hashtable iHt;
        private DataSet iDs;
        private DataTable iDt;

        private Xml xml;
        private string strExcelPath = System.Configuration.ConfigurationSettings.AppSettings["ExcelPath"];
        private string strConfigXmlFile;
        private string strDefaultXmlFile;
        private string strPropertyXmlFile;
        private string strModulePath;
        private string strTempPath;
        private string strTempFile;
        private bool isModule;
        private int iEachRow = 2000;    //每次写入的行数,默认2000
        private string strReturnHtmlUrl;    //返回的HTML的URL

        private string strExcel2003Module;
        private string strExcel2007Module;

       // protected static readonly ILog Log = LogManager.GetLogger("log4net");


        /// <summary>
        /// 初始化EXCEL下载类库
        /// </summary>
        /// <param name="strXlsType">下载配置文件的类型</param>
        public XlsExport(string strXlsType)
        {
            //设置路径
            strExcelPath = string.IsNullOrEmpty(strExcelPath) ? "Excel" : strExcelPath;
            strExcelPath = Utility.FormatPath(strExcelPath, "/");
            strConfigXmlFile = System.Web.HttpContext.Current.Server.MapPath("~" + Utility.CombinePath(strExcelPath, "Export/config.xml", "/"));
            strDefaultXmlFile = System.Web.HttpContext.Current.Server.MapPath("~" + Utility.CombinePath(strExcelPath, "Export/default.xml", "/"));
            strPropertyXmlFile = System.Web.HttpContext.Current.Server.MapPath("~" + Utility.CombinePath(strExcelPath, "Export/property.xml", "/"));
            strModulePath = System.Web.HttpContext.Current.Server.MapPath("~" + Utility.CombinePath(strExcelPath, "Export/module", "/"));
            strTempPath = System.Web.HttpContext.Current.Server.MapPath("~" + Utility.CombinePath(strExcelPath, "Export/temp", "/"));

            strExcel2003Module = System.Web.HttpContext.Current.Server.MapPath("~" + Utility.CombinePath(strExcelPath, "Export/Excel2003Module.xls", "/"));
            strExcel2007Module = System.Web.HttpContext.Current.Server.MapPath("~" + Utility.CombinePath(strExcelPath, "Export/Excel2007Module.xlsx", "/"));

            //strTempPath = @"d:\temp";
            //设置模板对象
            xml = new Xml();
            xml.load("Config", strConfigXmlFile);
            xml.load("Default", strDefaultXmlFile);
            xml.load("Module", strModulePath + "\\" + strXlsType + ".xml");
            ExcelEdit = new ExcelEdit(string.IsNullOrEmpty(xml.oExcel.version) ? xml.config.Version : xml.oExcel.version);
            lSheet = new List<sheet>();
            //取得每次写入的行数
            iEachRow = string.IsNullOrEmpty(xml.config.EachRow) ? iEachRow : Convert.ToInt32(xml.config.EachRow);
        }

        public void Export(Hashtable htMain, DataSet dsDetail)
        {
            try
            {
                //20170222 如果DataSet中超过1个Table，就转到数组，不用在页面里面拼了
                if (dsDetail.Tables.Count > 1)
                {
                    DataSet[] dsNew = new DataSet[dsDetail.Tables.Count];
                    for (int i = 0; i < dsDetail.Tables.Count; i++)
                    {
                        DataSet dsSingle = new DataSet();
                        dsSingle.Tables.Add(dsDetail.Tables[i].Copy());
                        dsNew[i] = dsSingle;
                    }
                    Export(htMain, dsNew);
                    return;
                }

                xml.reload(dsDetail);
                this.AddSheet(htMain, dsDetail);

                //TimeSpan ts1 = new TimeSpan(DateTime.Now.Ticks);
                this.Generate();
                //TimeSpan ts2 = new TimeSpan(DateTime.Now.Ticks);
                //TimeSpan ts = ts2.Subtract(ts1).Duration();
                //string spanTime = ts.Minutes.ToString() + "min" + ts.Seconds.ToString() + "sec";
                //
                //Log.Error(spanTime);
                this.DownloadTransfer();
            }
            finally
            {
                try
                {
                    this.DeleteFile();
                }
                catch
                {
                }
            }
        }

        public void Export(Hashtable htMain, DataSet dsDetail, String downloadtype)
        {
            try
            {
                //20170222 如果DataSet中超过1个Table，就转到数组，不用在页面里面拼了
                if (dsDetail.Tables.Count > 1)
                {
                    DataSet[] dsNew = new DataSet[dsDetail.Tables.Count];
                    for (int i = 0; i < dsDetail.Tables.Count; i++)
                    {
                        DataSet dsSingle = new DataSet();
                        dsSingle.Tables.Add(dsDetail.Tables[i].Copy());
                        dsNew[i] = dsSingle;
                    }
                    Export(htMain, dsNew, downloadtype);
                    return;
                }

                xml.reload(dsDetail);
                this.AddSheet(htMain, dsDetail);

                //TimeSpan ts1 = new TimeSpan(DateTime.Now.Ticks);
                this.Generate();
                //TimeSpan ts2 = new TimeSpan(DateTime.Now.Ticks);
                //TimeSpan ts = ts2.Subtract(ts1).Duration();
                //string spanTime = ts.Minutes.ToString() + "min" + ts.Seconds.ToString() + "sec";
                //
                //Log.Error(spanTime);
                this.DownloadTransfer(downloadtype);
            }
            finally
            {
                try
                {
                    this.DeleteFile();
                }
                catch
                {
                }
            }
        }

        public void Export(Hashtable htMain, DataSet[] dsDetails)
        {
            try
            {
                xml.reload(dsDetails);
                foreach (DataSet dsDetail in dsDetails)
                {
                    this.AddSheet(htMain, dsDetail);
                }
                this.Generate();
                this.DownloadTransfer();
            }
            finally
            {
                try
                {
                    this.DeleteFile();
                }
                catch
                {
                }
            }
        }

        public void Export(Hashtable htMain, DataSet[] dsDetails, String downloadtype)
        {
            try
            {
                xml.reload(dsDetails);
                foreach (DataSet dsDetail in dsDetails)
                {
                    this.AddSheet(htMain, dsDetail);
                }
                this.Generate();
                this.DownloadTransfer(downloadtype);
            }
            finally
            {
                try
                {
                    this.DeleteFile();
                }
                catch
                {
                }
            }
        }


        public string ExportWithoutDelete(Hashtable htMain, DataSet dsDetail)
        {
            try
            {
                //20170222 如果DataSet中超过1个Table，就转到数组，不用在页面里面拼了
                if (dsDetail.Tables.Count > 1)
                {
                    DataSet[] dsNew = new DataSet[dsDetail.Tables.Count];
                    for (int i = 0; i < dsDetail.Tables.Count; i++)
                    {
                        DataSet dsSingle = new DataSet();
                        dsSingle.Tables.Add(dsDetail.Tables[i].Copy());
                        dsNew[i] = dsSingle;
                    }
                    return ExportWithoutDelete(htMain, dsNew);
                }

                xml.reload(dsDetail);
                this.AddSheet(htMain, dsDetail);

                //TimeSpan ts1 = new TimeSpan(DateTime.Now.Ticks);
                this.Generate();
                //TimeSpan ts2 = new TimeSpan(DateTime.Now.Ticks);
                //TimeSpan ts = ts2.Subtract(ts1).Duration();
                //string spanTime = ts.Minutes.ToString() + "min" + ts.Seconds.ToString() + "sec";
                //
                //Log.Error(spanTime);
                //this.DownloadTransfer();
                return this.strTempFile;
            }
            finally
            {

            }
        }

        public string ExportWithoutDelete(Hashtable htMain, DataSet[] dsDetails)
        {
            try
            {
                xml.reload(dsDetails);
                foreach (DataSet dsDetail in dsDetails)
                {
                    this.AddSheet(htMain, dsDetail);
                }
                this.Generate();
                //this.DownloadTransfer();
                return this.strTempFile;
            }
            finally
            {

            }
        }


        public void DeleteFile()
        {
            FileInfo fi = new FileInfo(strTempFile);
            if (fi != null)
            {
                fi.Delete();
            }
        }

        public void CopyFile(string strSrcFile, string strDescFile)
        {
            FileInfo fi = new FileInfo(strSrcFile);
            if (fi != null)
            {
                fi.CopyTo(strDescFile);
            }

            if ((File.GetAttributes(strDescFile) & FileAttributes.ReadOnly) == FileAttributes.ReadOnly)
            {
                File.SetAttributes(strDescFile, FileAttributes.Normal);
            }

        }

        /// <summary>
        /// 根据主信息和明细信息添加新的Sheet页

        /// </summary>
        /// <param name="htMain">主信息</param>
        /// <param name="dsDetail">明细信息</param>
        private void AddSheet(Hashtable htMain, DataSet dsDetail)
        {
            sheet s = new sheet();
            s.htMain = htMain;
            s.dsDetail = dsDetail;
            lSheet.Add(s);
        }
        /// <summary>
        /// 生成Excel文件
        /// </summary>
        private void Generate()
        {
            try
            {

                //生成文件
                if (!string.IsNullOrEmpty(xml.oExcel.moduleName))
                {
                    string strSrcFile = strModulePath + "\\" + xml.oExcel.moduleName;
                    strTempFile = strTempPath + "\\" + (Guid.NewGuid().ToString()) + "." + xml.oExcel.moduleName.Substring(xml.oExcel.moduleName.LastIndexOf(".") + 1);
                    CopyFile(strSrcFile, strTempFile);

                    ExcelEdit.Open(strTempFile);
                    isModule = true;
                }
                else
                {
                    if (ExcelEdit.strVersion.ToLower().Equals("excel2003"))
                    {
                        strTempFile = strTempPath + "\\" + (Guid.NewGuid().ToString()) + ".xls";
                        CopyFile(strExcel2003Module, strTempFile);
                    }
                    else
                    {
                        strTempFile = strTempPath + "\\" + (Guid.NewGuid().ToString()) + ".xlsx";
                        CopyFile(strExcel2007Module, strTempFile);
                    }
                    ExcelEdit.Open(strTempFile);
                    //ExcelEdit.Create();
                    isModule = false;
                }

                //for (int i = lSheet.Count -1; i >=0; i--)
                //{
                //    iSheet = i;
                //    sheet sheet = lSheet[i];
                //    ExcelEdit.AddSheet();
                //    GenerateSheet(sheet.htMain, sheet.dsDetail);
                //    if (!isModule)
                //    {
                //        ExcelEdit.ReNameSheet(ExcelEdit.GetSheet(iSheet + 1), xml.oExcel.oSheets[iSheet].Name);
                //    }

                //}
                foreach (sheet sheet in lSheet)
                {
                    if (!isModule) ExcelEdit.AddLastSheet();
                    GenerateSheet(sheet.htMain, sheet.dsDetail);

                    if (!isModule)
                    {
                        ExcelEdit.ReNameSheet(ExcelEdit.GetSheet(iSheet + 1), xml.oExcel.oSheets[iSheet].Name);
                    }
                    iSheet += 1;
                }
                if (!isModule)
                {
                    ExcelEdit.DelSheet("Sheet1");
                }
                //是否在关闭前刷新EXCEL
                if (!string.IsNullOrEmpty(xml.oExcel.refreshBeforeClose) && xml.oExcel.refreshBeforeClose.ToLower().Equals("true"))
                    ExcelEdit.RefreshAll();

                iSheet = 0;
                foreach (sheet sheet in lSheet)
                {
                    if (!string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].deleteBeforeClose) && xml.oExcel.oSheets[iSheet].deleteBeforeClose.ToLower().Equals("true"))
                        ExcelEdit.DelSheet(xml.oExcel.oSheets[iSheet].Name);

                    iSheet += 1;
                }

                if (!string.IsNullOrEmpty(xml.oExcel.version) && xml.oExcel.version.ToLower().Equals("html"))   //html
                {
                    string strFileName = strTempPath + "\\" + (Guid.NewGuid().ToString());
                    string[] strHtml = xml.oExcel.htmlSheet.Split(',');

                    for (int i = 0; i < strHtml.Length; i++)
                    {
                        ExcelEdit.ColumnsAutoFit(ExcelEdit.GetSheet(strHtml[i]));
                    }

                    strReturnHtmlUrl = ExcelEdit.SaveAsHtml(strFileName, strHtml);
                    strTempFile = string.IsNullOrEmpty(strTempFile) ? strFileName + "." + xml.oExcel.moduleName.Substring(xml.oExcel.moduleName.LastIndexOf(".") + 1) : strTempFile;

                }
                else //excel
                {
                    //ExcelEdit.SetActiveCell(ExcelEdit.GetSheet(1), 1, 1, 1, 1);
                    ExcelEdit.Save();
                    /*
                    if (!isModule)
                        strTempFile = ExcelEdit.SaveAs(strTempPath + "\\" + (Guid.NewGuid().ToString()));
                    else
                        ExcelEdit.Save();
                     * */
                }
            }
            catch (Exception e)
            {
                //Log.Error(e);
                throw e;

            }
            finally { ExcelEdit.Close(); }
        }

        //返回HTML的URL
        public string getHtmlUrl()
        {
            return "/" + strReturnHtmlUrl.Remove(0, System.Web.HttpContext.Current.Server.MapPath("/").Length).Replace("\\", "/");
        }
        /// <summary>
        ///  
        /// </summary>
        /// <param name="ht"></param>
        /// <param name="dt"></param>
        /// <returns></returns>
        private void GenerateSheet(Hashtable ht, DataSet ds)
        {
            iHt = ht;
            iDs = ds;

            //生成主信息部分

            if (xml.oExcel.oSheets[iSheet].oMains.Count > 0)
            {
                GenerateMainInfo();
            }
            //格式化主信息部分
            if (!isModule && xml.oExcel.oSheets[iSheet].oMains.Count > 0)
            {
                GenerateMainProperty();
            }

            iDetailInfo = 0;
            //生成明细信息部分
            for (int i = 0; i < ds.Tables.Count; i++)
            {
                iDt = ds.Tables[i];
                prepareDetailInfo();
                //生成明细表头
                if (!isModule && xml.oExcel.oSheets[iSheet].oDetails.Count > 0)
                {
                    GenerateDetailHead();
                }
                //生成明细内容
                if (xml.oExcel.oSheets[iSheet].oDetails.Count > 0)
                {
                    if (!isModule || (isModule && !string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].setDetailProperty) && xml.oExcel.oSheets[iSheet].setDetailProperty.ToLower().Equals("true")))
                        setDetailProperty();
                    setDetailInfo("Formal"); //正式数据
                    //if (!isModule) setDetailProperty();
                }
                //20170222 如果没有数据，就不要合并列了，否则会报错
                if (iDt.Rows.Count > 0)
                {
                    setDetailMerge(0, iDt.Rows.Count, 0);
                }
                iDetailInfo += 1;
            }


        }


        #region 生成主信息
        //生成主信息的内容
        private void GenerateMainInfo()
        {
            for (int i = 0; i < xml.oExcel.oSheets[iSheet].oMains[iMainInfo].oItems.Count; i++)
            {
                setMainInfo(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].oItems[i]);
            }
        }
        //格式化主信息
        private void GenerateMainProperty()
        {
            for (int i = 0; i < xml.oExcel.oSheets[iSheet].oMains[iMainInfo].oItems.Count; i++)
            {
                setMainProperty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].oItems[i]);
            }
        }
        //生成单条主信息内容
        private void setMainInfo(oItem oItem)
        {
            //如果是模板就不需要设置主信息的标题，模板中应该有，所以只需要设置主信息的值
            if (!isModule)
            {
                Hashtable htKeyPositon = Utility.GetExcelPosition(oItem.keyPos);
                int iKeyStartX = Convert.ToInt32(htKeyPositon["startX"]);
                int iKeyStartY = Convert.ToInt32(htKeyPositon["startY"]);
                ExcelEdit.SetCellValue(ExcelEdit.GetSheet(iSheet + 1), iKeyStartX, iKeyStartY, oItem.key);
            }

            Hashtable htValuePositon = Utility.GetExcelPosition(oItem.valuePos);
            int iValueStartX = Convert.ToInt32(htValuePositon["startX"]);
            int iValueStartY = Convert.ToInt32(htValuePositon["startY"]);
            ExcelEdit.SetCellValue(ExcelEdit.GetSheet(iSheet + 1), iValueStartX, iValueStartY, iHt[oItem.value].ToString());
        }
        //格式化单条主信息
        private void setMainProperty(oItem oItem)
        {
            Hashtable htKeyPositon = Utility.GetExcelPosition(oItem.keyPos);
            int iKeyStartX = Convert.ToInt32(htKeyPositon["startX"]);
            int iKeyStartY = Convert.ToInt32(htKeyPositon["startY"]);
            Hashtable htValuePositon = Utility.GetExcelPosition(oItem.valuePos);
            int iValueStartX = Convert.ToInt32(htValuePositon["startX"]);
            int iValueStartY = Convert.ToInt32(htValuePositon["startY"]);

            cellProperty cellPropertyKey = new cellProperty(strPropertyXmlFile);

            cellPropertyKey.BackgroudColor = string.IsNullOrEmpty(oItem.keyBackGroudColor) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyBackGroudColor) ?
                xml.dDefault.dMain.keyBackGroudColor : xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyBackGroudColor
                : oItem.keyBackGroudColor;

            cellPropertyKey.Font = string.IsNullOrEmpty(oItem.keyFont) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyFont) ?
                xml.dDefault.dMain.keyFont : xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyFont
                : oItem.keyFont;

            cellPropertyKey.FontBond = string.IsNullOrEmpty(oItem.keyBond) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyBond) ?
                xml.dDefault.dMain.keyBond : xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyBond
                : oItem.keyBond;

            cellPropertyKey.FontColor = string.IsNullOrEmpty(oItem.keyFontColor) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyFontColor) ?
                xml.dDefault.dMain.keyFontColor : xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyFontColor
                : oItem.keyFontColor;

            cellPropertyKey.FontSize = string.IsNullOrEmpty(oItem.keyFontSize) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyFontSize) ?
                xml.dDefault.dMain.keyFontSize : xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyFontSize
                : oItem.keyFontSize;

            cellPropertyKey.HorizontalAlignment = string.IsNullOrEmpty(oItem.keyHorizontalAlignment) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyHorizontalAlignment) ?
                xml.dDefault.dMain.keyHorizontalAlignment : xml.oExcel.oSheets[iSheet].oMains[iMainInfo].keyHorizontalAlignment
                : oItem.keyHorizontalAlignment;

            ExcelEdit.SetCellProperty(ExcelEdit.GetSheet(iSheet + 1), iKeyStartX, iKeyStartY, iKeyStartX, iKeyStartY, cellPropertyKey);


            cellProperty cellPropertyValue = new cellProperty(strPropertyXmlFile);

            cellPropertyValue.Font = string.IsNullOrEmpty(oItem.valueFont) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].valueFont) ?
                xml.dDefault.dMain.valueFont : xml.oExcel.oSheets[iSheet].oMains[iMainInfo].valueFont
                : oItem.valueFont;

            cellPropertyValue.FontBond = string.IsNullOrEmpty(oItem.valueBond) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].valueBond) ?
                xml.dDefault.dMain.valueBond : xml.oExcel.oSheets[iSheet].oMains[iMainInfo].valueBond
                : oItem.valueBond;

            cellPropertyValue.FontColor = string.IsNullOrEmpty(oItem.valueFontColor) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].valueFontColor) ?
                xml.dDefault.dMain.valueFontColor : xml.oExcel.oSheets[iSheet].oMains[iMainInfo].valueFontColor
                : oItem.valueFontColor;

            cellPropertyValue.FontSize = string.IsNullOrEmpty(oItem.valueFontSize) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].valueFontSize) ?
                xml.dDefault.dMain.valueFontSize : xml.oExcel.oSheets[iSheet].oMains[iMainInfo].valueFontSize
                : oItem.valueFontSize;

            cellPropertyValue.HorizontalAlignment = string.IsNullOrEmpty(oItem.valueHorizontalAlignment) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oMains[iMainInfo].valueHorizontalAlignment) ?
                xml.dDefault.dMain.valueHorizontalAlignment : xml.oExcel.oSheets[iSheet].oMains[iMainInfo].valueHorizontalAlignment
                : oItem.valueHorizontalAlignment;

            cellPropertyValue.FontFormat = string.IsNullOrEmpty(oItem.valueFontFormat) ?
                null : oItem.valueFontFormat;


            ExcelEdit.SetCellProperty(ExcelEdit.GetSheet(iSheet + 1), iValueStartX, iValueStartY, iValueStartX, iValueStartY, cellPropertyValue);

        }
        #endregion

        #region 生成明细信息
        #region 生成明细表头
        //生成明细表头
        private void GenerateDetailHead()
        {
            for (int i = 0; i < xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords.Count; i++)
            {
                setDetailHeadInfo(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[i]);
                setDetailHeadProperty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[i]);
            }
            setDetailHeadMerge();
        }
        //生成单条明细表头内容
        private void setDetailHeadInfo(oRecord oRecord)
        {
            Hashtable htKeyPositon = Utility.GetExcelPosition(oRecord.keyPos);
            int iKeyStartX = Convert.ToInt32(htKeyPositon["startX"]);
            int iKeyStartY = Convert.ToInt32(htKeyPositon["startY"]);
            Hashtable htValuePositon = Utility.GetExcelPosition(oRecord.valuePos);
            int iValueStartX = Convert.ToInt32(htValuePositon["startX"]);
            int iValueStartY = Convert.ToInt32(htValuePositon["startY"]);
            string strGroupName = oRecord.groupName;
            ExcelEdit.SetCellValue(ExcelEdit.GetSheet(iSheet + 1), iValueStartX - 1, iKeyStartY, oRecord.key);
            if (string.IsNullOrEmpty(strGroupName) && iValueStartX - iKeyStartX > 1) //有合并项
            {
                ExcelEdit.UniteCells(ExcelEdit.GetSheet(iSheet + 1), iKeyStartX, iKeyStartY, iValueStartX - 1, iValueStartY);
            }
        }

        //格式化单条明细表头
        private void setDetailHeadProperty(oRecord oRecord)
        {
            Hashtable htKeyPositon = Utility.GetExcelPosition(oRecord.keyPos);
            int iKeyStartX = Convert.ToInt32(htKeyPositon["startX"]);
            int iKeyStartY = Convert.ToInt32(htKeyPositon["startY"]);
            Hashtable htValuePositon = Utility.GetExcelPosition(oRecord.valuePos);
            int iValueStartX = Convert.ToInt32(htValuePositon["startX"]);
            int iValueStartY = Convert.ToInt32(htValuePositon["startY"]);

            cellProperty cellPropertyKey = new cellProperty(strPropertyXmlFile);

            cellPropertyKey.BackgroudColor = string.IsNullOrEmpty(oRecord.keyBackGroudColor) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyBackGroudColor) ?
                xml.dDefault.dDetail.keyBackGroudColor : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyBackGroudColor
                : oRecord.keyBackGroudColor;

            cellPropertyKey.FontBond = string.IsNullOrEmpty(oRecord.keyBond) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyBond) ?
                xml.dDefault.dDetail.keyBond : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyBond
                : oRecord.keyBond;

            cellPropertyKey.Font = string.IsNullOrEmpty(oRecord.keyFont) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyFont) ?
                xml.dDefault.dDetail.keyFont : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyFont
                : oRecord.keyFont;

            cellPropertyKey.FontColor = string.IsNullOrEmpty(oRecord.keyFontColor) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyFontColor) ?
                xml.dDefault.dDetail.keyFontColor : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyFontColor
                : oRecord.keyFontColor;

            cellPropertyKey.FontSize = string.IsNullOrEmpty(oRecord.keyFontSize) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyFontSize) ?
                xml.dDefault.dDetail.keyFontSize : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyFontSize
                : oRecord.keyFontSize;

            cellPropertyKey.HorizontalAlignment = string.IsNullOrEmpty(oRecord.keyHorizontalAlignment) ?
                string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyHorizontalAlignment) ?
                xml.dDefault.dDetail.keyHorizontalAlignment : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].keyHorizontalAlignment
                : oRecord.keyHorizontalAlignment;

            ExcelEdit.SetCellProperty(ExcelEdit.GetSheet(iSheet + 1), iKeyStartX, iKeyStartY, iValueStartX - 1, iKeyStartY, cellPropertyKey);
            ExcelEdit.SetCellLineStyle(ExcelEdit.GetSheet(iSheet + 1), iKeyStartX, iKeyStartY, iValueStartX - 1, iKeyStartY);

        }
        //合并明细表头
        private void setDetailHeadMerge()
        {
            string strGroupName = "";
            int iStart = 0;
            int iEnd = 0;
            for (int i = 0; i < xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords.Count; i++)
            {
                if (!string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[i].groupName))
                {
                    if (xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[i].groupName.Equals(strGroupName))
                    {
                        iEnd = i;
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(strGroupName))
                        {

                            Hashtable htKeyPositonStart = Utility.GetExcelPosition(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[iStart].keyPos);
                            int iKeyStartXStart = Convert.ToInt32(htKeyPositonStart["startX"]);
                            int iKeyStartYStart = Convert.ToInt32(htKeyPositonStart["startY"]);

                            ExcelEdit.SetCellValue(ExcelEdit.GetSheet(iSheet + 1), iKeyStartXStart, iKeyStartYStart, strGroupName);

                            Hashtable htKeyPositonEnd = Utility.GetExcelPosition(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[i - 1].keyPos);
                            int iKeyStartXEnd = Convert.ToInt32(htKeyPositonEnd["startX"]);
                            int iKeyStartYEnd = Convert.ToInt32(htKeyPositonEnd["startY"]);

                            ExcelEdit.UniteCells(ExcelEdit.GetSheet(iSheet + 1), iKeyStartXStart, iKeyStartYStart, iKeyStartXEnd, iKeyStartYEnd);
                        }
                        iStart = i;
                        iEnd = i;
                        strGroupName = xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[i].groupName;
                    }
                }
                else
                {
                    iStart = 0;
                    iEnd = 0;
                    strGroupName = "";
                }
            }
            if (!string.IsNullOrEmpty(strGroupName))
            {

                Hashtable htKeyPositonStart = Utility.GetExcelPosition(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[iStart].keyPos);
                int iKeyStartXStart = Convert.ToInt32(htKeyPositonStart["startX"]);
                int iKeyStartYStart = Convert.ToInt32(htKeyPositonStart["startY"]);

                ExcelEdit.SetCellValue(ExcelEdit.GetSheet(iSheet + 1), iKeyStartXStart, iKeyStartYStart, strGroupName);

                Hashtable htKeyPositonEnd = Utility.GetExcelPosition(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords.Count - 1].keyPos);
                int iKeyStartXEnd = Convert.ToInt32(htKeyPositonEnd["startX"]);
                int iKeyStartYEnd = Convert.ToInt32(htKeyPositonEnd["startY"]);

                ExcelEdit.UniteCells(ExcelEdit.GetSheet(iSheet + 1), iKeyStartXStart, iKeyStartYStart, iKeyStartXEnd, iKeyStartYEnd);
            }
        }

        #endregion
        #region 生成明细内容
        //取得明细内容起始行
        private int getDeTailStartRow()
        {
            Hashtable htValuePositon = Utility.GetExcelPosition(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[0].valuePos);
            return Convert.ToInt32(htValuePositon["startX"]);
        }
        //将明细字段顺序放入HASHTABLE
        private Hashtable getDetailComlumn()
        {
            Hashtable ht = new Hashtable();
            foreach (oRecord oRecord in xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords)
            {
                ht.Add(Convert.ToInt32(Utility.GetExcelPosition(oRecord.valuePos)["startY"]), oRecord.value);
            }
            return ht;
        }

        private void prepareDetailInfo()
        {
            int iCount = 0;
            for (int i = 0; i < iDt.Rows.Count; i++)
            {
                iCount = 0;
                for (int j = 0; j < iDt.Columns.Count; j++)
                {
                    if (iDt.Rows[i][j].ToString().Equals("!y!"))
                    {
                        if (iCount == 0)
                        {
                            iDt.Rows[i][j] = "合计：";
                            iCount = 1;
                        }
                        else
                        {
                            iDt.Rows[i][j] = "";
                        }
                    }

                    if (iCount == 1)
                    {
                        //去除不显示合计列
                        if (!string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[j].showSum) && !xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[j].showSum.ToLower().Equals("y"))
                        {
                            iDt.Rows[i][j] = DBNull.Value;
                        }
                    }
                }
            }

        }
        /*
        //写明细数据,strDataType=Formal,Testing
        private void setDetailInfo(string strDataType)
        {
            int iStartRow = getDeTailStartRow();
            int maxRow = 65536 - iStartRow + 1;
            Hashtable ht = getDetailComlumn();
            int iTotalRow = 0;
            if (strDataType.Equals("Formal"))
            {
                iTotalRow = ExcelEdit.strVersion.ToLower().Equals("excel2003") ?
                     iDt.Rows.Count > maxRow ? maxRow : iDt.Rows.Count : iDt.Rows.Count;
            }
            else
            {
                iTotalRow = 
                    iDt.Rows.Count > 10 ? 10 : iDt.Rows.Count;
            }

            object[,] dataArray = new object[iTotalRow, ht.Count];
            int iMinY = 0;
            int iMaxY = 0;
            foreach (int j in ht.Keys)
            {
                iMinY = iMinY == 0 ? j : iMinY;
                iMaxY = iMaxY == 0 ? j : iMaxY;
                if (iMinY > j) iMinY = j;
                if (iMaxY < j) iMaxY = j;
            }

            for (int i = 0; i < iTotalRow; i++)
            {
                foreach (int j in ht.Keys)
                {
                    dataArray[i, j - 1] = iDt.Rows[i][ht[j].ToString()];
                }
            }
            //如果是创建EXCEL则根据配置文件的顺寻，如果是用模板则根据模板中SHEET的名字
            if (!isModule)
                ExcelEdit.SetCellValue(ExcelEdit.GetSheet(iSheet + 1), iStartRow, iMinY, iStartRow + iTotalRow - 1, iMaxY, dataArray);
            else
                ExcelEdit.SetCellValue(ExcelEdit.GetSheet(xml.oExcel.oSheets[iSheet].Name), iStartRow, iMinY, iStartRow + iTotalRow - 1, iMaxY, dataArray);

            if(strDataType.Equals("Testing"))
            {
                //EXCEL列宽自适应
                if (!isModule)
                    ExcelEdit.ColumnsAutoFit(ExcelEdit.GetSheet(iSheet + 1), iStartRow, iMinY, iStartRow + iTotalRow - 1, iMaxY);
                else
                    ExcelEdit.ColumnsAutoFit(ExcelEdit.GetSheet(xml.oExcel.oSheets[iSheet].Name), iStartRow, iMinY, iStartRow + iTotalRow - 1, iMaxY);

                //清除10行测试数据 
                if (!isModule)
                    ExcelEdit.ClearContents(ExcelEdit.GetSheet(iSheet + 1), iStartRow, iMinY, iStartRow + iTotalRow - 1, iMaxY);
                else
                    ExcelEdit.ClearContents(ExcelEdit.GetSheet(xml.oExcel.oSheets[iSheet].Name), iStartRow, iMinY, iStartRow + iTotalRow - 1, iMaxY);

            }
        }
         * */
        //写明细数据,strDataType=Formal,Testing
        private void setDetailInfo(string strDataType)
        {
            int iStartRow = getDeTailStartRow();
            int maxRow = 65536 - iStartRow + 1;
            Hashtable ht = getDetailComlumn();
            int iTotalRow = 0;
            if (strDataType.Equals("Formal"))
            {
                iTotalRow = ExcelEdit.strVersion.ToLower().Equals("excel2003") ?
                     iDt.Rows.Count > maxRow ? maxRow : iDt.Rows.Count : iDt.Rows.Count;
            }
            else
            {
                iTotalRow =
                    iDt.Rows.Count > 10 ? 10 : iDt.Rows.Count;
            }

            //如果没有记录，就直接返回
            if (iTotalRow == 0) return;

            int iMinY = 0;
            int iMaxY = 0;
            foreach (int j in ht.Keys)
            {
                iMinY = iMinY == 0 ? j : iMinY;
                iMaxY = iMaxY == 0 ? j : iMaxY;
                if (iMinY > j) iMinY = j;
                if (iMaxY < j) iMaxY = j;
            }

            int iEachTimeRow = iEachRow;    //每次行数
            int iCurrentStartRow = 0;       //本次开始行数
            int iCurrentEndRow = 0;         //本次结束行数


            object[,] dataArray = new object[iEachTimeRow, ht.Count];

            iCurrentEndRow = iTotalRow > iEachTimeRow ? iEachTimeRow : iTotalRow;


            while (iCurrentStartRow < iTotalRow)
            {
                dataArray.Initialize();
                for (int i = iCurrentStartRow; i < iCurrentEndRow; i++)
                {
                    foreach (int j in ht.Keys)
                    {
                        dataArray[i - iCurrentStartRow, j - 1] = iDt.Rows[i][ht[j].ToString()];
                    }
                }
                //如果是创建EXCEL则根据配置文件的顺寻，如果是用模板则根据模板中SHEET的名字
                if (!isModule)
                    ExcelEdit.SetCellValue(ExcelEdit.GetSheet(iSheet + 1), iStartRow + iCurrentStartRow, iMinY, iStartRow + iCurrentEndRow - 1, iMaxY, dataArray);
                else
                    ExcelEdit.SetCellValue(ExcelEdit.GetSheet(xml.oExcel.oSheets[iSheet].Name), iStartRow + iCurrentStartRow, iMinY, iStartRow + iCurrentEndRow - 1, iMaxY, dataArray);

                iCurrentStartRow += iEachTimeRow;
                iCurrentEndRow = (iCurrentEndRow + iEachTimeRow) > iTotalRow ? iTotalRow : (iCurrentEndRow + iEachTimeRow);
            }

            if (strDataType.Equals("Testing"))
            {
                //EXCEL列宽自适应
                if (!isModule)
                    ExcelEdit.ColumnsAutoFit(ExcelEdit.GetSheet(iSheet + 1), iStartRow, iMinY, iStartRow + iTotalRow - 1, iMaxY);
                else
                    ExcelEdit.ColumnsAutoFit(ExcelEdit.GetSheet(xml.oExcel.oSheets[iSheet].Name), iStartRow, iMinY, iStartRow + iTotalRow - 1, iMaxY);

                //清除10行测试数据 
                if (!isModule)
                    ExcelEdit.ClearContents(ExcelEdit.GetSheet(iSheet + 1), iStartRow, iMinY, iStartRow + iTotalRow - 1, iMaxY);
                else
                    ExcelEdit.ClearContents(ExcelEdit.GetSheet(xml.oExcel.oSheets[iSheet].Name), iStartRow, iMinY, iStartRow + iTotalRow - 1, iMaxY);

            }
        }

        //格式化明细
        /*
        private void setDetailProperty()
        {
            int iStartRow = getDeTailStartRow();
            int maxRow = 65536 - iStartRow + 1;
            int iRows = ExcelEdit.strVersion.ToLower().Equals("excel2003") ?
                                     iDt.Rows.Count > maxRow ? maxRow : iDt.Rows.Count : iDt.Rows.Count;
            foreach (oRecord oRecord in xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords)
            {
                Hashtable htValuePositon = Utility.GetExcelPosition(oRecord.valuePos);
                int iValueStartX = Convert.ToInt32(htValuePositon["startX"]);
                int iValueStartY = Convert.ToInt32(htValuePositon["startY"]);
                int iValueEndX = iValueStartX + iRows - 1;
                int iValueEndY = iValueStartY;

                cellProperty cellPropertyValue = new cellProperty(strPropertyXmlFile);

                cellPropertyValue.FontBond = string.IsNullOrEmpty(oRecord.valueBond) ?
                    string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueBond) ?
                    xml.dDefault.dDetail.valueBond : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueBond
                    : oRecord.valueBond;

                cellPropertyValue.Font = string.IsNullOrEmpty(oRecord.valueFont) ?
                    string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFont) ?
                    xml.dDefault.dDetail.valueFont : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFont
                    : oRecord.valueFont;

                cellPropertyValue.FontColor = string.IsNullOrEmpty(oRecord.valueFontColor) ?
                    string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFontColor) ?
                    xml.dDefault.dDetail.valueFontColor : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFontColor
                    : oRecord.valueFontColor;

                cellPropertyValue.FontSize = string.IsNullOrEmpty(oRecord.valueFontSize) ?
                    string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFontSize) ?
                    xml.dDefault.dDetail.valueFontSize : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFontSize
                    : oRecord.valueFontSize;

                cellPropertyValue.HorizontalAlignment = string.IsNullOrEmpty(oRecord.valueHorizontalAlignment) ? null
                    : oRecord.valueHorizontalAlignment;

                cellPropertyValue.FontFormat = string.IsNullOrEmpty(oRecord.valueFontFormat) ?
                    iDt.Columns[oRecord.value].DataType.ToString()
                    : oRecord.valueFontFormat;

                ExcelEdit.SetCellProperty(ExcelEdit.GetSheet(iSheet + 1), iValueStartX, iValueStartY, iValueEndX, iValueEndY, cellPropertyValue);
                ExcelEdit.SetCellLineStyle(ExcelEdit.GetSheet(iSheet + 1), iValueStartX, iValueStartY, iValueEndX, iValueEndY);
            }
        }
         * */


        ////格式化明细
        //先格式化第1行，然后用格式刷刷新其余数据
        private void setDetailProperty()
        {
            int iStartRow = getDeTailStartRow();
            int maxRow = 65536 - iStartRow + 1;
            int iRows = ExcelEdit.strVersion.ToLower().Equals("excel2003") ?
                                     iDt.Rows.Count > maxRow ? maxRow : iDt.Rows.Count : iDt.Rows.Count;

            int iValueStartX = 0;
            int iValueStartY = 0;
            int iValueEndX = 0;
            int iValueEndY = 0;

            foreach (oRecord oRecord in xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords)
            {
                Hashtable htValuePositon = Utility.GetExcelPosition(oRecord.valuePos);
                iValueStartX = Convert.ToInt32(htValuePositon["startX"]);
                iValueStartY = Convert.ToInt32(htValuePositon["startY"]);
                iValueEndX = iValueStartX;
                iValueEndY = iValueStartY;

                cellProperty cellPropertyValue = new cellProperty(strPropertyXmlFile);

                cellPropertyValue.FontBond = string.IsNullOrEmpty(oRecord.valueBond) ?
                    string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueBond) ?
                    xml.dDefault.dDetail.valueBond : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueBond
                    : oRecord.valueBond;

                cellPropertyValue.Font = string.IsNullOrEmpty(oRecord.valueFont) ?
                    string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFont) ?
                    xml.dDefault.dDetail.valueFont : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFont
                    : oRecord.valueFont;

                cellPropertyValue.FontColor = string.IsNullOrEmpty(oRecord.valueFontColor) ?
                    string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFontColor) ?
                    xml.dDefault.dDetail.valueFontColor : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFontColor
                    : oRecord.valueFontColor;

                cellPropertyValue.FontSize = string.IsNullOrEmpty(oRecord.valueFontSize) ?
                    string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFontSize) ?
                    xml.dDefault.dDetail.valueFontSize : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].valueFontSize
                    : oRecord.valueFontSize;

                cellPropertyValue.HorizontalAlignment = string.IsNullOrEmpty(oRecord.valueHorizontalAlignment) ? null
                    : oRecord.valueHorizontalAlignment;

                cellPropertyValue.FontFormat = string.IsNullOrEmpty(oRecord.valueFontFormat) ?
                    iDt.Columns[oRecord.value].DataType.ToString()
                    : oRecord.valueFontFormat;
                if (!isModule)
                {
                    ExcelEdit.SetCellProperty(ExcelEdit.GetSheet(iSheet + 1), iValueStartX, iValueStartY, iValueEndX, iValueEndY, cellPropertyValue);
                    ExcelEdit.SetCellLineStyle(ExcelEdit.GetSheet(iSheet + 1), iValueStartX, iValueStartY, iValueEndX, iValueEndY);
                }
            }
            //用第1行去格式刷其余行
            /*
            ExcelEdit.CopyFormat(ExcelEdit.GetSheet(iSheet + 1), iValueStartX, 1, iValueStartX, 50,
                    iValueStartX + 1, 1, iValueStartX + iRows - 1, 50);
            */
            int iEachTimeRow = iEachRow;    //每次行数
            int iCurrentStartRow = iValueStartX + 1;       //本次开始行数
            int iCurrentEndRow = 0;         //本次结束行数
            int iTotalEndRow = iValueStartX + iRows - 1;
            iCurrentEndRow = iRows > iEachTimeRow ? iEachTimeRow + iValueStartX - 1 : iRows + iValueStartX - 1;
            iCurrentEndRow = iCurrentEndRow < iCurrentStartRow ? iCurrentStartRow : iCurrentEndRow;

            while (iCurrentStartRow <= iTotalEndRow)
            {
                ExcelEdit.CopyFormat(ExcelEdit.GetSheet(iSheet + 1), iValueStartX, 1, iValueStartX, 100,
                    iCurrentStartRow, 1, iCurrentEndRow, 100);

                iCurrentStartRow += iEachTimeRow - 1;
                iCurrentEndRow = (iCurrentEndRow + iEachTimeRow) > iTotalEndRow ? iTotalEndRow : (iCurrentEndRow + iEachTimeRow);
            }
            //用数据前10行去测试各列的宽度
            setDetailInfo("Testing");


        }

        private void setDetailMerge(int startX, int endX, int Y)
        {
            Hashtable htValuePositon = Utility.GetExcelPosition(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[Y].valuePos);
            int iValueStartX = Convert.ToInt32(htValuePositon["startX"]);
            int iValueStartY = Convert.ToInt32(htValuePositon["startY"]);
            string strIsRollup = xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[Y].isRollup;
            if (string.IsNullOrEmpty(strIsRollup) || !strIsRollup.ToLower().Equals("y"))
                return;

            string strStartValue = iDt.Rows[startX][Y].ToString();
            string strCurValue = iDt.Rows[startX][Y].ToString();
            int iPos = startX;
            int iCount = 0;

            for (int i = startX; i < endX; i++)
            {
                strCurValue = iDt.Rows[i][Y].ToString();
                if (!strStartValue.Equals(strCurValue))
                {
                    if (strCurValue.Equals("!y!"))
                    {
                        if (iCount > 1)
                        {
                            ExcelEdit.UniteCells(ExcelEdit.GetSheet(iSheet + 1), iValueStartX + iPos, Y + 1, iValueStartX + iPos + iCount - 1, Y + 1);
                            setDetailMerge(iPos, i, Y + 1);
                        }

                        //ExcelEdit.SetCellValue(ExcelEdit.GetSheet(iSheet + 1), iValueStartX + i, Y + 1, iValueStartX + i, Y + 1, "合计：");

                        string strSumValue = strCurValue;
                        int iSumValue = Y;
                        while (strSumValue.Equals("!y!"))
                        {
                            iSumValue += 1;
                            strSumValue = iDt.Rows[i][iSumValue].ToString();
                        }
                        //合并单元格
                        //ExcelEdit.UniteCells(ExcelEdit.GetSheet(iSheet + 1), iValueStartX + i, Y + 1, iValueStartX + i, iSumValue);

                        /* 太慢了，不要设置了
                        //设置颜色
                        cellProperty cellPropertyValue = new cellProperty(strPropertyXmlFile);
                        cellPropertyValue.BackgroudColor =
                            string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].sumBackGroudColor) ?
                            xml.dDefault.dDetail.sumBackGroudColor : xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].sumBackGroudColor;
                        ExcelEdit.SetCellProperty(ExcelEdit.GetSheet(iSheet + 1), iValueStartX + i, Y + 1, iValueStartX + i, iDt.Columns.Count, cellPropertyValue);
                        
                        for (int j = Y + 1; j < xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords.Count; j++)
                        {
                            //去除不显示合计列
                            if (!string.IsNullOrEmpty(xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[j].showSum) && !xml.oExcel.oSheets[iSheet].oDetails[iDetailInfo].oRecords[j].showSum.ToLower().Equals("y"))
                            {
                                ExcelEdit.SetCellValue(ExcelEdit.GetSheet(iSheet + 1), iValueStartX + i, j + 1, iValueStartX + i, j + 1, "");
                            }
                        }
                         * * */

                        return;
                    }
                    else
                    {
                        ExcelEdit.UniteCells(ExcelEdit.GetSheet(iSheet + 1), iValueStartX + iPos, Y + 1, iValueStartX + iPos + iCount - 1, Y + 1);
                        strStartValue = strCurValue;
                        setDetailMerge(iPos, i, Y + 1);
                        iPos = i;
                        iCount = 1;
                    }
                }
                else
                {
                    iCount += 1;
                }

            }
        }
        #endregion
        #endregion


        #region 下载文件
        /// <summary>
        /// 下载EXCEL文件，适用与AJAX项目
        /// </summary>
        private void DownloadTransfer()
        {
            if (!string.IsNullOrEmpty(xml.oExcel.version) && xml.oExcel.version.ToLower().Equals("html"))   //html就不需要下载了
                return;

            int intStart = strTempFile.LastIndexOf("\\") + 1;
            string saveFileName = Utility.GetExcelFileName(strTempFile.Substring(intStart, strTempFile.Length - intStart), xml.oExcel.fileName);
            System.Web.HttpContext.Current.Server.Transfer("~" + Utility.FormatPath(strExcelPath, "\\") + "Export\\download.aspx?filename=" + strTempFile.Replace("\\", "\\\\") + "&savefilename=" + saveFileName);
        }
        /// <summary>
        /// 下载EXCEL文件，适用与AJAX项目
        /// </summary>
        private void DownloadTransfer(String downloadtype)
        {
            if (!string.IsNullOrEmpty(xml.oExcel.version) && xml.oExcel.version.ToLower().Equals("html"))   //html就不需要下载了
                return;

            int intStart = strTempFile.LastIndexOf("\\") + 1;
            string saveFileName = Utility.GetExcelFileName(strTempFile.Substring(intStart, strTempFile.Length - intStart), xml.oExcel.fileName);
            System.Web.HttpContext.Current.Server.Transfer("~" + Utility.FormatPath(strExcelPath, "\\") + "Export\\download.aspx?DownloadType=" + downloadtype + "&filename=" + strTempFile.Replace("\\", "\\\\") + "&savefilename=" + saveFileName);
        }
        /// <summary>
        /// 下载EXCEL文件
        /// </summary>
        private void Download()
        {
            //文件创建成功
            if (System.IO.File.Exists(strTempFile))
            {
                int intStart = strTempFile.LastIndexOf("\\") + 1;
                string saveFileName = Utility.GetExcelFileName(strTempFile.Substring(intStart, strTempFile.Length - intStart), xml.oExcel.fileName);
                try
                {
                    System.IO.FileInfo fi = new System.IO.FileInfo(strTempFile);

                    System.Web.HttpContext.Current.Response.Clear();
                    System.Web.HttpContext.Current.Response.Charset = "utf-8";
                    System.Web.HttpContext.Current.Response.Buffer = true;
                    //this.EnableViewState = false;
                    System.Web.HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.UTF8;

                    System.Web.HttpContext.Current.Response.AppendHeader("Content-Disposition", "attachment;filename=" + System.Web.HttpUtility.UrlEncode(saveFileName, System.Text.Encoding.UTF8));
                    System.Web.HttpContext.Current.Response.AppendHeader("Content-Length", fi.Length.ToString());
                    System.Web.HttpContext.Current.Response.ContentType = "application/vnd.ms-excel";

                    System.Web.HttpContext.Current.Response.WriteFile(strTempFile);
                    System.Web.HttpContext.Current.Response.Flush();
                    System.Web.HttpContext.Current.Response.Close();

                    System.Web.HttpContext.Current.Response.End();

                }
                catch (Exception ex)
                {
                }
            }
        }
        #endregion

    }
}
