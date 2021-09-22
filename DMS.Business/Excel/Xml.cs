using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Data;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using DMS.Business.Excel.Objects;

namespace DMS.Business.Excel
{
    public class Xml
    {
        public Hashtable xmlList;
        public oExcel oExcel;
        public dDefault dDefault;
        public config config;

        public iExcel iExcel;

        public Xml()
        {
            xmlList = new Hashtable();
        }

        public void load(string type, string filepath)
        {
            if (type.ToLower().Equals("module")) this.loadModule(filepath);
            if (type.ToLower().Equals("default")) this.loadDefault(filepath);
            if (type.ToLower().Equals("config")) this.loadConfig(filepath);
        }
        #region 根据TABLE的COLUMN重新生成模板结构
        public void reload(DataSet dsDetail)
        {
            DataSet[] dsDetails = new DataSet[] { dsDetail };
            reload(dsDetails);
        }
        public void reload(DataSet[] dsDetails)
        {
            for (int i = 0; i < oExcel.oSheets.Count; i++)
            {
                for (int j = 0; j < oExcel.oSheets[i].oDetails.Count; j++)
                {
                    if (oExcel.oSheets[i].oDetails[j].oRecords.Count == 0)
                    {
                        int iColumnGroupNameDeep = getColumnGroupNameDeep(dsDetails[i].Tables[j]);
                        for (int x = 0; x < dsDetails[i].Tables[j].Columns.Count; x++)
                        {
                            oRecord oR = new oRecord();
                            setRecordParaByColumn(oR, dsDetails[i].Tables[j].Columns[x]);
                            setRecordPos(oR, oExcel.oSheets[i].oDetails[j].keyPos, x, iColumnGroupNameDeep);
                            oExcel.oSheets[i].oDetails[j].oRecords.Add(oR);
                        }
                    }
                    else
                    {
                        //20170222 如果在XML中没有设置每一单元格的行和列，就用oDetail上的设置
                        for (int x = 0; x < oExcel.oSheets[i].oDetails[j].oRecords.Count; x++)
                        {
                            setRecordPos(oExcel.oSheets[i].oDetails[j].oRecords[x], oExcel.oSheets[i].oDetails[j].keyPos, x, 1);
                        }
                    }
                }
            }
        }

        private void setRecordParaByColumn(oRecord oR, DataColumn dC)
        {
            string columnName = dC.ColumnName;
            string[] x = columnName.Split('$');
            oR.key = x[0];
            oR.value = columnName;
            if (x.Length > 1 && !string.IsNullOrEmpty(x[1])) oR.groupName = x[1];
            if (x.Length > 2) oR.isRollup = "Y";
            if (x.Length > 3) oR.showSum = "N";
            oR.valueFontFormat = dC.DataType.ToString();

        }
        private void setRecordPos(oRecord oR, string strZeroPos, int iRelativePos, int iGroupNameDeep)
        {
            //20170222如果为空就设置一个默认值
            if (string.IsNullOrEmpty(strZeroPos))
                strZeroPos = "1,A";
            string[] x = strZeroPos.Split(',');
            string strPosY = Utility.GetExcelPositionRelative(x[1], iRelativePos);
            if (string.IsNullOrEmpty(oR.keyPos))
            {
                oR.keyPos = x[0] + "," + strPosY;
                oR.valuePos = Convert.ToString(Convert.ToInt32(x[0]) + iGroupNameDeep) + "," + strPosY;
            }
        }
        /*
        private int getColumnGroupNameDeep(DataTable dt)
        {
            int iReturn = 1;
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                string strGroupName = "";
                string[] x = dt.Columns[i].ColumnName.Split('$');
                if (x.Length > 1) strGroupName = x[1];
                iReturn = strGroupName.Split('#').Length + 1 > iReturn ? strGroupName.Split('#').Length + 1 : iReturn;
            }
            return iReturn;
        }
         * */

        private int getColumnGroupNameDeep(DataTable dt)
        {
            int iReturn = 1;
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                string strGroupName = "";
                string[] x = dt.Columns[i].ColumnName.Split('$');
                if (x.Length > 1)
                {
                    strGroupName = x[1];
                    iReturn = strGroupName.Split('#').Length + 1 > iReturn ? strGroupName.Split('#').Length + 1 : iReturn;
                }
            }
            return iReturn;
        }


        #endregion
        /// <summary>
        /// 生成临时的XML模板文件
        /// </summary>
        public void create()
        {
            XmlSerializer xs = new XmlSerializer(typeof(oExcel));
            Stream stream = new FileStream("d:\\a.xml", FileMode.Create, FileAccess.Write, FileShare.ReadWrite);
            xs.Serialize(stream, oExcel);
            //Console.WriteLine(oExcel.fileName);
            //Console.WriteLine(oExcel.oSheets[0].oDetails[0].oRecords[0].key);
            stream.Close();
        }
        /// <summary>
        /// 设置EXCEL模板的对象oExcel
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        private void loadModule(string filepath)
        {
            XmlSerializer xs = new XmlSerializer(typeof(oExcel));
            Stream stream = new FileStream(filepath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            oExcel = (oExcel)xs.Deserialize(stream);
            //Console.WriteLine(oExcel.fileName);
            //Console.WriteLine(oExcel.oSheets[0].oDetails[0].oRecords[0].key);
            stream.Close();
        }
        /// <summary>
        /// 设置默认值的模板
        /// </summary>
        /// <param name="file"></param>
        private void loadDefault(string filepath)
        {
            XmlSerializer xs = new XmlSerializer(typeof(dDefault));
            Stream stream = new FileStream(filepath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            dDefault = (dDefault)xs.Deserialize(stream);
            //Console.WriteLine(oExcel.fileName);
            //Console.WriteLine(oExcel.oSheets[0].oDetails[0].oRecords[0].key);
            stream.Close();

        }
        /// <summary>
        /// 读取配置文件
        /// </summary>
        /// <param name="file"></param>
        private void loadConfig(string filepath)
        {
            XmlSerializer xs = new XmlSerializer(typeof(config));
            Stream stream = new FileStream(filepath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            config = (config)xs.Deserialize(stream);
            //Console.WriteLine(config.files.Count);
            stream.Close();
        }

        public void loadImport(string filepath)
        {
            XmlSerializer xs = new XmlSerializer(typeof(iExcel));
            Stream stream = new FileStream(filepath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            iExcel = (iExcel)xs.Deserialize(stream);
            //Console.WriteLine(oExcel.fileName);
            //Console.WriteLine(oExcel.oSheets[0].oDetails[0].oRecords[0].key);
            stream.Close();
        }

    }
}
