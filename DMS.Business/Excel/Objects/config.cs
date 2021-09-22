using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.Serialization;

namespace DMS.Business.Excel.Objects
{
    public class config
    {
        private string _version;
        private string _eachrow;
        public List<file> files;
        public config() { }
        [XmlAttribute(AttributeName = "Version")]
        public string Version
        {
            get { return _version; }
            set { _version = value; }
        }
        [XmlAttribute(AttributeName = "EachRow")]
        public string EachRow
        {
            get { return _eachrow; }
            set { _eachrow = value; }
        }
    }

    public class file
    {
        private string _name;
        private string _value;
        public file() { }
        [XmlAttribute(AttributeName = "Name")]
        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }
        [XmlAttribute(AttributeName = "Value")]
        public string Value
        {
            get { return _value; }
            set { _value = value; }
        }
    }
}
