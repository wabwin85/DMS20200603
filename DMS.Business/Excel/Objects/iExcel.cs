using System;
using System.Collections.Generic;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Business.Excel.Objects
{
    public class iExcel
    {
        private string _Desc;
        private string _Procedure;
        public List<iSheet> iSheets;
        public iExcel() { }
        [XmlAttribute(AttributeName = "Desc")]
        public string Desc
        {
            get { return _Desc; }
            set { _Desc = value; }
        }
        [XmlAttribute(AttributeName = "Procedure")]
        public string Procedure
        {
            get { return _Procedure; }
            set { _Procedure = value; }
        }
    }

    [Serializable]
    public class iSheet
    {
        private string _TableName;
        private string _DataStartRowNumber; 
        public List<iRecord> iRecords;
        public iSheet() { }
        [XmlAttribute(AttributeName = "TableName")]
        public string TableName
        {
            get { return _TableName; }
            set { _TableName = value; }
        }
        [XmlAttribute(AttributeName = "DataStartRowNumber")]
        public string DataStartRowNumber
        {
            get { return _DataStartRowNumber; }
            set { _DataStartRowNumber = value; }
        }
    }

     
    [Serializable]
    public class iRecord
    {
        private string _Position;
        private string _ColumnName;
        private string _DescName;
        private string _DataType;
        private string _IsRequired; 
        private string _ErrorMsgColumn;
        private string _CheckType;
        private string _CheckValue;

        public iRecord() { }
        [XmlAttribute(AttributeName = "Position")]
        public string Position
        {
            get { return _Position; }
            set { _Position = value; }
        }
        [XmlAttribute(AttributeName = "ColumnName")]
        public string ColumnName
        {
            get { return _ColumnName; }
            set { _ColumnName = value; }
        }
        [XmlAttribute(AttributeName = "DescName")]
        public string DescName
        {
            get { return _DescName; }
            set { _DescName = value; }
        }
        [XmlAttribute(AttributeName = "DataType")]
        public string DataType
        {
            get { return _DataType; }
            set { _DataType = value; }
        }
        [XmlAttribute(AttributeName = "IsRequired")]
        public string IsRequired
        {
            get { return _IsRequired; }
            set { _IsRequired = value; }
        }
        [XmlAttribute(AttributeName = "ErrorMsgColumn")]
        public string ErrorMsgColumn
        {
            get { return _ErrorMsgColumn; }
            set { _ErrorMsgColumn = value; }
        }
        [XmlAttribute(AttributeName = "CheckType")]
        public string CheckType
        {
            get { return _CheckType; }
            set { _CheckType = value; }
        }
        [XmlAttribute(AttributeName = "CheckValue")]
        public string CheckValue
        {
            get { return _CheckValue; }
            set { _CheckValue = value; }
        }
    }
}
