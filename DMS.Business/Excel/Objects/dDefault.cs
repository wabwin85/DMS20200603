using System;
using System.Collections.Generic;
using System.Text;
using System.Xml.Serialization;

namespace DMS.Business.Excel.Objects
{
    public class dDefault
    {
        public dMain dMain;
        public dDetail dDetail;
        public dDefault() { }
    }


    public class dMain
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

        public dMain() { }

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
        [XmlAttribute(AttributeName = "keyFontColor")]
        public string keyFontColor
        {
            get { return _keyFontColor; }
            set { _keyFontColor = value; }
        }
        [XmlAttribute(AttributeName = "keyBackGroudColor")]
        public string keyBackGroudColor
        {
            get { return _keyBackGroudColor; }
            set { _keyBackGroudColor = value; }
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

    public class dDetail
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

        public dDetail() { }
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
        [XmlAttribute(AttributeName = "keyFontColor")]
        public string keyFontColor
        {
            get { return _keyFontColor; }
            set { _keyFontColor = value; }
        }
        [XmlAttribute(AttributeName = "keyBackGroudColor")]
        public string keyBackGroudColor
        {
            get { return _keyBackGroudColor; }
            set { _keyBackGroudColor = value; }
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
}
