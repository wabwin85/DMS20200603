using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Xml.Schema;
using System.Xml;

namespace DMS.Model.DataInterface.eWorkflow
{
    [Serializable]
    [XmlRoot("Data")]
    public class BaseRequestData
    {
        [XmlElement("FlowId")]
        public string FlowId { get; set; }

        [XmlElement("IgnoreAlarm")]
        public string IgnoreAlarm { get; set; }

        [XmlElement("Initiator")]
        public string Initiator { get; set; }

        [XmlElement("ApproveSelect")]
        public string ApproveSelect { get; set; }

        [XmlElement("Principal")]
        public string Principal { get; set; }

        [XmlArray("Tables"), XmlArrayItem("Table")]
        public List<BaseRequestTable> Tables { get; set; }
    }

    [Serializable]
    public class BaseRequestTable : IXmlSerializable
    {
        public string Name { get; set; }

        //[XmlArrayItem(typeof(HeaderRow)), XmlArrayItem(typeof(DetailRow))]
        //[XmlElement("R1", typeof(HeaderRow)), XmlElement("R2", typeof(DetailRow))]
        public List<BaseRequestTableRow> Rows { get; set; }

        #region IXmlSerializable 成员

        public XmlSchema GetSchema()
        {
            return null;
        }

        public void ReadXml(XmlReader reader)
        {
            //
        }

        public void WriteXml(XmlWriter writer)
        {
            writer.WriteAttributeString("Name", this.Name);
            foreach (var row in Rows)
            {
                writer.WriteStartElement("R");
                writer.WriteAttributeString("Index", row.Index);

                ((IXmlSerializable)row).WriteXml(writer);

                writer.WriteEndElement();
            }
        }

        #endregion
    }

    public abstract class BaseRequestTableRow
    {
        public string Index { get; set; }

        public void WriteCDATA(XmlWriter writer, string name, string text)
        {
            writer.WriteStartElement(name);
            writer.WriteCData(text);
            writer.WriteEndElement();
        }
    }

}
