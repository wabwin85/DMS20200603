using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Collections;

namespace DMS.Business.Excel.Objects
{
    public class cellProperty
    {
        private string _font;                   //字体
        private string _fontsize;                  //字体大小
        private string _fontcolor;              //字体颜色
        private string _backgroudcolor;         //背景颜色
        private string _horizontalalignment;    //横向位置
        private string _verticalalignment;      //垂直位置
        private string _fontbond;               //加粗
        private string _fontformat;             //格式
        private string __horizontalalignmentByfontFormat;
        private property property;

        public cellProperty(string strPropertyFilePath)
        {
            property = new property();
            XmlDocument doc = new XmlDocument();
            doc.Load(strPropertyFilePath);

            Hashtable htColors = new Hashtable();
            XmlNodeList nodeListColor = doc.GetElementsByTagName("color");
            foreach (XmlNode nodeColor in nodeListColor)
            {
                htColors.Add(nodeColor.Attributes["Name"].Value, nodeColor.Attributes["Value"].Value);
            }
            property.Colors = htColors;
        }

        #region set/get
        public string Font
        {
            get { return _font; }
            set { _font = value; }
        }

        public string FontSize
        {
            get { return _fontsize; }
            set { _fontsize = value; }
        }

        public string FontColor
        {
            get { return _fontcolor; }
            set { _fontcolor = value; }
        }

        public string BackgroudColor
        {
            get { return _backgroudcolor; }
            set { _backgroudcolor = value; }
        }

        public string HorizontalAlignment
        {
            get { return _horizontalalignment; }
            set { _horizontalalignment = value; }
        }

        public string VerticalAlignment
        {
            get { return _verticalalignment; }
            set { _verticalalignment = value; }
        }

        public string FontBond
        {
            get { return _fontbond; }
            set { _fontbond = value; }
        }

        public string FontFormat
        {
            get { return _fontformat; }
            set { _fontformat = value; }
        }

        #endregion



        public string Excel_Font()
        {
            return _font;
        }
        public int Excel_FontSize()
        {
            if (!string.IsNullOrEmpty(_fontsize))
                return Convert.ToInt32(_fontsize);
            else
                return 0;
        }

        public int Excel_FontColor()
        {
            if (!string.IsNullOrEmpty(_fontcolor))
                return Convert.ToInt32(property.Colors[_fontcolor]);
            else
                return 0;
        }

        public int Excel_BackgroudColor()
        {
            if (!string.IsNullOrEmpty(_backgroudcolor))
                return Convert.ToInt32(property.Colors[_backgroudcolor]);
            else
                return 0;
        }

        public Microsoft.Office.Interop.Excel.Constants Excel_HorizontalAlignment()
        {
            if (string.IsNullOrEmpty(_horizontalalignment))
            {
                switch (getFontFormat())
                {
                    case "test": return Microsoft.Office.Interop.Excel.Constants.xlLeft; break;
                    case "date": return Microsoft.Office.Interop.Excel.Constants.xlCenter; break;
                    case "number": return Microsoft.Office.Interop.Excel.Constants.xlRight; break;
                    case "percent": return Microsoft.Office.Interop.Excel.Constants.xlRight; break;
                }
            }
            else
            {
                switch (_horizontalalignment.ToLower())
                {
                    case "right": return Microsoft.Office.Interop.Excel.Constants.xlRight; break;
                    case "center": return Microsoft.Office.Interop.Excel.Constants.xlCenter; break;
                    case "left": return Microsoft.Office.Interop.Excel.Constants.xlLeft; break;
                }

            }
            return Microsoft.Office.Interop.Excel.Constants.xlCenter;
        }

        public bool Excel_FontBond()
        {
            if (string.IsNullOrEmpty(_fontbond)) return false;
            switch (_fontbond.ToLower())
            {
                case "true":
                case "yes": return true; break;
                case "false":
                case "no": return false; break;
            }
            return false;
        }

        private string getFontFormat()
        {
            string strReturnFormat = "text";
            if (string.IsNullOrEmpty(_fontformat)) return strReturnFormat;

            if (_fontformat.ToLower().IndexOf("text") >= 0 ||
                _fontformat.ToLower().IndexOf("string") >= 0 ||
                _fontformat.ToLower().IndexOf("char") >= 0
                )
                strReturnFormat = "text";

            if (_fontformat.ToLower().IndexOf("date") >= 0 ||
                _fontformat.ToLower().IndexOf("time") >= 0
                )
                strReturnFormat = "date";

            if (_fontformat.ToLower().IndexOf("number") >= 0 ||
                _fontformat.ToLower().IndexOf("decimal") >= 0 ||
                _fontformat.ToLower().IndexOf("int") >= 0 ||
                _fontformat.ToLower().IndexOf("double") >= 0
                )
                strReturnFormat = "number";

            if (_fontformat.ToLower().IndexOf("percent") >= 0
                )
                strReturnFormat = "percent";

            return strReturnFormat;
        }

        public string Excel_Format()
        {
            string strReturnFormat = "@";

            switch (getFontFormat())
            {
                case "text": strReturnFormat = "@"; break;
                case "date": strReturnFormat = "yyyy-mm-dd"; break;
                case "number": strReturnFormat = "#,##0.00"; break;
                case "percent": strReturnFormat = "#0.00%"; break;
            }
            return strReturnFormat;
        }
    }
}
