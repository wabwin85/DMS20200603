using System;
using System.Collections.Generic;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Business.Excel.Objects
{
    public class oExcel
    {
        private string _fileName;
        private string _moduleName;
        private string _version;
        private string _refreshBeforeClose;
        private string _htmlSheet;
        public List<oSheet> oSheets;
        public oExcel() { }
        [XmlAttribute(AttributeName = "fileName")]
        public string fileName
        {
            get { return _fileName; }
            set { _fileName = value; }
        }
        [XmlAttribute(AttributeName = "moduleName")]
        public string moduleName
        {
            get { return _moduleName; }
            set { _moduleName = value; }
        }
        [XmlAttribute(AttributeName = "version")]
        public string version
        {
            get { return _version; }
            set { _version = value; }
        }
        [XmlAttribute(AttributeName = "htmlSheet")]
        public string htmlSheet
        {
            get { return _htmlSheet; }
            set { _htmlSheet = value; }
        }
        [XmlAttribute(AttributeName = "refreshBeforeClose")]
        public string refreshBeforeClose
        {
            get { return _refreshBeforeClose; }
            set { _refreshBeforeClose = value; }
        }

    }

    [Serializable]
    public class oSheet
    {
        private string _Name;
        private string _deleteBeforeClose;
        private string _setDetailProperty;
        public List<oMain> oMains;
        public List<oDetail> oDetails;
        public oSheet() { }
        [XmlAttribute(AttributeName = "Name")]
        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }
        [XmlAttribute(AttributeName = "deleteBeforeClose")]
        public string deleteBeforeClose
        {
            get { return _deleteBeforeClose; }
            set { _deleteBeforeClose = value; }
        }
        [XmlAttribute(AttributeName = "setDetailProperty")]
        public string setDetailProperty
        {
            get { return _setDetailProperty; }
            set { _setDetailProperty = value; }
        }
    }

    [Serializable]
    public class oMain
    {
        private string _keyFont;
        private string _keyFontSize;
        private string _keyFontColor;
        private string _keyBackGroudColor;
        private string _keyHorizontalAlignment;
        private string _keyBond;

        private string _valueFont;
        private string _valueFontSize;
        private string _valueFontColor;
        private string _valueHorizontalAlignment;
        private string _valueBond;
        public List<oItem> oItems;
        public oMain() { }
        [XmlAttribute(AttributeName = "keyFont")]
        public string keyFont
        {
            get { return _keyFont; }
            set { _keyFont = value; }
        }
        [XmlAttribute(AttributeName = "keyFontSize")]
        public string keyFontSize
        {
            get { return _keyFontSize; }
            set { _keyFontSize = value; }
        }
        [XmlAttribute(AttributeName = "keyBackGroudColor")]
        public string keyBackGroudColor
        {
            get { return _keyBackGroudColor; }
            set { _keyBackGroudColor = value; }
        }
        [XmlAttribute(AttributeName = "keyFontColor")]
        public string keyFontColor
        {
            get { return _keyFontColor; }
            set { _keyFontColor = value; }
        }
        [XmlAttribute(AttributeName = "keyHorizontalAlignment")]
        public string keyHorizontalAlignment
        {
            get { return _keyHorizontalAlignment; }
            set { _keyHorizontalAlignment = value; }
        }
        [XmlAttribute(AttributeName = "keyBond")]
        public string keyBond
        {
            get { return _keyBond; }
            set { _keyBond = value; }
        }

        [XmlAttribute(AttributeName = "valueFont")]
        public string valueFont
        {
            get { return _valueFont; }
            set { _valueFont = value; }
        }
        [XmlAttribute(AttributeName = "valueFontSize")]
        public string valueFontSize
        {
            get { return _valueFontSize; }
            set { _valueFontSize = value; }
        }
        [XmlAttribute(AttributeName = "valueFontColor")]
        public string valueFontColor
        {
            get { return _valueFontColor; }
            set { _valueFontColor = value; }
        }
        [XmlAttribute(AttributeName = "valueHorizontalAlignment")]
        public string valueHorizontalAlignment
        {
            get { return _valueHorizontalAlignment; }
            set { _valueHorizontalAlignment = value; }
        }
        [XmlAttribute(AttributeName = "valueBond")]
        public string valueBond
        {
            get { return _valueBond; }
            set { _valueBond = value; }
        }

    }

    [Serializable]
    public class oDetail
    {
        private string _keyFont;
        private string _keyFontSize;
        private string _keyFontColor;
        private string _keyBackGroudColor;
        private string _keyHorizontalAlignment;
        private string _keyBond;
        private string _keyPos;

        private string _valueFont;
        private string _valueFontSize;
        private string _valueFontColor;
        private string _valueHorizontalAlignment;
        private string _valueBond;
        private string _valuePos;

        private string _isRollup;
        private string _sumBackGroudColor;
        public List<oRecord> oRecords;

        public oDetail() { }
        [XmlAttribute(AttributeName = "keyFont")]
        public string keyFont
        {
            get { return _keyFont; }
            set { _keyFont = value; }
        }
        [XmlAttribute(AttributeName = "keyFontSize")]
        public string keyFontSize
        {
            get { return _keyFontSize; }
            set { _keyFontSize = value; }
        }
        [XmlAttribute(AttributeName = "keyBackGroudColor")]
        public string keyBackGroudColor
        {
            get { return _keyBackGroudColor; }
            set { _keyBackGroudColor = value; }
        }
        [XmlAttribute(AttributeName = "keyFontColor")]
        public string keyFontColor
        {
            get { return _keyFontColor; }
            set { _keyFontColor = value; }
        }
        [XmlAttribute(AttributeName = "keyHorizontalAlignment")]
        public string keyHorizontalAlignment
        {
            get { return _keyHorizontalAlignment; }
            set { _keyHorizontalAlignment = value; }
        }
        [XmlAttribute(AttributeName = "keyBond")]
        public string keyBond
        {
            get { return _keyBond; }
            set { _keyBond = value; }
        }
        [XmlAttribute(AttributeName = "keyPos")]
        public string keyPos
        {
            get { return _keyPos; }
            set { _keyPos = value; }
        }

        [XmlAttribute(AttributeName = "valueFont")]
        public string valueFont
        {
            get { return _valueFont; }
            set { _valueFont = value; }
        }
        [XmlAttribute(AttributeName = "valueFontSize")]
        public string valueFontSize
        {
            get { return _valueFontSize; }
            set { _valueFontSize = value; }
        }
        [XmlAttribute(AttributeName = "valueFontColor")]
        public string valueFontColor
        {
            get { return _valueFontColor; }
            set { _valueFontColor = value; }
        }
        [XmlAttribute(AttributeName = "valueHorizontalAlignment")]
        public string valueHorizontalAlignment
        {
            get { return _valueHorizontalAlignment; }
            set { _valueHorizontalAlignment = value; }
        }
        [XmlAttribute(AttributeName = "valueBond")]
        public string valueBond
        {
            get { return _valueBond; }
            set { _valueBond = value; }
        }
        [XmlAttribute(AttributeName = "valuePos")]
        public string valuePos
        {
            get { return _valuePos; }
            set { _valuePos = value; }
        }
        [XmlAttribute(AttributeName = "isRollup")]
        public string isRollup
        {
            get { return _isRollup; }
            set { _isRollup = value; }
        }
        [XmlAttribute(AttributeName = "sumBackGroudColor")]
        public string sumBackGroudColor
        {
            get { return _sumBackGroudColor; }
            set { _sumBackGroudColor = value; }
        }

    }

    [Serializable]
    public class oItem
    {
        private string _key;
        private string _value;
        private string _keyPos;
        private string _valuePos;

        private string _keyFont;
        private string _keyFontSize;
        private string _keyFontColor;
        private string _keyBackGroudColor;
        private string _keyHorizontalAlignment;
        private string _keyBond;

        private string _valueFont;
        private string _valueFontSize;
        private string _valueFontColor;
        private string _valueHorizontalAlignment;
        private string _valueBond;
        private string _valueFontFormat;

        public oItem() { }
        [XmlAttribute(AttributeName = "key")]
        public string key
        {
            get { return _key; }
            set { _key = value; }
        }
        [XmlAttribute(AttributeName = "value")]
        public string value
        {
            get { return _value; }
            set { _value = value; }
        }
        [XmlAttribute(AttributeName = "keyPos")]
        public string keyPos
        {
            get { return _keyPos; }
            set { _keyPos = value; }
        }
        [XmlAttribute(AttributeName = "valuePos")]
        public string valuePos
        {
            get { return _valuePos; }
            set { _valuePos = value; }
        }
        [XmlAttribute(AttributeName = "keyFont")]
        public string keyFont
        {
            get { return _keyFont; }
            set { _keyFont = value; }
        }
        [XmlAttribute(AttributeName = "keyFontSize")]
        public string keyFontSize
        {
            get { return _keyFontSize; }
            set { _keyFontSize = value; }
        }
        [XmlAttribute(AttributeName = "keyBackGroudColor")]
        public string keyBackGroudColor
        {
            get { return _keyBackGroudColor; }
            set { _keyBackGroudColor = value; }
        }
        [XmlAttribute(AttributeName = "keyFontColor")]
        public string keyFontColor
        {
            get { return _keyFontColor; }
            set { _keyFontColor = value; }
        }
        [XmlAttribute(AttributeName = "keyHorizontalAlignment")]
        public string keyHorizontalAlignment
        {
            get { return _keyHorizontalAlignment; }
            set { _keyHorizontalAlignment = value; }
        }
        [XmlAttribute(AttributeName = "keyBond")]
        public string keyBond
        {
            get { return _keyBond; }
            set { _keyBond = value; }
        }

        [XmlAttribute(AttributeName = "valueFont")]
        public string valueFont
        {
            get { return _valueFont; }
            set { _valueFont = value; }
        }
        [XmlAttribute(AttributeName = "valueFontSize")]
        public string valueFontSize
        {
            get { return _valueFontSize; }
            set { _valueFontSize = value; }
        }
        [XmlAttribute(AttributeName = "valueFontColor")]
        public string valueFontColor
        {
            get { return _valueFontColor; }
            set { _valueFontColor = value; }
        }
        [XmlAttribute(AttributeName = "valueHorizontalAlignment")]
        public string valueHorizontalAlignment
        {
            get { return _valueHorizontalAlignment; }
            set { _valueHorizontalAlignment = value; }
        }
        [XmlAttribute(AttributeName = "valueBond")]
        public string valueBond
        {
            get { return _valueBond; }
            set { _valueBond = value; }
        }
        [XmlAttribute(AttributeName = "valueFontFormat")]
        public string valueFontFormat
        {
            get { return _valueFontFormat; }
            set { _valueFontFormat = value; }
        }
    }

    [Serializable]
    public class oRecord
    {
        private string _key;
        private string _value;
        private string _keyPos;
        private string _valuePos;

        private string _keyFont;
        private string _keyFontSize;
        private string _keyFontColor;
        private string _keyBackGroudColor;
        private string _keyHorizontalAlignment;
        private string _keyBond;

        private string _valueFont;
        private string _valueFontSize;
        private string _valueFontColor;
        private string _valueHorizontalAlignment;
        private string _valueBond;
        private string _valueFontFormat;

        private string _groupName;
        private string _isRollup;
        private string _showSum;

        public oRecord() { }
        [XmlAttribute(AttributeName = "key")]
        public string key
        {
            get { return _key; }
            set { _key = value; }
        }
        [XmlAttribute(AttributeName = "value")]
        public string value
        {
            get { return _value; }
            set { _value = value; }
        }
        [XmlAttribute(AttributeName = "keyPos")]
        public string keyPos
        {
            get { return _keyPos; }
            set { _keyPos = value; }
        }
        [XmlAttribute(AttributeName = "valuePos")]
        public string valuePos
        {
            get { return _valuePos; }
            set { _valuePos = value; }
        }
        [XmlAttribute(AttributeName = "keyFont")]
        public string keyFont
        {
            get { return _keyFont; }
            set { _keyFont = value; }
        }
        [XmlAttribute(AttributeName = "keyFontSize")]
        public string keyFontSize
        {
            get { return _keyFontSize; }
            set { _keyFontSize = value; }
        }
        [XmlAttribute(AttributeName = "keyBackGroudColor")]
        public string keyBackGroudColor
        {
            get { return _keyBackGroudColor; }
            set { _keyBackGroudColor = value; }
        }
        [XmlAttribute(AttributeName = "keyFontColor")]
        public string keyFontColor
        {
            get { return _keyFontColor; }
            set { _keyFontColor = value; }
        }
        [XmlAttribute(AttributeName = "keyHorizontalAlignment")]
        public string keyHorizontalAlignment
        {
            get { return _keyHorizontalAlignment; }
            set { _keyHorizontalAlignment = value; }
        }
        [XmlAttribute(AttributeName = "keyBond")]
        public string keyBond
        {
            get { return _keyBond; }
            set { _keyBond = value; }
        }

        [XmlAttribute(AttributeName = "valueFont")]
        public string valueFont
        {
            get { return _valueFont; }
            set { _valueFont = value; }
        }
        [XmlAttribute(AttributeName = "valueFontSize")]
        public string valueFontSize
        {
            get { return _valueFontSize; }
            set { _valueFontSize = value; }
        }
        [XmlAttribute(AttributeName = "valueFontColor")]
        public string valueFontColor
        {
            get { return _valueFontColor; }
            set { _valueFontColor = value; }
        }
        [XmlAttribute(AttributeName = "valueHorizontalAlignment")]
        public string valueHorizontalAlignment
        {
            get { return _valueHorizontalAlignment; }
            set { _valueHorizontalAlignment = value; }
        }
        [XmlAttribute(AttributeName = "valueBond")]
        public string valueBond
        {
            get { return _valueBond; }
            set { _valueBond = value; }
        }
        [XmlAttribute(AttributeName = "valueFontFormat")]
        public string valueFontFormat
        {
            get { return _valueFontFormat; }
            set { _valueFontFormat = value; }
        }
        [XmlAttribute(AttributeName = "groupName")]
        public string groupName
        {
            get { return _groupName; }
            set { _groupName = value; }
        }
        [XmlAttribute(AttributeName = "isRollup")]
        public string isRollup
        {
            get { return _isRollup; }
            set { _isRollup = value; }
        }
        [XmlAttribute(AttributeName = "showSum")]
        public string showSum
        {
            get { return _showSum; }
            set { _showSum = value; }
        }
    } 
}
